//
//  FxDraw.m
//  Fx
//
//  Created by alo on 17/01/2009.
//  Copyright 2009 alo. All rights reserved.
//

#import "FxDraw.h"

@implementation FxDraw

-(float) state { return state; }
-(void) setState: (float) value { state = value; }

-(int) indexi { return indexi; }
-(void) setIndexi: (int) value { indexi = value; }

-(int) indexj { return indexj; }
-(void) setIndexj: (int) value { indexj = value; }

-(NSMutableDictionary*) patches { return patches; }

-(void) setGlobalAlpha: (float) value { gAlpha = value; }

-(void) setPatch: (NSString*) key: (int) on 
{
	[[patches objectForKey: key] setActive: on];
}

-(void) setParam: (NSString*) key: (char*) param: (float) value
{

}

-(FxDraw*) init {
	NSArray* names;
	NSString* name;
	int i;
	self = [super init];
	names = [NSArray arrayWithObjects: @"kanji", @"ringz", @"wobble", @"grid", @"horizons", @"blinds", 
		@"axial", @"radial", @"elastic", @"mesh", nil ];
	patches = [NSMutableDictionary new];
		
	for (i = 0; i < [names count]; i++)
	{
		name = [names objectAtIndex:i];
		[patches setObject: [[Patch new] init] forKey: name];
	}
	
//	[[patches objectForKey: @"dimensions"] setActive: true ];
									
	return self;
}

- (void) drawCell: (Cell *) cell: (int) i: (int) j: (int) k: (int) ws: (int) fr {
	
	currentCell = cell;
	state = [cell phase];
	indexi = i;
	indexj = j;
	indexk = k;
	worldSize = ws;
	frameRateRatio = fr;
		
	if ([[patches objectForKey: @"kanji"] active ]) {
		cp = [patches objectForKey: @"kanji"];
		[self kanji];
	}
	if ([[patches objectForKey: @"ringz"] active ]) {
		cp = [patches objectForKey: @"ringz"];
		[self ringz];
	}
	if ([[patches objectForKey: @"wobble"] active ]) {
		cp = [patches objectForKey: @"wobble"];
		[self wobble];
	}
	if ([[patches objectForKey: @"grid"] active ]) {
		cp = [patches objectForKey: @"grid"];
		[self grid];
	}
	if ([[patches objectForKey: @"horizons"] active ]) {
		cp = [patches objectForKey: @"horizons"];
		[self horizons];
	}
	if ([[patches objectForKey: @"blinds"] active ]) {
		cp = [patches objectForKey: @"blinds"];
		[self blinds];
	}
	if ([[patches objectForKey: @"axial"] active ]) {
		cp = [patches objectForKey: @"axial"];
		[self axial];
	}
	if ([[patches objectForKey: @"radial"] active ]) {
		cp = [patches objectForKey: @"radial"];
		[self radial];
	}
	if ([[patches objectForKey: @"elastic"] active ]) {
		cp = [patches objectForKey: @"elastic"];
		[self elastic];
	}
	if ([[patches objectForKey: @"mesh"] active ]) {
		cp = [patches objectForKey: @"mesh"];
		[self mesh];
	}	
}

- (void) setCommon
{
	size = 0.6f;
	size *= 2.0f;
	halfscreen = 5.2f;
	halfscreen *= 2.0f;
	[cp mapValues: indexi: indexj: state];
	alpha = [cp alpha] * gAlpha;
	red = [cp red]; 
	green = [cp green];
	blue = [cp blue];
}

- (void) kanji {
	float stx, sty, stz, ex, ey, ez;
	
	[self setCommon];
	
	left = (float)indexi * size - halfscreen;
	bottom = (float)indexj * size - halfscreen;
	front = (float)indexk * size - halfscreen;
	width = height = depth = state * size * 0.5f;
	stx = randfloat(left + (0.25f * width), left + (width * 0.75f));
	sty = randfloat(bottom + (0.25f * height), bottom + (height * 0.75f)); 
	stz = randfloat(front + (0.25f * depth), front + (0.75f * depth));
/*		ex = randfloat(left, left + width);
	ey = randfloat(bottom, bottom + height);
	ez = randfloat(front, front + depth); */
	ex = stx + randfloat(-1.0f, 1.0f) * width;
	ey = sty + randfloat(-1.0f, 1.0f) * height;
	ez = stz + randfloat(-1.0f, 1.0f) * depth;
	[self drawLine: stx: sty: stz: ex: ey: ez: 0.01f];
}

