//
// IFVDelegate.m
// Unbox
//
// Created by Árpád Goretity on 07/11/2011
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "IFVDelegate.h"
#import "rocketbootstrap.h"

@implementation IFVDelegate

- (id)init
{
	if ((self = [super init])) {
		center = [CPDistributedMessagingCenter centerNamed:@"com.imokhles.ifilevelox"];
		rocketbootstrap_distributedmessagingcenter_apply(center);
		[center runServerOnCurrentThread];

		[center registerForMessageName:@"com.imokhles.ifilevelox.move" target:self selector:@selector(IFV_handleMessageNamed:IFV_userInfo:)];
		[center registerForMessageName:@"com.imokhles.ifilevelox.copy" target:self selector:@selector(IFV_handleMessageNamed:IFV_userInfo:)];
		[center registerForMessageName:@"com.imokhles.ifilevelox.symlink" target:self selector:@selector(IFV_handleMessageNamed:IFV_userInfo:)];
		[center registerForMessageName:@"com.imokhles.ifilevelox.delete" target:self selector:@selector(IFV_handleMessageNamed:IFV_userInfo:)];
		[center registerForMessageName:@"com.imokhles.ifilevelox.attributes" target:self selector:@selector(IFV_handleMessageNamed:IFV_userInfo:)];
		[center registerForMessageName:@"com.imokhles.ifilevelox.dircontents" target:self selector:@selector(IFV_handleMessageNamed:IFV_userInfo:)];
		[center registerForMessageName:@"com.imokhles.ifilevelox.chmod" target:self selector:@selector(IFV_handleMessageNamed:IFV_userInfo:)];
		[center registerForMessageName:@"com.imokhles.ifilevelox.exists" target:self selector:@selector(IFV_handleMessageNamed:IFV_userInfo:)];
		[center registerForMessageName:@"com.imokhles.ifilevelox.isdir" target:self selector:@selector(IFV_handleMessageNamed:IFV_userInfo:)];
		[center registerForMessageName:@"com.imokhles.ifilevelox.mkdir" target:self selector:@selector(IFV_handleMessageNamed:IFV_userInfo:)];

		fileManager = [[NSFileManager alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[fileManager release];
	[super dealloc];
}

- (NSDictionary *)IFV_handleMessageNamed:(NSString *)name IFV_userInfo:(NSDictionary *)info
{
	NSString *sourceFile = [info objectForKey:@"IFVSourceFile"];
	NSString *targetFile = [info objectForKey:@"IFVTargetFile"];
	NSNumber *modeNumber = [info objectForKey:@"IFVFileMode"];
	const char *source = [sourceFile UTF8String];
	const char *target = [targetFile UTF8String];
	mode_t mode = [modeNumber intValue];
	NSMutableDictionary *result = [NSMutableDictionary dictionary];

	if ([name isEqualToString:@"com.imokhles.ifilevelox.move"]) {
		[fileManager moveItemAtPath:sourceFile toPath:targetFile error:NULL];
	} else if ([name isEqualToString:@"com.imokhles.ifilevelox.copy"]) {
		[fileManager copyItemAtPath:sourceFile toPath:targetFile error:NULL];
	} else if ([name isEqualToString:@"com.imokhles.ifilevelox.symlink"]) {
		symlink(source, target);
	} else if ([name isEqualToString:@"com.imokhles.ifilevelox.delete"]) {
		[fileManager removeItemAtPath:targetFile error:NULL];
	} else if ([name isEqualToString:@"com.imokhles.ifilevelox.attributes"]) {
		[result setDictionary:[fileManager attributesOfItemAtPath:targetFile error:NULL]];
	} else if ([name isEqualToString:@"com.imokhles.ifilevelox.dircontents"]) {
		NSArray *contents = [fileManager contentsOfDirectoryAtPath:targetFile error:NULL];
		if (contents) {
			[result setObject:contents forKey:@"IFVDirContents"];
		}
	} else if ([name isEqualToString:@"com.imokhles.ifilevelox.chmod"]) {
		chmod(target, mode);
	} else if ([name isEqualToString:@"com.imokhles.ifilevelox.exists"]) {
		BOOL exists = access(target, F_OK);
		NSNumber *num = [[NSNumber alloc] initWithBool:exists];
		[result setObject:num forKey:@"IFVFileExists"];
		[num release];
	} else if ([name isEqualToString:@"com.imokhles.ifilevelox.isdir"]) {
		struct stat buf;
		stat(target, &buf);
		BOOL isDir = S_ISDIR(buf.st_mode);
		NSNumber *num = [[NSNumber alloc] initWithBool:isDir];
		[result setObject:num forKey:@"IFVIsDirectory"];
		[num release];
	} else if ([name isEqualToString:@"com.imokhles.ifilevelox.mkdir"]) {
		[fileManager createDirectoryAtPath:targetFile withIntermediateDirectories:YES attributes:nil error:NULL];
	}

	return result;
}

- (void)IFV_dummy {
	// Keep the timer alive ;)
	NSLog(@"Keeping server alive");
}

@end
