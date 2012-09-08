//
//  AdminMasterTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "SummaryTableViewController.h"

@protocol AdminSplitViewCommunicationDelegate <NSObject>
//Used to inform detai view of object selection
-(void) didSelectObject: (id) aObject;
-(void) didDeleteObject: (id) aObject;

@end


@interface AdminMasterTableViewController : CoreDataTableViewController <UIActionSheetDelegate>

-(IBAction)logout:(id)sender;


@property (nonatomic, weak) IBOutlet id<AdminSplitViewCommunicationDelegate> delegate;


@end
