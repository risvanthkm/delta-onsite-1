FROM redis:7-alpine
WORKDIR /app
COPY dep.txt ./
RUN pip install -r dep.txt
COPY . .
RUN echo

