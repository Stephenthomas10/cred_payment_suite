# 🧾 CRED Payment Suite — Refund Tracking System  
A full-stack **Flutter + FastAPI** application that simulates a real-world **refunds management workflow**, inspired by CRED’s Payments Suite.

This project demonstrates:
- Modern Flutter UI with filters, analytics, and workflow transitions  
- REST API built with FastAPI  
- Deterministic refund IDs (UUIDv5)  
- Clean architecture + responsive UI  
- Dockerized backend for production-ready deployment  

---

## 🚀 Features

### 🔵 **Frontend (Flutter Web)**
- Add new refunds manually  
- View refund timeline (Initiated → Gateway → Bank → Posted)  
- Advance a refund state  
- Escalate a refund (simulated PDF attachment flow)  
- Filtering by stage  
- Summary analytics banner  
- Modern UI with CRED-like aesthetic  
- API integration + automatic reload  
- Fully responsive layout  

### 🔴 **Backend (FastAPI)**
- Full REST API  
- Deterministic refund ID generation  
- Advance refund workflow  
- Escalation endpoint  
- Seed sample refunds  
- CORS enabled for Flutter Web  
- Docker support  

---

# 🏗️ **System Architecture**

        ┌────────────────────────┐
        │      Flutter Web       │
        │  UI: Refunds, Filters  │
        │  HTTP Calls via Dio/   │
        │  http package          │
        └───────────▲────────────┘
                    │
          (JSON REST API)
                    │
        ┌───────────┴────────────┐
        │       FastAPI API       │
        │  /refunds, /advance,    │
        │  /escalate, /seed       │
        ├─────────────────────────┤
        │ In-Memory Store (MVP)   │
        │ UUIDv5 deterministic IDs│
        └───────────▲────────────┘
                    │
        ┌───────────┴────────────┐
        │       Docker Image      │
        │  uvicorn + FastAPI      │
        └─────────────────────────┘

Screenshots:
![App Screenshot](../assets/readme/cred.png)


# 🧭 **API Documentation**

Base URL (local):
http://127.0.0.1:8000

csharp
Copy code

### **GET /refunds**
Returns list of refunds.

### **POST /refunds/seed**
Seeds sample refunds.

### **POST /refunds**
Creates a new refund:
```json
{
  "txn_id": "TXN-5555",
  "merchant": "Amazon",
  "amount": 1299.0
}
POST /refunds/{id}/advance
Moves refund to next stage.

POST /refunds/{id}/escalate
Creates escalation record and returns:

json
Copy code
{
  "msg": "escalation created",
  "dispute_note": "Attach proof…"
}
🛠️ Tech Stack
Frontend
Flutter 3.x

Material 3

REST API integration

ValueKeys + rebuild-safe UI

Backend
Python 3.11

FastAPI

Uvicorn

pydantic

CORS middleware

DevOps
Docker

GitHub

Hot Reload & Hot Restart

⚙️ Local Setup Instructions
1️⃣ Clone the project
sh
Copy code
git clone https://github.com/<your-user>/cred_payment_suite.git
cd cred_payment_suite
2️⃣ Run the Backend (FastAPI)
Install dependencies
sh
Copy code
cd backend
pip install -r requirements.txt
Start the server
sh
Copy code
uvicorn main:app --reload --port 8000
Swagger UI:

arduino
Copy code
http://127.0.0.1:8000/docs
3️⃣ Run Flutter Frontend
sh
Copy code
cd flutter_app/cred_payment_suite
flutter pub get
flutter run -d chrome
🐳 Run Backend via Docker
Build image:
sh
Copy code
docker build -t cred-refunds-api .
Run:
sh
Copy code
docker run -p 8000:8000 cred-refunds-api
Backend now available at:

cpp
Copy code
http://127.0.0.1:8000
🔮 Future Enhancements
Feature	Status
Persist refunds in SQLite/Postgres	⏳ Planned
JWT-based authentication	⏳ Planned
Merchant logos in UI	⏳ Planned
PDF generation for escalations	⏳ Planned
Real CRED-style UI animations	⏳ Planned
Dark mode	⏳ Planned
Push notifications	⏳ Planned

🏁 Why This Project Stands Out
Clean architecture

Solid API design

Real-world payment workflow logic

Professional UI polish

Docker + testing ready

Perfect for interviews or product demos

🙌 Author
Stephen Thomas
Flutter Dev • Backend Engineer • Full-Stack Builder
Karunya Institute of Technology & Sciences

👍 If this project impresses you, consider giving it a ⭐ on GitHub!