//
//  UsersDAO.m
//  poacMF
//
//  Created by Matt Hunter on 3/18/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "UsersDAO.h"

@implementation UsersDAO

#pragma mark Authentication / Authorization

-(BOOL) loginUserWithUserName: (NSString *) userName andPassword: (NSString *) password {
	sqlite3 *database;
	BOOL validUser = FALSE;
	NSString *u = [userName lowercaseString];
	NSString *p = [password lowercaseString];
	// Open the database from the users filessytem
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT userId FROM users WHERE username = ? and password = ?";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_text(compiledStatement, 1, [u UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 2, [p UTF8String], -1, SQLITE_TRANSIENT);
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				int x = -1;
				x = sqlite3_column_int(compiledStatement, 0);
				if (x > 0)
					validUser = TRUE;
			}//end while
		}//end if
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return validUser;
}//end method

#pragma mark Get Methods
-(User *) getUserInformation : (NSString *) userName {
	User *newUser = [[[User alloc] init] autorelease];
	NSString *u = [userName lowercaseString];
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT userId, firstName, lastName, userType, email, defaultTimeLimit, password, delayRetake, defaultTimedTimeLimit FROM users WHERE username = ?";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_text(compiledStatement, 1, [u UTF8String], -1, SQLITE_TRANSIENT);
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				newUser.username = userName;
				newUser.userId = sqlite3_column_int(compiledStatement, 0);
				if (nil != sqlite3_column_text(compiledStatement, 1))
					newUser.firstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				if (nil != sqlite3_column_text(compiledStatement, 2))
					newUser.lastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				newUser.userType = sqlite3_column_int(compiledStatement, 3);
				if (nil != sqlite3_column_text(compiledStatement, 4))
					newUser.emailAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)]; 
				newUser.defaultPracticeTimeLimit = sqlite3_column_double(compiledStatement, 5);
				if (nil != sqlite3_column_text(compiledStatement, 6))
					newUser.password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
				newUser.delayRetake = sqlite3_column_double(compiledStatement, 7);
				newUser.defaultTimedTimeLimit = sqlite3_column_double(compiledStatement, 8);
			}//end while
		} else {
			NSLog(@"UsersDAO.getUserInformation: Select error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return newUser;
}//end method

-(NSMutableArray *)	getAllUsers {
	NSMutableArray *uNSMA = [NSMutableArray array];
	
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT userId, username, firstName, lastName, userType, email,defaultTimeLimit, password, delayRetake,defaultTimedTimeLimit FROM users order by lastName, firstName";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				User *qs = [[User alloc] init];
				qs.userId = sqlite3_column_int(compiledStatement, 0);
				if (nil != sqlite3_column_text(compiledStatement, 1))
					qs.username = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				if (nil != sqlite3_column_text(compiledStatement, 2))
					qs.firstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				if (nil != sqlite3_column_text(compiledStatement, 3))
					qs.lastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
				qs.userType = sqlite3_column_int(compiledStatement, 4);
				if (nil != sqlite3_column_text(compiledStatement, 5))
					qs.emailAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
				qs.defaultPracticeTimeLimit = sqlite3_column_double(compiledStatement, 6);
				if (nil != sqlite3_column_text(compiledStatement, 7))
					qs.password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
				qs.delayRetake = sqlite3_column_double(compiledStatement, 8);
				qs.defaultTimedTimeLimit = sqlite3_column_double(compiledStatement, 9);
				[uNSMA addObject:qs];
				[qs autorelease];
			}//end while
		} else {
			NSLog(@"UsersDAO.getAllUsers: Select error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return uNSMA;
}//end method

#pragma mark Add user
-(int) addUser: (User *) newUser {
	int newUserId = -1;
	newUser.username = [newUser.username lowercaseString];
	newUser.password = [newUser.password lowercaseString];
	
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "INSERT INTO Users (username, password, firstName, lastName, userType, email, defaultTimeLimit, delayRetake,defaultTimedTimeLimit) values (?,?,?,?,?,?,?,?,?)";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if(returnValue == SQLITE_OK) {
			sqlite3_bind_text(compiledStatement, 1, [newUser.username UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 2, [newUser.password UTF8String], -1, SQLITE_TRANSIENT);	
			sqlite3_bind_text(compiledStatement, 3, [newUser.firstName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 4, [newUser.lastName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(compiledStatement, 5, newUser.userType);
			sqlite3_bind_text(compiledStatement, 6, [newUser.emailAddress UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_double(compiledStatement, 7, newUser.defaultPracticeTimeLimit);
			sqlite3_bind_double(compiledStatement, 8, newUser.delayRetake);
			sqlite3_bind_double(compiledStatement, 9, newUser.defaultTimedTimeLimit);
			
			if(SQLITE_DONE != sqlite3_step(compiledStatement))
				NSLog(@"UsersDAO.addUser: Error while inserting data: '%s'", sqlite3_errmsg(database));
			
			int x = sqlite3_last_insert_rowid(database);
			if (x > 0)
				newUserId = x;
		}//end if
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return newUserId;
}//end method

#pragma mark Delete Methods
-(BOOL) deleteUserById: (int) userId {
	BOOL deleted=FALSE;
	sqlite3 *database;
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "DELETE FROM users WHERE userId = ?";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_int(compiledStatement, 1, userId);
			if(SQLITE_DONE != sqlite3_step(compiledStatement))	
				NSLog(@"UsersDAO.deleteUserById:error while deleting: %s", sqlite3_errmsg(database));
			else
				deleted = TRUE;
		} else {
			NSLog(@"UsersDAO.deleteUserById.A: Prepare statement error: %s", sqlite3_errmsg(database) );
		}
		
		sqlite3_reset(compiledStatement);
		sqlStatement = "DELETE FROM QUIZZES where userId = ?";	
		returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if(returnValue == SQLITE_OK) {	
			sqlite3_bind_int(compiledStatement, 1, userId);
			if(SQLITE_DONE != sqlite3_step(compiledStatement))	
				NSLog(@"UsersDAO.deleteUserById.B: Prepare statement error: %s", sqlite3_errmsg(database) );
		}//
		
		sqlite3_reset(compiledStatement);
		sqlStatement = "DELETE FROM RESULTS where userId = ?";	
		returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if(returnValue == SQLITE_OK) {	
			sqlite3_bind_int(compiledStatement, 1, userId);
			if(SQLITE_DONE != sqlite3_step(compiledStatement))	
				NSLog(@"UsersDAO.deleteUserById.C: Prepare statement error: %s", sqlite3_errmsg(database) );
		}//
		
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return deleted;
}//end method

#pragma mark Update Methods
-(BOOL) updateUser: (User *) updateUser {
	BOOL updated=FALSE;
	sqlite3 *database;
	updateUser.username = [updateUser.username lowercaseString];
	updateUser.password = [updateUser.password lowercaseString];
	if(sqlite3_open([super.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "UPDATE users set username=?,password=?,firstName=?,lastName=?,userType=?,email=?, defaultTimeLimit=?, delayRetake=?, defaultTimedTimeLimit=? WHERE userId = ?";
		sqlite3_stmt *compiledStatement;
		int returnValue =sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if (returnValue == SQLITE_OK) {
			sqlite3_bind_text(compiledStatement, 1, [updateUser.username UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 2, [updateUser.password UTF8String], -1, SQLITE_TRANSIENT);	
			sqlite3_bind_text(compiledStatement, 3, [updateUser.firstName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStatement, 4, [updateUser.lastName UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(compiledStatement, 5, updateUser.userType);
			sqlite3_bind_text(compiledStatement, 6, [updateUser.emailAddress UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_double(compiledStatement, 7, updateUser.defaultPracticeTimeLimit);
			sqlite3_bind_double(compiledStatement, 8, updateUser.delayRetake);
			sqlite3_bind_double(compiledStatement, 9, updateUser.defaultTimedTimeLimit);
			sqlite3_bind_int(compiledStatement, 10, updateUser.userId);
			if(SQLITE_DONE != sqlite3_step(compiledStatement))	
				NSLog(@"UsersDAO.updateUser:error while updating: %s", sqlite3_errmsg(database));
			else
				updated = TRUE;
		} else {
			NSLog(@"UsersDAO.updateUser: Prepare statement error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}//end if
	return updated;
}//end method

@end
