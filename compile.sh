#!/bin/bash

APP=$1

# Remove directory if it exists inside container
docker exec -i uiotaCont bash -c "rm -rf /uiota/staging/${APP##*/}"

# Move dir into the container
docker cp $APP uiotaCont:/uiota/staging

# Make
docker exec -i uiotaCont bash -c "cd /uiota/staging/${APP##*/} && make -j 16"

# Copy built FW
docker exec -i uiotaCont bash -c "cp /uiota/staging/${APP##*/}/firmware/* /uiota/firmware"

# Copy firmware back to Linux
docker cp uiotaCont:/uiota/firmware .

