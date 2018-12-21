#!/bin/bash

set -o nounset
set -o errexit

pip install --upgrade pip
pip install redis

cd /usr/src/app/dockerweb/redisweb
python manage.py makemigrations
python manage.py migrate
python manage.py runserver 0.0.0.0:8001

