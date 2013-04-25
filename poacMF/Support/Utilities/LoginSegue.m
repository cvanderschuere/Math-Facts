//
//  LoginSegue.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "LoginSegue.h"
#import "PoacMFAppDelegate.h"

@implementation LoginSegue

- (void) perform {
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:self.destinationViewController];
}

@end
