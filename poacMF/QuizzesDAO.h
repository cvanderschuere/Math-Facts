//
//  QuizzesDAO.h
//  poacMF
//
//  Created by Matt Hunter on 3/29/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAO.h"
#import "Quiz.h"


@interface QuizzesDAO : DAO {
    
}

-(NSMutableArray *)	getAllQuizzesByUserId : (int) userId;
-(NSMutableArray *)	getAvailableQuizzesByUserId : (int) userId andTestType: (int) testType;
-(NSMutableArray *)	getAvailablePracticeQuizzesByUserId : (int) userId;
-(NSMutableArray *)	getAvailableTestQuizzesByUserId : (int) userId;

-(Quiz *) getSampleQuizForUser: (int) userId andTestType: (int) testType;

-(BOOL) addQuizForUser: (Quiz *) newQuiz;
-(BOOL) updateQuizForUser: (Quiz *) newQuiz;
-(BOOL) deleteQuizForUser:(Quiz*)quiz;



@end
