
from fastapi import Request, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from auth.jwt_handler import decode_access_token

class JWTBearer(HTTPBearer):
    def __init__(self, auto_error: bool = True):
        super(JWTBearer, self).__init__(auto_error=auto_error)

    async def __call__(self, request: Request):
        credentials: HTTPAuthorizationCredentials = await super(JWTBearer, self).__call__(request)
        if credentials:
            if not credentials.scheme == "Bearer":
                raise HTTPException(status_code=403, detail="Formato de autenticação inválido")
            if not self.verify_jwt(credentials.credentials):
                raise HTTPException(status_code=403, detail="Token inválido ou expirado")
            return credentials.credentials
        else:
            raise HTTPException(status_code=403, detail="Credenciais não encontradas")

    def verify_jwt(self, token: str) -> bool:
        payload = decode_access_token(token)
        return payload is not None

async def get_user_id_from_token(request: Request) -> int:
    auth_header = request.headers.get("Authorization")
    if not auth_header:
        raise HTTPException(status_code=401, detail="Token não fornecido")
    token = auth_header.split(" ")[1]
    payload = decode_access_token(token)
    if not payload or "user_id" not in payload:
        raise HTTPException(status_code=403, detail="Token inválido")
    return payload["user_id"]

async def is_admin_from_token(request: Request) -> bool:
    auth_header = request.headers.get("Authorization")
    if not auth_header:
        raise HTTPException(status_code=401, detail="Token não fornecido")
    token = auth_header.split(" ")[1]
    payload = decode_access_token(token)
    if not payload or "is_admin" not in payload:
        raise HTTPException(status_code=403, detail="Token inválido")
    return payload["is_admin"]
