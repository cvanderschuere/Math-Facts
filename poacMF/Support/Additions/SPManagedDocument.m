//
//  SPManagedDocument.m
//  Scorepad+
//
//  Created by Chris Vanderschuere on 14/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPManagedDocument.h"
#import <CoreData/CoreData.h>

@implementation SPManagedDocument

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSLog(@"Auto-Saving Document");
    return [super contentsForType:typeName error:outError];
}
- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted
{  
    NSLog(@"UIManagedDocument error: %@", error.localizedDescription);
    NSArray* errors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    if(errors != nil && errors.count > 0) {
        for (NSError *error in errors) {
            NSLog(@"  Error: %@", error.userInfo);
        }
    } else {
        NSLog(@"  %@", error.userInfo);
    }
}
@end
