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
	
	UITableView				*__weak thisTableView;
	UINavigationBar			*__weak thisNavBar;
	UITextField				*__weak userNameTextField;
	UITextField				*__weak passwordTextField;
}//end interface

@property (weak, nonatomic) IBOutlet	UITableView				*thisTableView;
@property (weak, nonatomic) IBOutlet	UINavigationBar			*thisNavBar;
@property (weak, nonatomic) IBOutlet	UITextField				*userNameTextField;
@property (weak, nonatomic) IBOutlet	UITextField				*passwordTextField;

-(IBAction) cancelTapped;
-(IBAction) loginTapped;
@end
