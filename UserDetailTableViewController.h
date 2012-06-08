//
//  UserDetailTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Student.h"


@interface UserDetailTableViewController : CoreDataTableViewController <UIPopoverControllerDelegate>

@property (nonatomic, strong) Student* student;
@property (nonatomic, strong) UIPopoverController *popover;


@end