- (void) ringz {
	[self setCommon];
	left = (float)indexi * size - halfscreen + (size / 2.0f);
	bottom = (float)indexj * size - halfscreen + (size / 2.0f);
	front = (float)indexk * size - halfscreen + (size / 2.0f);
	width = height = depth = state;
	if (isEven(indexi) && !isEven(indexj) && isEven(indexk))
	{
		front = front * state;
		[self strokeRect: 0: 1.0f];
	}
	if (!isEven(indexi) && isEven(indexj) && isEven(indexk))
	{
		left = left * state;
		[self strokeRect: 1: 1.0f];
	}
	if (isEven(indexi) && isEven(indexj) && !isEven(indexk))
	{
		bottom = bottom * state;
		[self strokeRect: 2: 1.0f];
	}
	
}
- (void) wobble {
	
	if (isEven(indexk))
		// indexk == worldSize - 1 || indexk == 0
	{

		float w, n, lineWidth, scale;
		[self setCommon];
		
		left = (float)indexi * size - halfscreen + size;
		bottom = (float)indexj * size - halfscreen + size;
		front = (float)indexk * size - halfscreen + (size / 2.0f);
		
		lineWidth = map(state, 0.1f, 1.0f);
		
//		alpha = 1.0f;
		
		scale = 1.0f;
		//alpha = alpha * map(1.0f - (indexk / worldSize), 0.2f, 0.8f);
		
		if (indexi > 0)
		{
			// 4, 10, 12, 13, 15, 21
			w = [[[currentCell habitat] objectAtIndex:10] phase]; // 0 - neumann
			
			[self drawLine: left : bottom : front + map(state, scale * -1.0f, scale) : left - size : bottom : front + map(w, scale * -1.0f, scale): lineWidth ];
			
		}
		//	nw = [[[currentCell habitat] objectAtIndex:0] phase];
		//	
		//	[self drawLine: left : bottom : left - size : bottom - size : map(state, -2.0f, 2.0f): map(nw, -2.0f, 2.0f)];
		
		if (indexj > 0)
		{
			
			n = [[[currentCell habitat] objectAtIndex:4] phase]; // 1 - neumann
			
			[self drawLine: left : bottom : front + map(state, scale * -1.0f, scale) : left : bottom - size : front + map(n, scale * -1.0f, scale) : lineWidth ];
			
		}
		//	ne = [[[currentCell habitat] objectAtIndex:2] phase];
		//	
		//	[self drawLine: left : bottom : left + size : bottom - size : map(state, -2.0f, 2.0f): map(ne, -2.0f, 2.0f)];
	}
}
- (void) grid {

	float lwid, step, endleft, endbottom, endfront; 
	int i, targetIndex;
	NSMutableDictionary * events;
	Cell * target;
	NSArray * ind;

	[self setCommon];
	left = (float)indexi * size - halfscreen + (size * 0.5f); 
	bottom = (float)indexj * size - halfscreen + (size * 0.5f);
	front = (float)indexk * size - halfscreen + (size * 0.5f);
	width = height = depth = size;
	lwid = 0.1f;

	alpha = 0.3f;
	red = green = blue = 0.2f;

	[self drawVertex3f:left :bottom :front :left - width :bottom :front :lwid ];
	[self drawVertex3f:left :bottom :front :left :bottom - height :front :lwid ];
	[self drawVertex3f:left :bottom :front :left :bottom :front - depth :lwid ];	
	
	events = [[patches objectForKey: @"grid"] events];
	if ([events objectForKey: @"x"] == nil)
	{
		[events setObject:[NSNumber numberWithInt:4] forKey:@"x"];
		[events setObject:[NSNumber numberWithInt:9] forKey:@"y"];
		[events setObject:[NSNumber numberWithInt:3] forKey:@"z"];
		[events setObject:[NSNumber numberWithInt:0] forKey:@"phase"];
		[events setObject:[NSNumber numberWithInt:2] forKey:@"target"];
	}
	
	if (indexi == [[events objectForKey:@"x"] intValue] && 
		indexj == [[events objectForKey:@"y"] intValue] && 
		indexk == [[events objectForKey:@"z"] intValue])
	{
				
		left = (float)indexi * size - 5.2f + (size / 2.0f);
		bottom = (float)indexj * size - 5.2f + (size / 2.0f);
		front = (float)indexk * size - 5.2f + (size / 2.0f);
		width = height = depth = size;
		endleft = left;
		endbottom = bottom;
		endfront = front;
		
		step = size / frameRateRatio;
		
		for (i = 0; i <= [[events objectForKey:@"phase"] intValue]; i++)
		{
			alpha = 1.0f;
			red = green = blue = 0.9f;
			switch ([[events objectForKey:@"target"] intValue])
			{
				case 4:
					left -= step;
					endleft = left - step;
					break;
				case 10:
					bottom -= step;
					endbottom = bottom - step;
					break;
				case 12: 
					front -= step;
					endfront = front - step;
					break;
				case 14:
					front += step;
					endfront = front + step;
					break;
				case 16:
					bottom += step;
					endbottom = bottom + step;
					break;
				case 22:
					left += step;
					endleft = left + step;
					break;
			}
			lwid = 2.0f;
			[self drawVertex3f:left :bottom :front :endleft :endbottom :endfront :lwid];
		}
		
		if ([[events objectForKey:@"phase"] intValue] == frameRateRatio)
		{
			[events setObject:[NSNumber numberWithInt:0] forKey:@"phase"];		
		}
		else
		{
			[events setObject:[NSNumber numberWithInt:[[events objectForKey:@"phase"] intValue] + 1] forKey:@"phase"];
		}
		
		if ([[events objectForKey:@"phase"] intValue] == 0)
		{
//			ind = [NSArray arrayWithObjects: 
//				   [NSNumber numberWithInt:4],	//left
//				   [NSNumber numberWithInt:10],	//down
//				   [NSNumber numberWithInt:12],	//back
//				   [NSNumber numberWithInt:14],	//front
//				   [NSNumber numberWithInt:16],	//up
//				   [NSNumber numberWithInt:22],	//right
//				   nil
//				   ];

			ind = [NSArray arrayWithObjects: 
				   [NSNumber numberWithInt:0],	//left
				   [NSNumber numberWithInt:1],	//down
				   [NSNumber numberWithInt:2],	//back
				   [NSNumber numberWithInt:3],	//front
				   [NSNumber numberWithInt:4],	//up
				   [NSNumber numberWithInt:5],	//right
				   nil
				   ];			
			
			target = [[currentCell habitat] objectAtIndex: [[events objectForKey: @"target"] intValue]];
			targetIndex = [[events objectForKey: @"target"] intValue];
//			targetIndex = [[ind objectAtIndex:(int)randfloat(0.0f, 5.0f)] intValue];
//			target = [[currentCell habitat] objectAtIndex:targetIndex];
			for (i = 0; i < [ind count]; i++)
			{
				//fabs([[[currentCell habitat] objectAtIndex:[[ind objectAtIndex: i] intValue]] state] - [currentCell state]);
				if ( [[[currentCell habitat] objectAtIndex:[[ind objectAtIndex: i] intValue]] state] > [target state] )
				{
					targetIndex = [[ind objectAtIndex: i] intValue];
					target = [[currentCell habitat] objectAtIndex:targetIndex];
				}
			}
			[events setObject:[NSNumber numberWithInt: [target coordX]] forKey:@"x"];
			[events setObject:[NSNumber numberWithInt: [target coordY]] forKey:@"y"];
			[events setObject:[NSNumber numberWithInt: [target coordZ]] forKey:@"z"];
			[events setObject:[NSNumber numberWithInt: targetIndex] forKey:@"target"];
			
		}
		
	}
	
}
- (void) horizons {
	
	[self setCommon];
	left = (float)indexi * size - halfscreen;
	bottom = (float)indexj * size - halfscreen + (size / 2.0f);
	front = (float)indexk * size - halfscreen + (size / 2.0f);
	width = size;

	if (!isEven(indexk))
	{
		[self drawLine: left: bottom: front: left + width: bottom: front: map(1.0f - state, 1.0f, 2.0f)];
	}
	
}
- (void) blinds {

	[self setCommon];
		
	left = (float)indexi * size - halfscreen + size -  (size * 2.0f * state);
	bottom = (float)indexj * size - halfscreen + size -  (size * 2.0f * state);
	front = (float)indexk * size - halfscreen + size -  (size * 2.0f * state);
	height = width = depth = size * 4.0f * state;

	if (isEven(indexk))
	{
		[self drawPoint: left : bottom : front : 1.0f ];
		[self drawPoint: left : bottom : front + depth : 1.0f ];
		[self drawPoint: left : bottom + height : front : 1.0f ];
		[self drawPoint: left : bottom + height : front + depth : 1.0f ];
	}

	if (!isEven(indexi))
	{
		[self drawPoint: left + width : bottom : front : 1.0f ];
		[self drawPoint: left + width : bottom : front + depth : 1.0f ];
		[self drawPoint: left + width : bottom + height : front : 1.0f ];
		[self drawPoint: left + width : bottom + height : front + depth : 1.0f ];
	}
	//	[self drawLine: left: bottom: front: left: bottom + height: front: map(1.0f - state, 0.1f, 2.0f)];

}

