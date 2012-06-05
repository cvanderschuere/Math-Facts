//
//  LogoutSegue.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "LogoutSegue.h"

@implementation LogoutSegue

-(void) perform{
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateInitialViewController]];
}
@end
