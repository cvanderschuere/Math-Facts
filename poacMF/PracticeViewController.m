//
//  TestViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 11/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "PracticeViewController.h"
#import "QuestionSet.h"
#import "Question.h"
#import "Result.h"
#import "PoacMFAppDelegate.h"
#import "Test.h"
#import "TestViewController.h"
#import "NSMutableArray+Shuffling.h"

#define RETAKE_REPITITION 3
#define ANSWER_ANIMATION_HALF_LENGTH .4

//1 in # new vs old
#define NEW_OLD_QUESTION_RATIO 3


@interface PracticeViewController ()

@property (nonatomic, strong) Result* result;
@property (nonatomic, strong) NSTimer* updateTimer;
@property (nonatomic, strong) UIActionSheet *quitSheet;

@property (nonatomic) BOOL currentQuestionIsRetake;
@property (nonatomic) BOOL questionsNeedShuffle;
@property (nonatomic) int questionsBeforeRetake;
@property (nonatomic, strong) NSMutableArray *oldQuestions;
@property (nonatomic, strong) NSMutableArray *errorQueue;

@end

@implementation PracticeViewController
@synthesize questionsLabel = _questionsLabel;
@synthesize timeLabel = _timeLabel;
@synthesize xLabel = _xLabel;
@synthesize yLabel = _yLabel;
@synthesize zLabel = _zLabel;
@synthesize mathOperatorSymbol = _mathOperatorSymbol;
@synthesize horizontalLine = _horizontalLine;
@synthesize verticalLine = _verticalLine;
@synthesize numberCorrectLabel = _numberCorrectLabel;
@synthesize numberIncorrectLabel = _numberIncorrectLabel;
@synthesize correctStar = _correctStar;
@synthesize incorrectImage = _incorrectImage;
@synthesize nextButton = _nextButton;
@synthesize instructionLabel = _instructionLabel;

@synthesize practice = _practice, questionsToAsk = _questionsToAsk, result = _result;
@synthesize updateTimer = _updateTimer;
@synthesize delegate = _delegate;
@synthesize quitSheet = _quitSheet;

@synthesize currentQuestionIsRetake = _currentQuestionIsRetake, questionsBeforeRetake = _questionsBeforeRetake, errorQueue = _errorQueue,questionsNeedShuffle = _questionsNeedShuffle, oldQuestions = _oldQuestions;

