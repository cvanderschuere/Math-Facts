//
//  MFLoginViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 11/07/2012.
//  Copyright (c) 2012 CDVConcepts. All rights reserved.
//

/*
    Overview
 
Docuemt Select
    -choose from local or icloud
    -use keyvalue store to save currently selected

Edit Document
    -change name (changes file url)
    -change icloud/local status
 
Create Document
    -Create new courses
 
Delete document
    -must be admin of that document
 
Document Status
    -better information about document status
    -tell user of saving errors
    -conflict resolution
 */



#import <UIKit/UIKit.h>
#import "DocumentSelectTableViewController.h"

@interface MFLoginViewController : UIViewController <UITextFieldDelegate, DocumentSelectProtocol>

@property (nonatomic, weak) IBOutlet	UITextField				*userNameTextField;
@property (nonatomic, weak) IBOutlet	UITextField				*passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic) BOOL readyToLogin;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildString;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *documentStateActivityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectCourseBarButton;


- (IBAction)selectCourse:(id)sender;
-(IBAction) loginTapped;
- (IBAction)sendFeedback:(id)sender;

@end
