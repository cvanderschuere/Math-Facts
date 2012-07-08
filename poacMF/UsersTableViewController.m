//
//  UsersTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "UsersTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PoacMFAppDelegate.h"
#import "AppConstants.h"
#import "UserDetailTableViewController.h"
#import "Student.h"
#import "AEUserTableViewController.h"

//Private Interface
@interface UsersTableViewController ()

@end

@implementation UsersTableViewController

@synthesize currentAdmin = _currentAdmin;

-(void) setCurrentAdmin:(Administrator *)currentAdmin{
    if (![_currentAdmin isEqual:currentAdmin]) {
        _currentAdmin = currentAdmin;
        [self setupFetchedResultsController];
    }
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setup ViewController Switcher Toolbar
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Users",@"Sets", nil]];
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segControl.selectedSegmentIndex = 0;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addStudentSegue"]) {
        [[[segue.destinationViewController viewControllers] lastObject] setCreatedStudentsAdmin:self.currentAdmin];
    }
    else if ([segue.identifier isEqualToString:@"editStudentSegue"]) {
        [[[segue.destinationViewController viewControllers] lastObject] setStudentToUpdate:sender];
    }
    else if ([segue.identifier isEqualToString:@"summarySegueUser"]) {
        [[[segue.destinationViewController viewControllers] lastObject] setCurrentAdmin:self.currentAdmin];
    }    
}

#pragma mark - NSFetchedResultsController Methods
- (void)setupFetchedResultsController
{
    //Fetch all students of currentAdmin
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"administrator.username == %@",self.currentAdmin.username];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.currentAdmin.managedObjectContext
                                                                          sectionNameKeyPath:@"firstNameInital"
                                                                                cacheName:@"studentsCache"];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"defaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *titleString=@"";
    
    //Get Student
    Student *student = [self.fetchedResultsController objectAtIndexPath:indexPath];

    //Customize Cell
    NSString *name = [student.firstName stringByAppendingString:@" "];
    titleString = [name stringByAppendingString:student.lastName];
    cell.textLabel.text = titleString; 
    
    return cell;
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        //Open edit student viewcontroll modally
        [self performSegueWithIdentifier:@"editStudentSegue" sender:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
    else {
        //Update Detail View controller with selected user
        [self.delegate didSelectObject:(Student*)[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
