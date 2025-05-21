from fastapi import APIRouter, HTTPException
from database.crud import insert_user, get_all_users, get_user_by_id, update_user, delete_user

router = APIRouter()

@router.post("/")
def create_user(name: str, email: str, password: str):
    insert_user(name, email, password)
    return {"msg": "Utilizador criado com sucesso"}

@router.get("/")
def list_users():
    users = get_all_users()
    return {"utilizadores": users}

@router.get("/{user_id}")
def get_user(user_id: int):
    user = get_user_by_id(user_id)
    if user:
        return {"utilizador": user}
    raise HTTPException(status_code=404, detail="Utilizador não encontrado")

@router.put("/{user_id}")
def update_user_data(user_id: int, name: str = None, email: str = None, password: str = None):
    success = update_user(user_id, name, email, password)
    if success:
        return {"msg": "Utilizador atualizado"}
    raise HTTPException(status_code=404, detail="Utilizador não encontrado ou nenhum campo enviado")

@router.delete("/{user_id}")
def delete_user_data(user_id: int):
    success = delete_user(user_id)
    if success:
        return {"msg": "Utilizador removido"}
    raise HTTPException(status_code=404, detail="Utilizador não encontrado")
