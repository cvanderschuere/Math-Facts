//
//  MFLoginViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 11/07/2012.
//  Copyright (c) 2012 CDVConcepts. All rights reserved.
//

//iCloud additions from Stanford C193pd

/*
 //DEBUG INFORMATION//
 NSFetchRequest* fetch = [NSFetchRequest fetchRequestWithEntityName:@"Result"];
 fetch.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:YES]];
 NSArray* resultArray = [self.database.managedObjectContext executeFetchRequest:fetch error:NULL];
 
 fetch = [NSFetchRequest fetchRequestWithEntityName:@"Test"];
 fetch.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"testLength" ascending:YES]];
 NSArray* testArray = [self.database.managedObjectContext executeFetchRequest:fetch error:NULL];
 
 NSLog(@"**Database Statistics**\n\n Test (%d): %@ \n\n Result(%d): %@\n\n",testArray.count,testArray,resultArray.count,resultArray);
 */


#import "MFLoginViewController.h"
#import "AppLibrary.h"
#import "PoacMFAppDelegate.h"
#import "Student.h"
#import "Administrator.h"
#import "AdminSplitViewController.h"
#import "SubjectDetailViewController.h"
#import "DocumentSelectTableViewController.h"

@interface MFLoginViewController ()
{
    NSString *_iOSVersion;
}

@property (nonatomic, strong) NSArray *iCloudDocuments; //of NSURL
@property (nonatomic, strong) NSArray *localDocuments; //NSURL
@property (nonatomic, strong) NSMetadataQuery *iCloudQuery;

@property (nonatomic, strong) UIPopoverController* coursePopover;
@property (nonatomic, strong) UIPopoverController* helpPopover;


@property (nonatomic, strong) UIManagedDocument* selectedDocument;

@end

@implementation MFLoginViewController
@synthesize errorLabel = _errorLabel;
@synthesize buildString = _buildString;
@synthesize documentStateActivityIndicator = _documentStateActivityIndicator;
@synthesize selectCourseBarButton = _selectCourseBarButton;
@synthesize loginButton = _loginButton;
@synthesize userNameTextField = _userNameTextField, passwordTextField = _passwordTextField, readyToLogin = _readyToLogin;
@synthesize coursePopover = _coursePopover;

@synthesize iCloudDocuments = _iCloudDocuments, localDocuments = _localDocuments;
@synthesize iCloudQuery = _iCloudQuery;
@synthesize selectedDocument = _selectedDocument;

@synthesize topToolBar;

#pragma mark - Use Document
-(void) setSelectedDocument:(UIManagedDocument *)selectedDocument{    
    
    if (![_selectedDocument.fileURL isEqual:selectedDocument.fileURL]) {
        [self.documentStateActivityIndicator startAnimating];
        
        if (_selectedDocument && _selectedDocument.documentState == UIDocumentStateNormal) {
            //Close current document first
            NSString *fileName = [_selectedDocument.fileURL.lastPathComponent stringByDeletingPathExtension];
            NSLog(@"Starting Close For %@",fileName);
            [_selectedDocument closeWithCompletionHandler:^(BOOL success){
                NSLog(@"Closing Course %@ %@",[fileName stringByDeletingPathExtension],success?@"Success":@"Unsuccessful");
                if (!success)
                    [self printDocumentError:_selectedDocument];
            }];
        }
        
        //Open new document
        _selectedDocument = selectedDocument;
        
        //Update document and UI
        [self setPersistentStoreOptionsInDocument:_selectedDocument];
        self.selectCourseBarButton.title = [[_selectedDocument.fileURL lastPathComponent] stringByDeletingPathExtension];


        if (_selectedDocument.documentState != UIDocumentStateNormal) {
            if (_selectedDocument.documentState == UIDocumentStateClosed) {
                NSString *fileName = [_selectedDocument.fileURL.lastPathComponent stringByDeletingPathExtension];
                NSLog(@"Starting Open For %@",fileName);
                [_selectedDocument openWithCompletionHandler:^(BOOL success){
                    NSLog(@"Openning Course %@ %@",fileName,success?@"Success":@"Unsuccessful");
                    [self.documentStateActivityIndicator stopAnimating];
                    self.loginButton.enabled = YES;
                    if (!success)
                        [self printDocumentError:_selectedDocument];
                }];
            }
            else {
                [self printDocumentError:_selectedDocument];
                [self.documentStateActivityIndicator stopAnimating];
                self.loginButton.enabled = YES;
            }
        }
        else {
            NSLog(@"Document State Normal");
            [self.documentStateActivityIndicator stopAnimating];
            self.loginButton.enabled = YES;
            //Close current document first

        }
    }
    else {
        //Using same docuent...double check that it's open
        if (_selectedDocument.documentState != UIDocumentStateNormal) {
            NSLog(@"\n\n\nDocument Error\n\n\n");
            [self printDocumentError:_selectedDocument];
            self.selectCourseBarButton.title = [[_selectedDocument.fileURL lastPathComponent] stringByDeletingPathExtension];
        }
        else {
            NSLog(@"Using current selected document");
            self.selectCourseBarButton.title = [[_selectedDocument.fileURL lastPathComponent] stringByDeletingPathExtension];
        }
    }
}
-(void) printDocumentError:(UIManagedDocument*)document{
    switch (document.documentState) {
        case UIDocumentStateClosed:
            NSLog(@"Document closed");
            break;
        case UIDocumentStateEditingDisabled:
            NSLog(@"Document editing disabled");
            break;
        case UIDocumentStateInConflict:
            NSLog(@"Document in conflict");
            break;
        case UIDocumentStateSavingError:
            NSLog(@"Document saving error");
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            break;
        default:
            break;
    }
}

