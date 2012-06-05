//
//  AdminViewController.h
//  poacMF
//
//  Created by Matt Hunter on 3/19/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POACDetailViewController.h"
#import "UsersViewController.h"
#import "QuestionSetsViewController.h"
#import "ResultsViewController.h"

@interface AdminViewController : POACDetailViewController <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate> {
	
}

@property (nonatomic, strong) IBOutlet	UsersViewController				*usersVC;
@property (nonatomic, strong) IBOutlet	QuestionSetsViewController		*questionSetsVC;
@property (nonatomic, strong) IBOutlet	ResultsViewController			*resultsVC;
@property (nonatomic, strong) IBOutlet	UIView							*studentView;
@property (nonatomic, strong) IBOutlet	UIView							*questionsView;
@property BOOL usersViewable;
@property BOOL questionSetsViewable;

//ResultsView Properties
@property (weak, nonatomic) IBOutlet	UITableView				*thisTableView;
@property (strong, nonatomic)			NSMutableArray			*listOfUsersNSMA;
@property (strong, nonatomic)			NSMutableArray			*listOfResultsNSMA;
@property (strong, nonatomic)			NSDictionary			*detailsCountForUsersNSD;
@property (strong, nonatomic)			NSMutableArray			*detailsForSelectedUserNSMA;
@property (nonatomic)					BOOL					detailMode;
@property (nonatomic)					int						selectedUserIndex;


-(IBAction) logOut: (id) sender;
-(IBAction) showUsers;
-(IBAction) showQuestionSets;

@end
