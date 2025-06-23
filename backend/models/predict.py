from pydantic import BaseModel

class OverdoseInput(BaseModel):
    idade: int
    peso_kg: float
    glicemia: float
    sintomas: list
    uso_suspeito: str
    dose_g: float