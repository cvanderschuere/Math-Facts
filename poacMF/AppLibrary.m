//
//  AppLibrary.m
//  poacMF
//
//  Created by Matt Hunter on 3/19/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "AppLibrary.h"
#import "AppConstants.h"
#import "User.h"
#import "SuperResults.h"

@implementation AppLibrary

-(void) showAlertFromDelegate: (id) delegateObject withWarning: (NSString *) warning {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Oops!"
						  message:warning 
						  delegate: delegateObject
						  cancelButtonTitle: @"Ok"
						  otherButtonTitles:nil];
	[alert show];
}//end method

-(NSString *)	interpretMathTypeAsPhrase: (int) mathType {
	if (ADDITION_MATH_TYPE == mathType)
		return @"Addition Set ";
	if (SUBTRACTION_MATH_TYPE == mathType)
		return @"Subtraction Set ";
	if (MULTIPLICATION_MATH_TYPE == mathType)
		return @"Multiplication Set ";
	if (DIVISION_MATH_TYPE == mathType)
		return @"Division Set ";
	return @"";
}//end method

-(NSString *)	interpretMathTypeAsSymbol: (int) mathType {
	if (ADDITION_MATH_TYPE == mathType)
		return @"+";
	if (SUBTRACTION_MATH_TYPE == mathType)
		return @"-";
	if (MULTIPLICATION_MATH_TYPE == mathType)
		return @"x";
	if (DIVISION_MATH_TYPE == mathType)
		return @"/";
	return @"";
}//end method

-(NSString *) formattedDate: (NSDate *)thisDate {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
	[dateFormatter setLenient:YES];				
	NSString *dateStr = [dateFormatter stringFromDate:thisDate];
	return dateStr;
}//end method

-(NSDictionary *)	matchAndCountUsers: (NSMutableArray *)listOfUsers toDetails:(NSMutableArray *) listOfResults {
	NSMutableDictionary *returnNSD = [NSMutableDictionary new];
	
	//cycle through the users
	int recordCount=0;
	for (User *u in listOfUsers) {
		for (SuperResults *sr in listOfResults) {
			if (u.userId == sr.userId)
				recordCount++;
		}//end for
		NSNumber *nsn = [NSNumber numberWithInt:recordCount];
		NSNumber *userKey = [NSNumber numberWithInt:u.userId];
		[returnNSD setObject:nsn forKey:userKey];
		recordCount=0;
	}//end for
	
	return returnNSD;
}//end method

@end
