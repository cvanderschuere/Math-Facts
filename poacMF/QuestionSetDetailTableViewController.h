//
//  QuestionSetDetailTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "QuestionSet.h"

@interface QuestionSetDetailTableViewController : CoreDataTableViewController

@property (nonatomic, strong) QuestionSet *questionSet;

@end
