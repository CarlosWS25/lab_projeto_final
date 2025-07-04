from typing import Optional
from pydantic import BaseModel

class OverdoseFlexibleInput(BaseModel):
    idade: Optional[int]
    peso_kg: Optional[int]
    altura_cm: Optional[int]
    glicemia: Optional[float]
    genero: Optional[str]
    sintomas: Optional[str]
    uso_suspeito: Optional[str]
    dose_g: float
    doenca_pre_existente: Optional[str]
