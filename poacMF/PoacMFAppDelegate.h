//
//  poacMFAppDelegate.h
//  poacMF
//
//  Created by Matt Hunter on 3/17/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
/*
	Revision History
	v1.0 (3/17/2011 - ?)
	- 
*/

#import <UIKit/UIKit.h>
#import "User.h"
#import "POACDetailViewController.h"

@interface PoacMFAppDelegate : NSObject <UIApplicationDelegate> {	
	NSString	*databasePath;
	BOOL		loggedIn;
	User		*currentUser;
}

@property (nonatomic, retain)	IBOutlet	UIWindow *window;
@property (nonatomic, retain)	IBOutlet	POACDetailViewController *viewController;

@property (nonatomic, retain)	NSString	*databasePath;
@property (nonatomic)	BOOL	loggedIn;
@property (nonatomic, retain)	User		*currentUser;


-(void) checkAndCreateDatabase;
-(void) applicationPrep;

@end
