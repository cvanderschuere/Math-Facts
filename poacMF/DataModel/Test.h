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
@property (nonatomic, retain) NSNumber * testDifficulty;
@property (nonatomic, retain) NSNumber * testLength;
@property (nonatomic, retain) Practice *practice;
@property (nonatomic, retain) QuestionSet *questionSet;
@property (nonatomic, retain) Result *results;
@property (nonatomic, retain) Student *student;

@end
