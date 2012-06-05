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
	NSString				* username;
    NSString                * password;
	NSString				* firstName;
	NSString				* lastName;
	int						userType;
	NSString				* emailAddress;
	double					defaultPracticeTimeLimit;
	double					defaultTimedTimeLimit;
	int						delayRetake;
}

@property (nonatomic)			int						userId;
@property (strong, nonatomic)	NSString				*username;
@property (strong, nonatomic)	NSString                *password;
@property (strong, nonatomic)	NSString				*firstName;
@property (strong, nonatomic)	NSString				*lastName;
@property (nonatomic)			int						userType;
@property (strong, nonatomic)	NSString				*emailAddress;
@property (nonatomic)			double					defaultPracticeTimeLimit;
@property (nonatomic)			double					defaultTimedTimeLimit;
@property (nonatomic)			int						delayRetake;

- (id)mutableCopyWithZone:(NSZone *)zone;

@end