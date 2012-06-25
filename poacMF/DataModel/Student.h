//
//  Student.h
//  poacMF
//
//  Created by Chris Vanderschuere on 25/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class Administrator, Result, Test;

@interface Student : User

@property (nonatomic, retain) NSNumber * defaultPassCriteria;
@property (nonatomic, retain) NSNumber * defaultPracticeLength;
@property (nonatomic, retain) NSNumber * defaultTestLength;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) Administrator *administrator;
@property (nonatomic, retain) NSSet *results;
@property (nonatomic, retain) NSSet *tests;

-(void) setCurrentTest:(Test *)currentTest;

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