// 5. Implement documents setter to sort the array of urls (and only reload if actual changes)
// Step 6 below in UITableViewDataSource section

- (void)setLocalDocuments:(NSArray *)localDocuments
{
    localDocuments = [localDocuments sortedArrayUsingComparator:^NSComparisonResult(NSURL *url1, NSURL *url2) {
        return [[url1 lastPathComponent] caseInsensitiveCompare:[url2 lastPathComponent]];
    }];
    if (![_localDocuments isEqualToArray:localDocuments]) {
        _localDocuments = localDocuments;
    }
}
- (void)setICloudDocuments:(NSArray *)iCloudDocuments
{
    iCloudDocuments = [iCloudDocuments sortedArrayUsingComparator:^NSComparisonResult(NSURL *url1, NSURL *url2) {
        return [[url1 lastPathComponent] caseInsensitiveCompare:[url2 lastPathComponent]];
    }];
    if (![_iCloudDocuments isEqualToArray:iCloudDocuments]) {
        _iCloudDocuments = iCloudDocuments;
    }
}

#pragma mark - iCloud Query

// 8. Implement getter of iCloudQuery to lazily instantiate it (set it to find all Documents files in cloud)
// Step 9 in viewWillAppear:
// 10. Add ourself as observer for both initial iCloudQuery results and any updates that happen later
// Step 11 at the very bottom of this file, then step 12 in viewWillAppear: again.

// 36. Observe changes to the ubiquious key-value store

- (NSMetadataQuery *)iCloudQuery
{
    if (!_iCloudQuery) {
        _iCloudQuery = [[NSMetadataQuery alloc] init];
        _iCloudQuery.searchScopes = [NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope];
        _iCloudQuery.predicate = [NSPredicate predicateWithFormat:@"%K like '*'", NSMetadataItemFSNameKey];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(processCloudQueryResults:)
                                                     name:NSMetadataQueryDidFinishGatheringNotification
                                                   object:_iCloudQuery];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(processCloudQueryResults:)
                                                     name:NSMetadataQueryDidUpdateNotification
                                                   object:_iCloudQuery];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ubiquitousKeyValueStoreChanged:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:[NSUbiquitousKeyValueStore defaultStore]];
        
    }
    return _iCloudQuery;
}

- (void)ubiquitousKeyValueStoreChanged:(NSNotification *)notification
{
    
}
#pragma mark - Local Documents
-(NSURL*)localDocumentsDirectoryURL {
    static NSURL *localDocumentsDirectoryURL = nil;
    if (localDocumentsDirectoryURL == nil) {
        NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                                NSUserDomainMask, YES ) objectAtIndex:0];
        localDocumentsDirectoryURL = [NSURL fileURLWithPath:documentsDirectoryPath];
    }
    return localDocumentsDirectoryURL;
}

-(void) loadLocalDocuments{
    NSArray * localDocuments = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[self localDocumentsDirectoryURL] includingPropertiesForKeys:nil options:0 error:nil];
    localDocuments = [localDocuments filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension == %@",@"mfCourse"]];
    if (![localDocuments isEqualToArray:self.localDocuments]) {
        self.localDocuments = localDocuments;
        NSLog(@"Local Documents: %@",localDocuments);
    }

}
#pragma mark - iCloud Documents
- (NSURL *)iCloudURL
{
    return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
}

