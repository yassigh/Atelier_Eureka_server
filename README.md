<<<<<<< HEAD
# TP Architecture Web Distribuée : Observabilité avec Spring Boot Actuator & Services Polyglottes

**Année Universitaire :** 2026-2027  
**Module :** Architecture Web Distribuée (ESPRIT)  


---

## 👥 Membres de l'équipe

- **Noms & Prénoms :** Yassine Gharbi, Bachir Habboubi, Chadha Dalhoumi, Dhia Trabelssi  
- **Classe / Groupe :** 4DAS_I11  






### 3. Tableau de bord Eureka avec les instances enregistrées
Capture du dashboard Eureka (`http://localhost:8761`) montrant les services polyglottes avec statut **UP** et liens directs vers `/info` :
![Eureka Dashboard Actuator](documentation/eureka-dashboard-actuator.png)

---

##  Réponses aux Questions du TP (Partie 4 - Métriques)

> **Question du TP :**  
> *Combien de requêtes HTTP Candidat a-t-il traitées (mesure COUNT) ? Quelle est la durée de la requête la plus lente (mesure MAX) ? Que donne `/actuator/metrics/http.server.requests?tag=status:200` ?*

### Réponses détaillées :
1. **Mesure COUNT (Nombre de requêtes traitées) :**
   - L'endpoint `http://localhost:8081/actuator/metrics/http.server.requests` contient une section `measurements` dans laquelle `COUNT` indique le **nombre total cumulé de requêtes HTTP** reçues et traitées par le microservice Candidat depuis son démarrage.
2. **Mesure MAX (Durée de la requête la plus lente) :**
   - La métrique `MAX` indique, en secondes, le **temps d'exécution maximal** observé pour la requête la plus lente.
   - `TOTAL_TIME` représente le temps cumulé de traitement de l'ensemble des requêtes.
3. **Effet du tag `?tag=status:200` :**
   - L'URL filtrée `http://localhost:8081/actuator/metrics/http.server.requests?tag=status:200` isole uniquement les requêtes qui se sont achevées avec succès (**HTTP 200 OK**).
   - Les valeurs de `COUNT` et `MAX` retournées ne comptabilisent alors que ces requêtes réussies, en éliminant les erreurs (4xx ou 5xx).

---

##  Procédure de Test de Panne MySQL (Partie 2 - Étape 2)

Grâce à `eureka.client.healthcheck.enabled=true` et au starter JDBC MySQL configuré dans `job-service` :
1. **État normal :**
   - MySQL actif sous XAMPP : `http://localhost:8082/actuator/health` renvoie `"status": "UP"` avec `"db": {"status": "UP", "details": {"database": "MySQL"}}`.
   - Eureka affiche `JOB` en statut **UP (1)**.
2. **Arrêt MySQL :**
   - Cliquez sur **Stop** MySQL dans XAMPP.
   - Rappelez `http://localhost:8082/actuator/health` : la réponse renvoie HTTP 503 avec `"status": "DOWN"` et l'erreur `CannotGetJdbcConnectionException`.
   - Actualisez le dashboard Eureka (`http://localhost:8761`) : le statut de `JOB` passe automatiquement à **DOWN (1)** en rouge.
3. **Reprise de service :**
   - Relancez MySQL dans XAMPP : le composant `db` redevient `UP` et Eureka rétablit `JOB` à **UP (1)**.

---

## 🔗 Endpoints de Référence

| Service | Port | Endpoint Santé | Endpoint Info |
| :--- | :---: | :--- | :--- |
| **Eureka Server** | `8761` | [Dashboard](http://localhost:8761) | [Registre JSON](http://localhost:8761/eureka/apps) |
| **Candidat** | `8081` | [Actuator Health](http://localhost:8081/actuator/health) | [Actuator Info](http://localhost:8081/actuator/info) |
| **Job** | `8082` | [Actuator Health](http://localhost:8082/actuator/health) | [Actuator Info](http://localhost:8082/actuator/info) |
| **Meeting (Instance 1)** | `8083` | [Health](http://localhost:8083/health) | [Info](http://localhost:8083/info) |
| **Meeting (Instance 2)** | `8086` | [Health](http://localhost:8086/health) | [Info](http://localhost:8086/info) |
| **Notification** | `8084` | [Health](http://localhost:8084/health) | [Info](http://localhost:8084/info) |
=======
# Atelier_Eureka_server
>>>>>>> 01de20081559d9b0e68118f2ab63adef0f0dd21c
