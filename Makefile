#INSTALL_TARGET_PROCESSES = SpringBoard

TARGET = iphone:clang:13.5:13.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Muse

Muse_CFLAGS = -fobjc-arc

#include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += musespotify
SUBPROJECTS += musesoundcloud
SUBPROJECTS += musespotifyintegration
SUBPROJECTS += musemusic
include $(THEOS_MAKE_PATH)/aggregate.mk

pre-build:
	sed 's/@implementation/%hook/' musespotifyintegration/Tweak.m | sed 's/@end/%end/' > musespotifyintegration/Tweak.x
