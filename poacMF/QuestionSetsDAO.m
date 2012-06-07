//
//  QuestionSets.m
//  poacMF
//
//  Created by Matt Hunter on 3/21/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuestionSetsDAO.h"
#import "QuestionSetDetailsDAO.h"
#import "QuestionSet.h"


@implementation QuestionSetsDAO

-(int) addQuestionSet: (NSString *) setName forMathType: (int) mathType withSetOrder: (int) setOrder {
    sqlite3 *sqlDatabase;

	if(sqlite3_open([super.databasePath UTF8String], &sqlDatabase) != SQLITE_OK) {
		return -1;
	}//end if
	int setId = 0;
	
	sqlite3_stmt *compiledStatement;
	char *sqlStatement;
	int returnValue=0;
	
	if (0 == setOrder) {
		sqlStatement = "select max(setOrder) from QuestionSets where mathType = ?";
		returnValue = sqlite3_prepare_v2(sqlDatabase, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, mathType);
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
				setOrder = sqlite3_column_int(compiledStatement, 0);
		}//
		sqlite3_reset(compiledStatement);
	}//end method
	
	sqlStatement = "insert into QuestionSets (setName, mathType,setOrder) values (?,?,?)";
	returnValue = sqlite3_prepare_v2(sqlDatabase, sqlStatement, -1, &compiledStatement, NULL);
	if(returnValue == SQLITE_OK) {
		sqlite3_bind_text(compiledStatement, 1, [setName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(compiledStatement, 2, mathType);
		sqlite3_bind_int(compiledStatement, 3, setOrder);
		if(SQLITE_DONE != sqlite3_step(compiledStatement))	
			NSLog(@"QuestionSetsDAO.addQuestionSet Error.A: '%s'", sqlite3_errmsg(sqlDatabase));
		else
			setId = sqlite3_last_insert_rowid(sqlDatabase);
	} else {
		NSLog(@"QuestionSetsDAO.addQuestionSet: Error.B...'%s'", sqlite3_errmsg(sqlDatabase));
	}
	sqlite3_finalize(compiledStatement);
	sqlite3_close(sqlDatabase);
	return setId;
}//end method


-(NSMutableArray *) getAllSets {
    
	NSMutableArray *qsNSMA = [NSMutableArray array];
    /*
	QuestionSetDetailsDAO *qsdDAO = [[QuestionSetDetailsDAO alloc] init];
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT setId, setName, mathType, setOrder FROM QuestionSets order by mathType, setOrder";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				QuestionSet *qs = [[QuestionSet alloc] init];
				qs.setId = sqlite3_column_int(compiledStatement, 0);
				if (nil != sqlite3_column_text(compiledStatement, 1))
					qs.questionSetName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				qs.mathType = sqlite3_column_int(compiledStatement, 2);
				qs.setOrder = sqlite3_column_int(compiledStatement, 3);
				
				//get the details!
				qs.setDetailsNSMA = [qsdDAO getDetailSetForSetId:qs.setId];
				
				[qsNSMA addObject:qs];
			}//end while
		} else {
			NSLog(@"QuestionSetsDAO.getAllSets: Select error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if*/
	return qsNSMA;
}//end method


-(NSMutableArray *) getSetByMathType: (int) mathType {
	NSMutableArray *qsNSMA = [NSMutableArray array];
    /*
	QuestionSetDetailsDAO *qsdDAO = [[QuestionSetDetailsDAO alloc] init];
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT setId, setName, mathType, setOrder FROM QuestionSets where mathType = ? order by mathType, setOrder";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, mathType);
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				QuestionSet *qs = [[QuestionSet alloc] init];
				qs.setId = sqlite3_column_int(compiledStatement, 0);
				if (nil != sqlite3_column_text(compiledStatement, 1))
					qs.questionSetName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				qs.mathType = sqlite3_column_int(compiledStatement, 2);
				qs.setOrder = sqlite3_column_int(compiledStatement, 3);
				
				//get the details!
				qs.setDetailsNSMA = [qsdDAO getDetailSetForSetId:qs.setId];
				
				[qsNSMA addObject:qs];
			}//end while
		} else {
			NSLog(@"QuestionSetsDAO.getAllSets: Select error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
     */
	return qsNSMA;
	
}//end method


-(QuestionSet *) getQuestionSetById: (int) setId {
    /*
	QuestionSet *qs = [[QuestionSet alloc] init];
	QuestionSetDetailsDAO *qsdDAO = [[QuestionSetDetailsDAO alloc] init];
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT setId, setName, mathType, setOrder FROM QuestionSets where setId = ? order by mathType, setOrder";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, setId);
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				qs.setId = sqlite3_column_int(compiledStatement, 0);
				if (nil != sqlite3_column_text(compiledStatement, 1))
					qs.questionSetName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				qs.mathType = sqlite3_column_int(compiledStatement, 2);
				qs.setOrder = sqlite3_column_int(compiledStatement, 3);
				
				//get the details!
				qs.setDetailsNSMA = [qsdDAO getDetailSetForSetId:qs.setId];
			}//end while
		} else {
			NSLog(@"QuestionSetsDAO.getQuestionSetById: Select error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return qs;
    */
}//end method

-(QuestionSet *) getQuestionSetBySetOrder: (int) nextSetOrder andMathType: (int) mathType {
    /*
	QuestionSet *qs = [[QuestionSet alloc] init];
	QuestionSetDetailsDAO *qsdDAO = [[QuestionSetDetailsDAO alloc] init];
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT setId, setName, mathType, setOrder FROM QuestionSets where setOrder >= ? and mathType = ? order by setOrder";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, nextSetOrder);
			sqlite3_bind_int(compiledStatement, 2, mathType);
			if (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				qs.setId = sqlite3_column_int(compiledStatement, 0);
				if (nil != sqlite3_column_text(compiledStatement, 1))
					qs.questionSetName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				qs.mathType = sqlite3_column_int(compiledStatement, 2);
				qs.setOrder = sqlite3_column_int(compiledStatement, 3);
				
				//get the details!
				qs.setDetailsNSMA = [qsdDAO getDetailSetForSetId:qs.setId];
			}//end if
		} else {
			NSLog(@"QuestionSetsDAO.getQuestionSetBySetOrderandMathType: Select error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return qs;
     */
}//end method

-(BOOL)	deleteQuestionSetById: (int) setId {
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "DELETE FROM QuestionSets where setId = ?";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, setId);
			
			if(SQLITE_DONE != sqlite3_step(compiledStatement)){
				NSLog(@"QuestionSetsDAO.deleteQuestionSetById: Error: '%s'", sqlite3_errmsg(database));
				return FALSE;
			}
		} else {
			NSLog(@"QuestionSetsDAO.deleteQuestionSetById: DELETE error: %s", sqlite3_errmsg(database) );
			return FALSE;
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	
	QuestionSetDetailsDAO *qsDAO = [[QuestionSetDetailsDAO alloc] init];
	[qsDAO deleteDetailSetForSetId: setId];
	return TRUE;
}//end method

@end
