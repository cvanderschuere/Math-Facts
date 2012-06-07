//
//  QuestionSet.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Administrator;

@interface QuestionSet : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * difficultyLevel;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) Administrator *administrator;
@property (nonatomic, retain) NSSet *questions;
@end

@interface QuestionSet (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(NSManagedObject *)value;
- (void)removeQuestionsObject:(NSManagedObject *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end
