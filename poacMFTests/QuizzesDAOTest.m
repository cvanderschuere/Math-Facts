//
//  QuizzesDAOTest.m
//  poacMF
//
//  Created by Matt Hunter on 3/29/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuizzesDAOTest.h"
#import "QuizzesDAO.h"

@implementation QuizzesDAOTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle


- (void) testGetAllQuizzesByUserId {
	QuizzesDAO *qsDAO = [[QuizzesDAO alloc] init];
	NSArray *allQuizzesNSA = [qsDAO getAllQuizzesByUserId:3];
	NSLog(@"allQuizzesNSA %s", [[allQuizzesNSA description] UTF8String]);
	[qsDAO release];
	STAssertNotNil(allQuizzesNSA,@"testGetAllQuizzesByUserId Failed");
}//end method

- (void) testGetAvailablePracticeQuizzesByUserId {
	QuizzesDAO *qsDAO = [[QuizzesDAO alloc] init];
	NSArray *allAvailableQuizzesNSA = [qsDAO getAvailablePracticeQuizzesByUserId:3];
	NSLog(@"allAvailableQuizzesNSA.count %i", [allAvailableQuizzesNSA count]);
	[qsDAO release];
	STAssertNotNil(allAvailableQuizzesNSA,@"testGetAvailablePracticeQuizzesByUserId Failed");
}//end method

#endif

@end
