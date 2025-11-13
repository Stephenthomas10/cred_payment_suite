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

<img width="957" height="503" alt="image" src="https://github.com/user-attachments/assets/4fd5e290-a64a-4f2e-9a3c-a15bed2589ef" />


🛠️ Tech Stack
Frontend

Flutter 3.x

Material 3

REST API integration

ValueKeys for stable rebuilds

Backend

Python 3.11

FastAPI

Pydantic

Uvicorn

CORS Middleware

DevOps

Docker

GitHub

Hot Reload / Hot Restart

🏁 Why This Project Stands Out

Clean and modular code

Real payment workflow logic

Professional UI polish

Docker setup

Excellent for interviews or demos

🙌 Author

Stephen Thomas
Flutter Dev • Backend Engineer • Full-Stack Builder
Karunya Institute of Technology & Sciences

⭐ If this project impressed you, please star the repo!

