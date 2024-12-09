package com.Task_Management.task.security.config;


import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI customOpenApi() {
        return new OpenAPI()
                .info(new Info()
                        .title("Task Management")
                        .version("1.0")
                        .description("API Documentation for Task Management"))
                .addServersItem(new Server().url("http://localhost:8080"));
    }
}
