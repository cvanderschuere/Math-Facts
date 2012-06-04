//
//  UsersTableViewController.h
//  poacMF
//
//  Created by Matt Hunter on 3/24/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UsersTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate> {
	NSMutableArray			*listOfUsers;
	UIPopoverController		*userPopoverController;
	UITableView				*thisTableView;
    
}

@property (nonatomic, retain)				NSMutableArray			*listOfUsers;
@property (nonatomic, retain)				UIPopoverController		*userPopoverController;
@property (nonatomic, retain)	IBOutlet	UITableView				*thisTableView;

-(IBAction) setEditableTable;

@end
