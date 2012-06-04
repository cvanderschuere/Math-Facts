//
//  QuizzesDAO.m
//  poacMF
//
//  Created by Matt Hunter on 3/29/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuizzesDAO.h"
#import "Quiz.h"
#import "AppConstants.h"

@implementation QuizzesDAO

#pragma mark GET methods
-(NSMutableArray *)	getAllQuizzesByUserId : (int) userId {
	NSMutableArray *uNSMA = [NSMutableArray array];
	
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "select quizId,userId,setId,timeLimit,correct,incorrect,totalQuestions,testType from quizzes where userId = ? order by setId";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, userId);
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				Quiz *qs = [[Quiz alloc] init];
				qs.quizId = sqlite3_column_int(compiledStatement, 0);
				qs.userId = sqlite3_column_int(compiledStatement, 1);
				qs.setId = sqlite3_column_int(compiledStatement, 2);
				qs.timeLimit = sqlite3_column_double(compiledStatement, 3);
				qs.requiredCorrect = sqlite3_column_int(compiledStatement, 4);
				qs.allowedIncorrect = sqlite3_column_int(compiledStatement, 5);
				qs.totalQuestions = sqlite3_column_int(compiledStatement, 6);
				qs.testType = sqlite3_column_int(compiledStatement, 7);
				[uNSMA addObject:qs];
			}//end while
		} else {
			NSLog(@"QuizzesDAO.getAllQuizzesByUserId: Select error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return uNSMA;
}//end method

-(NSMutableArray *)	getAvailablePracticeQuizzesByUserId : (int) userId {
	return [self getAvailableQuizzesByUserId: userId andTestType:QUIZ_PRACTICE_TYPE];
}//end method

-(NSMutableArray *)	getAvailableTestQuizzesByUserId : (int) userId {
	return [self getAvailableQuizzesByUserId: userId andTestType:QUIZ_TIMED_TYPE];
}//end method

-(NSMutableArray *)	getAvailableQuizzesByUserId : (int) userId andTestType: (int) testType {
	NSMutableArray *uNSMA = [NSMutableArray array];
	
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT quizId, userId, setid, timeLimit, correct, incorrect, totalQuestions, testType FROM quizzes q WHERE q.userId = ? AND testType =? AND q.quizId not in (SELECT r.quizId FROM results r where r.userid = ? and passFail == 'Pass' and testType=?) order by setId desc";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, userId);
			sqlite3_bind_int(compiledStatement, 2, testType);
			sqlite3_bind_int(compiledStatement, 3, userId);
			sqlite3_bind_int(compiledStatement, 4, testType);
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				Quiz *newQuiz = [[Quiz alloc] init];
				newQuiz.quizId = sqlite3_column_int(compiledStatement, 0);
				newQuiz.userId = sqlite3_column_int(compiledStatement, 1);
				newQuiz.setId = sqlite3_column_int(compiledStatement, 2);
				newQuiz.timeLimit = sqlite3_column_int(compiledStatement, 3);
				newQuiz.requiredCorrect = sqlite3_column_int(compiledStatement, 4);
				newQuiz.allowedIncorrect = sqlite3_column_int(compiledStatement, 5);
				newQuiz.totalQuestions = sqlite3_column_int(compiledStatement, 6);
				newQuiz.testType = sqlite3_column_int(compiledStatement, 7);
				[uNSMA addObject:newQuiz];
			}//end while
		}//end if
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return uNSMA;
}//end method

-(Quiz *) getSampleQuizForUser: (int) userId andTestType: (int) testType {
	
	Quiz *newQuiz = [[Quiz alloc] init];
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT quizId, userId, setid, timeLimit, correct, incorrect, totalQuestions, testType FROM quizzes q WHERE q.userId = ? AND testType =? order by quizId desc";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, userId);
			sqlite3_bind_int(compiledStatement, 2, testType);
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				newQuiz.quizId = sqlite3_column_int(compiledStatement, 0);
				newQuiz.userId = sqlite3_column_int(compiledStatement, 1);
				newQuiz.setId = sqlite3_column_int(compiledStatement, 2);
				newQuiz.timeLimit = sqlite3_column_int(compiledStatement, 3);
				newQuiz.requiredCorrect = sqlite3_column_int(compiledStatement, 4);
				newQuiz.allowedIncorrect = sqlite3_column_int(compiledStatement, 5);
				newQuiz.totalQuestions = sqlite3_column_int(compiledStatement, 6);
				newQuiz.testType = sqlite3_column_int(compiledStatement, 7);
			}//end while
		}//end if
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return newQuiz;
}//end method

