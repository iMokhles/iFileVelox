GO_EASY_ON_ME = 1
TARGET = iphone:clang:latest:7.0

include theos/makefiles/common.mk

TWEAK_NAME = iFileVelox
iFileVelox_FILES = Tweak.xm $(wildcard Filemanager/*.m) $(wildcard Filemanager/*.mm) $(wildcard Filemanager/*.c)
iFileVelox_FRAMEWORKS = UIKit Foundation MobileCoreServices CoreGraphics
iFileVelox_LIBRARIES = ifilevelox z

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/Application\ Support/Velox/API/iFileVelox$(ECHO_END)
	$(ECHO_NOTHING)cp Info.plist $(THEOS_STAGING_DIR)/Library/Application\ Support/Velox/API/iFileVelox/$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += ifileveloxx
include $(THEOS_MAKE_PATH)/aggregate.mk