# Marvell SAI

BRANCH = master
ifeq ($(CONFIGURED_ARCH),arm64)
MRVL_SAI_VERSION = 1.13.0-1
else ifeq ($(CONFIGURED_ARCH),armhf)
MRVL_SAI_VERSION = 1.13.0-3
else
MRVL_SAI_VERSION = 1.13.0-1
endif

MRVL_SAI_URL_PREFIX = https://github.com/Marvell-switching/sonic-marvell-binaries/raw/master/$(CONFIGURED_ARCH)/sai-plugin/$(BRANCH)/
MRVL_SAI = mrvllibsai_$(MRVL_SAI_VERSION)_$(PLATFORM_ARCH).deb
$(MRVL_SAI)_URL = $(MRVL_SAI_URL_PREFIX)/$(MRVL_SAI)

SONIC_ONLINE_DEBS += $(MRVL_SAI)
$(MRVL_SAI)_SKIP_VERSION=y
$(eval $(call add_conflict_package,$(MRVL_SAI),$(LIBSAIVS_DEV)))

#INVM SAI

INVM_SAI_ONLINE = https://github.com/Innovium/SONiC/raw/master/debian/master

INVM_LIBSAI = isai.deb
INVM_HSAI   = saihdr.deb
INVM_DRV    = ipd.deb
INVM_SHELL  = ishell.deb

$(INVM_LIBSAI)_URL = $(INVM_SAI_ONLINE)/$(INVM_LIBSAI)
$(INVM_HSAI)_URL   =  $(INVM_SAI_ONLINE)/$(INVM_HSAI)
$(INVM_DRV)_URL    =  $(INVM_SAI_ONLINE)/$(INVM_DRV)
$(INVM_SHELL)_URL  =  $(INVM_SAI_ONLINE)/$(INVM_SHELL)

#$(eval $(call add_conflict_package,$(INVM_HSAI),$(LIBSAIVS_DEV)))

SONIC_ONLINE_DEBS  += $(INVM_LIBSAI) $(INVM_HSAI) $(INVM_DRV) $(INVM_SHELL)
$(INVM_LIBSAI)_SKIP_VERSION=y

