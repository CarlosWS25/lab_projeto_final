from pydantic import BaseModel, Field
from typing import Optional

class OverdoseInput(BaseModel):
    glicemia: Optional[float] = Field(default=None)
    sintomas: list
    uso_suspeito: str
    dose_g: float