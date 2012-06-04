//
//  ResultsViewController.m
//  poacMF
//
//  Created by Matt Hunter on 5/6/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultsViewCell.h"
#import "UsersDAO.h"
#import "ResultsDAO.h"
#import "SuperResults.h"
#import "AppLibrary.h"
#import "AppConstants.h"

@implementation ResultsViewController

@synthesize thisTableView, listOfUsersNSMA, listOfResultsNSMA, detailsCountForUsersNSD;
@synthesize selectedUserIndex, detailMode, detailsForSelectedUserNSMA;

- (void)dealloc {
	[thisTableView release];
	[listOfUsersNSMA release];
	[listOfResultsNSMA release];
	[detailsCountForUsersNSD release];
	[detailsForSelectedUserNSMA release];
    [super dealloc];
}//end method

#pragma mark Button Methods


#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UsersDAO *uDAO = [[UsersDAO alloc] init];
	self.listOfUsersNSMA = [uDAO getAllUsers];
	[uDAO release];
	
	if (nil == self.listOfUsersNSMA)
		self.listOfUsersNSMA = [NSMutableArray array];
	
	ResultsDAO *rDAO = [[ResultsDAO alloc] init];
	self.listOfResultsNSMA = [rDAO getAllResults];
	[rDAO release];
	
	if (nil == self.listOfResultsNSMA)
		self.listOfResultsNSMA = [NSMutableArray array];
	
	AppLibrary *al = [[AppLibrary alloc] init];
	self.detailsCountForUsersNSD = [al matchAndCountUsers: listOfUsersNSMA toDetails:listOfResultsNSMA];
	[al release];
	
	self.detailsForSelectedUserNSMA = [NSMutableArray array];
	
	detailMode=FALSE;
}//end method

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	NSLog(@"ResultsVC.viewWillAppear");
}//end method

#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   return YES;
}

#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (detailMode) {
		return 2;
    }//end if
	return 1;
}//end method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (detailMode) {
		if (0 == section) {
			User *u = [listOfUsersNSMA objectAtIndex:selectedUserIndex];
			NSNumber *userKey = [NSNumber numberWithInt:u.userId];
			NSNumber *recordCount = (NSNumber *) [self.detailsCountForUsersNSD objectForKey:userKey];
			if (nil == recordCount)
				return 0;
			return [recordCount intValue];
		} else {
			return [self.listOfUsersNSMA count];
		}//end
	} else
		return [self.listOfUsersNSMA count];
}//end method


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section { 
	if (detailMode) {
		if (0 == section) {
			NSString *titleString=@"";
			User *u = [listOfUsersNSMA objectAtIndex:selectedUserIndex];
			NSString *name = [u.firstName stringByAppendingString:@" "];
			titleString = [name stringByAppendingString:u.lastName];
			return titleString;
		} else 
			return (@"Other Users");
	} else
		return @"";
}//end method

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   if ((detailMode) && (0 == indexPath.section)) {
		static NSString *CellIdentifier = @"ResultsVCell";
		ResultsViewCell *cell = (ResultsViewCell *) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil){
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ResultsViewCell" owner:self options:nil];
			for (id currentObject in topLevelObjects) {
				if ([currentObject isKindOfClass:[ResultsViewCell class]]) {
					cell = (ResultsViewCell *) currentObject;
					//break;
				}//end if
			}//end for
		}//end if
		
	   //for section 0, Using selectedUserIndex, get the record count for the user, find those records
	   //TODO: You're here, 
	   
		AppLibrary *al = [[AppLibrary alloc] init];
		SuperResults *sr = [self.detailsForSelectedUserNSMA objectAtIndex:indexPath.row];	
		if (QUIZ_PRACTICE_TYPE == sr.testType)
			cell.testTypeLabel.text = @"Practice";
		else
			cell.testTypeLabel.text = @"Timed";
		
		NSString *setName = [[al interpretMathTypeAsPhrase:sr.mathType] stringByAppendingString:@": "];
		setName = [setName stringByAppendingString:sr.setName];
		cell.mathTypeLabel.text = setName;
	
		NSNumber *nsn;
		nsn = [NSNumber numberWithInt:sr.resultsCorrect];
		cell.resultsNumberCorrect.text = [nsn stringValue];
	
		nsn = [NSNumber numberWithInt:sr.resultsTotalQuestions];
		cell.resultsTotalCount.text = [nsn stringValue];
	
		nsn = [NSNumber numberWithInt:sr.resultsTimeTaken];
		NSString *timeTaken = [[nsn stringValue] stringByAppendingString:@" seconds"];
		cell.resultsTimeTaken.text = timeTaken;
	
		nsn = [NSNumber numberWithInt:sr.requiredCorrect];
		cell.requiredNumberCorrect.text = [nsn stringValue];
	
		nsn = [NSNumber numberWithInt:sr.requiredTotalQuestions];
		cell.requiredTotalCount.text = [nsn stringValue];
	
		nsn = [NSNumber numberWithInt:sr.requiredTimeLimit];
		timeTaken = [[nsn stringValue] stringByAppendingString:@" seconds"];
		cell.requiredTimeTaken.text = timeTaken;
	
		cell.testDate.text = [al formattedDate:sr.resultsTestDate];
	
		cell.passFailLabel.text = sr.resultsPassFail;
		if (NSOrderedSame == [sr.resultsPassFail compare:@"Fail"])
			cell.passFailLabel.backgroundColor = [UIColor redColor];
		else
			cell.passFailLabel.backgroundColor = [UIColor greenColor];
	
		[al release];
	   return cell;
   } else {
	   static NSString *CellIdentifier = @"Cell";
	   
	   UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	   if (cell == nil) {
		   cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	   }
	   NSString *titleString=@"";
	   User *u = [listOfUsersNSMA objectAtIndex:indexPath.row];
	   NSString *name = [u.firstName stringByAppendingString:@" "];
	   titleString = [name stringByAppendingString:u.lastName];
	   cell.textLabel.text = titleString; 
	   return cell;
   }//end if/else
return nil;
}//end 

#pragma mark Table Delegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	detailMode = YES;
	selectedUserIndex = indexPath.row;
	//populate detailsForSelectedUserNSMA with detail rows
	[self.detailsForSelectedUserNSMA removeAllObjects];
	User *u = [listOfUsersNSMA objectAtIndex:indexPath.row];
	for (SuperResults *sr in self.listOfResultsNSMA) {
		if (u.userId == sr.userId)
			[self.detailsForSelectedUserNSMA addObject:sr];
	}//end for

	
	[tableView reloadData];
}//end didSelectRowAtIndexPath

@end
