# AquaTrack 後端 API 快速啟動指南

## 推薦方案：FastAPI + Python

由於你已經有 Python 環境（用於文件更新腳本），建議使用 **FastAPI** 作為後端框架。

### 為什麼選擇 FastAPI？

1. ✅ **快速開發**：自動生成 API 文檔（Swagger UI）
2. ✅ **高效能**：基於 Starlette，效能接近 Go
3. ✅ **類型安全**：完整的 Type Hints 支援
4. ✅ **自動驗證**：使用 Pydantic 自動驗證請求
5. ✅ **異步支援**：原生支援 async/await
6. ✅ **易於擴展**：方便加入 AI/ML 功能

## 快速開始（10 分鐘內啟動）

### 1. 建立專案結構

```bash
# 在專案根目錄外建立後端資料夾
cd ..
mkdir aquatrack-api
cd aquatrack-api

# 建立虛擬環境
python -m venv venv

# 啟動虛擬環境
# Windows PowerShell:
.\venv\Scripts\Activate.ps1
# Windows CMD:
venv\Scripts\activate.bat
# Linux/Mac:
source venv/bin/activate
```

### 2. 安裝依賴

```bash
# 核心套件
pip install fastapi uvicorn sqlalchemy psycopg2-binary pydantic-settings

# 認證相關
pip install python-jose[cryptography] passlib[bcrypt] python-multipart

# CORS 支援（讓 Flutter Web 可以連線）
pip install python-cors

# 開發工具
pip install python-dotenv
```

### 3. 建立專案檔案

#### 專案結構
```
aquatrack-api/
├── venv/
├── .env
├── .gitignore
├── requirements.txt
├── main.py
├── database.py
├── models.py
├── schemas.py
├── auth.py
└── routers/
    ├── __init__.py
    ├── auth.py
    ├── competitions.py
    └── teams.py
```

### 4. 核心程式碼

#### `.env` - 環境變數
```env
# 資料庫連線
DATABASE_URL=postgresql://aquatrack_user:your_password_here@localhost:5432/aquatrack

# JWT 設定
SECRET_KEY=your-secret-key-change-this-in-production-min-32-chars
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# CORS 設定（開發環境）
CORS_ORIGINS=http://localhost:3000,http://localhost:5000,http://127.0.0.1:3000
```

#### `requirements.txt`
```txt
fastapi==0.104.1
uvicorn[standard]==0.24.0
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
pydantic==2.5.0
pydantic-settings==2.1.0
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
python-dotenv==1.0.0
```

#### `database.py` - 資料庫連線
```python
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str
    secret_key: str
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    class Config:
        env_file = ".env"

settings = Settings()

engine = create_engine(settings.database_url)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

#### `models.py` - SQLAlchemy Models（節選）
```python
from sqlalchemy import Column, BigInteger, String, Text, TIMESTAMP, Integer, Boolean, Date
from database import Base
from datetime import datetime

class User(Base):
    __tablename__ = "users"
    
    user_id = Column(BigInteger, primary_key=True, index=True)
    email = Column(Text, unique=True, nullable=False)
    password_hash = Column(Text, nullable=False)
    name = Column(Text)
    role = Column(Text, nullable=False, default="swimmer")
    created_at = Column(TIMESTAMP, default=datetime.utcnow)
    updated_at = Column(TIMESTAMP, default=datetime.utcnow, onupdate=datetime.utcnow)

class CompetitionResult(Base):
    __tablename__ = "competitionresults"
    
    result_id = Column(BigInteger, primary_key=True, index=True)
    user_id = Column(BigInteger, nullable=False)
    stroke = Column(Text, nullable=False)
    distance = Column(Integer, nullable=False)
    pool_length = Column(Text, nullable=False)
    time_ms = Column(BigInteger, nullable=False)
    meet_name = Column(Text)
    date = Column(Date)
    created_at = Column(TIMESTAMP, default=datetime.utcnow)

class Team(Base):
    __tablename__ = "teams"
    
    team_id = Column(BigInteger, primary_key=True, index=True)
    name = Column(Text, nullable=False)
    description = Column(Text)
    created_by_user_id = Column(BigInteger, nullable=False)
    created_at = Column(TIMESTAMP, default=datetime.utcnow)
```

#### `schemas.py` - Pydantic Schemas（節選）
```python
from pydantic import BaseModel, EmailStr
from datetime import datetime, date
from typing import Optional, List

class UserBase(BaseModel):
    email: EmailStr
    name: Optional[str] = None

class UserCreate(UserBase):
    password: str

