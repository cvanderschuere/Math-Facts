//
//  UserProgressViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "UserProgressViewController.h"
#import "AppConstants.h"
#import "ResultsViewCell.h"
#import "ResultsDAO.h"
#import "SuperResults.h"
#import "Quiz.h"
#import "QuestionSet.h"
#import "QuizzesDAO.h"
#import "QuestionSetsDAO.h"
#import "AppLibrary.h"


@interface UserProgressViewController ()

@property (nonatomic, strong) NSMutableArray *quizArray;
@property (nonatomic, strong) NSMutableArray *testArray;

//Utility
@property (nonatomic, strong) QuizzesDAO *quizsDAO;
@property (nonatomic, strong) QuestionSetsDAO *qSetDAO;
@property (nonatomic, strong) AppLibrary *appLibrary;
@end

@implementation UserProgressViewController
@synthesize currentUser = _currentUser, quizArray = _quizArray, testArray = _testArray;
@synthesize quizTableView = _quizTableView, testTableView = _testTableView;
@synthesize quizsDAO = _quizsDAO, qSetDAO = _qSetDAO, appLibrary = _appLibrary;

-(void) setCurrentUser:(User *)currentUser{
    NSLog(@"Current User: %@",currentUser);
    if (![_currentUser isEqual:currentUser]) {
        _currentUser = currentUser;
        //Nil Invalid data Corresponding data
        self.quizArray = self.testArray = nil;
        self.title = _currentUser.firstName;
        [self.testTableView reloadData];
        [self.quizTableView reloadData];
    }
}
-(NSMutableArray*) quizArray{
    if (!_quizArray) {
        //Get quiz arrar and sort by sort order
        NSMutableArray* array = nil;//[self.quizsDAO getAvailablePracticeQuizzesByUserId: self.currentUser.userId];
        [array sortUsingComparator:^NSComparisonResult(Quiz* quiz1, Quiz *quiz2){
            int order1 = 0;//[self.qSetDAO getQuestionSetById:quiz1.setId].setOrder;
            int order2 = 0;//[self.qSetDAO getQuestionSetById:quiz2.setId].setOrder;
            if (order1>order2)
                return NSOrderedDescending;
            else if(order1<order2)
                return NSOrderedAscending;
            
            return NSOrderedSame;
        }];
        _quizArray = array;
    }
    return _quizArray;
}
-(NSMutableArray*) testArray{
    if (!_testArray) {
        //Get quiz arrar and sort by sort order
        NSMutableArray* array = nil;//[self.quizsDAO getAvailableTestQuizzesByUserId:self.currentUser.userId];
        [array sortUsingComparator:^NSComparisonResult(Quiz* quiz1, Quiz *quiz2){
            int order1 = 0;//[self.qSetDAO getQuestionSetById:quiz1.setId].setOrder;
            int order2 = 0;//[self.qSetDAO getQuestionSetById:quiz2.setId].setOrder;
            if (order1>order2)
                return NSOrderedDescending;
            else if(order1<order2)
                return NSOrderedAscending;
            
            return NSOrderedSame;
        }];
        _testArray = array;
    }
    return _testArray;
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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#pragma mark Button Methods
-(IBAction) logOut: (id) sender {
    //2) confirmatory logout prompt if they are logged in
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Logout?" 
                                                            delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Logout" 
                                                   otherButtonTitles:@"Cancel", nil, nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
}//end method
#pragma mark - Action Sheet Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
    if (buttonIndex == 0) {
        appDelegate.loggedIn = NO;
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
	}//end if
}//end method


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([tableView isEqual:self.quizTableView]) {
        return self.quizArray.count;
    }
    else if ([tableView isEqual:self.testArray]) {
        return self.testArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[tableView isEqual:self.testTableView]?@"testCell":@"quizCell"];
    
    // Configure the cell...
    Quiz * quiz = [[tableView isEqual:self.testTableView]?self.testArray:self.quizArray objectAtIndex:indexPath.row];
    QuestionSet *qSet = [self.qSetDAO getQuestionSetById:quiz.setId];
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


@end
