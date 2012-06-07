//
//  poacMFAppDelegate.m
//  poacMF
//
//  Created by Matt Hunter on 3/17/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "PoacMFAppDelegate.h"
#import "LoginViewController.h"
#import "Administrator.h"
#import "AppConstants.h"


@implementation PoacMFAppDelegate


@synthesize window = _window;
@synthesize database = _database;
@synthesize databasePath = _databasePath, loggedIn = _loggedIn, currentUser = _currentUser;

//end method



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupDatabase];
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
    [self saveDatabase];
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
#pragma mark - Database methods
-(void) setupDatabase{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"database"];
    self.database = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.database.fileURL path]]) {
        // does not exist on disk, so create it
        [self.database saveToURL:self.database.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:nil];
        [self addInitalData:self.database];
        [self setReadyToLogin:YES];
    } 
    else if (self.database.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.database openWithCompletionHandler:^(BOOL success) {
            NSLog(@"\nOpening Document %@\n",success?@"Succesful":@"Un Successful"); 
            [self setReadyToLogin:success];
        }];
    } 
    else if (self.database.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        [self setReadyToLogin:YES];
    }

}
-(void) setReadyToLogin:(BOOL)ready{
    if ([self.window.rootViewController respondsToSelector:@selector(setReadyToLogin:)]) {
        LoginViewController* loginVC = (LoginViewController*) self.window.rootViewController;
        loginVC.readyToLogin = ready;
    } 
}
-(void) addInitalData:(UIManagedDocument*)document{
    //Load information for plist
    NSDictionary *seedDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"databaseSeed" ofType:@"plist"]];
    
    //Add inital users
    NSArray* seedUsers = [seedDict objectForKey:@"Users"];
    for (NSDictionary* user in seedUsers) {
        Administrator * newAdmin = [NSEntityDescription insertNewObjectForEntityForName:@"Administrator" inManagedObjectContext:document.managedObjectContext];
        [newAdmin setValuesForKeysWithDictionary:user];
    }
}

-(void) saveDatabase{
    NSLog(@"Saving Document");
    [self.database saveToURL:self.database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
        NSLog(@"Save (Save Document) %@",success?@"Successful":@"Unsuccessful");
    }];
}


@end
