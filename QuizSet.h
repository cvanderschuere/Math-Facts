//
//  QuizSet.h
//  poacMF
//
//  Created by Matt Hunter on 4/4/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quiz.h"
#import "QuestionSet.h"

@interface QuizSet : NSObject {
	Quiz			* assignedQuiz;
	QuestionSetOLD		* assignedQuestionSet;
	NSMutableArray	* questionDetailsNSMA;
	
	//Results
	int				numberCorrect;
	int				numberIncorrect;
	double			recordedTime;
	BOOL			passedQuiz;
}


@property (strong, nonatomic)	Quiz			*assignedQuiz;
@property (strong, nonatomic)	QuestionSetOLD	*assignedQuestionSet;
@property (strong, nonatomic)	NSMutableArray	*questionDetailsNSMA;

@property	int				numberCorrect;
@property	int				numberIncorrect;
@property	double			recordedTime;
@property	BOOL			passedQuiz;

- (id)mutableCopyWithZone:(NSZone *)zone;

@end
