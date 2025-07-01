from pydantic import BaseModel

class FriendCreate(BaseModel):
    nome_do_amigo: str
    numero_amigo: str
