//
//  Quiz.h
//  poacMF
//
//  Created by Matt Hunter on 3/29/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Quiz : NSObject {
	int		quizId;
	int		userId;
	int		setId;
	double	timeLimit;
    int		requiredCorrect;
	int		allowedIncorrect;
	int		totalQuestions;
	int		testType;
	
	//not stored in database, just control mechanism
	double	questionThrottle;
}

@property (nonatomic)	int		quizId;
@property (nonatomic)	int		userId;
@property (nonatomic)	int		setId;
@property (nonatomic)	double	timeLimit;
@property (nonatomic)	int		requiredCorrect;
@property (nonatomic)	int		allowedIncorrect;
@property (nonatomic)	int		totalQuestions;
@property (nonatomic)	int		testType;

@property (nonatomic)	double	questionThrottle;


- (id)	mutableCopyWithZone:(NSZone *) zone;
-(void) calculateThrottle;

@end
