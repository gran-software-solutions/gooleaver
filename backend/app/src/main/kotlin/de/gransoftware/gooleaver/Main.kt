package de.gransoftware.gooleaver

import com.github.michaelbull.result.Err
import com.github.michaelbull.result.Ok
import com.github.michaelbull.result.Result
import de.gransoftware.gooleaver.conf.Conf
import io.vertx.core.Vertx
import io.vertx.core.json.jackson.DatabindCodec
import io.vertx.kotlin.coroutines.await
import kotlinx.coroutines.runBlocking
import mu.KotlinLogging

val log = KotlinLogging.logger {}
val violations: MutableList<String> = mutableListOf()

class BootstrapException(val violations: List<String>) : RuntimeException()

fun main(): Unit = runBlocking {
  val vertx = Vertx.vertx()
  val conf = when (val result = buildConf(System.getenv())) {
    is Err -> {
      result.error.printStackTrace()
      (result.error as? BootstrapException)?.violations?.forEach(::println)
      return@runBlocking
    }

    is Ok -> result.value
  }

  vertx.deployVerticle(
    MainVerticle(conf)
  ).onFailure {
    it.printStackTrace()
    log.error(it) { "Error deploying main verticle" }
    vertx.close()
  }.onSuccess {
    log.info("deployed main verticle")
  }.await()

  DatabindCodec.mapper()
    .findAndRegisterModules()
}

fun buildConf(env: Map<String, String>): Result<Conf, Throwable> = com.github.michaelbull.result.runCatching {
  val appPort = (env.getOrDefault("APP_PORT", "8888")).toIntOrNull()
  if (appPort == null) {
    violations += "Invalid APP_PORT"
  }

  if (violations.isNotEmpty()) {
    throw BootstrapException(violations)
  } else {
    Conf(port = appPort!!)
  }
}
