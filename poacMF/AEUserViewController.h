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

@property (nonatomic)	IBOutlet	UITableView		*thisTableView;
@property (nonatomic)	IBOutlet	UITextField		*usernameTF;
@property (nonatomic)	IBOutlet	UITextField		*firstNameTF;
@property (nonatomic)	IBOutlet	UITextField		*lastNameTF;
@property (nonatomic)	IBOutlet	UITextField		*passwordTF;
@property (nonatomic)	IBOutlet	UITextField		*emailAddressTF;
@property (nonatomic)	IBOutlet	UITextField		*userPracticeTimeLimitTF;
@property (nonatomic)	IBOutlet	UITextField		*userTimedTimeLimitTF;
@property (nonatomic)	IBOutlet	UITextField		*delayRetakeTF;
@property (nonatomic)	IBOutlet	UISwitch		*adminstratorSwitch;
@property (nonatomic)	IBOutlet	UISwitch		*studentSwitch;
@property (nonatomic)						BOOL			editMode;
@property (nonatomic)				User			*updateUser;

@property (nonatomic)				UITableView			*ptrTableToRedraw;

-(IBAction) cancelClicked;
-(IBAction) saveClicked;
-(IBAction) adminSet: (id) sender;
-(IBAction) studentSet: (id) sender;

-(UITextField *) createTextField;

@end
