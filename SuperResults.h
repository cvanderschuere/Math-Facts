//
//  SuperResults.h
//  poacMF
//
//  Created by Matt Hunter on 5/7/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SuperResults : NSObject {
	int			userId;
	NSString	* setName;
	
	int			setId;
	int			requiredTimeLimit;
	int			requiredCorrect;
	int			requiredTotalQuestions;
	int			testType;
	
	int			mathType;
	NSDate		* resultsTestDate;
	int			resultsCorrect;
	NSString	* resultsPassFail;
	int			resultsTimeTaken;
	int			resultsTotalQuestions;
}
@property (nonatomic)				int			userId;
@property (strong, nonatomic)		NSString	*setName;
@property (nonatomic)				int			setId;
@property (nonatomic)				int			requiredTimeLimit;
@property (nonatomic)				int			requiredCorrect;
@property (nonatomic)				int			requiredTotalQuestions;
@property (nonatomic)				int			testType;
@property (nonatomic)				int			mathType;
@property (strong, nonatomic)		NSDate		*resultsTestDate;
@property (nonatomic)				int			resultsCorrect;
@property (strong, nonatomic)		NSString	*resultsPassFail;
@property (nonatomic)				int			resultsTimeTaken;
@property (nonatomic)				int			resultsTotalQuestions;

@end