- (void) axial {
	[self setCommon];
	left = (float)indexi * size - halfscreen + size - (size * 2.0f * state);
	bottom = (float)indexj * size - halfscreen + size - (size * 2.0f * state);
	front = (float)indexk * size - halfscreen + size - (size * 2.0f * state);
	width = height = depth = size * 4.0f * state;
	alpha = alpha * 0.1f;
	if (indexk == 0) {
		[self fillRect: 0];
	}
	if (indexi == 0) { 
		[self fillRect: 1];
	}
	if (indexi == worldSize - 2) { 
		left = left + (width * 2.0f);
		[self fillRect: 1];
	}
	if (indexj == 0) {
		[self fillRect: 2];
	}
	if (indexj == worldSize - 1) { 
		bottom = bottom + height;
		[self fillRect: 2];
	}
	
}


- (void) radial {
	
	if (indexi == worldSize / 2 || indexk == worldSize / 2 || indexj == worldSize / 2)
	{
		[self setCommon];
		left = (float)indexi * size - halfscreen + size - (size * 2.0f * state);
		bottom = (float)indexj * size - halfscreen + size - (size * 2.0f * state);
		front = (float)indexk * size - halfscreen + size - (size * 2.0f * state);
		width = height = depth = size * 2.0f * state;
		
		float a[3] = { left - width, bottom - height, front - depth };
		float b[3] = { left - (width / 2.0f), bottom - (height / 2.0f), front - (depth / 2.0f) };
		float c[3] = { left + (width / 2.0f), bottom + (height / 2.0f), front + (depth / 2.0f) };
		float d[3] = {  left + width, bottom + height, front + depth };
		
		[self drawCubicCurve: a : c : b : d : 16 : 1.0f ];
	}
}

