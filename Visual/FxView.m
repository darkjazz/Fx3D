//
//  FxView.m
//  Fx
//
//  Created by alo on 02/01/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FxView.h"

@implementation FxView

+ (NSOpenGLPixelFormat*) basicPixelFormat
{
    NSOpenGLPixelFormatAttribute attributes [] = {
        NSOpenGLPFAWindow,
        NSOpenGLPFADoubleBuffer,	// double buffered
        NSOpenGLPFADepthSize, (NSOpenGLPixelFormatAttribute)16, // 16 bit depth buffer
        (NSOpenGLPixelFormatAttribute)nil
    };
    return [[[NSOpenGLPixelFormat alloc] initWithAttributes:attributes] autorelease];
}

- (void) prepareOpenGL {
	glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
//	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
	glClearDepth(1.0f);
	glDepthFunc(GL_LEQUAL);
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_BLEND);
	glEnable(GL_LINE_SMOOTH);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
	glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
	glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

}

- (void) reshape
{
    float aspect;
    NSSize bound = [self frame].size;
    aspect = bound.width / bound.height;
    // change the size of the viewport to the new width and height
    // this controls the affine transformation of x and y from normalized device 
    // coordinates to window coordinates (from the OpenGl 1.1 reference book, 2nd ed)
    glViewport(0, 0, bound.width, bound.height);
    glMatrixMode(GL_PROJECTION);
    // you must reload the identity before this or you'll lose your picture
    glLoadIdentity();
    gluPerspective(45.0f, (GLfloat)aspect, 0.1f,100.0f);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

- (void) drawFrame {

	glLoadIdentity();
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	[self drawCells];
	[[NSOpenGLContext currentContext] flushBuffer];
	
}

- (void) initWorld {
	Habitat * habitat;
	NSMutableArray * seed;
	NSArray * weights;
	bool isMoore;
	isMoore = true;
	if (isMoore)
	{
		habitat = [[Habitat new] initMoore: 1];
	}
	else
	{
		habitat = [[Habitat new] initNeumann: 1];
	}

	seed = [[Seeds new] wireCube: 6:6:6:4:4:4];
	
	if (isMoore)
	{
		
		weights = [
			[NSArray arrayWithObjects: 
				[NSNumber numberWithFloat: 1.0f],	//	tlf	(Top-Left-Front)
				[NSNumber numberWithFloat: 1.0f],	//	tmf	(Top-Mid-Front)
				[NSNumber numberWithFloat: 1.0f],	//	trf	(Top-Right-Front)
				[NSNumber numberWithFloat: 1.0f],	//	tlm	(Top-Left-Mid)
				[NSNumber numberWithFloat: 1.0f],	//	tmm	(Top-Mid-Mid)
				[NSNumber numberWithFloat: 1.0f],	//	trm	(Top-Right-Mid)
				[NSNumber numberWithFloat: 1.0f],	//	tlb	(Top-Left-Back)
				[NSNumber numberWithFloat: 1.0f],	//	tmb	(Top-Mid-Back)
				[NSNumber numberWithFloat: 1.0f],	//	trb	(Top-Right-Back)

				[NSNumber numberWithFloat: 1.0f],	//	mlf	(Mid-Left-Front)
				[NSNumber numberWithFloat: 1.0f],	//	mmf	(Mid-Mid-Front)
				[NSNumber numberWithFloat: 1.0f],	//	mrf	(Mid-Right-Front)
				[NSNumber numberWithFloat: 1.0f],	//	mlm	(Mid-Left-Mid)
//				[NSNumber numberWithFloat: 2.0f],	//	mmm	(Mid-Mid-Mid)
				[NSNumber numberWithFloat: 1.0f],	//	mrm	(Mid-Right-Mid)
				[NSNumber numberWithFloat: 1.0f],	//	mlb	(Mid-Left-Back)
				[NSNumber numberWithFloat: 1.0f],	//	mmb	(Mid-Mid-Back)
				[NSNumber numberWithFloat: 1.0f],	//	mrb	(Mid-Right-Back)

				[NSNumber numberWithFloat: 1.0f],	//	blf	(Bottom-Left-Front)
				[NSNumber numberWithFloat: 1.0f],	//	bmf	(Bottom-Mid-Front)
				[NSNumber numberWithFloat: 1.0f],	//	brf	(Bottom-Right-Front)
				[NSNumber numberWithFloat: 1.0f],	//	blm	(Bottom-Left-Mid)
				[NSNumber numberWithFloat: 1.0f],	//	bmm	(Bottom-Mid-Mid)
				[NSNumber numberWithFloat: 1.0f],	//	brm	(Bottom-Right-Mid)
				[NSNumber numberWithFloat: 1.0f],	//	blb	(Bottom-Left-Back)
				[NSNumber numberWithFloat: 1.0f],	//	bmb	(Bottom-Mid-Back)
				[NSNumber numberWithFloat: 1.0f],	//	brb	(Bottom-Right-Back)
				nil
			] retain
		];
	}
	else
	{
		weights = [
			[NSArray arrayWithObjects: 
				[NSNumber numberWithFloat: 1.0f],	//	tmm	(Top-Mid-Mid)
				[NSNumber numberWithFloat: 1.0f],	//	mmf	(Mid-Mid-Front)
				[NSNumber numberWithFloat: 1.0f],	//	mlm	(Mid-Left-Mid)
				[NSNumber numberWithFloat: 1.0f],	//	mrm	(Mid-Right-Mid)
				[NSNumber numberWithFloat: 1.0f],	//	mmb	(Mid-Mid-Back)
				[NSNumber numberWithFloat: 1.0f],	//	bmm	(Bottom-Mid-Mid)
				nil
			] retain
		];
	}
	
	world = [[[FxWorld new] init:WORLD_SIZE :habitat :seed :weights ] retain];

	[habitat release];
	[seed release];
}

- (void) resetWorld{
	NSArray * weights;
	if ([oscer getReset] == 1) // reset automata
	{
		Habitat * habitat;
		NSMutableArray * seed;
		int radius;

		[world release];
		
		radius = [oscer getRadius];
		
		if ([oscer getHabitat] == 1)
		{
			habitat = [[Habitat new] initNeumann: radius];
		}
		else
		{
			habitat = [[Habitat new] initMoore: radius];			
		}
		
		if ([oscer getSeed] == 0)
		{
			seed = [[Seeds new] wireCube: [oscer getLeft]: [oscer getBottom]: [oscer getFront]: [oscer getWidth]: [oscer getHeight]: [oscer getDepth]];
		}
		else
		{
			seed = [[Seeds new] randCube: [oscer getLeft]: [oscer getBottom]: [oscer getFront]: [oscer getWidth]: [oscer getHeight]: [oscer getDepth]];		
		}
		weights = [oscer getWeights];
		world = [[[FxWorld new] init: WORLD_SIZE : habitat : seed : [weights retain]] retain];
		[habitat release];
		[seed release];

	}
	else if ([oscer getReset] == 2) // update weights
	{
		weights = [oscer getWeights];
		[world setWeights: weights];
	}
	
	[oscer resetDone];
}

- (void) drawCells {
	float avg, sdev;
	float albf, arbf, arbb, albb, altf, artf, artb, altb;
	int i, j, k;
	float add;
	int half;
	NSMutableArray * col;
	NSMutableArray * row;
	NSArray * pollIndices;
	Cell * cell;
	Cell * max;
	
	if (rAng < 360.0f) { rAng += [oscer getAngle]; } else { rAng = 0.0f; }
	
	glTranslatef([oscer getTransX], [oscer getTransY], [oscer getTransZ]);
	glRotatef(rAng, [oscer getRotateX], [oscer getRotateY], [oscer getRotateZ]);
	
	glAlpha = [oscer getAlpha];
	[draw setGlobalAlpha: glAlpha];
	
	i = 0; avg = 0.0f; sdev = 0.0f;
	albf = arbf = arbb = albb = altf = artf = artb = altb = 0.0f;
	
	[oscer setPatch];
	
	if ([oscer getReset] > 0) { [self resetWorld]; }
	
	if ([oscer setCell]) {  
		NSArray* newstate;
		NSMutableArray* row;
		Cell* ccell;
		newstate = [oscer getCell];
		row = [[world cells] objectAtIndex: [[newstate objectAtIndex: 0] intValue] ];
		ccell = [row objectAtIndex: [[newstate objectAtIndex: 1] intValue] ];
		[ccell setState: [[newstate objectAtIndex: 2] floatValue]];
	}
	
	if ([oscer setPoll])
	{
		[world setPollIndices: [oscer getPollIndices]];

		for (i = 0; i < [oscValues count]; i++)
		{
			[[oscValues objectAtIndex:i] release ];
		}	

		oscValues = [NSMutableArray new];
		
		for (i = 0; i < [[world pollIndices] count]; i++)
		{
			[oscValues addObject: [NSNumber numberWithFloat:0.0f]];
		}		
		
	}
	 
	add = [oscer add];
	
	if (phase == frameRateRatio) { renew = true; phase = 0; } else { renew = false; }

	if (renew) { [world prepareNext]; frameRateRatio = [oscer getFrameRate]; }
	
	half = (int)(WORLD_SIZE / 2);
	
	max = [[[[world cells] objectAtIndex:0] objectAtIndex:0] objectAtIndex:0];
		
	for (i = 0; i < [[world cells] count]; i++)
	{
		col = [[world cells] objectAtIndex: i];
		for (j = 0; j < [col count]; j++)
		{
			row = [col objectAtIndex: j];
			for (k = 0; k < [row count]; k++)
			{
				cell = [row objectAtIndex: k];
				if (renew)
				{
					[cell next: add: [world weights]: frameRateRatio];	
				}
				else
				{
					[cell updatePhase];
				}
				[draw drawCell:cell	:i :j :k :WORLD_SIZE :frameRateRatio ];
				
				if ([max phase] < [cell phase]) { max = cell; }
				
				if (enableMessage)
				{
					avg += [cell phase];
					sdev += pow(avgState - [cell phase], 2);
					
					// calculate average states in sections
					
					if (i < half && j < half && k < half)
					{
						albf += [cell phase];
					}
					if (i >= half && j < half && k < half)
					{
						arbf += [cell phase];
					}
					if (i >= half && j < half && k >= half )
					{
						arbb += [cell phase];
					}
					if (i < half && j < half && k >= half )
					{
						albb += [cell phase];
					}
					if (i < half && j >= half && k < half)
					{
						altf += [cell phase];
					}
					if (i >= half && j >= half && k < half)
					{
						artf += [cell phase];
					}
					if (i >= half && j >= half && k >= half)
					{
						artb += [cell phase];
					}
					if (i < half && j >= half && k >= half)
					{
						altb += [cell phase];
					}
					
					pollIndices = [[world pollIndices] objectAtIndex: [world pollIndex]];
					
					if (i == [[pollIndices objectAtIndex:0] intValue] && 
						j == [[pollIndices objectAtIndex:1] intValue] && 
						k == [[pollIndices objectAtIndex:2] intValue])
					{
						[oscValues replaceObjectAtIndex:[world pollIndex] withObject: 
						 [NSNumber numberWithFloat: [cell phase]]];
						[world nextPollIndex];
					}
					
				}
				
			}
		}
	}
	
	if (enableMessage)
	{
		avgState = avg / pow([world size], 3);
		stdDev = sqrt(sdev / pow([world size], 3));
		albf = albf / (pow([world size], 3) / 8.0f);
		arbf = arbf / (pow([world size], 3) / 8.0f);
		arbb = arbb / (pow([world size], 3) / 8.0f);
		albb = albb / (pow([world size], 3) / 8.0f);
		altf = altf / (pow([world size], 3) / 8.0f);
		artf = artf / (pow([world size], 3) / 8.0f);
		artb = artb / (pow([world size], 3) / 8.0f);
		altb = altb / (pow([world size], 3) / 8.0f);
		[oscer sendMessage: avgState: stdDev: albf: arbf: arbb: albb: altf: artf: artb: altb];
		[oscer sendMessage: oscValues];
	}
	
	if (renew) { [oscer sendRenew]; }
	
	[oscer sendTrigger:[max coordX] :[max coordY] :[max coordZ]: [max phase]];
	
	bg = [oscer getClear];
	glClearColor(bg, bg, bg, 1.0f);
	
	if (enableMessage) { enableMessage = false; } else { enableMessage = true; }
	
	done = [oscer getDone];
	phase += 1;
}

- (id) initWithFrame: (NSRect) frameRect {

	NSOpenGLView* opengl;
	int i;
	
	NSOpenGLPixelFormat * pf = [FxView basicPixelFormat];

	[super initWithContentRect:frameRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];

//	self = [super initWithFrame: frameRect pixelFormat: pf];
 
	NSRect view_bounds = NSMakeRect(0,0,frameRect.size.width, frameRect.size.height);
	
	opengl = [NSOpenGLView alloc];
	
	[self setContentView: [[opengl initWithFrame:view_bounds pixelFormat:pf] autorelease]];

	[[opengl openGLContext] makeCurrentContext];

	draw = [[FxDraw new] init];

	[self initWorld];
	
	oscValues = [NSMutableArray new];

	for (i = 0; i < [[world pollIndices] count]; i++)
	{
		[oscValues addObject: [NSNumber numberWithFloat:0.0f]];
	}
	
	done = 0;
	avgState = 0.0f;
	stdDev = 0.1f;
	enableMessage = false;
	oscer = [[[FxOSC new] initWithAddress: SC_ADDRESS : SC_PORT: draw ] retain];	
	phase = frameRateRatio = [oscer getFrameRate];
	refToOscer = oscer;
	[oscer startListener];
	
	[self prepareOpenGL];
	
	[self reshape];
	
    return self;
}


- (int) done { return done; }

- (void) dealloc {
	int i;
	for (i = 0; i < [oscValues count]; i++)
	{
		[[oscValues objectAtIndex:i] release ];
	}	
	//[oscValues release];
	[oscer stopListener];
	[oscer release];
	[world release];
	[draw release];
	[super dealloc];
}

@end
