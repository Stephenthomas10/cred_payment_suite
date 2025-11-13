# CRED Payment Suite – Refunds Dashboard (Flutter + FastAPI)

A mini refunds orchestration dashboard inspired by CRED’s payments UX.

## Features

- Flutter web app with CRED-style theming
- Real backend API (FastAPI) with:
  - Refund lifecycle: `initiated → gateway_credited → bank_credited → posted`
  - Idempotent create + deterministic IDs
  - Escalation endpoint returning dispute payload
- Analytics banner (count + total ₹ in transit + stage distribution)
- Stage filter (All / initiated / gateway / bank / posted)
- Add Refund dialog (creates live refund rows)
- Dockerized backend (`Dockerfile` + `.dockerignore`)

## Tech Stack

- Flutter (Material 3, web)
- FastAPI + Uvicorn
- Docker

## Run locally

### Backend

```bash
cd backend
python -m venv venv
venv\Scripts\activate       # Windows
pip install -r app/requirements.txt
uvicorn app.main:app --reload --port 8000
# or: docker build -t cred-refunds-api . && docker run -p 8000:8000 cred-refunds-api

Frontend (Flutter)
flutter run -d chrome


App expects backend at http://127.0.0.1:8000.

API

GET /refunds

POST /refunds/create

POST /refunds/{id}/advance

POST /refunds/{id}/escalate

POST /refunds/seed (dev only)