//
//  QuestionSet.m
//  poacMF
//
//  Created by Matt Hunter on 3/22/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuestionSet.h"
#import "AppConstants.h"

@implementation QuestionSet

@synthesize setId,questionSetName,mathType,setOrder,setDetailsNSMA;

#pragma mark Memory Management
- (void)dealloc {
	[questionSetName release];
	[setDetailsNSMA release];
	[super dealloc];
}//end method

#pragma mark Mutable Copy Methods
- (id)mutableCopyWithZone:(NSZone *)zone {
	QuestionSet *temp = [[QuestionSet alloc] init];
	temp.setId	= setId;
	temp.questionSetName = questionSetName;
	temp.mathType = mathType;
	temp.setOrder = setOrder;
	temp.setDetailsNSMA = setDetailsNSMA;
	return temp;
}//end method

#pragma mark Init Methods
-(id) init {
	if ((self = [super init])) {
		setId = INVALID_QUESTION_SET;
		questionSetName = @"";
		mathType = ADDITION_MATH_TYPE;
		self.setDetailsNSMA = [NSMutableArray array];
	}//end if
	return self;
}//end method



#pragma mark Other Methods
- (NSString *)	description {
	NSString *returnString = [NSString stringWithFormat: @"%i:%s:%i:%i number of details: %i",
							  setId, [questionSetName UTF8String], mathType, setOrder,[setDetailsNSMA count]];
	return returnString;
}//end

@end