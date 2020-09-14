INSTALL_TARGET_PROCESSES = SpringBoard

TARGET = iphone:clang:13.0:13.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MuseSoundCloud
MuseSoundCloud_FILES = MUSCViewController.mm
MuseSoundCloud_FRAMEWORKS = UIKit
MuseSoundCloud_PRIVATE_FRAMEWORKS = MediaRemote MediaPlayerUI MobileCoreServices FrontBoard
MuseSoundCloud_EXTRA_FRAMEWORKS = HSWidgets MuseUI
MuseSoundCloud_INSTALL_PATH = /Library/HSWidgets
MuseSoundCloud_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