- (void) elastic {

//	NSMutableDictionary * events;
//	int cindex, direction;
	float scale;
	float lwid;
		
	[self setCommon];
	left = (float)indexi * size - halfscreen + size - (size * 2.0f * state);
	bottom = (float)indexj * size - halfscreen + size - (size * 2.0f * state);
	front = (float)indexk * size - halfscreen + size - (size * 2.0f * state);
	width = height = depth = size * 4.0f * state;
//	height = size * ( 1.0f / fabs(8.0f - (float)indexj));
//	depth = map(state, -5.0f, 5.0f);
/*
	events = [[patches objectForKey: @"elastic"] events];
	if ([events objectForKey: @"index"] == nil)
	{
		[events setObject:[NSNumber numberWithInt:8] forKey:@"index"];
		[events setObject:[NSNumber numberWithInt:-1] forKey:@"direction"];
		cindex = 8;
		direction = 1;
	}
	else
	{
		cindex = [[events objectForKey: @"index"] intValue];
		direction = [[events objectForKey: @"direction"] intValue];
	}
	
	if (indexk == cindex )
	{
		[self strokeRect: 1];
	}
	
	if (cindex == 0) { direction = 1; }

	if ([[events objectForKey: @"index"] intValue] == worldSize - 1) { direction = -1; }
		
	[events setObject:[NSNumber numberWithInt: direction] forKey:@"direction"];
	[events setObject:[NSNumber numberWithInt: cindex + direction] forKey:@"index"];
*/	
	lwid = map(state, 0.5f, 2.0f);
	scale = 1.0f;
	//if (state > 0.79f) { red = 0.1f; green = 0.2f; blue = 1.0f; }
	if (indexi == 0) { 
		//left *= map(state, scale * -1.0f, scale);
		[self strokeRect: 1: lwid];
	}
	if (indexi == worldSize - 1) {
		left += (width * state);
		//left *= map(state, scale * -1.0f, scale);
		[self strokeRect: 1: lwid];
	}
	if (indexj == 0) {
		//bottom *= map(state, scale * -1.0f, scale);
		[self strokeRect: 2: lwid];
	}
	if (indexj == worldSize - 1) {
		bottom += (height * state);
		//bottom *= map(state, scale * -1.0f, scale);
		[self strokeRect: 2: lwid];
	}	
	if (indexk == 0) {
		//front *= map(state, scale * -1.0f, scale);
		[self strokeRect: 0: lwid];
	}
	if (indexk == worldSize - 1)
	{
		front += (depth * state);
		//front *= map(state, scale * -1.0f, scale);
		[self strokeRect: 0: lwid];	
	}
}

