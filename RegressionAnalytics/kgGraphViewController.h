//
//  kgGraphViewController.h
//  RegressionAnalytics
//
//  Created by Maclab04 on 5/21/15.
//  Copyright (c) 2015 __GrahamKellen__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kgGraphViewController : UIViewController
@property(strong, nonatomic) IBOutlet UIStepper *zoom;
@property(strong, nonatomic) IBOutlet UILabel *equation;
@property(strong, nonatomic) IBOutlet UIImageView *canvasView;

- (IBAction)zoom:(UIStepper *)sender;
@end
