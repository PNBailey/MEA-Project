#!/bin/bash

build() {
    echo "Jenkins server: building images"
    docker build -t 52pbailey/mea-project .
}

push() {
    echo "Jenkins server: pushing images"
    docker push c
}

deploy() {
    

    echo "Deploy server: pulling images from Docker Hub"

    docker pull 52pbailey/mea-project

    echo "Deploy server: stopping and removing existing containers"

    docker stop mea-project && echo "mea-project stopped" || echo "mea-project already stopped"
    docker rm mea-project && echo "mea-project removed" || echo "mea-project does not exist"

    docker rmi 52pbailey/mea-project && echo "52pbailey/mea-project removed" || echo "52pbailey/mea-project does not exist"

    echo "Deploy server: stopping, removing and creating network"

    docker network rm mea-projectNetwork && echo "network removed" || echo "network does not exist"
    docker network create mea-projectNetwork

    echo "Deploy server: running containers"
     
    docker run -d -p 80:8080 --name mea-project --network mea-projectNetwork 52pbailey/mea-project
    
}

build
push
deploy
