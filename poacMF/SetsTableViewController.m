//
//  SetsTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "SetsTableViewController.h"
#import "QuestionSet.h"
#import "AEQuestionSetTableViewController.h"

@interface SetsTableViewController ()

@end

@implementation SetsTableViewController

@synthesize currentAdmin = _currentAdmin;

-(void) setCurrentAdmin:(Administrator *)currentAdmin{
    if (![_currentAdmin isEqual:currentAdmin]) {
        _currentAdmin = currentAdmin;
        [self setupFetchedResultsController];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    //Setup ViewController Switcher Toolbar
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Students",@"Sets", nil]];
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segControl.selectedSegmentIndex = 1;
    [segControl addTarget:self.navigationController action:@selector(switchViewController:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = [NSArray arrayWithObjects:[self.toolbarItems objectAtIndex:0],flexibleSpace,[[UIBarButtonItem alloc] initWithCustomView:segControl],flexibleSpace,self.toolbarItems.lastObject, nil];


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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addQuestionSetSegue"]) {
        [[[segue.destinationViewController viewControllers] lastObject] setAdministratorToCreateIn:self.currentAdmin];
    }
    else if ([segue.identifier isEqualToString:@"editQuestionSetSegue"]) {
        [[[segue.destinationViewController viewControllers] lastObject] setQuestionSetToUpdate:sender];
    }
    else if ([segue.identifier isEqualToString:@"summarySegueSet"]) {
        [[[segue.destinationViewController viewControllers] lastObject] setCurrentAdmin:self.currentAdmin];
    }
}


#pragma mark - NSFetchedResultsController Methods
- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    //Fetch all question sets of currentAdmin; Sort by type
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"QuestionSet"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"difficultyLevel" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
    request.predicate = [NSPredicate predicateWithFormat:@"administrator.username == %@",self.currentAdmin.username];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.currentAdmin.managedObjectContext
                                                                          sectionNameKeyPath:@"typeName"
                                                                                   cacheName:@"questionSetsCache"];
}
#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"questionSetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Get Question Set
    QuestionSet *qSet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //Customize Cell
    cell.textLabel.text = qSet.name; 
    
    return cell;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}
- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
    //Customize Section index titles
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.delegate didDeleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [self.fetchedResultsController.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}


 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
     NSMutableArray *questionSets = [self.fetchedResultsController fetchedObjects].mutableCopy;
     
     // Grab the item we're moving.
     QuestionSet *setToMove = [[self fetchedResultsController] objectAtIndexPath:fromIndexPath];
     
     // Remove the object we're moving from the array.
     [questionSets removeObject:setToMove];
     // Now re-insert it at the destination.
     [questionSets insertObject:setToMove atIndex:toIndexPath.row];
     
     // All of the objects are now in their correct order. Update each
     // object's displayOrder field by iterating through the array.
     int i = 0;
     for (QuestionSet *q in questionSets)
     {
         [q setValue:[NSNumber numberWithInt:i++] forKey:@"difficultyLevel"];
     }
 }

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the item to be re-orderable.
     return YES;
 }

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    //Limit moving cells to the section of their current type
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];     
    }
    
    return proposedDestinationIndexPath;
}
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        //Segue to edit set view
        [self performSegueWithIdentifier:@"editQuestionSetSegue" sender:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
    else {
        //Update Detail View controller with selected user
        [self.delegate didSelectObject:(QuestionSet*)[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
