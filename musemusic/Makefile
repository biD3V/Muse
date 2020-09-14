INSTALL_TARGET_PROCESSES = SpringBoard

TARGET = iphone:clang:13.0:13.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MuseMusic
MuseMusic_FILES = MUMViewController.mm MUMRecentViewController.m
MuseMusic_FRAMEWORKS = UIKit MediaPlayer
MuseMusic_PRIVATE_FRAMEWORKS = MobileCoreServices FrontBoard MediaRemote MediaPlayerUI
MuseMusic_EXTRA_FRAMEWORKS = HSWidgets MuseUI
MuseMusic_INSTALL_PATH = /Library/HSWidgets
MuseMusic_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

