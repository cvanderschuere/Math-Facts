//
//  ResultsDAO.m
//  poacMF
//
//  Created by Matt Hunter on 4/17/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "ResultsDAO.h"
#import "Quiz.h"
#import "AppConstants.h"
#import "SuperResults.h"

@implementation ResultsDAO
 
-(BOOL) recordResultsForQuizSet: (QuizSet *) studentQuizSet {
    sqlite3 *sqlDatabase;
	
	if(sqlite3_open([super.databasePath UTF8String], &sqlDatabase) != SQLITE_OK) {
		return FALSE;
	}//end if
	
	sqlite3_stmt *compiledStatement;
	char *sqlStatement = "INSERT INTO Results (userId, testType, setId, mathType, testDate, correct, incorrect, passFail, quizId, timeTaken) values (?,?,?,?,?,?,?,?,?,?)";
	int returnValue =sqlite3_prepare_v2(sqlDatabase, sqlStatement, -1, &compiledStatement, NULL);
	
	if(returnValue == SQLITE_OK) {
		sqlite3_bind_int(compiledStatement, 1, studentQuizSet.assignedQuiz.userId);
		sqlite3_bind_int(compiledStatement, 2, studentQuizSet.assignedQuiz.testType);
		sqlite3_bind_int(compiledStatement, 3, studentQuizSet.assignedQuestionSet.setId);
		sqlite3_bind_int(compiledStatement, 4, studentQuizSet.assignedQuestionSet.mathType);
		
		NSDate *now = [NSDate date];
		sqlite3_bind_text(compiledStatement, 5, [[now description] UTF8String], -1, SQLITE_TRANSIENT);
		
		sqlite3_bind_int(compiledStatement, 6, studentQuizSet.numberCorrect);
		sqlite3_bind_int(compiledStatement, 7, studentQuizSet.numberIncorrect);
		if (studentQuizSet.passedQuiz)
			sqlite3_bind_text(compiledStatement, 8, [QUIZ_PASS UTF8String], -1, SQLITE_TRANSIENT);
		else
			sqlite3_bind_text(compiledStatement, 8, [QUIZ_FAIL UTF8String], -1, SQLITE_TRANSIENT);
		
		sqlite3_bind_int(compiledStatement, 9, studentQuizSet.assignedQuiz.quizId);
		sqlite3_bind_double(compiledStatement, 10, studentQuizSet.recordedTime);
		
		if(SQLITE_DONE != sqlite3_step(compiledStatement))	
			NSLog(@"ResultsDAO.recordResultsForQuizSet Error.A: '%s'", sqlite3_errmsg(sqlDatabase));
	} else {
		NSLog(@"ResultsDAO.recordResultsForQuizSet: Error.B...'%s'", sqlite3_errmsg(sqlDatabase));
	}
    
	sqlite3_finalize(compiledStatement);
	sqlite3_close(sqlDatabase);
	return TRUE;
}//end method

-(NSMutableArray *) getAllResults {
	NSMutableArray *uNSMA = [NSMutableArray array];
	
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT c.userId, b.setId, b.timeLimit, b.correct, b.totalQuestions, b.testType, c.mathType, c.testDate, c.correct, c.passFail, c.timeTaken,c.incorrect, d.setName FROM Quizzes b, Results c, QuestionSets d WHERE b.userid = c.userid and b.setId = c.setId and d.setId = c.setId and c.quizId = b.quizId ORDER BY c.userId, c.testDate Desc, c.setId Desc";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				SuperResults *sr = [[SuperResults alloc] init];
				
				sr.userId = sqlite3_column_int(compiledStatement, 0); 
				sr.setId = sqlite3_column_int(compiledStatement, 1);
				sr.requiredTimeLimit = sqlite3_column_int(compiledStatement, 2);
				sr.requiredCorrect = sqlite3_column_int(compiledStatement, 3);
				sr.requiredTotalQuestions = sqlite3_column_int(compiledStatement, 4);
				sr.testType = sqlite3_column_int(compiledStatement, 5);
				sr.mathType = sqlite3_column_int(compiledStatement, 6);
				
				NSString *foo = @"";
				if (nil != sqlite3_column_text(compiledStatement, 7))
					foo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
				
				NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
				[dateFormatter setLenient:YES];		
				[dateFormatter setDateStyle:NSDateFormatterShortStyle];
				[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss Z"];
				if (nil != foo && 0 < [foo length])
					sr.resultsTestDate = [dateFormatter dateFromString:foo];
				else
					sr.resultsTestDate = nil;
				
				sr.resultsCorrect = sqlite3_column_int(compiledStatement, 8);
				if (nil != sqlite3_column_text(compiledStatement, 9))
					sr.resultsPassFail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];				
				sr.resultsTimeTaken = sqlite3_column_int(compiledStatement, 10);
				
				int incorrect = sqlite3_column_int(compiledStatement, 11);
				sr.resultsTotalQuestions = incorrect + sr.resultsCorrect;
				
				if (nil != sqlite3_column_text(compiledStatement, 12))
					sr.setName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
				
				[uNSMA addObject:sr];
				[sr autorelease];
			}//end while
		} else {
			NSLog(@"ResultsDAO.getResultsSet: Select error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return uNSMA;
}//end method

-(BOOL) hasThisQuizBeenPassed: (int) quizId forThisUser: (int) userId forThisTestType: (int) testType {
	BOOL results=FALSE;
	
	sqlite3 *database;
	// Open the database from the users filessytem
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT passFail FROM results WHERE quizID = ? and userId=? and testType=?";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, quizId);
			sqlite3_bind_int(compiledStatement, 2, userId);
			sqlite3_bind_int(compiledStatement, 3, testType);
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				if (nil != sqlite3_column_text(compiledStatement, 0)){
					NSString *passFail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					if (NSOrderedSame == [@"Pass" compare:passFail])
						results = TRUE;
				}//
			}//end while
		}//end if
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	
	return results;
}//end

-(BOOL) haveAnyPracticesBeenPassedForThisUser: (int) userId {
	BOOL results=FALSE;
	
	sqlite3 *database;
	// Open the database from the users filessytem
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT passFail FROM results WHERE userId=? and testType=?";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, userId);
			sqlite3_bind_int(compiledStatement, 2, QUIZ_PRACTICE_TYPE);
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				if (nil != sqlite3_column_text(compiledStatement, 0)){
					NSString *passFail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					if (NSOrderedSame == [@"Pass" compare:passFail])
						results = TRUE;
				}//
			}//end while
		}//end if
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	
	return results;
}//end method


@end
