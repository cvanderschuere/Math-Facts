//
//  UsersTableViewController.m
//  poacMF
//
//  Created by Matt Hunter on 3/24/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "UsersViewController.h"
#import "UsersDAO.h"
#import "User.h"
#import "AppConstants.h"
#import "AEUserViewController.h"
#import "AssignQuizViewController.h"
#import "AppConstants.h"
#import "QuizzesDAO.h"
#import "Quiz.h"
#import "QuestionSetsDAO.h"
#import "AppLibrary.h"
#import "QuestionSet.h"

@implementation UsersViewController

@synthesize  listOfUsers, thisTableView;

int TABLE_WIDTH = 300;
int TABLE_HEIGHT = 400;

//end method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}//end method

#pragma mark - Button Methods
-(IBAction)	userTableEditingTapped {
	if (thisTableView.editing)
		thisTableView.editing = NO;
	else
		thisTableView.editing = YES;
	[thisTableView reloadData];
}//end method

-(IBAction) addUser: (id) sender {
	AEUserViewController *addVC = [[AEUserViewController alloc] initWithNibName:AEUSER_NIB bundle:nil];
	addVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	addVC.view.frame = CGRectMake(0, 0, TABLE_WIDTH, TABLE_HEIGHT);
	[self presentModalViewController: addVC animated:YES];
	addVC.ptrTableToRedraw = thisTableView;
}//end method

-(IBAction)	assignQuizTapped {
	AssignQuizViewController *addVC = [[AssignQuizViewController alloc] initWithNibName:ASSIGN_QUIZ_NIB bundle:nil];
	addVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	addVC.testType = QUIZ_PRACTICE_TYPE;
	addVC.view.frame = CGRectMake(0, 0, TABLE_WIDTH,TABLE_HEIGHT);
	[self presentModalViewController: addVC animated:YES];
	addVC.ptrTableToRedraw = thisTableView;
}//end method

-(IBAction)	assignTestTapped {
	AssignQuizViewController *addVC = [[AssignQuizViewController alloc] initWithNibName:ASSIGN_QUIZ_NIB bundle:nil];
	addVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	addVC.testType = QUIZ_TIMED_TYPE;
	addVC.view.frame = CGRectMake(0, 0, 540, 580);
	[self presentModalViewController: addVC animated:YES];
	addVC.ptrTableToRedraw = thisTableView;
}//end method

-(void)	quizButtonClicked: (id) sender {
	UIButton *uib = (UIButton *) sender;
	
	AssignQuizViewController *addVC = [[AssignQuizViewController alloc] initWithNibName:ASSIGN_QUIZ_NIB bundle:nil];
	addVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	addVC.testType = QUIZ_PRACTICE_TYPE;
	addVC.view.frame = CGRectMake(0, 0, 540, 580);
	addVC.updateMode = YES;
	
	QuizzesDAO *quizsDAO = [[QuizzesDAO alloc] init];
	if (200 <= uib.tag) {
		int row = uib.tag - 200;
		User *u = [listOfUsers objectAtIndex:row];
		addVC.testType = QUIZ_TIMED_TYPE;
		NSMutableArray *testQuizzesNSMA = [quizsDAO getAvailableTestQuizzesByUserId: u.userId];
		addVC.assignedQuiz = [testQuizzesNSMA objectAtIndex:0];
	} else {
		int row = uib.tag - 100;
		User *u = [listOfUsers objectAtIndex:row];
		addVC.testType = QUIZ_PRACTICE_TYPE;
		NSMutableArray *practiceQuizzesNSMA = [quizsDAO getAvailablePracticeQuizzesByUserId: u.userId];
		addVC.assignedQuiz = [practiceQuizzesNSMA objectAtIndex:0];
	}//end if
	
	addVC.ptrTableToRedraw = thisTableView;
	
	[self presentModalViewController: addVC animated:YES];
}//end method

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UsersDAO *uDAO = [[UsersDAO alloc] init];
	self.listOfUsers = [uDAO getAllUsers];

	if (nil == self.listOfUsers)
		self.listOfUsers = [NSMutableArray array];
	
}//end method

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
NSLog(@"UsersTableVC.viewWillAppear");
	
}//end method

