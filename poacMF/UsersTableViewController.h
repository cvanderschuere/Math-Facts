//
//  UsersTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Administrator.h"

@interface UsersTableViewController : CoreDataTableViewController

@property (nonatomic,strong) Administrator *currentAdmin;
@property (nonatomic, weak) id<AdminSplitViewCommunicationDelegate> delegate;


@end
