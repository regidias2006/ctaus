# To start this projetc you'll needed a container managment.

# build imagem
docker build -t uefi-ws-server .

# run container
docker run -d -p 8080:8080 --name ws-server uefi-ws-server


docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
docker system prune --all
docker compose logs -f
docker compose down
docker compose build --no-cache
