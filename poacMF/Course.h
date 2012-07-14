//
//  Course.h
//  poacMF
//
//  Created by Chris Vanderschuere on 11/07/2012.
//  Copyright (c) 2012 CDVConcepts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Administrator, QuestionSet, Student;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) NSSet *administrators;
@property (nonatomic, retain) NSSet *questionSets;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

- (void)addAdministratorsObject:(Administrator *)value;
- (void)removeAdministratorsObject:(Administrator *)value;
- (void)addAdministrators:(NSSet *)values;
- (void)removeAdministrators:(NSSet *)values;

- (void)addQuestionSetsObject:(QuestionSet *)value;
- (void)removeQuestionSetsObject:(QuestionSet *)value;
- (void)addQuestionSets:(NSSet *)values;
- (void)removeQuestionSets:(NSSet *)values;

//CSV
-(void) saveCSVToFile:(NSString*) fileURL;

@end
