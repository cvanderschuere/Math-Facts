//
//  AssignQuizViewController.h
//  poacMF
//
//  Created by Matt Hunter on 3/30/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"

@interface AssignQuizViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	UILabel				*selectedStudent;
	UILabel				*assignedSet;
	NSMutableArray		*listOfUsers;
    NSMutableArray		*listofQuestionSets;
	UIPickerView		*studentPicker;
	UIPickerView		*quizSetPicker;
	int					selectedStudentIndex;
	int					assignedSetIndex;
	int					testType;
	UITextField			*timeLimitTF;
	UITextField			*requiredCorrectTF;
	UITextField			*allowedIncorrectTF;
	UITextField			*totalQuestionsTF;
	UINavigationBar		*thisNavBar;
	Quiz				*assignedQuiz;
	BOOL				updateMode;
	
    UITableView			*ptrTableToRedraw;
}

@property (nonatomic)	IBOutlet	UILabel				*selectedStudent;
@property (nonatomic)	IBOutlet	UILabel				*assignedSet;
@property (nonatomic)				NSMutableArray		*listOfUsers;
@property (nonatomic)				NSMutableArray		*listofQuestionSets;
@property (nonatomic)	IBOutlet	UIPickerView		*studentPicker;
@property (nonatomic)	IBOutlet	UIPickerView		*quizSetPicker;
@property (nonatomic)						int					selectedStudentIndex;
@property (nonatomic)						int					assignedSetIndex;
@property (nonatomic)						int					testType;
@property (nonatomic)	IBOutlet	UITextField			*timeLimitTF;
@property (nonatomic)	IBOutlet	UITextField			*requiredCorrectTF;
@property (nonatomic)	IBOutlet	UITextField			*allowedIncorrectTF;
@property (nonatomic)	IBOutlet	UITextField			*totalQuestionsTF;
@property (nonatomic)	IBOutlet	UINavigationBar		*thisNavBar;
@property (nonatomic)				Quiz				*assignedQuiz;
@property (nonatomic)						BOOL				updateMode;
@property (nonatomic)			    UITableView			*ptrTableToRedraw;

-(IBAction) cancelClicked;
-(IBAction) saveClicked;
-(void)		populateUI;

@end
