//
//  TestDetailViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "TestDetailViewController.h"
#import "Result.h"

@interface TestDetailViewController ()

@property (nonatomic, strong) NSMutableArray* results;

@end

@implementation TestDetailViewController
@synthesize test = _test;
@synthesize resultsTableView = _resultsTableView;
@synthesize results = _results;


-(void) setTest:(Test *)test{
    if (![_test isEqual:test]) {
        _test = test;
        
        self.title = _test.questionSet.name;
        
        self.results = _test.results.allObjects.mutableCopy;
        
        [self.results sortUsingComparator:^NSComparisonResult(Result *obj1, Result *obj2){
            return [obj1.startDate compare:obj2.startDate];
        }];
        
        //Update Results
        [self.resultsTableView reloadData];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma UITableView DataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    cell.textLabel.text = [NSDateFormatter localizedStringFromDate:[[self.results objectAtIndex:indexPath.row] startDate]  dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    return cell;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Results";
}

@end
