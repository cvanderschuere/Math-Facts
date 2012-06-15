//
//  AEUserTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "Administrator.h"

@interface AEUserTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) Student* studentToUpdate;
@property (nonatomic, strong) Administrator* createdStudentsAdmin;
@end