- (NSURL *)iCloudDocumentsURL
{
    return [[self iCloudURL] URLByAppendingPathComponent:@"Documents"];
}

// 14. Extract the file package that the passed url is contained in and return it

- (NSURL *)filePackageURLForCloudURL:(NSURL *)url
{
    if ([[url path] hasPrefix:[[self iCloudDocumentsURL] path]]) {
        NSArray *iCloudDocumentsURLComponents = [[self iCloudDocumentsURL] pathComponents];
        NSArray *urlComponents = [url pathComponents];
        if ([iCloudDocumentsURLComponents count] < [urlComponents count]) {
            urlComponents = [urlComponents subarrayWithRange:NSMakeRange(0, [iCloudDocumentsURLComponents count]+1)];
            url = [NSURL fileURLWithPathComponents:urlComponents];
        }
    }
    return url;
}

// 13. Handle changes to the iCloudQuery's results by iterating through and adding file packages to our Model

- (void)processCloudQueryResults:(NSNotification *)notification
{
    [self.iCloudQuery disableUpdates];
    NSMutableArray *documents = [NSMutableArray array];
    int resultCount = [self.iCloudQuery resultCount];
    for (int i = 0; i < resultCount; i++) {
        NSMetadataItem *item = [self.iCloudQuery resultAtIndex:i];
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey]; // this will be a file, not a directory
        url = [self filePackageURLForCloudURL:url];
        if (url && ![documents containsObject:url]) [documents addObject:url];  // in case a file package contains multiple files, don't add twice
    }
    
    self.iCloudDocuments = documents;
    
    //Check if selected document is available
    NSURL* selectedURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDocumentURL"]];
    if (selectedURL && ([self.iCloudDocuments containsObject:selectedURL])) {
        [self didSelectDocumentWithURL:selectedURL];
    }
    
    [self.iCloudQuery enableUpdates];
}

#pragma mark - Misc
- (void) displayAlertMessage
{
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Welcome to Math Facts"
                                                       message:@"Student user: user\nPassword: user\n\nAdmin user: admin\nPassword: admin\n\n Please consult the help file at the top right of the screen"
                                                      delegate:self
                                             cancelButtonTitle:@"Dismiss"
                                             otherButtonTitles:nil];
    [theAlert show];
}
- (void) resizeTopToolbar
{
    if ([_iOSVersion floatValue] >= 7.0) {
        
        CGRect frame = topToolBar.frame;
        frame.size.height += 20;
        topToolBar.frame = frame;
        
    }
}

// 3. Autorotation YES in all orientations
// Back to the top for step 4.

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// Convenience method for logging errors returned through NSError

- (void)logError:(NSError *)error inMethod:(SEL)method
{
    NSString *errorDescription = error.localizedDescription;
    if (!errorDescription) errorDescription = @"???";
    NSString *errorFailureReason = error.localizedFailureReason;
    if (!errorFailureReason) errorFailureReason = @"???";
    if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(method), errorDescription, errorFailureReason);
}
#pragma mark - Delete Document

// 25. Remove the url from the cloud in a coordinated manner (and in a separate thread)
//     (At this point, the application is capable of both adding and deleting documents from the cloud.)
// The next step is to be able to edit the documents themselves in PhotographersTableViewController (step 26).

// 34. Remove any ubiquitous key-value store entry for this document too (since we're deleting it)
//     Next step is to actually set the key-value store entry for a document.  Back in PhotographersTVC (step 35).

- (void)removeCloudURL:(NSURL *)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        NSError *coordinationError;
        [coordinator coordinateWritingItemAtURL:url options:NSFileCoordinatorWritingForDeleting error:&coordinationError byAccessor:^(NSURL *newURL) {
            NSError *removeError;
            [[NSFileManager defaultManager] removeItemAtURL:newURL error:&removeError];
            [self logError:removeError inMethod:_cmd]; // _cmd means "this method" (it's a SEL)
            // should also remove log files in CoreData directory in the cloud!
            // i.e., delete the files in [self iCloudCoreDataLogFilesURL]/[url lastPathComponent]
        }];
        [self logError:coordinationError inMethod:_cmd];
    });
}


#pragma mark - Segue

- (NSURL *)iCloudCoreDataLogFilesURL
{
    return [[self iCloudURL] URLByAppendingPathComponent:@"CoreData"];
}

