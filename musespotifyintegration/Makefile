INSTALL_TARGET_PROCESSES = Spotify

ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MuseSpotifyIntegration

MuseSpotifyIntegration_FILES = Tweak.x
MuseSpotifyIntegration_CFLAGS = -fobjc-arc -DTHEOS

include $(THEOS_MAKE_PATH)/tweak.mk
