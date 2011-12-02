//
//  FxOSC.m
//  Fx
//
//  Created by alo on 21/01/2009.
//  Copy_i__t 2009
//

#import "FxOSC.h"

int done = 0;

float alpha = 0.0f;
float clear = 0.0f;
float add = 0.02;

float transx = 0.0f;
float transy = 0.0f;
float transz = -12.0f;

float rotX = 0.0f;
float rotY = 0.0f;
float rotZ = 0.0f;
float angle = 0.0f;

int frameRate = 4;
int bufferRate = 72;
int freeze = 0;

int patch = 0;
int cmd = 0;
float value = 0.0f;

int reset = 0;		// 0 - no action, 1 - reset world, 2 - change weights
int seed = 0;		// 0 - rect, 1 - randRect
int habitat = 0;	// 0 - moore, 1 - neumann
int rad = 1;		// radius
// seed area
int s_left = 4;		
int s_bottom = 4;
int s_front = 7;
int s_wid = 8;
int s_hgt = 8;
int s_dep = 1;
//weights
float lbb, lbm, lbf, lmb, lmm, lmf, ltb, ltm, ltf;
float mbb, mbm, mbf, mmb, mmf, mtb, mtm, mtf;
float rbb, rbm, rbf, rmb, rmm, rmf, rtb, rtm, rtf;

bool setpoll = false;
int *pollindex;
int pollsize;

//cell
bool setcell;
int posx, posy, posz;
float state;

@implementation FxOSC

- (id) initWithAddress: (const char*) ip: (const char*) port: (FxDraw*) draw
{
	self = [super init];
	scIP = ip;
	scPort = port;
	addr = lo_address_new(scIP, scPort);
	dw = draw;
	done = 0;
	return self;
}

- (float) getAlpha { return alpha; }
- (float) getClear { return clear; }

- (float) getTransX { return transx; }
- (float) getTransY { return transy; }
- (float) getTransZ { return transz; }

- (float) getRotateX { return rotX; }
- (float) getRotateY { return rotY; }
- (float) getRotateZ { return rotZ; }
- (float) getAngle { return angle; }

- (int) getFrameRate { return frameRate; }
- (int) getBufferRate { return bufferRate; }
- (int) getFreeze { return freeze; } 

- (int) getDone { return done; }

- (int) getReset { return reset; }
- (int) getSeed { return seed; }
- (int) getHabitat { return habitat; }
- (int) getRadius { return rad; }

- (int) getLeft { return s_left; }
- (int) getBottom { return s_bottom; }
- (int) getFront { return s_front; }
- (int) getWidth { return s_wid; }
- (int) getHeight { return s_hgt; }
- (int) getDepth { return s_dep; }

- (float) add { return add; }

- (bool) setCell { return setcell; }
- (bool) setPoll { return setpoll; }

- (NSArray*) getWeights
{
	return [[NSArray arrayWithObjects:
		[NSNumber numberWithFloat: lbb],
		[NSNumber numberWithFloat: lbm],
		[NSNumber numberWithFloat: lbf],
		[NSNumber numberWithFloat: lmb],
		[NSNumber numberWithFloat: lmm],
		[NSNumber numberWithFloat: lmf],
		[NSNumber numberWithFloat: ltb],
		[NSNumber numberWithFloat: ltm],
		[NSNumber numberWithFloat: ltf],

		[NSNumber numberWithFloat: mbb],
		[NSNumber numberWithFloat: mbm],
		[NSNumber numberWithFloat: mbf],
		[NSNumber numberWithFloat: mmb],
		[NSNumber numberWithFloat: mmf],
		[NSNumber numberWithFloat: mtb],
		[NSNumber numberWithFloat: mtm],
		[NSNumber numberWithFloat: mtf],

		[NSNumber numberWithFloat: rbb],
		[NSNumber numberWithFloat: rbm],
		[NSNumber numberWithFloat: rbf],
		[NSNumber numberWithFloat: rmb],
		[NSNumber numberWithFloat: rmm],
		[NSNumber numberWithFloat: rmf],
		[NSNumber numberWithFloat: rtb],
		[NSNumber numberWithFloat: rtm],
		[NSNumber numberWithFloat: rtf],

		nil
	] retain];
}

