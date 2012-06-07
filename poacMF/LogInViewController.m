//
//  LoginViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 04/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "LoginViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "PoacMFAppDelegate.h"
#import "AppLibrary.h"
#import "AppConstants.h"
#import "POACDetailViewController.h"
#import "UsersDAO.h"
#import "AdminViewController.h"
#import "UserProgressViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userNameTextField = _userNameTextField, passwordTextField = _passwordTextField;

#pragma mark - Button Methods
-(IBAction) cancelTapped {
	PoacMFAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	//[appDelegate.viewController dismissThePopovers];
}//end method

-(IBAction) loginTapped {
	AppLibrary *al = [[AppLibrary alloc] init];
	//check if username entered
	if (nil == self.userNameTextField.text){
        NSLog(@"UserName: %@",self.userNameTextField);
		NSString *msg = @"Username must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if 
	
	//check if password entered
	if (nil == self.passwordTextField.text){
		NSString *msg = @"Password must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	
	//log em in, swap the view
	UsersDAO *uDAO = [[UsersDAO alloc] init];
	BOOL success = [uDAO loginUserWithUserName:self.userNameTextField.text andPassword:self.passwordTextField.text];
	if (success) {
		PoacMFAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		appDelegate.loggedIn = TRUE;
		appDelegate.currentUser = [uDAO getUserInformation:self.userNameTextField.text];
		
		if (ADMIN_USER_TYPE == appDelegate.currentUser.userType) {
            [self performSegueWithIdentifier:@"adminUserSegue" sender:self];
		} 
        else {
            [self performSegueWithIdentifier:@"studentUserSegue" sender:appDelegate.currentUser];
		}//
	} else {
		NSString *msg = @"Incorrect username/password.";
		[al showAlertFromDelegate:self withWarning:msg];
	}
}//end method
#pragma mark - Storyboard Segues
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"adminUserSegue"]) {
        
    }
    else if ([segue.identifier isEqualToString:@"studentUserSegue"]) {
        UserProgressViewController *progressVC = (UserProgressViewController *) [[segue.destinationViewController viewControllers] lastObject];
        progressVC.currentUser = sender;
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
	
	CGRect frame = CGRectMake(10, 6, 280, 30);
	if ((self.interfaceOrientation == UIInterfaceOrientationPortrait) || 
		(self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
		frame = CGRectMake(10, 6, 280, 30);
	
    /*
	UITextField *foo = [[UITextField alloc] initWithFrame:frame];
	self.userNameTextField = foo;
	self.userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.userNameTextField.textAlignment = UITextAlignmentCenter;
	self.userNameTextField.returnKeyType = UIReturnKeyDone;
	self.userNameTextField.borderStyle = UITextBorderStyleNone;
	self.userNameTextField.clearsOnBeginEditing = NO;
	self.userNameTextField.delegate = self;
	self.userNameTextField.autocorrectionType = FALSE;
	self.userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.userNameTextField.placeholder = @"Please Enter Username";
	
	UITextField *foo2 = [[UITextField alloc] initWithFrame:frame];
	self.passwordTextField = foo2;
	self.passwordTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;	
	self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.passwordTextField.textAlignment = UITextAlignmentCenter;
	self.passwordTextField.returnKeyType = UIReturnKeyDone;
	self.passwordTextField.borderStyle = UITextBorderStyleNone;
	self.passwordTextField.clearsOnBeginEditing = NO;
	self.passwordTextField.secureTextEntry = YES;
	self.passwordTextField.delegate = self;
	self.passwordTextField.autocorrectionType = FALSE;
	self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.passwordTextField.placeholder = @"Please Enter Password";
	*/
    
}//end method

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	self.userNameTextField.text = @"chris";//admin
	self.passwordTextField.text = @"kipper";//poacmf
}//end method

#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *) textField {
	[textField resignFirstResponder];
	//[self.passwordTextField resignFirstResponder];
	return YES;
}//end method

@end
