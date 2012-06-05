//
//  AdminViewController.m
//  poacMF
//
//  Created by Matt Hunter on 3/19/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "AdminViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PoacMFAppDelegate.h"
#import "AppConstants.h"
#import "ResultsViewCell.h"
#import "UsersDAO.h"
#import "ResultsDAO.h"
#import "SuperResults.h"
#import "AppLibrary.h"

@implementation AdminViewController

@synthesize usersVC = _usersVC, questionSetsVC = _questionSetsVC, studentView = _studentView, questionsView = _questionsView, usersViewable = _usersViewable;
@synthesize resultsVC = _resultsVC, questionSetsViewable = _questionSetsViewable;
@synthesize thisTableView = _thisTableView, listOfUsersNSMA = _listOfUsersNSMA, listOfResultsNSMA = _listOfResultsNSMA, detailsCountForUsersNSD = _detailsCountForUsersNSD, detailsForSelectedUserNSMA = _detailsForSelectedUserNSMA;
@synthesize detailMode = _detailMode, selectedUserIndex = _selectedUserIndex;


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	self.studentView.hidden = YES;
    
    //Setup Results TableView
    UsersDAO *uDAO = [[UsersDAO alloc] init];
	self.listOfUsersNSMA = [uDAO getAllUsers];
	NSLog(@"List of Users: %@",self.listOfUsersNSMA);
	if (nil == self.listOfUsersNSMA)
		self.listOfUsersNSMA = [NSMutableArray array];
	
	ResultsDAO *rDAO = [[ResultsDAO alloc] init];
	self.listOfResultsNSMA = [rDAO getAllResults];
	
	if (nil == self.listOfResultsNSMA)
		self.listOfResultsNSMA = [NSMutableArray array];
	
	AppLibrary *al = [[AppLibrary alloc] init];
	self.detailsCountForUsersNSD = [al matchAndCountUsers: self.listOfUsersNSMA toDetails:self.listOfResultsNSMA];
	
	self.detailsForSelectedUserNSMA = [NSMutableArray array];

}//end method

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
}//end method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

-(IBAction) showQuestionSets {
	if (self.questionSetsViewable) {
		self.questionSetsViewable = NO;
		//create the frame for the view so that it exists off screen.
		int X_POSITION = 1024;
		int Y_POSITION = self.questionSetsVC.view.frame.origin.y;
		int WIDTH = self.questionSetsVC.view.frame.size.width;
		int HEIGHT = self.questionSetsVC.view.frame.size.height;
		CGRect frame = CGRectMake(X_POSITION,Y_POSITION,WIDTH, HEIGHT);
		self.questionSetsVC.view.frame = frame;
		
		// set up an animation for the transition between the views
		CATransition *animation = [CATransition animation];
		[animation setDuration:0.5];
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromRight];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
		//execute the animation
		[[self.questionSetsVC.view layer] addAnimation:animation forKey:@"SwitchToView2"];
	} else {		
        /*Matt: When I had this code in the viewDidLoad the views didn't
         slide in/out correctly after the first one. */
        
        //Create viewcontroller from nib if need-be and add as child
        if (!self.questionSetsVC){
            self.questionSetsVC = [[QuestionSetsViewController alloc] initWithNibName:QUESTION_SETS_VIEW_NIB bundle:nil];
            [self addChildViewController:self.questionSetsVC];
            [self.view addSubview:self.questionSetsVC.view];
            [self.questionSetsVC didMoveToParentViewController:self];
        }

        [self.questionSetsVC.thisTableView reloadData];
        
        //setup the frame of the subTopicsVC
        int WIDTH = 374;
        int HEIGHT = 600;
        int Y_POSITION = 125;
        
        int X_POSITION = (0);
        
        CGRect frame = CGRectMake(X_POSITION,Y_POSITION,WIDTH, HEIGHT);
        self.questionSetsVC.view.frame = frame;
        
        // set up an animation for the transition between the views
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        //call the animation
        [[self.questionSetsVC.view layer] addAnimation:animation forKey:@"SwitchToView4"];
		//turn the flag so that a second VC isn't created
		self.questionSetsViewable = YES;	
	}//end if
}//end method

