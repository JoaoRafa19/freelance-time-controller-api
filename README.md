# Freller api

A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

# API in Development (v0.0.0)

# Usage

[Postman documentation](https://documenter.getpostman.com/view/12983885/UyrHeD83)

## Time controller api

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

``` shell
$ dart bin/server.dart
Server listening on port 8080
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

``` shell
$ docker build . -t my/app

$ docker run --env-file .env -d -p 8000:8000 my/app

Server listening on port 8080
```

And then from a second terminal:

``` shell
$ curl http://0.0.0.0:8080
Hello, world!
```

You should see the logging printed in the first terminal:

``` shell
2021-05-06T15:47:04.620417  0:00:00.000158 GET     [200] /
```

## Dependencies

```` yaml

    args: ^2.0.0
    dotenv: ^4.0.1
    dart_dotenv: ^1.0.1
    shelf: ^1.1.0
    shelf_router: ^1.0.0
    shelf_router_generator: ^1.0.2
    crypto: ^3.0.2
    sembast: ^3.2.0
    uuid: ^3.0.6
    shelf_test_handler: ^2.0.0 
    http: ^0.13.0
    lints: ^1.0.0
    test_process: ^2.0.0
    build_runner: ^2.1.10
    test: ^1.15.0


````

# Deploy

## Azure

Criação e envio do container para azure

```bash
docker build -t freeler .
docker tag freeler freeler.azurecr.io/freeler
docker push freeler.azurecr.io/freeler
```

Deploy do container na azure

```bash
 az container create --resource-group freeler --name freeler --image freeler.azurecr.io/freeler --dns-name-label freelerc --ports 80
 ```

 Mostar instancias de containers e o FQDN da VM

```bash
az container show --resource-group freeler --name freeler --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table
```

## Heroku

```bash
heroku login
git add .
git commit -m "make it better"
git push heroku master
```

_or_

```
docker build .
heroku container:push freeler

heroku container:release web
```
