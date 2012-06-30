//
//  SelectCurrentTestTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 24/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Administrator.h"
#import "Student.h"

@protocol SelectTestProtocol <NSObject>

-(void) didSelectQuestionSet:(QuestionSet*)selectedQuestionSet;

@end


@interface SelectCurrentTestTableViewController : CoreDataTableViewController

@property (nonatomic, strong) Student *student;
@property (nonatomic, weak) id <SelectTestProtocol> delegate;

@end
