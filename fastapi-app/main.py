from fastapi import FastAPI
from app.routes import user,product

app = FastAPI()

app.include_router(user.router)
app.include_router(product.router)
