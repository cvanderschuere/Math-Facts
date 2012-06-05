//
//  LoginSegue.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "LoginSegue.h"
#import "PoacMFAppDelegate.h"

@implementation LoginSegue
- (void) perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    //Account for status bar
    dst.view.frame = [[UIScreen mainScreen] applicationFrame];

    [UIView transitionFromView:src.view toView:dst.view duration:.3 options:UIViewAnimationOptionTransitionFlipFromRight 
                    completion:^(BOOL finished){
                        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:dst];
                    }
     ];
       
}

@end
