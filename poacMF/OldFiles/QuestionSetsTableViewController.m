//
//  QuestionSetsTableViewController.m
//  poacMF
//
//  Created by Matt Hunter on 3/29/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuestionSetsTableViewController.h"
#import "QuestionSetsDAO.h"
#import "QuestionSet.h"
#import "QuestionSetDetail.h"
#import "AppConstants.h"
#import "AppLibrary.h"

@implementation QuestionSetsTableViewController

@synthesize listofQuestionSets, thisTableView;

- (void)dealloc {
	[listofQuestionSets release];
	[thisTableView release];
    [super dealloc];
}//end method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  	return YES;
}//end method

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	QuestionSetsDAO *uDAO = [[QuestionSetsDAO alloc] init];
	self.listofQuestionSets = [uDAO getAllSets];
	[uDAO release];
	
	if (nil == self.listofQuestionSets)
		self.listofQuestionSets = [NSMutableArray array];
	
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
		count = [qs.setDetailsNSMA count];
	}
    return count;
}//end method
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section { 
	NSString *titleString=@"";
	AppLibrary *al = [[AppLibrary alloc] init];
	if (nil != listofQuestionSets) {
		QuestionSet *qs = [listofQuestionSets objectAtIndex:section];
		titleString = [al interpretMathTypeAsPhrase:qs.mathType];
		titleString = [titleString stringByAppendingString:qs.questionSetName];
	}//
	[al release];
	return titleString;
}//end method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	AppLibrary *al = [[AppLibrary alloc] init];
	if (nil != listofQuestionSets){
		QuestionSet *qs = [listofQuestionSets objectAtIndex:indexPath.section];
		QuestionSetDetail *qsd = [qs.setDetailsNSMA objectAtIndex:indexPath.row];
		NSString *sign = [al interpretMathTypeAsSymbol:qs.mathType];
		NSString *questionString = @"";

		if (nil != qsd)
			questionString = [NSString stringWithFormat:@"%i %s %i", qsd.xValue, [sign UTF8String], qsd.yValue];
		cell.textLabel.text = questionString;
	}//end method
	[al release];
	
	return cell;
}//end method

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[thisTableView deselectRowAtIndexPath:indexPath animated:YES];
	
}//end method

@end
