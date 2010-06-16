//
//  FxWorld.h
//  Fx
//
//  Created by alo on 31/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Habitat.h"
#import "Seeds.h"
#import "Cell.h"
#include "fxutil.h"

@interface FxWorld : NSObject {
	NSMutableArray * cells;
	Habitat * habitat;
	int size;
	NSMutableArray * seed;
	NSArray * weights;
	NSMutableArray * pollIndices;
	int pollIndex;
}

//@property (retain) NSMutableArray * cells;
//@property int size;
//@property (retain) NSArray * weights;

-(NSMutableArray*) cells;
-(int) size;
-(NSArray*) weights;
-(NSArray*) pollIndices;
-(int) pollIndex;

-(void) setCells: (NSMutableArray*) value;
-(void) setSize: (int) value;
-(void) setWeights: (NSArray*) value;


-(FxWorld*) init: (int) s: (Habitat*) h: (NSMutableArray*) sd;
-(FxWorld*) init: (int) s: (Habitat*) h: (NSMutableArray*) sd: (NSArray*) wghts;
-(void) setHabitat;
-(void) initCells;
-(void) setStates;
-(void) setPollIndices: (NSMutableArray*) value;
-(void) prepareNext;
-(void) nextPollIndex;

@end
