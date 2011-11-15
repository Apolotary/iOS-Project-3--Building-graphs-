//
//  GraphViewModel.m
//  TableGraphThirdEd
//
//  Created by user on 18.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphViewModel.h"


@implementation GraphViewModel

@synthesize arrayOfYCoordinates, arrayOfScaledYCoordinates, arrayOfScaledXAxisBiggerDashes,
arrayOfScaledXAxisSmallerDashes, arrayOfAllDashesTogether, arrayOfScaledYAxisCoordinates, scaledAxisMultiplier, arrayOfScaledYAxisGridCoordinates, userArray, distance, period, periodExponent, step,
            stepX, stepY;

static GraphViewModel *_sharedInstance = nil;

static void singleton_remover() {
    if (_sharedInstance) {
        [_sharedInstance release];
    }
}

+(GraphViewModel *) sharedInstance
{
    if (!_sharedInstance) {
        _sharedInstance = [[GraphViewModel alloc] init];
        // release instance at exit
        atexit(singleton_remover);
    }
    return _sharedInstance;
}

-(void) calculatePeriodExponent
{
    periodExponent = 0;
    int tmp = period;
    while (tmp != 1)
    {
        tmp /= 10;
        ++periodExponent;
    }
}

-(void) loadUserDefaults
{
    [self assignToArrayOfYCoordinates:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"model"]]];
}

-(void) saveUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:userArray] 
                                              forKey:@"model"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) addCoordinateToScaledYAxisArray: (CGFloat) tmp
{
    [arrayOfScaledYAxisCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(0,tmp)]];
}

-(void) makeACopyForUserArray
{
    [userArray removeAllObjects];
    for (int i = 0; i < [arrayOfYCoordinates count]; ++i)
    {
        NSValue * tmp = [[arrayOfYCoordinates objectAtIndex:i] copy];
        [userArray addObject:tmp];
        [tmp release];
    }
}

-(void) resetFromUserArray
{
    [arrayOfYCoordinates removeAllObjects];
    for (int i = 0; i < [userArray count]; ++i)
    {
        NSValue * tmp = [[userArray objectAtIndex:i]copy];
        [arrayOfYCoordinates addObject:tmp];
        [tmp release];
    }
}

-(void) fillAnArrayOfAllDashes
{
    int counter = 0;
    BOOL tmp = NO;
    while(!tmp)
    {
        if(counter < [arrayOfScaledXAxisBiggerDashes count])
        {
            [arrayOfAllDashesTogether addObject:[arrayOfScaledXAxisBiggerDashes objectAtIndex:counter]];
        }
        if (counter < [arrayOfScaledXAxisSmallerDashes count])
        {
            [arrayOfAllDashesTogether addObject:[arrayOfScaledXAxisSmallerDashes objectAtIndex:counter]];
        }
        if (counter >= [arrayOfScaledXAxisBiggerDashes count] && counter >= [arrayOfScaledXAxisSmallerDashes count])
        {
            break;
        }
        ++counter;
    }
}

-(void) assignToArrayOfYCoordinates: (NSMutableArray*) arr
{
    [arrayOfYCoordinates release];
    arrayOfYCoordinates = [[NSMutableArray alloc ] initWithArray:arr  copyItems:YES];
}

-(void) clearAnArrayOfYCoordinates
{
    [arrayOfYCoordinates removeAllObjects];
}

-(void) insertYCoordinate: (CGPoint) coordinate
{
    [arrayOfYCoordinates addObject:[NSValue valueWithCGPoint:coordinate]];
}

-(void) insertYCoordinate: (CGPoint) coordinate
                  atIndex: (NSInteger) index
{
    [arrayOfYCoordinates insertObject:[NSValue valueWithCGPoint:coordinate]
                              atIndex:index];
}

-(void) removeYCoordinateAtIndex: (NSInteger) index
{
    [arrayOfYCoordinates removeObjectAtIndex:index];
}

-(void) replaceYCoordinateAtIndex: (NSInteger) index
                       withPoint: (CGPoint) point
{
    [arrayOfYCoordinates replaceObjectAtIndex:index withObject:[NSValue valueWithCGPoint:point]];
}

-(void) exchangeYCoordinateAtIndex: (NSInteger) indexOne
             withCoordinateAtIndex: (NSInteger) indexTwo
{
        [arrayOfYCoordinates exchangeObjectAtIndex:indexOne 
                                 withObjectAtIndex:indexTwo];
}

-(CGPoint) returnPointFromArrayAtIndex: (NSInteger) index
{
   return [[arrayOfYCoordinates objectAtIndex:index] CGPointValue];
}

-(void) clearAnArrayOfScaledCoordinates
{
    [arrayOfScaledYCoordinates removeAllObjects];
    [arrayOfScaledXAxisBiggerDashes removeAllObjects];
    [arrayOfScaledXAxisSmallerDashes removeAllObjects];
    [arrayOfAllDashesTogether removeAllObjects];
    [arrayOfScaledYAxisCoordinates removeAllObjects];
    [arrayOfScaledYAxisGridCoordinates removeAllObjects];
}

