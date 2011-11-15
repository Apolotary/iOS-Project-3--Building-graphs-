//
//  TableGraphThirdEdAppDelegate.h
//  TableGraphThirdEd
//
//  Created by user on 18.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphDataTableView.h"

@interface TableGraphThirdEdAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> 
{

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
