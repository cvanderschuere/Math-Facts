//
//  poacMFViewController.m
//  poacMF
//
//  Created by Matt Hunter on 3/17/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TesterViewController.h"
#import "PoacMFAppDelegate.h"
#import "AppConstants.h"
#import "AppLibrary.h"
#import "LoginPopoverViewController.h"
#import "QuizzesDAO.h"
#import "QuestionSet.h"
#import "QuestionSetsDAO.h"
#import "QuizSet.h"
#import "QuizSetDAO.h"
#import "QuestionSetDetail.h"
#import "ResultsDAO.h"
#import "Promotion.h"
 
@implementation TesterViewController

@synthesize thisToolBar, loginPopoverController, availablePracticesButton, availableTestsButton;
@synthesize availablePracticeQuizzesNSMA, availableTestQuizzesNSMA, numberPadView;
@synthesize numberPadBackView, xValueLabel, yValueLabel, mathSymbolLabel, dashedLineLabel, answerLabel;
@synthesize studentQuizSet;
@synthesize xValue, yValue, zResult, correctAnswerCounter, totalAnswerCounter, errorCounter;
@synthesize timeCounter, testTimer,seededQuestionBankNSMA;
@synthesize modeLabel, successLabel, questionCountLabel, nextButton, errorQueueNSMA, justMissed, errorWaitCount;
@synthesize timeLabel, buildLabel, usernameLabel;
@synthesize divisionView, xDivValueLabel, yDivValueLabel, answerDivValueLabel, lastQuestionNSMA;

- (void)dealloc {
	[thisToolBar release];
	[loginPopoverController release];
	[availablePracticesButton release];
	[availableTestsButton release];
	[availablePracticeQuizzesNSMA release];
	[availableTestQuizzesNSMA release];
	[numberPadView release];
	[numberPadBackView release];
	[xValueLabel release];
	[yValueLabel release];
	[mathSymbolLabel release];
	[dashedLineLabel release];
	[answerLabel release];
	[timeLabel release];
	[studentQuizSet release];
	[testTimer release];
	[seededQuestionBankNSMA release];
	[modeLabel release];
	[successLabel release];
	[usernameLabel release];
	[questionCountLabel release];
	[nextButton release];
	[errorQueueNSMA release];
	[buildLabel release];
	[divisionView release];
	[xDivValueLabel release];
	[yDivValueLabel release];
	[answerDivValueLabel release];
	[lastQuestionNSMA release];
    [super dealloc];
}//end method

#pragma mark - View lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}//end method

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.divisionView.backgroundColor = [UIColor grayColor];
	
	/* Build Version Stuff */
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
	NSString *build = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
	NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];
	NSString *buildStr = [NSString stringWithFormat:@"%@ v%@ (build %@)",name,version,build];
	buildLabel.text = buildStr;
	
	self.availablePracticesButton.titleLabel.text = @"";
	self.availableTestsButton.titleLabel.text = @"";
	
	self.availablePracticeQuizzesNSMA = [NSMutableArray array];
	self.availableTestQuizzesNSMA = [NSMutableArray array];
	self.seededQuestionBankNSMA = [NSMutableArray array];
	self.errorQueueNSMA = [NSMutableArray array];
	self.lastQuestionNSMA = [NSMutableArray array];
	
	[self hideMostThings];
	
	self.usernameLabel.text = @"";
	
	LoginPopoverViewController *apc = [[LoginPopoverViewController alloc] initWithNibName:LOGIN_VIEW_NIB bundle:nil]; 
	apc.view.backgroundColor = [UIColor blackColor];
	apc.contentSizeForViewInPopover = CGSizeMake(340, 130);
	self.loginPopoverController = [[UIPopoverController alloc] initWithContentViewController:apc];
	[apc release];	
		
}//end method

