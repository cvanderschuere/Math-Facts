//
//  Question.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuestionSet;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * z;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSSet *questionSet;
@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addQuestionSetObject:(QuestionSet *)value;
- (void)removeQuestionSetObject:(QuestionSet *)value;
- (void)addQuestionSet:(NSSet *)values;
- (void)removeQuestionSet:(NSSet *)values;

@end
