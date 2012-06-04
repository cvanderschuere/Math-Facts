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
	Quiz			*__weak assignedQuiz;
	QuestionSet		*__weak assignedQuestionSet;
	NSMutableArray	*__weak questionDetailsNSMA;
	
	//Results
	int				numberCorrect;
	int				numberIncorrect;
	double			recordedTime;
	BOOL			passedQuiz;
}


@property (weak, nonatomic)	Quiz			*assignedQuiz;
@property (weak, nonatomic)	QuestionSet		*assignedQuestionSet;
@property (weak, nonatomic)	NSMutableArray	*questionDetailsNSMA;

@property	int				numberCorrect;
@property	int				numberIncorrect;
@property	double			recordedTime;
@property	BOOL			passedQuiz;

- (id)mutableCopyWithZone:(NSZone *)zone;

@end
