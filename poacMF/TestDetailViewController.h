//
//  TestDetailViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Test.h"

@interface TestDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CPTBarPlotDataSource, CPTBarPlotDelegate, CPTPlotSpaceDelegate>

@property (nonatomic, strong) Test* test;
@property (nonatomic, weak) IBOutlet UITableView* resultsTableView;
@property (nonatomic, weak) IBOutlet CPTGraphHostingView *graphView;
- (IBAction)adjustTestPressed:(id)sender;


@end
