INSTALL_TARGET_PROCESSES = SpringBoard

TARGET = iphone:clang:13.0:13.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MuseSpotify
MuseSpotify_FILES = MUSViewController.mm UIImage+Color.m MUSRecentViewController.m MUSPreferencesViewController.m
MuseSpotify_FRAMEWORKS = UIKit WebKit Preferences
MuseSpotify_PRIVATE_FRAMEWORKS = MediaRemote MobileCoreServices FrontBoard MediaPlayerUI
MuseSpotify_EXTRA_FRAMEWORKS = HSWidgets MuseUI
MuseSpotify_INSTALL_PATH = /Library/HSWidgets
MuseSpotify_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
