from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


DATABASE_URL = "postgresql://postgres:123456@localhost:1500/fluttermusicapp"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# session created then yielded then closed
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()