//
//  ResultsViewController.h
//  poacMF
//
//  Created by Matt Hunter on 5/6/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView				*thisTableView;
	NSMutableArray			*listOfUsersNSMA;
	NSMutableArray			*listOfResultsNSMA;
	NSDictionary			*detailsCountForUsersNSD;
	NSMutableArray			*detailsForSelectedUserNSMA;
	BOOL					detailMode;
	int						selectedUserIndex;
	
}

@property (nonatomic, retain) IBOutlet	UITableView				*thisTableView;
@property (nonatomic, retain)			NSMutableArray			*listOfUsersNSMA;
@property (nonatomic, retain)			NSMutableArray			*listOfResultsNSMA;
@property (nonatomic, retain)			NSDictionary			*detailsCountForUsersNSD;
@property (nonatomic, retain)			NSMutableArray			*detailsForSelectedUserNSMA;
@property (nonatomic)					BOOL					detailMode;
@property (nonatomic)					int						selectedUserIndex;

@end
