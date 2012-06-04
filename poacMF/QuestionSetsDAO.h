//
//  QuestionSets.h
//  poacMF
//
//  Created by Matt Hunter on 3/21/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAO.h"
@class QuestionSet;


@interface QuestionSetsDAO : DAO {
    
}

-(int)				addQuestionSet: (NSString *) setName forMathType: (int) mathType withSetOrder: (int) setOrder;
-(NSMutableArray *) getAllSets;
-(NSMutableArray *) getSetByMathType: (int) mathType;
-(QuestionSet *)	getQuestionSetById: (int) setId;
-(QuestionSet *)	getQuestionSetBySetOrder: (int) nextSetOrder andMathType: (int) mathType;
-(BOOL)				deleteQuestionSetById: (int) setId;

@end
