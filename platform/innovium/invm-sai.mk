# INVM SAI

#INVM_SAI_ONLINE = https://github.com/Innovium/SONiC/raw/master/debian/master
INVM_SAI_ONLINE = http://10.110.48.44/invm/master_new

INVM_LIBSAI = isai.deb
INVM_HSAI   = saihdr.deb
INVM_DRV    = ipd.deb
INVM_SHELL  = ishell.deb

$(INVM_LIBSAI)_URL = $(INVM_SAI_ONLINE)/$(INVM_LIBSAI)
$(INVM_HSAI)_URL   =  $(INVM_SAI_ONLINE)/$(INVM_HSAI)
$(INVM_DRV)_URL    =  $(INVM_SAI_ONLINE)/$(INVM_DRV)
$(INVM_SHELL)_URL  =  $(INVM_SAI_ONLINE)/$(INVM_SHELL)

$(eval $(call add_conflict_package,$(INVM_HSAI),$(LIBSAIVS_DEV)))

SONIC_ONLINE_DEBS  += $(INVM_LIBSAI) $(INVM_HSAI) $(INVM_DRV) $(INVM_SHELL)
