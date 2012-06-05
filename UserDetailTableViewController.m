//
//  UserDetailTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "UserDetailTableViewController.h"
#import "Quiz.h"
#import "QuestionSet.h"
#import "QuizzesDAO.h"
#import "QuestionSetsDAO.h"
#import "AppLibrary.h"
#import "AssignQuizPopoverViewController.h"
#import "AppConstants.h"

@interface UserDetailTableViewController ()

//Utility
@property (nonatomic, strong) QuizzesDAO *quizsDAO;
@property (nonatomic, strong) QuestionSetsDAO *qSetDAO;
@property (nonatomic, strong) AppLibrary *appLibrary;

//Storage Arrays
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSMutableArray *quizzes;
@property (nonatomic, strong) NSMutableArray *tests;



@end

@implementation UserDetailTableViewController
@synthesize currentUser = _currentUser;
@synthesize results = _results, quizzes = _quizzes, tests = _tests, popover = _popover;
@synthesize quizsDAO = _quizsDAO, qSetDAO = _qSetDAO, appLibrary = _appLibrary;

-(void) setCurrentUser:(User *)currentUser{
    NSLog(@"Current User: %@",currentUser);
    if (![_currentUser isEqual:currentUser]) {
        _currentUser = currentUser;
        //Nil Invalid data Corresponding data
        self.results = self.quizzes = self.tests = nil;
        self.title = _currentUser.firstName;
        [self.tableView reloadData];
    }
}
-(NSMutableArray*) results{
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}
-(NSMutableArray*) quizzes{
    if (!_quizzes) {
        _quizzes = [self.quizsDAO getAvailablePracticeQuizzesByUserId: self.currentUser.userId];
    }
    return _quizzes;
}
-(NSMutableArray*) tests{
    if (!_tests) {
        _tests = [self.quizsDAO getAvailableTestQuizzesByUserId:self.currentUser.userId];
    }
    return _tests;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.quizsDAO = [[QuizzesDAO alloc] init];
        self.qSetDAO = [[QuestionSetsDAO alloc] init];
        self.appLibrary = [[AppLibrary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Results, Quizs, Tests
    return self.currentUser?3:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Number of items plus "Insert" row
    switch (section) {
        case 0:
            return self.results.count ;
            break;
        case 1:
            return self.quizzes.count + 1;
            break;
        case 2:
            return self.tests.count + 1;
            break;
        default:
            return 0;
            break;
    }
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Results";
            break;
        case 1:
            return @"Quizzes";
            break;
        case 2:
            return @"Tests";
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Check if last row... should include insert row
    if (indexPath.row == [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section]-1 && indexPath.section>0) {
        //Include Insert Row
        return [tableView dequeueReusableCellWithIdentifier:@"insertCell"];
    }
    
    UITableViewCell *cell = nil;
    Quiz *quiz;    
    switch (indexPath.section) {
        case 0:
            //Results
            cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell"];
            break;
        case 1:
            //Quizzes
            cell = [tableView dequeueReusableCellWithIdentifier:@"quizzesCell"];
            quiz = [self.quizzes objectAtIndex:indexPath.row];
            break;
        case 2:
            //Tests
            cell = [tableView dequeueReusableCellWithIdentifier:@"testsCell"];
            quiz = [self.tests objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    // Configure the cell...
    if (indexPath.section > 0) {
        QuestionSet *qSet = [self.qSetDAO getQuestionSetById:quiz.setId];
        cell.textLabel.text = [NSString stringWithFormat: @"Timed: %s%s",
                       [[self.appLibrary interpretMathTypeAsPhrase:qSet.mathType] UTF8String], [qSet.questionSetName UTF8String]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d:%d",quiz.requiredCorrect,quiz.allowedIncorrect];
    }

    
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return ![[tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"insertCell"];
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        switch (indexPath.section) {
            case 0:
                //Delete Results
                return;
                break;
            case 1:
                //Delete Quiz
                if ([self.quizsDAO deleteQuizForUser:[self.quizzes objectAtIndex:indexPath.row]]) {
                    [self.quizzes removeObjectAtIndex:indexPath.row];
                }
                else
                    return;
                break;
            case 2:
                //Delete Test
                if ([self.quizsDAO deleteQuizForUser:[self.tests objectAtIndex:indexPath.row]]) {
                    [self.tests removeObjectAtIndex:indexPath.row];
                }
                else
                    return;
                break;
            default:
                break;
        }
        
        //Update UI
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedCell.reuseIdentifier isEqualToString:@"insertCell"]) {
        AssignQuizPopoverViewController* assignVC = [self.storyboard instantiateViewControllerWithIdentifier:@"assignQuizViewController"];
        assignVC.testType = indexPath.section == 1?QUIZ_PRACTICE_TYPE:QUIZ_TIMED_TYPE;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:assignVC];
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:selectedCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if (indexPath.section >0) {
        AssignQuizPopoverViewController* assignVC = [self.storyboard instantiateViewControllerWithIdentifier:@"assignQuizViewController"];
        assignVC.testType = indexPath.section == 1?QUIZ_PRACTICE_TYPE:QUIZ_TIMED_TYPE;
        assignVC.assignedQuiz = [indexPath.section == 1?self.quizzes:self.tests objectAtIndex:indexPath.row];
        assignVC.updateMode = YES;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:assignVC];
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:selectedCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIPopoverController Delegate
-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    id contentViewController = popoverController.contentViewController;
    if ([contentViewController isKindOfClass:[AssignQuizPopoverViewController class]]) {
        if ((-1 == [contentViewController selectedSet]))
            return; 
        
        if (![contentViewController updateMode]) {
            QuestionSet *qs = [[contentViewController listofQuestionSets] objectAtIndex:[contentViewController selectedSet]];
            Quiz *newQuiz = [[Quiz alloc] init];
            newQuiz.userId = self.currentUser.userId;
            newQuiz.setId = qs.setId;
           // newQuiz.timeLimit = [timeLimitTF.text intValue];
            newQuiz.requiredCorrect = [contentViewController numberCorrectStepper].value;
            newQuiz.allowedIncorrect = [contentViewController numberIncorrectStepper].value;
            newQuiz.totalQuestions = INT16_MAX;
            newQuiz.testType = [contentViewController testType];
            QuizzesDAO *qDAO = [[QuizzesDAO alloc] init];
            [qDAO addQuizForUser:newQuiz];
        } 
        else {
            QuestionSet *qs = [[contentViewController listofQuestionSets] objectAtIndex:[contentViewController selectedSet]];
            [contentViewController assignedQuiz].setId = qs.setId;
            //[contentViewController assignedQuiz].timeLimit = [timeLimitTF.text intValue];
            [contentViewController assignedQuiz].requiredCorrect = [contentViewController numberCorrectStepper].value;
            [contentViewController assignedQuiz].allowedIncorrect = [contentViewController numberIncorrectStepper].value;
            [contentViewController assignedQuiz].totalQuestions = INT16_MAX;
            [contentViewController assignedQuiz].testType = [contentViewController testType];
            QuizzesDAO *qDAO = [[QuizzesDAO alloc] init];
            [qDAO updateQuizForUser: [contentViewController assignedQuiz]];
        }
        if ([contentViewController testType]== QUIZ_PRACTICE_TYPE)
            self.quizzes = nil;
        else
            self.tests = nil;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[contentViewController testType]==QUIZ_PRACTICE_TYPE?1:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
