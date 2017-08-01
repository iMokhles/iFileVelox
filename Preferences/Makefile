ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest

include theos/makefiles/common.mk

BUNDLE_NAME = iFileVelox
iFileVelox_FILES = iFileVelox.mm
iFileVelox_INSTALL_PATH = /Library/Application Support/Velox/API/iFileVelox
iFileVelox_FRAMEWORKS = UIKit
iFileVelox_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk
