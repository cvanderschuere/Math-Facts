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

@property (nonatomic, weak)	IBOutlet	UITableView		*thisTableView;
@property (nonatomic, weak)	IBOutlet	UITextField		*usernameTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*firstNameTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*lastNameTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*passwordTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*emailAddressTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*userPracticeTimeLimitTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*userTimedTimeLimitTF;
@property (nonatomic, weak)	IBOutlet	UITextField		*delayRetakeTF;
@property (nonatomic, weak)	IBOutlet	UISwitch		*adminstratorSwitch;
@property (nonatomic, weak)	IBOutlet	UISwitch		*studentSwitch;
@property (nonatomic)						BOOL			editMode;
@property (nonatomic, strong)				User			*updateUser;

@property (nonatomic, strong)				UITableView			*ptrTableToRedraw;

-(IBAction) cancelClicked;
-(IBAction) saveClicked;
-(IBAction) adminSet: (id) sender;
-(IBAction) studentSet: (id) sender;

-(UITextField *) createTextField;

@end
