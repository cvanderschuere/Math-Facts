//
//  QuizSet.m
//  poacMF
//
//  Created by Matt Hunter on 4/4/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuizSet.h"


@implementation QuizSet

@synthesize assignedQuiz, assignedQuestionSet, questionDetailsNSMA;
@synthesize numberCorrect, numberIncorrect, recordedTime, passedQuiz;

#pragma mark Memory Management
//end method

#pragma mark Mutable Copy Methods
- (id)mutableCopyWithZone:(NSZone *)zone {
	QuizSet *temp = [[QuizSet alloc] init];
	temp.assignedQuiz = assignedQuiz;
	temp.assignedQuestionSet = assignedQuestionSet;
	temp.questionDetailsNSMA = questionDetailsNSMA;
	return temp;
}//end method

#pragma mark Init Methods
-(id) init {
	if ((self = [super init])) {
		self.questionDetailsNSMA = [NSMutableArray array];
	}//end if
	return self;
}//end method

@end
