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

}

@property (strong, nonatomic)	IBOutlet	UIWindow *window;

@property (strong, nonatomic)	NSString	*databasePath;
@property (nonatomic)	BOOL	loggedIn;
@property (nonatomic, strong) UIManagedDocument* database;
@property (nonatomic, strong)	User		*currentUser;


-(void) checkAndCreateDatabase;
-(void) applicationPrep;
-(void) saveDatabase;

@end
