//
//  UserDetailTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@interface UserDetailTableViewController : UITableViewController <UIPopoverControllerDelegate>

@property (nonatomic, strong) User* currentUser;
@property (nonatomic, strong) UIPopoverController *popover;


@end
