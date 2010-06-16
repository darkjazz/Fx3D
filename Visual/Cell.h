//
//  Cell.h
//  Fx
//
//  Created by alo on 31/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "fxutil.h"

@interface Cell : NSObject {
	float state;
	float lastState;
	int direction;
	float phase;
	float velocity;
	int coordX;
	int coordY; 
	int coordZ;
	NSMutableArray *habitat;
}

-(float) state;
-(void) setState: (float) value;

-(float) lastState;
-(void) setLastState: (float) value;

-(float) direction;
-(void) setDirection: (float) value;

-(float) phase;
-(void) setPhase: (float) value;

-(float) velocity;
-(void) setVelocity: (float) value;

-(int) coordX;
-(int) coordY;
-(int) coordZ;

-(NSMutableArray*) habitat;
-(void) setHabitat: (NSMutableArray*) value;

-(Cell*) init: (float) iState;
-(Cell*) initme: (float) iState: (int) cx: (int) cy: (int) cz;
-(float) next: (float) add: (int) frameRateRatio;
-(float) next: (float) add: (NSArray*) weights: (int) frameRateRatio;
-(void) updatePhase;
-(void) dealloc;

@end
