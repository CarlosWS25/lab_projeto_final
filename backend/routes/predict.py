from fastapi import APIRouter, HTTPException, Request
from datetime import datetime
from models.predict import OverdoseFlexibleInput
from database.crud import get_user_by_id
from auth.auth_bearer import get_user_id_from_token
import openai
import json

router = APIRouter()

@router.post("/predict_overdose")
async def predict_overdose(data: OverdoseFlexibleInput, request: Request):
    user_id = await get_user_id_from_token(request)

    # MODO AUTOMÁTICO: usar DB se os campos críticos estiverem ausentes
    if not all([data.idade, data.peso_kg, data.altura_cm, data.genero, data.doenca_pre_existente]):
        user_data = get_user_by_id(user_id)
        if not user_data:
            raise HTTPException(status_code=404, detail="Utilizador não encontrado.")

        _, _, _, ano_nasc, altura_cm, peso, genero, doenca_pre_existente = user_data
        idade = datetime.now().year - ano_nasc
    else:
        idade = data.idade
        altura_cm = data.altura_cm
        peso = data.peso_kg
        genero = data.genero
        doenca_pre_existente = data.doenca_pre_existente

    # Campos sempre obtidos do input
    sintomas = ", ".join(data.sintomas) if isinstance(data.sintomas, list) else data.sintomas or "não especificado"
    uso = ", ".join(data.uso_suspeito) if isinstance(data.uso_suspeito, list) else data.uso_suspeito or "não especificado"
    glicemia = f"{data.glicemia} mg/dL" if data.glicemia is not None else "não fornecida"

    prompt = f"""
És um assistente clínico especializado em overdoses. Com base nos dados:
- Idade: {idade} anos
- Peso: {peso} kg
- Altura: {altura_cm} cm
- Glicemia: {glicemia}
- Género: {genero}
- Sintomas: {sintomas}
- Uso suspeito: {uso}
- Quantidade em gramas: {data.dose_g}
- Doença pré-existente: {doenca_pre_existente}

Avalia o risco de overdose numa escala de 0 a 10 e responde apenas no formato:
{{
  "risk_score": [valor entre 0 e 10],
  "substância_antagonista": "nome da substância, caso necessário",
  "dica": "Como agir e o que fazer com a vítima"
}}
"""

    try:
        resposta = openai.ChatCompletion.create(
            model="gpt-4.1-mini",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.4,
            max_tokens=200,
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
