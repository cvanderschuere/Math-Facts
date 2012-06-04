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

@property (nonatomic)				NSMutableArray			*listofQuestionSets;
@property (nonatomic)	IBOutlet	UITableView				*thisTableView;
@property (nonatomic)				UIPopoverController		*addDetailsPopoverController;
@property (nonatomic)				UIPopoverController		*addSetPopoverController;

-(void)		loadQuestionSets: (int) mathType;
-(IBAction) addSetButtonTapped: (id) sender;
-(IBAction) addDetailsButtonTapped: (id) sender;
-(IBAction) additionButtonTapped;
-(IBAction) subtractionButtonTapped;
-(IBAction) multiplicationButtonTapped;
-(IBAction) divisionButtonTapped;

-(void)		dismissPopovers;

@end
