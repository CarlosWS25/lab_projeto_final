from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import JSONResponse
from auth.auth_bearer import get_user_id_from_token
from models.saude import SaudeCreate, SaudeUpdate
from database.crud import insert_info_saude, update_info_saude, wipe_table_saude

router = APIRouter()

@router.post("/saude")
async def criar_info_saude(saude: SaudeCreate):
    insert_info_saude(saude)
    return {"message": "Dados de saúde inseridos com sucesso."}

@router.put("/saude/{id}")
async def atualizar_info_saude_route(id: int, dados: SaudeUpdate):
    update_info_saude(id, dados)
    return {"message": f"Dados de saúde do utilizador {id} atualizados com sucesso."}

@router.delete("/wipe-saude")
async def wipe_saude_route(request: Request):
    await get_user_id_from_token(request)
    wipe_table_saude()
    return {"message": "Todos os dados de saúde foram apagados."}
