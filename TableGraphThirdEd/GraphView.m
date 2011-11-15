//
//  GraphView.m
//  TableGraphThirdEd
//
//  Created by user on 18.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"


@implementation GraphView

@synthesize graphViewDataInGraph, previousYCoordinateWasNegative, tehButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(CGPoint) alignPointWithFakedXAxis: (CGPoint) tmp
{
    if (isnan(tmp.y))
    {
        tmp.y = 0;
    }
    if(tmp.y < 0)
    {
        tmp.y = self.frame.size.height/2 + tmp.y*(-1);
    }
    else if(tmp.y > 0)
    {
        tmp.y = self.frame.size.height/2 - tmp.y;
    }
    else if (tmp.y == 0)
    {
        tmp.y = self.frame.size.height/2;
    }
    return tmp;
}

-(CGPoint) alignPointWithFakedXAxisReversed: (CGPoint) tmp
{
    if(tmp.y < self.frame.size.height/2)
    {
        tmp.y = self.frame.size.height/2 - tmp.y;
    }
    else if(tmp.y > self.frame.size.height/2)
    {
        tmp.y = (tmp.y - self.frame.size.height/2) * (-1);
    }
    else if (tmp.y == self.frame.size.height/2)
    {
        tmp.y = 0;
    }
    return tmp;
}

-(void) drawTextInContext
{
    [graphViewDataInGraph fillAnArrayOfAllDashes];
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    NSLog(@"calling method, array of all dashes = %d", [graphViewDataInGraph.arrayOfAllDashesTogether count]);
    
    CGContextSetRGBFillColor(c, 0.0, 0.0, 0.0, 1.0);
    
    CGContextSelectFont(c, "Helvetica", 10, kCGEncodingMacRoman);
	CGContextSetTextMatrix(c, CGAffineTransformMakeScale(1.0, -1.0));
	CGContextSetTextDrawingMode(c, kCGTextFill);
    
    CGPoint prevPoint, currPoint, tmpPoint;
    
    int step = 0;
    int prevI = 0;
    
    int multiplierForFormat = 1;
    
    if ([graphViewDataInGraph.arrayOfScaledYCoordinates count] > 100)
    {
        multiplierForFormat *= 10;
    }
    
    // drawing for x axis
    for (int i = 1; i + step < [graphViewDataInGraph.arrayOfAllDashesTogether count]; ++i) 
    {
        NSLog(@"step = %d", step);
        prevPoint = [[graphViewDataInGraph.arrayOfAllDashesTogether objectAtIndex:prevI] CGPointValue];
        currPoint = [[graphViewDataInGraph.arrayOfAllDashesTogether objectAtIndex:(i + step)] CGPointValue];
        
        prevI = i + step;
        
        NSLog(@"curr: %@", NSStringFromCGPoint(currPoint));
        NSLog(@"prev: %@", NSStringFromCGPoint(prevPoint));
        NSString * tmp =  [[NSString alloc] initWithFormat:@"%d", (int)prevPoint.x * multiplierForFormat/graphViewDataInGraph.scaledAxisMultiplier]; 
        NSLog(@"str: %@", tmp);
        if(currPoint.x - prevPoint.x > 15)
        {
            NSLog(@"if triggered");
            const char *tmp2 = [tmp UTF8String];
            CGContextShowTextAtPoint(c, prevPoint.x, prevPoint.y+20, tmp2, [tmp length]);
        }
        else
        {
            step++;
        }

        [tmp release];
    }
    NSString * tmp =  [[NSString alloc] initWithFormat:@"%d", (int)currPoint.x/graphViewDataInGraph.scaledAxisMultiplier]; 
    const char *tmp2 = [tmp UTF8String];
    CGContextShowTextAtPoint(c, currPoint.x, currPoint.y+20, tmp2, [tmp length]);
    [tmp release];
    
    [graphViewDataInGraph calculatePeriodExponent];
    for (int i = 0; i < [graphViewDataInGraph.arrayOfScaledYAxisGridCoordinates count]; i += graphViewDataInGraph.step)
    {
        prevPoint = [[graphViewDataInGraph.arrayOfScaledYAxisGridCoordinates objectAtIndex:i] CGPointValue];
        if (prevPoint.y < (self.frame.size.height/2) - 25|| prevPoint.y > (self.frame.size.height/2) + 25 || prevPoint.y == (self.frame.size.width/2) )
        {
            tmpPoint = [self alignPointWithFakedXAxisReversed:prevPoint];
            
            CGFloat tmpF = (tmpPoint.y/graphViewDataInGraph.stepY);
            
            if (tmpF < 0)
            {
                tmpF *= -1;
            }
            
            if (tmpF <= 1000 && tmpF >= 1)
            {
                NSString * tmp =  [[NSString alloc] initWithFormat:@"%1.1f", tmpF]; 
                const char *tmp2 = [tmp UTF8String];
                CGContextShowTextAtPoint(c, 5, prevPoint.y+10, tmp2, [tmp length]);
                [tmp release];
            }
            else if(tmpF < 1 && tmpF >= 0.01)
            {
                if (graphViewDataInGraph.period == 1)
                {
                    NSString * tmp =  [[NSString alloc] initWithFormat:@"%1.1f", tmpF*graphViewDataInGraph.period]; 
                    const char *tmp2 = [tmp UTF8String];
                    CGContextShowTextAtPoint(c, 5, prevPoint.y+10, tmp2, [tmp length]);
                    [tmp release];
                }
                else
                {
                    NSString * tmp =  [[NSString alloc] initWithFormat:@"%1.2f", tmpF*graphViewDataInGraph.period/10]; 
                    const char *tmp2 = [tmp UTF8String];
                    CGContextShowTextAtPoint(c, 5, prevPoint.y+10, tmp2, [tmp length]);
                    [tmp release];
                }
            }
            else if (tmpF < 0.01 && tmpF >= 0.001)
            {
                NSString * tmp =  [[NSString alloc] initWithFormat:@"%1.4f", tmpF*graphViewDataInGraph.period/100]; 
                const char *tmp2 = [tmp UTF8String];
                CGContextShowTextAtPoint(c, 5, prevPoint.y+10, tmp2, [tmp length]);
                [tmp release];
            }
            else if (tmpF < 0.001 && tmpF >= 0.0001)
            {
                NSString * tmp =  [[NSString alloc] initWithFormat:@"%1.5f", tmpF*graphViewDataInGraph.period/1000]; 
                const char *tmp2 = [tmp UTF8String];
                CGContextShowTextAtPoint(c, 5, prevPoint.y+10, tmp2, [tmp length]);
                [tmp release];
            }
            else
            {
                NSString * tmp =  [[NSString alloc] initWithFormat:@"%1.1f*10^%d", (tmpPoint.y/graphViewDataInGraph.stepY)*graphViewDataInGraph.period, graphViewDataInGraph.periodExponent]; 
                const char *tmp2 = [tmp UTF8String];
                CGContextShowTextAtPoint(c, 5, prevPoint.y+10, tmp2, [tmp length]);
                [tmp release];
            }
        }
    }
    CGContextStrokePath(c);    
}

