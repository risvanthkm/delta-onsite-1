FROM python:3.12-slim
WORKDIR /app
COPY requirments.txt ./
RUN pip install -r requirments.txt
COPY . .
RUN python app.py

