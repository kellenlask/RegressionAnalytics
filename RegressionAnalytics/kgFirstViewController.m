//
//  kgFirstViewController.m
//  RegressionAnalytics
//
//  Created by Maclab04 on 5/21/15.
//  Copyright (c) 2015 __GrahamKellen__. All rights reserved.
//

#import "kgFirstViewController.h"
#import "kgGlobalData.h"

int t = 0;
int position = 0;

@interface kgFirstViewController ()

@property (strong, nonatomic) NSMutableArray* inputXValues;
@property (strong, nonatomic) NSMutableArray* inputYValues;

@end


@implementation kgFirstViewController

kgGlobalData *data;

- (void)viewDidLoad
{
    [super viewDidLoad];
	data = [[kgGlobalData alloc] init];
    
    
    self.inputXValues = [[NSMutableArray array] init];
    self.inputYValues = [[NSMutableArray array] init];
    // Initialize the x and y lists to have 0 in them
    
    UITableView *tableView = (id)[self.view viewWithTag:1];
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = 20;
    [tableView setContentInset:contentInset];
	
} //End viewDidLoad



//--------------------------------------------------------
//
//		TableView Setup (mandatory things to build table and make it look nice)
//
//--------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(t==0)
        return 1; // if we don't have data yet, fill a cell with helpful text
    else
        return [self.inputXValues count]; // we want as many rows as we have data for
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SimpleTableIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:14]; // make stuff pretty
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if(t==0){
        cell.textLabel.text = [NSString stringWithFormat:@"Type in data values and press 'add data'"]; // we don't have data yet, here's the helpful text
        return cell;
    }
    else{
        cell.textLabel.text = [NSString stringWithFormat:@"(%3.3f, %3.3f)",[self.inputXValues[indexPath.row] doubleValue],[self.inputYValues[indexPath.row] doubleValue]]; // display the ordered pairs (x,y) in the table
        return cell;
    }
}

// When something in the table is selected
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (t == 0) {
        return nil; // don't try to delete the helpful text :(
    } else {
        return indexPath;
    }
}

//
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    position = (int) indexPath.row; // find out which data point is being deleted, and make it global
    NSString *message = [[NSString alloc] initWithFormat:
                         @"Would you like to delete (%3.3f,%3.3f)?", [_inputXValues[position] doubleValue], [_inputYValues[position] doubleValue]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:message delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes, I'm sure" otherButtonTitles:nil];
    
    [actionSheet showInView:self.view];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



//--------------------------------------------------------
//
//		ActionSheet Response
//
//--------------------------------------------------------


// if they make a decision on the action sheet
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != [actionSheet cancelButtonIndex])
    {
        [self removeData];
    }
}


//--------------------------------------------------------
//
//		Adding/Removing Data
//
//--------------------------------------------------------

- (IBAction)addData:(id)sender {
    
    double x = [_xField.text doubleValue]; // Pick the double values from the text fields
    double y = [_yField.text doubleValue];
    
    [_inputXValues addObject:[NSNumber numberWithDouble:x]]; // Add the values from the fields to our arrays
    [_inputYValues addObject:[NSNumber numberWithDouble:y]];
    
    [_tableView reloadData]; // refresh the table to show what we added
    NSLog([NSString stringWithFormat:@"Data added. Count: %d", (int) [_inputXValues count]]); // Log how much data we have for debugging purposes
    t++;
    
    _xField.text = @""; // reset the text fields to make things purdy
    _yField.text = @"";
}

// method to remove data from the arrays
- (IBAction)removeData
{
    [_inputXValues removeObjectAtIndex:position];
    [_inputYValues removeObjectAtIndex:position]; // rip the data out of the middle
    [_tableView reloadData];
    NSLog([NSString stringWithFormat:@"Data removed. Count: %d",(int) [_inputXValues count]]); // Log how much data we have for debugging purposes
    t--; // keep track of data with an extra integer (besides _inputXValues count) to prevent bugs in the interface
}
@end
