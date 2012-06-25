//
//  Test.m
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "Test.h"

@implementation Test

@dynamic passCriteria;
@dynamic testLength;
@dynamic practice;
@dynamic questionSet;
@dynamic results;
@dynamic student;
@dynamic isCurrentTest;


@dynamic passed;

-(void) awakeFromInsert{
    [super awakeFromInsert];
    
    //Add Practice entity
    Practice* practice = [NSEntityDescription insertNewObjectForEntityForName:@"Practice" inManagedObjectContext:self.managedObjectContext];
    practice.test = self;
}
+(Test*) testWithStudent:(Student*)student QuestionSet:(QuestionSet*) questionSet inManagedObjectContext:(NSManagedObjectContext*) context{
    return nil;
}

-(NSNumber*) passed{
    __block BOOL didPass = NO;
    [self.results enumerateObjectsUsingBlock:^(Result* result, BOOL *stop){
        if (result.correctResponses.count >= self.passCriteria.intValue) {
            didPass = YES;
            *stop = YES;
        }
    }];
    return [NSNumber numberWithBool:didPass];
}
+(NSSet*) keyPathsForValuesAffectingIsCurrentTest{
    return [NSSet setWithObject:@"currentTestForStudent"];
}

@end
