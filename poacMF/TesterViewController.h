//
//  poacMFViewController.h
//  poacMF
//
//  Created by Matt Hunter on 3/17/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoacMFAppDelegate.h"
#import "POACDetailViewController.h"
#import	"QuizSet.h"

@interface TesterViewController : POACDetailViewController <UIActionSheetDelegate, UIPopoverControllerDelegate> {
    
	UIPopoverController		*loginPopoverController;
	
	@private
	UIToolbar				*thisToolBar;
	UIView					*numberPadView;
	UIImageView				*numberPadBackView;
	UIButton				*availablePracticesButton;
	UIButton				*availableTestsButton;
	UILabel					*xValueLabel;
	UILabel					*yValueLabel;
	UILabel					*mathSymbolLabel;
	UILabel					*dashedLineLabel;
	UILabel					*answerLabel;
	UILabel					*usernameLabel;
	UILabel					*modeLabel;
	UILabel					*successLabel;
	UILabel					*questionCountLabel;
	UILabel					*timeLabel;	
	UIButton				*nextButton;
	
	NSMutableArray			*availablePracticeQuizzesNSMA;
	NSMutableArray			*availableTestQuizzesNSMA;
	QuizSet					*studentQuizSet;
	NSMutableArray			*errorQueueNSMA;
	NSMutableArray			*lastQuestionNSMA;
	
	int xValue;
	int yValue;
	int zResult;
	int correctAnswerCounter;
	int totalAnswerCounter;
	int errorCounter;
	int timeCounter;
	NSTimer					*testTimer;
	NSMutableArray			*seededQuestionBankNSMA;
	BOOL					justMissed;
	int errorWaitCount;
	
	//Division Items
	UIView					*divisionView;
	UILabel					*xDivValueLabel;
	UILabel					*yDivValueLabel;
	UILabel					*answerDivValueLabel;
	
	UILabel					*buildLabel;
	
}

@property (nonatomic, retain)	UIPopoverController			*loginPopoverController;
@property (nonatomic, retain)	IBOutlet	UIToolbar		*thisToolBar;
@property (nonatomic, retain)	IBOutlet	UIView			*numberPadView;
@property (nonatomic, retain)	IBOutlet	UIImageView		*numberPadBackView;
@property (nonatomic, retain)	IBOutlet	UIButton		*availablePracticesButton;
@property (nonatomic, retain)	IBOutlet	UIButton		*availableTestsButton;
@property (nonatomic, retain)	IBOutlet	UILabel			*xValueLabel;
@property (nonatomic, retain)	IBOutlet	UILabel			*yValueLabel;
@property (nonatomic, retain)	IBOutlet	UILabel			*mathSymbolLabel;
@property (nonatomic, retain)	IBOutlet	UILabel			*dashedLineLabel;
@property (nonatomic, retain)	IBOutlet	UILabel			*answerLabel;
@property (nonatomic, retain)	IBOutlet	UILabel			*modeLabel;
@property (nonatomic, retain)	IBOutlet	UILabel			*successLabel;
@property (nonatomic, retain)	IBOutlet	UILabel			*questionCountLabel;
@property (nonatomic, retain)	IBOutlet	UILabel			*timeLabel;	
@property (nonatomic, retain)	IBOutlet	UILabel			*usernameLabel;
@property (nonatomic, retain)	IBOutlet	UIButton		*nextButton;

@property (nonatomic, retain)				NSMutableArray	*availablePracticeQuizzesNSMA;
@property (nonatomic, retain)				NSMutableArray	*availableTestQuizzesNSMA;
@property (nonatomic, retain)				QuizSet			*studentQuizSet;
@property (nonatomic, retain)				NSTimer			*testTimer;
@property (nonatomic, retain)				NSMutableArray	*seededQuestionBankNSMA;
@property (nonatomic, retain)				NSMutableArray	*errorQueueNSMA;
@property (nonatomic, retain)				NSMutableArray	*lastQuestionNSMA;
@property (nonatomic)						BOOL			justMissed;

//Division Items
@property (nonatomic, retain)	IBOutlet	UIView			*divisionView;
@property (nonatomic, retain)	IBOutlet	UILabel			*xDivValueLabel;
@property (nonatomic, retain)	IBOutlet	UILabel			*yDivValueLabel;
@property (nonatomic, retain)	IBOutlet	UILabel			*answerDivValueLabel;

@property (nonatomic, retain)	IBOutlet	UILabel			*buildLabel;


@property int xValue;
@property int yValue;
@property int zResult;
@property int correctAnswerCounter;
@property int totalAnswerCounter;
@property int errorCounter;
@property int timeCounter;
@property int errorWaitCount;


-(void)			dismissThePopovers; 
-(IBAction)		logInOut: (id) sender;
-(void)			setInitialStudentView;
-(IBAction)		testButtonsTapped: (id) sender;
-(void)			initiateScenario;
-(void)			numberPadAnimation;
-(void)			createQuestions;
-(void)			setFlashcardDigits;
-(void)			actOnAnswer;
-(IBAction)		nextButtonTapped;
-(int)			getCheckAnswer;
-(void)			endSession;
-(void)			hideMostThings;

@end
