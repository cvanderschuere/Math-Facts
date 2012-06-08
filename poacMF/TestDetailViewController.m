//
//  TestDetailViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "TestDetailViewController.h"

@interface TestDetailViewController ()

@end

@implementation TestDetailViewController
@synthesize test = _test;
@synthesize resultsTableView = _resultsTableView;


-(void) setTest:(Test *)test{
    if (![_test isEqual:test]) {
        _test = test;
        
        self.title = _test.questionSet.name;
        
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
    return self.test.results.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"]; 
    return cell;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Results";
}

@end
