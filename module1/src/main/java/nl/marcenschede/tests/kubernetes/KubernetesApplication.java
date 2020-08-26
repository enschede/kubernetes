package nl.marcenschede.tests.kubernetes;

import io.micrometer.core.util.internal.logging.Slf4JLoggerFactory;
import lombok.extern.slf4j.Slf4j;
import org.apache.logging.slf4j.SLF4JLogger;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.io.ClassPathResource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
//@EnableDiscoveryClient
@Configuration
public class KubernetesApplication {

    private static Logger logger = LoggerFactory.getLogger(KubernetesApplication.class);

    @Value("${env1:novalue}")
    private String env1;

    @Value("${env2:novalue}")
    private String env2;

    @Value("${env3:novalue}")
    private String env3;

    @Value("${git.build.version}")
    private String buildVersion;

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

    @GetMapping("/versions")
    public String showVersions() {

        logger.info("running showVersions");

        return String.format("Version module1 = %s", buildVersion);
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
