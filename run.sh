#!/bin/bash

echo "Updating Repository..."
./update.sh

echo "Composing Apps on Docker ...."
docker-compose down -v
docker-compose up --build -d

echo "MathApp WIll Be Ready at  http://localhost:3000 in a few second"
