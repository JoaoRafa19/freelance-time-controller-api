 echo Script de deploy Interativo (Ambiente Homologação)
 

docker build -t freeler .
docker tag freeler freeler.azurecr.io/freeler
docker push freeler.azurecr.io/freeler

pause
