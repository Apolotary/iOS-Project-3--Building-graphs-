//
//  GraphDataTableView.m
//  TableGraphThirdEd
//
//  Created by user on 18.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphDataTableView.h"


@implementation GraphDataTableView

@synthesize graphViewDataSource, graphTableView,
            indexOfFieldThatWasChanged, textFieldFromView, 
            textFieldWasTriggered, graphTemplateChoiceControl,
            addNewObject, previousSegmentWasDefault;

- (void)dealloc
{
    [graphTableView release];
    [graphTemplateChoiceControl release];
    [textFieldFromView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) callTextFieldView
{
    CGPoint tmp;
    if(addNewObject)
    {
        tmp = CGPointMake(0, 0);
        [self.navigationController pushViewController:textFieldFromView animated:YES];
        textFieldFromView.textField.text = [NSString stringWithFormat:@"%1.5f", tmp.y];
        textFieldWasTriggered = YES;
    }
    else
    {
        tmp = [[graphViewDataSource.arrayOfYCoordinates objectAtIndex:indexOfFieldThatWasChanged] CGPointValue];
        [self.navigationController pushViewController:textFieldFromView animated:YES];
        textFieldFromView.textField.text = [NSString stringWithFormat:@"%1.5f", tmp.y];
        textFieldWasTriggered = YES;
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [graphTableView setEditing:editing animated:animated];
}

-(void) insertTemplateGraphFromControl
{
    NSLog(@"template");
    
    if(graphTemplateChoiceControl.selectedSegmentIndex == 0)
    {
        [graphViewDataSource resetFromUserArray];
        previousSegmentWasDefault = YES;
    }
    else if(graphTemplateChoiceControl.selectedSegmentIndex == 1)
    {
        if(previousSegmentWasDefault)
        {
            [graphViewDataSource makeACopyForUserArray];
        }
        [graphViewDataSource clearAnArrayOfYCoordinates];
        
        CGFloat x;
        
        for(int i = 0; i < 325; ++i)
        {
            x = i;
            [graphViewDataSource insertYCoordinate:CGPointMake(x, sinf(x/50))];
        }
        
        previousSegmentWasDefault = NO;
    }
    else if (graphTemplateChoiceControl.selectedSegmentIndex == 2)
    {
        if(previousSegmentWasDefault)
        {
            [graphViewDataSource makeACopyForUserArray];
        }
        [graphViewDataSource clearAnArrayOfYCoordinates];
        
        [graphViewDataSource insertYCoordinate:CGPointMake(0, -8)];
        [graphViewDataSource insertYCoordinate:CGPointMake(1, -1)];
        [graphViewDataSource insertYCoordinate:CGPointMake(2, 0)];
        [graphViewDataSource insertYCoordinate:CGPointMake(3, 1)];
        [graphViewDataSource insertYCoordinate:CGPointMake(4, 8)];
        previousSegmentWasDefault = NO;
    }
    [graphTableView reloadData];
}

-(IBAction) addCoordinate:(id) sender
{
    addNewObject = YES;
    [self callTextFieldView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [self editButtonItem];
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addCoordinate:)];
	[self.navigationItem setRightBarButtonItem:addButton]; 
    [addButton release];
    textFieldFromView = [[TextFieldView alloc] initWithNibName:@"TextFieldView" bundle:nil];

    graphViewDataSource = [GraphViewModel sharedInstance];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"model"]);
    [graphViewDataSource loadUserDefaults];
    [graphViewDataSource makeACopyForUserArray];
    NSLog(@"%d", [graphViewDataSource.arrayOfYCoordinates count]);
    [graphTemplateChoiceControl addTarget:self 
                                   action:@selector(insertTemplateGraphFromControl) 
                         forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (textFieldFromView.addCoordinate)
    {
        if(textFieldWasTriggered && !addNewObject)
        {
            CGFloat temp = (float)[self.textFieldFromView.textField.text floatValue];
            [graphViewDataSource replaceYCoordinateAtIndex:indexOfFieldThatWasChanged withPoint:CGPointMake(indexOfFieldThatWasChanged, temp)];
            NSLog(@"new value: %@", NSStringFromCGPoint([[graphViewDataSource.arrayOfYCoordinates objectAtIndex:indexOfFieldThatWasChanged] CGPointValue]));
            textFieldFromView.textField.text = nil;
            [graphTableView reloadData];
            textFieldWasTriggered = NO;
        }
        else if (textFieldWasTriggered && addNewObject)
        {
            CGFloat temp = (float)[self.textFieldFromView.textField.text floatValue];
            [graphViewDataSource insertYCoordinate:CGPointMake([graphViewDataSource.arrayOfYCoordinates count], temp)];
            addNewObject = NO;
            textFieldFromView.textField.text = nil;
            [graphTableView reloadData];
            textFieldWasTriggered = NO;
        }
        if (graphTemplateChoiceControl.selectedSegmentIndex == 0)
        {
            [graphViewDataSource makeACopyForUserArray];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [graphViewDataSource.arrayOfYCoordinates count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    int row = indexPath.row;
    
    if (indexPath.row > [graphViewDataSource.arrayOfYCoordinates count] - 1)
    {
        row = [graphViewDataSource.arrayOfYCoordinates count] - 1;
    }

    CGPoint tmp = [[graphViewDataSource.arrayOfYCoordinates objectAtIndex:row] CGPointValue];
    cell.textLabel.text = [NSString stringWithFormat:@"%1.5f", tmp.y]; 
    
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"editing commited");
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [graphViewDataSource removeYCoordinateAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationTop];
        [graphViewDataSource makeACopyForUserArray];
        //[graphTableView reloadData];
    } 
    
    if(previousSegmentWasDefault)
    {
        [graphViewDataSource makeACopyForUserArray];
    }
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    // existing content. Existing content can be deleted.    

    if (self.editing) 
	{
		return UITableViewCellEditingStyleDelete;
	}
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // custom swap
    CGPoint tmpPoint1 = [graphViewDataSource returnPointFromArrayAtIndex:fromIndexPath.row];
    CGPoint tmpPoint2 = [graphViewDataSource returnPointFromArrayAtIndex:toIndexPath.row];
    CGPoint tmp3 = tmpPoint1;
    tmpPoint1.x = tmpPoint2.x;
    tmpPoint2.x = tmp3.x;
    
    [graphViewDataSource replaceYCoordinateAtIndex:fromIndexPath.row withPoint:tmpPoint1];
    [graphViewDataSource replaceYCoordinateAtIndex:toIndexPath.row withPoint:tmpPoint2];
    [graphViewDataSource exchangeYCoordinateAtIndex:fromIndexPath.row 
                              withCoordinateAtIndex:toIndexPath.row];
    if(previousSegmentWasDefault)
    {
        [graphViewDataSource makeACopyForUserArray];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row %@ was selected", indexPath);
    indexOfFieldThatWasChanged = indexPath.row;
    [self callTextFieldView];
}

@end
