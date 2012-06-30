//
//  SegmentedControlNavigationController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "SegmentedControlNavigationController.h"
#import "AdminSplitViewController.h"
#import "UsersTableViewController.h"
#import "SetsTableViewController.h"

@interface SegmentedControlNavigationController ()

@end

@implementation SegmentedControlNavigationController

#pragma mark - IBActions
-(IBAction)switchViewController:(UISegmentedControl*)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [TestFlight passCheckpoint:@"SwitchToUsersViewController"];
            //Set Users ViewController
            [self setViewControllers:[NSArray arrayWithObject:[self.storyboard instantiateViewControllerWithIdentifier:@"usersTableViewController"]] animated:NO];
            break;
        case 1:
            [TestFlight passCheckpoint:@"SwitchToSetsViewController"];
            //Set Sets ViewController
            [self setViewControllers:[NSArray arrayWithObject:[self.storyboard instantiateViewControllerWithIdentifier:@"setsTableViewController"]] animated:NO];
            break;
        default:
            break;
    }
    
    //Setup currentAdmin and delegate
    if ([self.parentViewController respondsToSelector:@selector(currentAdmin)] && [self.viewControllers.lastObject respondsToSelector:@selector(setCurrentAdmin:)]) {
        [self.viewControllers.lastObject setCurrentAdmin:[self.parentViewController performSelector:@selector(currentAdmin)]];
        [self.viewControllers.lastObject setDelegate:self.parentViewController];
    }
}

#pragma mark - Rotation Handling
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