- (void) mesh {
	
	
	[self setCommon];
	left = (float)indexi * size - halfscreen + size - (size * state);
	bottom = (float)indexj * size - halfscreen + size - (size * state);
	front = (float)indexk * size - halfscreen + size - (size * state);
	width = height = depth = size * 2.0f * state;
	
	if (
		(indexi == 3 && indexj == 3) || 
		(indexi == 3 && indexk == 3) ||
		(indexj == 3 && indexk == 3) ||
		
		(indexi == 3 && indexj == 12) || 
		(indexi == 3 && indexk == 12) ||
		(indexj == 3 && indexk == 12) ||
		
		(indexj == 3 && indexi == 12) ||
		(indexk == 3 && indexi == 12) ||
		(indexk == 3 && indexj == 12) ||
		
		(indexi == 12 && indexk == 12) ||
		(indexi == 12 && indexj == 12) ||
		(indexk == 12 && indexj == 12)
		)
	{
		[self strokeCube];
	}
	
	left = (float)indexi * size - halfscreen + size - (size * 0.5f * state);
	bottom = (float)indexj * size - halfscreen + size - (size * 0.5f * state);
	front = (float)indexk * size - halfscreen + size - (size * 0.5f * state);
	width = height = depth = size * state;
	
	if (
		(indexi == 7 && indexj == 7) || 
		(indexi == 7 && indexk == 7) ||
		(indexj == 7 && indexk == 7) ||
		
		(indexi == 7 && indexj == 8) || 
		(indexi == 7 && indexk == 8) ||
		(indexj == 7 && indexk == 8) ||
		
		(indexj == 7 && indexi == 8) ||
		(indexk == 7 && indexi == 8) ||
		(indexk == 7 && indexj == 8) ||
		
		(indexi == 8 && indexk == 8) ||
		(indexi == 8 && indexj == 8) ||
		(indexk == 8 && indexj == 8)
		)
	{
		[self strokeCube];
	}
	
/*
	left = (float)indexi * size - halfscreen + size - (size * 1.0f * state);
	bottom = (float)indexj * size - halfscreen + size - (size * 1.0f * state);
	front = (float)indexk * size - halfscreen + size - (size * 1.0f * state);
	width = height = depth = size * 2.0f * state;
	
	alpha = 0.08f * state;
	
	[self stroke3Dvertex];
*/
}

// basic drawing functions

- (void) drawRect {
	glColor4f(red, green, blue, alpha);
	glBegin(GL_POLYGON);

	glVertex3f (left, bottom, 0.0f);
	glVertex3f (left + width, bottom, 0.0f);
	glVertex3f (left + width, bottom + height, 0.0f);
	glVertex3f (left, bottom + height, 0.0f);

	glEnd();

}

- (void) drawAxialRect: (float) colN: (float) colE: (float) colS: (float) colW {
	glBegin(GL_POLYGON);

	glColor4f(colS, colS, colS, alpha);
	glVertex3f (left, bottom, front);
	glColor4f(colE, colE, colE, alpha);
	glVertex3f (left + width, bottom, front);
	glColor4f(colN, colN, colN, alpha);
	glVertex3f (left + width, bottom + height, front);
	glColor4f(colW, colW, colW, alpha);
	glVertex3f (left, bottom + height, front);

	glEnd();

}