// 19. Set persistentStoreOptions in the document before segueing
//     (Both the automatic schema-migration options and the "logging-based Core Data" options are set.)
//     (The application is now capable of showing the contents of documents in the cloud.)
// See step 20 in PhotographersTableViewController (adding a spinner to better see what's happening).

- (void)setPersistentStoreOptionsInDocument:(UIManagedDocument *)document
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    
    //iCloud
    if ([self.iCloudDocuments containsObject:document.fileURL]) {
        [options setObject:[document.fileURL lastPathComponent] forKey:NSPersistentStoreUbiquitousContentNameKey];
        [options setObject:[self iCloudCoreDataLogFilesURL] forKey:NSPersistentStoreUbiquitousContentURLKey];
    }
    
    document.persistentStoreOptions = options;
}

#pragma mark - Button Methods

- (IBAction)selectCourse:(UIBarButtonItem*)sender {
    if(self.coursePopover.popoverVisible){
        [self.coursePopover dismissPopoverAnimated:YES];
        return;
    }
    
    [self loadLocalDocuments];
    
    UINavigationController* nav = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCourseNavController"];
    DocumentSelectTableViewController *courseVC = nav.viewControllers.lastObject;
    courseVC.icloudDocuments = self.iCloudDocuments.mutableCopy;
    courseVC.localDocuments = [NSMutableArray arrayWithArray:self.localDocuments];
    courseVC.selectedDocument = self.selectedDocument;
    courseVC.delegate = self;
    
    self.coursePopover = [[UIPopoverController alloc] initWithContentViewController:nav];
    [self.coursePopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(IBAction) loginTapped {
	AppLibrary *al = [[AppLibrary alloc] init];
    
    //Check if document is being loaded
    if(self.documentStateActivityIndicator.isAnimating){
        [al showAlertFromDelegate:self withWarning:@"Course is loading..."];
        return;
    }
        //Check for valid document
    if (!self.selectedDocument) {
        [al showAlertFromDelegate:self withWarning:@"Please select a course"];
        return;
    }
    //Check if document is being loaded
    if(self.selectedDocument.documentState != UIDocumentStateNormal){
        [al showAlertFromDelegate:self withWarning:@"Error with course document"];
        return;
    }

	//check if username entered
	if (nil == self.userNameTextField.text){
        NSLog(@"UserName: %@",self.userNameTextField);
		NSString *msg = @"Username must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if 
	
	//check if password entered
	if (nil == self.passwordTextField.text){
		NSString *msg = @"Password must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	
	//log em in, swap the view
    NSDictionary* loginDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.userNameTextField.text.lowercaseString, nil] forKeys:[NSArray arrayWithObjects:@"USERNAME", nil]];
    //Check if is student
    NSFetchRequest *studentLogin = [self.selectedDocument.managedObjectModel fetchRequestFromTemplateWithName:@"StudentLogin" substitutionVariables:loginDict];
    NSArray *users = [self.selectedDocument.managedObjectContext executeFetchRequest:studentLogin error:nil];
    if (users.count == 1) {
        //Check password
        if ([[users.lastObject password] isEqualToString:self.passwordTextField.text.lowercaseString]) {
            Student* currentStudent = [users lastObject];
            [self performSegueWithIdentifier:@"studentUserSegue" sender:currentStudent];
        }
        else {
            UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Incorrect password" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [passwordAlert show];
        }
    }//
    else if(users.count == 0) {
        //Check if is admin
        NSFetchRequest *adminLogin = [self.selectedDocument.managedObjectModel fetchRequestFromTemplateWithName:@"AdminLogin" substitutionVariables:loginDict];
        users = [self.selectedDocument.managedObjectContext executeFetchRequest:adminLogin error:nil];
        if (users.count == 1) {
            //Check password
            if ([[users.lastObject password] isEqualToString:self.passwordTextField.text.lowercaseString]) {
                Administrator* admin = [users lastObject];
                [self performSegueWithIdentifier:@"adminUserSegue" sender:admin.course];
            }
            else {
                //Incorrect Password
                UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Incorrect password" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                [passwordAlert show];
            }
        }//
        else if(users.count == 0){
            NSLog(@"Does not match ANY user");
            UIAlertView *userDoesntExistAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Username" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [userDoesntExistAlert show];
            
            //Fetch all users
            NSFetchRequest* allUserFetch = [NSFetchRequest fetchRequestWithEntityName:@"User"];
            allUserFetch.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES]];
            
            NSLog(@"Total Users: %d", [self.selectedDocument.managedObjectContext countForFetchRequest:allUserFetch error:NULL]);
            
        }
        else{
            NSLog(@"Error: Matches %d admin",users.count);
        }
	}
    else {
        NSLog(@"Error: Matches more than 1 student");
        UIAlertView *dataBaseAlert = [[UIAlertView alloc] initWithTitle:@"Database Error" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [dataBaseAlert show];
    }
    
}//end method

- (IBAction)showHelpInformation:(id)sender {
    if(self.helpPopover.popoverVisible){
        [self.helpPopover dismissPopoverAnimated:YES];
        self.helpPopover = nil;
        return;
    }
    
    
    QLPreviewController *helpPDFVC = [[QLPreviewController alloc] init];
    helpPDFVC.dataSource = self;
    helpPDFVC.currentPreviewItemIndex = 0;
    helpPDFVC.contentSizeForViewInPopover = CGSizeMake(600, helpPDFVC.contentSizeForViewInPopover.height);
    
    self.helpPopover = [[UIPopoverController alloc] initWithContentViewController:helpPDFVC];
    [self.helpPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
#pragma mark - QLPreviewDelegate and Datasource methods
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller{
    return 1;
}
- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Math Facts Help" ofType:@"pdf"];
    
	return [NSURL fileURLWithPath:path];
}
#pragma mark - Storyboard Segues
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"adminUserSegue"]) {
        [segue.destinationViewController setCurrentCourse:sender];
    }
    else if ([segue.identifier isEqualToString:@"studentUserSegue"]) {
        SubjectDetailViewController *progressVC = (SubjectDetailViewController *) [[segue.destinationViewController viewControllers] lastObject];
        progressVC.currentStudent = sender;
        
        //Clear Password
        self.passwordTextField.text = nil;
    }
    
    //Pass document to app delegate to handle saving
    PoacMFAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.documentToSave = (SPManagedDocument*) self.selectedDocument;
}

