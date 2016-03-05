## uIota ESP8266 Cross-build system
Dockerfile for uIota board cross-build system

## Usage
Create container:
```
docker run -d --name uiotaCont projectiota/uiota-esp8266-docker
```

Compile:
```
./compile.sh <path_to_my_proj_dir>
```

Flash:
```
./flash.sh
```
Will flash latest built FW
