# Classify the targets to the specific platform_asic type
PRESTERA := $(or $(findstring prestera, $(EXTRA_DOCKER_TARGETS)), \
        $(findstring db98cx8514, $(EXTRA_DOCKER_TARGETS)), \
        $(findstring db98cx8540,$(EXTRA_DOCKER_TARGETS)), \
        $(findstring db98cx8580,$(EXTRA_DOCKER_TARGETS)), \
        $(findstring rd98dx35xx,$(EXTRA_DOCKER_TARGETS)), \
        $(findstring syncd-mrvl.gz,$(EXTRA_DOCKER_TARGETS)))

TERALYNX := $(or $(findstring teralynx, $(EXTRA_DOCKER_TARGETS)), \
        $(findstring 6512_32r, $(EXTRA_DOCKER_TARGETS)), \
        $(findstring sw-to3200k, $(EXTRA_DOCKER_TARGETS)), \
        $(findstring dbmvtx9180, $(EXTRA_DOCKER_TARGETS)), \
        $(findstring sse_t7132, $(EXTRA_DOCKER_TARGETS)), \
        $(findstring midstone, $(EXTRA_DOCKER_TARGETS)))

ifneq ($(PRESTERA),)
$(info KS2 This is PRESTERA Build)
PRESTERA_BUILD = y
else ifneq ($(TERALYNX),)
$(info KS2 This is TERALYNX Build)
TERALYNX_BUILD = y
else
$(info KS2 No Match found for $(EXTRA_DOCKER_TARGETS))
endif
$(info KS2 parsing rules.mk EXTRA_DOCKER_TARGETS is $(EXTRA_DOCKER_TARGETS))
$(info KS2 parsing rules.mk PRESTERA_BUILD is $(PRESTERA_BUILD))
$(info KS2 parsing rules.mk TERALYNX_BUILD is $(TERALYNX_BUILD))

include $(PLATFORM_PATH)/sai.mk

# basic platform dockers
ifeq ($(PRESTERA_BUILD),y)

include $(PLATFORM_PATH)/docker-syncd-mrvl.mk
include $(PLATFORM_PATH)/docker-syncd-mrvl-rpc.mk
include $(PLATFORM_PATH)/docker-saiserver-mrvl.mk
include $(PLATFORM_PATH)/platform-marvell.mk
ifeq ($(CONFIGURED_ARCH),$(filter $(CONFIGURED_ARCH),arm64 armhf))
include $(PLATFORM_PATH)/mrvl-prestera.mk
include $(PLATFORM_PATH)/platform-nokia.mk
endif
SONIC_ALL += $(SONIC_ONE_IMAGE) \
             $(DOCKER_FPM) 	\
             $(DOCKER_SYNCD_MRVL_RPC)

# Inject mrvl sai into syncd
$(SYNCD)_DEPENDS += $(MRVL_SAI)
$(SYNCD)_UNINSTALLS += $(MRVL_SAI)

else ifeq ($(TERALYNX_BUILD),y)

include $(PLATFORM_PATH)/docker-syncd-mrvl-teralynx.mk
include $(PLATFORM_PATH)/docker-syncd-mrvl-teralynx-rpc.mk
#add teralynx ODM modules
include $(PLATFORM_PATH)/platform-modules-wistron.mk
include $(PLATFORM_PATH)/platform-modules-cel.mk
include $(PLATFORM_PATH)/platform-modules-supermicro.mk
include $(PLATFORM_PATH)/platform-modules-dbmvtx9180.mk
SONIC_ALL += $(SONIC_ONE_IMAGE) \
             $(DOCKER_FPM) 	\
             $(DOCKER_SYNCD_MRVL_TERALYNX_RPC)

# Inject mrvl sai into syncd
$(SYNCD)_DEPENDS += $(INVM_HSAI) $(INVM_LIBSAI) $(INVM_SHELL)
$(SYNCD)_UNINSTALLS += $(INVM_HSAI)
endif

# rules for thrift dependencies
include $(PLATFORM_PATH)/libsaithrift-dev.mk

# packaging rules for sonic image
include $(PLATFORM_PATH)/one-image.mk

SONIC_ALL += $(SONIC_ONE_IMAGE) \
             $(DOCKER_FPM) 	\
             $(DOCKER_SYNCD_MRVL_RPC) \
             $(DOCKER_SYNCD_MRVL_TERALYNX_RPC)

ifeq ($(ENABLE_SYNCD_RPC),y)
$(SYNCD)_DEPENDS := $(filter-out $(LIBTHRIFT_DEV),$($(SYNCD)_DEPENDS))
$(SYNCD)_DEPENDS += $(LIBSAITHRIFT_DEV)
endif
