//
//  AdminMasterTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "CoreDataTableViewController.h"

@protocol AdminSplitViewCommunicationDelegate <NSObject>

-(void) didSelectObject: (id) aObject;
-(void) didDeleteObject: (id) aObject;

@end


@interface AdminMasterTableViewController : CoreDataTableViewController <UIActionSheetDelegate>

-(IBAction)logout:(id)sender;


@property (nonatomic, weak) IBOutlet id<AdminSplitViewCommunicationDelegate> delegate;


@end
