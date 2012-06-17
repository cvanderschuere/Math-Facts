//
//  AEUserTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "AEUserTableViewController.h"
#import "PoacMFAppDelegate.h"
#import "AppConstants.h"
#import "AppLibrary.h"
#import "Test.h"

@interface AEUserTableViewController ()

@property (nonatomic, weak)	IBOutlet	UITextField		*usernameTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*firstNameTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*lastNameTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*passwordTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*emailAddressTF;
@property (weak, nonatomic) IBOutlet UIStepper *testLengthStepper;
@property (weak, nonatomic) IBOutlet UIStepper *passCriteriaStepper;
@property (weak, nonatomic) IBOutlet UIStepper *practiceLengthStepper;
@property (weak, nonatomic) IBOutlet UILabel *testLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *passCriteriaLabel;
@property (weak, nonatomic) IBOutlet UILabel *practiceLengthLabel;


- (IBAction)stepperUpdated:(id)sender;

@end

@implementation AEUserTableViewController
@synthesize testLengthStepper = _testLengthStepper;
@synthesize passCriteriaStepper = _passCriteriaStepper;
@synthesize testLengthLabel = _testLengthLabel;
@synthesize passCriteriaLabel = _passCriteriaLabel;
@synthesize usernameTF = _usernameTF, firstNameTF = _firstNameTF, lastNameTF = _lastNameTF, passwordTF = _passwordTF, emailAddressTF = _emailAddressTF;
@synthesize studentToUpdate = _studentToUpdate, createdStudentsAdmin = _createdStudentsAdmin;
@synthesize practiceLengthLabel = _practiceLengthLabel, practiceLengthStepper = _practiceLengthStepper;


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
        
        self.testLengthStepper.value = self.studentToUpdate.defaultTestLength.doubleValue;
        [self stepperUpdated:self.testLengthStepper];
        self.passCriteriaStepper.value = self.studentToUpdate.defaultPassCriteria.doubleValue;
        [self stepperUpdated:self.passCriteriaStepper];
        self.practiceLengthStepper.value = self.studentToUpdate.defaultPracticeLength.doubleValue;
        [self stepperUpdated:self.practiceLengthStepper];
        
        self.title = [@"Edit " stringByAppendingString:self.studentToUpdate.firstName];

	}//end editMode
    else{
        self.title = @"Create Student";
        self.practiceLengthStepper.value = 120;
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTestLengthStepper:nil];
    [self setPassCriteriaStepper:nil];
    [self setTestLengthLabel:nil];
    [self setPassCriteriaLabel:nil];
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
    else {
        //Check if username is unique or the same username as before
        if (![Student isUserNameUnique:self.usernameTF.text inContext:self.studentToUpdate?self.studentToUpdate.managedObjectContext:self.createdStudentsAdmin.managedObjectContext] && ![self.studentToUpdate.username isEqualToString:self.usernameTF.text]) {
            NSString *msg = @"Username already used.";
            [al showAlertFromDelegate:self withWarning:msg];
            return;
        }
    }
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
    
    //Create new student if necessary
    if (!self.studentToUpdate) {
        self.studentToUpdate = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.createdStudentsAdmin.managedObjectContext];
        [self.createdStudentsAdmin addStudentsObject:self.studentToUpdate];
    }
	
    self.studentToUpdate.username = self.usernameTF.text;
    self.studentToUpdate.firstName = self.firstNameTF.text;
    self.studentToUpdate.lastName = self.lastNameTF.text;
    self.studentToUpdate.password = self.passwordTF.text;
    self.studentToUpdate.emailAddress = self.emailAddressTF.text;
    
    
    //Update all current tests to new values if changed
    if (self.studentToUpdate.defaultTestLength.doubleValue != self.testLengthStepper.value) {
        self.studentToUpdate.defaultTestLength = [NSNumber numberWithDouble:self.testLengthStepper.value];
        for (Test* test in self.studentToUpdate.tests) {
            test.testLength = [NSNumber numberWithDouble:self.testLengthStepper.value];
        }

    }
    if (self.studentToUpdate.defaultPassCriteria.doubleValue != self.passCriteriaStepper.value) {
        self.studentToUpdate.defaultPassCriteria = [NSNumber numberWithDouble:self.passCriteriaStepper.value];
        for (Test* test in self.studentToUpdate.tests) {
            test.passCriteria = [NSNumber numberWithDouble:self.passCriteriaStepper.value];
        }
    }
    
    self.studentToUpdate.defaultPracticeLength = [NSNumber numberWithDouble:self.practiceLengthStepper.value];
    
    NSLog(@"Updated User: %@", self.studentToUpdate);
        
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

- (IBAction)stepperUpdated:(UIStepper*)sender {
    if([sender isEqual:self.testLengthStepper]){
        self.testLengthLabel.text = [NSNumber numberWithDouble:sender.value].stringValue;
    }
    else if([sender isEqual:self.passCriteriaStepper]){
        self.passCriteriaLabel.text = [NSNumber numberWithDouble:sender.value].stringValue;
    }
}
@end
