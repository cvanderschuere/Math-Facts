//
//  UsersTableViewController.m
//  poacMF
//
//  Created by Matt Hunter on 3/24/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "UsersTableViewController.h"
#import "UsersDAO.h"
#import "User.h"
#import "AppConstants.h"
#import "AEUserViewController.h"

@implementation UsersTableViewController

@synthesize  listOfUsers, userPopoverController, thisTableView;

int TABLE_WIDTH = 300;
int TABLE_HEIGHT = 400;

- (void)dealloc {
	[listOfUsers release];
	if (nil != userPopoverController)
		[userPopoverController release];
	[thisTableView release];
    [super dealloc];
}//end method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}//end method

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UsersDAO *uDAO = [[UsersDAO alloc] init];
	self.listOfUsers = [uDAO getAllUsers];
	[uDAO release];

	if (nil == self.listOfUsers)
		self.listOfUsers = [NSMutableArray array];
	
}//end method

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
NSLog(@"UsersTableVC.viewWillAppear");
	
}//end method

-(IBAction) setEditableTable {
	if (thisTableView.editing)
		[self.thisTableView setEditing:NO animated:YES];
	else
		[self.thisTableView setEditing: YES animated:YES]; 
	[thisTableView reloadData];
}//end method


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}//end method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = 0;
	if (nil != listOfUsers)
		count = [listOfUsers count];
	if (thisTableView.editing)
		count++;
    return count;
}//end method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

	int adjustedRow=0;
	if (thisTableView.editing) 
		adjustedRow = indexPath.row - 1;
	else
		adjustedRow = indexPath.row;

	// Configure the cell...
	if ((0 == indexPath.row) && (thisTableView.editing)) {
		cell.textLabel.text = @"Add User";
		cell.textLabel.textColor = [UIColor blueColor];
	} else {	
		User *u = [listOfUsers objectAtIndex:adjustedRow];
		NSString *name = [u.firstName stringByAppendingString:@" "];
		name = [name stringByAppendingString:u.lastName];
		cell.textLabel.text = name;
		cell.textLabel.textColor = [UIColor blackColor];
		if (u.userType == ADMIN_USER_TYPE)
			cell.detailTextLabel.text = @"Administrator";
		else
			cell.detailTextLabel.text = @"Student";
	}//end if-else
	
    return cell;
}//end method

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.thisTableView.editing == NO) return UITableViewCellEditingStyleNone;
	if (self.thisTableView.editing && (indexPath.row == 0))
		return UITableViewCellEditingStyleInsert;
    else
		return UITableViewCellEditingStyleDelete;
	
    return UITableViewCellEditingStyleNone;
}//end method

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		if (0 != indexPath.row) {
			int adjustedRowIndex = indexPath.row - 1;
			User *deleteUser = [listOfUsers objectAtIndex:adjustedRowIndex];
			UsersDAO *usDAO = [[UsersDAO alloc] init];
			[usDAO deleteUserById:deleteUser.userId];
			[usDAO release];
			[listOfUsers removeObjectAtIndex:adjustedRowIndex];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
		}//end if 
	}//end if
    if (editingStyle == UITableViewCellEditingStyleInsert) {
		//create the popver
		AEUserViewController *tpc = [[AEUserViewController alloc] initWithNibName:AEUSER_NIB bundle:nil];
		tpc.view.backgroundColor = [UIColor blackColor];
		tpc.contentSizeForViewInPopover = CGSizeMake(TABLE_WIDTH,TABLE_HEIGHT);
		self.userPopoverController = [[UIPopoverController alloc] initWithContentViewController:tpc];
		[tpc release];
		
		//grab the actual TableViewCell to Pop from
		NSIndexPath *nsip = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
		UITableViewCell *selectedCell = [self.thisTableView cellForRowAtIndexPath:nsip];
		
		//Pop the popover
		[self.userPopoverController presentPopoverFromRect:selectedCell.frame inView:selectedCell 
				permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    } //end if-else
}//end method

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[thisTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	User *updateUser = [listOfUsers objectAtIndex:indexPath.row];
	
	//create the popver
	AEUserViewController *tpc = [[AEUserViewController alloc] initWithNibName:AEUSER_NIB bundle:nil];
	tpc.editMode = TRUE; 
	tpc.updateUser = updateUser;
	tpc.view.backgroundColor = [UIColor blackColor];
	tpc.contentSizeForViewInPopover = CGSizeMake(TABLE_WIDTH,TABLE_HEIGHT);
	self.userPopoverController = [[UIPopoverController alloc] initWithContentViewController:tpc];
	[tpc release];
	
	//grab the actual TableViewCell to Pop from
	NSIndexPath *nsip = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
	UITableViewCell *selectedCell = [self.thisTableView cellForRowAtIndexPath:nsip];
	
	//Pop the popover
	[self.userPopoverController presentPopoverFromRect:selectedCell.frame inView:selectedCell 
			permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}//end method

@end
