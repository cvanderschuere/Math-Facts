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
	NSString				*username;
    NSString                *password;
	NSString				*firstName;
	NSString				*lastName;
	int						userType;
	NSString				*emailAddress;
	double					defaultPracticeTimeLimit;
	double					defaultTimedTimeLimit;
	int						delayRetake;
}

@property (nonatomic)			int						userId;
@property (nonatomic)	NSString				*username;
@property (nonatomic)	NSString                *password;
@property (nonatomic)	NSString				*firstName;
@property (nonatomic)	NSString				*lastName;
@property (nonatomic)			int						userType;
@property (nonatomic)	NSString				*emailAddress;
@property (nonatomic)			double					defaultPracticeTimeLimit;
@property (nonatomic)			double					defaultTimedTimeLimit;
@property (nonatomic)			int						delayRetake;

- (id)mutableCopyWithZone:(NSZone *)zone;

@end