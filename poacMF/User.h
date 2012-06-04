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
@property (nonatomic, retain)	NSString				*username;
@property (nonatomic, retain)	NSString                *password;
@property (nonatomic, retain)	NSString				*firstName;
@property (nonatomic, retain)	NSString				*lastName;
@property (nonatomic)			int						userType;
@property (nonatomic, retain)	NSString				*emailAddress;
@property (nonatomic)			double					defaultPracticeTimeLimit;
@property (nonatomic)			double					defaultTimedTimeLimit;
@property (nonatomic)			int						delayRetake;

- (id)mutableCopyWithZone:(NSZone *)zone;

@end