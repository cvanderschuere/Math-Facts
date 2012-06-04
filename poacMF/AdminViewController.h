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

@interface AdminViewController : POACDetailViewController <UIActionSheetDelegate> {
	UsersViewController				*usersVC;
	QuestionSetsViewController		*questionSetsVC;
	ResultsViewController			*resultsVC;
	BOOL							usersViewable;
	BOOL							questionSetsViewable;
	
}

@property (nonatomic, retain) IBOutlet	UsersViewController				*usersVC;
@property (nonatomic, retain) IBOutlet	QuestionSetsViewController		*questionSetsVC;
@property (nonatomic, retain) IBOutlet	ResultsViewController			*resultsVC;
@property (nonatomic, retain) IBOutlet	UIView							*studentView;
@property (nonatomic, retain) IBOutlet	UIView							*questionsView;
@property BOOL usersViewable;
@property BOOL questionSetsViewable;


-(IBAction) logOut: (id) sender;
-(IBAction) showUsers;
-(IBAction) showQuestionSets;

@end
