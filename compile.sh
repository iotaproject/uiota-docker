#!/bin/bash

APP=$1

# Remove directory if it exists inside container
docker exec -i uiotaCont bash -c "rm -rf /uiota/app/${APP##*/}"

# Move dir into the container
docker cp $APP uiotaCont:/uiota/app

# Make
docker exec -i uiotaCont bash -c "cd /uiota/app/${APP##*/} && make -j 16"

# Copy firmware back to Linux
docker cp uiotaCont:/uiota/app/${APP##*/}/firmware .

