//
//  FxDraw.h
//  Fx
//
//  Created by alo on 17/01/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import  <OpenGL/OpenGL.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <GLUT/glut.h>
#include <OpenGL/glext.h>
#include "Cell.h"
#include "fxutil.h"
#include "Patch.h"

@interface FxDraw : NSObject {
	NSMutableDictionary * patches;
	int indexi, indexj, indexk, worldSize, frameRateRatio;
	float left, bottom, front, width, height, depth, red, green, blue, alpha, size;
	float state, gAlpha, halfscreen;
	Cell* currentCell;
	Patch* cp;
}


-(float) state;
-(void) setState: (float) value;

-(int) indexi;
-(void) setIndexi: (int) value;

-(int) indexj;
-(void) setIndexj: (int) value;

-(NSMutableDictionary*) patches;

-(void) setGlobalAlpha: (float) value;

-(void) setPatch: (NSString*) key: (int) on; 

-(void) dealloc;


- (FxDraw*) init;
- (void) drawCell: (Cell*) cell: (int) i: (int) j: (int) k: (int) ws: (int) fr;
- (void) kanji;
- (void) ringz;
- (void) wobble;
- (void) grid;
- (void) horizons;
- (void) blinds;
- (void) axial;
- (void) radial;
- (void) elastic;
- (void) mesh;

- (void) strokeRect;
- (void) strokeRect: (int) plane: (float) lineWidth;
- (void) drawRect;
- (void) fillRect;
- (void) fillRect: (int) plane;
- (void) drawAxialRect: (float) colN: (float) colE: (float) colS: (float) colW;
- (void) drawLine: (float) startx: (float) starty: (float) startz: 
	(float) endx: (float) endy: (float) endz: (float) lineWidth;
- (void) drawCircle: (float) cx: (float) cy: (float) r: (int) num_segments: (bool) fill;
- (void) drawCube;
- (void) strokeCube;
- (void) stroke3Dvertex;
- (void) drawVertex3f: (float) startx: (float) starty: (float) startz: (float) endx: (float) endy: (float) endz: (float) lineWidth ;
- (void) drawPoint: (float) x: (float) y: (float) z: (float) sz;
- (void) drawCubicCurve: (float[]) a: (float[]) b: (float[]) c: (float[]) d: (int) segs: (float) lineWidth; 

@end
