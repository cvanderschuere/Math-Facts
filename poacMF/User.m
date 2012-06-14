//
//  User.m
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic emailAddress;
@dynamic firstName;
@dynamic lastName;
@dynamic password;
@dynamic username;

+(BOOL) isUserNameUnique:(NSString*)username inContext:(NSManagedObjectContext*)context{
    //Fetch all User objects with same username
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"username == %@",username];
    
    return [context executeFetchRequest:fetchRequest error:NULL].count == 0;
}

@end