#pragma mark - View Controller Lifecycle

// 9. Start up the iCloudQuery in viewWillAppear: if not already started
// 12. Turn iCloudQuery updates on and off as we appear/disappear from the screen

// 38. Since changes that WE make to the ubiquitous key-value store don't generate an NSNotification,
//      we are responsible for updating our UI when we change it.
//     We'll be cheap here and just reload ourselves each time we appear!
//     Probably would be a lot better to have our own internal NSNotification or some such.

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    //Load iCloud documents
    if (![self.iCloudQuery isStarted]) [self.iCloudQuery startQuery];
    [self.iCloudQuery enableUpdates];
     */
    
    //Set selected document from iCloud key value
    NSString * selectedURL = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDocumentURL"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //Removes encoding from intial save
    if (selectedURL) {
        //Check local documents
        NSUInteger localIndex =[self.localDocuments indexOfObjectPassingTest:^BOOL(NSURL* url, NSUInteger idx, BOOL *stop){
            if ([url.lastPathComponent isEqualToString:selectedURL.lastPathComponent]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        
        if (localIndex == NSNotFound) {
            //Check iCloud
            NSUInteger iCloudIndex =[self.iCloudDocuments indexOfObjectPassingTest:^BOOL(NSURL* url, NSUInteger idx, BOOL *stop){
                if ([url.lastPathComponent isEqualToString:selectedURL.lastPathComponent]) {
                    *stop = YES;
                    return YES;
                }
                return NO;
            }];
            if(iCloudIndex == NSNotFound){
                NSLog(@"Document doesn't exist");
            }
            else {
                //Select object
                [self didSelectDocumentWithURL:[self.iCloudDocuments objectAtIndex:localIndex]];
            }
        }
        else {
            //Select object
            [self didSelectDocumentWithURL:[self.localDocuments objectAtIndex:localIndex]];
        }
    }
    
    //Autofill for testing
        //self.userNameTextField.text = @"admin";
        //self.passwordTextField.text = @"poacmf";
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[self.iCloudQuery disableUpdates];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _iOSVersion = [[UIDevice currentDevice] systemVersion];
    [self displayAlertMessage];
    
    [self resizeTopToolbar];
    
    //Load Build Information
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
	NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
	NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
	self.buildString.text = [NSString stringWithFormat:@"%@ v%@ (build %@)",name,version,build];
    
    //Check inital setup
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasCreatedDefaultCourse"]) {
        [self createDefaultCourse];
    }
    
    
    //Create arrays
    self.localDocuments = [NSArray array];
    self.iCloudDocuments = [NSArray array];
    
    //Load Local documents
    [self loadLocalDocuments];

    //Load selected document from app delegate
    PoacMFAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.documentToSave) {
         _selectedDocument = (UIManagedDocument*) appDelegate.documentToSave;
    }
   
    
}//end method


