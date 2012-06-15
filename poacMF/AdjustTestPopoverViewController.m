//
//  AdjustTestPopoverViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 14/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "AdjustTestPopoverViewController.h"

@interface AdjustTestPopoverViewController ()

@end

@implementation AdjustTestPopoverViewController
@synthesize testToAdjust = _testToAdjust;
@synthesize passCriteriaStepper = _passCriteriaStepper;
@synthesize testLengthStepper = _testLengthStepper;
@synthesize passCriteriaLabel = _passCriteriaLabel;
@synthesize testLengthLabel = _testLengthLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.testLengthStepper.value = self.testToAdjust.testLength.doubleValue;
    self.passCriteriaStepper.value = self.testToAdjust.passCriteria.doubleValue;
    [self stepperValueChanged:self.testLengthStepper];
    [self stepperValueChanged:self.passCriteriaStepper];
    
}

- (void)viewDidUnload
{
    [self setPassCriteriaStepper:nil];
    [self setTestLengthStepper:nil];
    [self setPassCriteriaLabel:nil];
    [self setTestLengthLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)stepperValueChanged:(UIStepper*)sender {
    if ([sender isEqual:self.passCriteriaStepper]) {
        self.passCriteriaLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
        self.testToAdjust.passCriteria = [NSNumber numberWithDouble:sender.value];
    }
    else {
        self.testLengthLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
        self.testToAdjust.testLength = [NSNumber numberWithDouble:sender.value];
    }

}
@end
