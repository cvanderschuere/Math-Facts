//
//  AssignQuizPopoverViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "AssignQuizPopoverViewController.h"
#import "User.h"
#import "QuestionSetsDAO.h"
#import "QuestionSet.h"
#import "AppLibrary.h"
#import "Quiz.h"
#import "QuizzesDAO.h"
#import "AppConstants.h"

@interface AssignQuizPopoverViewController ()

@end

@implementation AssignQuizPopoverViewController
@synthesize numberCorrectStepper = _numberCorrectStepper;
@synthesize numberIncorrectStepper = _numberIncorrectStepper;
@synthesize quizPicker = _quizPicker;
@synthesize correctLabel = _correctLabel;
@synthesize incorrectLabel = _incorrectLabel;
@synthesize assignedQuiz = _assignedQuiz, testType = _testType, updateMode = _updateMode, selectedSet = _selectedSet;
@synthesize listofQuestionSets = _listofQuestionSets;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(400, 350);
    
    //load the Quiz Sets
	QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	self.listofQuestionSets = [qsDAO getAllSets];
	
	if (nil == self.listofQuestionSets)
		self.listofQuestionSets = [NSMutableArray array];
    
	// Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated{
    if (QUIZ_PRACTICE_TYPE == self.testType)
		self.title = @"Assign Practice";
	else
		self.title = @"Assign Time";
    
    //Populate UI
    [self.quizPicker reloadAllComponents];
    self.selectedSet = -1;
    if (nil != self.assignedQuiz){		
		NSNumber *nsn = [NSNumber numberWithInt:self.assignedQuiz.requiredCorrect];
		self.correctLabel.text = [nsn stringValue];
        
		nsn = [NSNumber numberWithInt:self.assignedQuiz.allowedIncorrect];
		self.incorrectLabel.text = [nsn stringValue];
				
		self.testType = self.assignedQuiz.testType;
        
        int index = [[self.listofQuestionSets indexesOfObjectsPassingTest:^BOOL(Quiz *obj, NSUInteger idx, BOOL *stop){
            if (obj.setId == self.assignedQuiz.setId) {
                *stop = YES;
                return YES;
            }
            return NO;
        }]lastIndex];
        self.selectedSet = index;
        [self.quizPicker selectRow:index inComponent:0 animated:NO];
	}//end method

}

- (void)viewDidUnload
{
    [self setQuizPicker:nil];
    [self setCorrectLabel:nil];
    [self setIncorrectLabel:nil];
    [self setNumberCorrectStepper:nil];
    [self setNumberIncorrectStepper:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
#pragma mark Picker Data Source Methods
-(NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView {
	return 1;
}//end method

-(NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component{
    return [self.listofQuestionSets count];
}//end method

-(NSString *) pickerView: (UIPickerView *) pickerView titleForRow: (NSInteger) row forComponent: (NSInteger) component {
	NSString *returnString = @"";
    if (nil != self.listofQuestionSets){
        AppLibrary *al = [[AppLibrary alloc] init];
        QuestionSet *qs = [self.listofQuestionSets objectAtIndex:row];
        NSString *backend = nil;//[NSString stringWithFormat:@" - %i questions", [qs.setDetailsNSMA count]];
        NSString *frontend = nil;//[[al interpretMathTypeAsPhrase:qs.mathType] stringByAppendingString:qs.questionSetName];
        returnString = [frontend stringByAppendingString:backend];
        return returnString;					  
    }//end if
	return returnString;
}//end method

#pragma mark Picker Delegate Methods
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return self.view.frame.size.width;
}//end method

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
		if (nil != self.listofQuestionSets){
			QuestionSet *qs = [self.listofQuestionSets objectAtIndex:row];
            self.selectedSet = row;
		}//end if
    
}//end method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)stepperValueChanged:(UIStepper*)sender {
    if ([sender isEqual:self.numberCorrectStepper]) {
        self.correctLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    }
    else if ([sender isEqual:self.numberIncorrectStepper]) {
        self.incorrectLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    }
}
@end
