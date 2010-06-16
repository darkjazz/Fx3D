//
//  Habitat.m
//  Fx
//
//  Created by alo on 31/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Habitat.h"


@implementation Habitat

//@synthesize indices;
//@synthesize includeCell;
//@synthesize numNeighbors;
//@synthesize range;

-(NSMutableArray*) indices { return indices; }
-(void) setIndices: (NSMutableArray*) value { indices = value; }

-(BOOL) includeCell { return includeCell; }
-(void) setIncludeCell: (BOOL) value { includeCell = value; }

-(int) numNeighbors { return numNeighbors; }
-(void) setNumNeighbors: (int) value { numNeighbors = value; }

-(int) range { return range; }
-(void) setRange: (int) value { range = value; }

-(Habitat*) init {
    self = [super init];
    return self;
}

-(Habitat*) initMoore: (int) radius {
	int size, i, j, k, ix, iy, iz;
	[self init];
	size = radius*2+1;
	numNeighbors = (size*size-1);
	range = radius;
	indices = [NSMutableArray new];
	for (i = 0; i < size; i++) {
		for (j = 0; j < size; j++) {
			for (k = 0; k < size; k++) {
				ix = j - (int)(size / 2);
				iy = i - (int)(size / 2);
				iz = k - (int)(size / 2);
				if (!(iy == 0 && ix == 0 && iz == 0)) {
					[indices addObject: [NSMutableArray arrayWithObjects: [NSNumber numberWithInt:ix], [NSNumber numberWithInt:iy], [NSNumber numberWithInt: iz], nil]];
				}
			}
		}
	}
	return self;
}

-(Habitat*) initNeumann: (int) radius {
	int size;
	[self init];
	size = radius*2+1;
	numNeighbors = 4 * radius;
	range = radius;
	indices = [NSMutableArray new];
	
	[indices addObject: [NSMutableArray arrayWithObjects: [NSNumber numberWithInt:-1], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil]];
	[indices addObject: [NSMutableArray arrayWithObjects: [NSNumber numberWithInt:0], [NSNumber numberWithInt:-1], [NSNumber numberWithInt:0], nil]];
	[indices addObject: [NSMutableArray arrayWithObjects: [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:-1], nil]];
	[indices addObject: [NSMutableArray arrayWithObjects: [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil]];
	[indices addObject: [NSMutableArray arrayWithObjects: [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:0], nil]];
	[indices addObject: [NSMutableArray arrayWithObjects: [NSNumber numberWithInt:1], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil]];
	
//	for (i = 0; i < size; i++) {
//		for (j = 0; j < size; j++) {
//			for (k = 0; k < size; k++)
//			{
//				if (i == range || j == range || k == range) {
//					[indices addObject: [NSMutableArray arrayWithObjects: [NSNumber numberWithInt:i], [NSNumber numberWithInt:j], [NSNumber numberWithInt:k], nil]];
//				}
//			}
//		}
//	}
	return self;
}

-(void) dealloc {
	[indices release];
	[super dealloc];
}

@end
