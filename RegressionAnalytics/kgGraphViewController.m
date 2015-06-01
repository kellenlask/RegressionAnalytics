//
//  kgGraphViewController.m
//  RegressionAnalytics
//
//  Created by Maclab04 on 5/21/15.
//  Copyright (c) 2015 __GrahamKellen__. All rights reserved.
//

#import "kgGraphViewController.h"
#import "kgGlobalData.h"
#import "kgRegression.h"

@implementation kgGraphViewController

kgGlobalData *data;

int resolution = 500;

double xmin = -10.;
double xmax = 10.;
double ymin = -10.;
double ymax = 10.;

NSArray* regression;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
} //End viewDidLoad

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	data = [[kgGlobalData alloc] init];
	
	//Make sure we don't try to graph something impossible
	if(data.getXValues.count !=  data.getYValues.count) {
		NSString* error = @"Error: Data entry mismatch.";
		[_equation setText:error];
		
	} else if(data.getXValues.count == 0 || data.getYValues.count == 0) {
		NSString* error = @"No data entered.";
		[_equation setText:error];
		
	} else {
		[self prepareFunction];
	}
	
}

-(void)prepareFunction
{
	double x[resolution];
    double y[resolution];
    double dx=(xmax-xmin)/resolution;
    
    for(int i = 0; i < resolution; i++)
    {
        x[i]=xmin+i*dx;
    }
	
    NSString* curve;	
	
    switch([data getPreferedRegression])
    {
        default: //None
            break;
			
        case 1: //Linear
			regression = [kgRegression linReg:data.getXValues yValues:data.getYValues];
			
			curve = [NSString stringWithFormat:@"y=(%f)x+(%f)", [regression[1] doubleValue], [regression[0] doubleValue]];
			[_equation setText:curve];
			
            for(int i=0;i<resolution;i++)
            {
                y[i]=[regression[1] doubleValue]*x[i]-[regression[0] doubleValue];
            }
			
			[self drawGraph:x y:y];	
            break;
			
        case 2: //Log
			regression = [kgRegression logReg:data.getXValues yValues:data.getYValues];
			
			curve = [NSString stringWithFormat:@"y=log((%f)x+(%f))", [regression[1] doubleValue], [regression[0] doubleValue]];
			[_equation setText:curve];
			
            for(int i=0;i<resolution;i++)
            {
                y[i]=log([regression[1] doubleValue]*x[i]+[regression[0] doubleValue]);
            }
			
			[self drawGraph:x y:y];	
            break;
			
        case 3: //Exp
			regression = [kgRegression expReg:data.getXValues yValues:data.getYValues];
			
			curve = [NSString stringWithFormat:@"y=e^((%f)x+(%f))", [regression[1] doubleValue], [regression[0] doubleValue]];
			[_equation setText:curve];
			
            for(int i=0;i<resolution;i++)
            {
                y[i]=pow(M_E, ([regression[1] doubleValue]*x[i]+[regression[0] doubleValue]));
            }
			
			[self drawGraph:x y:y];	
            break;
			
        case 4: //Power
			regression = [kgRegression powReg:data.getXValues yValues:data.getYValues];
			
			curve = [NSString stringWithFormat:@"y=(%f)x^(%f)", [regression[1] doubleValue], [regression[0] doubleValue]];
			[_equation setText:curve];
			
            for(int i=0;i<resolution;i++)
            {
                y[i]=pow([regression[1] doubleValue]*x[i], [regression[0] doubleValue]);
            }
			
			[self drawGraph:x y:y];	
            break;
    } //End Switch
} //End prepareFunction

- (IBAction)zoom:(UIStepper *)sender 
{
	//Get the Stepper Value
	int zoomLevel = _zoom.value;
	
	//Scale the window
	xmax = 10 * pow(1.5, zoomLevel);
	xmin = -10 * pow(1.5, zoomLevel);
	ymax = 10 * pow(1.5, zoomLevel);
	ymin = -10 * pow(1.5, zoomLevel);
	
	//Redraw the graph
	[self prepareFunction];
	
} //End zoom

- (void)drawGraph:(double[])x y:(double[])y
{
    //Prepare the Canvas
	_canvasView.image = nil;
	UIGraphicsBeginImageContext(self.view.frame.size);
	[self.canvasView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5);
    
	//Setup the axis
    double yAxis = self.view.frame.size.width / 2;
    double xAxis = self.view.frame.size.height / 2;
    
    //Re-scale the points to fit in the window
    for(int i=0;i<resolution;i++)
    {
        x[i]=[self xToGraph:x[i]];
        y[i]=yAxis-[self yToGraph:y[i]];
    }
    
    //Draw the axes
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, yAxis);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.view.frame.size.width, yAxis);
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), xAxis, 0);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), xAxis, self.view.frame.size.height);
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x[0], y[0]);
    
    //Draw the curve
    for(int i=1;i<resolution;i++)
    {
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x[i], y[i]);
    }
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    self.canvasView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
} //End drawGraph

//Draws a point on the graph
-(void)drawPoint:(int)x y:(int)y
{
	CGContextAddEllipseInRect(UIGraphicsGetCurrentContext(), (CGRectMake (x, y, 3.0, 3.0)));
	CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFill);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
}

//Scales the window to the ImageView dx
- (double)xToGraph:(double)x
{
    return (self.view.frame.size.width*x/(xmax-xmin));
}

//Scales the window to the ImageView dy
- (double)yToGraph:(double)y
{
    return (self.view.frame.size.height*y/(ymax-ymin));
}



@end
