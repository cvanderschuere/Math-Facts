//
//  Result.h
//  poacMF
//
//  Created by Chris Vanderschuere on 15/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Response.h"

@class Student, Test, Response,Practice;

@interface Result : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * isPractice;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSSet *correctResponses;
@property (nonatomic, retain) NSSet *incorrectResponses;
@property (nonatomic, retain) Student *student;
@property (nonatomic, retain) Test *test;
@property (nonatomic, retain) Practice *practice;

//Transient
@property (nonatomic, retain) NSNumber *didPass;


@end

@interface Result (CoreDataGeneratedAccessors)

- (void)addCorrectResponsesObject:(Response *)value;
- (void)removeCorrectResponsesObject:(Response *)value;
- (void)addCorrectResponses:(NSSet *)values;
- (void)removeCorrectResponses:(NSSet *)values;

- (void)addIncorrectResponsesObject:(Response *)value;
- (void)removeIncorrectResponsesObject:(Response *)value;
- (void)addIncorrectResponses:(NSSet *)values;
- (void)removeIncorrectResponses:(NSSet *)values;

@end
