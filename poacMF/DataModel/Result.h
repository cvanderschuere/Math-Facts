//
//  Result.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question, Student, Test;

@interface Result : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * isPractice;
@property (nonatomic, retain) Test *test;
@property (nonatomic, retain) NSSet *questionsCorrect;
@property (nonatomic, retain) NSSet *questionsIncorrect;
@property (nonatomic, retain) Student *student;
@end

@interface Result (CoreDataGeneratedAccessors)

- (void)addQuestionsCorrectObject:(Question *)value;
- (void)removeQuestionsCorrectObject:(Question *)value;
- (void)addQuestionsCorrect:(NSSet *)values;
- (void)removeQuestionsCorrect:(NSSet *)values;

- (void)addQuestionsIncorrectObject:(Question *)value;
- (void)removeQuestionsIncorrectObject:(Question *)value;
- (void)addQuestionsIncorrect:(NSSet *)values;
- (void)removeQuestionsIncorrect:(NSSet *)values;

@end