- (void) fillRect {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_POLYGON_SMOOTH);
	glBegin(GL_POLYGON);

	glVertex2f (left, bottom);
	glVertex2f (left + width, bottom);

	glVertex2f (left + width, bottom);
	glVertex2f (left + width, bottom + height);
	
	glVertex2f (left + width, bottom + height);
	glVertex2f (left, bottom + height);
	
	glVertex2f (left, bottom + height);
	glVertex2f (left, bottom);	

	glEnd();
	glDisable(GL_POLYGON_SMOOTH);
	
}

- (void) strokeRect {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_LINE_SMOOTH);
	glLineWidth(1.2f);
	glBegin(GL_LINES);

	glVertex2f (left, bottom);
	glVertex2f (left + width, bottom);

	glVertex2f (left + width, bottom);
	glVertex2f (left + width, bottom + height);
	
	glVertex2f (left + width, bottom + height);
	glVertex2f (left, bottom + height);
	
	glVertex2f (left, bottom + height);
	glVertex2f (left, bottom);	

	glEnd();
	glDisable(GL_LINE_SMOOTH);
}

- (void) fillRect: (int) plane {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_POLYGON_SMOOTH);
	glBegin(GL_POLYGON);

	switch (plane)
	{
		case 0:
			glVertex3f (left, bottom, front);
			glVertex3f (left + width, bottom, front);

			glVertex3f (left + width, bottom, front);
			glVertex3f (left + width, bottom + height, front);
			
			glVertex3f (left + width, bottom + height, front);
			glVertex3f (left, bottom + height, front);
			
			glVertex3f (left, bottom + height, front);
			glVertex3f (left, bottom, front);
			
			break;
			
		case 1:
			glVertex3f (left, bottom, front);
			glVertex3f (left, bottom, front + depth);

			glVertex3f (left, bottom, front + depth);
			glVertex3f (left, bottom + height, front + depth);
			
			glVertex3f (left, bottom + height, front + depth);
			glVertex3f (left, bottom + height, front);
			
			glVertex3f (left, bottom + height, front);
			glVertex3f (left, bottom, front);
			
			break;

		case 2:
			glVertex3f (left, bottom, front);
			glVertex3f (left + width, bottom, front);

			glVertex3f (left + width, bottom, front);
			glVertex3f (left + width, bottom, front + depth);
			
			glVertex3f (left + width, bottom, front + depth);
			glVertex3f (left, bottom, front + depth);
			
			glVertex3f (left, bottom, front + depth);
			glVertex3f (left, bottom, front);
			
			break;
			
	}

	glEnd();
	glDisable(GL_POLYGON_SMOOTH);
	
}

- (void) strokeRect: (int) plane: (float) lineWidth {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_LINE_SMOOTH);
	glLineWidth(lineWidth);
	glBegin(GL_LINES);
	
	switch (plane)
	{
		case 0:
			glVertex3f (left, bottom, front);
			glVertex3f (left + width, bottom, front);

			glVertex3f (left + width, bottom, front);
			glVertex3f (left + width, bottom + height, front);
			
			glVertex3f (left + width, bottom + height, front);
			glVertex3f (left, bottom + height, front);
			
			glVertex3f (left, bottom + height, front);
			glVertex3f (left, bottom, front);
			
			break;
			
		case 1:
			glVertex3f (left, bottom, front);
			glVertex3f (left, bottom, front + depth);

			glVertex3f (left, bottom, front + depth);
			glVertex3f (left, bottom + height, front + depth);
			
			glVertex3f (left, bottom + height, front + depth);
			glVertex3f (left, bottom + height, front);
			
			glVertex3f (left, bottom + height, front);
			glVertex3f (left, bottom, front);
			
			break;

		case 2:
			glVertex3f (left, bottom, front);
			glVertex3f (left + width, bottom, front);

			glVertex3f (left + width, bottom, front);
			glVertex3f (left + width, bottom, front + depth);
			
			glVertex3f (left + width, bottom, front + depth);
			glVertex3f (left, bottom, front + depth);
			
			glVertex3f (left, bottom, front + depth);
			glVertex3f (left, bottom, front);
			
			break;
			
	}


	glEnd();
	glDisable(GL_LINE_SMOOTH);
}

