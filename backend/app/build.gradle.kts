import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar
import org.gradle.api.tasks.testing.logging.TestLogEvent
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
  kotlin("jvm") version "1.7.21"
  application
  id("com.github.johnrengelman.shadow") version "7.1.2"
  id("org.jlleitschuh.gradle.ktlint") version "11.5.0"
  id("org.sonarqube") version "4.2.1.3168"
  id("com.google.cloud.tools.jib") version "3.3.1"
}

group = "de.gransoftware"
version = "1.0.0-SNAPSHOT"

repositories {
  mavenCentral()
}

val vertxVersion = "4.4.4"
val junitJupiterVersion = "5.9.1"

val mainVerticleName = "de.gransoftware.gooleaver.MainVerticle"
val launcherClassName = "de.gransoftware.gooleaver.MainKt"

val watchForChange = "src/**/*"
val doOnChange = "$projectDir/gradlew classes"

application {
  mainClass.set(launcherClassName)
}

dependencies {
  implementation(platform("io.vertx:vertx-stack-depchain:$vertxVersion"))
  implementation("io.vertx:vertx-lang-kotlin-coroutines")
  implementation("io.vertx:vertx-lang-kotlin")
  implementation(kotlin("stdlib-jdk8"))
  implementation("io.vertx:vertx-web:4.4.4")
  implementation("io.github.microutils:kotlin-logging-jvm:3.0.5")
  implementation("com.michael-bull.kotlin-result:kotlin-result:1.1.18")

  implementation("com.fasterxml.jackson.core:jackson-databind:2.13.4.2")
  implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.13.4")
  implementation("com.fasterxml.jackson.datatype:jackson-datatype-jsr310:2.13.4")

  implementation("org.slf4j:slf4j-api:2.0.5")
  implementation("org.slf4j:slf4j-simple:2.0.7")

  testImplementation("io.vertx:vertx-junit5")
  testImplementation("org.junit.jupiter:junit-jupiter:$junitJupiterVersion")
}

val compileKotlin: KotlinCompile by tasks
compileKotlin.kotlinOptions.jvmTarget = "17"

tasks.withType<ShadowJar> {
  archiveFileName.set("gooleaver-backend.jar")
  manifest {
    attributes(mapOf("Main-Verticle" to mainVerticleName))
  }
  mergeServiceFiles()
}

tasks.withType<Test> {
  useJUnitPlatform()
  testLogging {
    events = setOf(TestLogEvent.PASSED, TestLogEvent.SKIPPED, TestLogEvent.FAILED)
  }
}

tasks.withType<JavaExec> {
  args = listOf("run", mainVerticleName, "--redeploy=$watchForChange", "--launcher-class=$launcherClassName", "--on-redeploy=$doOnChange")
}

jib {
  from {
    image = "openjdk:17-slim"
  }
  to {
    image = "acrgooleaver.azurecr.io/gooleaver-backend"
    tags = setOf("latest")
  }
  container {
    mainClass = launcherClassName
    ports = listOf("8888")
  }
}
