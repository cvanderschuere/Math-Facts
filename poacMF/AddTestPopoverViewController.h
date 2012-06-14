//
//  AddTestPopoverViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 13/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionSet.h"


@protocol AddTestDelegate <NSObject>

-(void) didAddTestForQuestionSet:(QuestionSet*)qSet minCorrect:(int) minCorrect length:(NSTimeInterval) length;
@end

@interface AddTestPopoverViewController : UIViewController

@property (nonatomic, weak) id<AddTestDelegate> delegate;
@property (nonatomic, strong) NSMutableArray* questionSetsToChoose;
@property (nonatomic, strong) QuestionSet *selectedQuestionSet;
@property (nonatomic, weak) IBOutlet UIPickerView *questionSetPicker;
@property (nonatomic, weak) IBOutlet UIStepper *minCorrectStepper;
@property (nonatomic, weak) IBOutlet UIStepper *testLengthStepper;
@property (nonatomic, weak) IBOutlet UILabel* minCorrectLabel;
@property (nonatomic, weak) IBOutlet UILabel* testLengthLabel;

- (IBAction)addTestPressed:(id)sender;
- (IBAction)stepperUpdated:(id)sender;


@end
