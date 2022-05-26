A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).



# API in Development (v0.0.0)


# Usage
[Postman documentation](https://documenter.getpostman.com/view/12983885/UyrHeD83)


# Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart bin/server.dart
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

You should see the logging printed in the first terminal:
```
2021-05-06T15:47:04.620417  0:00:00.000158 GET     [200] /
```


## Dependencies

````

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