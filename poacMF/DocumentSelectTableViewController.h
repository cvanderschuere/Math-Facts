//
//  DocumentSelectTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 11/07/2012.
//  Copyright (c) 2012 CDVConcepts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AECourseTableViewController.h"

@protocol DocumentSelectProtocol <NSObject>

-(void) didSelectDocumentWithURL:(NSURL*) url;
-(void) didDeleteDocumentWithURL:(NSURL*) deletedURL;

@end


@interface DocumentSelectTableViewController : UITableViewController <AECourseProtocol>

@property (nonatomic, strong) NSMutableArray* icloudDocuments;
@property (nonatomic, strong) NSMutableArray* localDocuments;
@property (nonatomic, strong) UIManagedDocument *selectedDocument;
@property (nonatomic, weak) id<DocumentSelectProtocol> delegate;

- (IBAction)toggleEditMode:(id)sender;

@end
