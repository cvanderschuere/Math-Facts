//
//  ResultsViewController.h
//  poacMF
//
//  Created by Matt Hunter on 5/6/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView				*__weak thisTableView;
	NSMutableArray			*__weak listOfUsersNSMA;
	NSMutableArray			*__weak listOfResultsNSMA;
	NSDictionary			*__weak detailsCountForUsersNSD;
	NSMutableArray			*__weak detailsForSelectedUserNSMA;
	BOOL					detailMode;
	int						selectedUserIndex;
	
}

@property (weak, nonatomic) IBOutlet	UITableView				*thisTableView;
@property (weak, nonatomic)			NSMutableArray			*listOfUsersNSMA;
@property (weak, nonatomic)			NSMutableArray			*listOfResultsNSMA;
@property (weak, nonatomic)			NSDictionary			*detailsCountForUsersNSD;
@property (weak, nonatomic)			NSMutableArray			*detailsForSelectedUserNSMA;
@property (nonatomic)					BOOL					detailMode;
@property (nonatomic)					int						selectedUserIndex;

@end
