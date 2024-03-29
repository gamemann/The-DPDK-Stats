BUILDDIR=build
COMMONDIR=The-DPDK-Common
SRCDIR=src

COMMONOBJ=$(COMMONDIR)/objs/static/dpdk_common.o
COMMONSRC=$(COMMONDIR)/src

CMDLINEOBJ=cmdline.o
CMDLINESRC=cmdline.c

OBJS=$(COMMONOBJ) $(BUILDDIR)/$(CMDLINEOBJ)

SRC := dpdk_stats.c
OUT := dpdk-stats

PKGCONF ?= pkg-config

# Build using pkg-config variables if possible
ifneq ($(shell $(PKGCONF) --exists libdpdk && echo 0),0)
$(error "no installation of DPDK found")
endif

PC_FILE := $(shell $(PKGCONF) --path libdpdk 2>/dev/null)
CFLAGS += -O3 $(shell $(PKGCONF) --cflags libdpdk)
# Add flag to allow experimental API as l2fwd uses rte_ethdev_set_ptype API
CFLAGS += -DALLOW_EXPERIMENTAL_API
LDFLAGS_SHARED = $(shell $(PKGCONF) --libs libdpdk)
LDFLAGS_STATIC = $(shell $(PKGCONF) --static --libs libdpdk)

ifeq ($(MAKECMDGOALS),static)
# check for broken pkg-config
ifeq ($(shell echo $(LDFLAGS_STATIC) | grep 'whole-archive.*l:lib.*no-whole-archive'),)
$(warning "pkg-config output list does not contain drivers between 'whole-archive'/'no-whole-archive' flags.")
$(error "Cannot generate statically-linked binaries with this version of pkg-config")
endif
endif

all: main
build:
	@mkdir -p $(BUILDDIR)
commonbuild:
	$(MAKE) -C $(COMMONDIR)
cmdlinebuild: Makefile $(PC_FILE) | build
	$(CC) -I $(COMMONDIR)/$(SRCDIR) -c $(CFLAGS) -o $(BUILDDIR)/$(CMDLINEOBJ) $(LDFLAGS) $(LDFLAGS_STATIC) $(SRCDIR)/$(CMDLINESRC)
main: commonbuild cmdlinebuild $(OBJS) Makefile $(PC_FILE) | build
	$(CC) -I $(COMMONDIR)/$(SRCDIR) -pthread $(CFLAGS) $(SRCDIR)/$(SRC) -o $(BUILDDIR)/$(OUT) $(LDFLAGS) $(OBJS) $(LDFLAGS_STATIC)
install:
	cp $(BUILDDIR)/$(OUT) /usr/bin/$(OUT)
clean:
	rm -f $(BUILDDIR)/*
	$(MAKE) -C $(COMMONDIR) clean
.PHONY: main clean