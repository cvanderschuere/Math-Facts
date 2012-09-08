//
//  SummaryTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 28/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Test.h"
#import "Result.h"
#import "Course.h"
#import "CoreDataTableViewController.h"
#import <MessageUI/MessageUI.h>


@interface SummaryTableViewController : CoreDataTableViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) Course *currentCourse;
- (IBAction)done:(id)sender;
- (IBAction)backup:(UIBarButtonItem*)sender;

@end
