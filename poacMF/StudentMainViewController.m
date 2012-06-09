//
//  UserProgressViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "StudentMainViewController.h"


@interface StudentMainViewController ()

@end

@implementation StudentMainViewController
@synthesize currentStudent = _currentStudent;

-(void) setCurrentStudent:(Student *)currentStudent{
    NSLog(@"Current Student: %@",currentStudent);
    if (![_currentStudent isEqual:currentStudent]) {
        _currentStudent = currentStudent;

        self.title = _currentStudent.firstName;
    }
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
#pragma mark Button Methods
-(IBAction) logOut: (id) sender {
    [self.parentViewController dismissModalViewControllerAnimated:YES];
    return;
    //2) confirmatory logout prompt if they are logged in
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Logout?" 
                                                            delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Logout" 
                                                   otherButtonTitles:@"Cancel", nil, nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
}//end method


@end
