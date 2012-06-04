//
//  QuestionSetDetailsDAOTest.m
//  poacMF
//
//  Created by Matt Hunter on 3/21/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuestionSetDetailsDAOTest.h"
#import "QuestionSetsDAO.h"
#import "QuestionSetDetailsDAO.h"
#import "QuestionSet.h"
#import "AppConstants.h"

@implementation QuestionSetDetailsDAOTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)setUp {
    [super setUp];
	/* Uncomment this and run this test in order to populate the QuestionSets Table in the database ensure only
		one set of other tests are uncommented, otherwise this will get run for every test you have in this file.
	 NSLog(@"\n\n\n\n\n\n\n****************QuestionSetDetailsDAOTest******************************\n\n\n\n\n");

	 QuestionSetsDAO *qsDAO = [[QuestionSetsDAO alloc] init];
	 QuestionSetDetailsDAO *qsdDAO = [[QuestionSetDetailsDAO alloc] init];
	 
	 NSArray *questionSetsNSA = [qsDAO getAllSets];
	 for (QuestionSet *qs in questionSetsNSA) {
		 NSLog(@"QuestionSet: %s", [[qs description] UTF8String]);
		if (ADDITION_MATH_TYPE == qs.mathType){
			if ([qs.questionSetName isEqualToString:@"A"]){
				for (int xValue = 0; xValue < 11; xValue++)
					[qsdDAO addDetailsById: qs.setId andXValue: xValue andYValue: 0];
			}//end set
			if ([qs.questionSetName isEqualToString:@"B"]){
				[qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 1];
				[qsdDAO addDetailsById: qs.setId andXValue: 1 andYValue: 2];
				[qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 1];
				[qsdDAO addDetailsById: qs.setId andXValue: 1 andYValue: 2];
			}//end set
			if ([qs.questionSetName isEqualToString:@"C"]){
				[qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 1];
				[qsdDAO addDetailsById: qs.setId andXValue: 1 andYValue: 4];
				[qsdDAO addDetailsById: qs.setId andXValue: 1 andYValue: 1];
			}//end set
			if ([qs.questionSetName isEqualToString:@"D"]){
				[qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 1];
				[qsdDAO addDetailsById: qs.setId andXValue: 1 andYValue: 5];
				[qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 2];
			}//end set
			if ([qs.questionSetName isEqualToString:@"E"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 6 andYValue: 1];
				[qsdDAO addDetailsById: qs.setId  andXValue: 1 andYValue: 6];
				[qsdDAO addDetailsById: qs.setId  andXValue: 3 andYValue: 3];
			}//end set
			if ([qs.questionSetName isEqualToString:@"F"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 7 andYValue: 1];
				[qsdDAO addDetailsById: qs.setId  andXValue: 1 andYValue: 7];
				[qsdDAO addDetailsById: qs.setId  andXValue: 4 andYValue: 4];
			}//end set
			if ([qs.questionSetName isEqualToString:@"G"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 8 andYValue: 1];
				[qsdDAO addDetailsById: qs.setId  andXValue: 1 andYValue: 8];
				[qsdDAO addDetailsById: qs.setId  andXValue: 5 andYValue: 5];
			}//end set
			if ([qs.questionSetName isEqualToString:@"H"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 9 andYValue: 1];
				[qsdDAO addDetailsById: qs.setId  andXValue: 1 andYValue: 9];
				[qsdDAO addDetailsById: qs.setId  andXValue: 6 andYValue: 6];
			}//end set
			if ([qs.questionSetName isEqualToString:@"I"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 2 andYValue: 3];
				[qsdDAO addDetailsById: qs.setId  andXValue: 3 andYValue: 2];
				[qsdDAO addDetailsById: qs.setId  andXValue: 7 andYValue: 7];
			}//end set
			if ([qs.questionSetName isEqualToString:@"J"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 4 andYValue: 2];
				[qsdDAO addDetailsById: qs.setId  andXValue: 2 andYValue: 4];
				[qsdDAO addDetailsById: qs.setId  andXValue: 8 andYValue: 8];
			}//end set
			if ([qs.questionSetName isEqualToString:@"K"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 5 andYValue: 2];
				[qsdDAO addDetailsById: qs.setId  andXValue: 2 andYValue: 5];
				[qsdDAO addDetailsById: qs.setId  andXValue: 9 andYValue: 9];
			}//end set
			if ([qs.questionSetName isEqualToString:@"L"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 6 andYValue: 2];
				[qsdDAO addDetailsById: qs.setId  andXValue: 2 andYValue: 6];
				[qsdDAO addDetailsById: qs.setId  andXValue: 9 andYValue: 9];
			}//end set
			if ([qs.questionSetName isEqualToString:@"M"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 7 andYValue: 2];
				[qsdDAO addDetailsById: qs.setId  andXValue: 2 andYValue: 7];
				[qsdDAO addDetailsById: qs.setId  andXValue: 4 andYValue: 7];
				[qsdDAO addDetailsById: qs.setId  andXValue: 7 andYValue: 4];
			}//end set
			if ([qs.questionSetName isEqualToString:@"N"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 8 andYValue: 2];
				[qsdDAO addDetailsById: qs.setId  andXValue: 2 andYValue: 8];
				[qsdDAO addDetailsById: qs.setId  andXValue: 6 andYValue: 8];
				[qsdDAO addDetailsById: qs.setId  andXValue: 8 andYValue: 6];
			}//end set
			if ([qs.questionSetName isEqualToString:@"O"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 9 andYValue: 2];
				[qsdDAO addDetailsById: qs.setId  andXValue: 2 andYValue: 9];
				[qsdDAO addDetailsById: qs.setId  andXValue: 6 andYValue: 8];
				[qsdDAO addDetailsById: qs.setId  andXValue: 8 andYValue: 6];
			}//end set
			if ([qs.questionSetName isEqualToString:@"P"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 4 andYValue: 3];
				[qsdDAO addDetailsById: qs.setId  andXValue: 3 andYValue: 4];
				[qsdDAO addDetailsById: qs.setId  andXValue: 6 andYValue: 7];
				[qsdDAO addDetailsById: qs.setId  andXValue: 7 andYValue: 6];
			}//end set
			if ([qs.questionSetName isEqualToString:@"Q"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 5 andYValue: 3];
				[qsdDAO addDetailsById: qs.setId  andXValue: 3 andYValue: 5];
				[qsdDAO addDetailsById: qs.setId  andXValue: 7 andYValue: 8];
				[qsdDAO addDetailsById: qs.setId  andXValue: 8 andYValue: 7];
			}//end set
			if ([qs.questionSetName isEqualToString:@"R"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 5 andYValue: 8];
				[qsdDAO addDetailsById: qs.setId  andXValue: 8 andYValue: 5];
				[qsdDAO addDetailsById: qs.setId  andXValue: 7 andYValue: 9];
				[qsdDAO addDetailsById: qs.setId  andXValue: 9 andYValue: 7];
			}//end set
			if ([qs.questionSetName isEqualToString:@"S"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 6 andYValue: 3];
				[qsdDAO addDetailsById: qs.setId  andXValue: 3 andYValue: 6];
				[qsdDAO addDetailsById: qs.setId  andXValue: 5 andYValue: 9];
				[qsdDAO addDetailsById: qs.setId  andXValue: 9 andYValue: 5];
			}//end set
			if ([qs.questionSetName isEqualToString:@"T"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 7 andYValue: 3];
				[qsdDAO addDetailsById: qs.setId  andXValue: 3 andYValue: 7];
				[qsdDAO addDetailsById: qs.setId  andXValue: 8 andYValue: 9];
				[qsdDAO addDetailsById: qs.setId  andXValue: 9 andYValue: 8];
			}//end set
			if ([qs.questionSetName isEqualToString:@"U"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 8 andYValue: 3];
				[qsdDAO addDetailsById: qs.setId  andXValue: 3 andYValue: 8];
				[qsdDAO addDetailsById: qs.setId  andXValue: 4 andYValue: 9];
				[qsdDAO addDetailsById: qs.setId  andXValue: 9 andYValue: 4];
			}//end set
			if ([qs.questionSetName isEqualToString:@"V"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 9 andYValue: 3];
				[qsdDAO addDetailsById: qs.setId  andXValue: 3 andYValue: 9];
				[qsdDAO addDetailsById: qs.setId  andXValue: 5 andYValue: 7];
				[qsdDAO addDetailsById: qs.setId  andXValue: 7 andYValue: 5];
			}//end set
			if ([qs.questionSetName isEqualToString:@"W"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 4 andYValue: 5];
				[qsdDAO addDetailsById: qs.setId  andXValue: 5 andYValue: 4];
				[qsdDAO addDetailsById: qs.setId  andXValue: 4 andYValue: 8];
				[qsdDAO addDetailsById: qs.setId  andXValue: 8 andYValue: 4];
			}//end set
			if ([qs.questionSetName isEqualToString:@"X"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 4 andYValue: 6];
				[qsdDAO addDetailsById: qs.setId  andXValue: 6 andYValue: 4];
				[qsdDAO addDetailsById: qs.setId  andXValue: 5 andYValue: 6];
				[qsdDAO addDetailsById: qs.setId  andXValue: 6 andYValue: 5];
			}//end set
			if ([qs.questionSetName isEqualToString:@"Y"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 4 andYValue: 5];
				[qsdDAO addDetailsById: qs.setId  andXValue: 5 andYValue: 4];
				[qsdDAO addDetailsById: qs.setId  andXValue: 4 andYValue: 8];
				[qsdDAO addDetailsById: qs.setId  andXValue: 8 andYValue: 4];
			}//end set
			if ([qs.questionSetName isEqualToString:@"Z"]){
				[qsdDAO addDetailsById: qs.setId  andXValue: 4 andYValue: 6];
				[qsdDAO addDetailsById: qs.setId  andXValue: 6 andYValue: 4];
				[qsdDAO addDetailsById: qs.setId  andXValue: 5 andYValue: 6];
				[qsdDAO addDetailsById: qs.setId  andXValue: 6 andYValue: 5];
			}//end set
		}// end ADDITION
		 if (SUBTRACTION_MATH_TYPE == qs.mathType) {
			 if ([qs.questionSetName isEqualToString:@"A"]){
				for (int xValue = 0; xValue < 11; xValue++){
					 [qsdDAO addDetailsById: qs.setId andXValue: xValue andYValue: xValue];
					 [qsdDAO addDetailsById: qs.setId andXValue: xValue andYValue: 0];
				 }//end for
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"B"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 1];
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 1];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 3];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"C"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 1];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 4];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 1];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"D"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 1];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 5];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 2];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"E"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 1];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 3];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"F"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 1];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 7];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 4];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"G"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 1];
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 10 andYValue: 5];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"H"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 10 andYValue: 1];
				 [qsdDAO addDetailsById: qs.setId andXValue: 10 andYValue: 9];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"I"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 12 andYValue: 6];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"J"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 4];
				 [qsdDAO addDetailsById: qs.setId andXValue: 14 andYValue: 7];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"K"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 5];
				 [qsdDAO addDetailsById: qs.setId andXValue: 16 andYValue: 8];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"L"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 18 andYValue: 9];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"M"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 7];
				 [qsdDAO addDetailsById: qs.setId andXValue: 11 andYValue: 7];
				 [qsdDAO addDetailsById: qs.setId andXValue: 11 andYValue: 4];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"N"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 10 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 10 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 14 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 14 andYValue: 6];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"O"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 11 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 11 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 15 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 15 andYValue: 6];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"P"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 4];
				 [qsdDAO addDetailsById: qs.setId andXValue: 13 andYValue: 7];
				 [qsdDAO addDetailsById: qs.setId andXValue: 13 andYValue: 6];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"Q"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 5];
				 [qsdDAO addDetailsById: qs.setId andXValue: 15 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 15 andYValue: 7];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"R"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 13 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 13 andYValue: 5];
				 [qsdDAO addDetailsById: qs.setId andXValue: 16 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 16 andYValue: 7];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"S"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 14 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 14 andYValue: 5];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"T"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 10 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 10 andYValue: 7];
				 [qsdDAO addDetailsById: qs.setId andXValue: 17 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 17 andYValue: 8];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"U"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 11 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 11 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 13 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 13 andYValue: 4];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"V"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 12 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 12 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 12 andYValue: 7];
				 [qsdDAO addDetailsById: qs.setId andXValue: 12 andYValue: 5];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"W"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 5];
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 4];
				 [qsdDAO addDetailsById: qs.setId andXValue: 12 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 12 andYValue: 4];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"X"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 10 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 10 andYValue: 4];
				 [qsdDAO addDetailsById: qs.setId andXValue: 11 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 11 andYValue: 5];
			 }//end set
		}// end fi
		 if (MULTIPLICATION_MATH_TYPE == qs.mathType) {
			 if ([qs.questionSetName isEqualToString:@"A"]){
				 for (int xValue = 0; xValue < 11; xValue++){
					 [qsdDAO addDetailsById: qs.setId andXValue: xValue andYValue: 1];
				 }//end for
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"B"]){
				 for (int xValue = 0; xValue < 11; xValue++){
					 [qsdDAO addDetailsById: qs.setId andXValue: xValue andYValue: 0];
				 }//end for
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"C"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 2];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"D"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 4];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 5];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"E"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 7];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"F"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 2];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 9];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"G"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 4];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 9];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"H"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 5];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 3];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"I"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 4];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"J"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 7];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 5];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"K"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 9];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 6];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"L"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 4];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 7];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"M"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 5];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 8];
				 
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"N"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 9];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"O"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 7];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 3];
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 3];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"P"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 7];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 6];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"Q"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 5];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 4];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"R"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 7];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 5];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 7];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"S"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 4];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 7];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 5];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 6];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"T"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 4];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 5];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 4];
			 }//end set
		 }// end fi
		 if (DIVISION_MATH_TYPE == qs.mathType) {
			 if ([qs.questionSetName isEqualToString:@"A"]){
				 for (int yValue = 0; yValue < 9; yValue++){
					 [qsdDAO addDetailsById: qs.setId andXValue: 1 andYValue: yValue];
				 }//end for
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"B"]){
				 for (int yValue = 0; yValue < 9; yValue++){
					 [qsdDAO addDetailsById: qs.setId andXValue: yValue andYValue: yValue];
				 }//end for
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"C"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 6];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 4];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"D"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 8];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 10];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 10];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"E"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 12];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 12];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 14];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 14];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"F"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 16];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 16];
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 18];
				 [qsdDAO addDetailsById: qs.setId andXValue: 2 andYValue: 18];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"G"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 27];
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 27];
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 36];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 24];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"H"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 45];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 45];
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 9];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"I"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 54];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 45];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 16];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"J"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 63];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 63];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 25];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"K"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 72];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 72];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 36];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"L"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 12];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 12];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 49];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"M"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 15];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 15];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 64];
				 
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"N"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 18];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 18];
				 [qsdDAO addDetailsById: qs.setId andXValue: 9 andYValue: 81];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"O"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 21];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 21];
				 [qsdDAO addDetailsById: qs.setId andXValue: 3 andYValue: 24];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 24];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"P"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 56];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 56];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 48];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 48];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"Q"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 40];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 40];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 32];
				 [qsdDAO addDetailsById: qs.setId andXValue: 8 andYValue: 32];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"R"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 42];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 42];
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 35];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 35];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"S"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 7 andYValue: 28];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 28];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 30];
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 30];
			 }//end set
			 if ([qs.questionSetName isEqualToString:@"T"]){
				 [qsdDAO addDetailsById: qs.setId andXValue: 5 andYValue: 20];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 20];
				 [qsdDAO addDetailsById: qs.setId andXValue: 4 andYValue: 24];
				 [qsdDAO addDetailsById: qs.setId andXValue: 6 andYValue: 24];
			 }//end set
		}// end fi
	 
	 }//end for loop
	 	 
	 [qsdDAO release];
	 [qsDAO release];
  */
}//end method

- (void) testGetAllDetailSets {
	QuestionSetDetailsDAO *qsDAO = [[QuestionSetDetailsDAO alloc] init];
	NSArray *questionDetailSetsNSA = [qsDAO getAllDetailSets];
	//NSLog(@"questionDetailSetsNSA %s", [[questionDetailSetsNSA description] UTF8String]);
	STAssertNotNil(questionDetailSetsNSA,@"testGetAllDetailSets Failed");
}//end method

- (void)	testGetDetailSetForSetId {
	QuestionSetDetailsDAO *qsDAO = [[QuestionSetDetailsDAO alloc] init];
	NSArray *questionDetailSetsNSA = [qsDAO getDetailSetForSetId:1];
	//NSLog(@"testGetDetailSetForSetId.questionDetailSetsNSA %s", [[questionDetailSetsNSA description] UTF8String]);
	STAssertNotNil(questionDetailSetsNSA,@"testGetDetailSetForSetId Failed");
}//end method

#endif

@end
