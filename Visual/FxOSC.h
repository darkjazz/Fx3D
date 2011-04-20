//
//  FxOSC.h
//  Fx
//
//  Created by alo on 21/01/2009.
//  Copy_i__t 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "lo/lo.h"
#import "FxDraw.h"
#import "Patch.h"

int setting_handler(const char *path, const char *types, lo_arg **argv, 
	int argc, void *data, void *user_data);

int patch_handler(const char *path, const char *types, lo_arg **argv, 
	int argc, void *data, void *user_data);

int reset_handler(const char *path, const char *types, lo_arg **argv, 
	int argc, void *data, void *user_data);

int cell_handler(const char *path, const char *types, lo_arg **argv, int argc,
	void *data, void *user_data);

int poll_handler(const char *path, const char *types, lo_arg **argv, int argc,
	void *data, void *user_data);

int freeze_handler(const char *path, const char *types, lo_arg **argv, int argc,
	void *data, void *user_data);

void error(int num, const char *m, const char *path);

int quit_handler(const char *path, const char *types, lo_arg **argv, int argc, 
	void *data, void *user_data);

@interface FxOSC : NSObject {
	const char * scIP;
	const char * scPort;
	lo_address addr;
	lo_server_thread thread;
	FxDraw * dw;
	NSMutableArray * pollIndices;
}

- (id) initWithAddress: (const char*) ip: (const char*) port: (FxDraw*) draw;
- (void) sendMessage: (float) avg: (float) sdev: (float) albf: (float) arbf: (float) arbb: 
	(float) albb: (float) altf: (float) artf: (float) artb: (float) altb;
- (void) sendMessage: (NSMutableArray*) states;
- (void) sendMessage: (float*) states: (int) size;
- (void) sendTrigger: (int) x: (int) y: (int) z: (float) phase;
- (void) sendRenew;
- (void) sendPhase: (int) phase;
- (void) startListener;
- (void) stopListener;
- (float) getAlpha;
- (float) getClear;
- (int) getDone;
- (void) setPatch;

- (void) resetDone;
- (int) getReset;
- (int) getSeed;
- (int) getHabitat;
- (int) getRadius;

- (int) getLeft;
- (int) getBottom;
- (int) getFront;
- (int) getWidth;
- (int) getHeight;
- (int) getDepth;

- (float) getRotateX;
- (float) getRotateY;
- (float) getRotateZ;
- (float) getAngle;

- (float) getTransX;
- (float) getTransY;
- (float) getTransZ;

- (int) getFrameRate;
- (int) getBufferRate;
- (int) getFreeze;

- (float) add;

- (bool) setCell;
- (bool) setPoll;

- (NSArray*) getWeights;

- (NSArray*) getCell;

- (NSMutableArray*) getPollIndices;

@end
