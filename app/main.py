from fastapi import FastAPI, Request
from app.rag_engine import get_rag_response
from fastapi.middleware.cors import CORSMiddleware
from fastapi import Request, HTTPException

app = FastAPI()

# Enable CORS for frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/generate-insight")
async def generate_insight(request: Request):
    try:
        body = await request.json()
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid or empty JSON body")
