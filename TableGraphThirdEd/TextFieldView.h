//
//  TextFieldView.h
//  TableGraphThirdEd
//
//  Created by user on 19.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextFieldView : UIViewController 
{
    IBOutlet UITextField * textField;
    BOOL addCoordinate;
}

@property (nonatomic, retain) UITextField * textField;
@property BOOL addCoordinate;

-(BOOL)textFieldShouldReturn:(UITextField* ) textField;
-(void) returnToTable;
-(void) addCoordinateToTable;

@end
