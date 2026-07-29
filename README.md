# Setup

Check out the Git repository and execute the Bash script

```bash
git clone https://github.com/risvanthkm/delta-onsite-1.git
cd delta-onsite-1
bash onsite_script.sh
```
Inputs for building & launching a simple web server and a redis database

```
app,python:3.12-slim,requirements.txt,./web_server,python3 app.py,8081,8081,bridge1,,redis
redis,,,./redis,,6379,6379,bridge1,./data:/data,,redis:7-alpine
```

This generates Dockerfile and docker-compose.yaml for the deployment

Visit `http://localhost:8081/`
