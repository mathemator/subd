plugins {
	java
	id("org.springframework.boot") version "3.4.3"
	id("io.spring.dependency-management") version "1.1.7"
}

group = "ru.mathemator"
version = "0.0.1-SNAPSHOT"

repositories {
	mavenCentral()
}

dependencies {
	annotationProcessor("org.projectlombok:lombok:1.18.30")

	implementation("net.logstash.logback:logstash-logback-encoder:8.0")

	compileOnly("org.projectlombok:lombok:1.18.30")

	implementation("org.springframework.boot:spring-boot-starter-data-jpa")
	implementation("org.springframework.boot:spring-boot-starter-web")
	runtimeOnly("org.postgresql:postgresql")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType<Test> {
	useJUnitPlatform()
}
