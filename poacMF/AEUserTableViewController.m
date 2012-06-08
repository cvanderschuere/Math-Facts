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


@end

@implementation AEUserTableViewController
@synthesize usernameTF = _usernameTF, firstNameTF = _firstNameTF, lastNameTF = _lastNameTF, passwordTF = _passwordTF, emailAddressTF = _emailAddressTF, userTypeSC = _userTypeSC;
@synthesize userPracticeTimeLimitTF = _userPracticeTimeLimitTF;
@synthesize userTimedTimeLimitTF = _userTimedTimeLimitTF, delayRetakeTF = _delayRetakeTF, editMode = _editMode;
@synthesize studentToUpdate = _studentToUpdate, createdStudentsAdmin = _createdStudentsAdmin;


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
    if (self.studentToUpdate) {
		self.usernameTF.text = self.studentToUpdate.username;
		self.passwordTF.text = self.studentToUpdate.password;
		self.firstNameTF.text = self.studentToUpdate.firstName;
		self.lastNameTF.text = self.studentToUpdate.lastName;
		self.emailAddressTF.text = self.studentToUpdate.emailAddress;
        
        self.title = @"Update Student";
        /*
		NSNumber *dutll = [NSNumber numberWithDouble:self.updateUser.defaultPracticeTimeLimit];
		self.userPracticeTimeLimitTF.text = [dutll stringValue];
		dutll = [NSNumber numberWithDouble:self.updateUser.defaultTimedTimeLimit];
		self.userTimedTimeLimitTF.text = [dutll stringValue];
		dutll = [NSNumber numberWithInt:self.updateUser.delayRetake];
		self.delayRetakeTF.text = [dutll stringValue];
        self.userTypeSC.selectedSegmentIndex = self.updateUser.userType;
        */
	}//end editMode
    else 
        self.title = @"Create Student";

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
	//TODO: Need to check for valid values and unique username
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
    if (!self.studentToUpdate) {
        self.studentToUpdate = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.createdStudentsAdmin.managedObjectContext];
        [self.createdStudentsAdmin addStudentsObject:self.studentToUpdate];
    }
	
    self.studentToUpdate.username = self.usernameTF.text;
    self.studentToUpdate.firstName = self.firstNameTF.text;
    self.studentToUpdate.lastName = self.lastNameTF.text;
    self.studentToUpdate.password = self.passwordTF.text;
    self.studentToUpdate.emailAddress = self.emailAddressTF.text;
    
    NSLog(@"Updated User: %@", self.studentToUpdate);
    
    [self.studentToUpdate.managedObjectContext save:nil];
   	    
	[self dismissModalViewControllerAnimated:YES];
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
