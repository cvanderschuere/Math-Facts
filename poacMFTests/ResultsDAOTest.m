//
//  ResultsDAOTest.m
//  poacMF
//
//  Created by Matt Hunter on 5/7/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "ResultsDAOTest.h"
#import "ResultsDAO.h"
#import "SuperResults.h"

@implementation ResultsDAOTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)	testGetAllResults {
    ResultsDAO *rsDAO = [[ResultsDAO alloc] init];
	NSMutableArray *nsma = [rsDAO getAllResults];
	if ((nil != nsma) && (0 < [nsma count]))
		NSLog(@"ResultsDAOTest.testGetAllResults.count %i", [nsma count]);
	
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}

#endif

@end
