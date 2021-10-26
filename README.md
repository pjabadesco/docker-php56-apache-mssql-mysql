docker-compose build

docker build -t pjabadesco/php56-apache-mssql-mysql:1.3 .
docker push pjabadesco/php56-apache-mssql-mysql:1.3

docker build -t pjabadesco/php56-apache-mssql-mysql:latest .
docker push pjabadesco/php56-apache-mssql-mysql:latest

docker tag pjabadesco/php56-apache-mssql-mysql:latest ghcr.io/pjabadesco/php56-apache-mssql-mysql:latest
docker push ghcr.io/pjabadesco/php56-apache-mssql-mysql:latest
