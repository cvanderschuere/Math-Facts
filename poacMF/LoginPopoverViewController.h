//
//  LoginPopoverViewController.h
//  poacMF
//
//  Created by Matt Hunter on 3/19/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TesterViewController.h"

@interface LoginPopoverViewController : UIViewController 
	<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {    
	
	UITableView				*thisTableView;
	UINavigationBar			*thisNavBar;
	UITextField				*userNameTextField;
	UITextField				*passwordTextField;
}//end interface

@property (nonatomic, retain) IBOutlet	UITableView				*thisTableView;
@property (nonatomic, retain) IBOutlet	UINavigationBar			*thisNavBar;
@property (nonatomic, retain) IBOutlet	UITextField				*userNameTextField;
@property (nonatomic, retain) IBOutlet	UITextField				*passwordTextField;

-(IBAction) cancelTapped;
-(IBAction) loginTapped;
@end
