//
//  UsersTableViewController.h
//  poacMF
//
//  Created by Matt Hunter on 3/24/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UsersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate> {
	NSMutableArray			*listOfUsers;
	UITableView				*thisTableView;
    
}

@property (nonatomic, retain)				NSMutableArray			*listOfUsers;
@property (nonatomic, retain)	IBOutlet	UITableView				*thisTableView;

-(IBAction) setEditableTable;
-(IBAction)	userTableEditingTapped;
-(IBAction)	assignQuizTapped;
-(IBAction)	assignTestTapped;
-(IBAction) addUser: (id) sender;
-(void)		quizButtonClicked: (id) sender;

@end
