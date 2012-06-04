//
//  AssignQuizViewController.m
//  poacMF
//
//  Created by Matt Hunter on 3/30/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "AssignQuizViewController.h"
#import "UsersDAO.h"
#import "User.h"
#import "QuestionSetsDAO.h"
#import "QuestionSet.h"
#import "AppLibrary.h"
#import "Quiz.h"
#import "QuizzesDAO.h"
#import "AppConstants.h"
#import "PoacMFAppDelegate.h"

@implementation AssignQuizViewController

@synthesize selectedStudent, assignedSet, listOfUsers, listofQuestionSets;
@synthesize studentPicker, quizSetPicker;
@synthesize selectedStudentIndex, assignedSetIndex, testType;
@synthesize timeLimitTF, requiredCorrectTF, allowedIncorrectTF, totalQuestionsTF;
@synthesize thisNavBar, assignedQuiz, updateMode, ptrTableToRedraw;

- (void)dealloc {
	[selectedStudent release];
	[assignedSet release];
	[listOfUsers release];
	[listofQuestionSets release];
	[studentPicker release];
	[quizSetPicker release];
	[timeLimitTF release];
	[requiredCorrectTF release];
	[allowedIncorrectTF release];
	[totalQuestionsTF release];
	[thisNavBar release];
	if (nil != assignedQuiz)
		[assignedQuiz release];
	[ptrTableToRedraw release];
    [super dealloc];
}//end method


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}//end method

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	self.modalPresentationStyle=UIModalPresentationFormSheet;
	self.timeLimitTF.text=@"";
	//load the users
	UsersDAO *uDAO = [[UsersDAO alloc] init];
	self.listOfUsers = [uDAO getAllUsers];
	[uDAO release];
	
	if (nil == self.listOfUsers)
		self.listOfUsers = [NSMutableArray array];
	
	//load the Quiz Sets
	QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	self.listofQuestionSets = [qsDAO getAllSets];
	[qsDAO release];
	
	if (nil == self.listofQuestionSets)
		self.listofQuestionSets = [NSMutableArray array];
	
	selectedStudentIndex = assignedSetIndex = -1;
	
	selectedStudent.text = @"";
	assignedSet.text = @"";
	
	
	[self.studentPicker selectRow:0 inComponent:0 animated:YES];
	[self pickerView:studentPicker didSelectRow:0 inComponent:0];
	
	[self.quizSetPicker selectRow:0 inComponent:0 animated:YES];
	[self pickerView:quizSetPicker didSelectRow:0 inComponent:0];
	
}//end method

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	/*Change the Title of the Nav Bar based on scenario */
	NSArray *navItemsArray = self.thisNavBar.items;
	UINavigationItem *item = [navItemsArray objectAtIndex:0];
	if (QUIZ_PRACTICE_TYPE == testType)
		item.title = @"Assign Practice";
	else
		item.title = @"Assign Time";
	
	[self populateUI];
}

-(void) populateUI {
	if (nil != self.assignedQuiz){
		NSNumber *nsn = [NSNumber numberWithInt:self.assignedQuiz.timeLimit];
		timeLimitTF.text = [nsn stringValue];
		
		nsn = [NSNumber numberWithInt:self.assignedQuiz.requiredCorrect];
		requiredCorrectTF.text = [nsn stringValue];

		nsn = [NSNumber numberWithInt:self.assignedQuiz.allowedIncorrect];
		allowedIncorrectTF.text = [nsn stringValue];
		
		nsn = [NSNumber numberWithInt:self.assignedQuiz.totalQuestions];
		totalQuestionsTF.text = [nsn stringValue];
		
		self.testType = self.assignedQuiz.testType;
		
		//Loop through users, figure out which one we have and select it
		int count = 0;
		for (User *u in self.listOfUsers){
			if (self.assignedQuiz.userId == u.userId) {
				selectedStudentIndex = count;
				[self.studentPicker selectRow:count inComponent:0 animated:YES];
				[self pickerView:studentPicker didSelectRow:count	inComponent:0];
			}//end if
			count++;
		}//end for loop
		
		count = 0;
		for (QuestionSet *qs in self.listofQuestionSets){
			if (self.assignedQuiz.setId == qs.setId) {
				assignedSetIndex = count;
				[self.quizSetPicker selectRow:count inComponent:0 animated:YES];
				[self pickerView:quizSetPicker didSelectRow:count	inComponent:0];
			}//end if
			count++;
		}//end for loop
			
	}//end method
}//end method

#pragma mark Button Methods
-(IBAction) cancelClicked {
	[ptrTableToRedraw reloadData];
	[self dismissModalViewControllerAnimated:YES];
}//end method

