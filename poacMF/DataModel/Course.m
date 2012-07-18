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
    
    //Heading
    [csvWriter writeLineOfFields:@"First Name",@"Last Name",@"Date", @"Practice/Timing",@"Set",@"# correct",@"# incorrect",@"Time",nil];
    
    //Find all results and sort by date/lastName/firstName
    NSFetchRequest *allResults = [NSFetchRequest fetchRequestWithEntityName:@"Result"];
    allResults.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"student.lastName" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"student.firstName" ascending:YES],nil];
    
    NSArray * allResultsArray = [self.managedObjectContext executeFetchRequest:allResults error:NULL];
    
    for (Result* result in allResultsArray) {
        //Create row
        [csvWriter writeLineOfFields:result.student.firstName,result.student.lastName,[NSDateFormatter localizedStringFromDate:result.startDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle],result.isPractice.boolValue?@"Practice":@"Timing",result.isPractice.boolValue?[NSString stringWithFormat:@"%@: (%@)",result.practice.test.questionSet.typeName,result.practice.test.questionSet.name]:[NSString stringWithFormat:@"%@: (%@)",result.test.questionSet.typeName,result.test.questionSet.name],[NSNumber numberWithInt:result.correctResponses.count].stringValue,[NSNumber numberWithInt:result.incorrectResponses.count].stringValue,[NSString stringWithFormat:@"%.0f",[result.endDate timeIntervalSinceDate:result.startDate]], nil];
    }
    
    [csvWriter closeFile];
}

@end
