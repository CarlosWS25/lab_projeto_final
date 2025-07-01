from pydantic import BaseModel

class OverdoseInput(BaseModel):
    glicemia: float
    sintomas: list
    uso_suspeito: str
    dose_g: float