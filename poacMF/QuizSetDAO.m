//
//  QuizSetDAO.m
//  poacMF
//
//  Created by Matt Hunter on 4/7/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuizSetDAO.h"
#import "QuestionSetsDAO.h"
#import "QuestionSet.h"
#import "QuestionSetDetail.h"

@implementation QuizSetDAO

-(QuizSet *) getQuizSetDetails: (QuizSet *) studentQuizSet {
	// Query 1 - Get the QuestionSets
	QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	studentQuizSet.assignedQuestionSet = [qsDAO getQuestionSetById: studentQuizSet.assignedQuiz.setId];
	[qsDAO release];
		
	sqlite3 *database;
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
	/* Query 2 - get the details
		SELECT a.setId, a.mathType, b.xValue, b.yValue FROM QuestionSets a, QuestionSetDetails b WHERE a.setOrder <= ? AND a.mathType = ?  AND a.setId = b.setId  */
		const char *sqlStatement = "SELECT a.setId, a.mathType, b.xValue, b.yValue, a.setOrder FROM QuestionSets a, QuestionSetDetails b WHERE a.setOrder <= ? AND a.mathType = ? AND a.setId = b.setId order by a.setOrder desc";
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, studentQuizSet.assignedQuestionSet.setOrder);
			sqlite3_bind_int(compiledStatement, 2, studentQuizSet.assignedQuestionSet.mathType);
				
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				QuestionSetDetail *qsd = [[QuestionSetDetail alloc] init];
				qsd.xValue = sqlite3_column_int(compiledStatement, 2);
				qsd.yValue = sqlite3_column_int(compiledStatement, 3);
				[studentQuizSet.questionDetailsNSMA addObject:qsd];
				[qsd release];
			}//end while
		}//end if
		sqlite3_finalize(compiledStatement);
	}//end if
		sqlite3_close(database);
	return studentQuizSet;
}//end method

@end
