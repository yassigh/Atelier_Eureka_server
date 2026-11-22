import os
import sys
from contextlib import asynccontextmanager
from fastapi import FastAPI
import py_eureka_client.eureka_client as eureka_client
import uvicorn

# Lecture du port depuis la variable d'environnement PORT (par défaut 8084)
PORT = int(os.environ.get("PORT", 8084))
EUREKA_SERVER = os.environ.get("EUREKA_SERVER", "http://localhost:8761/eureka")

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Démarrage : Enregistrement auprès d'Eureka
    print(f"[NOTIFICATION] Démarrage sur le port {PORT}...")
    try:
        await eureka_client.init_async(
            eureka_server=EUREKA_SERVER,
            app_name="NOTIFICATION",
            instance_id=f"127.0.0.1:notification:{PORT}",
            instance_port=PORT,
            instance_host="127.0.0.1",
            status_page_url=f"http://127.0.0.1:{PORT}/info",
            health_check_url=f"http://127.0.0.1:{PORT}/health"
        )
        print(f"[NOTIFICATION] Enregistré avec succès auprès d'Eureka ({EUREKA_SERVER})")
    except Exception as e:
        print(f"[NOTIFICATION] Erreur lors de l'enregistrement Eureka: {e}")
    
    yield
    
    # Arrêt : Déconnexion d'Eureka
    print("[NOTIFICATION] Arrêt du microservice...")
    try:
        await eureka_client.stop_async()
        print("[NOTIFICATION] Désenregistré d'Eureka avec succès.")
    except Exception as e:
        print(f"[NOTIFICATION] Erreur lors du désenregistrement: {e}")

app = FastAPI(title="Notification Service", lifespan=lifespan)

# Route de sante GET /health (Tâche 2)
@app.get("/health")
def health():
    return {"status": "UP"}

# Route d'information GET /info (Tâche 2)
@app.get("/info")
def info():
    return {
        "app": {
            "name": "notification-service",
            "version": "1.0.0",
            "description": "Microservice de notification (Python / FastAPI)",
            "team": "yassine gharbi, bachir habboubi, chadha dalhoumi, dhia trabelssi"
        }
    }

# Endpoint Hello de l'atelier precedent
@app.get("/api/notifications/hello")
async def hello():
    return {
        "message": "Hello from Notification service!",
        "service": "NOTIFICATION",
        "port": PORT
    }

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=PORT, reload=False)
