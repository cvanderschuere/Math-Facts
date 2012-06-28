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
@synthesize maxIncorrectStepper = _maxIncorrectStepper;
@synthesize passCriteriaLabel = _passCriteriaLabel;
@synthesize testLengthLabel = _testLengthLabel;
@synthesize maxIncorrectLabel = _maxIncorrectLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.testLengthStepper.value = self.testToAdjust.testLength.doubleValue;
    self.passCriteriaStepper.value = self.testToAdjust.passCriteria.doubleValue;
    self.maxIncorrectStepper.value = self.testToAdjust.maximumIncorrect.doubleValue;
    [self stepperValueChanged:self.testLengthStepper];
    [self stepperValueChanged:self.passCriteriaStepper];
    [self stepperValueChanged:self.maxIncorrectStepper];
}

- (void)viewDidUnload
{
    [self setPassCriteriaStepper:nil];
    [self setTestLengthStepper:nil];
    [self setPassCriteriaLabel:nil];
    [self setTestLengthLabel:nil];
    [self setMaxIncorrectStepper:nil];
    [self setMaxIncorrectLabel:nil];
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
    else if([sender isEqual:self.testLengthStepper]) {
        self.testLengthLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
        self.testToAdjust.testLength = [NSNumber numberWithDouble:sender.value];
    }
    else if([sender isEqual:self.maxIncorrectStepper]) {
        self.maxIncorrectLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
        self.testToAdjust.maximumIncorrect = [NSNumber numberWithDouble:sender.value];
    }

}
@end
