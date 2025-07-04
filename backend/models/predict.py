from typing import Optional
from pydantic import BaseModel

class OverdoseFlexibleInput(BaseModel):
    idade: Optional[int] = None
    peso_kg: Optional[int] = None
    altura_cm: Optional[int] = None
    glicemia: Optional[float] = None
    genero: Optional[str] = None
    sintomas: Optional[str] = None
    uso_suspeito: Optional[str] = None
    dose_g: float
    doenca_pre_existente: Optional[str] = None
