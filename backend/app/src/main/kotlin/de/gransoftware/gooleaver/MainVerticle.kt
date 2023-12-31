package de.gransoftware.gooleaver

import de.gransoftware.gooleaver.conf.Conf
import io.vertx.core.AbstractVerticle
import io.vertx.core.Promise
import io.vertx.ext.web.Router

class MainVerticle(private val conf: Conf) : AbstractVerticle() {

  override fun start(startPromise: Promise<Void>) {
    val router = Router.router(vertx)
    router.get("/health/liveness").handler { ctx ->
      ctx.response().end("OK")
    }
    router.get("/health/readiness").handler { ctx ->
      ctx.response().end("OK")
    }

    vertx
      .createHttpServer()
      .requestHandler(router)
      .listen(conf.port) { http ->
        if (http.succeeded()) {
          startPromise.complete()
          println("HTTP server started on port 8888")
        } else {
          startPromise.fail(http.cause())
        }
      }
  }
}
