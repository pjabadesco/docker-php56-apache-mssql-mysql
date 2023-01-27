## OLD

docker-compose build

docker build -t pjabadesco/php56-apache-mssql-mysql:1.8 .
docker push pjabadesco/php56-apache-mssql-mysql:1.8

docker build -t pjabadesco/php56-apache-mssql-mysql:latest .
docker push pjabadesco/php56-apache-mssql-mysql:latest

docker tag pjabadesco/php56-apache-mssql-mysql:latest ghcr.io/pjabadesco/php56-apache-mssql-mysql:latest
docker push ghcr.io/pjabadesco/php56-apache-mssql-mysql:latest

## NEW

docker buildx build --platform=linux/amd64 --tag=php56-apache-mssql-mysql:latest --load .

docker tag php56-apache-mssql-mysql:latest pjabadesco/php56-apache-mssql-mysql:2.1
docker push pjabadesco/php56-apache-mssql-mysql:2.1

docker tag pjabadesco/php56-apache-mssql-mysql:2.1 pjabadesco/php56-apache-mssql-mysql:latest
docker push pjabadesco/php56-apache-mssql-mysql:latest

docker tag pjabadesco/php56-apache-mssql-mysql:latest ghcr.io/pjabadesco/php56-apache-mssql-mysql:latest
docker push ghcr.io/pjabadesco/php56-apache-mssql-mysql:latest
