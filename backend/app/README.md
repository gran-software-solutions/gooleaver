# gooleaver backend

## Requirements

* Java 19

## How to run

```shell
./gradlew run
```

The server will be running on port 8888, and expose two endpoints:

* `/health/liveness`
* `/health/readiness`

## Format code

Run `./gradlew ktlintFormat`
