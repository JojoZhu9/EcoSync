package com.example.bibilabo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
//import org.springframework.boot.jdbc.autoconfigure.DataSourceAutoConfiguration;

@SpringBootApplication
@MapperScan("com.example.bibilabo.mapper")
public class BibilaboApplication {

    public static void main(String[] args) {
        SpringApplication.run(BibilaboApplication.class, args);
    }

}