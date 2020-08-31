package nl.marcenschede.tests.kubernetes;

import brave.Tracer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.io.ClassPathResource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@SpringBootApplication
@RestController
@EnableDiscoveryClient
@Configuration
public class KubernetesApplication {

    private static Logger logger = LoggerFactory.getLogger(KubernetesApplication.class);

    // Waarde wordt gezet in deployment yaml
    @Value("${env1:novalue}")
    private String env1;

    // Waarde wordt gezet in configMap yaml
    @Value("${env2:novalue}")
    private String env2;

    // Waarde wordt gezet in secret yaml
    @Value("${env3:novalue}")
    private String env3;

    // Zonder Kubernetes; uit application.properties
    // Met Kubernetes; wordt gezet in configMap2 yaml en wordt actief onderhouden via Spring Cloud Kubernetes
    @Value(value = "${value.From.Kubernetes}")
    private String valueFromKubernetes;

    // Zie PropertySourcesPlaceholderConfigurer bean hieronder
    @Value("${git.build.version}")
    private String buildVersion;

    @Autowired
    private Tracer tracer;

    public static void main(String[] args) {
        SpringApplication.run(KubernetesApplication.class, args);
    }

    @GetMapping("/env1")
    public String showEnv1() {

        logger.info("running showEnv1");

        return String.format("env1 has value '%s'", env1);
    }

    @GetMapping("/env2")
    public String showEnv2() {

        logger.info("running showEnv2");

        return String.format("env2 has value '%s'", env2);
    }

    @GetMapping("/env3")
    public String showEnv3() {

        logger.info("running showEnv3");

        return String.format("env3 has value '%s'", env3);
    }

//    @GetMapping
public List<String> root() {

    logger.info("running root");

    return getVersionData();
}

    @GetMapping("/versions")
    public List<String> showVersions() {

        logger.info("running /versions");

        return getVersionData();
    }

    private List<String> getVersionData() {
        String spanIdString = tracer.currentSpan().context().spanIdString();

        return List.of(
                String.format("env1 has value '%s'", env1),
                String.format("env2 has value '%s'", env2),
                String.format("env3 has value '%s'", env3),
                String.format("value.From.Kubernetes = '%s'", valueFromKubernetes),
                String.format("SpanID = %s", spanIdString),
                String.format("Version module1 = %s", buildVersion));
    }

    @Bean
    public static PropertySourcesPlaceholderConfigurer placeholderConfigurer() {
        PropertySourcesPlaceholderConfigurer propsConfig
                = new PropertySourcesPlaceholderConfigurer();
        propsConfig.setLocation(new ClassPathResource("git.properties"));
        propsConfig.setIgnoreResourceNotFound(true);
        propsConfig.setIgnoreUnresolvablePlaceholders(true);
        return propsConfig;
    }
}
