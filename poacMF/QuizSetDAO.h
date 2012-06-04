//
//  QuizSetDAO.h
//  poacMF
//
//  Created by Matt Hunter on 4/7/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAO.h"
#import "QuizSet.h"

@interface QuizSetDAO : DAO {
    
}

-(QuizSet *) getQuizSetDetails: (QuizSet *) studentQuizSet;

@end
