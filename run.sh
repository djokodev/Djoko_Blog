#!/bin/bash
pip install -r requirements.txt

python manage.py makemigrations
python manage.py migrate

python manage.py collectstatic --noinput

sleep 3

gunicorn --bind 0.0.0.0:8000 --workers 2 mysite.wsgi:application