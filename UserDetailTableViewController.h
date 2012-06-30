//
//  UserDetailTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "SelectCurrentTestTableViewController.h"
#import "Student.h"


@interface UserDetailTableViewController : CoreDataTableViewController <UIPopoverControllerDelegate,SelectTestProtocol>

@property (nonatomic, strong) Student* student;
@property (nonatomic, strong) UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

- (IBAction)selectCurrentTest:(id)sender;

@end
