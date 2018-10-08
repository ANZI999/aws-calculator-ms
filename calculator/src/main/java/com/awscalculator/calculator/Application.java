package com.awscalculator.calculator;

import java.util.Arrays;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
	
    public static void main(String[] args) {
    	ExternalAPI.setAPIRoot(args[0]);
        SpringApplication.run(Application.class, args);
    }
}