#pragma mark ADD methods
-(BOOL) addQuizForUser: (Quiz *) newQuiz {
	int newQuizId = -1;
	
	BOOL exists = FALSE;
	sqlite3 *database;
	const char *sqlStatement = "SELECT setid FROM quizzes q WHERE q.userId = ? AND testType =? and q.setId=?";
	sqlite3_stmt *compiledStatement;
	//first, ensure this quiz for this test type doesn't already exist
	/* removing this on 7/30/11. Kathy wants to have them do the practice quiz again if they fail the timed
		test...don't want to lose the results though */
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		if (QUIZ_TIMED_TYPE == newQuiz.testType) {
			int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
			if (returnValue == SQLITE_OK) {
				sqlite3_bind_int(compiledStatement, 1, newQuiz.userId);
				sqlite3_bind_int(compiledStatement, 2, newQuiz.testType);
				sqlite3_bind_int(compiledStatement, 3, newQuiz.setId);
			
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
					int setId = sqlite3_column_int(compiledStatement, 0);
					if (setId == newQuiz.setId)
						exists=TRUE;
				}//end while
				sqlite3_reset(compiledStatement);
			}//
		}//end
	}//

	if(!exists) {
		sqlStatement = "INSERT INTO Quizzes (userId, setId, timeLimit, correct, incorrect, totalQuestions, testType) values (?,?,?,?,?,?,?)";
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if(returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, newQuiz.userId);
			sqlite3_bind_int(compiledStatement, 2, newQuiz.setId);
			sqlite3_bind_int(compiledStatement, 3, newQuiz.timeLimit);
			sqlite3_bind_int(compiledStatement, 4, newQuiz.requiredCorrect);
			sqlite3_bind_int(compiledStatement, 5, newQuiz.allowedIncorrect);
			sqlite3_bind_int(compiledStatement, 6, newQuiz.totalQuestions);
			sqlite3_bind_int(compiledStatement, 7, newQuiz.testType);
			
			if(SQLITE_DONE != sqlite3_step(compiledStatement))
				NSLog(@"QuizzesDAO.addQuizForUser: Error while inserting data: '%s'", sqlite3_errmsg(database));
			
			int x = sqlite3_last_insert_rowid(database);
			if (x > 0)
				newQuizId = x;
		}//end if
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
		return TRUE;
	} else
		return FALSE;
	return exists;
}//end method

#pragma mark UPDATE methods
-(BOOL) updateQuizForUser: (Quiz *) newQuiz {
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "UPDATE Quizzes set timeLimit=?,correct=?, incorrect=?, totalQuestions=?, setId=? where userId=? and quizId=?";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if(returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, newQuiz.timeLimit);
			sqlite3_bind_int(compiledStatement, 2, newQuiz.requiredCorrect);
			sqlite3_bind_int(compiledStatement, 3, newQuiz.allowedIncorrect);
			sqlite3_bind_int(compiledStatement, 4, newQuiz.totalQuestions);
			sqlite3_bind_int(compiledStatement, 5, newQuiz.setId);
			sqlite3_bind_int(compiledStatement, 6, newQuiz.userId);
			sqlite3_bind_int(compiledStatement, 7, newQuiz.quizId);
			
			if(SQLITE_DONE != sqlite3_step(compiledStatement)) {
				NSLog(@"QuizzesDAO.updateQuizForUser: Error while update data: '%s'", sqlite3_errmsg(database));
				sqlite3_finalize(compiledStatement);
				sqlite3_close(database);
				return FALSE;
			}//end if
		}//end if
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return TRUE;
}//end method

@end
