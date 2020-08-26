# Spring Cloud

## Sleuth

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

### Logging example

    2020-08-26 13:43:44.928  INFO [,acc36632d66e8a3b,acc36632d66e8a3b,true] 41770 --- [nio-8080-exec-1] n.m.t.kubernetes.KubernetesApplication   : running showEnv3


