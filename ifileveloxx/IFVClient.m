//
// IFVClient.m
// Unbox
//
// Created by Árpád Goretity on 07/11/2011
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "IFVClient.h"
#import "rocketbootstrap.h"

@implementation IFVClient

+ (id)sharedInstance
{
	static id shared = nil;
	if (shared == nil) {
		shared = [[self alloc] init];
	}

	return shared;
}

- (id)init
{
	if ((self = [super init])) {
		center = [CPDistributedMessagingCenter centerNamed:@"com.imokhles.ifilevelox"];
		rocketbootstrap_distributedmessagingcenter_apply(center);
	}

	return self;
}

- (NSString *)IFV_temporaryFile
{
	CFUUIDRef uuidRef = CFUUIDCreate(NULL);
	CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
	CFRelease(uuidRef);
	NSString *path = [NSString stringWithFormat:@"/tmp/%@.tmp", uuid];
	CFRelease(uuid);
	return path;
}

- (void)IFV_moveFile:(NSString *)file1 IFV_toFile:(NSString *)file2
{
	if (file1 == nil || file2 == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file1 forKey:@"IFVSourceFile"];
	[info setObject:file2 forKey:@"IFVTargetFile"];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.ifilevelox.move" userInfo:info];
	[info release];
}

- (void)IFV_copyFile:(NSString *)file1 IFV_toFile:(NSString *)file2
{
	if (file1 == nil || file2 == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file1 forKey:@"IFVSourceFile"];
	[info setObject:file2 forKey:@"IFVTargetFile"];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.ifilevelox.copy" userInfo:info];
	[info release];
}

- (void)IFV_symlinkFile:(NSString *)file1 IFV_toFile:(NSString *)file2
{
	if (file1 == nil || file2 == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file1 forKey:@"IFVSourceFile"];
	[info setObject:file2 forKey:@"IFVTargetFile"];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.ifilevelox.symlink" userInfo:info];
	[info release];
}

- (void)IFV_deleteFile:(NSString *)file
{
	if (file == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file forKey:@"IFVTargetFile"];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.ifilevelox.delete" userInfo:info];
	[info release];
}

- (NSDictionary *)IFV_attributesOfFile:(NSString *)file
{
	if (file == nil) {
		return nil;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file forKey:@"IFVTargetFile"];
	NSDictionary *reply = [center sendMessageAndReceiveReplyName:@"com.imokhles.ifilevelox.attributes" userInfo:info];
	[info release];
	return reply;
}

- (NSArray *)IFV_contentsOfDirectory:(NSString *)dir
{
	if (dir == nil) {
		return nil;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:dir forKey:@"IFVTargetFile"];
	NSDictionary *reply = [center sendMessageAndReceiveReplyName:@"com.imokhles.ifilevelox.dircontents" userInfo:info];
	[info release];
	NSArray *result = [reply objectForKey:@"IFVDirContents"];
	return result;
}

- (void)IFV_chmodFile:(NSString *)file mode:(mode_t)mode
{
	if (file == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file forKey:@"IFVTargetFile"];
	NSNumber *modeNumber = [[NSNumber alloc] initWithInt:mode];
	[info setObject:modeNumber forKey:@"IFVFileMode"];
	[modeNumber release];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.ifilevelox.chmod" userInfo:info];
	[info release];
}

- (BOOL)IFV_fileExists:(NSString *)file
{
	if (file == nil) {
		return NO;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file forKey:@"IFVTargetFile"];
	NSDictionary *reply = [center sendMessageAndReceiveReplyName:@"com.imokhles.ifilevelox.exists" userInfo:info];
	[info release];
	BOOL result = [(NSNumber *)[reply objectForKey:@"IFVFileExists"] boolValue];
	return result;
}

- (BOOL)IFV_fileIsDirectory:(NSString *)file
{
	if (file == nil) {
		return NO;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file forKey:@"IFVTargetFile"];
	NSDictionary *reply = [center sendMessageAndReceiveReplyName:@"com.imokhles.ifilevelox.isdir" userInfo:info];
	[info release];
	BOOL result = [(NSNumber *)[reply objectForKey:@"IFVIsDirectory"] boolValue];
	return result;
}

- (void)IFV_createDirectory:(NSString *)dir
{
	if (dir == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:dir forKey:@"IFVTargetFile"];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.ifilevelox.mkdir" userInfo:info];
	[info release];
}

@end
