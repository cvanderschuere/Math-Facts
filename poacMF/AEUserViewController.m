//
//  AEUserViewController.m
//  poacMF
//
//  Created by Matt Hunter on 3/25/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "AEUserViewController.h"
#import "PoacMFAppDelegate.h"
#import "AdminViewController.h"
#import "UsersDAO.h"
#import "AppConstants.h"
#import "AppLibrary.h"

@implementation AEUserViewController
@synthesize thisTableView, usernameTF, firstNameTF, lastNameTF, passwordTF, emailAddressTF;
@synthesize editMode, adminstratorSwitch, studentSwitch,updateUser,userPracticeTimeLimitTF;
@synthesize userTimedTimeLimitTF, delayRetakeTF, ptrTableToRedraw;

//end method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}//end method

#pragma mark Button Methods
-(IBAction) cancelClicked {
	[self dismissModalViewControllerAnimated:YES];
}//end method

-(IBAction) saveClicked {
	//TODO: Need to check for valid values
	AppLibrary *al = [[AppLibrary alloc] init];
	if (nil == usernameTF.text){
		NSString *msg = @"Username must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	if (nil == passwordTF.text){
		NSString *msg = @"Password must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	if (nil == firstNameTF.text){
		NSString *msg = @"First name must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	if (nil == lastNameTF.text){
		NSString *msg = @"Last name must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	
	PoacMFAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	AdminViewController *avc = (AdminViewController *) appDelegate.viewController.modalViewController;
	UsersDAO *uDAO = [[UsersDAO alloc] init];
	if (!editMode) {
		User *newUser = [[User alloc] init];
		newUser.username = usernameTF.text;
		newUser.firstName = firstNameTF.text;
		newUser.lastName = lastNameTF.text;
		newUser.password = passwordTF.text;
		newUser.emailAddress = emailAddressTF.text;
		newUser.defaultPracticeTimeLimit = [userPracticeTimeLimitTF.text doubleValue];
		newUser.defaultTimedTimeLimit = [userTimedTimeLimitTF.text doubleValue];
		newUser.delayRetake = [delayRetakeTF.text intValue];
		if (0 == newUser.delayRetake)
			newUser.delayRetake = 2;
		if (0 == newUser.defaultPracticeTimeLimit)
			newUser.defaultPracticeTimeLimit = 120;
		if (0 == newUser.defaultTimedTimeLimit)
			newUser.defaultTimedTimeLimit = 60;
						
		if (adminstratorSwitch.on)
			newUser.userType = ADMIN_USER_TYPE;
		else
			newUser.userType = STUDENT_USER_TYPE;
	
		newUser.userId = [uDAO addUser:newUser];
		[avc.usersVC.listOfUsers addObject:newUser];
	} else {
		updateUser.username = usernameTF.text;
		updateUser.firstName = firstNameTF.text;
		updateUser.lastName = lastNameTF.text;
		updateUser.password = passwordTF.text;
		updateUser.emailAddress = emailAddressTF.text;
		updateUser.defaultPracticeTimeLimit = [userPracticeTimeLimitTF.text doubleValue];
		updateUser.defaultTimedTimeLimit = [userTimedTimeLimitTF.text doubleValue];
		updateUser.delayRetake = [delayRetakeTF.text intValue];
		
		if (0 == updateUser.delayRetake)
			updateUser.delayRetake = 2;
		if (0 == updateUser.defaultPracticeTimeLimit)
			updateUser.defaultPracticeTimeLimit = 60;
		
		if (adminstratorSwitch.on)
			updateUser.userType = ADMIN_USER_TYPE;
		else
			updateUser.userType = STUDENT_USER_TYPE;
		[uDAO updateUser: updateUser];
	}//end if-else
	
	[self dismissModalViewControllerAnimated:YES];
	[ptrTableToRedraw reloadData];
}//end method

-(IBAction) adminSet: (id) sender{
	if (YES == ((UISwitch *)sender).on) {
		self.studentSwitch.enabled = FALSE;
	} else {
		self.studentSwitch.enabled = TRUE;
	}
}//end method

-(IBAction) studentSet: (id) sender{
	if (YES == ((UISwitch *)sender).on) {
		self.adminstratorSwitch.enabled = FALSE;
	} else {
		self.adminstratorSwitch.enabled = TRUE;
	}
}//end method

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	self.modalPresentationStyle=UIModalPresentationFormSheet;
	//Setup the UITextFields
	self.usernameTF = [self createTextField];
	usernameTF.placeholder = @"Username";
	
	self.firstNameTF = [self createTextField];
	firstNameTF.placeholder = @"First Name";
	
	self.lastNameTF = [self createTextField];
	lastNameTF.placeholder = @"Last Name";
	
	self.passwordTF = [self createTextField];
	passwordTF.secureTextEntry = YES;
	passwordTF.placeholder = @"Password";
	
	self.emailAddressTF = [self createTextField];
	emailAddressTF.placeholder = @"Optional Email Address";
	
	self.userPracticeTimeLimitTF = [self createTextField];
	userPracticeTimeLimitTF.placeholder = @"Default Practice time limit (ie. 120)";
	
	self.userTimedTimeLimitTF = [self createTextField];
	userTimedTimeLimitTF.placeholder = @"Default Timed time limit (ie. 60)";
	
	self.delayRetakeTF = [self createTextField];
	delayRetakeTF.placeholder = @"Delay between retakes (ie. 2)";
	
	//setup the switches
	CGRect switchFrame = CGRectMake(1.0, 1.0, 20.0, 20.0);
	self.adminstratorSwitch = [[UISwitch alloc] initWithFrame:switchFrame];
	[self.adminstratorSwitch addTarget:self action:@selector(adminSet:) forControlEvents:UIControlEventValueChanged];
	self.studentSwitch = [[UISwitch alloc] initWithFrame:switchFrame];
	[self.studentSwitch addTarget:self action:@selector(studentSet:) forControlEvents:UIControlEventValueChanged];
	
	if (editMode) {
		usernameTF.text = updateUser.username;
		passwordTF.text = updateUser.password;
		firstNameTF.text = updateUser.firstName;
		lastNameTF.text = updateUser.lastName;
		emailAddressTF.text = updateUser.emailAddress;
		NSNumber *dutll = [NSNumber numberWithDouble:updateUser.defaultPracticeTimeLimit];
		userPracticeTimeLimitTF.text = [dutll stringValue];
		dutll = [NSNumber numberWithDouble:updateUser.defaultTimedTimeLimit];
		userTimedTimeLimitTF.text = [dutll stringValue];
		dutll = [NSNumber numberWithInt:updateUser.delayRetake];
		delayRetakeTF.text = [dutll stringValue];
		if (STUDENT_USER_TYPE == updateUser.userType)
			studentSwitch.on = YES;
		else
			adminstratorSwitch.on = YES;
	}//end editMode
}//end method

