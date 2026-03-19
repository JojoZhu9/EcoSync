package com.example.bibilabo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class IndexController {

    // 访问根目录时，自动重定向到 index.html
    @GetMapping("/")
    public String index() {
        return "forward:/index.html";
    }
}