# README - Commandes Docker pour les Microservices

Ce README détaille les commandes utilisées pour la création et l'exécution des conteneurs de microservices Spring Boot et Flask.

## Arborescence du Projet

```
58493/
├── service-java/
│   └── service-java-main/
│       ├── Dockerfile
│       ├── src/
│       ├── pom.xml
│       └── ...
├── service-python/
│   └── service-python-main/
│       ├── Dockerfile
│       ├── app.py
│       ├── requirements.txt
│       ├── test_app.py
│       └── ...
└── docker-compose.yml
```

## Commandes pour les Images Docker

### Service Spring Boot

```bash
# Se placer dans le répertoire du service java
cd service-java/service-java-main

# Construire l'image Docker
docker build -t service-java .
```

### Service Flask

```bash
# Se placer dans le répertoire du service python
cd service-python/service-python-main

# Construire l'image Docker
docker build -t service-python .
```

## Commandes pour l'Exécution des Conteneurs

### Exécution Individuelle des images


Service Spring Boot:
```bash
# Exécuter l'image Spring Boot
docker run -p 8080:8080 service-java
```

Service Flask:
```bash
# Exécuter l'image Flask
docker run -p 5000:5000 service-python
```



### Exécution avec Docker Compose

```bash
# Se placer à la racine du projet (où se trouve le docker-compose.yml)
cd 58493

# Démarrer les services définis dans le fichier docker-compose.yml
docker-compose up -d

# Lister les conteneurs en cours d'exécution
docker-compose ps

# Démarrer un service spécifique
docker-compose start "name-service"

# Arrêter un service spécifique
docker-compose stop "name-service"

# Arrêter et supprimer tous les services
docker-compose down
```

## Vérification du Fonctionnement

Pour tester que les services fonctionnent correctement:

```bash
# Test du service Flask
curl http://localhost:5000/api/message

# Test du service Spring Boot (proxy vers Flask)
curl http://localhost:8080/proxy
```

## Rappel des Spécifications Techniques

### Service Spring Boot
- Port: 8080
- Variable d'environnement: FLASK_URL

### Service Flask
- Port: 5000