#pragma mark - Button Methods
-(IBAction) logInOut: (id) sender {
	PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (!appDelegate.loggedIn) {
		//1) pop open a login window if not logged in
		[self dismissThePopovers];
		[loginPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	} else {
		//2) confirmatory logout prompt if they are logged in
		UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Logout?" 
				delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Logout" 
				otherButtonTitles:@"Cancel", nil, nil];
		popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
		[popupQuery showInView:self.view];
		[popupQuery release];
	}//end if
}//end method

-(IBAction) testButtonsTapped: (id) sender{
	//TODO: if no practice quizzes, do nothing or give an error
	UIButton *uib = (UIButton *) sender;
	
	if ((0 == uib.tag) && (0 == [self.availablePracticeQuizzesNSMA count]))
		return;
	if ((1 == uib.tag) && (0 == [self.availableTestQuizzesNSMA count]))
		return;	
		
	Quiz *firstQuiz;
	//Get the Practice Quiz
	if (0 == uib.tag)
		firstQuiz = [self.availablePracticeQuizzesNSMA objectAtIndex:0];
	else
		firstQuiz = [self.availableTestQuizzesNSMA objectAtIndex:0];
	
	self.studentQuizSet = [[QuizSet alloc] init];
	studentQuizSet.assignedQuiz = firstQuiz;

	//Using the Quiz, get the full QuizSet
	QuizSetDAO *qsDAO = [[QuizSetDAO alloc] init];
	self.studentQuizSet = [qsDAO getQuizSetDetails: studentQuizSet];
	[qsDAO release];
	
	[self initiateScenario];
}//end method

#pragma mark Managing the add popover
-(void) dismissThePopovers {
	[loginPopoverController dismissPopoverAnimated:YES];
}//end

#pragma mark - Action Sheet Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
    if (buttonIndex == 0) {
        appDelegate.loggedIn = NO;
		self.usernameLabel.text = @"";
		[self hideMostThings];
		if (nil != testTimer) {
			[testTimer invalidate];
			testTimer=nil;
		}//end if
	}//end if
}//end method

#pragma mark ----
-(void) setInitialStudentView {
	PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
	NSString *first = [appDelegate.currentUser.firstName stringByAppendingString:@" "];
	self.usernameLabel.text = [first stringByAppendingString:appDelegate.currentUser.lastName];
	
	availablePracticesButton.hidden = NO;
	availableTestsButton.hidden = NO;	
	QuizzesDAO *qDAO = [[QuizzesDAO alloc] init];
	AppLibrary *al = [[AppLibrary alloc] init];

	QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	
	//change the Practices Button Text
	self.availablePracticeQuizzesNSMA = [qDAO getAvailablePracticeQuizzesByUserId:appDelegate.currentUser.userId];
	if (0 < [self.availablePracticeQuizzesNSMA count]){
		Quiz *firstQuiz = [self.availablePracticeQuizzesNSMA objectAtIndex:0];
		QuestionSet *qs = [qsDAO getQuestionSetById: firstQuiz.setId];
		NSString *buttonText = @"Practice ";
		buttonText = [buttonText stringByAppendingString:[al interpretMathTypeAsPhrase:qs.mathType]];
		buttonText = [buttonText stringByAppendingString:@": "];
		buttonText = [buttonText stringByAppendingString:qs.questionSetName];
		availablePracticesButton.titleLabel.text = buttonText;
	} else {
		availablePracticesButton.titleLabel.text = @"0 Practices";
	}
	
	/*change the Tests Button Text
	Per kathy notes on v51...don't allow a Timed test to be taken if
		1) if it is the same as the Practice...and
		2) the allowed time is the same...and
		3) they haven't passed the practice yet
		4) OR they haven't passed ANY practices yet. [per v56 Kathy comments]
	 */
	
	self.availableTestQuizzesNSMA = [qDAO getAvailableTestQuizzesByUserId:appDelegate.currentUser.userId];
	if (0 < [self.availableTestQuizzesNSMA count]){
		Quiz *firstQuiz = [self.availableTestQuizzesNSMA objectAtIndex:0];
		QuestionSet *qs = [qsDAO getQuestionSetById: firstQuiz.setId];
		
		Quiz *firstPracticeQuiz = [[Quiz alloc] init];;
		if (0 != [self.availablePracticeQuizzesNSMA count])
			firstPracticeQuiz = [self.availablePracticeQuizzesNSMA objectAtIndex:0];
		else
			[firstPracticeQuiz autorelease];
		
		ResultsDAO *rdao = [[ResultsDAO alloc] init];
		BOOL practicesPassed = [rdao haveAnyPracticesBeenPassedForThisUser:appDelegate.currentUser.userId];
		[rdao release];
		
		//QuestionSet *qsP = [qsDAO getQuestionSetById: firstQuiz.setId];
		ResultsDAO *rDAO = [[ResultsDAO alloc] init];
		if (
			(
				(firstQuiz.setId == firstPracticeQuiz.setId) && 
				//(firstQuiz.timeLimit == firstPracticeQuiz.timeLimit) &&
				(![rDAO hasThisQuizBeenPassed:firstPracticeQuiz.quizId forThisUser:appDelegate.currentUser.userId forThisTestType:QUIZ_PRACTICE_TYPE])
			 ) ||
				(!practicesPassed)
			){
				availableTestsButton.titleLabel.text = @"0 Tests";
		} else {
			NSString *buttonText = @"Test ";
			buttonText = [buttonText stringByAppendingString:[al interpretMathTypeAsPhrase:qs.mathType]];
			buttonText = [buttonText stringByAppendingString:@": "];
			buttonText = [buttonText stringByAppendingString:qs.questionSetName];
			availableTestsButton.titleLabel.text = buttonText;
		}//
		[rDAO release];
	} else {
		availableTestsButton.titleLabel.text = @"0 Tests";
	}
	
	[qsDAO release];	
	[al release];
	[qDAO release];
}//end method

