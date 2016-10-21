obj-m	:= altera_dma.o

KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD       := $(shell pwd)

CPPFLAGS += -include $(KERNELDIR)/include/generated/autoconf.h
ccflags-y := -Wno-error=date-time

all:
	$(MAKE) -C $(KERNELDIR) M=$(PWD)

install:
	./altera_dma_load

clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions *.symvers *.order

