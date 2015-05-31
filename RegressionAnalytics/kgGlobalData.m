//
//  kgGlobalData.m
//  RegressionAnalytics
//
//  Created by Maclab04 on 5/30/15.
//  Copyright (c) 2015 __GrahamKellen__. All rights reserved.
//

#import "kgGlobalData.h"

//This class is intended to provide a way to access application data across all views
//This class's contents should always be static (+), for obvious reasons.

@implementation kgGlobalData

//-------------------------------------------------
//
//		Fields
//
//-------------------------------------------------

//Store the entered data
static NSArray *xValues;
static NSArray *yValues;

// Indicate the type of regression that is strongest
// 0: None		2: Log		4: Power
// 1: Linear	3: Exp			
static int preferedRegression;

//-------------------------------------------------
//
//		Accessors
//
//-------------------------------------------------
-(NSArray*)getXValues
{
	return xValues;
}

-(NSArray*)getYValues
{
	return yValues;
}

-(int)getPreferedRegression
{
	return preferedRegression;
}

//-------------------------------------------------
//
//		Mutators
//
//-------------------------------------------------
-(void)setXValues:(NSArray*)values
{
	xValues = values;
}

-(void)setYValues:(NSArray*)values
{
	yValues = values;
}

-(void)setPreferedRegression:(int)best
{
	preferedRegression = best;
}


@end
