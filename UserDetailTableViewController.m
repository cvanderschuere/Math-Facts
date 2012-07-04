//
//  UserDetailTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
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
        //Set Title and setup observer
        self.title = _student.firstName;
        
        if (_student){   //Enable Button Segues
            self.shareButton.enabled = self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
            [self setupFetchedResultsController];
        }
        else {   //Disable and clear tableview
            self.fetchedResultsController = nil;
            self.shareButton.enabled = self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}
#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Only enable segues if student exists
    if (_student)   
        self.shareButton.enabled = self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
    else    //Disable
        self.shareButton.enabled = self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = NO;

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
        //Pass student to update
        [[[segue.destinationViewController viewControllers] lastObject] setCreatedStudentsAdmin:self.student.administrator];
        [[[segue.destinationViewController viewControllers] lastObject] setStudentToUpdate:self.student];

    }
}

#pragma mark - NSFetchedResultsController Methods
- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    //Create fetch for all tests for student; Section by current
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Test"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"isCurrentTest" ascending:NO selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"questionSet.type" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"questionSet.difficultyLevel" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"questionSet.name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
    request.predicate = [NSPredicate predicateWithFormat:@"student.username == %@",self.student.username];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.student.managedObjectContext
                                                                          sectionNameKeyPath:@"isCurrentTest"
                                                                                   cacheName:nil];
}
#pragma mark - Table view data source
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName = [super tableView:tableView titleForHeaderInSection:section];
    
    //Customize section header from "isCurrentTest" bool
    if ([sectionName isEqualToString:@"1"]) {
        return @"Current";
    }
    else {
        return @"History";
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil; //Disable section index titles
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
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
    
    //Get Test
    Test *test = (Test*) [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //Customize Cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",test.questionSet.typeName,test.questionSet.name];
    cell.imageView.image = test.passed.boolValue?[UIImage imageNamed:@"passStamp"]:nil;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return ![[tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"selectTestCell"];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Make custom menu
    UIMenuController* menu = [UIMenuController sharedMenuController];
    
}

#pragma mark - Select Current Test Methods
- (IBAction)selectCurrentTest:(UIBarButtonItem*)sender {
    if (self.popover.popoverVisible) {
        return [self.popover dismissPopoverAnimated:YES];
    }
    
    SelectCurrentTestTableViewController* selectTest = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCurrentTestTableViewController"];
    selectTest.delegate = self;
    selectTest.student = self.student;
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:selectTest];
    [self.popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void) didSelectQuestionSet:(QuestionSet*)selectedQuestionSet{
    [self.student selectQuestionSet:selectedQuestionSet];
    [self.popover dismissPopoverAnimated:YES];
}

@end
