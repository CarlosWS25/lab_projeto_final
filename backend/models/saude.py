from pydantic import BaseModel, Field
from typing import List, Optional

class SaudeBase(BaseModel):
    doencas: Optional[List[str]] = []
    sintomas: Optional[List[str]] = []
    droga_usada: Optional[str] = None
    quantidade: Optional[float] = None
    peso: float
    altura_cm: int
    idade_atual: int
    genero: str = Field(..., pattern="^(M|F)$")

class SaudeCreate(SaudeBase):
    id: int 

class SaudeUpdate(BaseModel):
    doencas: Optional[List[str]]
    sintomas: Optional[List[str]]
    droga_usada: Optional[str]
    quantidade: Optional[float]
