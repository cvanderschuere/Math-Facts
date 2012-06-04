//
//  AdminViewController.m
//  poacMF
//
//  Created by Matt Hunter on 3/19/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "AdminViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PoacMFAppDelegate.h"
#import "AppConstants.h"

@implementation AdminViewController

@synthesize usersVC = _usersVC, questionSetsVC = _questionSetsVC, studentView = _studentView, questionsView = _questionsView, usersViewable = _usersViewable;
@synthesize resultsVC = _resultsVC, questionSetsViewable = _questionSetsViewable;


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	self.studentView.hidden = YES;
}//end method

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
}//end method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

-(IBAction) showQuestionSets {
	if (self.questionSetsViewable) {
		self.questionSetsViewable = NO;
		//create the frame for the view so that it exists off screen.
		int X_POSITION = 1024;
		int Y_POSITION = self.questionSetsVC.view.frame.origin.y;
		int WIDTH = self.questionSetsVC.view.frame.size.width;
		int HEIGHT = self.questionSetsVC.view.frame.size.height;
		CGRect frame = CGRectMake(X_POSITION,Y_POSITION,WIDTH, HEIGHT);
		self.questionSetsVC.view.frame = frame;
		
		// set up an animation for the transition between the views
		CATransition *animation = [CATransition animation];
		[animation setDuration:0.5];
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromRight];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
		//execute the animation
		[[self.questionSetsVC.view layer] addAnimation:animation forKey:@"SwitchToView2"];
	} else {		
        /*Matt: When I had this code in the viewDidLoad the views didn't
         slide in/out correctly after the first one. */
        
        //Create viewcontroller from nib if need-be and add as child
        if (!self.questionSetsVC){
            self.questionSetsVC = [[QuestionSetsViewController alloc] initWithNibName:QUESTION_SETS_VIEW_NIB bundle:nil];
            [self addChildViewController:self.questionSetsVC];
            [self.view addSubview:self.questionSetsVC.view];
            [self.questionSetsVC didMoveToParentViewController:self];
        }

        [self.questionSetsVC.thisTableView reloadData];
        
        //setup the frame of the subTopicsVC
        int WIDTH = 374;
        int HEIGHT = 600;
        int Y_POSITION = 125;
        
        int X_POSITION = (0);
        
        CGRect frame = CGRectMake(X_POSITION,Y_POSITION,WIDTH, HEIGHT);
        self.questionSetsVC.view.frame = frame;
        
        // set up an animation for the transition between the views
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        //call the animation
        [[self.questionSetsVC.view layer] addAnimation:animation forKey:@"SwitchToView4"];
		//turn the flag so that a second VC isn't created
		self.questionSetsViewable = YES;	
	}//end if
}//end method

-(IBAction) showUsers {
	if (self.usersViewable) {
		self.usersViewable = NO;
		//create the frame for the view so that it exists off screen.
		int X_POSITION = 1024;
		int Y_POSITION = self.usersVC.view.frame.origin.y;
		int WIDTH = self.usersVC.view.frame.size.width;
		int HEIGHT = self.usersVC.view.frame.size.height;
		CGRect frame = CGRectMake(X_POSITION,Y_POSITION,WIDTH, HEIGHT);
		self.usersVC.view.frame = frame;
		
		// set up an animation for the transition between the views
		CATransition *animation = [CATransition animation];
		[animation setDuration:0.5];
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromLeft];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
		//execute the animation
		[[self.usersVC.view layer] addAnimation:animation forKey:@"SwitchToView0"];
		
	} 
    else {
		[self.usersVC.thisTableView reloadData];
		
		//if we've never opened the view, slide it open
		if (!self.usersViewable) {
			/*create the VC with NIB. When I had this code in the viewDidLoad the views didn't
			 slide in/out correctly after the first one. */
            
            //Create viewcontroller from nib if need-be and add as child
            if (!self.usersVC){
                self.usersVC = [[UsersViewController alloc] initWithNibName:USERS_VIEW_NIB bundle:nil];
                [self addChildViewController:self.usersVC];
                [self.view addSubview:self.usersVC.view];
                [self.usersVC didMoveToParentViewController:self];
            }
			
			//setup the frame of the subTopicsVC
			int WIDTH = 374;
			int HEIGHT = 600;
			int Y_POSITION = 125;
			
			int X_POSITION = (self.view.frame.size.width - WIDTH);
			if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
				self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
				X_POSITION = 650;
			}//end
			
			CGRect frame = CGRectMake(X_POSITION,Y_POSITION,WIDTH, HEIGHT);
			self.usersVC.view.frame = frame;
			
			// set up an animation for the transition between the views
			CATransition *animation = [CATransition animation];
			[animation setDuration:0.5];
			[animation setType:kCATransitionPush];
			[animation setSubtype:kCATransitionFromRight];
			[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
			//call the animation
			[[self.usersVC.view layer] addAnimation:animation forKey:@"SwitchToView1"];
		}//end if
		//turn the flag so that a second VC isn't created
		self.usersViewable = YES;	
	}//end if
}//end method

#pragma mark Button Methods
-(IBAction) logOut: (id) sender {
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Logout?" 
		delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Logout" 
		otherButtonTitles:@"Cancel", nil, nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
}//end method

#pragma mark - Action Sheet Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	PoacMFAppDelegate *appDelegate = (PoacMFAppDelegate *)[[UIApplication sharedApplication] delegate];	
    if (buttonIndex == 0){
        appDelegate.loggedIn = NO;
		[self dismissModalViewControllerAnimated:YES];
	}//end
}//end method

@end
