//
//  UserProgressViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoacMFAppDelegate.h"
#import "User.h"

@interface UserProgressViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UITableView *quizTableView;
@property (nonatomic, weak) IBOutlet UITableView *testTableView;

@property (nonatomic, strong) User *currentUser;
- (IBAction)sliderChanged:(id)sender;

@end
