//
//  AEUserViewController.h
//  poacMF
//
//  Created by Matt Hunter on 3/25/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AEUserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    UITableView		*thisTableView;
	UITextField		*usernameTF;
	UITextField		*firstNameTF;
	UITextField		*lastNameTF;
	UITextField		*passwordTF;
	UITextField		*emailAddressTF;
	UITextField		*userPracticeTimeLimitTF;
	UITextField		*userTimedTimeLimitTF;
	UITextField		*delayRetakeTF;
	UISwitch		*adminstratorSwitch;
	UISwitch		*studentSwitch;
	BOOL			editMode;
	User			*updateUser;
	
    UITableView			*ptrTableToRedraw;
	
}

@property (nonatomic, retain)	IBOutlet	UITableView		*thisTableView;
@property (nonatomic, retain)	IBOutlet	UITextField		*usernameTF;
@property (nonatomic, retain)	IBOutlet	UITextField		*firstNameTF;
@property (nonatomic, retain)	IBOutlet	UITextField		*lastNameTF;
@property (nonatomic, retain)	IBOutlet	UITextField		*passwordTF;
@property (nonatomic, retain)	IBOutlet	UITextField		*emailAddressTF;
@property (nonatomic, retain)	IBOutlet	UITextField		*userPracticeTimeLimitTF;
@property (nonatomic, retain)	IBOutlet	UITextField		*userTimedTimeLimitTF;
@property (nonatomic, retain)	IBOutlet	UITextField		*delayRetakeTF;
@property (nonatomic, retain)	IBOutlet	UISwitch		*adminstratorSwitch;
@property (nonatomic, retain)	IBOutlet	UISwitch		*studentSwitch;
@property (nonatomic)						BOOL			editMode;
@property (nonatomic, retain)				User			*updateUser;

@property (nonatomic, retain)				UITableView			*ptrTableToRedraw;

-(IBAction) cancelClicked;
-(IBAction) saveClicked;
-(IBAction) adminSet: (id) sender;
-(IBAction) studentSet: (id) sender;

-(UITextField *) createTextField;

@end
