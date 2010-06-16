//
//  Habitat.h
//  Fx
//
//  Created by alo on 31/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Habitat : NSObject {
	NSMutableArray *indices;
	BOOL includeCell;
	int numNeighbors;
	int range; 
}

////@property (retain) NSMutableArray* indices;
////@property BOOL includeCell;
////@property int numNeighbors;
////@property int range;

-(NSMutableArray*) indices;
-(void) setIndices: (NSMutableArray*) value;

-(BOOL) includeCell;
-(void) setIncludeCell: (BOOL) value;

-(int) numNeighbors;
-(void) setNumNeighbors: (int) value;

-(int) range;
-(void) setRange: (int) value;


-(Habitat*) init;
-(Habitat*) initMoore: (int) radius;
-(Habitat*) initNeumann: (int) radius;
-(void) dealloc;


@end
