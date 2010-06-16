//
//  Cell.m
//  Fx
//
//  Created by alo on 31/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"


@implementation Cell

//@synthesize state;
//@synthesize lastState;
//@synthesize direction;
//@synthesize habitat;

-(float) state { return state; }
-(void) setState: (float) value { state = value; }

-(float) lastState { return lastState; }
-(void) setLastState: (float) value { lastState = value; }

-(float) direction { return direction; }
-(void) setDirection: (float) value { direction = value; }

-(float) phase { return phase; }
-(void) setPhase: (float) value { phase = value; }

-(float) velocity { return velocity; }
-(void) setVelocity: (float) value { velocity = value; }

-(int) coordX { return coordX; }
-(int) coordY { return coordY; }
-(int) coordZ { return coordZ; }

-(NSMutableArray*) habitat { return habitat; }
-(void) setHabitat: (NSMutableArray*) value { habitat = value; }

-(Cell*) init: (float) iState {
	self = [super init];
	state = iState;
	return self;
}

-(Cell*) initme: (float) iState: (int) cx: (int) cy: (int) cz
{
	self = [super init];
	state = iState;
	coordX = cx;
	coordY = cy;
	coordZ = cz;
	return self;
}

-(float) next: (float) add: (int) frameRateRatio {
	float val, avg;
	int i;
	avg = 0;
	if (habitat) {
		val = 0;
		for (i = 0; i < [habitat count]; i++)
		{
			val += [[habitat objectAtIndex: i] lastState];
		}
		avg = val / [habitat count];
		avg += add;
		if (avg > 1.0f) { avg -= 1.0f; }		

		velocity = (avg - lastState) / frameRateRatio;		
		[self setState: avg];
	}
	return avg;
}

-(float) next: (float) add: (NSArray*) weights: (int) frameRateRatio {
	float avg, wsum;
	int i;
	if ([weights count] != [habitat count])
	{
		return [self next: add: frameRateRatio];
	}
	else
	{
		avg = wsum = 0.0f;
		for (i=0;i<[habitat count];i++)
		{
			avg += [[habitat objectAtIndex: i] lastState] * [[weights objectAtIndex: i] floatValue];
			wsum += [[weights objectAtIndex: i] floatValue];
		}
		avg = avg / wsum;
		
//		if (avg > 0.5f) { avg += add; }
//		else { avg -= add; }
		avg += add;
		if (avg > 1.0f) { avg -= 1.0f; }		
		
		velocity = (avg - lastState) / frameRateRatio;	
//		avg = wrapf(avg, 0.0f, 1.0f);
		[self setState: avg];
		
		return avg;
	}
}

-(void) updatePhase {
	phase = wrapf(phase + velocity, 0.0f, 1.0f);
}

-(void) dealloc {
	[super dealloc];
}

@end
