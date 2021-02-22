package com.example.demo;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class HelloController {

    @RequestMapping("/add")
    public String add(@RequestParam(value = "num1",defaultValue = "0") String num1,@RequestParam(value="num2",defaultValue = "0")String num2) {
        int sum = Integer.parseInt(num1) + Integer.parseInt(num2);
        return "Sum =  " + sum;
    }

    @RequestMapping("/sub")
    public String sub(@RequestParam(value = "num1",defaultValue = "0") String num1,@RequestParam(value="num2",defaultValue = "0")String num2) {
        int diff= Integer.parseInt(num1) - Integer.parseInt(num2);
        return "Difference = " + diff;
    }



        @RequestMapping("/")
        public String index() {
            return "Greetings from Spring Boot!1111";
        }
    }
