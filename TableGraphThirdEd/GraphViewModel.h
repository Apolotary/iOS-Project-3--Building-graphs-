//
//  GraphViewModel.h
//  TableGraphThirdEd
//
//  Created by user on 18.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GraphViewModelDataSource <NSObject>

// methods for basic data manipulations
@required

// methods for basic saving/loading interaction
-(void) loadUserDefaults;
-(void) saveUserDefaults;

// methods for changing data in array with coordinates
// use default methods from NSMutable array
// for these methods' implementation
-(void) insertYCoordinate: (CGPoint) coordinate;
-(void) insertYCoordinate: (CGPoint) coordinate
                  atIndex: (NSInteger) index;
-(void) replaceYCoordinateAtIndex: (NSInteger) index
                        withPoint: (CGPoint) point;
-(void) removeYCoordinateAtIndex: (NSInteger) index;
-(void) exchangeYCoordinateAtIndex: (NSInteger) indexOne
             withCoordinateAtIndex: (NSInteger) indexTwo;
-(void) clearAnArrayOfYCoordinates;

// returns value stored in the array converted to CGPoint
-(CGPoint) returnPointFromArrayAtIndex: (NSInteger) index;

@optional

// in case if you use a separate array for user data
-(void) makeACopyForUserArray;
-(void) resetFromUserArray;

// providing points for automatic scaling
-(void) assignToArrayOfYCoordinates: (NSMutableArray*) arr;
-(void) calculateScaledXAxisPoints: (CGFloat) frameWidth
             whereYCenterisEqualTo: (CGFloat) frameCenter;
-(void) addCoordinateToScaledYAxisArray: (CGFloat) tmp;
-(void) calculateResizedPointsForChartWithWidth:(CGFloat) frameWidth
                                      andHeight:(CGFloat) frameHeight;
-(void) fillAnArrayOfAllDashes;
-(void) clearAnArrayOfScaledCoordinates;

-(void) calculatePeriodExponent;

@end


@interface GraphViewModel : NSObject <GraphViewModelDataSource>
{
    NSMutableArray * arrayOfYCoordinates;
    NSMutableArray * arrayOfScaledYCoordinates;
    NSMutableArray * arrayOfScaledXAxisBiggerDashes;
    NSMutableArray * arrayOfScaledXAxisSmallerDashes;
    NSMutableArray * arrayOfScaledYAxisGridCoordinates;
    NSMutableArray * arrayOfScaledYAxisCoordinates;
    NSMutableArray * arrayOfAllDashesTogether;
    NSMutableArray * userArray;
    int              scaledAxisMultiplier;
    int              period;
    int              periodExponent;
    int              step;
    CGFloat          distance;
    CGFloat          stepX;
    CGFloat          stepY;
}

@property (nonatomic, retain) NSMutableArray * arrayOfYCoordinates;
@property (nonatomic, retain) NSMutableArray * arrayOfScaledYCoordinates;
@property (nonatomic, retain) NSMutableArray * arrayOfScaledXAxisBiggerDashes;
@property (nonatomic, retain) NSMutableArray * arrayOfScaledXAxisSmallerDashes;
@property (nonatomic, retain) NSMutableArray * arrayOfAllDashesTogether;
@property (nonatomic, retain) NSMutableArray * arrayOfScaledYAxisCoordinates;
@property (nonatomic, retain) NSMutableArray * arrayOfScaledYAxisGridCoordinates;
@property (nonatomic, retain) NSMutableArray * userArray;

@property CGFloat          stepX;
@property CGFloat          stepY;
@property CGFloat          distance;
@property int              step;
@property int              scaledAxisMultiplier;
@property int              period;
@property int              periodExponent;

+(GraphViewModel *) sharedInstance;

@end


