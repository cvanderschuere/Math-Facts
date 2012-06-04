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

@property (nonatomic) IBOutlet	UITableView				*thisTableView;
@property (nonatomic)			NSMutableArray			*listOfUsersNSMA;
@property (nonatomic)			NSMutableArray			*listOfResultsNSMA;
@property (nonatomic)			NSDictionary			*detailsCountForUsersNSD;
@property (nonatomic)			NSMutableArray			*detailsForSelectedUserNSMA;
@property (nonatomic)					BOOL					detailMode;
@property (nonatomic)					int						selectedUserIndex;

@end