-(void) numberPadAnimation {
	// set up an animation for the transition between the views
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.25];
	[animation setType:kCATransitionFade];
	[animation setSubtype:kCATransitionFromTop];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	//call the animation
	[[numberPadView layer] addAnimation:animation forKey:@"SwitchToView1"];
}//end method

-(void) initiateScenario{
	//reset things
	availablePracticesButton.hidden = YES;
	availableTestsButton.hidden = YES;	
	[self numberPadAnimation];
	numberPadView.hidden = NO;
	xValueLabel.hidden = NO;
	yValueLabel.hidden = NO;
	mathSymbolLabel.hidden = NO;
	dashedLineLabel.hidden = NO;
	answerLabel.hidden = NO;
	modeLabel.hidden = NO;
	questionCountLabel.hidden = NO;
	timeLabel.hidden = NO;
	successLabel.text=@"";
	correctAnswerCounter=0;
	totalAnswerCounter=1;
	errorCounter=0;
	answerLabel.text=@"";
	divisionView.hidden = YES;
	answerDivValueLabel.text=@"";
	timeCounter=studentQuizSet.assignedQuiz.timeLimit;
	timeLabel.text = [NSString stringWithFormat:@"Seconds Left: %i",0];
	srandom(time(NULL));
	
	if (QUIZ_PRACTICE_TYPE == studentQuizSet.assignedQuiz.testType){
		modeLabel.text = @"Practicing...";
		answerLabel.hidden = NO;
	} else {
		modeLabel.text = @"Testing...";
		answerLabel.hidden = YES;
	}
	
	//studentQuizSet
	//1) Figure out how many questions of the new set are needed
	[self.studentQuizSet.assignedQuiz calculateThrottle];
	 //2) seed the test
	[self.seededQuestionBankNSMA removeAllObjects];
	[self createQuestions];
	//3) start the timer
	self.testTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
	//4) go!
	questionCountLabel.text = [NSString stringWithFormat:@"Question: %d of %d", totalAnswerCounter,studentQuizSet.assignedQuiz.totalQuestions];
	
	if (3 == studentQuizSet.assignedQuestionSet.mathType)
		divisionView.hidden = NO;
	else
		divisionView.hidden = YES;
	[self setFlashcardDigits];
}//end method

