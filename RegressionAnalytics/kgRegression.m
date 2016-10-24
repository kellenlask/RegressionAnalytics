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
+ (double)calcStdDev:(NSArray *)values {
    double variance = [kgRegression calcVariance:values];

    return sqrt(variance);

} //End calcStdDev


//Calculates the variance of the passed data set
+ (double)calcVariance:(NSArray *)values {
    double mean = [kgRegression calcMean:values];

    double variance = 0;

    for (NSNumber *num in values) {
        variance += pow(mean - [num doubleValue], 2);
    }

    variance /= values.count;

    return variance;

} //End calcVariance


//Calculates the arithmetic mean of the passed data set
+ (double)calcMean:(NSArray *)values {
    double sum = 0;

    for (NSNumber *num in values) {
        sum += [num doubleValue];

    }

    sum /= values.count;

    return sum;

} //End calcMean


//Calculates the Median of the passed data set
+ (double)calcMedian:(NSArray *)values {
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

//Linear Least Squares
+ (NSArray *)linReg:(NSArray *)xVals yValues:(NSArray *)yVals {
    //Get some values
    double xsum = 0;
    double ysum = 0;
    double xysum = 0;
    double x2sum = 0;
    double y2sum = 0;
    double xtmp = 0;
    double ytmp = 0;
    int N = [xVals count];

    for (int i = 0; i < N; i++) {
        xtmp = [xVals[i] doubleValue];
        ytmp = [yVals[i] doubleValue];

        xsum += xtmp;
        ysum += ytmp;
        xysum += xtmp * ytmp;
        x2sum += xtmp * xtmp;
        y2sum += ytmp * ytmp;
    }
    //Calculate the regression
    double slope = (N * xysum - xsum * ysum) / (N * x2sum - xsum * xsum);
    double yIntercept = (x2sum * ysum - xsum * xysum) / (N * x2sum - xsum * xsum);
    double r = (N * xysum - xsum * ysum) / sqrt(((N * x2sum - xsum * xsum) * (N * y2sum - ysum * ysum)));

    NSArray *returnArray = @[@(yIntercept), @(slope), @(r)];

    return returnArray;

} //End linReg


//--------------------------------------------------------
//
//		Nonstandard Regressions
//
//--------------------------------------------------------


// Logarithm Regression: y = log(ax+b), or e^y = ax+b
+ (NSArray *)logReg:(NSArray *)xVals yValues:(NSArray *)yVals {
    NSMutableArray *yExpVals = [yVals mutableCopy]; // Make mutable copies to dynamically edit
    for (int i = 0; i < [yVals count]; i++) {
        yExpVals[(NSUInteger) i] = @(exp([yVals[(NSUInteger) i] doubleValue])); // Do e^() both sides to linearize
    }

    NSMutableArray *returnMArray = [[kgRegression linReg:xVals yValues:yExpVals] mutableCopy];

    return returnMArray;
} // End logReg

// Exponential Regression: y = e^(ax+b), or log(y) = ax+b
+ (NSArray *)expReg:(NSArray *)xVals yValues:(NSArray *)yVals {
    NSMutableArray *yLogVals = [yVals mutableCopy]; // Make mutable copies to dynamically edit
    for (int i = 0; i < [yVals count]; i++) {
        yLogVals[i] = @(log([yVals[i] doubleValue])); // Do log() both sides to linearize
    }

    NSMutableArray *returnMArray = [[kgRegression linReg:xVals yValues:yLogVals] mutableCopy];

    return returnMArray;
} // End expReg

// Power Regression: y = ax^b, or log(y) = log(a)+b*log(x)
+ (NSArray *)powReg:(NSArray *)xVals yValues:(NSArray *)yVals {
    NSMutableArray *xLogVals = [xVals mutableCopy]; // Make mutable copies to edit
    NSMutableArray *yLogVals = [yVals mutableCopy]; // "
    for (int i = 0; i < [yVals count]; i++) {
        xLogVals[(NSUInteger) i] = @(log([xVals[(NSUInteger) i] doubleValue])); // Do log() both sides to linearize
        yLogVals[(NSUInteger) i] = @(log([yVals[(NSUInteger) i] doubleValue])); // Do log() both sides to linearize
    }

    NSMutableArray *returnMArray = [[kgRegression linReg:xLogVals yValues:yLogVals] mutableCopy];
    returnMArray[0] = @(exp([returnMArray[0] doubleValue])); // Change log(a) that linReg found back to a

    return returnMArray;
} // End logReg

@end
