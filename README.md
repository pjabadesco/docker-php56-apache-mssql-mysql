docker builder prune	
docker-compose build
docker run -d -p 8080:80 docker_imgcorp-net


docker-compose up

docker run -d -p 8080:80 -e PATH_WWW='www' docker_imgcorp-net