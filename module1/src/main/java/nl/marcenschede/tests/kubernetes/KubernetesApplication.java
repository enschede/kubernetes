package nl.marcenschede.tests.kubernetes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class KubernetesApplication {

    @Value("${env1:novalue}")
    private String env1;

    @Value("${env2:novalue}")
    private String env2;

    @Value("${env3:novalue}")
    private String env3;

    public static void main(String[] args) {
        SpringApplication.run(KubernetesApplication.class, args);
    }

    @GetMapping("/env1")
    public String showEnv1() {
        return String.format("env1 has value '%s'", env1);
    }

    @GetMapping("/env2")
    public String showEnv2() {
        return String.format("env2 has value '%s'", env2);
    }

    @GetMapping("/env3")
    public String showEnv3() {
        return String.format("env3 has value '%s'", env3);
    }

}
