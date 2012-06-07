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
#import "ResultsDAO.h"
#import "SuperResults.h"
#import "AppLibrary.h"
#import "UserDetailTableViewController.h"

//Private Interface
@interface UsersTableViewController ()

@property (strong, nonatomic)			NSMutableArray			*listOfUsersNSMA;
@property (strong, nonatomic)			NSMutableArray			*listOfResultsNSMA;
@property (strong, nonatomic)			NSDictionary			*detailsCountForUsersNSD;
@property (strong, nonatomic)			NSMutableArray			*detailsForSelectedUserNSMA;
@property (nonatomic)					BOOL					detailMode;
@property (nonatomic)					int						selectedUserIndex;

@property (nonatomic, weak)             UserDetailTableViewController   *userDetail;

@end

@implementation UsersTableViewController
@synthesize listOfUsersNSMA = _listOfUsersNSMA, listOfResultsNSMA = _listOfResultsNSMA, detailsCountForUsersNSD = _detailsCountForUsersNSD, detailsForSelectedUserNSMA = _detailsForSelectedUserNSMA;
@synthesize detailMode = _detailMode, selectedUserIndex = _selectedUserIndex;
@synthesize userDetail = _userDetail;

-(UserDetailTableViewController*) userDetail{
    NSLog(@"Present: %@",self.parentViewController.parentViewController);
    return (UserDetailTableViewController*) [[[[(UISplitViewController*) self.parentViewController.parentViewController viewControllers] lastObject] viewControllers] lastObject];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) refreshUserInformation{
    //Load Users Information and store in array
        
    
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
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Update Information and register for change notifications
    [self refreshUserInformation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInformation) name:@"usersUpdated" object:nil];
    
    
    //Setup ViewController Switcher Toolbar
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Users",@"Sets", nil]];
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segControl.selectedSegmentIndex = 0;
    [segControl addTarget:self.navigationController action:@selector(switchViewController:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = [NSArray arrayWithObjects:flexibleSpace,[[UIBarButtonItem alloc] initWithCustomView:segControl],flexibleSpace, nil];
    
    
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


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        User *deleteUser = [self.listOfUsersNSMA objectAtIndex:indexPath.row];
        if ([self.userDetail.currentUser isEqual:deleteUser]) {
            self.userDetail.currentUser = nil;
        }
		//[usDAO deleteUserById:deleteUser.userId];
		[self.listOfUsersNSMA removeObjectAtIndex:indexPath.row];

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //Update Detail View controller with selected user
    self.userDetail.currentUser = [self.listOfUsersNSMA objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
