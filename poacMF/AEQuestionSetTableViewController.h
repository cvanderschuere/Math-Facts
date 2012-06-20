//
//  AEQuestionSetTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 20/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionSet.h"
#import "Administrator.h"





@interface AEQuestionSetTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) QuestionSet *questionSetToUpdate;
@property (nonatomic, strong) Administrator *administratorToCreateIn;

@end
