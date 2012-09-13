//
//  poacMFViewController.h
//  poacMF
//
//  Created by Matt Hunter on 3/17/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoacMFAppDelegate.h"
#import "POACDetailViewController.h"

@interface PoacMFViewController : POACDetailViewController <UIActionSheetDelegate, UIPopoverControllerDelegate> {
    
	UIToolbar		*thisToolBar;
	UIPopoverController		*meetingListPopoverController;
}

@property (nonatomic, retain)	IBOutlet	UIToolbar		*thisToolBar;
@property (nonatomic, retain)	UIPopoverController		*loginPopoverController;

-(void)			dismissThePopovers; 
-(IBAction)		logInOut: (id) sender;

@end
