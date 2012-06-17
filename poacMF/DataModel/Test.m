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

-(void) awakeFromInsert{
    [super awakeFromInsert];
    
    //Add Practice entity
    Practice* practice = [NSEntityDescription insertNewObjectForEntityForName:@"Practice" inManagedObjectContext:self.managedObjectContext];
    practice.test = self;
}

@end
