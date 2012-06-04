//
//  QuizSetDAOTest.m
//  poacMF
//
//  Created by Matt Hunter on 4/9/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuizSetDAOTest.h"
#import "QuizzesDAO.h"
#import "Quiz.h"
#import "QuestionSetsDAO.h"
#import "QuizSetDAO.h"
#import "QuizSet.h"

@implementation QuizSetDAOTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testGetQuizSetDetails {
	QuizzesDAO *qDAO = [[QuizzesDAO alloc] init];
	NSMutableArray *availablePracticeQuizzesNSMA = [qDAO getAvailablePracticeQuizzesByUserId:2];
    Quiz *firstQuiz = [availablePracticeQuizzesNSMA objectAtIndex:0];
	QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	//QuestionSet *qs = [qsDAO getQuestionSetById: firstQuiz.setId];
	QuizSet *studentQuizSet = [[QuizSet alloc] init];
	
	studentQuizSet.assignedQuiz = firstQuiz;
	QuizSetDAO *quizsDAO = [[QuizSetDAO alloc] init];
	studentQuizSet = [quizsDAO getQuizSetDetails: studentQuizSet];
	
	//NSLog(@"studentQuizSet.assignedQuiz %s", [[studentQuizSet.assignedQuiz description] UTF8String]);
	//NSLog(@"studentQuizSet.assignedQuestionSet %s", [[studentQuizSet.assignedQuestionSet description] UTF8String]);
	//NSLog(@"studentQuizSet.questionDetailsNSMA %s", [[studentQuizSet.questionDetailsNSMA description] UTF8String]);
	
	STAssertNotNil(studentQuizSet, @"QuizSetDAOTest.testGetQuizSetDetails failed");
    
	[qDAO release];
	[qsDAO release];
	[quizsDAO release];
	[studentQuizSet release];
}//end method

#endif

@end
