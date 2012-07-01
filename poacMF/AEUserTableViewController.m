//
//  AEUserTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
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
@property (weak, nonatomic) IBOutlet UIStepper *maximumIncorrectStepper;
@property (weak, nonatomic) IBOutlet UIStepper *distractionNumberStepper;
@property (weak, nonatomic) IBOutlet UILabel *testLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *passCriteriaLabel;
@property (weak, nonatomic) IBOutlet UILabel *practiceLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumIncorrectLabel;
@property (weak, nonatomic) IBOutlet UILabel *distractionNumberLabel;


- (IBAction)stepperUpdated:(id)sender;

@end

@implementation AEUserTableViewController
@synthesize maximumIncorrectLabel = _maximumIncorrectLabel;
@synthesize distractionNumberLabel = _distractionNumberLabel;
@synthesize testLengthStepper = _testLengthStepper;
@synthesize passCriteriaStepper = _passCriteriaStepper;
@synthesize maximumIncorrectStepper = _maximumIncorrectStepper;
@synthesize distractionNumberStepper = _distractionNumberStepper;
@synthesize testLengthLabel = _testLengthLabel;
@synthesize passCriteriaLabel = _passCriteriaLabel;
@synthesize usernameTF = _usernameTF, firstNameTF = _firstNameTF, lastNameTF = _lastNameTF, passwordTF = _passwordTF, emailAddressTF = _emailAddressTF;
@synthesize studentToUpdate = _studentToUpdate, createdStudentsAdmin = _createdStudentsAdmin;
@synthesize practiceLengthLabel = _practiceLengthLabel, practiceLengthStepper = _practiceLengthStepper;


#pragma mark - View Lifecycle
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
        
        //Set stepper values and update labels
        self.testLengthStepper.value = self.studentToUpdate.defaultTestLength.doubleValue;
        [self stepperUpdated:self.testLengthStepper];
        self.passCriteriaStepper.value = self.studentToUpdate.defaultPassCriteria.doubleValue;
        [self stepperUpdated:self.passCriteriaStepper];
        self.practiceLengthStepper.value = self.studentToUpdate.defaultPracticeLength.doubleValue;
        [self stepperUpdated:self.practiceLengthStepper];
        self.maximumIncorrectStepper.value = self.studentToUpdate.defaultMaximumIncorrect.doubleValue;
        [self stepperUpdated:self.maximumIncorrectStepper];
        self.distractionNumberStepper.value = self.studentToUpdate.numberOfDistractionQuestions.doubleValue;
        [self stepperUpdated:self.distractionNumberStepper];
        
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
    [self setMaximumIncorrectStepper:nil];
    [self setMaximumIncorrectLabel:nil];
    [self setDistractionNumberStepper:nil];
    [self setDistractionNumberLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - IBActions
- (IBAction)stepperUpdated:(UIStepper*)sender {
    if([sender isEqual:self.testLengthStepper]){
        self.testLengthLabel.text = [NSNumber numberWithDouble:sender.value].stringValue;
    }
    else if([sender isEqual:self.passCriteriaStepper]){
        self.passCriteriaLabel.text = [NSNumber numberWithDouble:sender.value].stringValue;
    }
    else if ([sender isEqual:self.practiceLengthStepper]) {
        self.practiceLengthLabel.text = [NSNumber numberWithDouble:sender.value].stringValue;
    }
    else if ([sender isEqual:self.maximumIncorrectStepper]) {
        self.maximumIncorrectLabel.text = [NSNumber numberWithDouble:sender.value].stringValue;
    }
    else if ([sender isEqual:self.distractionNumberStepper]) {
        self.distractionNumberLabel.text = [NSNumber numberWithDouble:sender.value].stringValue;
    }
}

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
        if (![Student isUserNameUnique:self.usernameTF.text inContext:self.studentToUpdate?self.studentToUpdate.managedObjectContext:self.createdStudentsAdmin.managedObjectContext] && ![self.studentToUpdate.username isEqualToString:self.usernameTF.text.lowercaseString]) {
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
	
    self.studentToUpdate.username = self.usernameTF.text.lowercaseString;
    self.studentToUpdate.firstName = self.firstNameTF.text;
    self.studentToUpdate.lastName = self.lastNameTF.text;
    self.studentToUpdate.password = self.passwordTF.text;
    self.studentToUpdate.emailAddress = self.emailAddressTF.text;
    
    self.studentToUpdate.numberOfDistractionQuestions = [NSNumber numberWithDouble:self.distractionNumberStepper.value];

    self.studentToUpdate.defaultPracticeLength = [NSNumber numberWithDouble:self.practiceLengthStepper.value];

    
    //If student has tests and a test setting changed...ask to update all tests to new settings
    if (self.studentToUpdate.tests.count>0 && (self.studentToUpdate.defaultTestLength.doubleValue != self.testLengthStepper.value || self.studentToUpdate.defaultPassCriteria.doubleValue != self.passCriteriaStepper.value || self.studentToUpdate.defaultMaximumIncorrect.doubleValue != self.maximumIncorrectStepper.value)) {
        
        
        UIAlertView *updateTests = [[UIAlertView alloc] initWithTitle:@"Update Settings" message:@"Should all current timings be updated to new settings?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [updateTests show];
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    
        //Update Test Defaults
        self.studentToUpdate.defaultTestLength = [NSNumber numberWithDouble:self.testLengthStepper.value];
        self.studentToUpdate.defaultPassCriteria = [NSNumber numberWithDouble:self.passCriteriaStepper.value];
        self.studentToUpdate.defaultMaximumIncorrect = [NSNumber numberWithDouble:self.maximumIncorrectStepper.value];
    }
    
    
    NSLog(@"Updated User: %@", self.studentToUpdate);
        
}//end method
#pragma mark - UIAlertView Delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //Update all current tests to new values if changed
        if (self.studentToUpdate.defaultTestLength.doubleValue != self.testLengthStepper.value) {
            for (Test* test in self.studentToUpdate.tests) {
                test.testLength = [NSNumber numberWithDouble:self.testLengthStepper.value];
            }
            
        }
        if (self.studentToUpdate.defaultPassCriteria.doubleValue != self.passCriteriaStepper.value) {
            for (Test* test in self.studentToUpdate.tests) {
                test.passCriteria = [NSNumber numberWithDouble:self.passCriteriaStepper.value];
            }
        }
        if (self.studentToUpdate.defaultMaximumIncorrect.doubleValue != self.maximumIncorrectStepper.value) {
            for (Test* test in self.studentToUpdate.tests) {
                test.maximumIncorrect = [NSNumber numberWithDouble:self.maximumIncorrectStepper.value];
            }
        }
    }
    
    //Update Test Defaults
    self.studentToUpdate.defaultTestLength = [NSNumber numberWithDouble:self.testLengthStepper.value];
    self.studentToUpdate.defaultPassCriteria = [NSNumber numberWithDouble:self.passCriteriaStepper.value];
    self.studentToUpdate.defaultMaximumIncorrect = [NSNumber numberWithDouble:self.maximumIncorrectStepper.value];    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
