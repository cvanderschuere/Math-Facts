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
	/*
	@private
	UIToolbar				*thisToolBar;
	UIView					*numberPadView;
	UIImageView				*numberPadBackView;
	UIButton				*availablePracticesButton;
	UIButton				*availableTestsButton;
	UILabel					*xValueLabel;
	UILabel					*yValueLabel;
	UILabel					*__weak mathSymbolLabel;
	UILabel					*__weak dashedLineLabel;
	UILabel					*__weak answerLabel;
	UILabel					*__weak usernameLabel;
	UILabel					*__weak modeLabel;
	UILabel					*__weak successLabel;
	UILabel					*__weak questionCountLabel;
	UILabel					*__weak timeLabel;	
	UIButton				*__weak nextButton;
	
	NSMutableArray			*__weak availablePracticeQuizzesNSMA;
	NSMutableArray			*__weak availableTestQuizzesNSMA;
	QuizSet					*studentQuizSet;
	NSMutableArray			*__weak errorQueueNSMA;
	NSMutableArray			*__weak lastQuestionNSMA;
	
	int xValue;
	int yValue;
	int zResult;
	int correctAnswerCounter;
	int totalAnswerCounter;
	int errorCounter;
	int timeCounter;
	NSTimer					*__weak testTimer;
	NSMutableArray			*__weak seededQuestionBankNSMA;
	BOOL					justMissed;
	int errorWaitCount;
	
	//Division Items
	UIView					*divisionView;
	UILabel					*xDivValueLabel;
	UILabel					*yDivValueLabel;
	UILabel					*answerDivValueLabel;
	
	UILabel					*buildLabel;
     */
	
}

@property (nonatomic, strong)	UIPopoverController			*loginPopoverController;
@property (nonatomic, weak)	IBOutlet	UIToolbar		*thisToolBar;
@property (nonatomic, weak)	IBOutlet	UIView			*numberPadView;
@property (nonatomic, weak)	IBOutlet	UIImageView		*numberPadBackView;
@property (nonatomic, weak)	IBOutlet	UIButton		*availablePracticesButton;
@property (nonatomic, weak)	IBOutlet	UIButton		*availableTestsButton;
@property (nonatomic, weak)	IBOutlet	UILabel			*xValueLabel;
@property (nonatomic, weak)	IBOutlet	UILabel			*yValueLabel;
@property (weak, nonatomic)	IBOutlet	UILabel			*mathSymbolLabel;
@property (weak, nonatomic)	IBOutlet	UILabel			*dashedLineLabel;
@property (weak, nonatomic)	IBOutlet	UILabel			*answerLabel;
@property (weak, nonatomic)	IBOutlet	UILabel			*modeLabel;
@property (weak, nonatomic)	IBOutlet	UILabel			*successLabel;
@property (weak, nonatomic)	IBOutlet	UILabel			*questionCountLabel;
@property (weak, nonatomic)	IBOutlet	UILabel			*timeLabel;	
@property (weak, nonatomic)	IBOutlet	UILabel			*usernameLabel;
@property (weak, nonatomic)	IBOutlet	UIButton		*nextButton;

@property (strong, nonatomic)				NSMutableArray	*availablePracticeQuizzesNSMA;
@property (strong, nonatomic)				NSMutableArray	*availableTestQuizzesNSMA;
@property (nonatomic, strong)				QuizSet			*studentQuizSet;
@property (strong, nonatomic)				NSTimer			*testTimer;
@property (strong, nonatomic)				NSMutableArray	*seededQuestionBankNSMA;
@property (strong, nonatomic)				NSMutableArray	*errorQueueNSMA;
@property (strong, nonatomic)				NSMutableArray	*lastQuestionNSMA;
@property (nonatomic)						BOOL			justMissed;

//Division Items
@property (nonatomic, weak)	IBOutlet	UIView			*divisionView;
@property (nonatomic, weak)	IBOutlet	UILabel			*xDivValueLabel;
@property (nonatomic, weak)	IBOutlet	UILabel			*yDivValueLabel;
@property (nonatomic, weak)	IBOutlet	UILabel			*answerDivValueLabel;

@property (nonatomic, weak)	IBOutlet	UILabel			*buildLabel;


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
