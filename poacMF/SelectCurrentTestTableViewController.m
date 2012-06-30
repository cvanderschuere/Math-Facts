//
//  SelectCurrentTestTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 24/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "SelectCurrentTestTableViewController.h"
#import "QuestionSet.h"

@interface SelectCurrentTestTableViewController ()

@end

@implementation SelectCurrentTestTableViewController
@synthesize student = _student;
@synthesize delegate = _delegate;

-(void) setStudent:(Student *)student{
    _student = student;
    if(_student)
        [self setupFetchedResultsController];
}

#pragma mark - View Lifecycle
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

#pragma mark - NSFetchedResultsController Methods
 - (void)setupFetchedResultsController
{
   //Fetch all question sets of current admin; sort by typeName  
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"QuestionSet"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"difficultyLevel" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
    request.predicate = [NSPredicate predicateWithFormat:@"administrator.username == %@",self.student.administrator.username];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.student.managedObjectContext
                                                                          sectionNameKeyPath:@"typeName"
                                                                                   cacheName:nil];
}
#pragma mark - Table view data source
         
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"questionSetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    QuestionSet *qSet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = qSet.name; 
    
    return cell;
}
 - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;//[self.fetchedResultsController sectionIndexTitles];
}
 - (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
     //Customize Section Index Titles
     if ([sectionName isEqualToString:@"Addition"]) {
         return @"+";
     }
     else if ([sectionName isEqualToString:@"Subtraction"]) {
         return @"-";
     }
     else if ([sectionName isEqualToString:@"Multiplication"]) {
         return @"x";
     }
     else if ([sectionName isEqualToString:@"Division"]) {
         return @"/";
     }
     return nil;
 }
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
 return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if ([self.delegate respondsToSelector:@selector(didSelectQuestionSet:)]) {
        [self.delegate didSelectQuestionSet:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
