//
//  UserProgressViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface StudentMainViewController : UIViewController <UIActionSheetDelegate>


@property (nonatomic, strong) Student *currentStudent;


@end
