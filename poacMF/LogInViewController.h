//
//  LoginViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 04/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet	UITextField				*userNameTextField;
@property (nonatomic, weak) IBOutlet	UITextField				*passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic) BOOL readyToLogin;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

-(IBAction) loginTapped;
- (IBAction)sendFeedback:(id)sender;

@end
