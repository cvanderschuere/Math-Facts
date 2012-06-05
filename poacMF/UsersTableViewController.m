//
//  UsersTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "UsersTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PoacMFAppDelegate.h"
#import "AppConstants.h"
#import "ResultsViewCell.h"
#import "UsersDAO.h"
#import "ResultsDAO.h"
#import "SuperResults.h"
#import "AppLibrary.h"

//Private Interface
@interface UsersTableViewController ()

@property (strong, nonatomic)			NSMutableArray			*listOfUsersNSMA;
@property (strong, nonatomic)			NSMutableArray			*listOfResultsNSMA;
@property (strong, nonatomic)			NSDictionary			*detailsCountForUsersNSD;
@property (strong, nonatomic)			NSMutableArray			*detailsForSelectedUserNSMA;
@property (nonatomic)					BOOL					detailMode;
@property (nonatomic)					int						selectedUserIndex;

@end

@implementation UsersTableViewController
@synthesize listOfUsersNSMA = _listOfUsersNSMA, listOfResultsNSMA = _listOfResultsNSMA, detailsCountForUsersNSD = _detailsCountForUsersNSD, detailsForSelectedUserNSMA = _detailsForSelectedUserNSMA;
@synthesize detailMode = _detailMode, selectedUserIndex = _selectedUserIndex;

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
    
    //Load Users Information and store in array
    UsersDAO *uDAO = [[UsersDAO alloc] init];
	self.listOfUsersNSMA = [uDAO getAllUsers];
	NSLog(@"List of Users: %@",self.listOfUsersNSMA);
	if (nil == self.listOfUsersNSMA)
		self.listOfUsersNSMA = [NSMutableArray array];
	
	ResultsDAO *rDAO = [[ResultsDAO alloc] init];
	self.listOfResultsNSMA = [rDAO getAllResults];
	
	if (nil == self.listOfResultsNSMA)
		self.listOfResultsNSMA = [NSMutableArray array];
	
	AppLibrary *al = [[AppLibrary alloc] init];
	self.detailsCountForUsersNSD = [al matchAndCountUsers: self.listOfUsersNSMA toDetails:self.listOfResultsNSMA];
	
	self.detailsForSelectedUserNSMA = [NSMutableArray array];
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listOfUsersNSMA count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"defaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *titleString=@"";
    User *u = [self.listOfUsersNSMA objectAtIndex:indexPath.row];
    NSString *name = [u.firstName stringByAppendingString:@" "];
    titleString = [name stringByAppendingString:u.lastName];
    cell.textLabel.text = titleString; 
    
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
