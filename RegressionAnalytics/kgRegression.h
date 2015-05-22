//
//  kgRegression.h
//  RegressionAnalytics
//
//  Created by Maclab04 on 5/22/15.
//  Copyright (c) 2015 __GrahamKellen__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kgRegression : NSObject
+(double)calcStdDev:(NSArray*)values;
+(double)calcVariance:(NSArray*)values;
+(double)calcMean:(NSArray*)values;
+(double)calcMedian:(NSArray*)values;


@end
