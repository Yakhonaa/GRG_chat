package com.dbtest;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;

@SpringBootApplication
@EnableWebSocketMessageBroker 
public class DbtestApplication {

	public static void main(String[] args) {
		SpringApplication.run(DbtestApplication.class, args);
	}
}