-(void) createQuestions {
	//this sets the MATH_SIGN CONSTANT	
	AppLibrary *al = [[AppLibrary alloc] init];
	NSString *mathSymbolStr = [al interpretMathTypeAsSymbol:studentQuizSet.assignedQuestionSet.mathType];
	
	for (QuestionSetDetail *qsd in studentQuizSet.questionDetailsNSMA) {
		
		int localX = qsd.xValue;
		int localY = qsd.yValue;
		int localZ;
		//To begin with, let's put the bigger number on top (important for subtraction) if ! division
		if (1 == studentQuizSet.assignedQuestionSet.mathType){	
			if(qsd.xValue < qsd.yValue){
					localZ = localX;
					localX = localY;
					localY = localZ;
			}//end if
		}//end if	
		NSString *question1 = [NSString stringWithFormat:@"%i %s %i", localX, [mathSymbolStr UTF8String], localY];
		[self.seededQuestionBankNSMA addObject:question1];
	}//end seededQuestionBankNSMA
	
	if (studentQuizSet.assignedQuiz.totalQuestions > [self.seededQuestionBankNSMA count])
		[self createQuestions];
	
	[al release];
}//end method

-(void) setFlashcardDigits {
	
	/* For first x% questions, based on the throttle, grab questions from the front of the queue. These 
	 should be the newest questions sets available. After the first x%, grab whatever random question */
	int size = [self.seededQuestionBankNSMA count];
	size--;
	BOOL removeQuestion=FALSE;
		
	//on even questions, pick from the throttle side if appropriate
	if (
		(self.studentQuizSet.assignedQuiz.questionThrottle > totalAnswerCounter) && 
		(self.studentQuizSet.assignedQuiz.questionThrottle < size ) && 
		(0 == totalAnswerCounter%2) )
		size = self.studentQuizSet.assignedQuiz.questionThrottle;
	else 
		removeQuestion = TRUE;
	
	int pick = 0;
	//if we ran out of questions
	if (0 == size)
		pick=0;
	else
		pick = arc4random() % size;

	NSString *thisQ = [self.seededQuestionBankNSMA objectAtIndex:pick];
	NSArray *nsa = [thisQ componentsSeparatedByString: @" "];
	NSString *localX = [nsa objectAtIndex:0];
	NSString *localSymbol = [nsa objectAtIndex:1];
	NSString *localY = [nsa objectAtIndex:2];
	
	self.xValue = [localX intValue];
	self.yValue = [localY intValue];
	
	//present to user
	self.mathSymbolLabel.text = localSymbol;
	if (NSOrderedSame == [localSymbol caseInsensitiveCompare:@"/"])
		self.mathSymbolLabel.text = @"÷";
	
	xValueLabel.text = localX;
	yValueLabel.text = localY;
	if (3 == studentQuizSet.assignedQuestionSet.mathType) {
		xDivValueLabel.text = localX;
		yDivValueLabel.text = localY;
	}//
	
	/*if same question, do it again...
	 this code gets caught in recursion traps when there's not enough variety, works
	 fine on larger sets where there's plenty of variety.
	
	 if ((nil != self.lastQuestionNSMA) && (0 < [lastQuestionNSMA count])) {
		NSString *lastQ = [self.lastQuestionNSMA objectAtIndex:0];
		if (NSOrderedSame == [lastQ caseInsensitiveCompare:thisQ])
			[self setFlashcardDigits];
	}
	*/
	
	[self.lastQuestionNSMA removeAllObjects];
	[self.lastQuestionNSMA addObject:thisQ];
	
	//If we're still in throttle mode don't remove the question asked because it will
	//need to be asked again. After our throttle is met, remove.
	if (removeQuestion){
		if (pick < [self.seededQuestionBankNSMA count])
			[self.seededQuestionBankNSMA removeObjectAtIndex:pick];
	}// end if
}//end method

