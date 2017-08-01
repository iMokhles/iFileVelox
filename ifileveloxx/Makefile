TARGET=iphone:clang:latest:6.0
THEOS_DEVICE_PORT=22
GO_EASY_ON_ME=1
export ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

THEOS_BUILD_DIR = Packages

LIBRARY_NAME = libifilevelox
libifilevelox_LOGOSFLAGS = -c generator=internal
libifilevelox_FILES = IFVClient.m
libifilevelox_CFLAGS = -I.
libifilevelox_LIBRARIES = rocketbootstrap
libifilevelox_PRIVATE_FRAMEWORKS = AppSupport
libifilevelox_INSTALL_PATH = /usr/lib

TOOL_NAME = ifilevelox
ifilevelox_FILES = IFVServer.m IFVDelegate.m
ifilevelox_FRAMEWORKS = Foundation CoreFoundation
ifilevelox_PRIVATE_FRAMEWORKS = AppSupport
ifilevelox_LIBRARIES = rocketbootstrap
ifilevelox_INSTALL_PATH = /usr/libexec

include $(THEOS_MAKE_PATH)/library.mk
include $(THEOS_MAKE_PATH)/tool.mk

before-package::
	sudo find _ -name "ifilevelox" -exec chown root:wheel {} \;
	sudo find _ -name "ifilevelox" -exec chmod 4777 {} \;
	sudo find _ -name "com.unlimapps.ifileveloxdlaunch.plist" -exec chown root:wheel {} \;
	find _ -name "ifileveloxdlaunch" -exec chmod 755 {} \;
	sudo find $(THEOS_STAGING_DIR) -name "ifilevelox" -exec nahm8 {} \;
	sudo find $(THEOS_STAGING_DIR) -name "libifilevelox.dylib" -exec nahm8 {} \;
