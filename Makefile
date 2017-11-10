CURDIR := $(shell pwd)
BASEDIR := $(abspath $(CURDIR)/)

# Configuration.

H2LOAD_DURATION ?= 5s
H2LOAD_WARM_UP_TIME ?= 1s
H2LOAD_ADDRESS ?= "127.0.0.1"

# Platform detection.

ifeq ($(PLATFORM),)
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
PLATFORM = linux
else ifeq ($(UNAME_S),Darwin)
PLATFORM = darwin
else ifeq ($(UNAME_S),SunOS)
PLATFORM = solaris
else ifeq ($(UNAME_S),GNU)
PLATFORM = gnu
else ifeq ($(UNAME_S),FreeBSD)
PLATFORM = freebsd
else ifeq ($(UNAME_S),NetBSD)
PLATFORM = netbsd
else ifeq ($(UNAME_S),OpenBSD)
PLATFORM = openbsd
else ifeq ($(UNAME_S),DragonFly)
PLATFORM = dragonfly
else ifeq ($(shell uname -o),Msys)
PLATFORM = msys2
else
$(error Unable to detect platform.)
endif

export PLATFORM
endif

# Verbosity.

V ?= 0

verbose_0 = @
verbose_2 = set -x;
verbose = $(verbose_$(V))

gen_verbose_0 = @echo " GEN   " $@;
gen_verbose_2 = set -x;
gen_verbose = $(gen_verbose_$(V))

# Targets.

all:: cowboy1-h1-test cowboy2-h1-test cowboy2-h2-test

cowboy1-build:
	$(gen_verbose) docker build -f Dockerfile.cowboy1 -t phoenix_h2load:cowboy1 .

cowboy1-create: cowboy1-build
	$(gen_verbose) (docker stop phoenix_h2load_cowboy1 || true) \
		&& (docker rm -f phoenix_h2load_cowboy1 || true) \
		&& docker create --name phoenix_h2load_cowboy1 phoenix_h2load:cowboy1

# && docker create -p 29593:29593 -p 29594:29594 -p 29595:29595 --name phoenix_h2load_cowboy1 phoenix_h2load:cowboy1

cowboy1-start: cowboy1-create
	$(gen_verbose) docker start phoenix_h2load_cowboy1 \
		&& sleep 5 # give everything time to start up

cowboy1-stop:
	$(gen_verbose) docker stop phoenix_h2load_cowboy1

cowboy1-h1-test: cowboy1-start
	$(gen_verbose) echo "\033[0;36m[cowboy 1.x] load testing cowboy (h1) for $(H2LOAD_DURATION)\033[0m" \
		&& docker exec phoenix_h2load_cowboy1 priv/test.sh $(H2LOAD_DURATION) $(H2LOAD_WARM_UP_TIME) h1 $(H2LOAD_ADDRESS) 29593 \
		&& echo "\033[0;36m[cowboy 1.x] load testing plug (h1) for $(H2LOAD_DURATION)\033[0m" \
		&& docker exec phoenix_h2load_cowboy1 priv/test.sh $(H2LOAD_DURATION) $(H2LOAD_WARM_UP_TIME) h1 $(H2LOAD_ADDRESS) 29594 \
		&& echo "\033[0;36m[cowboy 1.x] load testing phoenix (h1) for $(H2LOAD_DURATION)\033[0m" \
		&& docker exec phoenix_h2load_cowboy1 priv/test.sh $(H2LOAD_DURATION) $(H2LOAD_WARM_UP_TIME) h1 $(H2LOAD_ADDRESS) 29595 \
		&& (docker stop phoenix_h2load_cowboy1 || true)

cowboy2-build:
	$(gen_verbose) docker build -f Dockerfile.cowboy2 -t phoenix_h2load:cowboy2 .

cowboy2-create: cowboy2-build
	$(gen_verbose) (docker stop phoenix_h2load_cowboy2 || true) \
		&& (docker rm -f phoenix_h2load_cowboy2 || true) \
		&& docker create --name phoenix_h2load_cowboy2 phoenix_h2load:cowboy2

cowboy2-start: cowboy2-create
	$(gen_verbose) docker start phoenix_h2load_cowboy2 \
		&& sleep 5 # give everything time to start up

cowboy2-stop:
	$(gen_verbose) docker stop phoenix_h2load_cowboy2

cowboy2-h1-test: cowboy2-start
	$(gen_verbose) echo "\033[0;36m[cowboy 2.x] load testing cowboy (h1) for $(H2LOAD_DURATION)\033[0m" \
		&& docker exec phoenix_h2load_cowboy2 priv/test.sh $(H2LOAD_DURATION) $(H2LOAD_WARM_UP_TIME) h1 $(H2LOAD_ADDRESS) 29593 \
		&& echo "\033[0;36m[cowboy 2.x] load testing plug (h1) for $(H2LOAD_DURATION)\033[0m" \
		&& docker exec phoenix_h2load_cowboy2 priv/test.sh $(H2LOAD_DURATION) $(H2LOAD_WARM_UP_TIME) h1 $(H2LOAD_ADDRESS) 29594 \
		&& echo "\033[0;36m[cowboy 2.x] load testing phoenix (h1) for $(H2LOAD_DURATION)\033[0m" \
		&& docker exec phoenix_h2load_cowboy2 priv/test.sh $(H2LOAD_DURATION) $(H2LOAD_WARM_UP_TIME) h1 $(H2LOAD_ADDRESS) 29595 \
		&& (docker stop phoenix_h2load_cowboy2 || true)

cowboy2-h2-test: cowboy2-start
	$(gen_verbose) echo "\033[0;36m[cowboy 2.x] load testing cowboy (h2) for $(H2LOAD_DURATION)\033[0m" \
		&& docker exec phoenix_h2load_cowboy2 priv/test.sh $(H2LOAD_DURATION) $(H2LOAD_WARM_UP_TIME) h2 $(H2LOAD_ADDRESS) 29593 \
		&& echo "\033[0;36m[cowboy 2.x] load testing plug (h2) for $(H2LOAD_DURATION)\033[0m" \
		&& docker exec phoenix_h2load_cowboy2 priv/test.sh $(H2LOAD_DURATION) $(H2LOAD_WARM_UP_TIME) h2 $(H2LOAD_ADDRESS) 29594 \
		&& echo "\033[0;36m[cowboy 2.x] load testing phoenix (h2) for $(H2LOAD_DURATION)\033[0m" \
		&& docker exec phoenix_h2load_cowboy2 priv/test.sh $(H2LOAD_DURATION) $(H2LOAD_WARM_UP_TIME) h2 $(H2LOAD_ADDRESS) 29595 \
		&& (docker stop phoenix_h2load_cowboy2 || true)

clean:: clean-docker

clean-docker:
	$(gen_verbose) (docker stop phoenix_h2load_cowboy1 || true) \
		&& (docker stop phoenix_h2load_cowboy2 || true) \
		&& (docker rm -f phoenix_h2load_cowboy1 || true) \
		&& (docker rm -f phoenix_h2load_cowboy2 || true) \
		&& (docker rmi phoenix_h2load:cowboy1 || true) \
		&& (docker rmi phoenix_h2load:cowboy2 || true)
