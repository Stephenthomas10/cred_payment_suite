from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Literal, Dict
from uuid import uuid4, uuid5, NAMESPACE_DNS  # uuid4 for new, uuid5 for seeded

app = FastAPI()

# ---------- CORS (dev-wide allow; tighten for prod) ----------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------- Models ----------
RefundStage = Literal["initiated", "gateway_credited", "bank_credited", "posted"]

class Refund(BaseModel):
    id: str
    txn_id: str
    merchant: str
    amount: float
    stage: RefundStage
    history: List[RefundStage]

class RefundCreate(BaseModel):
    txn_id: str
    merchant: str
    amount: float
    stage: RefundStage = "initiated"

class Bill(BaseModel):
    id: str
    title: str
    amount: float
    status: str

# ---------- Data Stores ----------
bills: List[Bill] = []

# Refunds stored by ID for O(1) lookup and stable identity across seeds
refunds_by_id: Dict[str, Refund] = {}

# ---------- Helpers ----------
def _history_for(stage: RefundStage) -> List[RefundStage]:
    if stage == "initiated":
        return ["initiated"]
    if stage == "gateway_credited":
        return ["initiated", "gateway_credited"]
    if stage == "bank_credited":
        return ["initiated", "gateway_credited", "bank_credited"]
    # posted
    return ["initiated", "gateway_credited", "bank_credited", "posted"]

def upsert_refund(txn_id: str, merchant: str, amount: float, stage: RefundStage) -> Refund:
    """Deterministic/stable ID derived from txn_id (good for dev seeding)."""
    rid = str(uuid5(NAMESPACE_DNS, txn_id))
    r = Refund(
        id=rid,
        txn_id=txn_id,
        merchant=merchant,
        amount=amount,
        stage=stage,
        history=_history_for(stage),
    )
    refunds_by_id[rid] = r
    return r

# ---------- Health ----------
@app.get("/health")
def health():
    return {"ok": True}

# ---------- Bills (demo from earlier) ----------
@app.get("/bills")
def get_bills():
    return bills

@app.post("/bills")
def add_bill(bill: Bill):
    bills.append(bill)
    return {"msg": "bill added", "count": len(bills)}

# ---------- Refunds ----------
@app.get("/refunds")
def list_refunds():
    return list(refunds_by_id.values())

@app.post("/refunds/seed")
def seed_refunds():
    # Upsert keeps IDs stable across multiple seeding calls
    upsert_refund("TXN-1001", "Amazon",     1299.0, "gateway_credited")
    upsert_refund("TXN-1002", "Swiggy",      389.0, "initiated")
    upsert_refund("TXN-1003", "BookMyShow",  499.0, "bank_credited")
    return {"msg": "seeded", "count": len(refunds_by_id)}

@app.post("/refunds")
def create_refund(data: RefundCreate):
    """Create a new refund coming from the UI."""
    rid = str(uuid4())
    r = Refund(
        id=rid,
        txn_id=data.txn_id,
        merchant=data.merchant,
        amount=data.amount,
        stage=data.stage,
        history=_history_for(data.stage),
    )
    refunds_by_id[rid] = r
    return r

ORDER = ["initiated", "gateway_credited", "bank_credited", "posted"]

@app.post("/refunds/{rid}/advance")
def advance_refund(rid: str):
    r = refunds_by_id.get(rid)
    if not r:
        raise HTTPException(status_code=404, detail="refund not found")
    idx = ORDER.index(r.stage)
    if idx < len(ORDER) - 1:
        r.stage = ORDER[idx + 1]
        if r.stage not in r.history:
            r.history.append(r.stage)
    # Return updated resource (clean API contract)
    return r

@app.post("/refunds/{rid}/escalate")
def escalate_refund(rid: str):
    r = refunds_by_id.get(rid)
    if not r:
        raise HTTPException(status_code=404, detail="refund not found")
    return {
        "msg": "escalation created",
        "rid": r.id,
        "txn_id": r.txn_id,
        "merchant": r.merchant,
        "amount": r.amount,
        "current_stage": r.stage,
        "dispute_note": "Attach proof of debit and merchant message. (PDF gen TODO)",
    }
