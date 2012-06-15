//
//  AdminMasterTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "AdminMasterTableViewController.h"

@interface AdminMasterTableViewController ()

@end

@implementation AdminMasterTableViewController
@synthesize delegate = _delegate;

-(IBAction)logout:(id)sender{
    //Show action sheet to confrim logout
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Logout?" 
                                                            delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Logout" 
                                                   otherButtonTitles:@"Cancel", nil, nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showFromBarButtonItem:sender animated:YES];
}
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.parentViewController performSegueWithIdentifier:@"logoutSegue" sender:self];
    }
}

-(IBAction)toggleEditMode:(id)sender{
    self.tableView.editing = !self.tableView.editing;
}

@end
