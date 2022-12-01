package com.deviot.localstackdemo

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class LocalstackDemoApplication

fun main(args: Array<String>) {
	runApplication<LocalstackDemoApplication>(*args)
}
