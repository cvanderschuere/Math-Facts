//
//  Student.h
//  poacMF
//
//  Created by Chris Vanderschuere on 25/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class Course, Result, Test, QuestionSet;

@interface Student : User

@property (nonatomic, retain) NSNumber * defaultPassCriteria;
@property (nonatomic, retain) NSNumber * defaultMaximumIncorrect;
@property (nonatomic, retain) NSNumber * defaultPracticeLength;
@property (nonatomic, retain) NSNumber * defaultTestLength;
@property (nonatomic, retain) NSNumber * numberOfDistractionQuestions;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) Course *course;
@property (nonatomic, retain) NSSet *results;
@property (nonatomic, retain) NSSet *tests;

-(void) setCurrentTest:(Test *)currentTest;
-(void) selectQuestionSet: (QuestionSet*)selectedSet;

@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addResultsObject:(Result *)value;
- (void)removeResultsObject:(Result *)value;
- (void)addResults:(NSSet *)values;
- (void)removeResults:(NSSet *)values;

- (void)addTestsObject:(Test *)value;
- (void)removeTestsObject:(Test *)value;
- (void)addTests:(NSSet *)values;
- (void)removeTests:(NSSet *)values;

@end
