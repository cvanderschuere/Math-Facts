//
//  poacMFAppDelegate.m
//  poacMF
//
//  Created by Matt Hunter on 3/17/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "PoacMFAppDelegate.h"
#import "TesterViewController.h"
#import "AppConstants.h"

@implementation PoacMFAppDelegate


@synthesize window = _window, viewController=_viewController;
@synthesize databasePath = _databasePath, loggedIn = _loggedIn, currentUser = _currentUser;

//end method



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self applicationPrep];
	return YES;
}//end method

- (void)applicationWillResignActive:(UIApplication *)application {
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}//end method

- (void)applicationDidEnterBackground:(UIApplication *)application {
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
	self.loggedIn = NO;
}//end method

- (void)applicationWillEnterForeground:(UIApplication *)application {
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}//end method

- (void)applicationDidBecomeActive:(UIApplication *)application {
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}//end method

- (void)applicationWillTerminate:(UIApplication *)application {
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}//end method

-(void) applicationPrep { 
	//create the database if it doesn't exist
	[self checkAndCreateDatabase];
	
	self.loggedIn = NO;
	self.currentUser = [[User alloc] init];
	
    // Override point for customization after application launch.
    
	[self.window makeKeyAndVisible];
}//end method

-(void) checkAndCreateDatabase {
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	self.databasePath = [documentsDir stringByAppendingPathComponent:DATABASE_NAME];
	[[NSUserDefaults standardUserDefaults] setObject: self.databasePath forKey: DATABASE_PATH];
	
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:self.databasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
}//end method


@end
