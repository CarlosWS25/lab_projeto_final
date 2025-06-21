from fastapi import APIRouter, HTTPException
from auth.jwt_handler import create_access_token
from models.user import UserLogin, RecoveryPasswordRequest
from database.crud import get_user_by_username, recuperar_password
from utils.hash import verify_password

router = APIRouter()

@router.post("/login")
async def login(user: UserLogin):
    db_user = get_user_by_username(user.username)

    if db_user is None:
        raise HTTPException(status_code=404, detail="Utilizador não encontrado")

    db_is_admin = db_user[0]  # is_admin
    db_id = db_user[1]        # id
    db_username = db_user[2]  # username
    db_hashed_pw = db_user[3] # password

    if not verify_password(user.password, db_hashed_pw):
        raise HTTPException(status_code=401, detail="Password incorreta")

    token = create_access_token({
        "user_id": db_id,
        "username": db_username,
        "is_admin": db_is_admin
    })
    return {"access_token": token}


@router.post("/recover-password")
def recover_password(data: RecoveryPasswordRequest):
    sucesso = recuperar_password(data.username, data.recovery_key, data.new_password)
    if not sucesso:
        raise HTTPException(status_code=403, detail="Username ou chave de recuperação inválida.")
    return {"message": "Password atualizada com sucesso."}