-(void) drawGrid
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGFloat gray[4] = {0.0f, 0.0f, 0.0f, 0.25f};
    
    CGContextSetStrokeColor(c, gray);
    CGPoint tmp;
    CGContextBeginPath(c);
    for (int i = 0; i < [graphViewDataInGraph.arrayOfScaledXAxisBiggerDashes count]; ++i)
    {
        tmp = [[graphViewDataInGraph.arrayOfScaledXAxisBiggerDashes objectAtIndex:i] CGPointValue];
        NSLog(@"B: %@", NSStringFromCGPoint(tmp));
        CGContextMoveToPoint(c, tmp.x, 0);
        CGContextAddLineToPoint(c, tmp.x, self.frame.size.height);
    }
    for (int i = 0; i < [graphViewDataInGraph.arrayOfScaledXAxisSmallerDashes count]; ++i)
    {
        tmp = [[graphViewDataInGraph.arrayOfScaledXAxisSmallerDashes objectAtIndex:i] CGPointValue];
        NSLog(@"S: %@", NSStringFromCGPoint(tmp));
        CGContextMoveToPoint(c, tmp.x, 0);
        CGContextAddLineToPoint(c, tmp.x, self.frame.size.height);
    }
    NSLog(@"stepY: %f", graphViewDataInGraph.stepY);

    CGPoint tmpPoint;

    for (int i = 0; i < [graphViewDataInGraph.arrayOfScaledYAxisGridCoordinates count]; i += graphViewDataInGraph.step)
    {
        tmpPoint = [[graphViewDataInGraph.arrayOfScaledYAxisGridCoordinates objectAtIndex:i] CGPointValue];
        NSLog(@"pp: %f", tmpPoint.y);
        if (tmpPoint.y < (self.frame.size.height/2) - 25|| tmpPoint.y > (self.frame.size.height/2) + 25 || tmpPoint.y == (self.frame.size.width/2) )
        {
            NSLog(@"pp2: %f", tmpPoint.y);
            CGContextMoveToPoint(c, 0, tmpPoint.y);
            CGContextAddLineToPoint(c, self.frame.size.width, tmpPoint.y);
        }
    }
    
    CGContextStrokePath(c);
}

