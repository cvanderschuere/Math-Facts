//
//  TestViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 11/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "TestViewController.h"
#import "QuestionSet.h"
#import "Question.h"
#import "Result.h"
#import "PoacMFAppDelegate.h"
#import "NSMutableArray+Shuffling.h"

//1 in # new vs old
#define NEW_OLD_QUESTION_RATIO 5


@interface TestViewController ()

@property (nonatomic, strong) Result* result;
@property (nonatomic, strong) NSTimer* updateTimer;
@property (nonatomic, strong) UIActionSheet *quitSheet;
@property (nonatomic, strong) NSMutableArray *oldQuestions;

@end

@implementation TestViewController
@synthesize questionsLabel = _questionsLabel;
@synthesize timeLabel = _timeLabel;
@synthesize xLabel = _xLabel;
@synthesize yLabel = _yLabel;
@synthesize zLabel = _zLabel;
@synthesize mathOperatorSymbol = _mathOperatorSymbol;
@synthesize horizontalLine = _horizontalLine;
@synthesize verticalLine = _verticalLine;
@synthesize numberCorrectLabel = _numberCorrectLabel;

@synthesize test = _test, questionsToAsk = _questionsToAsk, result = _result, oldQuestions = _oldQuestions;
@synthesize updateTimer = _updateTimer;
@synthesize delegate = _delegate;
@synthesize quitSheet = _quitSheet;

-(void) setTest:(Test *)test{
    if (![_test isEqual:test]) {
        _questionsToAsk = nil;
        _test = test;
        
        //Set title label
        self.title = [_test.student.username stringByAppendingString:[NSString stringWithFormat:@": %@",_test.questionSet.name]];
        
        //Reload Questions to ask
        NSFetchRequest *previousQuestionSet = [NSFetchRequest fetchRequestWithEntityName:@"QuestionSet"];
        previousQuestionSet.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"difficultyLevel" ascending:YES]];
        previousQuestionSet.predicate = [NSPredicate predicateWithFormat:@"difficultyLevel < %@ AND type == %@",_test.questionSet.difficultyLevel,_test.questionSet.type];
        NSMutableArray *sets = [_test.managedObjectContext executeFetchRequest:previousQuestionSet error:NULL].mutableCopy;
        
        NSLog(@"Sets: %@",sets);
        
        self.oldQuestions = [NSMutableArray array];
        for (QuestionSet* set in sets) {
            [self.oldQuestions addObjectsFromArray:set.questions.allObjects];
        }
        [self.oldQuestions shuffleArray];
                
        NSMutableArray* newQuestions = test.questionSet.questions.allObjects.mutableCopy;
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
                [self.oldQuestions removeObject:oldQuestion];
            }
        }
    }
}
#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Disable back button
    self.navigationItem.hidesBackButton = YES;

        
    //Setup for question type
    if (self.test.questionSet.type.intValue == QUESTION_TYPE_MATH_DIVISION) {
        //Setup for divsion symbol
        //Setup for vertical problem
        self.xLabel.frame = CGRectMake(318, 212, 132, 62);
        self.yLabel.frame = CGRectMake(151, 208, 132, 66);
        self.zLabel.frame = CGRectMake(318, 93, 132,68);
        self.horizontalLine.hidden = YES;  //.frame = CGRectMake(258, 164, 252,19);
        
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
        switch (self.test.questionSet.type.intValue) {
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
    self.xLabel.text = self.yLabel.text = self.zLabel.text = self.timeLabel.text = self.numberCorrectLabel.text = nil;
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Test Flow Methods
-(void) startTest{    
    //Create Result and set values
    self.result = [NSEntityDescription insertNewObjectForEntityForName:@"Result" inManagedObjectContext:self.test.managedObjectContext];
    self.result.test = self.test;
    self.result.student = self.test.student;
    self.result.isPractice = [NSNumber numberWithBool:NO];
    self.result.startDate = [NSDate date];
    self.result.endDate = [self.result.startDate dateByAddingTimeInterval:self.test.testLength.intValue];

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
    NSMutableArray *arrayOfNewQuestions = [self.questionsToAsk filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"questionSet.difficultyLevel = %@",self.test.questionSet.difficultyLevel]].mutableCopy;
    
    int numberToAdd = self.questionsToAsk.count - arrayOfNewQuestions.count;
    
    //Check: Not enough old questions to refill array
    if (self.oldQuestions.count < numberToAdd) {
        //Reload all previous questions
        NSFetchRequest *previousQuestionSet = [NSFetchRequest fetchRequestWithEntityName:@"QuestionSet"];
        previousQuestionSet.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"difficultyLevel" ascending:YES]];
        previousQuestionSet.predicate = [NSPredicate predicateWithFormat:@"difficultyLevel < %@ AND type == %@",self.test.questionSet.difficultyLevel,self.test.questionSet.type];
        NSMutableArray *sets = [self.test.managedObjectContext executeFetchRequest:previousQuestionSet error:NULL].mutableCopy;
        
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
    if (self.questionsToAsk.count>0) {
        Question* previousQuestion = self.questionsToAsk.lastObject;
        
        //Insert old question in front of array
        [self.questionsToAsk insertObject:previousQuestion atIndex:0];
        [self.questionsToAsk removeLastObject];
        
        //If gone through entire array...shuffle
        if ((self.result.correctResponses.count + self.result.incorrectResponses.count) % self.questionsToAsk.count == 0)
            [self shuffleQuestions];
        
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
        switch (self.test.questionSet.type.intValue) {
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
        switch (self.test.questionSet.type.intValue) {
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
        switch (self.test.questionSet.type.intValue) {
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
        
    }
    else {
        //Incorrect Answer
        Response *incorrectResponse = [NSEntityDescription insertNewObjectForEntityForName:@"Response" inManagedObjectContext:self.result.managedObjectContext];
        incorrectResponse.question = [self.questionsToAsk lastObject];
        incorrectResponse.answer = givenAnswer;
        incorrectResponse.index = [NSNumber numberWithInt:self.result.correctResponses.count + self.result.incorrectResponses.count];
        [self.result addIncorrectResponsesObject:incorrectResponse];
    }
    
    [self checkPassConditions];
    
    //Update numberCorrectLabel
    self.numberCorrectLabel.text = [NSString stringWithFormat:@"%d / %d",self.result.correctResponses.count,self.test.passCriteria.intValue];
    
    
    [self performSelector:@selector(loadNextQuestion) withObject:nil afterDelay:.2]; //Add delay for effect
    
}
-(void) checkPassConditions{
    if (self.result.incorrectResponses.count > self.test.maximumIncorrect.intValue) {
        //Failed test: Undecided whether should kick students out or finish the timing
        //[self endSessionWithTimer:NO];
    }
    
}
-(void) endSessionWithTimer:(BOOL)endedWithTimer{
    
    [self.updateTimer invalidate]; //Stop timer

    if (!endedWithTimer) {
        if (self.result.correctResponses.count + self.result.incorrectResponses.count>0) {
            self.result.endDate = [NSDate date]; //Used if test is stopped short but not quit entirely
        }
        else {
            [self.result.managedObjectContext deleteObject:self.result]; //Delete worthlessresults
        }
    }
    //Save
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveDatabase" object:nil];
    
    //Exit to test grid
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //Show Stats if test started
    if (self.result) {
        [self.delegate didFinishTest:self.test withResult:self.result];
    }
}
#pragma mark - IBActions
-(IBAction)digitPressed:(id)sender{
    if (!self.updateTimer.isValid) //Copy race condition code from matt's work
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
@end
