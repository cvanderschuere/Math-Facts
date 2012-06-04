//
//  User.h
//  poacMF
//
//  Created by Matt Hunter on 3/19/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
	int						userId;
	NSString				*__weak username;
    NSString                *__weak password;
	NSString				*__weak firstName;
	NSString				*__weak lastName;
	int						userType;
	NSString				*__weak emailAddress;
	double					defaultPracticeTimeLimit;
	double					defaultTimedTimeLimit;
	int						delayRetake;
}

@property (nonatomic)			int						userId;
@property (weak, nonatomic)	NSString				*username;
@property (weak, nonatomic)	NSString                *password;
@property (weak, nonatomic)	NSString				*firstName;
@property (weak, nonatomic)	NSString				*lastName;
@property (nonatomic)			int						userType;
@property (weak, nonatomic)	NSString				*emailAddress;
@property (nonatomic)			double					defaultPracticeTimeLimit;
@property (nonatomic)			double					defaultTimedTimeLimit;
@property (nonatomic)			int						delayRetake;

- (id)mutableCopyWithZone:(NSZone *)zone;

@end