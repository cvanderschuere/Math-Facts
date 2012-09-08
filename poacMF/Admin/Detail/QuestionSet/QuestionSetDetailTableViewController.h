//
//  QuestionSetDetailTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "QuestionSet.h"

@interface QuestionSetDetailTableViewController : CoreDataTableViewController

@property (nonatomic, strong) QuestionSet *questionSet;
@property (nonatomic, strong) UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) UIBarButtonItem *revealMasterButton;

@end
