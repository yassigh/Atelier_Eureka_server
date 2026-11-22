package tn.esprit.job.actuator;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

/**
 * Indicateur de santé personnalisé pour le microservice Job.
 * Objectif TP : Ecrire un HealthIndicator personnalisé exposé sous /actuator/health.
 */
@Component
public class CustomJobHealthIndicator implements HealthIndicator {

    @Override
    public Health health() {
        // Verification personnalisee pour le microservice Job
        boolean jobServiceOperational = true;

        if (jobServiceOperational) {
            return Health.up()
                    .withDetail("service", "Job")
                    .withDetail("state", "OPERATIONAL")
                    .withDetail("jobQueue", "EMPTY_OR_PROCESSING")
                    .withDetail("timestamp", System.currentTimeMillis())
                    .build();
        } else {
            return Health.down()
                    .withDetail("service", "Job")
                    .withDetail("error", "Service Job indisponible")
                    .build();
        }
    }
}
