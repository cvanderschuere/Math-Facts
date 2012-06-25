//
//  Student.m
//  poacMF
//
//  Created by Chris Vanderschuere on 25/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "Student.h"
#import "Administrator.h"
#import "Result.h"
#import "Test.h"


@implementation Student

@dynamic defaultPassCriteria;
@dynamic defaultPracticeLength;
@dynamic defaultTestLength;
@dynamic idNumber;
@dynamic notes;
@dynamic administrator;
@dynamic results;
@dynamic tests;


-(void) setCurrentTest:(Test *)currentTest{
    [self.tests enumerateObjectsUsingBlock:^(Test *oldTest, BOOL *stop){
        if (oldTest.isCurrentTest.boolValue) {
            oldTest.isCurrentTest = [NSNumber numberWithBool:NO];
            *stop = YES;
        }
    }];
    currentTest.isCurrentTest = [NSNumber numberWithBool:YES];
}


@end
