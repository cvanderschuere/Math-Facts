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
	
}

@property (nonatomic, strong) IBOutlet	UsersViewController				*usersVC;
@property (nonatomic, strong) IBOutlet	QuestionSetsViewController		*questionSetsVC;
@property (nonatomic, strong) IBOutlet	ResultsViewController			*resultsVC;
@property (nonatomic, strong) IBOutlet	UIView							*studentView;
@property (nonatomic, strong) IBOutlet	UIView							*questionsView;
@property BOOL usersViewable;
@property BOOL questionSetsViewable;


-(IBAction) logOut: (id) sender;
-(IBAction) showUsers;
-(IBAction) showQuestionSets;

@end
