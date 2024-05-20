# sonic marvell one image installer
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

#for ARM64/ARMHF targets
ifeq ($(CONFIGURED_ARCH),$(filter $(CONFIGURED_ARCH),arm64 armhf))
ifeq ($(CONFIGURED_ARCH),arm64)
$(SONIC_ONE_IMAGE)_INSTALLS += $(MRVL_PRESTERA_DEB)
# prestera arm64 platform modules
$(SONIC_ONE_IMAGE)_LAZY_INSTALLS += $(NOKIA_7215_PLATFORM) \
				$(AC5X_RD98DX35xx_PLATFORM) \
				$(AC5X_RD98DX35xxCN9131_PLATFORM)
else ifeq ($(CONFIGURED_ARCH),armhf)
$(SONIC_ONE_IMAGE)_INSTALLS += $(MRVL_PRESTERA_DEB)
# prestera armhf platform modules
$(SONIC_ONE_IMAGE)_LAZY_INSTALLS += $(NOKIA_7215_PLATFORM)
endif

#ifeq ($(EXTRA_DOCKER_TARGETS),sonic-marvell-prestera.bin)
ifeq ($(PRESTERA_BUILD),y)
SONIC_ONE_IMAGE = sonic-marvell-prestera-$(CONFIGURED_ARCH).bin
else ifeq ($(TERALYNX_BUILD),y)
SONIC_ONE_IMAGE = sonic-marvell-teralynx-$(CONFIGURED_ARCH).bin
endif
else
#amd64 related targets
$(info KS2 extra docker targets is $(EXTRA_DOCKER_TARGETS))
#ifeq ($(EXTRA_DOCKER_TARGETS),sonic-marvell-prestera.bin)
ifeq ($(PRESTERA_BUILD),y)
SONIC_ONE_IMAGE = sonic-marvell-prestera.bin
$(SONIC_ONE_IMAGE)_MACHINE = marvell-prestera
# prestera x86 platform modules
$(SONIC_ONE_IMAGE)_LAZY_INSTALLS += $(AC5X_RD98DX35xx_PLATFORM)
$(SONIC_ONE_IMAGE)_LAZY_INSTALLS += $(FALCON_DB98CX8580_32CD_PLATFORM)
$(SONIC_ONE_IMAGE)_LAZY_INSTALLS += $(FALCON_DB98CX8540_16CD_PLATFORM)
$(SONIC_ONE_IMAGE)_LAZY_INSTALLS += $(FALCON_DB98CX8514_10CC_PLATFORM)
else ifeq ($(TERALYNX_BUILD),y)
SONIC_ONE_IMAGE = sonic-marvell-teralynx.bin
$(SONIC_ONE_IMAGE)_MACHINE = marvell-teralynx
# teralynx x86 platform modules
$(SONIC_ONE_IMAGE)_LAZY_INSTALLS += $(CEL_MIDSTONE_200I_PLATFORM_MODULE)
$(SONIC_ONE_IMAGE)_LAZY_INSTALLS += $(WISTRON_PLATFORM_MODULE)
$(SONIC_ONE_IMAGE)_LAZY_INSTALLS += $(TL10_DBMVTX9180_PLATFORM)
$(SONIC_ONE_IMAGE)_INSTALLS += $(INVM_DRV)
endif
endif #end of amd64 artifacts

$(SONIC_ONE_IMAGE)_IMAGE_TYPE = onie
$(SONIC_ONE_IMAGE)_INSTALLS += $(SYSTEMD_SONIC_GENERATOR)

ifeq ($(INSTALL_DEBUG_TOOLS),y)
$(SONIC_ONE_IMAGE)_DOCKERS += $(SONIC_INSTALL_DOCKER_DBG_IMAGES)
$(SONIC_ONE_IMAGE)_DOCKERS += $(filter-out $(patsubst %-$(DBG_IMAGE_MARK).gz,%.gz, $(SONIC_INSTALL_DOCKER_DBG_IMAGES)), $(SONIC_INSTALL_DOCKER_IMAGES))
else
$(SONIC_ONE_IMAGE)_DOCKERS = $(SONIC_INSTALL_DOCKER_IMAGES)
endif
SONIC_INSTALLERS += $(SONIC_ONE_IMAGE)