- (void) strokeCube {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_LINE_SMOOTH);
	glLineWidth((1.0f - state) * 2.0f);
	glBegin(GL_LINES);
	
	
	glVertex3f (left, bottom, front);
	glVertex3f (left + width, bottom, front);

	glVertex3f (left + width, bottom, front);
	glVertex3f (left + width, bottom + height, front);
	
	glVertex3f (left + width, bottom + height, front);
	glVertex3f (left, bottom + height, front);
	
	glVertex3f (left, bottom + height, front);
	glVertex3f (left, bottom, front);	
	
	glVertex3f (left, bottom, front);
	glVertex3f (left, bottom, front + depth);
	
	glVertex3f (left, bottom, front + depth);
	glVertex3f (left + width, bottom, front + depth);
	
	glVertex3f (left + width, bottom, front + depth);
	glVertex3f (left + width, bottom, front);

	glVertex3f (left, bottom + height, front);
	glVertex3f (left, bottom + height, front + depth);
	
	glVertex3f (left, bottom + height, front + depth);
	glVertex3f (left + width, bottom + height, front + depth);
	
	glVertex3f (left + width, bottom + height, front + depth);
	glVertex3f (left + width, bottom + height, front);
	
	glVertex3f (left, bottom, front + depth);
	glVertex3f (left, bottom + height, front + depth);

	glVertex3f (left + width, bottom, front + depth);
	glVertex3f (left + width, bottom + height, front + depth);
	
	glEnd();
	glDisable(GL_LINE_SMOOTH);

}

- (void) drawVertex3f: (float) startx: (float) starty: (float) startz: (float) endx: (float) endy: (float) endz: (float) lineWidth {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_LINE_SMOOTH);
	glLineWidth(lineWidth);
	glBegin(GL_LINES);
	
	glVertex3f(startx, starty, startz);
	glVertex3f(endx, endy, endz);
	
	glEnd();
	glDisable(GL_LINE_SMOOTH);
		
}

- (void) stroke3Dvertex {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_LINE_SMOOTH);
	glLineWidth(state * 4.0f);
	glBegin(GL_LINES);
	
	if (state <= 0.05)
	{
		glVertex3f (left, bottom, front);
		glVertex3f (left + width, bottom, front);
	}
	
	if (state > 0.05 && state <= 0.1)
	{
		glVertex3f (left + width, bottom, front);
		glVertex3f (left + width, bottom + height, front);
	}
	
	if (state > 0.1 && state <= 0.2)
	{	
		glVertex3f (left + width, bottom + height, front);
		glVertex3f (left, bottom + height, front);
	}
	
	if (state > 0.2 && state <= 0.3)
	{	
		glVertex3f (left, bottom + height, front);
		glVertex3f (left, bottom, front);	
	}	
	
	if (state > 0.3 && state <= 0.4)
	{	
		glVertex3f (left, bottom, front);
		glVertex3f (left, bottom, front + depth);
	}
	
	if (state > 0.4 && state <= 0.5)
	{	
		glVertex3f (left, bottom, front + depth);
		glVertex3f (left + width, bottom, front + depth);
	}
	
	if (state > 0.5 && state <= 0.6)
	{				
		glVertex3f (left + width, bottom, front + depth);
		glVertex3f (left + width, bottom, front);
	}
	
	if (state > 0.6 && state <= 0.7)
	{	
		glVertex3f (left, bottom + height, front);
		glVertex3f (left, bottom + height, front + depth);
	}
	
	if (state > 0.7 && state <= 0.8)
	{		
		glVertex3f (left, bottom + height, front + depth);
		glVertex3f (left + width, bottom + height, front + depth);
	}
	
	if (state > 0.8 && state <= 0.9)
	{		
		glVertex3f (left + width, bottom + height, front + depth);
		glVertex3f (left + width, bottom + height, front);
	}
	
	if (state > 0.9 && state <= 0.95)
	{		
		glVertex3f (left, bottom, front + depth);
		glVertex3f (left, bottom + height, front + depth);
	}
	
	if (state > 0.95)
	{		
		glVertex3f (left + width, bottom, front + depth);
		glVertex3f (left + width, bottom + height, front + depth);
	}
	
	glEnd();
	glDisable(GL_LINE_SMOOTH);

}


- (void) drawPoint: (float) x: (float) y: (float) z: (float) sz {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_POINT_SMOOTH);
	glPointSize(sz);
	glBegin(GL_POINTS);
	glVertex3f(x, y, z);
	glEnd();
	glDisable(GL_POINT_SMOOTH);
}


