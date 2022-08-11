 echo -e "Script de deploy Interativo (Ambiente Homologação)"

docker-compose --env-file .env run -d -p 8000:8000 web
heroku container:push web 
heroku container:release web
heroku logs --tail

pause
