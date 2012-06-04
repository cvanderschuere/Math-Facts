//
//  QuestionSetsTableViewController.h
//  poacMF
//
//  Created by Matt Hunter on 3/29/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuestionSetsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray			*listofQuestionSets;
	UITableView				*thisTableView;
	UIPopoverController		*addDetailsPopoverController;
	UIPopoverController		*addSetPopoverController;
    
}

@property (nonatomic, retain)				NSMutableArray			*listofQuestionSets;
@property (nonatomic, retain)	IBOutlet	UITableView				*thisTableView;
@property (nonatomic, retain)				UIPopoverController		*addDetailsPopoverController;
@property (nonatomic, retain)				UIPopoverController		*addSetPopoverController;

-(void)		loadQuestionSets: (int) mathType;
-(IBAction) addSetButtonTapped: (id) sender;
-(IBAction) addDetailsButtonTapped: (id) sender;
-(IBAction) additionButtonTapped;
-(IBAction) subtractionButtonTapped;
-(IBAction) multiplicationButtonTapped;
-(IBAction) divisionButtonTapped;

-(void)		dismissPopovers;

@end
