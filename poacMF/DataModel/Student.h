//
//  Student.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class Administrator, Test;

@interface Student : User

@property (nonatomic, retain) NSNumber * defaultDifficulty;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) Administrator *adminstrator;
@property (nonatomic, retain) NSSet *results;
@property (nonatomic, retain) NSSet *tests;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addResultsObject:(NSManagedObject *)value;
- (void)removeResultsObject:(NSManagedObject *)value;
- (void)addResults:(NSSet *)values;
- (void)removeResults:(NSSet *)values;

- (void)addTestsObject:(Test *)value;
- (void)removeTestsObject:(Test *)value;
- (void)addTests:(NSSet *)values;
- (void)removeTests:(NSSet *)values;

@end
