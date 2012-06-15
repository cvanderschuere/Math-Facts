//
//  QuestionSet.m
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "QuestionSet.h"
#import "Administrator.h"

@implementation QuestionSet

@dynamic details;
@dynamic difficultyLevel;
@dynamic name;
@dynamic type;
@dynamic typeName;
@dynamic administrator;
@dynamic questions;


- (NSString *) typeName {
    [self willAccessValueForKey:@"typeName"];
    NSString * name = @"Error Type";
    switch (self.type.intValue) {
        case 0:
            name = @"Addition";
            break;
        case 1:
            name = @"Subtraction";
            break;
        case 2:
            name = @"Multiplication";
            break;
        case 3:
            name = @"Division";
            break;
            
        default:
            name = @"Unknown Type";
            break;
    }
    [self didAccessValueForKey:@"typeName"];
    return name;
}


@end
