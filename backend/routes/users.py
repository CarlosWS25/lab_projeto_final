
from fastapi import APIRouter, HTTPException, Depends, Request
from auth.auth_bearer import JWTBearer, get_user_id_from_token, is_admin_from_token
from database.crud import insert_user, get_all_users, get_user_by_id
from models.user import UserCreate

router = APIRouter()

@router.post("/")
def create_user(user: UserCreate):
    # Ignora user.is_admin — força sempre False
    insert_user(
        False,  
        user.username,
        user.password,
        user.altura_cm,
        user.peso,
        user.genero,
        user.outras_doencas,
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

