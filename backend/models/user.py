
from pydantic import BaseModel, Field

class UserLogin(BaseModel):
    username: str
    password: str

class UserCreate(BaseModel):
    is_admin: bool = False
    username: str
    password: str
    altura_cm: int
    ano_nascimento: int
    peso: float
    genero: str = Field(..., pattern="^(M|F)$")
    doencas: str = "nenhuma"
    