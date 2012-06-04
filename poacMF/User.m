//
//  User.m
//  poacMF
//
//  Created by Matt Hunter on 3/19/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "User.h"
#import "AppConstants.h"


@implementation User

@synthesize userId,username,password,firstName,lastName,userType,emailAddress;
@synthesize delayRetake,defaultPracticeTimeLimit,defaultTimedTimeLimit;

#pragma mark Memory Management
- (void)dealloc {
	[username release];
	[password release];
	[firstName release];
	[lastName release];
	[emailAddress release];
	[super dealloc];
}//end method

#pragma mark Mutable Copy Methods
- (id)mutableCopyWithZone:(NSZone *)zone {
	User *temp = [[User alloc] init];
	temp.userId	= userId;
	temp.username = username;
	temp.password = password;
	temp.firstName = firstName;
	temp.lastName = lastName;
	temp.userType = userType;
	temp.emailAddress = emailAddress;
	temp.delayRetake = delayRetake;
	temp.defaultPracticeTimeLimit = defaultPracticeTimeLimit;
	temp.defaultTimedTimeLimit = defaultTimedTimeLimit;
	return temp;
}//end method

#pragma mark Init Methods
-(id) init {
	if ((self = [super init])) {
		userId = -1;
		username = @"";
		password = @"";
		firstName = @"";
		lastName = @"";
		userType = STUDENT_USER_TYPE;
		emailAddress = @"";
		defaultPracticeTimeLimit=120;
		defaultTimedTimeLimit=60;
		delayRetake = 2;
	}
	return self;
}//end method

#pragma mark Other Methods
- (NSString *)	description {
	NSString *returnString = [NSString stringWithFormat: @"%i:%s:%s:%s:%s:%i:%s:%lf:%lf",
		userId, [username UTF8String], [password UTF8String], [firstName UTF8String], [lastName UTF8String],
							  userType, [emailAddress UTF8String], defaultPracticeTimeLimit, defaultTimedTimeLimit];
	return returnString;
}//end


@end