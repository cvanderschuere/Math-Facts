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

@dynamic defaultMaximumIncorrect;
@dynamic defaultPassCriteria;
@dynamic defaultPracticeLength;
@dynamic defaultTestLength;
@dynamic numberOfDistractionQuestions;
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
-(void) selectQuestionSet:(QuestionSet *)selectedQuestionSet{
    //Fetch pre-existing test for this user and questionset
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Test"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"student.firstName" ascending:YES]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"questionSet.type == %@ AND questionSet.difficultyLevel == %@ AND questionSet.name == %@ AND student.username == %@",selectedQuestionSet.type,selectedQuestionSet.difficultyLevel,selectedQuestionSet.name,self.username];
    NSArray* result = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    
    
    Test* currentTest = nil;
    //If no prexisting tests exist...create new
    if (result.count == 0) {
        currentTest = [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:self.managedObjectContext];
        currentTest.questionSet = selectedQuestionSet;
        currentTest.testLength = self.defaultTestLength;
        currentTest.passCriteria = self.defaultPassCriteria;
        [self addTestsObject:currentTest];
        
    }
    else {
        currentTest = result.lastObject;
    }
    
    [self setCurrentTest:currentTest];
}

@end
