/*
 *  fxutil.c
 *  Fx
 *
 *  Created by alo on 20/01/2009.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "fxutil.h"

void initrand() 
{ 
    srand((unsigned)(time(0))); 
} 

float map(float val, float lo, float hi)
{
	return val * (hi - lo) + lo;
}

int randint(int min, int max) 
{ 
    if (min>max) 
    { 
        return max+(int)((min-max+1)*rand()/(RAND_MAX+1.0)); 
    } 
    else 
    { 
        return min+(int)((max-min+1)*rand()/(RAND_MAX+1.0)); 
    } 
}

float randf() 
{ 
    return rand()/((float)(RAND_MAX)+1); 
} 

float randfloat(float min, float max) 
{ 
    if (min>max) 
    { 
        return randf()*(min-max)+max;     
    } 
    else 
    { 
        return randf()*(max-min)+min; 
    }     
} 

int xmod(int a, int n) {
	return a - (n * floor(a / (double)n));
}

int wrapi(int val, int lo, int hi) {
	int rtn;
	rtn = xmod((val - lo), (hi - lo + 1)) + lo;
	return rtn;
}

float wrapf(float val, float lo, float hi)
{
	return xmodf(val - lo, hi - lo) + lo;
}

float xmodf(float value, float hi)
{
	return value - hi*floor(value/hi);
}

int isEven(int number)
{
	return (int)(number % 2 == 0);
}