-(IBAction) showUsers {
	if (self.usersViewable) {
		self.usersViewable = NO;
		//create the frame for the view so that it exists off screen.
		int X_POSITION = 1024;
		int Y_POSITION = self.usersVC.view.frame.origin.y;
		int WIDTH = self.usersVC.view.frame.size.width;
		int HEIGHT = self.usersVC.view.frame.size.height;
		CGRect frame = CGRectMake(X_POSITION,Y_POSITION,WIDTH, HEIGHT);
		self.usersVC.view.frame = frame;
		
		// set up an animation for the transition between the views
		CATransition *animation = [CATransition animation];
		[animation setDuration:0.5];
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromLeft];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
		//execute the animation
		[[self.usersVC.view layer] addAnimation:animation forKey:@"SwitchToView0"];
		
	} 
    else {
		[self.usersVC.thisTableView reloadData];
		
		//if we've never opened the view, slide it open
		if (!self.usersViewable) {
			/*create the VC with NIB. When I had this code in the viewDidLoad the views didn't
			 slide in/out correctly after the first one. */
            
            //Create viewcontroller from nib if need-be and add as child
            if (!self.usersVC){
                self.usersVC = [[UsersViewController alloc] initWithNibName:USERS_VIEW_NIB bundle:nil];
                [self addChildViewController:self.usersVC];
                [self.view addSubview:self.usersVC.view];
                [self.usersVC didMoveToParentViewController:self];
            }
			
			//setup the frame of the subTopicsVC
			int WIDTH = 374;
			int HEIGHT = 600;
			int Y_POSITION = 125;
			
			int X_POSITION = (self.view.frame.size.width - WIDTH);
			if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
				self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
				X_POSITION = 650;
			}//end
			
			CGRect frame = CGRectMake(X_POSITION,Y_POSITION,WIDTH, HEIGHT);
			self.usersVC.view.frame = frame;
			
			// set up an animation for the transition between the views
			CATransition *animation = [CATransition animation];
			[animation setDuration:0.5];
			[animation setType:kCATransitionPush];
			[animation setSubtype:kCATransitionFromRight];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
			//call the animation
			[[self.usersVC.view layer] addAnimation:animation forKey:@"SwitchToView1"];
		}//end if
		//turn the flag so that a second VC isn't created
		self.usersViewable = YES;	
	}//end if
}//end method

#pragma mark Button Methods
-(IBAction) logOut: (id) sender {
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Logout?" 
		delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Logout" 
		otherButtonTitles:@"Cancel", nil, nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
}//end method

#pragma mark - Action Sheet Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
    if (buttonIndex == 0){
        appDelegate.loggedIn = NO;
		[appDelegate.window setRootViewController:[self.storyboard instantiateInitialViewController]];
	}//end
}//end method

#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.detailMode) {
		return 2;
    }//end if
	return 1;
}//end method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.detailMode) {
		if (0 == section) {
			User *u = [self.listOfUsersNSMA objectAtIndex:self.selectedUserIndex];
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
	if (self.detailMode) {
		if (0 == section) {
			NSString *titleString=@"";
			User *u = [self.listOfUsersNSMA objectAtIndex:self.selectedUserIndex];
			NSString *name = [u.firstName stringByAppendingString:@" "];
			titleString = [name stringByAppendingString:u.lastName];
			return titleString;
		} else 
			return (@"Other Users");
	} else
		return @"";
}//end method

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.detailMode) && (0 == indexPath.section)) {
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
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"defaultCell";
        
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSLog(@"List of Users: %@",self.listOfUsersNSMA);

        NSString *titleString=@"";
        User *u = [self.listOfUsersNSMA objectAtIndex:indexPath.row];
        NSString *name = [u.firstName stringByAppendingString:@" "];
        titleString = [name stringByAppendingString:u.lastName];
        cell.textLabel.text = titleString; 
        return cell;
    }//end if/else
    return nil;
}//end 

#pragma mark -UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	self.detailMode = YES;
	self.selectedUserIndex = indexPath.row;
	//populate detailsForSelectedUserNSMA with detail rows
	[self.detailsForSelectedUserNSMA removeAllObjects];
	User *u = [self.listOfUsersNSMA objectAtIndex:indexPath.row];
	for (SuperResults *sr in self.listOfResultsNSMA) {
		if (u.userId == sr.userId)
			[self.detailsForSelectedUserNSMA addObject:sr];
	}//end for
    
	
	[tableView reloadData];
}//end didSelectRowAtIndexPath

@end
