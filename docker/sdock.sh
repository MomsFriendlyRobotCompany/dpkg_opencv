#!/bin/bash
# So this is one monolithic script to replace of the separate scripts
# one script to rule them all

set -e

VERSION=0.5.0

NAME="pi-opencv"

useage(){
    echo "sdock.sh [cmd]"
    echo " A simple docker interface script. Valid commands:"
    echo "   bash     opens a bash command line into an existing ${NAME}"
    echo "   build    builds the image"
    echo "   clean    removes build artifacts that are not needed"
    echo "   help     print this message"
    echo "   nuke     nukes everything from orbit ... the only way to be sure it is clean"
    echo "   run      runs the image"
    echo "   status   shows useful info on docker status"
    echo "   rm       remove an existing ${NAME} container that is hung up"
}

stop(){
    docker stop ${NAME}
    docker rm ${NAME}
}

if [[ $# -ne 1 ]]; then
    useage
    exit 1
fi

CMD=$1

# if [[ ! -d "./${NAME}" ]]; then
#     echo ">> Creating local ${NAME} to store your config info from ${NAME}"
#     mkdir ${NAME}
# fi

if [[ ${CMD} == "run" ]]; then
    echo ">> running the image"
    DIR=`pwd`
    echo ">> ${DIR}/${NAME}"
    docker run \
    --name ${NAME} \
    -v ${DIR}/${NAME}:/done \
    walchko/${NAME}:${VERSION} bash
    stop

elif [[ ${CMD} == "bash" ]]; then
    echo ">> launching a bash command line to the container"
    docker exec -it ${NAME} bash

elif [[ ${CMD} == "rm" ]]; then
    echo ">> removing existing ${NAME} container"
    docker stop ${NAME}
    docker rm ${NAME}

elif [[ ${CMD} == "build" ]]; then
    echo ">> building the image"
    DIR=`pwd`
    echo ">> path: ${DIR}"
    docker build -t walchko/${NAME}:${VERSION} .
    # docker build -t walchko/${NAME}:${VERSION} -v ${DIR}/${NAME}:/opt/opencv/tmp .
    docker images walchko/${NAME}

elif [[ ${CMD} == "status" ]]; then
    docker ps
    echo "-------------------------------------------------------"
    docker images
    echo "-------------------------------------------------------"
    docker system df -v

elif [[ ${CMD} == "clean" ]]; then
    echo ">> Let's clean this up"
    # stop
    # docker volume rm $(docker volume ls -qf dangling=true) # delete orphaned/dangling volumes
    docker rmi $(docker images -q -f dangling=true) # delete dangling/untagged images
    docker rm $(docker ps -a -q) # remove all stopped containers

elif [[ ${CMD} == "nuke" ]]; then
    echo ">> nuke everything ... ha ha ha!!"
    docker kill $(docker ps -q)  # kill all running containers
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker system prune -a -f
    docker images prune -a
    docker volume prune -f
    docker container prune -f
    # docker rmi $(docker ps -q)
    docker rmi $(docker images -a -q) # delete all images
    docker rm $(docker ps -aq) # delete all containers

# elif [[ ${CMD} == "nuke" ]]; then
#     echo ">> removing existing ${NAME} container"
#     docker rm ${NAME}

elif [[ ${CMD} == "help" ]]; then
    useage
    exit 0

else
    echo ">> Unknown command: ${CMD}"
    echo ""
    useage
    exit 1

fi
