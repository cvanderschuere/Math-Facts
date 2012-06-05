//
//  ResultsViewController.h
//  poacMF
//
//  Created by Matt Hunter on 5/6/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>

//Note: View is part of admin screen

@interface ResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}

@property (weak, nonatomic) IBOutlet	UITableView				*thisTableView;
@property (strong, nonatomic)			NSMutableArray			*listOfUsersNSMA;
@property (strong, nonatomic)			NSMutableArray			*listOfResultsNSMA;
@property (strong, nonatomic)			NSDictionary			*detailsCountForUsersNSD;
@property (strong, nonatomic)			NSMutableArray			*detailsForSelectedUserNSMA;
@property (nonatomic)					BOOL					detailMode;
@property (nonatomic)					int						selectedUserIndex;

@end
