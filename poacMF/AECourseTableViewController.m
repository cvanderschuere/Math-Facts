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
    NSLog(@"iCloud Container: %@",[[self iCloudURL] URLByAppendingPathComponent:@"Documents"].absoluteString);

}

- (NSURL *)iCloudDocumentsURL
{
    NSLog(@"iCloud URL: %@",[[self iCloudURL] URLByAppendingPathComponent:@"Documents"].absoluteString);
    return [[self iCloudURL] URLByAppendingPathComponent:@"Documents"];
}


#pragma mark - IBActions
- (IBAction)courseSaved:(id)sender {
    //Check validity of information
    AppLibrary *lib = [[AppLibrary alloc] init];
    if (self.nameTextField.text.length == 0) {
        return [lib showAlertFromDelegate:self withWarning:@"Must enter name"];
    }   
    if (self.admin1Username.text.length == 0) {
        return [lib showAlertFromDelegate:self withWarning:@"Must enter administrator"];
    }
    if (self.admin1Password.text.length == 0) {
        return [lib showAlertFromDelegate:self withWarning:@"Must enter administrator"];
    }
     
    
    
    NSURL *url = [self.icloudSwitch.on?[self iCloudDocumentsURL]:[self localDocumentsDirectoryURL] URLByAppendingPathComponent:self.nameTextField.text];
    url = [url URLByAppendingPathExtension:@"mfCourse"];

    NSLog(@"URL: %@",url);
    UIManagedDocument *newDocument = [[UIManagedDocument alloc] initWithFileURL:url];
        
    if (![[NSFileManager defaultManager] fileExistsAtPath:[newDocument.fileURL path]]) {
        [self.delegate didStartCreatingCourseWithURL:newDocument.fileURL inICloud:self.icloudSwitch.on];
        
        // does not exist on disk, so create it
        [newDocument saveToURL:newDocument.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                //Reload Main login screen information
                
                [newDocument openWithCompletionHandler:^(BOOL success){
                    //Add inital Data
                    Course *newCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:newDocument.managedObjectContext];
                    
                    Administrator *newAdmin = [NSEntityDescription insertNewObjectForEntityForName:@"Administrator" inManagedObjectContext:newDocument.managedObjectContext];
                    newAdmin.username = self.admin1Username.text;
                    newAdmin.password = self.admin1Password.text;
                    
                    [newCourse addAdministratorsObject:newAdmin];
                    
                    [newDocument saveToURL:newDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
                        [self.delegate didFinishCreatingCourseWithURL:newDocument.fileURL inICloud:self.icloudSwitch.on];
                    }];
                }];
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
@end
