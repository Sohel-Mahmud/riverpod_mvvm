from fastapi import HTTPException, Header
import uuid
import bcrypt
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter, Depends
from database import get_db
from sqlalchemy.orm import Session
from pydantic_schemas.user_login import UserLogin
import jwt
from middleware.auth_middelware import auth_middleware
from sqlalchemy.orm import joinedload

router = APIRouter()

@router.post("/signup", status_code=201)
def signup_user(user: UserCreate, db: Session=Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()
    
    if user_db:
        raise HTTPException(400, "User already exists")
    
    hased_pw = bcrypt.hashpw(user.password.encode('utf-8'), bcrypt.gensalt())
    user_db = User(id=str(uuid.uuid4()), name=user.name, email=user.email, password=hased_pw)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db

@router.post('/login')
def login_user(user: UserLogin, db: Session=Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(400, "User not found")
    
    if not bcrypt.checkpw(user.password.encode('utf-8'), user_db.password):
        raise HTTPException(400, "Invalid password")

    token = jwt.encode({'id': user_db.id}, 'password_key')

    return {'token': token, 'user': user_db}

@router.get('/')
def current_user_data(db: Session=Depends(get_db), 
                      user_dict = Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).options(
        joinedload(User.favorites)
    ).first()

    if not user:
        raise HTTPException(404, 'User not found!')
    
    return user