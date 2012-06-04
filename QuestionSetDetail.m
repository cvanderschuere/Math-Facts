//
//  QuestionSetDetail.m
//  poacMF
//
//  Created by Matt Hunter on 3/23/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "QuestionSetDetail.h"


@implementation QuestionSetDetail

@synthesize detailId,setId,xValue,yValue;

#pragma mark Memory Management
- (void)dealloc {
	[super dealloc];
}//end method

#pragma mark Mutable Copy Methods
- (id)mutableCopyWithZone:(NSZone *)zone {
	QuestionSetDetail *temp = [[QuestionSetDetail alloc] init];
	temp.detailId = detailId;
	temp.setId	= setId;
	temp.xValue = xValue;
	temp.yValue = yValue;
	return temp;
}//end method

#pragma mark Init Methods
-(id) init {
	if ((self = [super init])) {
		detailId = -1;
		setId = -1;
		xValue = 0;
		yValue = 0;
	}
	return self;
}//end method



#pragma mark Other Methods
- (NSString *)	description {
	NSString *returnString = [NSString stringWithFormat: @"%i:%i:%i:%i",detailId,setId,xValue,yValue];
	return returnString;
}//end

@end