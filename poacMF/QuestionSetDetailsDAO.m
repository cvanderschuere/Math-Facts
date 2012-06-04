//
//  QuestionSetDetailsDAO.m
//  poacMF
//
//  Created by Matt Hunter on 3/21/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuestionSetDetailsDAO.h"
#import "QuestionSetDetail.h"

@implementation QuestionSetDetailsDAO

-(int) addDetailsById: (int) setId andXValue: (int) xValue andYValue: (int) yValue {
    sqlite3 *sqlDatabase;
	int detailId=0;
	if(sqlite3_open([super.databasePath UTF8String], &sqlDatabase) != SQLITE_OK) {
		return -1;
	}//end if
	
	sqlite3_stmt *compiledStatement;
	char *sqlStatement = "insert into QuestionSetDetails (setId,xValue,yValue) values (?,?,?)";
	int returnValue =sqlite3_prepare_v2(sqlDatabase, sqlStatement, -1, &compiledStatement, NULL);
	
	if(returnValue == SQLITE_OK) {
		sqlite3_bind_int(compiledStatement, 1, setId);
		sqlite3_bind_int(compiledStatement, 2, xValue);
		sqlite3_bind_int(compiledStatement, 3, yValue);
		
		if(SQLITE_DONE != sqlite3_step(compiledStatement))	
			NSLog(@"QuestionSetDetailsDAO.addDetailsById Error.A: '%s'", sqlite3_errmsg(sqlDatabase));
		else
			detailId = sqlite3_last_insert_rowid(sqlDatabase);
	} else {
		NSLog(@"QuestionSetDetailsDAO.addDetailsById: Error.B...'%s'", sqlite3_errmsg(sqlDatabase));
	}
    
	sqlite3_finalize(compiledStatement);
	return detailId;
	sqlite3_close(sqlDatabase);
}//end method

-(NSMutableArray *) getAllDetailSets {
	NSMutableArray *qsNSMA = [NSMutableArray array];
	
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT detailId, setId, xValue, yValue FROM QuestionSetDetails order by setId, detailId";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				QuestionSetDetail *qs = [[QuestionSetDetail alloc] init];
				qs.detailId = sqlite3_column_int(compiledStatement, 0);
				qs.setId  = sqlite3_column_int(compiledStatement, 1);
				qs.xValue = sqlite3_column_int(compiledStatement, 2);
				qs.yValue = sqlite3_column_int(compiledStatement, 3);
				[qsNSMA addObject:qs];
				[qs autorelease];
			}//end while
		} else {
			NSLog(@"QuestionSetDetailsDAO.getAllDetailSets: Select error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return qsNSMA;
}//end method

-(NSMutableArray *) getDetailSetForSetId: (int) setId {
	NSMutableArray *qsNSMA = [NSMutableArray array];
	
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT detailId, setId, xValue, yValue FROM QuestionSetDetails where setId = ? order by detailid";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, setId);
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				QuestionSetDetail *qs = [[QuestionSetDetail alloc] init];
				qs.detailId = sqlite3_column_int(compiledStatement, 0);
				qs.setId  = sqlite3_column_int(compiledStatement, 1);
				qs.xValue = sqlite3_column_int(compiledStatement, 2);
				qs.yValue = sqlite3_column_int(compiledStatement, 3);
				[qsNSMA addObject:qs];
				[qs autorelease];
			}//end while
		} else {
			NSLog(@"QuestionSetDetailsDAO.getDetailSetForSetId: Select error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return qsNSMA;
}//end method

-(BOOL)	deleteDetailSetForDetailId: (int) detailId {
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "DELETE FROM QuestionSetDetails where detailId = ?";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, detailId);
			if(SQLITE_DONE != sqlite3_step(compiledStatement)){
				NSLog(@"QuestionSetDetailsDAO.deleteDetailSetForDetailId: Error: '%s'", sqlite3_errmsg(database));
				return FALSE;
			}
		} else {
			NSLog(@"QuestionSetDetailsDAO.deleteDetailSetForDetailId: DELETE error: %s", sqlite3_errmsg(database) );
			return FALSE;
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return TRUE;
}//end method

-(BOOL)	deleteDetailSetForSetId: (int) setId {
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "DELETE FROM QuestionSetDetails where setID = ?";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, setId);
			if(SQLITE_DONE != sqlite3_step(compiledStatement)){
				NSLog(@"QuestionSetDetailsDAO.deleteDetailSetForDetailId: Error: '%s'", sqlite3_errmsg(database));
				return FALSE;
			}
		} else {
			NSLog(@"QuestionSetDetailsDAO.deleteDetailSetForDetailId: DELETE error: %s", sqlite3_errmsg(database) );
			return FALSE;
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return TRUE;
}//end method

@end
