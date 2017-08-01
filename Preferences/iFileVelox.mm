#import <Preferences/Preferences.h>

@interface iFileVeloxListController: PSListController {
}
@end

@implementation iFileVeloxListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"iFileVelox" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
