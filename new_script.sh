#!/bin/bash

touch docker-compose.yaml
echo services: > docker-compose.yaml

declare -A bridges

while true; do
    echo "Input Required Variables Please"

    IFS=',' read -r name base_image dep_file dir stup_cmd host_port cont_port bridge mount dep

    # if [[ -z "$name" || -z "$base_image" || -z "$dep_file" || -z "$dir" || -z "$stup_cmd" || -z "$host_port" || -z "$cont_port" || -z "$bridge" || -z "$mount" ]]; then
    #     echo "Stopping Input : One or more required variables are empty."
    #     break
    # fi

    bridges["$bridge"]=$bridge

    (
        mkdir -p "$dir"
        cd "$dir"
        touch Dockerfile

        cat <<- EOF > Dockerfile
FROM $base_image
WORKDIR /app
COPY $dep_file ./
RUN pip install -r $dep_file
COPY . .
RUN $stup_cmd

EOF

    nano Dockerfile

    )

    cat <<EOF >> docker-compose.yaml
    $name:
        build: $dir
        ports:
            - $host_port:$cont_port
        networks:
            - $bridge
        restart: unless-stopped
        volumes: 
            - $mount
EOF

    if [[ -n dep ]]; then
    cat <<EOF >> docker-compose.yaml
        depends_on:
            - $dep     
EOF

    nano docker-compose.yaml

done

echo networks: >> docker-compose.yaml

for br in ${!bridges[@]}; do
echo $br
cat <<EOF >> docker-compose.yaml
    $br:
        driver: bridge
EOF

done

docker compose up 

docker compose logs

#app,python:3.12-slim,requirments.txt,./1,python app.py,8081,8081,bridge1,./:/,redis
#redis,redis:7-alpine,dep.txt,./2,echo,6379,6379,bridge1,./:/,to_be_fixed