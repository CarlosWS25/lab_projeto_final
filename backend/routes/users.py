
from fastapi import APIRouter, HTTPException, Depends, Request
from auth.auth_bearer import JWTBearer, get_user_id_from_token, is_admin_from_token
from database.crud import insert_user, get_all_users, get_user_by_id, delete_user, update_user
from models.user import UserCreate
from models.user import UserUpdate

router = APIRouter()

@router.post("/")
def create_user(user: UserCreate):
    # Ignora user.is_admin — força sempre False
    insert_user(
        False,  
        user.username,
        user.password,
        user.ano_nascimento, 
        user.altura_cm,
        user.peso,
        user.genero,
        user.doencas
    )
    return {"msg": "Utilizador criado com sucesso"}


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
        genero=user_update.genero,
        doencas=user_update.doencas,
    )
    if success:
        return {"msg": "Dados atualizados com sucesso"}
    raise HTTPException(status_code=400, detail="Falha ao atualizar dados")