-(void) setPractice:(Practice *)practice{
    if (![_practice isEqual:practice]) {
        _questionsToAsk = nil;
        _practice = practice;
        
        //Set title label
        self.title = [_practice.test.student.username stringByAppendingString:[NSString stringWithFormat:@": %@",_practice.test.questionSet.name]];
        
        //Reload Questions to ask
        NSFetchRequest *previousQuestionSet = [NSFetchRequest fetchRequestWithEntityName:@"QuestionSet"];
        previousQuestionSet.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"difficultyLevel" ascending:YES]];
        previousQuestionSet.predicate = [NSPredicate predicateWithFormat:@"difficultyLevel < %@ AND type == %@",_practice.test.questionSet.difficultyLevel,_practice.test.questionSet.type];
        NSMutableArray *sets = [_practice.managedObjectContext executeFetchRequest:previousQuestionSet error:NULL].mutableCopy;
        
        //Cummalate old questions
        self.oldQuestions = [NSMutableArray array];
        for (QuestionSet* set in sets) {
            [self.oldQuestions addObjectsFromArray:set.questions.allObjects];
        }
        
        //Shuffle old questions
        [self.oldQuestions shuffleArray];
        self.questionsNeedShuffle = NO;
        
        NSMutableArray* newQuestions = practice.test.questionSet.questions.allObjects.mutableCopy;
        [newQuestions shuffleArray];
        
        self.questionsToAsk = [NSMutableArray array];
        
        while (newQuestions.count>0) {
            if (self.questionsToAsk.count%(NEW_OLD_QUESTION_RATIO)==0 || self.oldQuestions.count == 0) {
                //Add new question every third question
                [self.questionsToAsk addObject:newQuestions.lastObject];
                [newQuestions removeLastObject];
            }
            else {
                //Add old question in random order
                Question *oldQuestion = [self.oldQuestions objectAtIndex:arc4random()%self.oldQuestions.count];
                
                [self.questionsToAsk addObject:oldQuestion];
                
                //Remove old question so its not asked again
                [self.oldQuestions removeObject:oldQuestion];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Disable back button
    self.navigationItem.hidesBackButton = YES;
    
    //Set inital data
    self.nextButton.alpha = 0;
    self.instructionLabel.text = nil;
    self.currentQuestionIsRetake = NO;
    self.questionsBeforeRetake = -1;
    self.errorQueue = [NSMutableArray array];
        
    //Setup for question type
    if (self.practice.test.questionSet.type.intValue == QUESTION_TYPE_MATH_DIVISION) {
        //Setup for divsion symbol
        //Setup for vertical problem
        self.xLabel.frame = CGRectMake(318, 212, 132, 62);
        self.yLabel.frame = CGRectMake(151, 208, 132, 66);
        self.zLabel.frame = CGRectMake(318, 93, 132,68);
        self.horizontalLine.hidden = YES; //.frame = CGRectMake(258, 164, 252,19);
        
        self.verticalLine.hidden = NO;
        self.mathOperatorSymbol.hidden = YES;
        
    }
    else {
        //Setup for vertical problem
        self.xLabel.center = CGPointMake(385, 162);
        self.yLabel.center = CGPointMake(385, 228);
        self.zLabel.center = CGPointMake(385, 328);
        self.horizontalLine.hidden = NO;
        self.horizontalLine.center = CGPointMake(385, 276);
        
        self.verticalLine.hidden = YES;
        self.mathOperatorSymbol.hidden = NO;
        switch (self.practice.test.questionSet.type.intValue) {
            case QUESTION_TYPE_MATH_ADDITION:
                self.mathOperatorSymbol.text = @"+";
                break;
            case QUESTION_TYPE_MATH_SUBTRACTION:
                self.mathOperatorSymbol.text = @"-";
                break;
            case QUESTION_TYPE_MATH_MULTIPLICATION:
                self.mathOperatorSymbol.text = @"X";
                break;
            default:
                break;
        }        
    }
    
    //Clear labels
    self.xLabel.text = self.yLabel.text = self.zLabel.text = self.timeLabel.text = self.numberCorrectLabel.text = self.numberIncorrectLabel.text = nil;
}

-(void) viewDidAppear:(BOOL)animated{    
    //Alert to start test        
    UIActionSheet *startTestSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Quit" otherButtonTitles:@"Start", nil];
    [startTestSheet showInView:self.view];

}
-(void) viewWillDisappear:(BOOL)animated{
    [self.quitSheet dismissWithClickedButtonIndex:-1 animated:animated];
}
- (void)viewDidUnload
{
    [self setQuestionsLabel:nil];
    [self setTimeLabel:nil];
    [self setXLabel:nil];
    [self setYLabel:nil];
    [self setZLabel:nil];
    [self setMathOperatorSymbol:nil];
    [self setHorizontalLine:nil];
    [self setVerticalLine:nil];
    [self setNumberCorrectLabel:nil];
    [self setNumberIncorrectLabel:nil];
    [self setNextButton:nil];
    [self setCorrectStar:nil];
    [self setIncorrectImage:nil];
    [self setInstructionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Storyboard
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"startTestFromPractice"]){
        [segue.destinationViewController setDelegate:self.delegate];
        [segue.destinationViewController setTest:self.practice.test];
    }
}
#pragma mark - Test Flow Methods
-(void) startTest{
    //Create Result and set values
    self.result = [NSEntityDescription insertNewObjectForEntityForName:@"Result" inManagedObjectContext:self.practice.managedObjectContext];
    [self.practice addResultsObject:self.result];
    self.result.student = self.practice.test.student;
    self.result.isPractice = [NSNumber numberWithBool:YES];
    self.result.startDate = [NSDate date];
    self.result.endDate = [self.result.startDate dateByAddingTimeInterval:self.practice.test.student.defaultPracticeLength.intValue];

    //Setup timer
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    //Load first question
    [self prepareForQuestion:[self.questionsToAsk lastObject]];
}
-(void) updateTime{
    //Find the time interval remains by comparing start and end date
    NSTimeInterval interval = [self.result.endDate timeIntervalSinceNow];
    if (interval<=0) {
        //Test has finished
        [self endSessionWithTimer:YES];
    }
    else {
        //Update time label with seconds remaining
        self.timeLabel.text = [NSString stringWithFormat:@"%d s",(int)round(interval)];
    }
}
-(void) shuffleQuestions{
    //Filter out all old questions
    NSMutableArray *arrayOfNewQuestions = [self.questionsToAsk filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"questionSet.difficultyLevel = %@",self.practice.test.questionSet.difficultyLevel]].mutableCopy;
    
    int numberToAdd = self.questionsToAsk.count - arrayOfNewQuestions.count;
    
    //Check: Not enough old questions to refill array
    if (self.oldQuestions.count < numberToAdd) {
        //Reload all previous questions
        NSFetchRequest *previousQuestionSet = [NSFetchRequest fetchRequestWithEntityName:@"QuestionSet"];
        previousQuestionSet.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"difficultyLevel" ascending:YES]];
        previousQuestionSet.predicate = [NSPredicate predicateWithFormat:@"difficultyLevel < %@ AND type == %@",_practice.test.questionSet.difficultyLevel,_practice.test.questionSet.type];
        NSMutableArray *sets = [_practice.managedObjectContext executeFetchRequest:previousQuestionSet error:NULL].mutableCopy;
        
        //Cummalate old questions
        self.oldQuestions = [NSMutableArray array];
        for (QuestionSet* set in sets) {
            [self.oldQuestions addObjectsFromArray:set.questions.allObjects];
        }
        [self.oldQuestions shuffleArray];
    }
    
    for (int numberAdded = 0; numberAdded < numberToAdd; numberAdded++) {
        //Add questions from oldQuestions at random
        Question *oldQuestion = [self.oldQuestions objectAtIndex:arc4random()%self.oldQuestions.count];
        [arrayOfNewQuestions addObject:oldQuestion];
        
        //Remove old question so its not asked again
        [self.oldQuestions removeObject:oldQuestion];
    }
    
    self.questionsToAsk = arrayOfNewQuestions;
    //Shuffle for good measure
    [self.questionsToAsk shuffleArray];
    
}
-(void) loadNextQuestion{
    //Disable instruction
    self.nextButton.layer.opacity = 0;
    self.instructionLabel.text = nil;
    Question* previousQuestion = self.questionsToAsk.lastObject;

    if(self.currentQuestionIsRetake){
        [self prepareForQuestion:[self.questionsToAsk lastObject]];   //Load last question again
    }
    
    //Normal Question loading    
    else if (self.questionsToAsk.count>0) {
        //Check if error question
        if ([self.errorQueue.lastObject isEqual:self.questionsToAsk.lastObject]) {
            [self.errorQueue removeLastObject];
            [self.questionsToAsk removeLastObject];
        }
        else {
            //Insert old question in front of array
            [self.questionsToAsk insertObject:[self.questionsToAsk lastObject] atIndex:0];
            [self.questionsToAsk removeLastObject];

        }
        
        //If gone through entire array...shuffle
        if (((self.result.correctResponses.count + self.result.incorrectResponses.count) % self.questionsToAsk.count == 0 )|| self.questionsNeedShuffle){
            if (self.errorQueue.count>0) {
                //Cant shuffle now, shuffle when error array empty
                self.questionsNeedShuffle = YES;
            }
            else{
                [self shuffleQuestions];
                self.questionsNeedShuffle = NO;
            }
        }
        
        //Load new first question: check for duplicate question
        if ([previousQuestion.objectID isEqual:[self.questionsToAsk.lastObject objectID]]) {
            //Skip to next question
            [self.questionsToAsk insertObject:previousQuestion atIndex:0];
            [self.questionsToAsk removeLastObject];
            [self prepareForQuestion:[self.questionsToAsk lastObject]];
        }
        else{
            [self prepareForQuestion:[self.questionsToAsk lastObject]];
        }

    }
}
-(void) prepareForQuestion:(Question*)question{
    if (question) {
        NSLog(@"Question from Question set: %@",question.questionSet.difficultyLevel.stringValue);
        
        //Setup text
        self.xLabel.text = question.x?[NSNumberFormatter localizedStringFromNumber:question.x numberStyle:NSNumberFormatterBehavior10_4]:nil;
        self.yLabel.text = question.y?[NSNumberFormatter localizedStringFromNumber:question.y numberStyle:NSNumberFormatterBehavior10_4]:nil;
        self.zLabel.text = question.z?[NSNumberFormatter localizedStringFromNumber:question.z numberStyle:NSNumberFormatterBehavior10_4]:nil;
        //Setup Format
        self.xLabel.backgroundColor = question.x?[UIColor clearColor]:[UIColor lightGrayColor];
        self.yLabel.backgroundColor = question.y?[UIColor clearColor]:[UIColor lightGrayColor];
        self.zLabel.backgroundColor = question.z?[UIColor clearColor]:[UIColor lightGrayColor];
    }
}
-(NSNumber*) getAnswerForQuestion:(Question*)question{
    NSNumber * answer = nil;
    
    //Case 1: a ? b = v
    if (!question.z) {
        switch (self.practice.test.questionSet.type.intValue) {
            case QUESTION_TYPE_MATH_ADDITION:
                answer = [NSNumber numberWithInt:question.x.intValue + question.y.intValue];
                break;
            case QUESTION_TYPE_MATH_SUBTRACTION:
                answer = [NSNumber numberWithInt:question.x.intValue - question.y.intValue];
                break;
            case QUESTION_TYPE_MATH_MULTIPLICATION:
                answer = [NSNumber numberWithInt:question.x.intValue * question.y.intValue];
                break;
            case QUESTION_TYPE_MATH_DIVISION:
                answer = [NSNumber numberWithInt:question.x.intValue / question.y.intValue];
                break;
            default:
                
                break;
        }
    }
    //Case 2: a ? v = c
    else if (!question.y) {
        switch (self.practice.test.questionSet.type.intValue) {
            case QUESTION_TYPE_MATH_ADDITION:
                answer = [NSNumber numberWithInt:question.z.intValue - question.x.intValue];
                break;
            case QUESTION_TYPE_MATH_SUBTRACTION:
                answer = [NSNumber numberWithInt:question.x.intValue - question.z.intValue];
                break;
            case QUESTION_TYPE_MATH_MULTIPLICATION:
                answer = [NSNumber numberWithInt:question.z.intValue / question.x.intValue];
                break;
            case QUESTION_TYPE_MATH_DIVISION:
                answer = [NSNumber numberWithInt:question.x.intValue / question.z.intValue];
                break;
            default:
                //Unknown Type
                break;
        }

    }
    //Case 3: v ? b = c
    else if (!question.x) {
        switch (self.practice.test.questionSet.type.intValue) {
            case QUESTION_TYPE_MATH_ADDITION:
                answer = [NSNumber numberWithInt:question.z.intValue - question.y.intValue];
                break;
            case QUESTION_TYPE_MATH_SUBTRACTION:
                answer = [NSNumber numberWithInt:question.z.intValue + question.y.intValue];
                break;
            case QUESTION_TYPE_MATH_MULTIPLICATION:
                answer = [NSNumber numberWithInt:question.z.intValue / question.y.intValue];
                break;
            case QUESTION_TYPE_MATH_DIVISION:
                answer = [NSNumber numberWithInt:question.z.intValue * question.y.intValue];
                break;
            default:
                //Unknown Type
                break;
        }

    }
    return answer;
}
-(void) evaluateGivenAnswer:(NSString*)givenAnswer withActualAnswer:(NSNumber*)actualAnswer{
    //Convert to string
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterBehavior10_4;
    NSNumber * answer = [formatter numberFromString:givenAnswer];
    
    if ([answer compare:actualAnswer] == NSOrderedSame) {
        //Create Response
        Response *correctResponse = [NSEntityDescription insertNewObjectForEntityForName:@"Response" inManagedObjectContext:self.result.managedObjectContext];
        correctResponse.question = [self.questionsToAsk lastObject];
        correctResponse.answer = givenAnswer;
        correctResponse.index = [NSNumber numberWithInt:self.result.correctResponses.count + self.result.incorrectResponses.count];
        [self.result addCorrectResponsesObject:correctResponse];
        
        //Animate Correct star
        [UIView animateWithDuration:ANSWER_ANIMATION_HALF_LENGTH animations:^{
            //Scale large
            self.correctStar.transform = CGAffineTransformMakeScale(1.8, 1.8);
        }completion:^(BOOL finished){
            [UIView animateWithDuration:ANSWER_ANIMATION_HALF_LENGTH
                             animations:^{
                                 //Scale back
                                 self.correctStar.transform = CGAffineTransformIdentity;
                             }];
        }];
        
        if (self.currentQuestionIsRetake)
            self.currentQuestionIsRetake = NO;
        
    }
    else {
        //Incorrect Answer
        Response *incorrectResponse = [NSEntityDescription insertNewObjectForEntityForName:@"Response" inManagedObjectContext:self.result.managedObjectContext];
        incorrectResponse.question = [self.questionsToAsk lastObject];
        incorrectResponse.answer = givenAnswer;
        incorrectResponse.index = [NSNumber numberWithInt:self.result.correctResponses.count + self.result.incorrectResponses.count];
        [self.result addIncorrectResponsesObject:incorrectResponse];
        
        //Instruct about actual answer
            //Determine label with answer
        
        self.instructionLabel.text = [@"Incorrect. The correct answer was " stringByAppendingString:actualAnswer.stringValue];
        
        //Animate Incorrect image
        [UIView animateWithDuration:ANSWER_ANIMATION_HALF_LENGTH animations:^{
            //Scale large
            self.incorrectImage.transform = CGAffineTransformMakeScale(1.8, 1.8);
            }completion:^(BOOL finished){
                [UIView animateWithDuration:ANSWER_ANIMATION_HALF_LENGTH
                                 animations:^{
                                     //Scale back
                                     self.incorrectImage.transform = CGAffineTransformIdentity;
                                 }];
        }];
            
        if (self.currentQuestionIsRetake) {
            //Repeat current retake
        }
        else {
            //Manage error retake
            [self.errorQueue insertObject:self.questionsToAsk.lastObject atIndex:0]; //Add to front of array
            [self.errorQueue insertObject:self.questionsToAsk.lastObject atIndex:0]; //Add to front of array
            [self.errorQueue insertObject:self.questionsToAsk.lastObject atIndex:0]; //Add to front of array

            //Check if questions array is large enough
            while (self.questionsToAsk.count < self.practice.test.student.numberOfDistractionQuestions.intValue * RETAKE_REPITITION) {
                [self.questionsToAsk addObjectsFromArray:self.questionsToAsk]; //Double size
            }
            
            //Add retake questions
            for (int i = 1; i<=RETAKE_REPITITION; i++) {
                [self.questionsToAsk insertObject:self.questionsToAsk.lastObject atIndex:self.questionsToAsk.count - self.practice.test.student.numberOfDistractionQuestions.intValue * i];
            }

            self.currentQuestionIsRetake = YES;
        }

    }
    self.numberCorrectLabel.text = [NSString stringWithFormat:@"%d",self.result.correctResponses.count];
    self.numberIncorrectLabel.text = [NSString stringWithFormat:@"%d",self.result.incorrectResponses.count];
    
    if ([answer compare:actualAnswer] == NSOrderedSame)
        [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:.2];
    else
        self.nextButton.layer.opacity = 1;
    
}
-(void) checkPassConditions{
    
}
-(void) endSessionWithTimer:(BOOL)endedWithTimer{
    
    [self.updateTimer invalidate]; //Stop timer

    if (!endedWithTimer) {
        if (self.result.correctResponses.count + self.result.incorrectResponses.count>0) {
            self.result.endDate = [NSDate date]; //Used if test is stopped short but not quit entirely
        }
        else if(self.result){
            [self.practice removeResultsObject:self.result];
            [self.practice.managedObjectContext deleteObject:self.result]; //Delete worthlessresults
            self.result = nil;
        }
    }
    //Save
    [[UIApplication sharedApplication].delegate performSelector:@selector(saveDatabase)];    
    
    
    //Move to test or exit
    if (self.result && endedWithTimer) {
        UIAlertView *finishAlert = [[UIAlertView alloc] initWithTitle:@"Good work" message:[NSString stringWithFormat:@"You got %d questions correct and %d incorrect.",self.result.correctResponses.count,self.result.incorrectResponses.count] delegate:self cancelButtonTitle:@"Go To Test" otherButtonTitles:nil];
        [finishAlert show];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    //Save for good measure
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveDatabase" object:nil];    
}
#pragma mark - IBActions
-(IBAction)digitPressed:(id)sender{
    if (!self.updateTimer.isValid) //Copy race condition code from matt's work
        return;
    if (self.instructionLabel.text.length>0)//If current showing instruction, disable button input
        return;
    
	UIButton *btn = (UIButton *) sender;
    NSString *temp = [NSString stringWithFormat:@"%d", btn.tag];

    //Determine which label is the answerlabel
    Question* currentQuestion = [self.questionsToAsk lastObject];
    UILabel* answerLabel = nil;
    if (!currentQuestion.x)
        answerLabel = self.xLabel;
    else if (!currentQuestion.y)
        answerLabel = self.yLabel;
    else if(!currentQuestion.z)
        answerLabel = self.zLabel;
    
    if(answerLabel.text)
         answerLabel.text = [answerLabel.text stringByAppendingString:temp];
    else
        answerLabel.text = temp;
    
    //Check if correct digits have been entered
	NSNumber* actualAnswer = [self getAnswerForQuestion:[self.questionsToAsk lastObject]];
	
	if ([answerLabel.text length] == [[actualAnswer stringValue] length])
		 [self evaluateGivenAnswer:answerLabel.text  withActualAnswer:actualAnswer];
}
-(IBAction)didPressNextButton:(UIButton *)sender{
    [self loadNextQuestion];
}
-(IBAction)quitTest:(id)sender{
    if (self.quitSheet.visible)
        return [self.quitSheet dismissWithClickedButtonIndex:-1 animated:YES];
    
    self.quitSheet = [[UIActionSheet alloc] initWithTitle:NULL delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Quit" otherButtonTitles: nil];
    [self.quitSheet showFromBarButtonItem:sender animated:YES];

}
#pragma mark - UIActionSheet Delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //Start Test
        [self startTest];
    }
    else {
        //Quit test
        [self endSessionWithTimer:NO];
    }
}
-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self performSegueWithIdentifier:@"startTestFromPractice" sender:self.delegate];
}

@end
