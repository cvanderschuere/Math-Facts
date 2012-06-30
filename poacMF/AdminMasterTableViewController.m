//
//  AdminMasterTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "AdminMasterTableViewController.h"

@interface AdminMasterTableViewController ()

@property (nonatomic, strong) UIActionSheet* popupQuery;

@end

@implementation AdminMasterTableViewController
@synthesize delegate = _delegate;
@synthesize popupQuery = _popupQuery;

#pragma mark - View Lifecycle
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.popupQuery.isVisible)
        [self.popupQuery dismissWithClickedButtonIndex:-1 animated:animated]; //Dismiss logout action sheet on logout
}
#pragma mark - IBActions
-(IBAction)toggleEditMode:(id)sender{
    self.tableView.editing = !self.tableView.editing;
}
-(IBAction)logout:(id)sender{
    //Dismiss if visible
    if(self.popupQuery.visible)
        return [self.popupQuery dismissWithClickedButtonIndex:-1 animated:YES];
    
    //Show action sheet to confrim logout
    self.popupQuery = [[UIActionSheet alloc] initWithTitle:@"Logout?" 
                                                            delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Logout" 
                                                   otherButtonTitles:@"Cancel", nil, nil];
    self.popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [self.popupQuery showFromBarButtonItem:sender animated:YES];
    
    //Save on logout
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveDatabase" object:nil];
}
#pragma mark - UIActionSheet Delegate
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        
        //Logout by changing root view controller
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:loginVC];
        
    }
}
@end
