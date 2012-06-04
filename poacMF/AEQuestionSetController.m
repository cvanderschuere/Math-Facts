//
//  AEQuestionSetController.m
//  poacMF
//
//  Created by Matt Hunter on 5/24/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "AEQuestionSetController.h"
#import "PoacMFAppDelegate.h"
#import "AdminViewController.h"
#import "AppLibrary.h"
#import "AdminViewController.h"
#import "QuestionSetsDAO.h"
#import "QuestionSet.h"
#import "AppConstants.h"

@implementation AEQuestionSetController

@synthesize thisTableView,listOfQuestionSets, nameSetTF;
@synthesize addSwitch,subSwitch,multSwitch,divSwitch;


//end method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}//end method

#pragma mark Button Methods
-(IBAction) cancelClicked {
	PoacMFAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	AdminViewController *avc = (AdminViewController *) appDelegate.viewController.modalViewController;
	[avc.questionSetsVC dismissPopovers];
	[avc.questionSetsVC loadQuestionSets:ADDITION_MATH_TYPE];
	[avc.questionSetsVC.thisTableView reloadData];
}//end method

-(IBAction) saveClicked {
	if (nil == self.nameSetTF.text){
		[self cancelClicked];
		return;
	}//end if
	
	QuestionSet *newQS = [[QuestionSet alloc] init];
	newQS.questionSetName = self.nameSetTF.text;
	if (YES == self.addSwitch.on)
		newQS.mathType = ADDITION_MATH_TYPE;
	if (YES == self.subSwitch.on)
		newQS.mathType = SUBTRACTION_MATH_TYPE;
	if (YES == self.multSwitch.on)
		newQS.mathType = MULTIPLICATION_MATH_TYPE;
	if (YES == self.divSwitch.on)
		newQS.mathType = DIVISION_MATH_TYPE;
	
	QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	newQS.setId = [qsDAO addQuestionSet:newQS.questionSetName forMathType:newQS.mathType withSetOrder:0];
	
	PoacMFAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	AdminViewController *avc = (AdminViewController *) appDelegate.viewController.modalViewController;
	[avc.questionSetsVC dismissPopovers];
	
	[avc.questionSetsVC loadQuestionSets:newQS.mathType];
	[avc.questionSetsVC.thisTableView reloadData];
	
}//end method

-(IBAction) switchSet: (id) sender{
	UISwitch *uis = (UISwitch *) sender;
	if (YES == uis.on) {
		if (0 == uis.tag) {
			self.addSwitch.enabled = TRUE;
			self.subSwitch.enabled = FALSE;
			self.multSwitch.enabled = FALSE;
			self.divSwitch.enabled = FALSE;
		}//end 
		if (1 == uis.tag) {
			self.addSwitch.enabled = FALSE;
			self.subSwitch.enabled = TRUE;
			self.multSwitch.enabled = FALSE;
			self.divSwitch.enabled = FALSE;
		}//end 
		if (2 == uis.tag) {
			self.addSwitch.enabled = FALSE;
			self.subSwitch.enabled = FALSE;
			self.multSwitch.enabled = TRUE;
			self.divSwitch.enabled = FALSE;
		}//end 
		if (3 == uis.tag) {
			self.addSwitch.enabled = FALSE;
			self.subSwitch.enabled = FALSE;
			self.multSwitch.enabled = FALSE;
			self.divSwitch.enabled = TRUE;
		}//end 
	} else {
		self.addSwitch.enabled = TRUE;
		self.subSwitch.enabled = TRUE;
		self.multSwitch.enabled = TRUE;
		self.divSwitch.enabled = TRUE;
	}
}//end method

