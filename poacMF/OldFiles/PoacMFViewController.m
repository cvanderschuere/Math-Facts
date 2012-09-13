//
//  poacMFViewController.m
//  poacMF
//
//  Created by Matt Hunter on 3/17/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "PoacMFViewController.h"
#import "PoacMFAppDelegate.h"
#import "AppConstants.h"
#import "LoginPopoverViewController.h"

@implementation PoacMFViewController

@synthesize thisToolBar, loginPopoverController;

- (void)dealloc {
	[thisToolBar release];
	[loginPopoverController release];
    [super dealloc];
}//end method

#pragma mark - View lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}//end method

- (void)viewDidLoad {
    [super viewDidLoad];
	
	LoginPopoverViewController *apc = [[LoginPopoverViewController alloc] initWithNibName:LOGIN_VIEW_NIB bundle:nil]; 
	apc.view.backgroundColor = [UIColor blackColor];
	apc.contentSizeForViewInPopover = CGSizeMake(340, 130);
	self.loginPopoverController = [[UIPopoverController alloc] initWithContentViewController:apc];
	[apc release];	
	
}//end method

#pragma mark - Button Methods
-(IBAction) logInOut: (id) sender {
	PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (!appDelegate.loggedIn) {
		NSLog(@"not logged in apparently....");
		//1) pop open a login window if not logged in
		[self dismissThePopovers];
		[loginPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	} else {
		//2) confirmatory logout prompt if they are logged in
		UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Logout?" 
				delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Logout" 
				otherButtonTitles:@"Cancel", nil, nil];
		popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
		[popupQuery showInView:self.view];
		[popupQuery release];
	}//end if2
}//end method

#pragma mark Managing the add popover
-(void) dismissThePopovers {
	[loginPopoverController dismissPopoverAnimated:YES];
}//end

#pragma mark - Action Sheet Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
    if (buttonIndex == 0) {
        appDelegate.loggedIn = NO;
		//#TODO: wipe the screen
	}
}//end method


@end
