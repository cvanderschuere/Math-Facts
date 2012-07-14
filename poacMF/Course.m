//
//  Course.m
//  poacMF
//
//  Created by Chris Vanderschuere on 11/07/2012.
//  Copyright (c) 2012 CDVConcepts. All rights reserved.
//

#import "Course.h"
#import "Administrator.h"
#import "QuestionSet.h"
#import "Student.h"
#import "Test.h"
#import "Result.h"

//CSV
#import "CHCSV.h"


@implementation Course

@dynamic name;
@dynamic students;
@dynamic administrators;
@dynamic questionSets;


-(void) saveCSVToFile:(NSString*) fileURL{
    NSLog(@"Writting CSV to %@",fileURL);
    
    CHCSVWriter *csvWriter = [[CHCSVWriter alloc] initWithCSVFile:fileURL atomic:NO];
    
    //Title
    [csvWriter writeLineOfFields:self.name, nil];
    [csvWriter writeLine];
    
    //Students sort alphabetical
    NSArray *sortedStudents = [self.students.allObjects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES], nil]];
    
    [csvWriter writeLineOfFields:@"Student Name",@"",@"Test Length", @"Min Correct",@"Max Incorrect",@"Practice Length" ,nil];
    
    for (Student* student in sortedStudents) {
        //Print student name
        [csvWriter writeLineOfFields:student.firstName,student.lastName,student.defaultTestLength,student.defaultPassCriteria,student.defaultMaximumIncorrect,student.defaultPracticeLength, nil];
        [csvWriter writeLine];
        
        [csvWriter writeLineOfFields:@"Timings", nil];
        for (Test* test in student.tests) {
            [csvWriter writeLineOfFields:[NSString stringWithFormat:@"%@: %@",test.questionSet.typeName,test.questionSet.name,test.testLength],test.passCriteria,test.maximumIncorrect, nil];
            
            [csvWriter writeLineOfFields:@"Results", nil];
            for (Result* result in test.results) {
                [csvWriter writeLineOfFields:[NSNumber numberWithInt:result.correctResponses.count].stringValue,[NSNumber numberWithInt:result.incorrectResponses.count].stringValue, nil];
            }
            [csvWriter writeLine];
        }
        [csvWriter writeLine];
        [csvWriter writeLine];
    }
        
    [csvWriter closeFile];
}

@end
