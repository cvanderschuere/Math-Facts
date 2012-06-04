//
//  AppLibraryTest.m
//  poacMF
//
//  Created by Matt Hunter on 5/11/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "AppLibraryTest.h"
#import "UsersDAO.h"
#import "ResultsDAO.h"
#import "AppLibrary.h"

@implementation AppLibraryTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

-(void)testMatchAndCountUsersToDetails {
    
	UsersDAO *uDAO = [[UsersDAO alloc] init];
	NSMutableArray *listOfUsers = [uDAO getAllUsers];
	[uDAO release];
	
	if (nil == listOfUsers)
		listOfUsers = [NSMutableArray array];
	
	ResultsDAO *rDAO = [[ResultsDAO alloc] init];
	NSMutableArray *listOfResults = [rDAO getAllResults];
	[rDAO release];
	
	if (nil == listOfResults)
		listOfResults = [NSMutableArray array];
	
	AppLibrary *al = [[AppLibrary alloc] init];
	NSDictionary *detailsCountForUsers = [al matchAndCountUsers: listOfUsers toDetails:listOfResults];
	[al release];
	
	NSLog(@"AppLibraryTest.testMatchAndCountUsersToDetails: %s", [[detailsCountForUsers description] UTF8String]);
	
	STAssertNotNil(detailsCountForUsers, @"testMatchAndCountUsersToDetails succeeded" );
    
}//end method

#endif

@end