-(UITextField *) createTextField {
	CGRect frame = CGRectMake(10, 3, 520, 35);
	UITextField *foo = [[UITextField alloc] initWithFrame:frame];
	foo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	foo.textAlignment = UITextAlignmentCenter;
	foo.returnKeyType = UIReturnKeyDone;
	foo.borderStyle = UITextBorderStyleNone;
	foo.clearsOnBeginEditing = NO;
	foo.delegate = self;
	foo.autocorrectionType = FALSE;
	foo.autocapitalizationType = UITextAutocapitalizationTypeNone;
	return foo;
}//end method

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}//end method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 10;
}//end method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	//otherwise the labels appear multiple times, 
	for (UIView *view in cell.contentView.subviews)
		[view removeFromSuperview];
	
	
    if (0 == indexPath.row){
		[cell addSubview:firstNameTF];
	}
	if (1 == indexPath.row){
		[cell addSubview:lastNameTF];
	}
	if (2 == indexPath.row){
		[cell addSubview:usernameTF];
	}
	if (3 == indexPath.row) {
		[cell addSubview:passwordTF];
	}
	if (4 == indexPath.row) {
		[cell addSubview:emailAddressTF];
	}
	if (5 == indexPath.row) {
		[cell addSubview:userPracticeTimeLimitTF];
	}
	if (6 == indexPath.row) {
		[cell addSubview:userTimedTimeLimitTF];
	}
	if (7 == indexPath.row) {
		[cell addSubview:delayRetakeTF];
	}
	if (8 == indexPath.row){
		cell.textLabel.text = @"Administrator?";
		cell.accessoryView  = adminstratorSwitch;
	}
	if (9 == indexPath.row) {
		cell.textLabel.text = @"Student?";
		cell.accessoryView = studentSwitch;
	}
    return cell;
}//end method


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}//end method

@end
