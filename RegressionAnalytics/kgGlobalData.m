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
static int currentTab;
static bool dataChanged;

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

//Functions to handle when the regression tab is skipped
-(BOOL)wasDataChanged
{
    return dataChanged;
}
-(int)getCurrentTab
{
    return currentTab;
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

//Functions to handle when the graph should be redrawn and how to redraw it if the user skips the regression tab
-(void)dataChanged
{
    dataChanged = TRUE;
}
-(void)dataRegressed
{
    dataChanged = FALSE;
}
-(void)setTab:(NSInteger)tab
{
    currentTab = tab;
}

@end
