//
//  User.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * password; //TODO: hash password
@property (nonatomic, retain) NSString * username; //TODO: Unique username
@property (nonatomic, readonly, retain) NSString *firstNameInital;
@property (nonatomic, readonly, retain) NSString *lastNameInital;

+(BOOL) isUserNameUnique:(NSString*)username inContext:(NSManagedObjectContext*)context;
@end
