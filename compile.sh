#!/bin/bash

APP=$1

# Remove directory if it exists inside container
# Note that Bash shell parameter expansion ${X##Y} is used to get file basename
# More on this here: http://stackoverflow.com/questions/2664740/extract-file-basename-without-path-and-extension-in-bash
docker exec -i uiotaCont bash -c "rm -rf /uiota/staging/${APP##*/}"

# Move dir into the container
docker cp $APP uiotaCont:/uiota/staging

# Make
docker exec -i uiotaCont bash -c "cd /uiota/staging/${APP##*/} && make -j 16"

# Copy built FW
docker exec -i uiotaCont bash -c "cp /uiota/staging/${APP##*/}/firmware/* /uiota/firmware"

# Copy firmware back to Linux
docker cp uiotaCont:/uiota/firmware .