#pragma mark - Default Course
-(void) createDefaultCourse{
    [self.documentStateActivityIndicator startAnimating];
    
    //Create localDocument
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Default Course"];
    url = [url URLByAppendingPathExtension:@"mfCourse"];
    UIManagedDocument *defaultDocument = [[UIManagedDocument alloc] initWithFileURL:url];
    
    [defaultDocument saveToURL:defaultDocument.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
        if (success) {
            //Add inital data
            [self addInitalData:defaultDocument];
            
            //Save URL Settings
            [[NSUserDefaults standardUserDefaults] setObject:[[defaultDocument.fileURL absoluteString] stringByAppendingString:@"/"] forKey:@"selectedDocumentURL"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasCreatedDefaultCourse"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.selectedDocument = defaultDocument;
            
            [self.documentStateActivityIndicator stopAnimating];
        } 
    }];
    
}
-(void) addInitalData:(UIManagedDocument*)document{
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
        
        //Add inital question sets
        NSArray* seedQuestionSets = [seedDict objectForKey:@"Questions Sets New"];
        
        __block QuestionSet* initalQuestionSet = nil;
        
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
                
                //Save first question set
                if (!initalQuestionSet) {
                    initalQuestionSet = qSet;
                }
            }];
        }

        //Add inital Students
        NSArray* seedStudents = [seedDict objectForKey:@"Students"];
        for (NSDictionary* user in seedStudents) {
            if ([Student isUserNameUnique:[user objectForKey:@"username"] inContext:document.managedObjectContext]) {
                Student * newStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:document.managedObjectContext];
                [newStudent setValuesForKeysWithDictionary:user];
                [newCourse addStudentsObject:newStudent];
                
                //Set inital questionSet
                if (initalQuestionSet)
                    [newStudent selectQuestionSet:initalQuestionSet];
            }
        }
        
            }];
    //Save
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
        NSLog(@"Save (Inital Document) %@",success?@"Successful":@"Unsuccessful");
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *) textField {
	[textField resignFirstResponder];
	return YES;
}//end method
#pragma mark - Document Select Delegate
-(void) didSelectDocumentWithURL:(NSURL *)url{
    if (!url) {
        //Clear selection
        [[NSUserDefaults standardUserDefaults] setObject:[NSString string] forKey:@"selectedDocumentURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.selectedDocument = nil;
        
        self.selectCourseBarButton.title = @"Select Course";
        
        //Dismiss
        [self.coursePopover dismissPopoverAnimated:YES];
        return;
    }
        
    //UpdateSettings
    [[NSUserDefaults standardUserDefaults] setObject:[url absoluteString] forKey:@"selectedDocumentURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //Create document with this file url
    UIManagedDocument *selectDoc = [[UIManagedDocument alloc] initWithFileURL:url];
    self.selectedDocument = selectDoc; //Opens
            
    //Dismiss
    [self.coursePopover dismissPopoverAnimated:YES];
}
-(void) didDeleteDocumentWithURL:(NSURL*) deletedURL{ 
    if ([self.selectedDocument.fileURL.lastPathComponent isEqual:deletedURL.lastPathComponent]) {
        self.selectCourseBarButton.title = @"Select Course"; //Deleting current document
    }
    
    // Simple delete to start
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtURL:deletedURL error:nil];
    
    NSArray *documentArray = [self.localDocuments containsObject:deletedURL]?self.localDocuments:self.iCloudDocuments;
    NSMutableArray *documentArrayMutable = [[self.localDocuments containsObject:deletedURL]?self.localDocuments:self.iCloudDocuments mutableCopy];
    
    [documentArrayMutable removeObject:deletedURL];
    documentArray = documentArrayMutable;
}

#pragma mark - Dealloc

- (void)viewDidUnload {
    [self setLoginButton:nil];
    [self setErrorLabel:nil];
    [self setBuildString:nil];
    [self setDocumentStateActivityIndicator:nil];
    [self setSelectCourseBarButton:nil];
    [super viewDidUnload];
}

// 11. Remove ourself as an observer (of anything) when we leave the heap

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
