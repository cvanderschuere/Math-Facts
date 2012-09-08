//
//  SummaryTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 28/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "SummaryTableViewController.h"
#import "Student.h"
#import "SummaryTableViewCell.h"

@interface SummaryTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *studentInfoDict;
@property (nonatomic, strong) UIActionSheet* backupActionSheet;


@end

@implementation SummaryTableViewController
@synthesize studentInfoDict = _studentInfoDict;
@synthesize currentCourse = _currentCourse;
@synthesize backupActionSheet = _backupActionSheet;

-(void) setCurrentCourse:(Course *)currentCourse{
    if (![_currentCourse isEqual:currentCourse]) {
        _currentCourse = currentCourse;
        [self setupFetchedResultsController];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.studentInfoDict = [NSMutableDictionary dictionary];

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
    //Create fetch for all students with this course
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"course.name == %@",self.currentCourse.name];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.currentCourse.managedObjectContext
                                                                          sectionNameKeyPath:@"firstNameInital"
                                                                                   cacheName:nil];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"summaryCell";
    SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Get selectedStudent
    Student *selectedStudent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //Check for cachedResult
    Result *savedResult = (Result*) [self.studentInfoDict objectForKey:selectedStudent.username];
    
    if (savedResult) {
        //Use cached result for cell
        [cell setupCellForResult:savedResult withStudent:selectedStudent];
    }
    else {
        //Find last result for student
        NSArray* allResults = [selectedStudent.results.allObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]]];
            
        Result* lastResult = [allResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isPractice == %@",[NSNumber numberWithBool:NO]]].lastObject
;
        
        //Save for later use
        if (lastResult) {
            [self.studentInfoDict setObject:lastResult forKey:selectedStudent.username];
        }
        
        [cell setupCellForResult:lastResult withStudent:selectedStudent];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushV   iewController:detailViewController animated:YES];
     */
}
#pragma mark - IBActions
- (IBAction)done:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}
- (IBAction)backup:(UIBarButtonItem*)sender {
    if (self.backupActionSheet.visible) {
        return [self.backupActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    }

    self.backupActionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Backup: %@",self.currentCourse.name]  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Send Email",@"Save to documents", nil];
    
    return [self.backupActionSheet showFromBarButtonItem:sender animated:YES];
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex >= 2)
        return;    
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
    //Create CSV
    NSString* csvURLString = [self createCSVBackupForCourse:self.currentCourse];
    
    if (csvURLString) {
        if (buttonIndex == 0) {
            //Email
            NSData *csvData = [NSData dataWithContentsOfFile:csvURLString];
            
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            [picker setSubject:[NSString stringWithFormat:@"Math Facts Backup: %@",[csvURLString.lastPathComponent stringByDeletingPathExtension]]];
            
            [picker addAttachmentData:csvData mimeType:@"text/csv" fileName:csvURLString.lastPathComponent];
            [picker setMailComposeDelegate:self];
            [self presentModalViewController:picker animated:YES]; 
        }
        else if (buttonIndex == 1) {
            //Just save
        }
    }
    
}
-(NSString*) createCSVBackupForCourse:(Course*)course{                
        //Create file url
        NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                                NSUserDomainMask, YES ) objectAtIndex:0];
    NSString* fileURL = [[documentsDirectoryPath stringByAppendingPathComponent:course.name?course.name:@"Unnamed"] stringByAppendingPathExtension:@"csv"];
        
        [course saveCSVToFile:fileURL];  //[courses.lastObject performSelectorInBackground:@selector(saveCSVToFile:) withObject:fileURL];
        
        return fileURL;
}
#pragma mark - MFMailComposeDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}


@end
