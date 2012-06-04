//
//  ResultsDAO.h
//  poacMF
//
//  Created by Matt Hunter on 4/17/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DAO.h"
#import "QuizSet.h"

@interface ResultsDAO : DAO {
    
}

-(BOOL) recordResultsForQuizSet: (QuizSet *) studentQuizSet;
-(NSMutableArray *) getAllResults;
-(BOOL) hasThisQuizBeenPassed: (int) quizId forThisUser: (int) userId forThisTestType: (int) testType;
-(BOOL) haveAnyPracticesBeenPassedForThisUser: (int) userId;
 
@end
