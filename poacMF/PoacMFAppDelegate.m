//
//  poacMFAppDelegate.m
//  poacMF
//
//  Created by Chris Vanderschuere on 3/17/11.
//  Copyright 2011 Chris Vanderschuere. All rights reserved.
//

#import "PoacMFAppDelegate.h"
#import "LoginViewController.h"
#import "Administrator.h"
#import "Student.h"
#import "Course.h"
#import "AppConstants.h"
#import "QuestionSet.h"
#import "Question.h"

@implementation PoacMFAppDelegate

@synthesize window = _window;
@synthesize documentToSave = _documentToSave;
@synthesize currentUser = _currentUser;

-(void) setDocumentToSave:(SPManagedDocument *)documentToSave{
    if (![_documentToSave isEqual:documentToSave]) {
        //Remove old observer
        [[NSNotificationCenter defaultCenter] removeObserver:self  // remove observing of old document (if any)
                                                        name:UIDocumentStateChangedNotification
                                                      object:_documentToSave];

        //Switch to new document
        _documentToSave = documentToSave;
        
        /*[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(documentStateChanged:)
                                                     name:UIDocumentStateChangedNotification
                                                   object:_documentToSave];*/
        
        [[NSNotificationCenter defaultCenter]
         addObserverForName:UIDocumentStateChangedNotification 
         object:_documentToSave 
         queue:nil 
         usingBlock:^(NSNotification *note) {
             
             UIDocumentState state = _documentToSave.documentState;
             
             if (state == 0) {
                 
                 NSLog(@"Document State Normal");
                 
             }
             
             if (state & UIDocumentStateClosed) {
                 
                 NSLog(@"Document Closed!");
             }
             
             if (state & UIDocumentStateEditingDisabled) {
                 
                 NSLog(@"Document Editing Disabled");
             }
             
             if (state & UIDocumentStateSavingError) {
                 NSLog(@"Saving Error Occurred");
             }
             
             if (state & UIDocumentStateInConflict) {
                 NSLog(@"Document in conflict");
             }
         }];

    }
}
- (void)documentStateChanged:(NSNotification *)notification
{
    if (self.documentToSave.documentState & UIDocumentStateInConflict) {
        // look at the changes in notification's userInfo and resolve conflicts
        //   or just take the latest version (by doing nothing)
        // in any case (even if you do nothing and take latest version),
        //   mark all old versions resolved ...
        NSArray *conflictingVersions = [NSFileVersion unresolvedConflictVersionsOfItemAtURL:self.documentToSave.fileURL];
        for (NSFileVersion *version in conflictingVersions) {
            version.resolved = YES;
        }
        // ... and remove the old version files in a separate thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
            NSError *error;
            [coordinator coordinateWritingItemAtURL:self.documentToSave.fileURL options:NSFileCoordinatorWritingForDeleting error:&error byAccessor:^(NSURL *newURL) {
                [NSFileVersion removeOtherVersionsOfItemAtURL:self.documentToSave.fileURL error:NULL];
            }];
            if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription, error.localizedFailureReason);
        });
    } else if (self.documentToSave.documentState & UIDocumentStateSavingError) {
        // try again?
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Testflight
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    [TestFlight takeOff:@"697945e1548f653ac921aafc40670040_MTAwMzE3MjAxMi0wNi0xNCAyMDowNTozMi4zMjk2NDg"];
    

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasCreatedDefaultCourse"]) {
        //[self createDefaultCourseWithApplication:application];
           
        /*
        //Create directories
        NSString* docURL = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                       NSUserDomainMask, YES) objectAtIndex:0];
        
        [self createDirectory:@"Courses" atFilePath:docURL];
        [self createDirectory:@"Backups" atFilePath:docURL];
         */
    }
    
    /*
    //Test iCloud
    NSURL *ubiq = [[NSFileManager defaultManager] 
                   URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud access at %@", ubiq);
        // TODO: Load document... 
    } else {
        NSLog(@"No iCloud access");
    }
    */
    
	return YES;
    
    //Register for iCloud updates
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(iCloudDidUpdateDocument:)
                                                name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                              object:nil];
    
}//end method
-(void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath
{
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
}
-(void) createDefaultCourseWithApplication:(UIApplication*)application{
    application.networkActivityIndicatorVisible = YES;
    //Create localDocument
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Default Course"];
    url = [url URLByAppendingPathExtension:@"mfCourse"];
    SPManagedDocument *defaultDocument = [[SPManagedDocument alloc] initWithFileURL:url];
    
    [defaultDocument saveToURL:defaultDocument.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
        if (success) {
            //Add inital data
            [defaultDocument openWithCompletionHandler:^(BOOL success){
                if (success) {
                    [self addInitalData:defaultDocument];
                    [defaultDocument saveToURL:defaultDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
                        if (success) {
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasCreatedDefaultCourse"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            application.networkActivityIndicatorVisible = NO;
                        }
                    }];
                }
            }];
        } 
    }];

}
#pragma mark - iCloud

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
-(void) addInitalData:(SPManagedDocument*)document{
    [document.managedObjectContext performBlockAndWait:^{
    
        //Load information for plist
        NSDictionary *seedDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"databaseSeed" ofType:@"plist"]];
        
        //Create Course
        Course *newCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:document.managedObjectContext];
        newCourse.name = [seedDict objectForKey:@"name"];
        
        //Add inital Administrators
        NSArray* seedAdmins = [seedDict objectForKey:@"Administrators"];
        if ([Administrator isUserNameUnique:[[seedAdmins lastObject] objectForKey:@"username"] inContext:document.managedObjectContext]) {
            Administrator* newAdmin = [NSEntityDescription insertNewObjectForEntityForName:@"Administrator" inManagedObjectContext:document.managedObjectContext];
            [newAdmin setValuesForKeysWithDictionary:[seedAdmins lastObject]];
            [newCourse addAdministratorsObject:newAdmin];
        }
        
        //Add inital Students
        NSArray* seedStudents = [seedDict objectForKey:@"Students"];
        for (NSDictionary* user in seedStudents) {
            if ([Student isUserNameUnique:[user objectForKey:@"username"] inContext:document.managedObjectContext]) {
                Student * newStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:document.managedObjectContext];
                [newStudent setValuesForKeysWithDictionary:user];
                [newCourse addStudentsObject:newStudent];
            }
        }
        
        //Add inital question set to new admins
        NSArray* seedQuestionSets = [seedDict objectForKey:@"Questions Sets New"];
        
        //Step through each type
        for (NSArray* setTypeArray in seedQuestionSets) {
            NSNumber* setType = [setTypeArray objectAtIndex:0];
            
            //Step through each set
            [[setTypeArray objectAtIndex:1] enumerateObjectsUsingBlock:^(NSDictionary *questionSet,NSUInteger idx, BOOL *stop){
                //Create QuestionSet
                QuestionSet *qSet = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionSet" inManagedObjectContext:document.managedObjectContext];
                qSet.name = [NSString stringWithFormat:@"Set %d",idx+1];
                qSet.type = setType;
                qSet.difficultyLevel = [NSNumber numberWithInt:idx];
                
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
                [newCourse addQuestionSetsObject:qSet];
            }];
        }
    }];
    //Save
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
        NSLog(@"Save (Save Document) %@",success?@"Successful":@"Unsuccessful");
    }];

}

-(void) saveDatabase{
    NSLog(@"Saving Document");
    [self.documentToSave saveToURL:self.documentToSave.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
        NSLog(@"Save (Save Document) %@",success?@"Successful":@"Unsuccessful");
    }];
}


@end