-(IBAction) digitPressed: (id) sender {
	/* this resolves a race condition. If the NEXT button (or answer on TIMED) is hit
	 when time runs down to 0 the results don't show appropriately. */
	if (0 == timeCounter)
		return;
	UIButton *btn = (UIButton *) sender;
    NSString *temp = [NSString stringWithFormat:@"%i", btn.tag];
    NSString *currentValue = answerLabel.text;
    currentValue = [currentValue stringByAppendingString:temp];
    answerLabel.text = currentValue;
	
	if (3 == studentQuizSet.assignedQuestionSet.mathType)
		answerDivValueLabel.text = currentValue;
	
	//has the full answer been entered?
	int checkAnswer = [self getCheckAnswer];
	
	NSNumber *sizeCheck = [NSNumber numberWithInt:checkAnswer];
	if ([answerLabel.text length] == [[sizeCheck stringValue] length])
		[self actOnAnswer];
}//end method

-(int) getCheckAnswer {
	int checkAnswer = 0;
	if (0 == studentQuizSet.assignedQuestionSet.mathType)
		checkAnswer = xValue+yValue;
	else if (1 == studentQuizSet.assignedQuestionSet.mathType)
		checkAnswer = xValue-yValue;
	else if (2 == studentQuizSet.assignedQuestionSet.mathType)
		checkAnswer = xValue*yValue;
	else if (3 == studentQuizSet.assignedQuestionSet.mathType)
		checkAnswer = yValue/xValue;
	return checkAnswer;
}//end method

-(void) actOnAnswer {
    [self numberPadAnimation];   
	
	successLabel.textColor = [UIColor whiteColor];
	successLabel.font = [UIFont systemFontOfSize:20];
	
	zResult = (int) [answerLabel.text intValue];
	int checkAnswer = [self getCheckAnswer];
	
	if (checkAnswer == zResult){
		//only increment the counter if its an immediate retake question
		if (justMissed)
			justMissed = FALSE;
		else
			correctAnswerCounter++;			

		if (QUIZ_PRACTICE_TYPE == studentQuizSet.assignedQuiz.testType) {
			successLabel.text = @"Good job! ";
		} else {
			//in test mode, don't tell them good job, just pop the next question
			successLabel.text = @"";
			nextButton.hidden = YES;
			[self nextButtonTapped];
			return;
		}
	} else {
		if (QUIZ_TIMED_TYPE == studentQuizSet.assignedQuiz.testType) {
			//in test mode, don't tell them good job, just pop the next question
			successLabel.text = @"";
			errorCounter++;
			nextButton.hidden = YES;
			[self nextButtonTapped];
			return;
		}//end
		
		//if we just missed this question and are taking it a second time, don't record again, we will
		//keep retaking until we get it right
		if (justMissed) 
			justMissed = YES;
		else {
			errorCounter++;
			justMissed = YES;
		}
		PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
		if (0 >= errorWaitCount)
			errorWaitCount=appDelegate.currentUser.delayRetake;
		NSString *missed;		
		if (3 == studentQuizSet.assignedQuestionSet.mathType) {
			missed = [NSString stringWithFormat:@"%i %s %i = %i", xValue, [@"/" UTF8String], yValue, checkAnswer];
		} else {
			missed = [NSString stringWithFormat:@"%i %s %i = %i", xValue, [mathSymbolLabel.text UTF8String], yValue, checkAnswer];
		}
		[self.errorQueueNSMA addObject:missed];

		successLabel.text = [NSString stringWithFormat:@"No, it was %i ", checkAnswer];
		successLabel.textColor = [UIColor yellowColor];
		successLabel.font = [UIFont boldSystemFontOfSize:40];
	}//end if-else
	nextButton.hidden = NO;
	successLabel.hidden = NO;
}//end doneButtonClicked