-(void) drawXAxisScale
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGRect rect;
    CGPoint tmp;
    int heightOfBiggerDash = 16;
    int heightOfSmallerDash = 10;
    
    CGContextBeginPath(c);
    CGContextSetFillColorWithColor(c, [[UIColor blackColor] CGColor]);
    for (int i = [graphViewDataInGraph.arrayOfScaledXAxisBiggerDashes count] - 1; i >= 0 ; --i)
    {
        NSLog(@"imin: %d", i);
        tmp = [[graphViewDataInGraph.arrayOfScaledXAxisBiggerDashes objectAtIndex:i] CGPointValue];
        NSLog(@"B: %@", NSStringFromCGPoint(tmp));
        rect = CGRectMake(tmp.x, tmp.y-heightOfBiggerDash/2, 1, heightOfBiggerDash);
        CGContextAddRect(c, rect);
        CGContextFillRect(c, rect);
    }
    
    CGContextBeginPath(c);
    for (int i = [graphViewDataInGraph.arrayOfScaledXAxisSmallerDashes count] - 1; i >= 0 ; --i)
    {
        NSLog(@"imin: %d", i);
        tmp = [[graphViewDataInGraph.arrayOfScaledXAxisSmallerDashes objectAtIndex:i] CGPointValue];
        NSLog(@"S: %@", NSStringFromCGPoint(tmp));
        rect = CGRectMake(tmp.x, tmp.y-heightOfSmallerDash/2, 1, heightOfSmallerDash);
        CGContextAddRect(c, rect);
        CGContextFillRect(c, rect);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //self.backgroundColor = [UIColor blackColor];
    graphViewDataInGraph = [GraphViewModel sharedInstance];
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(c, 1.0);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat blue[8] = {0.0f, 0.0f, 1.0f, 1.0f,   // blue
                        1.0f, 0.0f, 0.0f, 0.0f}; // red
    CGFloat green[8] = {0.0f, 1.0f, 0.0f, 0.0f,  // green
                        0.0f, 0.0f, 1.0f, 1.0f}; // blue

    CGFloat arr[2] = {0, 1};
        
    CGGradientRef g = CGGradientCreateWithColorComponents(colorSpace, blue, arr, sizeof(blue)/(sizeof(blue[0])*4));
    CGGradientRef g2 = CGGradientCreateWithColorComponents(colorSpace, green, arr, sizeof(green)/(sizeof(green[0])*4));
    
    CGColorSpaceRelease(colorSpace);
    
    CGFloat screenCenter = self.frame.size.height/2;
//  X axis    
    CGContextBeginPath(c);
    
    CGContextMoveToPoint(c, 0, screenCenter);//set the entry point to the center
    CGContextAddLineToPoint(c, self.frame.size.width, screenCenter);
    CGContextSetLineWidth(c, 1);
    CGContextClosePath(c);
    CGContextStrokePath(c);

    CGContextBeginPath(c);
    
    CGContextMoveToPoint(c, 0, screenCenter);
    CGPoint tmp;
    [graphViewDataInGraph calculateResizedPointsForChartWithWidth:self.frame.size.width andHeight:self.frame.size.height];
    for(int i = 0; i < [graphViewDataInGraph.arrayOfScaledYCoordinates count]; ++i)
    {
        tmp = [[graphViewDataInGraph.arrayOfScaledYCoordinates objectAtIndex:i] CGPointValue];
        
        tmp = [self alignPointWithFakedXAxis:tmp];
                
        CGContextAddLineToPoint(c, tmp.x, tmp.y);
        NSLog(@"screencenter: %f %f", tmp.x, tmp.y);
    }
    CGContextAddLineToPoint (c, tmp.x, screenCenter);
    
    CGContextSaveGState(c);
    CGContextClosePath(c);
    CGContextClip(c);
    CGContextStrokePath(c);
    
    CGContextDrawLinearGradient(c, g, CGPointMake(0,0), CGPointMake(0, screenCenter), 0);
    CGContextDrawLinearGradient(c, g2, CGPointMake(0, screenCenter), CGPointMake(0, self.frame.size.height), 0);
    
    CGContextRestoreGState(c);

    CGGradientRelease(g);
    CGGradientRelease(g2);
    [graphViewDataInGraph calculateScaledXAxisPoints:self.frame.size.width whereYCenterisEqualTo:screenCenter];

    [self drawXAxisScale];
    [self drawGrid];
    [self drawTextInContext];
    [graphViewDataInGraph clearAnArrayOfScaledCoordinates];
}

-(IBAction) screenButtonWasPressed:(UIButton *) sender
{
    tehButton.hidden = YES;
    UIGraphicsBeginImageContext(CGSizeMake(320,415));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    [UIImageJPEGRepresentation(screenShot, 1.0) writeToFile:@"screen.jpg" atomically:NO];
    UIGraphicsEndImageContext();
    tehButton.hidden = NO;
    NSLog(@"image saved");
}

- (void)dealloc
{
    [tehButton release];
    [super dealloc];
}

@end
