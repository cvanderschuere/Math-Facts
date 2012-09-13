//
//  QuestionSetsTableViewController.h
//  poacMF
//
//  Created by Matt Hunter on 3/29/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuestionSetsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray			*__weak listofQuestionSets;
	UITableView				*__weak thisTableView;
	UIPopoverController		*addDetailsPopoverController;
	UIPopoverController		*addSetPopoverController;
    
}

@property (weak, nonatomic)				NSMutableArray			*listofQuestionSets;
@property (weak, nonatomic)	IBOutlet	UITableView				*thisTableView;
@property (nonatomic, strong)				UIPopoverController		*addDetailsPopoverController;
@property (nonatomic, strong)				UIPopoverController		*addSetPopoverController;

-(void)		loadQuestionSets: (int) mathType;
-(IBAction) addSetButtonTapped: (id) sender;
-(IBAction) addDetailsButtonTapped: (id) sender;
-(IBAction) additionButtonTapped;
-(IBAction) subtractionButtonTapped;
-(IBAction) multiplicationButtonTapped;
-(IBAction) divisionButtonTapped;

-(void)		dismissPopovers;

@end
