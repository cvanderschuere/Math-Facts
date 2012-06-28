//
//  TestViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 11/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Test.h"

@protocol TestResultProtocol <NSObject>

-(void) didFinishTest:(Test*)finishedTest withResult:(Result*)result;

@end

@interface TestViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, strong) Test* test;
@property (nonatomic, strong) NSMutableArray *questionsToAsk;
@property (nonatomic, strong) id<TestResultProtocol> delegate;

//UI
@property (weak, nonatomic) IBOutlet UILabel *questionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (weak, nonatomic) IBOutlet UILabel *mathOperatorSymbol;
@property (weak, nonatomic) IBOutlet UIView *horizontalLine;
@property (weak, nonatomic) IBOutlet UIView *verticalLine;
@property (weak, nonatomic) IBOutlet UILabel *numberCorrectLabel;

@end


/* Flow Chart */

//1) Test set (Fetch questions for all previous question sets for cummulative = questionsToAsk)
    //Shuffel inital questions
//2) ViewDidLoad (Setup screen for testType + ask for confirmation to start test)
//3) Start Test (Create Result and set start date; initiate question loop)

    //4) Load first question from list and display (if empty load again)
        //After every question has been show shuffle
    //5) Digit pressed (Check to see if matches number of digit required and use as full answer if so)
    //6) Check answer 
        //7a) Correct (Add to questionsCorrect and congratulate animation)
        //7b) Incorrect (Add to questionsIncorrect and wrong animation)
    //8) Check passing conditions (If too many wrong end session)

//9) End Session (Save Result)
