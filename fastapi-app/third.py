
from fastapi import FastAPI
from fastapi import Depends


app = FastAPI()

#depends function

#1
def get_current_user():
    return {"name": "rahul"}
    

@app.get("/user")
def get_user(user = Depends(get_current_user)):
    return user
    
 #2
def check_login():
    return True

@app.get("/home")
def home(user = Depends(check_login)):
    return {"logged_in": user}

#3
def get_user():
    return {"name": "amit"}
    
@app.get("/profile")
def profile(user = Depends(get_user)):
    return user

@app.get("/settings")
def settings(user = Depends(get_user)):
    return user
    

#4
def verify_token():
    return {"status": "valid"}
    
@app.get("/dashboard")
def dashboard(token = Depends(verify_token)):
    return token


#5
@app.get("/orders")
def order(user = Depends(get_current_user)):
    return user

@app.get("/cart")
def cart(user = Depends(get_current_user)):
    return user














