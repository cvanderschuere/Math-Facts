//
//  Promotion.m
//  poacMF
//
//  Created by Matt Hunter on 4/17/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//
 
#import "Promotion.h"
#import "QuestionSetsDAO.h"
#import "QuestionSet.h"
#import "AppConstants.h"
#import "Quiz.h"
#import "QuizzesDAO.h"

@implementation Promotion

-(void) promoteUser: (User *) user withQuizSet: (QuizSet *) studentQuizSet {
	//if !passed quiz set
	if (!studentQuizSet.passedQuiz)
		return;
		
	//2) increment by 1
	int nextSetOrder = studentQuizSet.assignedQuestionSet.setOrder + 1;
	
	//3) verify that setId is in the database for the math type
	QuestionSetsDAO *qDAO = [[QuestionSetsDAO alloc] init];
	QuestionSet *nextQuestionSet = [qDAO getQuestionSetBySetOrder:nextSetOrder andMathType:studentQuizSet.assignedQuestionSet.mathType];
	
	//4) if not, move up a mathType and setId=0;
	int nextMathType = studentQuizSet.assignedQuestionSet.mathType;
	if (INVALID_QUESTION_SET == nextQuestionSet.setId) {
		nextMathType++;
		nextQuestionSet.mathType = nextMathType;
		nextQuestionSet.setOrder = 0;
		nextQuestionSet = [qDAO getQuestionSetBySetOrder:nextQuestionSet.setOrder andMathType:nextQuestionSet.mathType];
	}//end if
	
	//if we've passed all things, don't assign
	if (nextMathType > DIVISION_MATH_TYPE)
		return;
	
	QuizzesDAO *quizDAO = [[QuizzesDAO alloc] init];
	//5) if we passed a Practice
	if (QUIZ_PRACTICE_TYPE == studentQuizSet.assignedQuiz.testType) {
		//	a) open up the same Test
		Quiz *newTestQuiz = [studentQuizSet.assignedQuiz mutableCopyWithZone:nil];
		newTestQuiz.testType = QUIZ_TIMED_TYPE;
		newTestQuiz.timeLimit = user.defaultTimedTimeLimit;
		
		//	b) get other parameters from most recent Timed test
		Quiz *recentTimedQuiz = [quizDAO getSampleQuizForUser:user.userId andTestType:QUIZ_TIMED_TYPE];
		if ((nil != recentTimedQuiz) && (recentTimedQuiz.quizId != 0)) {
			newTestQuiz.requiredCorrect = recentTimedQuiz.requiredCorrect;
			newTestQuiz.allowedIncorrect = recentTimedQuiz.allowedIncorrect;
			newTestQuiz.totalQuestions = recentTimedQuiz.totalQuestions;
		}//
		//	c) insert
		[quizDAO addQuizForUser:newTestQuiz];
	} else {
		//   a) create the next Practice
		Quiz *newPracticeQuiz = [studentQuizSet.assignedQuiz mutableCopyWithZone:nil];
		newPracticeQuiz.setId = nextQuestionSet.setId;
		newPracticeQuiz.testType = QUIZ_PRACTICE_TYPE;
		newPracticeQuiz.timeLimit = user.defaultPracticeTimeLimit;
		
		//	b) get other parameters from most recent Timed test
		Quiz *recentPracticeQuiz = [quizDAO getSampleQuizForUser:user.userId andTestType:QUIZ_PRACTICE_TYPE];
		if ((nil != recentPracticeQuiz) && (recentPracticeQuiz.quizId != 0)) {
			newPracticeQuiz.requiredCorrect = recentPracticeQuiz.requiredCorrect;
			newPracticeQuiz.allowedIncorrect = recentPracticeQuiz.allowedIncorrect;
			newPracticeQuiz.totalQuestions = recentPracticeQuiz.totalQuestions;
		}//
		
		//	c) insert
		[quizDAO addQuizForUser:newPracticeQuiz];
		//open up the next test
		//newPracticeQuiz.testType=QUIZ_TEST_TYPE;
		//[quizDAO addQuizForUser:newPracticeQuiz];
		
	}//end if-else
	
}//end method

-(void) regressUser: (User *) user withQuizSet: (QuizSet *) studentQuizSet {
		QuizzesDAO *quizDAO = [[QuizzesDAO alloc] init];
		Quiz *newTestQuiz = [studentQuizSet.assignedQuiz mutableCopyWithZone:nil];
		newTestQuiz.testType = QUIZ_PRACTICE_TYPE;
		newTestQuiz.timeLimit = user.defaultPracticeTimeLimit;
		newTestQuiz.quizId = -1;
		[quizDAO addQuizForUser:newTestQuiz];
}//end method

@end
