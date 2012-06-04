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
	NSString	*__weak setName;
	
	int			setId;
	int			requiredTimeLimit;
	int			requiredCorrect;
	int			requiredTotalQuestions;
	int			testType;
	
	int			mathType;
	NSDate		*__weak resultsTestDate;
	int			resultsCorrect;
	NSString	*__weak resultsPassFail;
	int			resultsTimeTaken;
	int			resultsTotalQuestions;
}
@property (nonatomic)				int			userId;
@property (weak, nonatomic)		NSString	*setName;
@property (nonatomic)				int			setId;
@property (nonatomic)				int			requiredTimeLimit;
@property (nonatomic)				int			requiredCorrect;
@property (nonatomic)				int			requiredTotalQuestions;
@property (nonatomic)				int			testType;
@property (nonatomic)				int			mathType;
@property (weak, nonatomic)		NSDate		*resultsTestDate;
@property (nonatomic)				int			resultsCorrect;
@property (weak, nonatomic)		NSString	*resultsPassFail;
@property (nonatomic)				int			resultsTimeTaken;
@property (nonatomic)				int			resultsTotalQuestions;

@end
