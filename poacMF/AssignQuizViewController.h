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

@property (nonatomic, weak)	IBOutlet	UILabel				*selectedStudent;
@property (nonatomic, weak)	IBOutlet	UILabel				*assignedSet;
@property (nonatomic, strong)				NSMutableArray		*listOfUsers;
@property (nonatomic, strong)				NSMutableArray		*listofQuestionSets;
@property (nonatomic, weak)	IBOutlet	UIPickerView		*studentPicker;
@property (nonatomic, weak)	IBOutlet	UIPickerView		*quizSetPicker;
@property (nonatomic)						int					selectedStudentIndex;
@property (nonatomic)						int					assignedSetIndex;
@property (nonatomic)						int					testType;
@property (nonatomic, weak)	IBOutlet	UITextField			*timeLimitTF;
@property (nonatomic, weak)	IBOutlet	UITextField			*requiredCorrectTF;
@property (nonatomic, weak)	IBOutlet	UITextField			*allowedIncorrectTF;
@property (nonatomic, weak)	IBOutlet	UITextField			*totalQuestionsTF;
@property (nonatomic, weak)	IBOutlet	UINavigationBar		*thisNavBar;
@property (nonatomic, strong)				Quiz				*assignedQuiz;
@property (nonatomic)						BOOL				updateMode;
@property (nonatomic, strong)			    UITableView			*ptrTableToRedraw;

-(IBAction) cancelClicked;
-(IBAction) saveClicked;
-(void)		populateUI;

@end
