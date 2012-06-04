//
//  Quiz.m
//  poacMF
//
//  Created by Matt Hunter on 3/29/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "Quiz.h"
#import "AppConstants.h"


@implementation Quiz

@synthesize quizId, userId, setId, timeLimit, requiredCorrect, allowedIncorrect;
@synthesize totalQuestions, testType, questionThrottle;


#pragma mark Memory Management
//end method

#pragma mark Mutable Copy Methods
- (id)mutableCopyWithZone:(NSZone *) zone {
	Quiz *temp = [[Quiz alloc] init];
	temp.quizId = quizId;
	temp.userId = userId;
	temp.setId = setId;
	temp.timeLimit = timeLimit;
	temp.requiredCorrect = requiredCorrect;
	temp.allowedIncorrect = allowedIncorrect;
	temp.totalQuestions = totalQuestions;
	temp.testType = testType;
	temp.questionThrottle = questionThrottle;
	return temp;
}//end method

#pragma mark Init Methods
-(id) init {
	if ((self = [super init])) {
		quizId = 0;
		userId = 0;
		setId = 0;
		timeLimit = 60;
		requiredCorrect = 0;
		allowedIncorrect = 0;
		totalQuestions = 0;
		testType = 0;
		questionThrottle = 5;
	}
	return self;
}//end method

#pragma mark Other Methods
- (NSString *)	description {
	NSString *returnString = [NSString stringWithFormat: @"%i:%i:%i:%lf:%i:%i:%i:%i",quizId,userId,setId,timeLimit,requiredCorrect,allowedIncorrect,totalQuestions, testType];
	return returnString;
}//end

-(void) calculateThrottle {
	if (QUIZ_PRACTICE_TYPE == testType)
		questionThrottle = totalQuestions * .30;
	else
		questionThrottle = totalQuestions * .18;
}//end method

@end
