//
//  SetsTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdminSplitViewController.h"
#import "AdminMasterTableViewController.h"
#import "Administrator.h"

@interface SetsTableViewController : AdminMasterTableViewController

@property (nonatomic,strong) Administrator *currentAdmin;

@end
