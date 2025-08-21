#!/bin/bash

echo "Updating Repository..."
./update.sh

echo "Composing Apps on Docker ...."
cp ./mathApp-service/.env.example ./mathApp-service/.env
cp ./mathApp/.env.example ./mathApp/.env
docker-compose down -v
docker-compose up --build -d

