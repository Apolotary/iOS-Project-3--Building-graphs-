//
//  GraphDataTableView.h
//  TableGraphThirdEd
//
//  Created by user on 18.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewModel.h"
#import "TextFieldView.h"


@interface GraphDataTableView : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    GraphViewModel *              graphViewDataSource;
    IBOutlet UITableView *        graphTableView;
    IBOutlet UISegmentedControl * graphTemplateChoiceControl;
    int                           indexOfFieldThatWasChanged;
    TextFieldView *               textFieldFromView;
    BOOL                          textFieldWasTriggered;
    BOOL                          addNewObject;
    BOOL                          previousSegmentWasDefault;
}

@property (nonatomic, retain) GraphViewModel *     graphViewDataSource;
@property (nonatomic, retain) UITableView *        graphTableView;
@property (nonatomic, retain) TextFieldView *      textFieldFromView;
@property (nonatomic, retain) UISegmentedControl * graphTemplateChoiceControl;

@property int  indexOfFieldThatWasChanged;
@property BOOL textFieldWasTriggered;
@property BOOL addNewObject;
@property BOOL previousSegmentWasDefault;

-(IBAction) addCoordinate:(id) sender;

@end
