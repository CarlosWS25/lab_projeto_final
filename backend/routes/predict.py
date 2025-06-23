from fastapi import APIRouter, Request, HTTPException
import openai
import json
from database.crud import get_user_by_id
from datetime import datetime
from models.predict import OverdoseInput
from auth.auth_bearer import get_user_id_from_token
from dotenv import load_dotenv
import os

load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")
router = APIRouter()

@router.post("/predict_overdose")
async def predict_overdose(data: OverdoseInput, request: Request):
    user_id = await get_user_id_from_token(request)
    user_data = get_user_by_id(user_id)

    if not user_data:
        raise HTTPException(status_code=404, detail="Utilizador não encontrado.")

    _, _, _, ano_nasc, altura_cm, peso, genero = user_data
    idade = datetime.now().year - ano_nasc

    sintomas = ", ".join(data.sintomas) if isinstance(data.sintomas, list) else data.sintomas
    uso = ", ".join(data.uso_suspeito) if isinstance(data.uso_suspeito, list) else data.uso_suspeito

    prompt = f"""
És um assistente clínico especializado em overdoses. Com base nos dados:
- Idade: {idade} anos
- Peso: {peso} kg
- Altura: {altura_cm} cm
- Glicemia: {data.glicemia} mg/dL
- Género: {genero}
- Sintomas: {sintomas}
- Uso suspeito: {uso}
- Quantidade em gramas: {data.dose_g}

Avalia o risco de overdose numa escala de 0 a 10 e responde apenas no formato:
{{
  "risk_score": [valor entre 0 e 10],
  "substância_antagonista": "nome da substância, caso necessário",
  "dica": "Como agir e o que fazer com a vitima"
}}
"""

    try:
        resposta = openai.ChatCompletion.create(
            model="gpt-4.1-mini",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.4,
            max_tokens=50,
        )

        texto = resposta.choices[0].message["content"]
        result = json.loads(texto)

        if "risk_score" not in result or not (0 <= result["risk_score"] <= 10):
            raise ValueError("Resposta inválida do modelo.")

        return result

    except json.JSONDecodeError:
        raise HTTPException(status_code=500, detail="Erro ao interpretar resposta do modelo.")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
