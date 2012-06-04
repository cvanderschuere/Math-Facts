//
//  QuestionSetsDAOTest.m
//  poacMF
//
//  Created by Matt Hunter on 3/21/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuestionSetsDAOTest.h"
#import "QuestionSetsDAO.h"
#import "QuestionSet.h"
#import "AppConstants.h"


@implementation QuestionSetsDAOTest


#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    //id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    //STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)setUp {
    [super setUp];
	/* Uncomment this and run this test in order to populate the QuestionSets Table in the database 
	NSLog(@"\n\n\n\n\n\n\n**********************************************\n\n\n\n\n");
	NSArray *alphabet = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",
		@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",
		@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
	
    // Set-up code here.
	QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	for (int count=0; count < 4; count++) {
		if (ADDITION_MATH_TYPE == count){
			for (int setName=0; setName < 26; setName++)
				[qsDAO addQuestionSet:[alphabet objectAtIndex:setName] forMathType:ADDITION_MATH_TYPE withSetOrder:setName];
		}// end fi
		if (SUBTRACTION_MATH_TYPE == count) {
			for (int setName=0; setName < 24; setName++)
				[qsDAO addQuestionSet:[alphabet objectAtIndex:setName] forMathType:SUBTRACTION_MATH_TYPE withSetOrder:setName];
		}// end fi
		if (MULTIPLICATION_MATH_TYPE == count) {
			for (int setName=0; setName < 20; setName++)
				[qsDAO addQuestionSet:[alphabet objectAtIndex:setName] forMathType:MULTIPLICATION_MATH_TYPE withSetOrder:setName];
		}// end fi
		if (DIVISION_MATH_TYPE == count) {
			for (int setName=0; setName < 20; setName++)
				[qsDAO addQuestionSet:[alphabet objectAtIndex:setName] forMathType:DIVISION_MATH_TYPE withSetOrder:setName];
		}// end fi
		
	}//end for loop
	[qsDAO release];
	 
	 */
}//end method

- (void) testGetAllSets {
	QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	NSArray *questionSetsNSA = [qsDAO getAllSets];
	//NSLog(@"questionSetsNSA %s", [[questionSetsNSA description] UTF8String]);
	STAssertNotNil(questionSetsNSA,@"getAllSets Failed");
}//end method

-(void) testGetSetByMathType {
	QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	NSArray *questionSetsNSA = [qsDAO getSetByMathType:DIVISION_MATH_TYPE];
	NSLog(@"testGetSetByMathType.questionSetsNSA %s", [[questionSetsNSA description] UTF8String]);
	STAssertNotNil(questionSetsNSA,@"testGetSetByMathType Failed");
}//end method

-(void) testGetQuestionSetById {
	QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	QuestionSet *qs = [qsDAO getQuestionSetById:5];
	//NSLog(@"QuestionSet %s", [[qs description] UTF8String]);
	STAssertNotNil(qs,@"testGetQuestionSetById Failed");
}//end method

-(void) testgetQuestionSetBySetOrderAndMathType {
	QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	QuestionSet *qs = [qsDAO getQuestionSetBySetOrder:5 andMathType:0];
	NSLog(@"QuestionSet %s", [[qs description] UTF8String]);
	STAssertNotNil(qs,@"testgetQuestionSetBySetOrderAndMathType Failed");
}//end method

#endif

@end
