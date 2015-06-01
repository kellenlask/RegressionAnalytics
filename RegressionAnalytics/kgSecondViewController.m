//
//  kgSecondViewController.m
//  RegressionAnalytics
//
//  Created by Maclab04 on 5/21/15.
//  Copyright (c) 2015 __GrahamKellen__. All rights reserved.
//

#import "kgSecondViewController.h"
#import "kgGlobalData.h"
#import "kgRegression.h"

@implementation kgSecondViewController

kgGlobalData *data;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Start up the data
	data = [[kgGlobalData alloc] init];
	
	//Make the string, and display it
	[_regressionView setText:[self constructText]];
	
} //End viewDidLoad

//Make the string with the regression information
-(NSString *)constructText
{
	//Basic Information
	double xMean = [kgRegression calcMean:data.getXValues];
	double yMean = [kgRegression calcMean:data.getYValues];
	double xVariance = [kgRegression calcVariance:data.getXValues];
	double yVariance = [kgRegression calcVariance:data.getYValues];
	double xStdDev = [kgRegression calcStdDev:data.getXValues];
	double yStdDev = [kgRegression calcStdDev:data.getYValues];	
	
	//Linear Regression
	NSArray* linRegression = [kgRegression linReg:data.getXValues yValues:data.getYValues];
	NSArray* logRegression = [kgRegression logReg:data.getXValues yValues:data.getYValues];
	NSArray* expRegression = [kgRegression expReg:data.getXValues yValues:data.getYValues];
	NSArray* powRegression = [kgRegression powReg:data.getXValues yValues:data.getYValues];
	
	//Create the MONSTER STRING!!!!!!!!
	NSString* returnString = [NSString stringWithFormat:@"X \nMean: %f\nStdDev: %f\nVar: %f\n--------------------\nY \nMean: %f\nStdDev: %f\nVar: %f\n====================Linear Regression\n\tr: %f\n\tr²: %f\n\ty=%fx+%f\nLogarithmic Regression\n\tr: %f\n\tr²: %f\n\ty=log(%fx+%f\nExponential Regression\n\tr: %f\n\tr²: %f\n\ty=e^(%fx+%f)\nPower Regression\n\tr: %f\n\tr²: %f\n\ty=%fx^(%f))", xMean, xStdDev, xVariance, yMean, yStdDev, yVariance, [linRegression[2] doubleValue], pow([linRegression[2] doubleValue], 2), [linRegression[1] doubleValue], [linRegression[0] doubleValue], [logRegression[2] doubleValue], pow([logRegression[2] doubleValue], 2), [logRegression[1] doubleValue], [logRegression[0] doubleValue], [expRegression[2] doubleValue], pow([expRegression[2] doubleValue], 2), [expRegression[1] doubleValue], [expRegression[0] doubleValue], [powRegression[2] doubleValue], pow([powRegression[2] doubleValue], 2), [powRegression[1] doubleValue], [powRegression[0] doubleValue]];
	
	//Do Dat Return Thang
	return returnString;
	
} //End constructText

@end





















