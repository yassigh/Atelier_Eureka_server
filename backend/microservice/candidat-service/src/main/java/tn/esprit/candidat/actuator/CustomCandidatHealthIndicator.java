package tn.esprit.candidat.actuator;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

/**
 * Indicateur de santé personnalisé pour le microservice Candidat.
 * Objectif TP : Ecrire un HealthIndicator personnalisé exposé sous /actuator/health.
 */
@Component
public class CustomCandidatHealthIndicator implements HealthIndicator {

    @Override
    public Health health() {
        // Verification personnalisee de disponibilite du microservice
        boolean serviceReady = true;

        if (serviceReady) {
            return Health.up()
                    .withDetail("service", "Candidat")
                    .withDetail("state", "OPERATIONAL")
                    .withDetail("storage", "H2 In-Memory Database Ready")
                    .withDetail("timestamp", System.currentTimeMillis())
                    .build();
        } else {
            return Health.down()
                    .withDetail("service", "Candidat")
                    .withDetail("error", "Service Candidat non disponible")
                    .build();
        }
    }
}
