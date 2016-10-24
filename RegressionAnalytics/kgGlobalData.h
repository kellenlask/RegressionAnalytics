//
//  kgGlobalData.h
//  RegressionAnalytics
//
//  Created by Maclab04 on 5/30/15.
//  Copyright (c) 2015 __GrahamKellen__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kgGlobalData : NSObject
- (NSArray *)getXValues;

- (NSArray *)getYValues;

- (int)getPreferedRegression;

- (void)setXValues:(NSArray *)values;

- (void)setYValues:(NSArray *)values;

- (void)setPreferredRegression:(int)best;

//Methods when the user skips the regression tab
- (void)dataChanged;

- (void)dataRegressed;

- (BOOL)wasDataChanged;

- (int)getCurrentTab;

- (void)setTab:(NSInteger)tab;
@end