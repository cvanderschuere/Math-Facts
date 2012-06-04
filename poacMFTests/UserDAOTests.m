//
//  UserDAOTests.m
//  poacMF
//
//  Created by Matt Hunter on 3/18/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "UserDAOTests.h"
#import "UsersDAO.h"
#import "User.h"
#import "AppConstants.h"


@implementation UserDAOTests

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    //id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    //STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)setUp {
    [super setUp];
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    [super tearDown];
}

- (void)testLoginUserWithUserNameandPassword {
    UsersDAO *uDAO = [[UsersDAO alloc] init];
	BOOL success = [uDAO  loginUserWithUserName: @"admin" andPassword:@"poacMF"];
	STAssertTrue(success,@"UserDAOTests.testLoginUserWithUserNameandPassword");
	[uDAO release];
}//end method

- (void) testGetUserInformation {
    UsersDAO *uDAO = [[UsersDAO alloc] init];
	User *user = [uDAO getUserInformation:@"admin"];
	if (
		([user.username isEqualToString:@"admin"]) && 
		(ADMIN_USER_TYPE == user.userType) &&
		([user.firstName isEqualToString:@"admin"])) {
		
		STAssertTrue(TRUE,@"UserDAOTests.testGetUserInformation");
	} else
		STAssertTrue(FALSE,@"UserDAOTests.testGetUserInformation");
	[uDAO release];
}//end method

- (void) testGetAddUser {
	User *newUser = [[User alloc] init];
	newUser.username = @"testUser";
	newUser.firstName = @"Test";
	newUser.lastName = @"User";
	newUser.password = @"testUser";
	newUser.emailAddress = @"moo@foo.com";
	newUser.defaultTimedTimeLimit = 60;
	newUser.defaultPracticeTimeLimit = 60;
	newUser.userType = STUDENT_USER_TYPE;
	UsersDAO *uDAO = [[UsersDAO alloc] init];
	newUser.userId = [uDAO addUser: newUser];
	STAssertTrue(0 < newUser.userId,@"UserDAOTests.testGetAddUser");
	[uDAO deleteUserById:newUser.userId];
	[uDAO release];
}//end method

- (void) testDeleteUserById {
	User *newUser = [[User alloc] init];
	newUser.username = @"testUser";
	newUser.firstName = @"Test";
	newUser.lastName = @"User";
	newUser.password = @"testUser";
	newUser.emailAddress = @"moo@foo.com";
	newUser.userType = STUDENT_USER_TYPE;
	UsersDAO *uDAO = [[UsersDAO alloc] init];
	newUser.userId = [uDAO addUser: newUser];
	BOOL results = [uDAO deleteUserById:newUser.userId];
	[uDAO release];
	STAssertTrue(results,@"UserDAOTests.testDeleteUserById");
}//end method

- (void) testGetAllUsers {
	UsersDAO *uDAO = [[UsersDAO alloc] init];
	NSMutableArray *usersNSMA = [uDAO getAllUsers];
	[uDAO release];
	STAssertTrue(0 < [usersNSMA count],@"UserDAOTests.testGetAllUsers");
}//end method

#endif


@end
