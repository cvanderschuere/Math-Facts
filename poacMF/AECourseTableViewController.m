//
//  AECourseTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 11/07/2012.
//  Copyright (c) 2012 CDVConcepts. All rights reserved.
//

#import "AECourseTableViewController.h"
#import "DocumentSelectTableViewController.h"
#import "Course.h"
#import "QuestionSet.h"
#import "Question.h"
#import "Administrator.h"
#import "AppLibrary.h"

@interface AECourseTableViewController ()

@end

@implementation AECourseTableViewController
@synthesize nameTextField = _nameTextField;
@synthesize icloudSwitch = _icloudSwitch;
@synthesize admin1Username = _admin1Username;
@synthesize admin1Password = _admin1Password;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil]){
        [self.icloudSwitch setOn:NO animated:animated];
        self.icloudSwitch.enabled = NO;
    }
    
    /*
    //Autofill for testings
    self.nameTextField.text = [NSString stringWithFormat:@"Test: %d",arc4random()%20];
    self.admin1Username.text = @"admin";
	self.admin1Password.text = @"poacmf";
     */
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setIcloudSwitch:nil];
    [self setAdmin1Username:nil];
    [self setAdmin1Password:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - URLS
-(NSURL*)localDocumentsDirectoryURL {
    static NSURL *localDocumentsDirectoryURL = nil;
    if (localDocumentsDirectoryURL == nil) {
        NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                                NSUserDomainMask, YES ) objectAtIndex:0];
        localDocumentsDirectoryURL = [NSURL fileURLWithPath:documentsDirectoryPath];
    }
    return localDocumentsDirectoryURL;
}
- (NSURL *)iCloudURL
{
    return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
}

- (NSURL *)iCloudDocumentsURL
{
    return [[self iCloudURL] URLByAppendingPathComponent:@"Documents"];
}
- (NSURL *)iCloudCoreDataLogFilesURL
{
    return [[self iCloudURL] URLByAppendingPathComponent:@"CoreData"];
}

#pragma mark - IBActions
- (IBAction)courseSaved:(id)sender {
    //Check validity of information
    AppLibrary *lib = [[AppLibrary alloc] init];
    if (self.nameTextField.text.length == 0) {
        return [lib showAlertFromDelegate:self withWarning:@"Must enter name"];
    }   
    if (self.admin1Username.text.length == 0) {
        return [lib showAlertFromDelegate:self withWarning:@"Must enter administrator username"];
    }
    if (self.admin1Password.text.length == 0) {
        return [lib showAlertFromDelegate:self withWarning:@"Must enter administrator password"];
    }
    
    UIAlertView* exampleQuestionsAlert = [[UIAlertView alloc] initWithTitle:@"Example Questions" message:@"Would you like to import default questions into this course"  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [exampleQuestionsAlert show];
     
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"Example Questions"]) {
        [self createCourseWithExampleQuestions:buttonIndex != 0];
    }
    
    
}

- (void)setPersistentStoreOptionsInDocument:(UIManagedDocument *)document withICloud:(BOOL)useIcloud
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    
    //iCloud
    if (useIcloud) {
        [options setObject:[document.fileURL lastPathComponent] forKey:NSPersistentStoreUbiquitousContentNameKey];
        [options setObject:[self iCloudCoreDataLogFilesURL] forKey:NSPersistentStoreUbiquitousContentURLKey];
    }
    
    document.persistentStoreOptions = options;
}
-(void) createCourseWithExampleQuestions:(BOOL)useExampleQuestions{
    NSURL *url = [self.icloudSwitch.on?[self iCloudDocumentsURL]:[self localDocumentsDirectoryURL] URLByAppendingPathComponent:self.nameTextField.text];
    url = [url URLByAppendingPathExtension:@"mfCourse"];
    
    NSLog(@"URL: %@",url);
    UIManagedDocument *newDocument = [[UIManagedDocument alloc] initWithFileURL:url];
    [self setPersistentStoreOptionsInDocument:newDocument withICloud:self.icloudSwitch.on];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[newDocument.fileURL path]]) {
        [self.delegate didStartCreatingCourseWithURL:newDocument.fileURL inICloud:self.icloudSwitch.on];
        
        // does not exist on disk, so create it
        [newDocument saveToURL:newDocument.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [newDocument.managedObjectContext performBlock:^{
                    //Reload Main login screen information
                    Course *newCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:newDocument.managedObjectContext];
                        
                    Administrator *newAdmin = [NSEntityDescription insertNewObjectForEntityForName:@"Administrator" inManagedObjectContext:newDocument.managedObjectContext];
                    newAdmin.username = self.admin1Username.text.lowercaseString;
                    newAdmin.password = self.admin1Password.text.lowercaseString;
                    
                    [newCourse addAdministratorsObject:newAdmin];
                    
                    if (useExampleQuestions)
                        [self addDefaultQuestionSetsToCourse:newCourse];
                                        
                    [newDocument saveToURL:newDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
                        [newDocument closeWithCompletionHandler:^(BOOL success){
                            NSLog(@"Creating document intial data %@",success?@"Success":@"Fail");
                            [self.delegate didFinishCreatingCourseWithURL:newDocument.fileURL inICloud:self.icloudSwitch.on];
                        }];
                    }];
                }];
                /*
                    [newDocument saveToURL:newDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
                        if (success) {
                            [newDocument closeWithCompletionHandler:^(BOOL success){
                                [self.delegate didFinishCreatingCourseWithURL:newDocument.fileURL inICloud:self.icloudSwitch.on];
                            }];
                        }
                    }];
                 */
            }
        }];
        
        //Dismiss
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    }
    else {
        //Error: File already exists
        UIAlertView *duplicateAlert = [[UIAlertView alloc] initWithTitle:@"Duplicate" message:@"Course with this name already exists." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [duplicateAlert show];
    }

}
-(void) addDefaultQuestionSetsToCourse:(Course*)course{
    //Load information for plist
    NSDictionary *seedDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"databaseSeed" ofType:@"plist"]];
    //Add inital question set to new admins
    NSArray* seedQuestionSets = [seedDict objectForKey:@"Questions Sets"];
    
    //Step through each type
    for (NSArray* setTypeArray in seedQuestionSets) {
        NSNumber* setType = [setTypeArray objectAtIndex:0];
        
        //Step through each set
        [[setTypeArray objectAtIndex:1] enumerateObjectsUsingBlock:^(NSDictionary *questionSet,NSUInteger idx, BOOL *stop){
            //Create QuestionSet
            QuestionSet *qSet = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionSet" inManagedObjectContext:course.managedObjectContext];
            qSet.name = [NSString stringWithFormat:@"Set %d",idx+1];
            qSet.type = setType;
            qSet.difficultyLevel = [NSNumber numberWithInt:idx];
            
            //Set through each question
            [[questionSet objectForKey:@"questions"] enumerateObjectsUsingBlock:^(NSArray* question, NSUInteger idx, BOOL *stop){
                Question* newQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:course.managedObjectContext];
                
                // -1 signifies the blank in the question
                newQuestion.x = [[question objectAtIndex:0] intValue]>=0?[question objectAtIndex:0]:nil;
                newQuestion.y = [[question objectAtIndex:1] intValue]>=0?[question objectAtIndex:1]:nil;
                newQuestion.z = [[question objectAtIndex:2] intValue]>=0?[question objectAtIndex:2]:nil;
                newQuestion.questionOrder = [NSNumber numberWithInt:idx];
                [qSet addQuestionsObject:newQuestion];
            }];
            
            //Add new question set to all new admins
            [course addQuestionSetsObject:qSet];
        }];
    }

}
@end
