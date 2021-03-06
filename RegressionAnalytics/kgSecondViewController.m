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
NSArray *linRegression;
NSArray *logRegression;
NSArray *expRegression;
NSArray *powRegression;
NSArray *sortedYVals;
NSArray *sortedXVals;
bool canLogReg;
bool canExpReg;
bool canPowReg;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self viewWillAppear:false];

} //End viewDidLoad

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //Start up the data
    data = [[kgGlobalData alloc] init];

    if (data.getXValues.count != data.getYValues.count) {
        NSString *error = [NSString stringWithFormat:@"Error: Data entry mismatch.\nY:%d values\nX:%d values", (unsigned) data.getXValues.count, (unsigned) data.getYValues.count];

        [_regressionView setText:error];

    } else if (data.getXValues.count == 0 || data.getYValues.count == 0) {
        NSString *error = @"No data entered.";

        [_regressionView setText:error];

    } else {
        //Make the string, and display it
        [_regressionView setText:[self constructText]];

        [self setPreferredRegression];
    }


    // If you're here because you cheated and tried to skip this tab
    if ([data wasDataChanged] && [data getCurrentTab] == 2) {
        [data dataRegressed];
        [data setTab:1];
        [self.tabBarController setSelectedIndex:2];
    }

    [data setTab:1];
} //End viewWillAppear

//Make the string with the regression information
- (NSString *)constructText {
    //Basic Information
    double xMean = [kgRegression calcMean:data.getXValues];
    double yMean = [kgRegression calcMean:data.getYValues];
    double xMedian = [kgRegression calcMedian:data.getXValues];
    double yMedian = [kgRegression calcMedian:data.getYValues];
    double xVariance = [kgRegression calcVariance:data.getXValues];
    double yVariance = [kgRegression calcVariance:data.getYValues];
    double xStdDev = [kgRegression calcStdDev:data.getXValues];
    double yStdDev = [kgRegression calcStdDev:data.getYValues];

    sortedXVals = [data.getXValues sortedArrayUsingSelector:@selector(compare:)];
    sortedYVals = [data.getYValues sortedArrayUsingSelector:@selector(compare:)];

    //NSLog([NSString stringWithFormat:@"X1: %f\nY1: %f",[sortedXVals[0] doubleValue],[sortedYVals[0] doubleValue]]);
    canExpReg = [sortedYVals[0] doubleValue] > 0;
    canLogReg = [sortedXVals[0] doubleValue] > 0;
    canPowReg = canExpReg && canLogReg;

    NSString *logarithmic = @"Logarithmic Regression\nBecause the x values are 0 or smaller, no logarithmic regression can be computed.";
    NSString *exponential = @"Exponential Regression\nBecause the y values are 0 or smaller, no exponential regression can be computed.";
    NSString *power = @"Power Regression\nBecause the x or y values are 0 or smaller, no power regression can be computed.";


    //Linear Regression
    linRegression = [kgRegression linReg:data.getXValues yValues:data.getYValues];
    NSString *linear = [NSString stringWithFormat:@"Linear Regression\n\tr: %f\n\tr²: %f\n\ty=(%f)x+(%f)", [linRegression[2] doubleValue], pow([linRegression[2] doubleValue], 2), [linRegression[1] doubleValue], [linRegression[0] doubleValue]];

    if (canLogReg) //Logarithmic Regression
    {
        logRegression = [kgRegression logReg:data.getXValues yValues:data.getYValues];
        logarithmic = [NSString stringWithFormat:@"Logarithmic Regression\n\tr: %f\n\tr²: %f\n\ty=ln((%f)x+(%f))", [logRegression[2] doubleValue], pow([logRegression[2] doubleValue], 2), [logRegression[1] doubleValue], [logRegression[0] doubleValue]];
    }
    if (canExpReg) //Exponential Regression
    {
        expRegression = [kgRegression expReg:data.getXValues yValues:data.getYValues];
        exponential = [NSString stringWithFormat:@"Exponential Regression\n\tr: %f\n\tr²: %f\n\ty=e^((%f)x+(%f))", [expRegression[2] doubleValue], pow([expRegression[2] doubleValue], 2), [expRegression[1] doubleValue], [expRegression[0] doubleValue]];
    }
    if (canPowReg) //Power Regression
    {
        powRegression = [kgRegression powReg:data.getXValues yValues:data.getYValues];
        power = [NSString stringWithFormat:@"Power Regression\n\tr: %f\n\tr²: %f\n\ty=(%f)x^(%f)", [powRegression[2] doubleValue], pow([powRegression[2] doubleValue], 2), [powRegression[0] doubleValue], [powRegression[1] doubleValue]];
    }



    //Simple Analysis
    NSString *simple = [NSString stringWithFormat:@"X \nMean: %f\nMedian: %f\nStdDev: %f\nVar: %f\n--------------------\nY \nMean: %f\nMedian: %f\nStdDev: %f\nVar: %f\n====================", xMean, xMedian, xStdDev, xVariance, yMean, yMedian, yStdDev, yVariance];

    //Create the MONSTER STRING!!!!!!!!
    NSString *returnString = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@", simple, linear, logarithmic, exponential, power];

    //Do Dat Return Thang
    return returnString;

} //End constructText

- (void)setPreferredRegression {
    double lin = [linRegression[2] doubleValue];
    double log;
    double exp;
    double pow;

    if (canLogReg)
        log = [logRegression[2] doubleValue];
    else
        log = -1;
    if (canExpReg)
        exp = [expRegression[2] doubleValue];
    else
        exp = -1;
    if (canPowReg)
        pow = [powRegression[2] doubleValue];
    else
        pow = -1;

    NSArray *rValues = @[@((float) lin), @((float) log), @((float) exp), @((float) pow)];

    int index1 = (lin > log) ? 0 : 1;
    int index2 = (exp > pow) ? 2 : 3;
    int max = ([rValues[(NSUInteger) index1] doubleValue] > [rValues[(NSUInteger) index2] doubleValue]) ? index1 : index2;

    [data setPreferredRegression:max + 1];

} //End setPreferredRegression

@end





