- (NSArray*) getCell
{
	setcell = false;
	return [NSArray arrayWithObjects: 
		[NSNumber numberWithInt: posx ], 
		[NSNumber numberWithInt: posy ],
		[NSNumber numberWithInt: posz ],
		[NSNumber numberWithFloat: state ],
		nil
		];
}


- (NSMutableArray*) getPollIndices
{
	int i;
	setpoll = false;
	pollIndices = [NSMutableArray new];
	for (i = 1; i <= pollsize; i+=3)
	{
		[pollIndices addObject: [NSArray arrayWithObjects:
					[NSNumber numberWithInt: pollindex[i]],	
					[NSNumber numberWithInt: pollindex[i+1]],
					[NSNumber numberWithInt: pollindex[i+2]],
					nil
			]
		 ];
	}
	free(pollindex);
	return pollIndices;
}

- (void) resetDone { reset = 0; }

- (void) sendMessage: (float) avg: (float) sdev: (float) albf: (float) arbf: (float) arbb: 
	(float) albb: (float) altf: (float) artf: (float) artb: (float) altb
{
	lo_send(addr, "/fx/globals", "ffffffffff", avg, sdev, albf, arbf, arbb, albb, altf, artf, artb, altb);
}

- (void) sendMessage: (NSMutableArray*) states {
	int i;
	float *arr;
	
	arr = malloc(sizeof(float) * (int)[states count]);
	
	for (i = 0; i < [states count]; i++)
	{
		arr[i] = [[states objectAtIndex: i] floatValue];
	}
	
	lo_blob data = lo_blob_new(sizeof(float) * (int)[states count], arr);
	lo_send(addr, "/fx/states", "b", data);
	
	free(arr);
	
}

-(void) sendMessage: (float*) states: (int) size {
	
//	int i;
//	float *arr;
	
//	arr = malloc(sizeof(float) * (int)size);
	
//	for (i = 0; i < size; i++) {
//		arr[i] = states[i];
//	}

	lo_blob data = lo_blob_new(sizeof(float) * size, states);
	lo_send(addr, "/fx/states", "b", data);
	
//	free(arr);

}

- (void) sendTrigger: (int) x: (int) y: (int) z: (float) phase
{
	lo_send(addr, "/fx/trigger", "iiif", x, y, z, phase);
}

- (void) sendRenew 
{
	lo_send(addr, "/fx/renew", "i", 0);
}

- (void) sendPhase: (int) phase
{
	lo_send(addr, "/fx/phase", "i", phase);
}

- (void) startListener
{
	thread = lo_server_thread_new("7770", error);
	lo_server_thread_add_method(thread, "/fx/settings", "ffffffffffii", setting_handler, NULL);
	lo_server_thread_add_method(thread, "/fx/cell", "iiif", cell_handler, NULL);	
	lo_server_thread_add_method(thread, "/fx/patch", "iif", patch_handler, NULL);
	lo_server_thread_add_method(thread, "/fx/world", "iiiiiiiiiiffffffffffffffffffffffffff", reset_handler, NULL);
	lo_server_thread_add_method(thread, "/fx/poll", NULL, poll_handler, NULL);
	lo_server_thread_add_method(thread, "/fx/freeze", "i", freeze_handler, NULL);
	lo_server_thread_add_method(thread, "/fx/quit", "i", quit_handler, NULL);
	lo_server_thread_start(thread);
	
}

- (void) stopListener
{
	lo_server_thread_free(thread);
}

