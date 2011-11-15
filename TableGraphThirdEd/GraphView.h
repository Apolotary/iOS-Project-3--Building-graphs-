//
//  GraphView.h
//  TableGraphThirdEd
//
//  Created by user on 18.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GraphViewModel.h"
#define DEFAULT_SCALE 50

@interface GraphView : UIView 
{
    GraphViewModel *    graphViewDataInGraph;
    IBOutlet UIButton * tehButton;
    BOOL                previousYCoordinateWasNegative;
}

@property (nonatomic, retain) GraphViewModel * graphViewDataInGraph;
@property (nonatomic, retain) UIButton * tehButton;
@property BOOL             previousYCoordinateWasNegative;

-(IBAction) screenButtonWasPressed:(UIButton *) sender;
@end
