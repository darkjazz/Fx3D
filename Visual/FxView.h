//
//  FxView.h
//  Fx
//
//  Created by alo on 02/01/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import  <OpenGL/OpenGL.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <OpenGL/glext.h>
#include "FxWorld.h"
#include "FxDraw.h"
#import "FxOSC.h"

#define BITS_PER_PIXEL          32.0
#define DEPTH_SIZE              32.0
#define WORLD_SIZE				16
#define SC_ADDRESS				"127.0.0.1" // "192.168.0.102"
#define SC_PORT					"57120"

@interface FxView : NSWindow {

	bool first;
	NSTimer *time;
	FxWorld *world;
	FxDraw *draw;
	bool run;
	FxOSC * oscer;
	float avgState, stdDev;
	float bg, zoom, glAlpha, rAng, rX, rY, rZ;
	int done, frameRateRatio, bufferRateRatio;
	bool renew, enableMessage, renewBuffer;
	int phase, bufferPhase;
	NSArray * pollCellCoords;
	NSMutableArray * pollCellValues;
	NSMutableArray * oscValues;	
}

+ (NSOpenGLPixelFormat*) basicPixelFormat;

- (int) done;

- (void) initWorld;
- (void) resetWorld;
- (void) drawCells;
- (void) drawFrame;

- (void) prepareOpenGL;

- (id) initWithFrame: (NSRect) frameRect;

- (void) dealloc;

@end
