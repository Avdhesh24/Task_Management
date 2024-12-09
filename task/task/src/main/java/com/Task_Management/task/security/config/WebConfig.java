package com.Task_Management.task.security.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://10.0.2.2:5554", "http://localhost:5555") // Allow emulator (10.0.2.2) and browser (localhost)
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS") // Add OPTIONS for preflight requests
                .allowedHeaders("*") // Allow all headers
                .exposedHeaders("Authorization") // Expose Authorization header (e.g., JWT tokens)
                .allowCredentials(true); // Allow credentials like cookies and authorization headers
    }
}
