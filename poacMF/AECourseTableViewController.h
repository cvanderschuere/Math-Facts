//
//  AECourseTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 11/07/2012.
//  Copyright (c) 2012 CDVConcepts. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AECourseProtocol <NSObject>

-(void) didStartCreatingCourseWithURL:(NSURL*)newCourseURL inICloud:(BOOL) inICloud;
-(void) didFinishCreatingCourseWithURL: (NSURL*)newCourseURL  inICloud:(BOOL) inICloud;

@end

@interface AECourseTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *icloudSwitch;
@property (weak, nonatomic) IBOutlet UITextField *admin1Username;
@property (weak, nonatomic) IBOutlet UITextField *admin1Password;

@property (weak, nonatomic) id <AECourseProtocol> delegate;


- (IBAction)courseSaved:(id)sender;

@end
