//
//  Patch.h
//  Fx
//
//  Created by tehis on 28/03/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Patch : NSObject {
	const char* name;
	bool active;
	int color; // 0 - grayscale, 1 - blue, 2 - green
	int colormap; // 0 - state, 1 - reverse
	int alphamap; // 0 - state, 1 - reverse
	float alphahi, alphalo;
	float colorhi, colorlo;
	float sizehi, sizelo;
	float size, red, green, blue, alpha, left, bottom, param;
	NSMutableDictionary * events;
}

-(Patch*) init;
-(bool) active;
-(float) size;
-(float) red;
-(float) green;
-(float) blue;
-(float) alpha;
-(float) bottom;
-(float) left;
-(float) param;
-(NSMutableDictionary*) events;

-(void) setActive: (bool) value;
-(void) setAlpha: (float) value;
-(void) setSize: (float) value;
-(void) setColor: (int) value;
-(void) setColormap: (int) value;
-(void) setAlphamap: (int) value;
-(void) setAlphahi: (float) value;
-(void) setAlphalo: (float) value;
-(void) setColorhi: (float) value;
-(void) setColorlo: (float) value;
-(void) setSizehi: (float) value;
-(void) setSizelo: (float) value;
-(void) setParam: (float) value;

-(void) mapValues: (int) i: (int) j: (float) state;

-(void) dealloc;

@end
