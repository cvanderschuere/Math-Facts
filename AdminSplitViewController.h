//
//  AdminSplitViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Administrator.h"
#import "UsersTableViewController.h"
#import "SetsTableViewController.h"


@interface AdminSplitViewController : UISplitViewController <UISplitViewControllerDelegate, AdminSplitViewCommunicationDelegate>

@property (nonatomic, strong) Administrator* currentAdmin;

@end
