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

@property (nonatomic)	UIPopoverController			*loginPopoverController;
@property (nonatomic)	IBOutlet	UIToolbar		*thisToolBar;
@property (nonatomic)	IBOutlet	UIView			*numberPadView;
@property (nonatomic)	IBOutlet	UIImageView		*numberPadBackView;
@property (nonatomic)	IBOutlet	UIButton		*availablePracticesButton;
@property (nonatomic)	IBOutlet	UIButton		*availableTestsButton;
@property (nonatomic)	IBOutlet	UILabel			*xValueLabel;
@property (nonatomic)	IBOutlet	UILabel			*yValueLabel;
@property (nonatomic)	IBOutlet	UILabel			*mathSymbolLabel;
@property (nonatomic)	IBOutlet	UILabel			*dashedLineLabel;
@property (nonatomic)	IBOutlet	UILabel			*answerLabel;
@property (nonatomic)	IBOutlet	UILabel			*modeLabel;
@property (nonatomic)	IBOutlet	UILabel			*successLabel;
@property (nonatomic)	IBOutlet	UILabel			*questionCountLabel;
@property (nonatomic)	IBOutlet	UILabel			*timeLabel;	
@property (nonatomic)	IBOutlet	UILabel			*usernameLabel;
@property (nonatomic)	IBOutlet	UIButton		*nextButton;

@property (nonatomic)				NSMutableArray	*availablePracticeQuizzesNSMA;
@property (nonatomic)				NSMutableArray	*availableTestQuizzesNSMA;
@property (nonatomic)				QuizSet			*studentQuizSet;
@property (nonatomic)				NSTimer			*testTimer;
@property (nonatomic)				NSMutableArray	*seededQuestionBankNSMA;
@property (nonatomic)				NSMutableArray	*errorQueueNSMA;
@property (nonatomic)				NSMutableArray	*lastQuestionNSMA;
@property (nonatomic)						BOOL			justMissed;

//Division Items
@property (nonatomic)	IBOutlet	UIView			*divisionView;
@property (nonatomic)	IBOutlet	UILabel			*xDivValueLabel;
@property (nonatomic)	IBOutlet	UILabel			*yDivValueLabel;
@property (nonatomic)	IBOutlet	UILabel			*answerDivValueLabel;

@property (nonatomic)	IBOutlet	UILabel			*buildLabel;


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
