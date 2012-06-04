//
//  SuperResults.m
//  poacMF
//
//  Created by Matt Hunter on 5/7/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "SuperResults.h"


@implementation SuperResults

@synthesize userId,setName, setId,requiredTimeLimit,requiredCorrect,requiredTotalQuestions,testType;
@synthesize mathType,resultsTestDate,resultsPassFail,resultsTimeTaken, resultsTotalQuestions,resultsCorrect;

#pragma mark Memory Management
- (void)dealloc {
	
	[resultsTestDate release];
	[resultsPassFail release];
	[setName release];
	[super dealloc];
}//end method

@end
