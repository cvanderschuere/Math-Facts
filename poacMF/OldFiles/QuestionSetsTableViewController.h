//
//  QuestionSetsTableViewController.h
//  poacMF
//
//  Created by Matt Hunter on 3/29/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuestionSetsTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray			*listofQuestionSets;
	UITableView				*thisTableView;
    
}

@property (nonatomic, retain)				NSMutableArray			*listofQuestionSets;
@property (nonatomic, retain)	IBOutlet	UITableView				*thisTableView;

@end
