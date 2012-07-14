//
//  DocumentSelectTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 11/07/2012.
//  Copyright (c) 2012 CDVConcepts. All rights reserved.
//

#import "DocumentSelectTableViewController.h"

@interface DocumentSelectTableViewController ()

@end

@implementation DocumentSelectTableViewController

@synthesize localDocuments = _localDocuments, icloudDocuments = _icloudDocuments;
@synthesize delegate = _delegate;
@synthesize selectedDocument = _selectedDocument;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;//iCloud: 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return section == 1?self.icloudDocuments.count:self.localDocuments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DocumentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSURL *url = [indexPath.section == 1?self.icloudDocuments:self.localDocuments objectAtIndex:indexPath.row];
    cell.textLabel.text = [[url lastPathComponent] stringByDeletingPathExtension];
    
    if ([url isEqual:self.selectedDocument.fileURL])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section == 1?@"iCloud":@"Local";
}
/*
-(NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return section == 1?@"These courses will sync to all of your iPads":@"These courses will only work on this iPad";
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Get deleted URL
        NSURL *deletedURL = [indexPath.section == 1?self.icloudDocuments:self.localDocuments objectAtIndex:indexPath.row];
        
        //Delete url
        [indexPath.section == 1?self.icloudDocuments:self.localDocuments removeObject:deletedURL];
                
        [self.delegate didDeleteDocumentWithURL:deletedURL];

        // Delete the row from the tableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
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
- (IBAction)toggleEditMode:(id)sender {
    self.tableView.editing = !self.tableView.editing;
}
#pragma mark - Segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"createCourseSegue"]) {
        [segue.destinationViewController setDelegate:self];
    }
}

-(void) didStartCreatingCourseWithURL:(NSURL *)newCourseURL inICloud:(BOOL)inICloud
{
    if (inICloud) {
        //Do nothing
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[self.delegate documentStateActivityIndicator] startAnimating];
    }
    else {
        [self.navigationController popToViewController:self animated:YES];
            
        //Update Data  
        [inICloud?self.icloudDocuments:self.localDocuments addObject:newCourseURL];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[inICloud?self.icloudDocuments:self.localDocuments indexOfObject:newCourseURL] inSection:inICloud?1:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewScrollPositionBottom];
        
        
        //Animate loading
        UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView*) [newCell viewWithTag:10];
        [spinner startAnimating];
    }
}
-(void) didFinishCreatingCourseWithURL:(NSURL *)newCourseURL inICloud:(BOOL)inICloud{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[self.delegate documentStateActivityIndicator] stopAnimating];

    
    //Animate loading
    UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[inICloud?self.icloudDocuments:self.localDocuments indexOfObject:newCourseURL] inSection:inICloud?1:0]];
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView*) [newCell viewWithTag:10];
    [spinner stopAnimating];
    
    [self.delegate didSelectDocumentWithURL:newCourseURL];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;

    [self.delegate didSelectDocumentWithURL:[indexPath.section == 1?self.icloudDocuments:self.localDocuments objectAtIndex:indexPath.row]];
}
@end
