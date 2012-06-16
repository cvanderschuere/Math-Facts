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
#import "Student.h"
#import "AppConstants.h"
#import "QuestionSet.h"
#import "Question.h"

@implementation PoacMFAppDelegate

@synthesize window = _window;
@synthesize database = _database;
@synthesize currentUser = _currentUser;

//end method



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[TestFlight takeOff:@"697945e1548f653ac921aafc40670040_MTAwMzE3MjAxMi0wNi0xNCAyMDowNTozMi4zMjk2NDg"];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDatabase) name:@"SaveDatabase" object:nil];
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
    self.database = [[SPManagedDocument alloc] initWithFileURL:url];
    
    // Set the persistent store options to point to the cloud
    //Things to add for iCloud:  PrivateName, NSPersistentStoreUbiquitousContentNameKey,cloudURL, NSPersistentStoreUbiquitousContentURLKey,

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                             NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES],
                             NSInferMappingModelAutomaticallyOption,
                             nil];
    self.database.persistentStoreOptions = options;
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.database.fileURL path]]) {
        // does not exist on disk, so create it
        [self.database saveToURL:self.database.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL succeed){
            [self setReadyToLogin:NO];
            if (succeed) {
                [self.database closeWithCompletionHandler:^(BOOL success){
                    if (succeed)
                        [self.database openWithCompletionHandler:^(BOOL success){
                            if (succeed) {
                                [self setReadyToLogin:YES];
                                [self addInitalData:self.database];
                            }
                        }];
                }];
            }
        }];
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
-(void) addInitalData:(SPManagedDocument*)document{
    [document.managedObjectContext performBlockAndWait:^{
    
        //Load information for plist
        NSDictionary *seedDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"databaseSeed" ofType:@"plist"]];
        
        //Add inital Administrators
        NSArray* seedAdmins = [seedDict objectForKey:@"Administrators"];
        NSMutableArray *createdAdmins = [NSMutableArray arrayWithCapacity:seedAdmins.count];
        Administrator * newAdmin = nil;
        if ([Administrator isUserNameUnique:[[seedAdmins lastObject] objectForKey:@"username"] inContext:document.managedObjectContext]) {
            newAdmin = [NSEntityDescription insertNewObjectForEntityForName:@"Administrator" inManagedObjectContext:document.managedObjectContext];
            [newAdmin setValuesForKeysWithDictionary:[seedAdmins lastObject]];
            [createdAdmins addObject:newAdmin];
        }
        
        //Add inital Students
        NSArray* seedStudents = [seedDict objectForKey:@"Students"];
        NSMutableArray *createdStudents = [NSMutableArray arrayWithCapacity:seedStudents.count];
        for (NSDictionary* user in seedStudents) {
            if ([Student isUserNameUnique:[user objectForKey:@"username"] inContext:document.managedObjectContext]) {
                Student * newStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:document.managedObjectContext];
                [newStudent setValuesForKeysWithDictionary:user];
                newStudent.administrator = newAdmin;
                [createdStudents addObject:newStudent];
            }
        }
        
        //Add inital question set to new admins
        NSArray* seedQuestionSets = [seedDict objectForKey:@"Questions Sets"];
        
        //Step through each type
        for (NSArray* setTypeArray in seedQuestionSets) {
            NSNumber* setType = [setTypeArray objectAtIndex:0];
            
            //Step through each set
            [[setTypeArray objectAtIndex:1] enumerateObjectsUsingBlock:^(NSDictionary *questionSet,NSUInteger idx, BOOL *stop){
                //Create QuestionSet
                QuestionSet *qSet = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionSet" inManagedObjectContext:document.managedObjectContext];
                qSet.name = [questionSet objectForKey:@"name"];
                qSet.type = setType;
                qSet.difficultyLevel = [NSNumber numberWithInt:idx];
                NSLog(@"%@: %@",qSet.name,qSet.difficultyLevel);
                
                //Set through each question
                [[questionSet objectForKey:@"questions"] enumerateObjectsUsingBlock:^(NSArray* question, NSUInteger idx, BOOL *stop){
                    Question* newQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:document.managedObjectContext];
                    
                    // -1 signifies the blank in the question
                    newQuestion.x = [[question objectAtIndex:0] intValue]>=0?[question objectAtIndex:0]:nil;
                    newQuestion.y = [[question objectAtIndex:1] intValue]>=0?[question objectAtIndex:1]:nil;
                    newQuestion.z = [[question objectAtIndex:2] intValue]>=0?[question objectAtIndex:2]:nil;
                    newQuestion.questionOrder = [NSNumber numberWithInt:idx];
                    [qSet addQuestionsObject:newQuestion];
                }];
                
                //Add new question set to all new admins
                [newAdmin addQuestionSetsObject:qSet];
            }];
        }
    }];
    //Save
    [document saveToURL:self.database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
        NSLog(@"Save (Save Document) %@",success?@"Successful":@"Unsuccessful");
    }];

}

-(void) saveDatabase{
    NSLog(@"Saving Document");
    [self.database saveToURL:self.database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
        NSLog(@"Save (Save Document) %@",success?@"Successful":@"Unsuccessful");
    }];
}


@end
