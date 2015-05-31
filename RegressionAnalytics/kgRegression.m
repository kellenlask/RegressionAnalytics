//
//  kgRegression.m
//  RegressionAnalytics
//
//  Created by Kellen on 5/22/15.
//  Copyright (c) 2015 __GrahamKellen__. All rights reserved.
//

#import "kgRegression.h"

@implementation kgRegression

//--------------------------------------------------------
//
//		Simple Measures
//
//--------------------------------------------------------

//Calculates the Standard Deviation of the passed dataset (posiitve only)
+(double)calcStdDev:(NSArray*)values 
{
	double variance = [kgRegression calcVariance: values];
	
	return sqrt(variance);
	
} //End calcStdDev


//Calculates the variance of the passed data set
+(double)calcVariance:(NSArray*)values
{
	double mean = [kgRegression calcMean:values];
	
	double variance = 0;
	
	for(NSNumber *num in values) 
	{
		variance += pow(mean - [num doubleValue], 2);
		
	}
	
	variance /= values.count;
	
	return variance;
	
} //End calcVariance


//Calculates the arithmetic mean of the passed data set
+(double)calcMean:(NSArray*)values
{
	double sum = 0;
	
	for(NSNumber *num in values) 
	{
		sum += [num doubleValue];
		
	}
	
	sum /= values.count;
	
	return sum;
	
} //End calcMean


//Calculates the Median of the passed data set
+(double)calcMedian:(NSArray*)values
{
	NSArray *sorted = [values sortedArrayUsingSelector:@selector(compare:)];
	
	if (sorted.count % 2 == 0) {
		return ([sorted[sorted.count / 2] doubleValue] + [sorted[sorted.count / 2 - 1] doubleValue]) / 2;
		
	} else {
		return [sorted[sorted.count / 2] doubleValue];
	}
	
} //End calcMedian

//--------------------------------------------------------
//
//		Regressions
//
//--------------------------------------------------------

//Calculates the linear regression r value
+(double)linRegR:(NSArray*)xVals yValues:(NSArray*)yVals
{
	//Sum of the products of the x's and the y's
	double xy = 0;
	for(int i = 0; i < xVals.count; i++) {
		xy += [xVals[i] doubleValue] * [yVals[i] doubleValue];
	}
	
	//Sum of the x's squared
	double xSquare = 0;
	for(NSNumber *num in xVals) 
	{
		xSquare += pow([num doubleValue], 2);
	}
	
	//Sum of the y's squared
	double ySquare = 0;
	for(NSNumber *num in yVals) 
	{
		ySquare += pow([num doubleValue], 2);
	}
	
	//Calculate the r value
	return xy / sqrt(xSquare * ySquare);
	
} //End linRegR

//Linear Least Squares
+(NSArray*)linReg:(NSArray*)xVals yValues:(NSArray*)yVals
{
	//Get some values
	double r = [kgRegression linRegR:xVals yValues:yVals];
	double xDev = [kgRegression calcStdDev:xVals];
	double yDev = [kgRegression calcStdDev:yVals];
	double yMean = [kgRegression calcMean:yVals];
	double xMean = [kgRegression calcMean:xVals];
	
	//Calculate the regression
	double slope = r * (yDev / xDev);
	double yIntercept = yMean - slope * xMean;
	
	NSArray* returnArray = [NSArray arrayWithObjects:[NSNumber numberWithDouble:yIntercept], [NSNumber numberWithDouble:slope], [NSNumber numberWithDouble:r], nil]; 
	
	return returnArray;
	
} //End linReg


//--------------------------------------------------------
//
//		Nonstandard Regressions
//
//--------------------------------------------------------


// Logarithm Regression: y = log(ax+b), or e^y = ax+b
+(NSArray*)logReg:(NSArray*)xVals yValues:(NSArray*)yVals
{
    NSMutableArray* yExpVals = [yVals mutableCopy]; // Make mutable copies to dynamically edit
    for(int i=0; i<[yVals count]; i++)
    {
        yExpVals[i] = @(exp([yVals[i] doubleValue])); // Do e^() both sides to linearize
    }
    
    NSMutableArray* returnMArray = [[kgRegression linReg:xVals yValues:yExpVals] mutableCopy];
    
    return returnMArray;
} // End logReg

// Exponential Regression: y = e^(ax+b), or log(y) = ax+b
+(NSArray*)expReg:(NSArray*)xVals yValues:(NSArray*)yVals
{
    NSMutableArray* yLogVals = [yVals mutableCopy]; // Make mutable copies to dynamically edit
    for(int i=0; i<[yVals count]; i++)
    {
        yLogVals[i] = @(log([yVals[i] doubleValue])); // Do log() both sides to linearize
    }
    
    NSMutableArray* returnMArray = [[kgRegression linReg:xVals yValues:yLogVals] mutableCopy];
    
    return returnMArray;
} // End expReg

// Power Regression: y = ax^b, or log(y) = log(a)+b*log(x)
+(NSArray*)powReg:(NSArray*)xVals yValues:(NSArray*)yVals
{
    NSMutableArray* xLogVals = [xVals mutableCopy]; // Make mutable copies to edit
    NSMutableArray* yLogVals = [yVals mutableCopy]; // "
    for(int i=0; i<[yVals count]; i++)
    {
        xLogVals[i] = @(log([xVals[i] doubleValue])); // Do log() both sides to linearize
        yLogVals[i] = @(log([yVals[i] doubleValue])); // Do log() both sides to linearize
    }
    
    NSMutableArray* returnMArray = [[kgRegression linReg:xLogVals yValues:yLogVals] mutableCopy];
    returnMArray[0]=@(exp([returnMArray[0] doubleValue])); // Change log(a) that linReg found back to a
    
    return returnMArray;
} // End logReg

@end
