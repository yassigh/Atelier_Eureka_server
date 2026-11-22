<<<<<<< HEAD
# TP Architecture Web Distribuée : Observabilité avec Spring Boot Actuator & Services Polyglottes

**Année Universitaire :** 2026-2027  
**Module :** Architecture Web Distribuée (ESPRIT)  
**Enseignante :** Mme Badia Bouhdid  

---

## 👥 Membres de l'équipe

- **Noms & Prénoms :** Yassine Gharbi, Bachir Habboubi, Chadha Dalhoumi, Dhia Trabelssi  
- **Classe / Groupe :** 4DAS_I11  

---

## 📊 Bilan du TP : Ce qui est bien terminé vs Ce qui reste à faire

### 🟢 Ce qui est BIEN TERMINÉ (Code & Configuration validés)

| Partie du TP | Tâche | Statut | Détails |
| :--- | :--- | :---: | :--- |
| **Partie 1 (Étape 1)** | Dépendance Actuator | ✅ Terminé | `spring-boot-starter-actuator` ajouté dans `candidat-service` et `job-service`. |
| **Partie 1 (Étape 2)** | Endpoints exposés | ✅ Terminé | `health,info,metrics,loggers` exposés, `show-details=always`, `eureka.client.healthcheck.enabled=true`. |
| **Partie 1 (Étape 2)** | Métadonnées info.* | ✅ Terminé | Infos complètes (nom, version, description, membres d'équipe) configurées dans les `.properties`. |
| **Partie 1 (Bonus)** | HealthIndicator personnalisé | ✅ Terminé | `CustomCandidatHealthIndicator.java` et `CustomJobHealthIndicator.java` implémentés. |
| **Partie 2 (Étape 1)** | Santé MySQL pour Job | ✅ Terminé | `spring-boot-starter-jdbc` et `mysql-connector-j` configurés dans `job-service`. |
| **Partie 4 (Étape 4)** | Réponses analyse métriques | ✅ Terminé | Réponses aux questions sur `COUNT`, `MAX` et `?tag=status:200` rédigées ci-dessous. |
| **Partie 5 (Tâche 1)** | Meeting Node.js : Route `/health` | ✅ Terminé | Renvoie `{"status": "UP"}` avec code 200. |
| **Partie 5 (Tâche 1)** | Meeting Node.js : Route `/info` | ✅ Terminé | Lit `name`, `version`, `description` dynamiquement depuis `package.json`. |
| **Partie 5 (Tâche 1)** | Meeting Node.js : Eureka URLs | ✅ Terminé | `statusPageUrl` (`/info`) et `healthCheckUrl` (`/health`) déclarés dans `eureka-js-client`. |
| **Partie 5 (Tâche 2)** | Notification Python : `/health` | ✅ Terminé | Route GET `/health` implémentée sous FastAPI. |
| **Partie 5 (Tâche 2)** | Notification Python : `/info` | ✅ Terminé | Route GET `/info` implémentée avec infos service et équipe. |
| **Partie 5 (Tâche 2)** | Notification Python : Eureka URLs | ✅ Terminé | `status_page_url` et `health_check_url` déclarés dans `py-eureka-client`. |

---

### 🟡 Ce qu'il reste à finaliser / manipuler

1. **Lancement simultané de Candidat et Job avec Meeting et Notification :**
   - Sur votre dernière capture, Meeting et Notification sont bien enregistrés dans Eureka.
   - Il vous reste à lancer en même temps `candidat-service` et `job-service` (`java -jar ...` ou via votre IDE) pour voir les 4 services enregistrés simultanément dans Eureka.
2. **Partie 2 (Étape 2) - Test de panne MySQL (Manipulation à chaud) :**
   - Arrêter MySQL dans XAMPP/WAMP.
   - Constater que `http://localhost:8082/actuator/health` passe à `DOWN`.
   - Observer dans Eureka que `JOB` passe à `DOWN (1)`.
   - Redémarrer MySQL et vérifier le retour à `UP (1)`.
3. **Pousser sur GitHub :**
   - Faire le `git commit` et `git push` sur votre dépôt GitHub d'équipe.

---

## 📸 Captures d'écran des Résultats

### 1. Microservice Meeting (Node.js) - Endpoint `/info`
Capture montrant la route `/info` renvoyant le nom et la version lus depuis `package.json` :
![Meeting Info](documentation/meeting-info.png)

---

### 2. Microservice Notification (Python / FastAPI) - Endpoint `/info`
Capture montrant la route `/info` avec les métadonnées et les noms des membres de l'équipe :
![Notification Info](documentation/notification-info.png)

---

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
