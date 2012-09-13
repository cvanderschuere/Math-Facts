//
//  Administrator.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class Course;

@interface Administrator : User

@property (nonatomic, retain) Course *course;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) NSSet *questionSets;

@end

@interface Administrator (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(NSManagedObject *)value;
- (void)removeStudentsObject:(NSManagedObject *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

- (void)addQuestionSetsObject:(NSManagedObject *)value;
- (void)removeQuestionSetsObject:(NSManagedObject *)value;
- (void)addQuestionSets:(NSSet *)values;
- (void)removeQuestionSets:(NSSet *)values;

@end
