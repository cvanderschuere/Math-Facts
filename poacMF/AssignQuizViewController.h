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

@property (nonatomic, retain)	IBOutlet	UILabel				*selectedStudent;
@property (nonatomic, retain)	IBOutlet	UILabel				*assignedSet;
@property (nonatomic, retain)				NSMutableArray		*listOfUsers;
@property (nonatomic, retain)				NSMutableArray		*listofQuestionSets;
@property (nonatomic, retain)	IBOutlet	UIPickerView		*studentPicker;
@property (nonatomic, retain)	IBOutlet	UIPickerView		*quizSetPicker;
@property (nonatomic)						int					selectedStudentIndex;
@property (nonatomic)						int					assignedSetIndex;
@property (nonatomic)						int					testType;
@property (nonatomic, retain)	IBOutlet	UITextField			*timeLimitTF;
@property (nonatomic, retain)	IBOutlet	UITextField			*requiredCorrectTF;
@property (nonatomic, retain)	IBOutlet	UITextField			*allowedIncorrectTF;
@property (nonatomic, retain)	IBOutlet	UITextField			*totalQuestionsTF;
@property (nonatomic, retain)	IBOutlet	UINavigationBar		*thisNavBar;
@property (nonatomic, retain)				Quiz				*assignedQuiz;
@property (nonatomic)						BOOL				updateMode;
@property (nonatomic, retain)			    UITableView			*ptrTableToRedraw;

-(IBAction) cancelClicked;
-(IBAction) saveClicked;
-(void)		populateUI;

@end
