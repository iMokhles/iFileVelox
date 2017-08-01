//
// IFVServer.m
// Unbox
//
// Created by Árpád Goretity on 07/11/2011
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "IFVServer.h"

int main(int argc, char *argv[])
{
	NSLog(@"Starting file server");
	NSLog(@"CHDIR: %i", (chdir("/")));
	if ((chdir("/")) < 0)
		return 1;

	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	close(STDERR_FILENO);

	// this is to keep various Foundation classes happy
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	// actually start the server
	IFVDelegate *delegate = [[IFVDelegate alloc] init];
	NSDate *now = [[NSDate alloc] init];

	// set up a timer to keep the run loop alive
	// we seem to need to add a non-NULL target and selector to kepp the timer running
	NSTimer *timer = [[NSTimer alloc] initWithFireDate:now interval:60.0 target:delegate selector:@selector(IFV_dummy) userInfo:NULL repeats:YES];
	[now release];
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
	[runLoop run];

	// the following will be never reached
	[timer release];
	[delegate release];
	[pool release];

	return 0;
}
