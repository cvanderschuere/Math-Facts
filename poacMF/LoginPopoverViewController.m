//
//  LoginPopoverViewController.m
//  poacMF
//
//  Created by Matt Hunter on 3/19/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginPopoverViewController.h"
#import "PoacMFAppDelegate.h"
#import "AppLibrary.h"
#import "AppConstants.h"
#import "POACDetailViewController.h"
#import "UsersDAO.h"
#import "AdminViewController.h"

@implementation LoginPopoverViewController

@synthesize thisNavBar, thisTableView, userNameTextField, passwordTextField;

//end method

#pragma mark Button Methods
-(IBAction) cancelTapped {
	PoacMFAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate.viewController dismissThePopovers];
}//end method

-(IBAction) loginTapped {
	AppLibrary *al = [[AppLibrary alloc] init];
	//check if username entered
	if (nil == userNameTextField.text){
		NSString *msg = @"Username must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if 
	
	//check if password entered
	if (nil == passwordTextField.text){
		NSString *msg = @"Password must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	
	//log em in, swap the view
	UsersDAO *uDAO = [[UsersDAO alloc] init];
	BOOL success = [uDAO loginUserWithUserName:userNameTextField.text andPassword:passwordTextField.text];
	if (success) {
		PoacMFAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		appDelegate.loggedIn = TRUE;
		appDelegate.currentUser = [uDAO getUserInformation:userNameTextField.text];
		[appDelegate.viewController dismissThePopovers];
		
		if (ADMIN_USER_TYPE == appDelegate.currentUser.userType) {		
			POACDetailViewController *newDVC = [[AdminViewController alloc] initWithNibName:ADMIN_VIEW_NIB bundle:nil];
			newDVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			newDVC.view.frame = CGRectMake(0, 0, 350, 365);
			[appDelegate.viewController presentModalViewController: newDVC animated:YES];
		} else {
			TesterViewController *testerView = (TesterViewController *) appDelegate.viewController;
			[testerView setInitialStudentView];
		}//
	} else {
		NSString *msg = @"Incorrect username/password.";
		[al showAlertFromDelegate:self withWarning:msg];
	}
}//end method

#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

	
	CGRect frame = CGRectMake(10, 6, 280, 30);
	if ((self.interfaceOrientation == UIInterfaceOrientationPortrait) || 
		(self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
		frame = CGRectMake(10, 6, 280, 30);
	
	UITextField *foo = [[UITextField alloc] initWithFrame:frame];
	self.userNameTextField = foo;
	userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	userNameTextField.textAlignment = UITextAlignmentCenter;
	userNameTextField.returnKeyType = UIReturnKeyDone;
	userNameTextField.borderStyle = UITextBorderStyleNone;
	userNameTextField.clearsOnBeginEditing = NO;
	userNameTextField.delegate = self;
	userNameTextField.autocorrectionType = FALSE;
	userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	userNameTextField.placeholder = @"Please Enter Username";
	
	UITextField *foo2 = [[UITextField alloc] initWithFrame:frame];
	self.passwordTextField = foo2;
	passwordTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;	
	passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	passwordTextField.textAlignment = UITextAlignmentCenter;
	passwordTextField.returnKeyType = UIReturnKeyDone;
	passwordTextField.borderStyle = UITextBorderStyleNone;
	passwordTextField.clearsOnBeginEditing = NO;
	passwordTextField.secureTextEntry = YES;
	passwordTextField.delegate = self;
	passwordTextField.autocorrectionType = FALSE;
	passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	passwordTextField.placeholder = @"Please Enter Password";
	
}//end method

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	userNameTextField.text = nil;
	passwordTextField.text = nil;
	//userNameTextField.text = @"mhunter";
	//passwordTextField.text = @"mhunter";
}//end method

#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

#pragma mark Table view data source
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}//end method

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
	
	//otherwise the labels appear multiple times, 
	for (UIView *view in cell.contentView.subviews)
		[view removeFromSuperview];
	
	userNameTextField.frame = cell.frame;
	passwordTextField.frame = cell.frame;
	
	if (0 == indexPath.row)
		[cell addSubview: userNameTextField];
	if (1 == indexPath.row)
		[cell addSubview:passwordTextField];
	return cell;
}//end 

#pragma mark Table Delegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];	
}//end didSelectRowAtIndexPath

#pragma mark UITableViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *) textField {
	[userNameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
	return YES;
}//end method


@end
