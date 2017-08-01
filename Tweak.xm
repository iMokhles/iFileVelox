//Velox expects your view to be a subclass of UIView.
//Additionally, you must conform to the VeloxView protocol, reproduced below.
//Get started by configuring the Info.plist in the root project directory to set up the API handling for the app you want to create an extension for.
//Most of the options will be set up by default through NIC, but you are free to customize.

//NOTE: any header you download for VeloxNotificationController may be outdated. You can get up to date headers by class dumping the Velox dylib.
#import "VeloxProtocol.h"
#import "Filemanager/TTOpenInAppActivity.h"
#import <MobileCoreServices/MobileCoreServices.h> // For UTI

static UIDocumentInteractionController *_OpenINController = nil;
static BOOL folderIFILEExists;
static UIWindow *ifileVeloxWindow;
static UIViewController *ifileVeloxRootViewController;
@interface iFileVelox : UIView <VeloxView, iFileVeloxViewControllerDelegate, UIPopoverPresentationControllerDelegate, UIDocumentInteractionControllerDelegate, TTOpenInAppActivityDelegate>
@end

@implementation iFileVelox
@synthesize controller;
@synthesize bulletins;

#pragma mark - Required methods

-(id)initWithBundleIdentifier:(NSString*)bundleIdentifier {
    //Velox's API will automatically set your view's frame based on -viewHeight. You do not need to set it explicitly, nor should you (as it will be overwritten by the API anyways).
    if (self = [super init]) {
        //Perform any custom setup you need to do.
        ifileVeloxRootViewController = [[UIViewController alloc] init];
        [ifileVeloxRootViewController.view setFrame:[UIApplication sharedApplication].keyWindow.frame];
        ifileVeloxRootViewController.view.backgroundColor = [UIColor clearColor];

        ifileVeloxWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        [ifileVeloxWindow setWindowLevel:UIWindowLevelStatusBar];
        [ifileVeloxWindow setRootViewController:ifileVeloxRootViewController];
        NSLog(@"Bundle identifier passed to my view is: %@", bundleIdentifier);
    }
    return self;
}
-(CGFloat)viewHeight {
    //Set the height of your view

    //it is not recommended that you set your view's height based on a static number.
    //while this may look fine on your device, devices with other screen sizes will probably be distorted.
    //instead, you should use the following method, 
    //where your view height is set based on a percentage of the total screen size.
    CGFloat screenHeight = [[UIApplication sharedApplication] keyWindow].frame.size.height;
    return screenHeight-180;
}

#pragma mark - Optional methods

-(UIColor*)preferredArrowColorForArrowPosition:(ArrowViewPosition)position isDarkMode:(BOOL)darkMode {
    //ArrowViewPosition is defined in VeloxProtocol.h
    //You can use this to set the arrow color if, for example, your UI is different colors on the top and bottom.
    //You can adjust your colors for dark mode using the dark mode argument
    return [UIColor whiteColor];
}

-(BOOL)includeArrowView {
    //specify whether you want your view to include Velox's arrow view
    //it is recommended that you leave this on unless you really need to turn it off
    return YES;
}

-(BOOL)needsNotifications {
    //Define whether your extension needs the currently pending notifications for that app
    //THis is off by default as it creates an incredibly minute amount of lag 
    //(about 0.3 seconds)
    //If on, the notifications for the app will be stored in your class's bulletins property
    //If off, this property will be nil
    return NO;
}

-(UIColor*)backgroundColorForDarkMode:(BOOL)darkMode {
    //if you choose not to directly use this method, Velox will set a background color automatically for you.
    //if you use a custom color scheme, this method is good for customizing your Velox extension.

    //You can adjust for dark mode using the darkMode argument
    // if (!darkMode) {
    //     //light mode
    //     return [UIColor whiteColor];
    // }
    // else {
    //     //dark mode
    //     return [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
    // }
    return [UIColor whiteColor];
}

-(void)viewWillAppear {
    //Set up your view for use by the Velox API.
    //The API will set up the entire screen except for your actual view. 
    //Velox will automatically shift icons based on your view's specified height, 
    //and will automatically apply the background blur and the arrow view.
    //There is no need for you to do any of this manually.
    //Velox will also inform you when light mode is enabled via the controller property.
    //You can check against this property to perform custom UI changes within your view.

    //It is recommended you perform any initial UI setup in -viewWillAppear
    //-layoutSubviews will most likely also work,
    //however -viewWillAppear is directly backed by the API,
    //and is consistently called at the right time.

    NSLog(@"My view is about to appear!");
    folderIFILEExists = YES;
    [ifileVeloxWindow setHidden:YES];

    // UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    //  //do something like background color, title, etc you self
    // [navbar setTitle:@"/"];
    // [self addSubview:navbar];

    CGRect viewsStaticFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView *fbView = [[UIView alloc] initWithFrame:viewsStaticFrame];
    fbView.backgroundColor = [UIColor blackColor];
    [self addSubview:fbView];

    iFileVeloxViewController *fileBWSE = [[iFileVeloxViewController alloc] init];
    fileBWSE.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fileBWSE];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;

    navigationController.view.frame = fbView.bounds;
    // fileBWSE.view.frame = fbView.bounds;
    [fbView addSubview:navigationController.view];
    // UILabel* myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    // myLabel.text = @"I love Velox!";
    
    // if (self.controller.isLightMode)
    //     myLabel.textColor = [UIColor blackColor];
    // else
    //     myLabel.textColor = [UIColor whiteColor];
            
    // myLabel.font = [UIFont systemFontOfSize:36];
    // myLabel.numberOfLines = 1;
    // [self addSubview:myLabel];
}

