//
// IFVDelegate.h
// Unbox
//
// Created by Árpád Goretity on 07/11/2011
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import <stdlib.h>
#import <unistd.h>
#import <stdint.h>
#import <stdio.h>
#import <sys/stat.h>
#import <sys/types.h>
#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>


@interface IFVDelegate: NSObject {
	CPDistributedMessagingCenter *center;
	NSFileManager *fileManager;
}

- (NSDictionary *)IFV_handleMessageNamed:(NSString *)name IFV_userInfo:(NSDictionary *)info;
- (void)IFV_dummy;

@end
