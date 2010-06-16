//
//  Seeds.h
//  Fx
//
//  Created by alo on 01/01/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "fxutil.h"


@interface Seeds : NSObject {
	NSMutableArray * indices;
}

-(NSMutableArray *) point: (int) x: (int) y;
-(NSMutableArray *) fillRect: (int) left: (int) top: (int) width: (int) length;
-(NSMutableArray *) rect: (int) left: (int) top: (int) width: (int) length;
-(NSMutableArray *) randCube: (int) left: (int) top: (int) front: (int) width: (int) length: (int) depth;
-(NSMutableArray *) wireCube: (int) left: (int) bottom: (int) front: (int) width: (int) height: (int) depth;
-(NSMutableArray *) fillCube: (int) left: (int) bottom: (int) front: (int) width: (int) height: (int) depth;
-(void) dealloc;

@end