- (void)didSelectFile:(NSString *)path {
    // [[UBClient sharedInstance] shareFileAtPath:path];
    // UIWindow *mainImoWindow = [[UIApplication sharedApplication] windows][0];
    // UIViewController *ifvViewController = mainImoWindow.rootViewController;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *URL = [NSURL fileURLWithPath:path];
        // CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)URL.pathExtension, NULL);
        // NSString *UTIType = [NSString stringWithFormat:@"%@",UTI];

        // _OpenINController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        // _OpenINController.delegate = self;
        // _OpenINController.URL = URL;
        // _OpenINController.UTI = UTIType;

        // dispatch_async(dispatch_get_main_queue(), ^{
        //     [ifileVeloxWindow setHidden:NO];
        //     [_OpenINController presentOpenInMenuFromRect:ifileVeloxRootViewController.view.frame inView:ifileVeloxRootViewController.view animated:YES];
        //         // [ProgressHUD showSuccess:@"Finished....."];
        // });
        
        // [ifileVeloxRootViewController presentViewController:activityViewController animated:YES completion:NULL];
        TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:ifileVeloxRootViewController.view andRect:ifileVeloxRootViewController.view.frame];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            openInAppActivity.superViewController = activityViewController;
            openInAppActivity.delegate = self;
            [activityViewController setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
                NSLog(@"[iMoDevTools] completed: %@, \n%d, \n%@, \n%@,", activityType, completed, returnedItems, activityError);
                if (completed && ![activityType isEqualToString:@"TTOpenInAppActivity"]) {
                    // [[iMoDevTools sharedInstance] dismissMainWindow];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ifileVeloxWindow setHidden:YES];
                    });
                }
                if (activityError && ![activityType isEqualToString:@"TTOpenInAppActivity"]) {
                    // [[iMoDevTools sharedInstance] dismissMainWindow];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ifileVeloxWindow setHidden:YES];
                    });
                }
            }];
            // Show UIActivityViewController
            dispatch_async(dispatch_get_main_queue(), ^{
                [ifileVeloxWindow setHidden:NO];
                [ifileVeloxRootViewController presentViewController:activityViewController animated:YES completion:NULL];
                // [ProgressHUD showSuccess:@"Finished....."];
            });
        } else {
            // Create pop up
            UIPopoverPresentationController *presentPOP = activityViewController.popoverPresentationController;
            activityViewController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
            activityViewController.popoverPresentationController.sourceView = ifileVeloxRootViewController.view;
            presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
            presentPOP.delegate = self;
            presentPOP.sourceRect = CGRectMake(700,80,0,0);
            presentPOP.sourceView = ifileVeloxRootViewController.view;
            openInAppActivity.superViewController = presentPOP;
            dispatch_async(dispatch_get_main_queue(), ^{
                [ifileVeloxWindow setHidden:NO];
                [ifileVeloxRootViewController presentViewController:activityViewController animated:YES completion:NULL];
                // [ProgressHUD showSuccess:@"Finished....."];
            });
        }

    });
}
- (void)openInAppActivityWillPresentDocumentInteractionController:(TTOpenInAppActivity*)activity {

}
- (void)openInAppActivityDidDismissDocumentInteractionController:(TTOpenInAppActivity*)activity {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ifileVeloxWindow setHidden:YES];
    });
}
- (void)openInAppActivityDidEndSendingToApplication:(TTOpenInAppActivity*)activity {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ifileVeloxWindow setHidden:YES];
    });
}

// - (void) documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
//     [ifileVeloxWindow setHidden:YES];
// }
- (BOOL)shouldDeleteFileAtPath:(NSString *)path {
    return YES;
}

-(void)viewDidAppear {
    //this is called when the animations finish and your view has fully appeared and is ready for use
    //perform any final setup
    NSLog(@"My view has appeared!");
}

-(void)viewWillDisappear {
    //this is called when the user touches outside your view, dismissing Velox
    NSLog(@"My view is about to disappear!");
    folderIFILEExists = NO;
}

-(void)viewDidDisappear {
    //this is called when your view has been completely removed from the key window
    NSLog(@"My view is gone!");
}
@end

%hook UIActivityViewController
- (void)_cancel {
    %orig;
    if (folderIFILEExists) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ifileVeloxWindow setHidden:YES];
        });
        %orig;
    } else {
        %orig;
    }
}
%end