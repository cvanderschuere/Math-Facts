//
//  QuestionSetsTableViewController.m
//  poacMF
//
//  Created by Matt Hunter on 3/29/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuestionSetsViewController.h"
#import "QuestionSetsDAO.h"
#import "QuestionSet.h"
#import "QuestionSetDetail.h"
#import "AppConstants.h"
#import "AppLibrary.h"
#import "QuestionSetDetailsDAO.h"
#import "AEQuestionSetDetailController.h"
#import "AEQuestionSetController.h"

@implementation QuestionSetsViewController

@synthesize listofQuestionSets, thisTableView, addDetailsPopoverController, addSetPopoverController;

//end method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  	return YES;
}//end method

#pragma mark - Button Methods
-(IBAction) addSetButtonTapped: (id) sender {
	AEQuestionSetController *addVC = [[AEQuestionSetController alloc] initWithNibName:AEQUESTIONSET_NIB bundle:nil];
	addVC.view.backgroundColor = [UIColor blackColor];
	addVC.contentSizeForViewInPopover = CGSizeMake(400, 380);
	self.addSetPopoverController = [[UIPopoverController alloc] initWithContentViewController:addVC];
	
	//[self dismissThePopovers];
	[addSetPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}//end method

-(IBAction) addDetailsButtonTapped: (id) sender {
	AEQuestionSetDetailController *addVC = [[AEQuestionSetDetailController alloc] initWithNibName:AEQUESTIONSETDETAILS_NIB bundle:nil];
	addVC.view.backgroundColor = [UIColor blackColor];
	addVC.contentSizeForViewInPopover = CGSizeMake(400, 380);
	self.addDetailsPopoverController = [[UIPopoverController alloc] initWithContentViewController:addVC];
	
	//[self dismissThePopovers];
	[addDetailsPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}//end method

-(IBAction) additionButtonTapped {	
	[self loadQuestionSets:ADDITION_MATH_TYPE];
}//end method

-(IBAction) subtractionButtonTapped {
	[self loadQuestionSets:SUBTRACTION_MATH_TYPE];
}//end method

-(IBAction) multiplicationButtonTapped {
	[self loadQuestionSets:MULTIPLICATION_MATH_TYPE];
}//end method

-(IBAction) divisionButtonTapped {
	[self loadQuestionSets:DIVISION_MATH_TYPE];
}//end method

-(void) loadQuestionSets: (int) mathType {
	QuestionSetsDAO *uDAO = [[QuestionSetsDAO alloc] init];
	self.listofQuestionSets = [uDAO getSetByMathType:mathType];
	
	if (nil == self.listofQuestionSets)
		self.listofQuestionSets = [NSMutableArray array];
	
	[self.thisTableView reloadData];
}//end

-(void)	dismissPopovers {
	[addDetailsPopoverController dismissPopoverAnimated:YES];
	[addSetPopoverController dismissPopoverAnimated:YES];
}//end method

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self loadQuestionSets:ADDITION_MATH_TYPE];
}//end method

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	NSLog(@"QuestionSetsTableVC.viewWillAppear");
	
}//end method

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 0;
	if (nil != listofQuestionSets)
		count = [listofQuestionSets count];
    return count;
}//end method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = 0;
	if (nil != listofQuestionSets) {
		QuestionSet *qs = [listofQuestionSets objectAtIndex:section];
		//count = [qs.setDetailsNSMA count];
	}
    return count;
}//end method
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section { 
	NSString *titleString=@"";
	AppLibrary *al = [[AppLibrary alloc] init];
	if (nil != listofQuestionSets) {
		QuestionSet *qs = [listofQuestionSets objectAtIndex:section];
		//titleString = [al interpretMathTypeAsPhrase:qs.mathType];
		//titleString = [titleString stringByAppendingString:qs.questionSetName];
	}//
	return titleString;
}//end method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	/*
	AppLibrary *al = [[AppLibrary alloc] init];
	if (nil != listofQuestionSets){
		QuestionSet *qs = [listofQuestionSets objectAtIndex:indexPath.section];
		QuestionSetDetail *qsd = [qs.setDetailsNSMA objectAtIndex:indexPath.row];
		NSString *sign = [al interpretMathTypeAsSymbol:qs.mathType];
		NSString *questionString = @"";

		if ((ADDITION_MATH_TYPE == qs.mathType) || (MULTIPLICATION_MATH_TYPE == qs.mathType))
			questionString = [NSString stringWithFormat:@"%i %s %i", qsd.xValue, [sign UTF8String], qsd.yValue];
		
		if (DIVISION_MATH_TYPE == qs.mathType)
			questionString = [NSString stringWithFormat:@"%i %s %i", qsd.yValue, [sign UTF8String], qsd.xValue];
		
		if (SUBTRACTION_MATH_TYPE == qs.mathType) {
			int x=qsd.xValue;
			int y=qsd.yValue;
			if (qsd.xValue < qsd.yValue){
				x = qsd.yValue;
				y = qsd.xValue;
			}//
			questionString = [NSString stringWithFormat:@"%i %s %i", x, [sign UTF8String], y];
		}//
		
		cell.textLabel.text = questionString;
	}//end method
	*/
	return cell;
}//end method

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}//end method

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[thisTableView deselectRowAtIndexPath:indexPath animated:YES];
}//end method

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { 
	
    // If row is deleted, remove it from the list. 
	if (editingStyle == UITableViewCellEditingStyleDelete) { 
		//get VOs
		QuestionSet *qs = [listofQuestionSets objectAtIndex:indexPath.section];
		//QuestionSetDetail *qsd = [qs.setDetailsNSMA objectAtIndex:indexPath.row];		
		//2) remove from DB
	
		QuestionSetDetailsDAO *qsdDAO = [[QuestionSetDetailsDAO alloc] init];
		//[qsdDAO deleteDetailSetForDetailId:qsd.detailId];
		
		//3) remove from NSMA
		//[qs.setDetailsNSMA removeObjectAtIndex:indexPath.row];
		//4) reset cache
		//rely on pointers
		//5) update the View
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];		
		//[tableView reloadData];
		
	} //end IF statement
} //end method

@end
