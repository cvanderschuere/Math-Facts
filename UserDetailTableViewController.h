//
//  UserDetailTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"
#import "SelectCurrentTestTableViewController.h"
#import "Student.h"


@interface UserDetailTableViewController : CoreDataViewController <UIPopoverControllerDelegate,SelectTestProtocol,CPTPlotDataSource,CPTPlotSpaceDelegate,CPTScatterPlotDelegate>

@property (nonatomic, strong) Student* student;
@property (nonatomic, strong) UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (strong, nonatomic) UIBarButtonItem *revealMasterButton;
@property (nonatomic, weak) IBOutlet CPTGraphHostingView *graphView;


- (IBAction)selectCurrentTest:(id)sender;

@end
