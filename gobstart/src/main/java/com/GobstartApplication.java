package com;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;

@SpringBootApplication(scanBasePackages={
        
        "com.config",
        "com.controller",
        "com.entity",
        "com.repository",
        "com.webconfig",
        "com.service",
        "com.spring",
        "com.survey"
})
@EntityScan("com.entity")
public class GobstartApplication {

	public static void main(String[] args) {
		
		SpringApplication.run(GobstartApplication.class, args);
	}

}
