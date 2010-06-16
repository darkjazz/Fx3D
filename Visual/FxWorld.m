//
//  FxWorld.m
//  Fx
//
//  Created by alo on 31/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FxWorld.h"


@implementation FxWorld

-(NSMutableArray*) cells { return cells; }
-(void) setCells: (NSMutableArray*) value { cells = value; }

-(int) size { return size; }
-(void) setSize: (int) value { size = value; }

-(NSArray*) weights { return weights; }
-(void) setWeights: (NSArray*) value { weights = value; }

-(NSArray*) pollIndices { return pollIndices; }

-(FxWorld*) init: (int) s: (Habitat*) h: (NSMutableArray*) sd {
	self = [super init]; 
	habitat = h;
	size = s;
	seed = sd;
	[self initCells];
//	[self setHabitat];
	return self;
}

-(FxWorld*) init: (int) s: (Habitat*) h: (NSMutableArray*) sd: (NSArray*) wghts {
	self = [super init]; 
	habitat = h;
	size = s;
	seed = sd;
	[self setWeights: wghts];
	[self initCells];
	[self setHabitat];
	[self setPollIndices: NULL];
	return self;
}

-(void) setHabitat {
	int h, i, j, ind;
	int indx, indy, indz;
	i = 0;
	Cell* cell;
	NSMutableArray* col;
	NSMutableArray* row;
	NSMutableArray* coords;
	
	for (h = 0; h < [cells count]; h++)
	{
		col = [cells objectAtIndex: h];
		for (i = 0; i < [col count]; i++)
		{
			row = [col objectAtIndex: i];
			for (j = 0;j < [row count]; j++)
			{
				cell = [row objectAtIndex: j];
				[cell setHabitat: [NSMutableArray new]];
				for (ind = 0; ind < [[habitat indices] count]; ind++)
				{
					coords = [[habitat indices] objectAtIndex: ind];
					indx = [[coords objectAtIndex: 0] intValue];
					indy = [[coords objectAtIndex: 1] intValue];
					indz = [[coords objectAtIndex: 2] intValue];
					indx = wrapi(h + indx, 0, size - 1);
					indy = wrapi(i + indy, 0, size - 1);
					indz = wrapi(j + indz, 0, size - 1);
					[[cell habitat] addObject: [[[cells objectAtIndex: indx] objectAtIndex: indy] objectAtIndex: indz]];				
				}
			}
		}
	}
			
}

-(void) initCells {
	int h, i, j;
	int x, y, z;
	NSArray* loc;
	Cell* currentCell;
	NSMutableArray* newcol;
	NSMutableArray* newrow;
	cells = [NSMutableArray new];
	for (h = 0; h < size; h++)
	{
		newcol = [NSMutableArray new];
		for (i = 0; i < size; i++) {
			newrow = [NSMutableArray new];
			for (j = 0; j < size; j++) {
				[newrow addObject: [[[Cell new] initme: 0.0: h: i: j] retain]];
			}
			[newcol addObject: newrow];
		}
		[cells addObject: newcol];
	}
	for (i = 0; i < [seed count]; i++) {
		loc = [seed objectAtIndex: i];
		x = [[loc objectAtIndex: 0] intValue];
		y = [[loc objectAtIndex: 1] intValue];
		z = [[loc objectAtIndex: 2] intValue];
		currentCell = [[[cells objectAtIndex: x] objectAtIndex: y] objectAtIndex: z];
		[currentCell setState: [[loc objectAtIndex: 3] floatValue]];
	}
}

-(void) setStates {
	int i, j;
	Cell * cell;
	for (i = 0; i < [cells count]; i++)
	{
		for (j = 0; j < [[cells objectAtIndex: i] count]; j++)
		{
			cell = [[cells objectAtIndex: i] objectAtIndex: j];
			[cell setLastState: [cell state]];
		}
	}
}

-(void) prepareNext {
	int h, i, j;
	Cell * cell;
	NSMutableArray * col;
	NSMutableArray * row;
	for (h = 0; h < [cells count]; h++)
	{
		col = [cells objectAtIndex: h];
		for (i = 0; i < [col count]; i++)
		{
			row = [col objectAtIndex: i];
			for (j = 0; j < [row count]; j++)
			{
				cell = [row objectAtIndex: j];
				[cell setLastState: [cell state]];
			}
		}
	}

}

-(void) setPollIndices: (NSMutableArray*) value 
{
	int step, offset, i, j, k;
	
	if (value == NULL)
	{
	
		step = (int)(size / 4);
		offset = 2;
		pollIndices = [NSMutableArray new];
		for (i = offset; i < size; i += step)
		{
			for (j = offset; j < size; j += step)
			{
				for (k = offset; k < size; k += step)
				{
					[pollIndices addObject:[NSArray arrayWithObjects:
											[NSNumber numberWithInt:i],
											[NSNumber numberWithInt:j],
											[NSNumber numberWithInt:k],
											nil
											]
					];
				}
			}
		}
	}
	else
	{
		pollIndices = value;
	}
}

-(int) pollIndex { return pollIndex; }

-(void) nextPollIndex { if (pollIndex == [pollIndices count] - 1) { pollIndex = 0; } else { pollIndex++; } }

-(void) dealloc {
	int h, i, j;
	Cell * cell;
	NSMutableArray * col;
	NSMutableArray * row;

	for (h = 0; h < [cells count]; h++)
	{
		col = [cells objectAtIndex: h];
		for (i = 0; i < [col count]; i++)
		{
			row = [col objectAtIndex: i];
			for (j = 0; j < [row count]; j++)
			{
				cell = [[cells objectAtIndex: i] objectAtIndex: j];
				[cell release];
				[cell release];
			}
			[row release];
		}
		[col release];
	}

	[cells release];
	
	for (i = 0; i < [weights count]; i++)
	{
		[[weights objectAtIndex: i] release];
	}
	
	for (i = 0; i < [pollIndices count]; i++)
	{
		NSArray * items;
		items = [pollIndices objectAtIndex: i];
		for (j = 0; j < [items count]; j++)
		{
			[[items objectAtIndex: j] release];
		}
		[items release];
	}
	
	[pollIndices release];
	
//	[weights release];
	
	[super dealloc];
	
}

@end
