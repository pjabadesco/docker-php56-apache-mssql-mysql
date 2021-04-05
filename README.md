docker builder prune	
docker-compose build
docker run -d -p 8080:80 pjabadesco/php56-apache-mssql-mysql

docker-compose up

docker run -d -p 8080:80 -e PATH_WWW='www' docker-php56-apache-mssql-mysql_www

docker-compose build --build-arg PATH_WWW='www1'

docker push pjabadesco/php56-apache-mssql-mysql:latest