- (void) setPatch
{
	Patch* p;
	if (patch == 0) { p = [[dw patches] objectForKey: @"kanji"]; }
	else if (patch == 1) { p = [[dw patches] objectForKey: @"ringz"]; }
	else if (patch == 2) { p = [[dw patches] objectForKey: @"wobble"]; }
	else if (patch == 3) { p = [[dw patches] objectForKey: @"grid"]; }
	else if (patch == 4) { p = [[dw patches] objectForKey: @"horizons"]; }
	else if (patch == 5) { p = [[dw patches] objectForKey: @"blinds"]; }
	else if (patch == 6) { p = [[dw patches] objectForKey: @"axial"]; }
	else if (patch == 7) { p = [[dw patches] objectForKey: @"radial"]; }
	else if (patch == 8) { p = [[dw patches] objectForKey: @"elastic"]; }
	else if (patch == 9) { p = [[dw patches] objectForKey: @"mesh"]; }
	else if (patch == 10) { p = [[dw patches] objectForKey: @"dimensions"]; }
		
	if (cmd == 0) { [p setActive: (bool)value]; }
	else if (cmd == 1) { [p setColor: (int)value]; }
	else if (cmd == 2) { [p setColormap: (int)value]; }
	else if (cmd == 3) { [p setAlphamap: (int)value]; }
	else if (cmd == 4) { [p setColorlo: value]; }
	else if (cmd == 5) { [p setColorhi: value]; }
	else if (cmd == 6) { [p setAlphalo: value]; }
	else if (cmd == 7) { [p setAlphahi: value]; }
	else if (cmd == 8) { [p setSizelo: value]; }
	else if (cmd == 9) { [p setSizehi: value]; }
	else if (cmd == 10) { [p setParam: value]; }
	
}

@end

int setting_handler(const char *path, const char *types, lo_arg **argv, int argc,
					void *data, void *user_data)
{
	alpha = argv[0]->f;
	clear = argv[1]->f;
	add = argv[2]->f;
	transx = argv[3]->f;
	transy = argv[4]->f;
	transz = argv[5]->f;
	angle = argv[6]->f;
	rotX = argv[7]->f;
	rotY = argv[8]->f;
	rotZ = argv[9]->f;
	frameRate = argv[10]->i;
	bufferRate = argv[11]->i;
	return 0;
}

int cell_handler(const char *path, const char *types, lo_arg **argv, int argc,
	void *data, void *user_data)
{
	setcell = true;
	posx = argv[0]->i;
	posy = argv[1]->i;
	posz = argv[2]->i;
	state = argv[3]->f;
	return 0;
}

int patch_handler(const char *path, const char *types, lo_arg **argv, int argc,
	void *data, void *user_data)
{
	patch = argv[0]->i;
	cmd = argv[1]->i;
	value = argv[2]->f;
	return 0;
}

int reset_handler(const char *path, const char *types, lo_arg **argv, int argc,
	void *data, void *user_data)
{
	reset = argv[0]->i;
	seed = argv[1]->i;
	habitat = argv[2]->i;
	rad = argv[3]->i;
	s_left = argv[4]->i;
	s_bottom = argv[5]->i;
	s_front = argv[6]->i;
	s_wid = argv[7]->i;
	s_hgt = argv[8]->i;
	s_dep = argv[9]->i;
	
	lbb = argv[10]->f; 
	lbm = argv[11]->f;
	lbf = argv[12]->f;
	lmb = argv[13]->f;
	lmm = argv[14]->f;
	lmf = argv[15]->f;
	ltb = argv[16]->f;
	ltm = argv[17]->f;
	ltf = argv[18]->f;
	
	mbb = argv[19]->f;
	mbm = argv[20]->f;
	mbf = argv[21]->f;
	mmb = argv[22]->f;
	mmf = argv[23]->f;
	mtb = argv[24]->f;
	mtm = argv[25]->f;
	mtf = argv[26]->f;
	
	rbb = argv[27]->f; 
	rbm = argv[28]->f; 
	rbf = argv[29]->f; 
	rmb = argv[30]->f; 
	rmm = argv[31]->f; 
	rmf = argv[32]->f; 
	rtb = argv[33]->f; 
	rtm = argv[34]->f; 
	rtf = argv[35]->f;
	
	return 0;
}

int poll_handler(const char *path, const char *types, lo_arg **argv, int argc,
				 void *data, void *user_data)
{
	int i;
	setpoll = true;
	pollsize = argv[0]->i;
	pollindex = malloc(sizeof(int) * pollsize);
	for (i = 1; i <= pollsize; i++) {
		pollindex[i] = argv[i]->i; 
	}
	return 0;
}

int freeze_handler(const char *path, const char *types, lo_arg **argv, int argc,
				 void *data, void *user_data)
{
	freeze = argv[0]->i;
	return 0;
}


int quit_handler(const char *path, const char *types, lo_arg **argv, int argc, 
	void *data, void *user_data)
{
	done = 1;
	return 0;
}

void error (int num, const char *msg, const char *path)
{
	printf("liblo server %d error in path %s: %s\n", num, path, msg);
	fflush(stdout);
}