-(UITextField *) createTextField {
	CGRect frame = CGRectMake(20, 4, 350, 35);
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

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	self.modalPresentationStyle=UIModalPresentationFormSheet;
	
	//Setup the UITextFields
	self.nameSetTF = [self createTextField];
	nameSetTF.placeholder = @"Name of New Set";
	
	QuestionSetsDAO *uDAO = [[QuestionSetsDAO alloc] init];
	self.listOfQuestionSets = [uDAO getAllSets];
	
	if (nil == self.listOfQuestionSets)
		self.listOfQuestionSets = [NSMutableArray array];
	
	//setup the switches
	CGRect switchFrame = CGRectMake(1.0, 1.0, 20.0, 20.0);
	self.addSwitch = [[UISwitch alloc] initWithFrame:switchFrame];
	[self.addSwitch addTarget:self action:@selector(switchSet:) forControlEvents:UIControlEventValueChanged];
	self.addSwitch.tag=0;
	self.subSwitch = [[UISwitch alloc] initWithFrame:switchFrame];
	[self.subSwitch addTarget:self action:@selector(switchSet:) forControlEvents:UIControlEventValueChanged];
	self.subSwitch.tag=1;
	self.multSwitch = [[UISwitch alloc] initWithFrame:switchFrame];
	[self.multSwitch addTarget:self action:@selector(switchSet:) forControlEvents:UIControlEventValueChanged];
	self.multSwitch.tag=2;
	self.divSwitch = [[UISwitch alloc] initWithFrame:switchFrame];
	[self.divSwitch addTarget:self action:@selector(switchSet:) forControlEvents:UIControlEventValueChanged];
	self.divSwitch.tag=3;
	
	[thisTableView setEditing: YES animated:YES];
}//end method

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}//end method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (0 == section) 
		return 5;
	if (1 == section)
		return [self.listOfQuestionSets count];
	return 1;
}//end method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
	if (0 == indexPath.section) {
		static NSString *CellIdentifier = @"CellOne";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil)
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

		//otherwise the labels appear multiple times, 
		for (UIView *view in cell.contentView.subviews)
			[view removeFromSuperview];
		cell.accessoryView=nil;
		
		if (0 == indexPath.row)
			[cell addSubview:self.nameSetTF];
		
		if (1 == indexPath.row){
			cell.textLabel.text = @"Addition";
			cell.accessoryView = addSwitch;
		}
		if (2 == indexPath.row){
			cell.textLabel.text = @"Subtraction";
			cell.accessoryView = subSwitch;
		}
		if (3 == indexPath.row){
			cell.textLabel.text = @"Multiplication";
			cell.accessoryView = multSwitch;
		}
		if (4 == indexPath.row){
			cell.textLabel.text = @"Division";
			cell.accessoryView = divSwitch;
		}
		return cell;
	}//
	
	static NSString *CellIdentifier = @"CellTwo";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];	

	if (1 == indexPath.section) {		
		if (nil != self.listOfQuestionSets){
			AppLibrary *al = [[AppLibrary alloc] init];
			QuestionSet *qs = [listOfQuestionSets objectAtIndex:indexPath.row];
			NSString *backend = [NSString stringWithFormat:@"%i questions", [qs.setDetailsNSMA count]];
			NSString *frontend = [[al interpretMathTypeAsPhrase:qs.mathType] stringByAppendingString:qs.questionSetName];
			
			cell.textLabel.text = frontend;
			cell.detailTextLabel.text = backend;
			;					  
		}//end if
	}//end if
		
	if (2 == indexPath.section)
		cell.textLabel.text=@"";
    return cell;
}//end method

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (1 == indexPath.section)
		return YES;
	return NO;
}//end method

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}//end method


- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { 
    // If row is deleted, remove it from the list. 
	if (editingStyle == UITableViewCellEditingStyleDelete) { 
		QuestionSet *qs = [self.listOfQuestionSets objectAtIndex:indexPath.row];
		QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
		[qsDAO deleteQuestionSetById:qs.setId];
		
		[self.listOfQuestionSets removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];		
		//[tableView reloadData];
	} //end IF statement
} //end method

@end
