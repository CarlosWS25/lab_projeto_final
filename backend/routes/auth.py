from fastapi import APIRouter, HTTPException
from auth.jwt_handler import create_access_token
from models.user import UserLogin

router = APIRouter()

# Exemplo simples de utilizador (em produção usa uma base de dados real)
fake_user = {"username": "joao", "password": "segura"}

@router.post("/login")
async def login(user: UserLogin):
    if user.username == fake_user["username"] and user.password == fake_user["password"]:
        token = create_access_token({"username": user.username})
        return {"access_token": token}
    raise HTTPException(status_code=401, detail="Credenciais incorretas.")
