//
//  UserDetailTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "UserDetailTableViewController.h"
#import "AppConstants.h"
#import "Test.h"
#import "QuestionSet.h"
#import "Administrator.h"
#import "AEUserTableViewController.h"

@interface UserDetailTableViewController ()

//Storage Arrays
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSMutableArray *quizzes;
@property (nonatomic, strong) NSMutableArray *tests;



@end

@implementation UserDetailTableViewController
@synthesize editButton = _editButton;
@synthesize shareButton = _shareButton;
@synthesize student = _student;
@synthesize results = _results, quizzes = _quizzes, tests = _tests, popover = _popover;
-(void) setStudent:(Student *)student{
    if (![_student isEqual:student]) {
        _student = student;
        NSLog(@"Student: %@",_student);
        //Set Title and setup observer
        self.title = _student.firstName;
        self.debug = YES;
        
        if (_student){   //Enable Button Segues
            self.shareButton.enabled = self.editButton.enabled = YES;
            [self setupFetchedResultsController];
        }
        else {   //Disable and clear tableview
            self.fetchedResultsController = nil;
            self.shareButton.enabled = self.editButton.enabled = NO;
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_student)   //Enable Button Segues
        self.shareButton.enabled = self.editButton.enabled = YES;
    else    //Disable
        self.shareButton.enabled = self.editButton.enabled = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setEditButton:nil];
    [self setShareButton:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Storyboard
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showTestSegue"]) {
        //Get selected test from frc and pass it along
        Test* selectedTest = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
        [segue.destinationViewController setTest:selectedTest];
    }
    else if ([segue.identifier isEqualToString:@"editStudentSegue"]) {
        [[[segue.destinationViewController viewControllers] lastObject] setCreatedStudentsAdmin:self.student.administrator];
        [[[segue.destinationViewController viewControllers] lastObject] setStudentToUpdate:self.student];

    }
}

#pragma mark - NSFetchedResultsController Methods
- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Test"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"isCurrentTest" ascending:NO selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"questionSet.type" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"questionSet.difficultyLevel" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"questionSet.name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
    request.predicate = [NSPredicate predicateWithFormat:@"student.username == %@",self.student.username];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.student.managedObjectContext
                                                                          sectionNameKeyPath:@"isCurrentTest"
                                                                                   cacheName:nil];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName = [super tableView:tableView titleForHeaderInSection:section];
    if ([sectionName isEqualToString:@"1"]) {
        return @"Current";
    }
    else {
        return @"History";
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.fetchedResultsController.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    //Check if section 1 and current test doesnt exist
    if (indexPath.section == 0 && !self.student.currentTest) {
        return [tableView dequeueReusableCellWithIdentifier:@"selectTestCell"];
    }
     */
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
    Test *test = (Test*) [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",test.questionSet.typeName,test.questionSet.name];// [@"Test: " stringByAppendingString:test.questionSet.name];
    
    cell.imageView.image = test.passed.boolValue?[UIImage imageNamed:@"passStamp"]:nil;
    
    return cell;
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

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return ![[tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"selectTestCell"];
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
    /*
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedCell.reuseIdentifier isEqualToString:@"selectTestCell"]) {
        SelectCurrentTestTableViewController* selectTest = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCurrentTestTableViewController"];
        selectTest.delegate = self;
        selectTest.context = self.student.managedObjectContext;
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:selectTest];
        [self.popover presentPopoverFromRect:selectedCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if ([selectedCell.reuseIdentifier isEqualToString:@"addTestCategoryCell"]) {
        AddCategoryPopoverController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addCategoryPopoverController"];
        //Find categorys that student doesnt have yet
        NSMutableArray *availableCategories = [NSMutableArray array];
        for (QuestionSet* questionSet in self.student.administrator.questionSets) {
            if (![availableCategories containsObject:questionSet.type]) {
                [availableCategories addObject:questionSet.type];
            }
        }
        NSMutableArray *currentCategories = [NSMutableArray array];
        for (Test* test in self.student.tests) {
            if (![currentCategories containsObject:test.questionSet.type]) {
                [currentCategories addObject:test.questionSet.type];
            }
        }
        [availableCategories removeObjectsInArray:currentCategories];
        addVC.categoriesToChoose = availableCategories;
        addVC.delegate = self;
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:addVC];
        [self.popover presentPopoverFromRect:selectedCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void) didSelectQuestionSet:(QuestionSet*)selectedQuestionSet{
    //Fetch pre-existing test for this user and questionset
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Test"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"student.firstName" ascending:YES]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"questionSet.type == %@ AND questionSet.difficultyLevel == %@ AND questionSet.name == %@ AND student.username == %@",selectedQuestionSet.type,selectedQuestionSet.difficultyLevel,selectedQuestionSet.name,self.student.username];
    NSArray* result = [self.student.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    
    
    Test* currentTest = nil;
    //If no prexisting tests exist...create new
    if (result.count == 0) {
        currentTest = [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:self.student.managedObjectContext];
        currentTest.questionSet = selectedQuestionSet;
        currentTest.testLength = self.student.defaultTestLength;
        currentTest.passCriteria = self.student.defaultPassCriteria;
        [self.student addTestsObject:currentTest];

    }
    else {
        currentTest = result.lastObject;
    }
    
    [self.student setCurrentTest:currentTest];
}

-(void) didAddCategoryType:(NSNumber *)categoryType{
    //Fetch all question sets of this category type from admin
    NSFetchRequest* questionSetRequest = [NSFetchRequest fetchRequestWithEntityName:@"QuestionSet"];
    questionSetRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"difficultyLevel" ascending:YES]];
    questionSetRequest.predicate = [NSPredicate predicateWithFormat:@"administrator.username == %@ AND type == %@",self.student.administrator.username,categoryType];
    NSArray* questionSetResults = [self.student.managedObjectContext executeFetchRequest:questionSetRequest error:NULL];
    
    [self.popover dismissPopoverAnimated:YES];
    
    NSLog(@"Student: %@", self.student);
    
    //Create a test for each set and add it to student
    for (QuestionSet * qSet in questionSetResults) {
        Test* newTest = [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:self.student.managedObjectContext];
        newTest.questionSet = qSet;
        newTest.testLength = self.student.defaultTestLength;
        newTest.passCriteria = self.student.defaultPassCriteria;
        [self.student addTestsObject:newTest];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveDatabase" object:nil];
}
-(void) didAddTestForQuestionSet:(QuestionSet *)qSet minCorrect:(int)minCorrect length:(NSTimeInterval)length{
    [self.popover dismissPopoverAnimated:YES];

    Test* newTest = [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:self.student.managedObjectContext];
    newTest.questionSet = qSet;
    newTest.testLength = [NSNumber numberWithDouble:length];
    newTest.passCriteria = [NSNumber numberWithInt:minCorrect];
    [self.student addTestsObject:newTest];
}

- (IBAction)selectCurrentTest:(UIBarButtonItem*)sender {
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:YES];
    }
    
    SelectCurrentTestTableViewController* selectTest = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCurrentTestTableViewController"];
    selectTest.delegate = self;
    selectTest.context = self.student.managedObjectContext;
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:selectTest];
    [self.popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
@end
