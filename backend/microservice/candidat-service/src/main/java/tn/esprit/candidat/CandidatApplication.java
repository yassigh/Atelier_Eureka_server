package tn.esprit.candidat;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@SpringBootApplication
@EnableDiscoveryClient
@RestController
@RequestMapping("/api/candidates")
public class CandidatApplication {

    public static void main(String[] args) {
        SpringApplication.run(CandidatApplication.class, args);
    }

    @GetMapping("/hello")
    public Map<String, Object> hello() {
        Map<String, Object> response = new HashMap<>();
        response.put("service", "CANDIDAT");
        response.put("status", "UP");
        return response;
    }
}
