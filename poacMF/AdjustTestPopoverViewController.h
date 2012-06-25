//
//  AdjustTestPopoverViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 14/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Test.h"

@interface AdjustTestPopoverViewController : UITableViewController

@property (strong, nonatomic) Test *testToAdjust;

@property (weak, nonatomic) IBOutlet UIStepper *passCriteriaStepper;
@property (weak, nonatomic) IBOutlet UIStepper *testLengthStepper;
@property (weak, nonatomic) IBOutlet UILabel *passCriteriaLabel;
@property (weak, nonatomic) IBOutlet UILabel *testLengthLabel;


- (IBAction)stepperValueChanged:(id)sender;

@end
