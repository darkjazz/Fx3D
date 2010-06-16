//
//  Patch.m
//  Fx
//
//  Created by tehis on 28/03/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Patch.h"


@implementation Patch

-(bool) active { return active; }
-(float) size { return size; }
-(float) red { return red; }
-(float) green { return green; }
-(float) blue { return blue; }
-(float) alpha { return alpha; }
-(float) left { return left; }
-(float) bottom { return bottom; }
-(float) scale { return scale; }
-(NSMutableDictionary*) events { return events; }

-(void) setActive: (bool) value { active = value; }
-(void) setAlpha: (float) value { alpha = value; }
-(void) setSize: (float) value { size = value; }
-(void) setColor: (int) value { color = value; }
-(void) setColormap: (int) value { colormap = value; }
-(void) setAlphamap: (int) value { alphamap = value; }
-(void) setAlphahi: (float) value { alphahi = value; }
-(void) setAlphalo: (float) value { alphalo = value; }
-(void) setColorhi: (float) value { colorhi = value; }
-(void) setColorlo: (float) value { colorlo = value; }
-(void) setSizehi: (float) value { sizehi = value; }
-(void) setSizelo: (float) value { sizelo = value; }
-(void) setScale: (float) value { scale = value; }

-(Patch*) init {
	self = [super init];
	active = false;
	red = green = blue = scale = 1.0f;
	alpha = 0.0f;
	color = 0; colormap = 0; alphamap = 0;
	alphalo = colorlo = sizelo = 0.0f;
	alphahi = colorhi = sizehi = 0.0f;
	events = [NSMutableDictionary new];
	return self;
}

-(void) mapValues: (int) i: (int) j: (float) state
{

	if (color == 0)
	{
		if (colormap == 0) { red = green = blue = state; /*map(state, colorlo, colorhi);*/ }
		else { red = green = blue = 1.0f - state; /*map(1.0f - state, colorlo, colorhi); */ }	
	}
	else if (color == 1)
	{
		red = 0.0f;
		green = 0.6f;
		blue = 1.0f;
	
	}
	else if (color == 2)
	{
		red = 0.4f;
		green = 1.0f;
		blue = 0.0f;		
	}
	
	if (alphamap == 0) { alpha = state; } else { alpha = 1.0f - state; }
	
	alpha *= alphahi; //map(alpha, alphalo, alphahi);
	
	
}

-(void) dealloc
{
	[super dealloc];
}

@end
