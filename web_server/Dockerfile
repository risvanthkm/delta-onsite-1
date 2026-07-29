FROM python:3.12-slim
WORKDIR /app
COPY requirments.txt ./
RUN pip install -r requirments.txt
COPY . .
CMD python3 app.py
