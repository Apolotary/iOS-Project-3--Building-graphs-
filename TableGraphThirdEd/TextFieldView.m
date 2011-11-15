//
//  TextFieldView.m
//  TableGraphThirdEd
//
//  Created by user on 19.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextFieldView.h"


@implementation TextFieldView

@synthesize textField, addCoordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [textField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL)textFieldShouldReturn:(UITextField* ) textField
{
    NSLog(@"retuuurn!");
    return YES;
}

#pragma mark - View lifecycle

-(void) returnToTable
{
    addCoordinate = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) addCoordinateToTable
{
    addCoordinate = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(returnToTable)];
	[self.navigationItem setLeftBarButtonItem:addButton]; 
    [addButton release];
    addButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(addCoordinateToTable)];
	[self.navigationItem setRightBarButtonItem:addButton]; 
    [addButton release];
    [textField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [textField resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