class UserResponse(UserBase):
    user_id: int
    role: str
    created_at: datetime
    
    class Config:
        from_attributes = True

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user: UserResponse

class CompetitionResultCreate(BaseModel):
    stroke: str
    distance: int
    pool_length: str
    time_ms: int
    meet_name: Optional[str] = None
    date: Optional[date] = None

class CompetitionResultResponse(BaseModel):
    result_id: int
    user_id: int
    stroke: str
    distance: int
    pool_length: str
    time_ms: int
    meet_name: Optional[str]
    date: Optional[date]
    created_at: datetime
    
    class Config:
        from_attributes = True

class PersonalBestResponse(BaseModel):
    stroke: str
    distance: int
    pool_length: str
    time_ms: int
    date: date
```

#### `auth.py` - JWT 認證工具
```python
from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from database import get_db, settings
from models import User

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire, "type": "access"})
    return jwt.encode(to_encode, settings.secret_key, algorithm=settings.algorithm)

def create_refresh_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(days=7)
    to_encode.update({"exp": expire, "type": "refresh"})
    return jwt.encode(to_encode, settings.secret_key, algorithm=settings.algorithm)

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        token = credentials.credentials
        payload = jwt.decode(token, settings.secret_key, algorithms=[settings.algorithm])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    user = db.query(User).filter(User.email == email).first()
    if user is None:
        raise credentials_exception
    return user
```

#### `routers/auth.py` - 認證路由
```python
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from database import get_db
from models import User
from schemas import UserCreate, LoginRequest, TokenResponse, UserResponse
from auth import get_password_hash, verify_password, create_access_token, create_refresh_token, get_current_user
from datetime import timedelta
from database import settings

router = APIRouter(prefix="/auth", tags=["Authentication"])

@router.post("/signup", response_model=TokenResponse)
async def signup(user_data: UserCreate, db: Session = Depends(get_db)):
    # 檢查 email 是否已存在
    existing_user = db.query(User).filter(User.email == user_data.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # 建立新用戶
    hashed_password = get_password_hash(user_data.password)
    new_user = User(
        email=user_data.email,
        password_hash=hashed_password,
        name=user_data.name,
        role="swimmer"
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    # 生成 tokens
    access_token = create_access_token(
        data={"sub": new_user.email},
        expires_delta=timedelta(minutes=settings.access_token_expire_minutes)
    )
    refresh_token = create_refresh_token(data={"sub": new_user.email})
    
    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        user=UserResponse.from_orm(new_user)
    )

@router.post("/login", response_model=TokenResponse)
async def login(login_data: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == login_data.email).first()
    if not user or not verify_password(login_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )
    
    access_token = create_access_token(
        data={"sub": user.email},
        expires_delta=timedelta(minutes=settings.access_token_expire_minutes)
    )
    refresh_token = create_refresh_token(data={"sub": user.email})
    
    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        user=UserResponse.from_orm(user)
    )

@router.get("/me", response_model=UserResponse)
async def get_me(current_user: User = Depends(get_current_user)):
    return UserResponse.from_orm(current_user)
```

#### `routers/competitions.py` - 成績路由
```python
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional
from database import get_db
from models import User, CompetitionResult, OfficialRecord
from schemas import CompetitionResultCreate, CompetitionResultResponse, PersonalBestResponse
from auth import get_current_user

router = APIRouter(prefix="/competitions", tags=["Competitions"])

