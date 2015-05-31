//
//  kgGraphViewController.m
//  RegressionAnalytics
//
//  Created by Maclab04 on 5/21/15.
//  Copyright (c) 2015 __GrahamKellen__. All rights reserved.
//

#import "kgGraphViewController.h"
#import "kgGlobalData.h"

@implementation kgGraphViewController

int resolution = 500;
double xmin = -10.;
double xmax = 10.;
double ymin = -10.;
double ymax = 10.;
kgGlobalData *data;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	data = [[kgGlobalData alloc] init];

} //End viewDidLoad

-(void)determineFunction
{
	double x[resolution];
    double y[resolution];
    double dx=(xmax-xmin)/resolution;
    
    for(int i = 0; i < resolution; i++)
    {
        x[i]=xmin+i*dx;
    }
    
    switch([data getPreferedRegression])
    {
        case 0: //None
            for(int i=0;i<resolution;i++)
            {
                y[i]=0.4*x[i]-1;
            }
            break;
        case 1: //Linear
            for(int i=0;i<resolution;i++)
            {
                y[i]=x[i]*x[i]-4;
            }
            break;
        case 2: //Log
            for(int i=0;i<resolution;i++)
            {
                y[i]=sin(x[i]);
            }
            break;
        case 3: //Exp
            for(int i=0;i<resolution;i++)
            {
                y[i]=cos(10*x[i]);
            }
            break;
        case 4: //Power
            for(int i=0;i<resolution;i++)
            {
                y[i]=exp(x[i]/4);
            }
            break;
    }
    
    [self drawGraph:x y:y];	
	
} //End determineFunction

- (IBAction)zoom:(UIStepper *)sender 
{

}

- (void)drawGraph:(double[])x y:(double[])y
{
    // Draw the current shape
    _canvasView.image = nil;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.canvasView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5);
    // All set to draw
    
	//Set the axis to the halves
    double yAxis = self.view.frame.size.width / 2;
    double xAxis = self.view.frame.size.height / 2;
    
    // Re-scale the points to fit in the window
    for(int i=0;i<resolution;i++)
    {
        x[i]=[self xToGraph:x[i]];
        y[i]=yAxis-[self yToGraph:y[i]];
    }
    
    // Draw the axes
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, yAxis);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.view.frame.size.width, yAxis);
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), xAxis, 0);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), xAxis, self.view.frame.size.height);
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x[0], y[0]);
    
    // Ready to draw the curve
    for(int i=1;i<resolution;i++)
    {
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x[i], y[i]);
    }
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    self.canvasView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Graphics updated and loaded
}

-(void)drawPoint:(int)x y:(int)y
{
	CGContextAddEllipseInRect(UIGraphicsGetCurrentContext(), (CGRectMake (x, y, 3.0, 3.0)));
	CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFill);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
}

- (double)xToGraph:(double)x
{
    return (320.*x/(xmax-xmin));
}

- (double)yToGraph:(double)y
{
    return (568.*y/(ymax-ymin));
}



@end
