//
//  AssignQuizPopoverViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"

@interface AssignQuizPopoverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *quizPicker;
@property (weak, nonatomic) IBOutlet UILabel *correctLabel;
@property (weak, nonatomic) IBOutlet UILabel *incorrectLabel;
@property (nonatomic, strong) NSArray* listofQuestionSets;


@property (strong, nonatomic) Quiz *assignedQuiz;
@property (nonatomic) int testType;
@property (nonatomic) BOOL updateMode;
@property (nonatomic) int selectedSet;
@property (weak, nonatomic) IBOutlet UIStepper *numberCorrectStepper;
@property (weak, nonatomic) IBOutlet UIStepper *numberIncorrectStepper;

- (IBAction)stepperValueChanged:(id)sender;

@end
