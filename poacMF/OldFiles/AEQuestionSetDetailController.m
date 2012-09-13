//
//  AEQuestionSetDetailController.m
//  poacMF
//
//  Created by Matt Hunter on 5/22/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "AEQuestionSetDetailController.h"
#import "PoacMFAppDelegate.h"
#import "AppLibrary.h"
#import "QuestionSetDetailsDAO.h"
#import "QuestionSetDetail.h"
#import "QuestionSetsDAO.h"
#import "QuestionSet.h"


@implementation AEQuestionSetDetailController

@synthesize thisTableView,xValueTF,yValueTF,questionSetPicker;
@synthesize selectedSetIndex, listOfQuestionSets;

//end method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}//end method

#pragma mark Button Methods
-(IBAction) cancelClicked {
	PoacMFAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    /*
	AdminViewController *avc = nil;//(AdminViewController *) appDelegate.viewController.modalViewController;
	[avc.questionSetsVC dismissPopovers];
     */
}//end method

-(IBAction) saveClicked {
	AppLibrary *al = [[AppLibrary alloc] init];
	if (nil == xValueTF.text){
		NSString *msg = @"xValue must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	if (nil == yValueTF.text){
		NSString *msg = @"yValue must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if

	QuestionSet *qs = [listOfQuestionSets objectAtIndex: selectedSetIndex];
	QuestionSetDetailsDAO *qsdDAO = [[QuestionSetDetailsDAO alloc] init];
	QuestionSetDetail *qsd = [[QuestionSetDetail alloc] init];
	qsd.xValue = [xValueTF.text intValue];
	qsd.yValue = [yValueTF.text intValue];

	qsd.detailId = [qsdDAO addDetailsById:qsd.setId andXValue:qsd.xValue andYValue:qsd.yValue];
	
	
	PoacMFAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    /*
	AdminViewController *avc = nil;//(AdminViewController *) appDelegate.viewController.modalViewController;
	[avc.questionSetsVC dismissPopovers];
	
	[avc.questionSetsVC loadQuestionSets:qs.mathType];
	[avc.questionSetsVC.thisTableView reloadData];
     */
}//end method

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	self.modalPresentationStyle=UIModalPresentationFormSheet;
	//Setup the UITextFields
	self.xValueTF = [self createTextField];
	xValueTF.placeholder = @"x Value";
	
	self.yValueTF = [self createTextField];
	yValueTF.placeholder = @"y Value";
	
	QuestionSetsDAO *uDAO = [[QuestionSetsDAO alloc] init];
	self.listOfQuestionSets = [uDAO getAllSets];
	
	if (nil == self.listOfQuestionSets)
		self.listOfQuestionSets = [NSMutableArray array];
	
	selectedSetIndex = 0;
}//end method

-(UITextField *) createTextField {
	CGRect frame = CGRectMake(50, 3, 300, 35);
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
	return 2;
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
		[cell addSubview:xValueTF];
	}
	if (1 == indexPath.row){
		[cell addSubview:yValueTF];
	}

    return cell;
}//end method

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}//end method


#pragma mark Picker Data Source Methods
-(NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView {
	return 1;
}//end method

-(NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component{
	if (nil != self.listOfQuestionSets)
		return [listOfQuestionSets count];
	return 0;
}//end method

-(NSString *) pickerView: (UIPickerView *) pickerView titleForRow: (NSInteger) row forComponent: (NSInteger) component {
	NSString *returnString = @"";
	if (nil != self.listOfQuestionSets){
		AppLibrary *al = [[AppLibrary alloc] init];
		QuestionSet *qs = [listOfQuestionSets objectAtIndex:row];
		return returnString;					  
	}//end if
	return returnString;
}//end method

#pragma mark Picker Delegate Methods
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return self.view.frame.size.width;
}//end method

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	selectedSetIndex = row;
}//end method

@end
