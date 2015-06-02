//
//  kgFirstViewController.h
//  RegressionAnalytics
//
//  Created by Maclab04 on 5/21/15.
//  Copyright (c) 2015 __GrahamKellen__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kgFirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *xField;
@property (weak, nonatomic) IBOutlet UITextField *yField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addData:(id)sender;


@end
