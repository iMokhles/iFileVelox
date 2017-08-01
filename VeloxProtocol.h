#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Filemanager/iFileVeloxViewController.h"

//This struct is used internally to define, set, and check Velox's arrow position (top or bottom)
//You could use it to perform custom UI changes with -preferredArrowColorForArrowPosition:isDarkMode:
typedef NS_ENUM(NSInteger, ArrowViewPosition){
	ArrowViewPositionTop,
	ArrowViewPositionBottom
};

@class VeloxNotificationController;

@protocol VeloxView
//This array contains all the pending notifications for the app Velox was invoked on
//You could use this to display the notifications in a fancy way
@property (nonatomic, assign) NSArray* bulletins;
@property (nonatomic, assign) VeloxNotificationController *controller;
- (id)initWithBundleIdentifier:(NSString *)bundleIdentifier;
- (CGFloat)viewHeight;

@optional
- (UIColor*)preferredArrowColorForArrowPosition:(ArrowViewPosition)position isDarkMode:(BOOL)darkMode;
- (UIColor*)backgroundColorForDarkMode:(BOOL)darkMode;
- (BOOL)includeArrowView;
- (void)viewWillAppear;
- (void)viewDidAppear;
- (void)viewWillDisappear;
- (void)viewDidDisappear;
@end

@interface VeloxNotificationController : NSObject
//The property containing your view
//Under almost all cicumstances you will not need to access this
@property (nonatomic, retain) UIView<VeloxView> *specializedView;
//This property defines whether Velox is currently in light mode
//Use it to perform custom UI changes to accomodate for both modes
@property (nonatomic, assign) BOOL isLightMode;
//Only access VeloxNotficationController through either the sharedController method, or through self.controller
+(id)sharedController;
//You can use this method to dismiss Velox explicitly, if, for example, your view has a close button
//if you pass nil to the view argument, Velox will assume the keyWindow, where it is normally added
-(BOOL)removeVeloxViewsFromView:(UIView *)view;
@end
