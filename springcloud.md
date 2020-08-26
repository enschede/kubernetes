# Spring Cloud

## Sleuth
Zorgt voor toevoegen van een TraceID en SpanID

- TraceID is uniek op ieder component
- SpanID is gemeenschappelijk op alle componenten

### pom file

    <properties>
        <spring-cloud.version>Hoxton.SR7</spring-cloud.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-sleuth</artifactId>
    </dependency>

### application.properties

    spring.application.name=Kubernetes Module 1

### Using the span ID
    
    @Autowired
    private Tracer tracer;

    String spanIdString = tracer.currentSpan().context().spanIdString();

Met de Tracer kunnen het TraceID en SpanID gemanipuleerd worden

### Logging example

    2020-08-26 13:43:44.928  INFO [Kubernetes Module 1,acc36632d66e8a3b,acc36632d66e8a3b,true] 41770 --- [nio-8080-exec-1] n.m.t.kubernetes.KubernetesApplication   : running showEnv3

## Log web request
Handige truuk om web requests te debuggen
    
    @Configuration
    public class RequestLoggingFilterConfig {
     
        @Bean
        public CommonsRequestLoggingFilter logFilter() {
            CommonsRequestLoggingFilter filter = new CommonsRequestLoggingFilter();
            filter.setIncludeQueryString(true);
            filter.setIncludePayload(true);
            filter.setMaxPayloadLength(10000);
            filter.setIncludeHeaders(false);
            filter.setAfterMessagePrefix("REQUEST DATA : ");
            return filter;
        }
    }


### application.properties

    logging.level.org.springframework.web.filter.CommonsRequestLoggingFilter=DEBUG

