#!/bin/bash
# dokploy.sh - Script de démarrage pour Dokploy

# Collecte des fichiers statiques
python manage.py collectstatic --noinput

# Démarrage de Gunicorn avec bind à 0.0.0.0
exec gunicorn --bind 0.0.0.0:8000 --workers 3 mysite.wsgi:application