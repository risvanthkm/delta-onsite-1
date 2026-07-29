#!/bin/bash

touch docker-compose.yaml
echo services: > docker-compose.yaml

declare -A bridges

while true; do
echo "Input Required Variables Please"

IFS=',' read -r name base_image dep_file dir stup_cmd host_port cont_port bridge mount dep image

if [[ -z "$name" || -z "$dir" || -z "$host_port" || -z "$cont_port" || -z "$bridge" ]]; then
echo "Stopping Input : One or more required variables are empty."
break
fi

echo $dep_file

bridges["$bridge"]=$bridge

(
if [[ -n "$base_image" ]]; then
mkdir -p "$dir"
cd "$dir"
touch Dockerfile

cat << EOF > Dockerfile
FROM $base_image
WORKDIR /app
EOF

if [[ -n "$dep_file" ]];then
echo "COPY $dep_file ./" >> Dockerfile
echo "RUN pip install -r $dep_file" >> Dockerfile
fi

echo "COPY . ." >> Dockerfile

if [[ -n "$stup_cmd" ]]; then
echo "CMD $stup_cmd" >> Dockerfile
fi

nano Dockerfile
fi

)

if [[ -n "$base_image" ]]; then
cat <<EOF >> docker-compose.yaml
  $name:
    build: $dir
EOF

elif [[ -n "$image" ]]; then
cat <<EOF >> docker-compose.yaml
  $name:
    image: $image
EOF
fi

cat <<EOF >> docker-compose.yaml
    ports:
      - $host_port:$cont_port
    networks:
      - $bridge
    restart: unless-stopped
EOF

if [[ -n "$mount" ]];then
cat <<EOF >> docker-compose.yaml
    volumes:
      - $mount
EOF
fi

if [[ -n "$dep" ]]; then
cat <<EOF >> docker-compose.yaml
    depends_on:
      - $dep
EOF
fi

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

docker compose up -d

docker compose logs -f

#app,python:3.12-slim,requirments.txt,./web_server,python3 app.py,8081,8081,bridge1,,redis
#redis,,,./redis,,6379,6379,bridge1,./data:/data,,redis:7-alpine