//
//  Practice.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Test, Result;

@interface Practice : NSManagedObject

@property (nonatomic, retain) NSNumber * maximumIncorrect;
@property (nonatomic, retain) NSNumber * minimumCorrect;
@property (nonatomic, retain) NSNumber * passed;
@property (nonatomic, retain) Test *test;
@property (nonatomic, retain) NSSet *results;

@end

@interface Practice (CoreDataGeneratedAccessors)

- (void)addResultsObject:(Result *)value;
- (void)removeResultsObject:(Result *)object;
- (void)addResults:(NSSet *)values;
- (void)removeResults:(NSSet *)values;




@end
