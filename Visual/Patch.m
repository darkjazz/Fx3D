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
-(float) param { return param; }
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
-(void) setParam: (float) value { param = value; }

-(Patch*) init {
	self = [super init];
	active = false;
	red = green = blue = param = 1.0f;
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
		if (colormap == 0)
		{
			red = 0.0f * state;
			green = 0.6f * state;
			blue = 1.0f * state;
		}
		else
		{
			red = 0.0f * (1.0f - state);
			green = 0.6f * (1.0f - state);
			blue = 1.0f * (1.0f - state);
		}
	
	}
	else if (color == 2)
	{
		if (colormap == 0)
		{
			red = 0.4f * state;
			green = state;
			blue = 0.0f;		
		}
		else
		{
			red = 0.4f * (1.0f - state);
			green = (1.0f - state);
			blue = 0.0f;		
		}
	}
	else if (color == 3)
	{
		if (colormap == 0)
		{
			red = state;
			green = state;
			blue = 0.0f;		
		}
		else
		{
			red = 1.0f - state;
			green = 1.0f - state;
			blue = 0.0f;		
		}		
	}

	else if (color == 4)
	{
		if (colormap == 0)
		{
			red = 0.53f * state;
			green = 0.0f;
			blue = 0.77f * state;		
		}
		else
		{
			red = 0.53f * (1.0f - state);
			green = 0.0f;
			blue = 0.77f * (1.0f - state);		
		}		
	}
	
	if (alphamap == 0) { alpha = state; } else { alpha = 1.0f - state; }
	
	alpha *= alphahi; //map(alpha, alphalo, alphahi);
	
	
}

-(void) dealloc
{
	[super dealloc];
}

@end