-(IBAction)	nextButtonTapped {
	/* this resolves a race condition. If the NEXT button (or answer on TIMED) is hit
	 when time runs down to 0 the results don't show appropriately. */
	if (0 == timeCounter)
		return;
	
	PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
	nextButton.hidden = YES;
	successLabel.hidden = YES;
	answerLabel.text = @"";
	answerDivValueLabel.text = @"";
	
	//if we ran out of questions
	if (0 == [seededQuestionBankNSMA count])
		[self createQuestions];
	
	//1) if we just missed a question, ask it again
	if (justMissed) {
		questionCountLabel.text = [NSString stringWithFormat:@"Retake Question %d", totalAnswerCounter];
		NSString *text = [self.errorQueueNSMA lastObject];
		NSArray *nsa = [text componentsSeparatedByString: @" "];
		NSString *localX = [nsa objectAtIndex:0];
		NSString *localSymbol = [nsa objectAtIndex:1];
		NSString *localY = [nsa objectAtIndex:2];
		self.xValue = [localX intValue];
		self.yValue = [localY intValue];
		//present to user
		self.mathSymbolLabel.text = localSymbol;
		if (NSOrderedSame == [localSymbol caseInsensitiveCompare:@"/"]){
			self.mathSymbolLabel.text = @"÷";
			xDivValueLabel.text = localX;
			yDivValueLabel.text = localY;
		}
		xValueLabel.text = localX;
		yValueLabel.text = localY;
		return;
	}//end if
	
	/* For a Timed Test...keep going until time runs out. All others, stop when 
		you run through all questions 
	 
		On 7/16 Kathy wants it for PRACTICE as well
	 */
	/* 
	 if ((QUIZ_PRACTICE_TYPE == studentQuizSet.assignedQuiz.testType) && 
		(totalAnswerCounter >= studentQuizSet.assignedQuiz.totalQuestions)) {
		[self endSession];
	}else {
	*/	
		totalAnswerCounter++;
		if (totalAnswerCounter <= studentQuizSet.assignedQuiz.totalQuestions)
			questionCountLabel.text = [NSString stringWithFormat:@"Question: %d of %d", totalAnswerCounter,studentQuizSet.assignedQuiz.totalQuestions];
		else 
			questionCountLabel.text = [NSString stringWithFormat:@"Question: %d of %d", totalAnswerCounter,totalAnswerCounter];
	
		//2) if the errorQueue is empty, just pick another question
		if (0 == [errorQueueNSMA count]) {
			[self setFlashcardDigits];
			return;
		}//end if
		
		//3) if errorQueue is !empty, decide whether to ask a normal question or redo
		if (0 >= errorWaitCount) {
			NSString *text = [self.errorQueueNSMA objectAtIndex:0];
			NSArray *nsa = [text componentsSeparatedByString: @" "];
			NSString *localX = [nsa objectAtIndex:0];
			NSString *localSymbol = [nsa objectAtIndex:1];
			NSString *localY = [nsa objectAtIndex:2];
			self.xValue = [localX intValue];
			self.yValue = [localY intValue];
			//present to user
			self.mathSymbolLabel.text = localSymbol;
			if (NSOrderedSame == [localSymbol caseInsensitiveCompare:@"/"]){
				self.mathSymbolLabel.text = @"÷";
				xDivValueLabel.text = localX;
				yDivValueLabel.text = localY;
			}
			xValueLabel.text = localX;
			yValueLabel.text = localY;
			justMissed = NO;
			[self.errorQueueNSMA removeObjectAtIndex:0];
			//if there are other questions in the queue, set the Count back to 2
			if (0 != [errorQueueNSMA count])
				errorWaitCount = appDelegate.currentUser.delayRetake;
		} else {
			errorWaitCount--;
			[self setFlashcardDigits];
		}
	//}//end if-else
}//end method

-(void) onTimer:(NSTimer*) theTimer {
	timeCounter--;
	NSNumber *timeStr = [NSNumber numberWithInt:timeCounter];
	timeLabel.text = [@"Seconds Left: " stringByAppendingString: [timeStr stringValue]];
	if (0 == timeCounter){
		timeLabel.text = @"Time's Up!";
		
		/* all of this prevents results such as "12 of 11 correct" or incorrectly 
			decrementing when an answer wasn't given */
		if (1 > [answerLabel.text length]){
			zResult = [answerLabel.text intValue];
			int checkAnswer = [self getCheckAnswer];
			if (checkAnswer == zResult){
				//only increment the counter if its an immediate retake question
				if (justMissed)
					justMissed = FALSE;
				else
					correctAnswerCounter++;
				
			}
		} else {
			totalAnswerCounter--;				//you ran out of time, don't let the last one be counted against you.
		}
		[self endSession];
	}//end method
}//end method

