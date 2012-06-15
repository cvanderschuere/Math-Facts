//
//  QuestionSet.h
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Question.h"

@class Administrator, Question;

#define QUESTION_TYPE_MATH_ADDITION         0
#define QUESTION_TYPE_MATH_SUBTRACTION      1
#define QUESTION_TYPE_MATH_MULTIPLICATION	2
#define QUESTION_TYPE_MATH_DIVISION         3

@interface QuestionSet : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * difficultyLevel;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) NSString * typeSymbol;
@property (nonatomic, retain) Administrator *administrator;
@property (nonatomic, retain) NSSet *questions;
@end

@interface QuestionSet (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end
