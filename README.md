docker system prune

docker-compose build
docker run -d -p 8080:80 pjabadesco/php56-apache-mssql-mysql

docker-compose up

docker run -d -p 8080:80 pjabadesco/php56-apache-mssql-mysql

docker-compose build --build-arg PATH_WWW='www'

docker push pjabadesco/php56-apache-mssql-mysql:latest


docker build -t pjabadesco/php56-apache-mssql-mysql:latest .
docker push pjabadesco/php56-apache-mssql-mysql