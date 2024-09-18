from fastapi import HTTPException, Header
import jwt

def auth_middleware(x_auth_token = Header()):
    try:
        if not x_auth_token:
            raise HTTPException(401, "No auth token, access denied")
        verifid_token = jwt.decode(x_auth_token, 'password_key', 'HS256')

        if not verifid_token:
            raise HTTPException(401, "Token verfication failed")
    
        uid = verifid_token.get('id')
        return {'uid': uid, 'token': x_auth_token}
    except jwt.PyJWTError:
        raise HTTPException(401, "Token is not valid, auth failed")