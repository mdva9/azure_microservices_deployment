# README - Commandes pour le déploiement d'une application à microservices sur Microsoft Azure.

Ce README détaille les commandes utilisées pour le déploiement des microservices Spring Boot et Flask sur Azure.

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


## Création et Configuration d'un Runner

Création du dossier config :
```bash
# Le dossier doit être crée à la racine du projet.
mkdir chemin_vers/gitlab-runner/config/ 
```


Installation du runner via Docker:
```bash
# Exécuter l'image Spring Boot
docker run -d --name gitlab-runner --restart always \
-v /chemin_vers/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest
```


Création d'un token pour le projet:

    - Menu Settings > CI/CD du projet.
    - Ouvrir la section Runners.
    - Créer le runner via le bouton New project runner.
    - Cocher la case Run untagged jobs
    - Copier le runner authentication token et stocker le dans une endroit sur.


Enregistrement du Runner dans Docker:

```bash
# Remplacer la variable par le token 
docker run --rm -v /chemin_vers/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register \
--non-interactive \
--url "https://git.esi-bru.be" \
--token "$RUNNER_TOKEN" \ 
--executor "docker" \
--docker-image alpine:latest \
--description "docker-runner"
```







