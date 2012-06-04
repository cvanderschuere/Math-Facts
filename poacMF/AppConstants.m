//
//  AppConstants.m
//  poacMF
//
//  Created by Matt Hunter on 3/18/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "AppConstants.h"


@implementation AppConstants

NSString *	const	DATABASE_PATH =	@"databasePath";
NSString *	const	DATABASE_NAME =	@"poacMF.sqlite";


int			const	ADMIN_USER_TYPE = 0;
int			const	STUDENT_USER_TYPE = 1;

int			const	ADDITION_MATH_TYPE = 0;
int			const	SUBTRACTION_MATH_TYPE = 1;
int			const	MULTIPLICATION_MATH_TYPE = 2;
int			const	DIVISION_MATH_TYPE = 3;

int			const	QUIZ_TEST_TYPE=1;
int			const	QUIZ_PRACTICE_TYPE=0;
NSString *	const	QUIZ_PASS = @"Pass";
NSString *	const	QUIZ_FAIL = @"Fail";
int			const	INVALID_QUESTION_SET = -1;

NSString *	const	LOGIN_VIEW_NIB = @"LoginPopoverView";
NSString *	const	ADMIN_VIEW_NIB = @"AdminView";
NSString *	const	TESTER_VIEW_NIB = @"TesterView";
NSString *	const	USERS_VIEW_NIB = @"UsersView";
NSString *	const	AEUSER_NIB = @"AEUserView";
NSString *	const	ASSIGN_QUIZ_NIB = @"AssignQuizView";
NSString *	const	QUESTION_SETS_VIEW_NIB = @"QuestionSetsView";

@end
