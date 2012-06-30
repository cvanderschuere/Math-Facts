//
//  User.m
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic emailAddress;
@dynamic firstName;
@dynamic lastName;
@dynamic password;
@dynamic username;

//Transient
@dynamic firstNameInital;
@dynamic lastNameInital;

+(BOOL) isUserNameUnique:(NSString*)username inContext:(NSManagedObjectContext*)context{
    //Fetch all User objects with same username
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"username == %@", username.lowercaseString];
    
    return [context executeFetchRequest:fetchRequest error:NULL].count == 0;
}
- (NSString *) firstNameInital {
    [self willAccessValueForKey:@"firstNameInital"];
    NSString * initial = self.firstName.length>0?[[self firstName] substringToIndex:1]:@"";
    [self didAccessValueForKey:@"firstNameInital"];
    return initial;
}
- (NSString *) lastNameInital {
    [self willAccessValueForKey:@"lastNameInital"];
    NSString * initial = self.lastName.length>0?[[self lastName] substringToIndex:1]:@"";
    [self didAccessValueForKey:@"lastNameInital"];
    return initial;
}
@end
