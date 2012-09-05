//
//  poacMFAppDelegate.m
//  poacMF
//
//  Created by Chris Vanderschuere on 3/17/11.
//  Copyright 2011 Chris Vanderschuere. All rights reserved.
//

#import "PoacMFAppDelegate.h"
#import "Administrator.h"
#import "Student.h"
#import "Course.h"
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
        
    /*
    //Test iCloud
    NSURL *ubiq = [[NSFileManager defaultManager] 
                   URLForUbiquityContainerIdentifier:nil];    
    if (ubiq){
        NSLog(@"iCloud access at %@", ubiq);
         //Register for iCloud updates
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(iCloudDidUpdateDocument:)
                                                    name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                  object:nil];
     }
    else
        NSLog(@"No iCloud access");
     */
    
	return YES;
    
    
    
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
    
    
    //Recieve notifications about saving
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldSave) name:@"SaveDatabase" object:nil];
}//end method

- (void)applicationWillTerminate:(UIApplication *)application {
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}//end method

#pragma mark - Database methods
-(void) saveDatabase{
    NSLog(@"Saving Document");
    [self.documentToSave saveToURL:self.documentToSave.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
        NSLog(@"Save (Save Document) %@",success?@"Successful":@"Unsuccessful");
    }];
}
- (void) shouldSave{
    [self.documentToSave updateChangeCount:UIDocumentChangeDone];
}

#pragma mark - Dealloc
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //Remove self here as well just in case
}


@end
