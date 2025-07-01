from fastapi import APIRouter, HTTPException, Depends, Request
from auth.auth_bearer import JWTBearer, get_user_id_from_token, is_admin_from_token
from database.crud import insert_user, get_all_users, get_user_by_id, delete_user, update_user, get_user_by_username, insert_friend
from models.user import UserCreate, UserUpdate
from models.user import RecoveryPasswordRequest
from models.friend import FriendCreate

router = APIRouter()

@router.post("/")
def create_user(user: UserCreate):
    if get_user_by_username(user.username):
        raise HTTPException(status_code=409, detail="Username já existe.")

    recovery_key = insert_user(
        False,
        user.username,
        user.password,
        user.ano_nascimento, 
        user.altura_cm,
        user.peso,
        user.genero
    )

    if not recovery_key:
        raise HTTPException(status_code=500, detail="Erro ao criar utilizador.")

    return {
        "message": "Utilizador criado com sucesso.",
        "recovery_key": recovery_key 
    }


@router.get("/", dependencies=[Depends(JWTBearer())])
async def list_users(request: Request):
    if not await is_admin_from_token(request):
        raise HTTPException(status_code=403, detail="Acesso apenas para administradores")
    users = get_all_users()
    return {"utilizadores": users}

@router.get("/me", dependencies=[Depends(JWTBearer())])
async def get_me(request: Request):
    user_id = await get_user_id_from_token(request)
    user = get_user_by_id(user_id)
    if user:
        return {"utilizador": user}
    raise HTTPException(status_code=404, detail="Utilizador não encontrado")

@router.delete("/{user_id}", dependencies=[Depends(JWTBearer())])
async def delete_user_data(user_id: int, request: Request):
    # Só admins podem apagar qualquer utilizador
    if not await is_admin_from_token(request):
        raise HTTPException(status_code=403, detail="Acesso apenas para administradores")
    success = delete_user(user_id)
    if success:
        return {"msg": "Utilizador removido com sucesso"}
    raise HTTPException(status_code=404, detail="Utilizador não encontrado")

@router.put("/me", dependencies=[Depends(JWTBearer())])
async def update_me(request: Request, user_update: UserUpdate):
    user_id = await get_user_id_from_token(request)
    success = update_user(
        user_id,
        username=user_update.username,
        ano_nascimento=user_update.ano_nascimento,
        altura_cm=user_update.altura_cm,
        peso=user_update.peso,
        genero=user_update.genero
    )
    if success:
        return {"msg": "Dados atualizados com sucesso"}
    raise HTTPException(status_code=400, detail="Falha ao atualizar dados")


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
