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


RUN mkdir -p /app/staticfiles /app/media


# Exposer le port que Gunicorn utilisera (interne au réseau Docker)
EXPOSE 8000
