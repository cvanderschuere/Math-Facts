//
//  Test.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Practice.h"
#import "QuestionSet.h"
#import "Result.h"
#import "Student.h"

@class Practice, QuestionSet, Result, Student;

@interface Test : NSManagedObject

@property (nonatomic, retain) NSNumber * passCriteria;
@property (nonatomic, retain) NSNumber * testLength;
@property (nonatomic, retain) Practice *practice;
@property (nonatomic, retain) QuestionSet *questionSet;
@property (nonatomic, retain) NSSet *results;
@property (nonatomic, retain) Student *student;
@property (nonatomic, retain) NSNumber *isCurrentTest;


//Transient
@property (nonatomic, readonly, retain) NSNumber *passed;


+(Test*) testWithStudent:(Student*)student QuestionSet:(QuestionSet*) questionSet inManagedObjectContext:(NSManagedObjectContext*) context;


@end

@interface Test (CoreDataGeneratedAccessors)

- (void)addResultsObject:(Result *)value;
- (void)removeResultsObject:(Result *)object;
- (void)addResults:(NSSet *)values;
- (void)removeResults:(NSSet *)values;

@end


