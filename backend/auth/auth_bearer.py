from fastapi import Request, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from .jwt_handler import decode_token

class JWTBearer(HTTPBearer):
    async def __call__(self, request: Request):
        credentials: HTTPAuthorizationCredentials = await super().__call__(request)
        if credentials:
            token = credentials.credentials
            if decode_token(token) is None:
                raise HTTPException(status_code=403, detail="Token inválido ou expirado.")
            return credentials.credentials
        else:
            raise HTTPException(status_code=403, detail="Credenciais não fornecidas.")
