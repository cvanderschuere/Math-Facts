//
//  AppLibrary.m
//  poacMF
//
//  Created by Matt Hunter on 3/19/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "AppLibrary.h"
#import "AppConstants.h"
#import "User.h"
#import "SuperResults.h"

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
