FROM python:3.12-alpine

# Variables d'environnement pour Python
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Ajouter les dépendances système nécessaires
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    postgresql-dev \
    python3-dev \
    libffi-dev

WORKDIR /app

# Copier uniquement requirements.txt pour profiter du cache Docker
COPY requirements.txt .
# Installer les dépendances système si nécessaire (ex: pour postgresql client)
# RUN apk update && apk add --no-cache postgresql-client build-base
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste du projet
COPY . .

# Créer les répertoires pour les fichiers statiques et médias
# Note: Assurez-vous que l'utilisateur qui lance Gunicorn a les droits d'écriture sur MEDIA_ROOT si nécessaire.
# Pour l'instant, on les crée et collectstatic écrira dans staticfiles.
RUN mkdir -p /app/staticfiles /app/mediafiles

# Exécuter collectstatic
# --noinput évite les questions interactives
RUN python mysite/manage.py collectstatic --noinput

# Exposer le port que Gunicorn utilisera (interne au réseau Docker)
EXPOSE 8000

# Lancer Gunicorn
# Remplacer 'mysite.wsgi:application' par le chemin vers votre fichier wsgi.py
# Le nombre de workers (ex: 3) dépendra des ressources de votre serveur.
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "mysite.mysite.wsgi:application"]
