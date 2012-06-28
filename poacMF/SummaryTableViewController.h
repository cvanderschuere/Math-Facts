//
//  SummaryTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 28/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Test.h"
#import "Result.h"
#import "Administrator.h"
#import "CoreDataTableViewController.h"

@interface SummaryTableViewController : CoreDataTableViewController

@property (nonatomic, strong) Administrator *currentAdmin;
- (IBAction)done:(id)sender;

@end
