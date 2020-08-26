# Usefull Docker commands

### Containers
    docker container ls -a
    docker container ls
    docker container inspect <container>
    docker container stop <container>
    docker container kill <container>
    docker container logs <container>
    
    docker top <container>      # bekijk alle processen in een container

### Containers starten

    docker run -it -rm <image>          # interactief en verwijderen na stop
    docker run -p 5001:5000 <image>     # port 5001 on host to 5000 in container
    docker run -d <image>               # detached
    docker run -m 512m <image>          # memory limit 512MB
    docker run --cpu-quota 5000 <image> # cpu limit 5%
    
### Images
    
    docker image ls
    docker push <image>
    docker push <image>:<tag>

### Overige

    docker events
    docker events -f
    docker stats                # info over alle draaiende containers
    docker system df            # disk usage van Docker
    
## Bronnen

- https://thefuturegroup.udemy.com/course/kubernetes-crash-course-for-java-developers/learn/lecture/16905346#overview
