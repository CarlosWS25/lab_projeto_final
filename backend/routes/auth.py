from fastapi import APIRouter, HTTPException
from auth.jwt_handler import create_access_token
from models.user import UserLogin
from database.crud import get_user_by_username
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
