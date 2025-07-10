# Setup the docker as a service to restart on boot.

1. update and copy to systemd
    - Open chirpstack-docker.service and change Working Directory to match the cloned location
        - WorkingDirectory=/home/embue/chirpstack-docker
    - Copy the file
        - sudo cp chirpstack-docker.service /etc/systemd/system/
2. Run the setup commands
    - sudo systemctl daemon-reexec
    - sudo systemctl daemon-reload
    - sudo systemctl enable chirpstack-docker
    - sudo systemctl start chirpstack-docker
3. Check Its running
    - docker ps
    - view log with "journalctl -u chirpstack-docker.service -f"

(expand the window horizontally in edit mode and not markdown view to see the below better.)

CONTAINER ID   IMAGE                                       COMMAND                  CREATED          STATUS          PORTS                                       NAMES
4421e4f598a6   chirpstack/chirpstack-rest-api:4            "/usr/bin/chirpstack…"   41 seconds ago   Up 37 seconds   0.0.0.0:8090->8090/tcp, :::8090->8090/tcp   chirpstack-docker-chirpstack-rest-api-1
bf5b9e056522   chirpstack/chirpstack-gateway-bridge:4      "/usr/bin/chirpstack…"   41 seconds ago   Up 38 seconds                                               chirpstack-docker-chirpstack-gateway-bridge-1
cea92f967454   chirpstack/chirpstack:4                     "/usr/bin/chirpstack…"   41 seconds ago   Up 38 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   chirpstack-docker-chirpstack-1
6935c8f02f81   postgres:14-alpine                          "docker-entrypoint.s…"   42 seconds ago   Up 39 seconds   5432/tcp                                    chirpstack-docker-postgres-1
e8654585e62d   redis:7-alpine                              "docker-entrypoint.s…"   42 seconds ago   Up 39 seconds   6379/tcp                                    chirpstack-docker-redis-1
b61548bc2a7e   xoseperez/chirpstack-concentratord:latest   "bash start"             42 seconds ago   Up 40 seconds                                               chirpstack-concentratord
a310aace4f50   eclipse-mosquitto:2                         "/docker-entrypoint.…"   42 seconds ago   Up 39 seconds   0.0.0.0:1883->1883/tcp, :::1883->1883/tcp   chirpstack-docker-mosquitto-1