- (void) drawLine: (float) startx: (float) starty: (float) startz: 
		(float) endx: (float) endy: (float) endz: (float) lineWidth {
	glColor4f(red, green, blue, alpha);
	glEnable(GL_LINE_SMOOTH);
	glLineWidth(lineWidth);
	glBegin(GL_LINES);
	
	glVertex3f(startx, starty, startz);
	glVertex3f(endx, endy, endz);
	
	glEnd();
	glDisable(GL_LINE_SMOOTH);
}


- (void) drawCircle: (float) cx: (float) cy: (float) r: (int) num_segments: (bool) fill { 
	int i;
	float theta, tangetial_factor, radial_factor, x, y;
	theta = 2 * pi / num_segments;
	tangetial_factor = tanf(theta);
	radial_factor = cosf(theta);
	x = r;
	y = 0;
	
	if (fill) {
		glBegin(GL_POLYGON);	
	}
	{
		glBegin(GL_LINE_LOOP);
	}
	glColor4f(red, green, blue, alpha);
	for(i = 0; i < num_segments; i++) 
	{ 
		glVertex3f(x + cx, y + cy, front);
        
		float tx = -y; 
		float ty = x; 
		x += tx * tangetial_factor; 
		y += ty * tangetial_factor; 
		x *= radial_factor; 
		y *= radial_factor; 
	} 
	glEnd(); 
}


- (void) drawCube
{

/*
	GLfloat n[6][3] = {  // Normals for the 6 faces of a cube.
	  {-1.0, 0.0, 0.0}, {0.0, 1.0, 0.0}, {1.0, 0.0, 0.0},
	  {0.0, -1.0, 0.0}, {0.0, 0.0, 1.0}, {0.0, 0.0, -1.0} };
*/
	
	GLfloat n[6][3] = {
		{left - size, bottom, front}, {left, bottom + size, front}, {left + size, bottom, front},
		{left, bottom - size, front}, {left, bottom, front + size}, {left, bottom, front - size}
	};
	
	GLint faces[6][4] = {  /* Vertex indices for the 6 faces of a cube. */
	  {0, 1, 2, 3}, {3, 2, 6, 7}, {7, 6, 5, 4},
	  {4, 5, 1, 0}, {5, 6, 2, 1}, {7, 4, 0, 3} };
	GLfloat v[8][3];  /* Will be filled in with X,Y,Z vertexes. */

	int i;

	for (i = 0; i < 6; i++) {
		glBegin(GL_QUADS);
		glNormal3fv(&n[i][0]);
		glVertex3fv(&v[faces[i][0]][0]);
		glVertex3fv(&v[faces[i][1]][0]);
		glVertex3fv(&v[faces[i][2]][0]);
		glVertex3fv(&v[faces[i][3]][0]);
		glEnd();
	}
}

- (void) drawCubicCurve: (float[]) a: (float[]) b: (float[]) c: (float[]) d: (int) segs: (float) lineWidth
{
	float cx, cy, cz;
	float aa, bb;
	int i;
	
	aa = 1.0f;
	bb = 0.0f;
	
	glColor4f(red, green, blue, alpha);
	glLineWidth(lineWidth);
	glBegin(GL_LINE_STRIP);
	
	for (i = 0; i < segs; i++)
	{
		cx = a[0]*pow(aa,3) + b[0]*pow(aa,2)*bb + c[0]*aa*pow(bb,2) + d[0]*pow(bb,3);
		cy = a[1]*pow(aa,3) + b[1]*pow(aa,2)*bb + c[1]*aa*pow(bb,2) + d[1]*pow(bb,3);
		cz = a[2]*pow(aa,3) + b[2]*pow(aa,2)*bb + c[2]*aa*pow(bb,2) + d[2]*pow(bb,3);
		
		glVertex3f(cx, cy, cz);
		
		aa -= (1.0f / segs);
		bb = 1.0f - aa;
	}
	
	glEnd();
}

-(void) dealloc {
	int i;
	NSArray* names;
	NSString* name;
	
	names = [NSArray arrayWithObjects: @"kanji", @"ringz", @"wobble", @"grid", @"horizons", @"blinds", 
	@"axial", @"axial", @"radial", @"elastic", @"mesh", nil ];

	for (i = 0; i < [names count]; i++)
	{
		name = [names objectAtIndex: i];
		[[patches objectForKey: name] release];
	}
	
	[super dealloc];
}

@end

