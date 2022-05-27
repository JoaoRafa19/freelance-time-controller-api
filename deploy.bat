#!/bin/bash
#Script para backup e execução de deploy dos Sites
echo -e "

Script de deploy Interativo (Ambiente Homologação)
para Freelance time controller api
"

docker-compose --env-file .env run -d -p 8000:8000 web
heroku container:push web 
heroku container:release web
heroku logs --tail

pause
