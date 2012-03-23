//
//  main.m
//  Fx
//
//  Created by tehis on 17/03/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FxView.h"

#define DEBUG				TRUE
#define FULLSCREEN			FALSE

#define FRAME_RATE			18

#define WIDTH				800
#define HEIGHT				600

//#define WIDTH				1024
//#define HEIGHT			768

#define FULLWIDTH			1440
#define FULLHEIGHT			900

@interface App : NSApplication
	FxView* window;
	NSTimer* timer;
@end

@implementation App
- (id) init
{
	self = [super init];

	[self setDelegate: self];
	
	return self;
}

- (void) dealloc
{
	[timer invalidate];
	[timer release];

	[window release];
	
	[super dealloc];
}

- (void) applicationWillFinishLaunching: (NSNotification*) notification
{
	int width, height;
	if (FULLSCREEN)
	{
		width = FULLWIDTH;
		height = FULLHEIGHT;
	}
	else
	{
		width = WIDTH;
		height = HEIGHT;
	}
	if (DEBUG)
	{
		window = [[FxView alloc] initWithFrame: NSMakeRect(0,0,width,height)];
	}
	else
	{
		window = [[FxView alloc] initWithFrame: NSMakeRect(1440,0,width,height)];
	}
}

- (void) update : (id) object
{
	[window drawFrame];
	if ([window done] == 1) 
	{
		[super terminate: self];
	}
}

- (void) applicationDidFinishLaunching: (NSNotification*) notification
{
	timer = [[NSTimer scheduledTimerWithTimeInterval: (1.0f / FRAME_RATE) target: self selector:@selector(update:) userInfo:self repeats:YES] retain];
	[window makeKeyAndOrderFront: nil];
}

	
@end

int main(int argc, char *argv[])
{
    return NSApplicationMain(argc,  (const char **) argv);
}
