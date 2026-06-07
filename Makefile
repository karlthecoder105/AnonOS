.PHONY: all build clean

all: build

build:
	sudo docker run --privileged --rm \
		-v $(PWD)/build:/build/build \
		-v $(PWD)/profiledir:/build/profiledir \
		-v $(PWD)/build.sh:/build/build.sh \
		anonos-builder \
		/bin/bash -c './build.sh && cp /build/build/*.iso /build/build/ 2>/dev/null; ls -lh /build/build/*.iso 2>/dev/null || echo "Check build/ directory"'

docker:
	sudo docker build -t anonos-builder .

clean:
	sudo rm -rf build/work build/anonos-*.iso 2>/dev/null; mkdir -p build