-(void) endSession {
	[testTimer invalidate];
	testTimer=nil;
	
	[self hideMostThings];
	
	//package up the totals
	successLabel.textColor = [UIColor whiteColor];
	successLabel.font = [UIFont systemFontOfSize:20];
	successLabel.hidden = NO;
	studentQuizSet.numberIncorrect = errorCounter;
	studentQuizSet.recordedTime = (studentQuizSet.assignedQuiz.timeLimit - timeCounter);
	studentQuizSet.numberCorrect = correctAnswerCounter;
	
	NSString *yeah;
	//if the got the required number correct AND answered all questions
	if ((studentQuizSet.numberIncorrect <= studentQuizSet.assignedQuiz.allowedIncorrect) && 
		(totalAnswerCounter >= studentQuizSet.assignedQuiz.totalQuestions) &&
		(studentQuizSet.numberCorrect >= studentQuizSet.assignedQuiz.requiredCorrect)){
		studentQuizSet.passedQuiz = YES;
		yeah = @"Passed! ";
	} else {
		studentQuizSet.passedQuiz = NO;
		yeah = @"Sorry! ";
	}	
	
	//give success messages
	if (QUIZ_PRACTICE_TYPE == studentQuizSet.assignedQuiz.testType)
		successLabel.text = [yeah stringByAppendingFormat:@"You got %i of %i correct. ", correctAnswerCounter, totalAnswerCounter];
	else
		successLabel.text = [yeah stringByAppendingFormat:@"You got %i of %i correct. ", correctAnswerCounter, totalAnswerCounter];
	
	NSString *foo = [NSString stringWithFormat:@"You needed %i of %i correct. ", 
		studentQuizSet.assignedQuiz.requiredCorrect, studentQuizSet.assignedQuiz.totalQuestions];
	successLabel.text = [successLabel.text stringByAppendingString:foo];
	
	if ((0 == timeCounter) && (totalAnswerCounter < studentQuizSet.assignedQuiz.totalQuestions) )
		successLabel.text = [successLabel.text stringByAppendingString:@"You ran out of time. "];
	
	
	//Record Results
	ResultsDAO *rDAO = [[ResultsDAO alloc] init];
	[rDAO recordResultsForQuizSet: studentQuizSet];
	[rDAO release];
	
	//Call Business Object to Promote student if possible, otherwise reopen quiz
	if (studentQuizSet.passedQuiz) {
		PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
		Promotion *promo = [[Promotion alloc] init];
		[promo promoteUser: appDelegate.currentUser withQuizSet:studentQuizSet];
		[promo release];
	} else {
		if (studentQuizSet.assignedQuiz.testType == QUIZ_TIMED_TYPE) {
			PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
			Promotion *promo = [[Promotion alloc] init];
			[promo regressUser: appDelegate.currentUser withQuizSet:studentQuizSet];
			[promo release];
		}
	}//end method
	
	mathSymbolLabel.text = @"";
	[self setInitialStudentView];
}//end method

-(void) hideMostThings {
	availablePracticesButton.hidden = YES;
	availableTestsButton.hidden = YES;
	numberPadView.hidden = YES;
	xValueLabel.hidden = YES;
	yValueLabel.hidden = YES;
	mathSymbolLabel.hidden = YES;
	dashedLineLabel.hidden = YES;
	answerLabel.hidden = YES;
	modeLabel.hidden = YES;
	successLabel.hidden = YES;
	questionCountLabel.hidden = YES;
	nextButton.hidden = YES;
	timeLabel.hidden = YES;
	divisionView.hidden = YES;
}//end method

@end