-(IBAction) saveClicked {
	AppLibrary *al = [[AppLibrary alloc] init];
	if ((-1 == selectedStudentIndex) || (-1 == assignedSetIndex) ||
		(0 >= timeLimitTF.text) || (0 >= requiredCorrectTF) ||
		(0 >= allowedIncorrectTF)){
		NSString *msg = @"All fields need to be filled in.";
		[al showAlertFromDelegate:self withWarning:msg];
		[al release];
		return;
	}//end 
	
	if (!self.updateMode) {
		User *tempUser = [listOfUsers objectAtIndex:selectedStudentIndex];
		QuestionSet *qs = [listofQuestionSets objectAtIndex:assignedSetIndex];
		Quiz *newQuiz = [[Quiz alloc] init];
		newQuiz.userId = tempUser.userId;
		newQuiz.setId = qs.setId;
		newQuiz.timeLimit = [timeLimitTF.text intValue];
		newQuiz.requiredCorrect = [requiredCorrectTF.text intValue];
		newQuiz.allowedIncorrect = [allowedIncorrectTF.text intValue];
		newQuiz.totalQuestions = [totalQuestionsTF.text intValue];
		newQuiz.testType = self.testType;
		QuizzesDAO *qDAO = [[QuizzesDAO alloc] init];
		[qDAO addQuizForUser:newQuiz];
		[qDAO release];
		[newQuiz release];		
	} else {
		QuestionSet *qs = [listofQuestionSets objectAtIndex:assignedSetIndex];
		assignedQuiz.setId = qs.setId;
		assignedQuiz.timeLimit = [timeLimitTF.text intValue];
		assignedQuiz.requiredCorrect = [requiredCorrectTF.text intValue];
		assignedQuiz.allowedIncorrect = [allowedIncorrectTF.text intValue];
		assignedQuiz.totalQuestions = [totalQuestionsTF.text intValue];
		assignedQuiz.testType = self.testType;
		QuizzesDAO *qDAO = [[QuizzesDAO alloc] init];
		[qDAO updateQuizForUser: assignedQuiz];
		[qDAO release];
	}//
	
	[al release];
	
	[self dismissModalViewControllerAnimated:YES];
	
	[ptrTableToRedraw reloadData];
}//end method

#pragma mark Picker Data Source Methods
-(NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView {
	return 1;
}//end method

-(NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component{
	if (pickerView == self.studentPicker)
		if (nil != self.listOfUsers)
			return [listOfUsers count];
	if (pickerView == self.quizSetPicker)
		if (nil != self.listofQuestionSets)
			return [listofQuestionSets count];
	return 0;
}//end method

-(NSString *) pickerView: (UIPickerView *) pickerView titleForRow: (NSInteger) row forComponent: (NSInteger) component {
	NSString *returnString = @"";
	if (pickerView == self.studentPicker)
		if (nil != self.listOfUsers){
			User *tempUser = [listOfUsers objectAtIndex:row];
			NSString *name = [tempUser.firstName stringByAppendingString:@" "];
			name = [name stringByAppendingString:tempUser.lastName];
			return name;
		}//end if
	if (pickerView == self.quizSetPicker)
		if (nil != self.listofQuestionSets){
			AppLibrary *al = [[AppLibrary alloc] init];
			QuestionSet *qs = [listofQuestionSets objectAtIndex:row];
			NSString *backend = [NSString stringWithFormat:@" - %i questions", [qs.setDetailsNSMA count]];
			NSString *frontend = [[al interpretMathTypeAsPhrase:qs.mathType] stringByAppendingString:qs.questionSetName];
			returnString = [frontend stringByAppendingString:backend];
			[al release];
			return returnString;					  
		}//end if
	return returnString;
}//end method

#pragma mark Picker Delegate Methods
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return self.view.frame.size.width;
}//end method

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSString *returnString = @"";
	if (pickerView == self.studentPicker)
		if (nil != self.listOfUsers){
			User *tempUser = [listOfUsers objectAtIndex:row];
			NSString *name = [tempUser.firstName stringByAppendingString:@" "];
			name = [name stringByAppendingString:tempUser.lastName];
			self.selectedStudent.text = name;
			selectedStudentIndex = row;
			if (!updateMode) {
				NSNumber *dtl;
				if (QUIZ_PRACTICE_TYPE == testType)
					dtl = [NSNumber numberWithInt:tempUser.defaultPracticeTimeLimit];
				else
					dtl = [NSNumber numberWithInt:tempUser.defaultTimedTimeLimit];
				timeLimitTF.text = [dtl stringValue];
			}//end
		}//end if
	if (pickerView == self.quizSetPicker)
		if (nil != self.listofQuestionSets){
			AppLibrary *al = [[AppLibrary alloc] init];
			QuestionSet *qs = [listofQuestionSets objectAtIndex:row];
			NSString *backend = [NSString stringWithFormat:@" - %i questions", [qs.setDetailsNSMA count]];
			NSString *frontend = [[al interpretMathTypeAsPhrase:qs.mathType] stringByAppendingString:qs.questionSetName];
			returnString = [frontend stringByAppendingString:backend];
			[al release];
			self.assignedSet.text = returnString;
			assignedSetIndex = row;
		}//end if
}//end method

@end
