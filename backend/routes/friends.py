from fastapi import APIRouter, HTTPException, Depends, Request
from typing import List
from auth.auth_bearer import JWTBearer, get_user_id_from_token
from database.crud import insert_friend, delete_friend, get_friends_for_user
from models.friend import FriendCreate, FriendOut


router = APIRouter()

@router.get("/amigos", response_model=List[FriendOut], dependencies=[Depends(JWTBearer())])
async def listar_amigos(request: Request):
    user_id = await get_user_id_from_token(request)
    amigos = get_friends_for_user(user_id)
    return amigos

@router.post("/amigos", dependencies=[Depends(JWTBearer())])
async def adicionar_amigo(request: Request, friend: FriendCreate):
    user_id = await get_user_id_from_token(request)

    success = insert_friend(
        user_id=user_id,
        nome_do_amigo=friend.nome_do_amigo,
        numero_amigo=friend.numero_amigo
    )

    if success:
        return {"msg": "Amigo adicionado com sucesso"}
    raise HTTPException(status_code=400, detail="Erro ao adicionar amigo")

@router.delete("/amigos", dependencies=[Depends(JWTBearer())])
async def remover_amigo(request: Request, friend: FriendCreate):
    user_id = await get_user_id_from_token(request)

    success = delete_friend(
        user_id=user_id,
        nome_do_amigo=friend.nome_do_amigo,
        numero_amigo=friend.numero_amigo
    )

    if success:
        return {"msg": "Amigo removido com sucesso"}
    raise HTTPException(status_code=404, detail="Amigo não encontrado")