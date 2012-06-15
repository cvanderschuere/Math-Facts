//
//  AddTestPopoverViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 13/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "AddTestPopoverViewController.h"

@interface AddTestPopoverViewController ()

@end

@implementation AddTestPopoverViewController

@synthesize questionSetsToChoose = _questionSetsToChoose;
@synthesize selectedQuestionSet = _selectedQuestionSet;
@synthesize questionSetPicker = _questionSetPicker;
@synthesize delegate = _delegate;
@synthesize minCorrectStepper = _minCorrectStepper, testLengthStepper = _testLengthStepper, minCorrectLabel = _minCorrectLabel, testLengthLabel = _testLengthLabel;
@synthesize passCriteriaSetting = _passCriteriaSetting, testLengthSetting = _testLengthSetting;
-(void) setQuestionSetsToChoose:(NSMutableArray *)questionSetsToChoose{
    _questionSetsToChoose = questionSetsToChoose;
    [self.questionSetPicker reloadAllComponents];
    if (_questionSetsToChoose.count>0) {
        self.selectedQuestionSet = [_questionSetsToChoose objectAtIndex:0];
    }
}

#pragma mark Picker Data Source Methods
-(NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView {
	return 1;
}//end method

-(NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component{
    return [self.questionSetsToChoose count];
}//end method

-(NSString *) pickerView: (UIPickerView *) pickerView titleForRow: (NSInteger) row forComponent: (NSInteger) component {
    QuestionSet* qSet = [self.questionSetsToChoose objectAtIndex:row];
    return qSet.name;
}//end method

#pragma mark Picker Delegate Methods
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.questionSetsToChoose.count>0) {
        self.selectedQuestionSet = [self.questionSetsToChoose objectAtIndex:row];  
    }
}//end method


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.contentSizeForViewInPopover = CGSizeMake(350, 350);
    
    //Update Stepper Labels
    if (self.testLengthSetting){
        self.testLengthStepper.value = self.testLengthSetting.doubleValue;
        [self stepperUpdated:self.testLengthStepper];
    }
    if (self.passCriteriaSetting) {
        self.minCorrectStepper.value = self.passCriteriaSetting.doubleValue;
        [self stepperUpdated:self.minCorrectStepper];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addTestPressed:(id)sender{
    if (self.questionSetsToChoose.count==0) {
        return;
    }
    [self.delegate didAddTestForQuestionSet:self.selectedQuestionSet minCorrect:self.minCorrectStepper.value length:self.testLengthStepper.value];
    [self.questionSetsToChoose removeObject:self.selectedQuestionSet];
    [self.questionSetPicker reloadComponent:0];
    self.selectedQuestionSet = self.questionSetsToChoose.count>0?[self.questionSetsToChoose objectAtIndex:0]:nil;
    [self.questionSetPicker selectRow:0 inComponent:0 animated:YES];
}
- (IBAction)stepperUpdated:(UIStepper*)sender{
    if ([sender isEqual:self.minCorrectStepper]) {
        self.minCorrectLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    }
    else {
        self.testLengthLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    }
}

@end
