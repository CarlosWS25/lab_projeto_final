
from pydantic import BaseModel, Field
from typing import Optional

class UserLogin(BaseModel):
    username: str
    password: str

class UserCreate(BaseModel):
    is_admin: bool = False
    username: str
    password: str
    ano_nascimento: int
    altura_cm: int
    peso: float
    genero: str = Field(..., pattern="^(M|F)$")

class UserUpdate(BaseModel):
    username: Optional[str]
    ano_nascimento: Optional[int]
    altura_cm: Optional[int]
    peso: Optional[float]
    genero: Optional[str]
    