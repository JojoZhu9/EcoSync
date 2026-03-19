package com.example.bibilabo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.jdbc.autoconfigure.DataSourceAutoConfiguration;

// 加上 exclude，告诉 Spring Boot 先别管数据库
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
public class BibilaboApplication {

    public static void main(String[] args) {
        SpringApplication.run(BibilaboApplication.class, args);
    }

}
