//
//  kgRegression.h
//  RegressionAnalytics
//
//  Created by Maclab04 on 5/22/15.
//  Copyright (c) 2015 __GrahamKellen__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kgRegression : NSObject
//Fiddly Bits
+ (double)calcStdDev:(NSArray *)values;

+ (double)calcVariance:(NSArray *)values;

+ (double)calcMean:(NSArray *)values;

+ (double)calcMedian:(NSArray *)values;

//Regressions
+ (NSArray *)linReg:(NSArray *)xVals yValues:(NSArray *)yVals;

+ (NSArray *)logReg:(NSArray *)xVals yValues:(NSArray *)yVals;

+ (NSArray *)expReg:(NSArray *)xVals yValues:(NSArray *)yVals;

+ (NSArray *)powReg:(NSArray *)xVals yValues:(NSArray *)yVals;
@end