-(void) calculateResizedPointsForChartWithWidth:(CGFloat) frameWidth
                                      andHeight:(CGFloat) frameHeight
{
    int amountOfPoints = [arrayOfYCoordinates count];
    CGPoint tmp;
    stepX = frameWidth / (amountOfPoints - 1);
    NSLog(@"stepX: %f", stepX);
    CGFloat maxY, minY;
    
    
    for (int i = 0; i < amountOfPoints; ++i)
    {
        tmp = [[arrayOfYCoordinates objectAtIndex:i] CGPointValue];
        if (tmp.y > maxY)
        {
            maxY = tmp.y;
        }
        if (tmp.y < minY)
        {
            minY = tmp.y;
        }
    }
    
    if (maxY < (-1)*minY)
    {
        distance = minY;
    }
    else
    {
        distance = maxY;
    }
    
    if(distance < 0)
    {
        distance *= -1;
    }
    
    stepY = (frameHeight/2) / distance;
    
    NSLog(@"distance = %f  stepY = %f", distance, stepY);
    
    // filling the array of scaled points

    double counter = 2;
    for (int i = 0; i < amountOfPoints; ++i)
    {
        tmp = [[arrayOfYCoordinates objectAtIndex:i] CGPointValue];
        tmp.x *= stepX;
        while (tmp.x > frameWidth) 
        {
            NSLog(@"recounting");
            stepX /= counter;
            tmp = [[arrayOfYCoordinates lastObject] CGPointValue];
            tmp.x *= stepX;
            counter++;
        }
    }
        
    for (int i = 0; i < amountOfPoints; ++i)
    {
        tmp = [[arrayOfYCoordinates objectAtIndex:i] CGPointValue];
        tmp.x *= stepX;
        tmp.y *= stepY;
        [arrayOfScaledYCoordinates addObject:[NSValue valueWithCGPoint:tmp]];
        NSLog(@"tmp.x %f", tmp.x);
    }
}

-(void) calculateScaledXAxisPoints: (CGFloat) frameWidth
             whereYCenterisEqualTo: (CGFloat) frameCenter
{
    
    CGPoint tmpB = CGPointMake(0, frameCenter);
    CGPoint tmpS = CGPointMake(0, frameCenter);
    
    NSLog(@"stepx: %f", stepX);
    
    scaledAxisMultiplier = ceilf(stepX);
    
    NSLog(@"mul1 %d", scaledAxisMultiplier);
    
    NSLog(@"tmp 1: %d", scaledAxisMultiplier);
    
    if(scaledAxisMultiplier % 10 != 0)
    {
        scaledAxisMultiplier += 10 - (scaledAxisMultiplier % 10);
    }
    scaledAxisMultiplier /= 2;
    
    NSLog(@"tmp 2: %d", scaledAxisMultiplier);
    
    if (scaledAxisMultiplier < 0)
    {
        scaledAxisMultiplier *= -1;
    }
    
    tmpB.x += scaledAxisMultiplier;
    tmpS.x += tmpB.x + scaledAxisMultiplier;
    
    while (tmpS.x - tmpB.x < 20)
    {
        scaledAxisMultiplier *= 2;
        
        tmpB.x += scaledAxisMultiplier;
        tmpS.x += tmpB.x + scaledAxisMultiplier;
    }
    
    tmpB = CGPointMake(0, frameCenter);
    tmpS = CGPointMake(0, frameCenter);
    CGPoint tmpY = CGPointMake(0, 0);
    
    period = 1;
    
    
    while (distance*period <= 1)
    {
        period *= 10;
    }
    
    NSLog(@"per: %d", period);
    
    NSLog(@"mul12 %d", scaledAxisMultiplier);
    
    BOOL addToBiggerDashesArray = YES;
    
    tmpY.y = 0.5*(stepY/period);
    
    CGFloat tmp = 0.5*(stepY/period);
    
    step = 1;
    
    while (tmp < 25)
    {
        tmp += 0.5*(stepY/period);
        step++;
    }
    
    while (tmpY.y <= frameCenter*2)
    {
        NSLog(@"y: %f", tmpY.y);
        [arrayOfScaledYAxisGridCoordinates addObject:[NSValue valueWithCGPoint:tmpY]];
        tmpY.y += 0.5*(stepY/period); 
    }

    while (tmpB.x <= frameWidth && tmpS.x <= frameWidth)
    {
        if (addToBiggerDashesArray)
        {
            [arrayOfScaledXAxisBiggerDashes addObject:[NSValue valueWithCGPoint:tmpB]];
            addToBiggerDashesArray = NO;
        }
        else
        {
            [arrayOfScaledXAxisSmallerDashes addObject:[NSValue valueWithCGPoint:tmpS]];
            addToBiggerDashesArray = YES;
        }
        
        tmpB.x += scaledAxisMultiplier;
        tmpS.x += scaledAxisMultiplier;
        NSLog(@"tmps.x %f multiplier: %d", tmpS.x, scaledAxisMultiplier);
    }
}

-(id) init
{
    if ((self = [super init]))
    {
        arrayOfYCoordinates = [[NSMutableArray alloc] init];
        arrayOfScaledYCoordinates = [[NSMutableArray alloc] init];
        arrayOfScaledXAxisBiggerDashes = [[NSMutableArray alloc] init];
        arrayOfScaledXAxisSmallerDashes = [[NSMutableArray alloc] init];
        arrayOfAllDashesTogether = [[NSMutableArray alloc] init];
        arrayOfScaledYAxisCoordinates = [[NSMutableArray alloc] init];
        arrayOfScaledYAxisGridCoordinates = [[NSMutableArray alloc] init];
        userArray = [[NSMutableArray alloc] init];
        // we don't really need cgpoints here, since we don't use x coordinates
        [arrayOfYCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(0, 1)]];
        [arrayOfYCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(1, -2)]];
        [arrayOfYCoordinates addObject:[NSValue valueWithCGPoint:CGPointMake(2, 2)]];
    }
    
    return self;
}

-(void)dealloc
{
    [arrayOfYCoordinates release];
    [arrayOfScaledYCoordinates release];
    [arrayOfScaledXAxisBiggerDashes release];
    [arrayOfScaledXAxisSmallerDashes release];
    [arrayOfScaledYAxisCoordinates release];
    [arrayOfScaledYAxisGridCoordinates release];
    [arrayOfAllDashesTogether release];
    [userArray release];
    [super dealloc];
}

@end
