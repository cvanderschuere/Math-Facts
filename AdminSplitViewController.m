//
//  AdminSplitViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "AdminSplitViewController.h"
#import "UsersTableViewController.h"
#import "UserDetailTableViewController.h"
#import "Student.h"

@interface AdminSplitViewController ()

@end

@implementation AdminSplitViewController

@synthesize currentAdmin = _currentAdmin;

-(void) setCurrentAdmin:(Administrator *)currentAdmin{
    if (![_currentAdmin isEqual:currentAdmin]) {
        _currentAdmin = currentAdmin;
        //Pass it on to whatever viewcontroller want it
        for (UINavigationController* vc in self.viewControllers) {
            if ([[[vc viewControllers] lastObject] respondsToSelector:@selector(setCurrentAdmin:)]) {
                [[[vc viewControllers] lastObject] performSelector:@selector(setCurrentAdmin:) withObject:_currentAdmin];
            }
        }
    }
}


-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        AdminMasterTableViewController *adminMaster = [[[self.viewControllers objectAtIndex:0] viewControllers] lastObject];
        adminMaster.delegate = self;
    }
    return self;
}

#pragma mark - AdminComDelegate
-(void) didSelectObject:(id)aObject{
    UINavigationController *navController = [self.viewControllers lastObject];
    if ([aObject isKindOfClass:[Student class]] && ![[[navController.viewControllers lastObject] student] isEqual:aObject]) {
        //Detail view should be userDetailView
        UserDetailTableViewController *detailTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserDetailTableViewController"];
        [detailTVC setStudent:aObject];
        [navController setViewControllers:[NSArray arrayWithObject:detailTVC] animated:NO];
    }
    
}

#pragma mark - UISplitViewDelegate Methods
-(BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}
-(void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