-(IBAction) setEditableTable {
	if (thisTableView.editing)
		[self.thisTableView setEditing:NO animated:YES];
	else
		[self.thisTableView setEditing: YES animated:YES]; 
	[thisTableView reloadData];
}//end method


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}//end method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (nil != listOfUsers)
		return [listOfUsers count];
    return 0;
}//end method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	
	//Pull all the subviews off the cell, otherwise the labels appear multiple times, 
	for (UIView *view in cell.contentView.subviews)
		[view removeFromSuperview];

	User *u = [listOfUsers objectAtIndex:indexPath.row];
	NSString *name = [u.firstName stringByAppendingString:@" "];
	name = [name stringByAppendingString:u.lastName];
	cell.textLabel.text = name;
	cell.textLabel.textColor = [UIColor blackColor];
	if (u.userType == ADMIN_USER_TYPE)
		cell.detailTextLabel.text = @"Administrator";
	else
		cell.detailTextLabel.text = @"Student";
	
	QuizzesDAO *quizsDAO = [[QuizzesDAO alloc] init];
	QuestionSetsDAO *qSetDAO = [[QuestionSetsDAO alloc] init];
	AppLibrary *al = [[AppLibrary alloc] init];
	int X_POSITION = 180;
	int Y_POSITION = 2;
	int WIDTH = 180;
	int HEIGHT = 30;
	
	//1) Get user's current practice
	NSMutableArray *practiceQuizzesNSMA = [quizsDAO getAvailablePracticeQuizzesByUserId: u.userId];
	Quiz *practiceQuiz;
	if ((nil != practiceQuizzesNSMA) && (0 < [practiceQuizzesNSMA count])) {
		practiceQuiz = [practiceQuizzesNSMA objectAtIndex:0];
		QuestionSet *qSet = [qSetDAO getQuestionSetById:practiceQuiz.setId];
		NSString *title = [NSString stringWithFormat: @"Practice: %s Set %s",
			[[al interpretMathTypeAsSymbol:qSet.mathType] UTF8String], [qSet.questionSetName UTF8String]];
		
		//2) Display practice Button
		CGRect pFrame = CGRectMake(X_POSITION, Y_POSITION, WIDTH, HEIGHT);
		UIButton *pButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		pButton.frame = pFrame;
		[pButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState: UIControlStateNormal]; 
		[pButton setTitle:title forState:UIControlStateNormal];
		[pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		pButton.tag = indexPath.row + 100;
		[pButton addTarget:self action:@selector(quizButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:pButton];
	} else {
		CGRect pFrame = CGRectMake(X_POSITION, Y_POSITION, WIDTH, HEIGHT);
		UILabel *pLabel = [[UILabel alloc] init];
		pLabel.frame = pFrame;
		pLabel.text = @"Practice not assigned.";
		pLabel.backgroundColor = [UIColor clearColor];
		[cell addSubview:pLabel];
	}//end if-else
	
	//3) Get user's current Test
	NSMutableArray *testQuizzesNSMA = [quizsDAO getAvailableTestQuizzesByUserId: u.userId];
	Quiz *testQuiz;
	if ((nil != testQuizzesNSMA) && (0 < [testQuizzesNSMA count])) {
		testQuiz = [testQuizzesNSMA objectAtIndex:0];
		QuestionSet *qSet = [qSetDAO getQuestionSetById:testQuiz.setId];
		NSString *title = [NSString stringWithFormat: @"Timed: %s Set %s",
						   [[al interpretMathTypeAsSymbol:qSet.mathType] UTF8String], [qSet.questionSetName UTF8String]];
		
		///4) Display test Button
		int adjustedY = Y_POSITION + HEIGHT + 2;
		CGRect tFrame = CGRectMake(X_POSITION, adjustedY, WIDTH, HEIGHT);
		UIButton *tButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		tButton.frame = tFrame;
		[tButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState: UIControlStateNormal]; 
		tButton.tag = indexPath.row + 200;
		[tButton setTitle:title forState:UIControlStateNormal];
		[tButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[tButton addTarget:self action:@selector(quizButtonClicked:) forControlEvents:UIControlEventTouchUpInside];		
		[cell addSubview:tButton];
	} else {
		int adjustedY = Y_POSITION + HEIGHT + 2;
		CGRect pFrame = CGRectMake(X_POSITION, adjustedY, WIDTH, HEIGHT);
		UILabel *pLabel = [[UILabel alloc] init];
		pLabel.frame = pFrame;
		pLabel.text = @"Test not assigned.";
		pLabel.backgroundColor = [UIColor clearColor];
		[cell addSubview:pLabel];
	}//end if-else
	
    return cell;
}//end method

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}//end method

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		User *deleteUser = [listOfUsers objectAtIndex:indexPath.row];
		UsersDAO *usDAO = [[UsersDAO alloc] init];
		[usDAO deleteUserById:deleteUser.userId];
		[listOfUsers removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}//end if
}//end method

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[thisTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	User *updateUser = [listOfUsers objectAtIndex:indexPath.row];
	
	AEUserViewController *addVC = [[AEUserViewController alloc] initWithNibName:AEUSER_NIB bundle:nil];
	addVC.editMode = TRUE; 
	addVC.updateUser = updateUser;
	addVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	addVC.view.frame = CGRectMake(0, 0, TABLE_WIDTH, TABLE_HEIGHT);
	[self presentModalViewController: addVC animated:YES];
}//end method

@end