@router.get("/results", response_model=List[CompetitionResultResponse])
async def get_results(
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    results = db.query(CompetitionResult)\
        .filter(CompetitionResult.user_id == current_user.user_id)\
        .order_by(CompetitionResult.date.desc(), CompetitionResult.created_at.desc())\
        .limit(limit)\
        .offset(offset)\
        .all()
    return results

@router.post("/results", response_model=CompetitionResultResponse, status_code=201)
async def create_result(
    result_data: CompetitionResultCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    new_result = CompetitionResult(
        user_id=current_user.user_id,
        **result_data.dict()
    )
    db.add(new_result)
    db.commit()
    db.refresh(new_result)
    return new_result

@router.get("/pb", response_model=List[PersonalBestResponse])
async def get_personal_bests(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # 查詢每個泳姿/距離/池長組合的最佳成績
    subquery = db.query(
        CompetitionResult.stroke,
        CompetitionResult.distance,
        CompetitionResult.pool_length,
        func.min(CompetitionResult.time_ms).label('best_time')
    ).filter(
        CompetitionResult.user_id == current_user.user_id
    ).group_by(
        CompetitionResult.stroke,
        CompetitionResult.distance,
        CompetitionResult.pool_length
    ).subquery()
    
    # 取得完整記錄（包含日期）
    pbs = db.query(CompetitionResult).join(
        subquery,
        (CompetitionResult.stroke == subquery.c.stroke) &
        (CompetitionResult.distance == subquery.c.distance) &
        (CompetitionResult.pool_length == subquery.c.pool_length) &
        (CompetitionResult.time_ms == subquery.c.best_time) &
        (CompetitionResult.user_id == current_user.user_id)
    ).all()
    
    return [
        PersonalBestResponse(
            stroke=pb.stroke,
            distance=pb.distance,
            pool_length=pb.pool_length,
            time_ms=pb.time_ms,
            date=pb.date
        ) for pb in pbs
    ]
```

#### `main.py` - 主程式
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import auth, competitions
from database import settings

app = FastAPI(
    title="AquaTrack API",
    description="游泳成績追蹤系統 API",
    version="1.6.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS 設定
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins.split(","),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 註冊路由
app.include_router(auth.router)
app.include_router(competitions.router)

@app.get("/")
async def root():
    return {
        "message": "AquaTrack API v1.6",
        "docs": "/docs",
        "health": "ok"
    }

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
```

### 5. 啟動後端 API

```bash
# 確認虛擬環境已啟動
# 應該看到 (venv) 前綴

# 啟動開發伺服器
python main.py

# 或使用 uvicorn 直接啟動
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### 6. 測試 API

訪問以下網址：

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

### 7. 更新 Flutter 設定

修改 Flutter 專案中的 API 端點：

```dart
// lib/core/providers/dio_provider.dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8000',  // 更新為你的 API 地址
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
  
  // ... rest of the code
});
```

### 8. 測試登入流程

1. 在 Flutter app 中切換到正式模式（已完成）
2. 使用測試帳號登入：
   - Email: `test@example.com`
   - Password: `password123`
3. 查看個人成績和 PB

## 進階設定

### 部署到生產環境

#### 使用 Docker

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://aquatrack_user:password@db:5432/aquatrack
      - SECRET_KEY=${SECRET_KEY}
    depends_on:
      - db
  
  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=aquatrack
      - POSTGRES_USER=aquatrack_user
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./docs/aquatrack_1_6_db.sql:/docker-entrypoint-initdb.d/1-schema.sql
      - ./docs/seed_data.sql:/docker-entrypoint-initdb.d/2-data.sql

volumes:
  postgres_data:
```

啟動：
```bash
docker-compose up -d
```

#### 部署到 GCP Cloud Run

```bash
# 建立 Container
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/aquatrack-api

# 部署到 Cloud Run
gcloud run deploy aquatrack-api \
  --image gcr.io/YOUR_PROJECT_ID/aquatrack-api \
  --platform managed \
  --region asia-east1 \
  --allow-unauthenticated \
  --set-env-vars DATABASE_URL="postgresql://..." \
  --set-env-vars SECRET_KEY="..."
```

### 監控和日誌

```python
# 加入日誌中介層
import logging
from fastapi import Request
import time

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    logger.info(
        f"{request.method} {request.url.path} "
        f"completed in {process_time:.2f}s "
        f"with status {response.status_code}"
    )
    return response
```

## 下一步

1. ✅ 完成基礎 API（認證 + 成績）
2. ⏭️ 實作隊伍管理 API
3. ⏭️ 實作課表和目標 API
4. ⏭️ 加入單元測試
5. ⏭️ 加入 API 限流（rate limiting）
6. ⏭️ 加入快取（Redis）
7. ⏭️ 部署到雲端

## 疑難排解

### PostgreSQL 連線失敗
```bash
# 檢查資料庫是否啟動
pg_isready -h localhost -p 5432

# 測試連線
psql -U aquatrack_user -d aquatrack -c "SELECT 1;"
```

### CORS 錯誤
確認 `.env` 中的 `CORS_ORIGINS` 包含你的 Flutter app 執行的網址。

### 認證失敗
檢查：
1. `.env` 中的 `SECRET_KEY` 是否設定
2. 資料庫中是否有測試用戶
3. 密碼 hash 是否正確（使用 `seed_data.sql` 初始化）

## 相關資源

- [FastAPI 官方文檔](https://fastapi.tiangolo.com/)
- [SQLAlchemy 教學](https://docs.sqlalchemy.org/)
- [Pydantic 文檔](https://docs.pydantic.dev/)
- [JWT 認證指南](https://jwt.io/)
