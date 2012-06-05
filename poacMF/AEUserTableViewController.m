//
//  AEUserTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "AEUserTableViewController.h"
#import "User.h"
#import "PoacMFAppDelegate.h"
#import "AdminViewController.h"
#import "UsersDAO.h"
#import "AppConstants.h"
#import "AppLibrary.h"

@interface AEUserTableViewController ()

@property (nonatomic, weak)	IBOutlet	UITextField		*usernameTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*firstNameTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*lastNameTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*passwordTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*emailAddressTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*userPracticeTimeLimitTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*userTimedTimeLimitTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*delayRetakeTF;
@property (nonatomic, weak) IBOutlet    UISegmentedControl *userTypeSC;
@property (nonatomic, strong)				User			*updateUser;


@end

@implementation AEUserTableViewController
@synthesize usernameTF = _usernameTF, firstNameTF = _firstNameTF, lastNameTF = _lastNameTF, passwordTF = _passwordTF, emailAddressTF = _emailAddressTF, userTypeSC = _userTypeSC;
@synthesize updateUser = _updateUser,userPracticeTimeLimitTF = _userPracticeTimeLimitTF;
@synthesize userTimedTimeLimitTF = _userTimedTimeLimitTF, delayRetakeTF = _delayRetakeTF, editMode = _editMode;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Configure for updatedUser if in edit mode
    if (self.editMode) {
		self.usernameTF.text = self.updateUser.username;
		self.passwordTF.text = self.updateUser.password;
		self.firstNameTF.text = self.updateUser.firstName;
		self.lastNameTF.text = self.updateUser.lastName;
		self.emailAddressTF.text = self.updateUser.emailAddress;
		NSNumber *dutll = [NSNumber numberWithDouble:self.updateUser.defaultPracticeTimeLimit];
		self.userPracticeTimeLimitTF.text = [dutll stringValue];
		dutll = [NSNumber numberWithDouble:self.updateUser.defaultTimedTimeLimit];
		self.userTimedTimeLimitTF.text = [dutll stringValue];
		dutll = [NSNumber numberWithInt:self.updateUser.delayRetake];
		self.delayRetakeTF.text = [dutll stringValue];
        self.userTypeSC.selectedSegmentIndex = self.updateUser.userType;
	}//end editMode


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark Button Methods
-(IBAction) cancelClicked {
    //Dismiss View
	[self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}//end method

-(IBAction) saveClicked {
	//TODO: Need to check for valid values
	AppLibrary *al = [[AppLibrary alloc] init];
	if (nil == self.usernameTF.text){
		NSString *msg = @"Username must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	if (nil == self.passwordTF.text){
		NSString *msg = @"Password must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	if (nil == self.firstNameTF.text){
		NSString *msg = @"First name must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	if (nil == self.lastNameTF.text){
		NSString *msg = @"Last name must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	
	//PoacMFAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	//AdminViewController *avc = nil;//(AdminViewController *) appDelegate.viewController.modalViewController;
    UsersDAO *uDAO = [[UsersDAO alloc] init];
	if (!self.editMode) {
		User *newUser = [[User alloc] init];
		newUser.username = self.usernameTF.text;
		newUser.firstName = self.firstNameTF.text;
		newUser.lastName = self.lastNameTF.text;
		newUser.password = self.passwordTF.text;
		newUser.emailAddress = self.emailAddressTF.text;
		newUser.defaultPracticeTimeLimit = [self.userPracticeTimeLimitTF.text doubleValue];
		newUser.defaultTimedTimeLimit = [self.userTimedTimeLimitTF.text doubleValue];
		newUser.delayRetake = [self.delayRetakeTF.text intValue];
		if (0 == newUser.delayRetake)
			newUser.delayRetake = 2;
		if (0 == newUser.defaultPracticeTimeLimit)
			newUser.defaultPracticeTimeLimit = 120;
		if (0 == newUser.defaultTimedTimeLimit)
			newUser.defaultTimedTimeLimit = 60;
        
        newUser.userType = self.userTypeSC.selectedSegmentIndex;
        
		newUser.userId = [uDAO addUser:newUser];
		//[avc.usersVC.listOfUsers addObject:newUser];
	} else {
		self.updateUser.username = self.usernameTF.text;
		self.updateUser.firstName = self.firstNameTF.text;
		self.updateUser.lastName = self.lastNameTF.text;
		self.updateUser.password = self.passwordTF.text;
		self.updateUser.emailAddress = self.emailAddressTF.text;
		self.updateUser.defaultPracticeTimeLimit = [self.userPracticeTimeLimitTF.text doubleValue];
		self.updateUser.defaultTimedTimeLimit = [self.userTimedTimeLimitTF.text doubleValue];
		self.updateUser.delayRetake = [self.delayRetakeTF.text intValue];
		
		if (0 == self.updateUser.delayRetake)
			self.updateUser.delayRetake = 2;
		if (0 == self.updateUser.defaultPracticeTimeLimit)
			self.updateUser.defaultPracticeTimeLimit = 60;
		
        self.updateUser.userType = self.userTypeSC.selectedSegmentIndex;
		
		[uDAO updateUser:self.updateUser];
	}//end if-else
	
    [[NSNotificationCenter defaultCenter] postNotificationName:@"usersUpdated" object:self.updateUser];
    
	[self dismissModalViewControllerAnimated:YES];
	//[ptrTableToRedraw reloadData];
}//end method


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - UITextField Delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
