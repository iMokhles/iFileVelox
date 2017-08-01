//
// MGFileBrowserTableViewController.h
// MGEnhancer
//
// (Unbox) Created by Mokhlas Hussein on 26/11/2014 
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import <unistd.h>
#import <stdlib.h>
#import <sys/types.h>
#import <sys/stat.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#include <objc/runtime.h>
#include <dlfcn.h>
#import <IFVClient.h>

@class iFileVeloxViewController;

@protocol iFileVeloxViewControllerDelegate <NSObject>
- (void)didSelectFile:(NSString *)path;
- (BOOL)shouldDeleteFileAtPath:(NSString *)path;
@optional
- (void)didLoadDirectory:(NSString *)path;
- (void)fileBrowserDidCancelled;
@end

@interface iFileVeloxViewController: UITableViewController {
	NSFileManager *fileManager;
	NSString *path;
	NSMutableArray *contents;
	id <iFileVeloxViewControllerDelegate> _delegate;
}

@property (nonatomic, readonly) NSString *path;
@property (nonatomic, assign) id <iFileVeloxViewControllerDelegate> delegate;

@end