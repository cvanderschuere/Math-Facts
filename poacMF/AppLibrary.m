//
//  AppLibrary.m
//  poacMF
//
//  Created by Chris Vanderschuere on 3/19/11.
//  Copyright 2011 Chris Vanderschuere. All rights reserved.
//

#import "AppLibrary.h"
#import "User.h"

@implementation AppLibrary

-(void) showAlertFromDelegate: (id) delegateObject withWarning: (NSString *) warning {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Oops!"
						  message:warning 
						  delegate: delegateObject
						  cancelButtonTitle: @"Ok"
						  otherButtonTitles:nil];
	[alert show];
}//end method
@end
