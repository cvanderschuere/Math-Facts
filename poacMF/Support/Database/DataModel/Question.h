//
//  Question.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuestionSet,Response;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * z;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, strong) NSNumber * questionOrder;
@property (nonatomic, retain) QuestionSet *questionSet;
@property (nonatomic, retain) NSSet *responses;
@end
