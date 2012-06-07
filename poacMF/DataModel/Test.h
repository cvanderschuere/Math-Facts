//
//  Test.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Test : NSManagedObject

@property (nonatomic, retain) NSNumber * passCriteria;
@property (nonatomic, retain) NSNumber * testLength;
@property (nonatomic, retain) NSNumber * testDifficulty;
@property (nonatomic, retain) NSManagedObject *results;
@property (nonatomic, retain) NSManagedObject *questionSet;
@property (nonatomic, retain) NSManagedObject *practice;
@property (nonatomic, retain) NSManagedObject *student;

@end
