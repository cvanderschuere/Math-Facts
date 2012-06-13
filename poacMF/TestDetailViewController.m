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
@synthesize graphView = _graphView;


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
    [self constructBarChart];
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
-(void)constructBarChart
{
    // Create barChart from theme
    CPTXYGraph *barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [barChart applyTheme:theme];
    self.graphView.hostedGraph             = barChart;
    barChart.plotAreaFrame.masksToBorder = NO;
    

    barChart.paddingLeft   = 60;
    barChart.paddingTop    = 10;
    barChart.paddingRight  = 0;
    barChart.paddingBottom = 30;
    
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate = self;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(110.0f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(self.results.count*5)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    // Define some custom labels for the data elements
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
	NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:self.results.count];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"mm/dd";
    
	[self.results enumerateObjectsUsingBlock:^(Result* result, NSUInteger idx, BOOL *stop){
        //Use Date formatter to make date
        NSString *dateString = [dateFormatter stringFromDate:result.startDate];
        
		CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:dateString textStyle:x.labelTextStyle];
		newLabel.tickLocation = [[NSDecimalNumber numberWithFloat:idx + .5] decimalValue];
        newLabel.alignment = CPTAlignmentCenter;
        newLabel.offset = 1;
		[customLabels addObject:newLabel];
	}];
    
	x.axisLabels = [NSSet setWithArray:customLabels];
        
    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle               = nil;
    y.majorTickLineStyle          = nil;
    y.minorTickLineStyle          = nil;
    y.majorIntervalLength         = CPTDecimalFromString(@"20");
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    y.title                       = @"Correct %";
    y.titleOffset                 = 40.0f;
    y.titleLocation               = CPTDecimalFromFloat(50.0f);
    y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
    
    // First bar plot
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor darkGrayColor] horizontalBars:NO];
    barPlot.baseValue  = CPTDecimalFromString(@"0");
    barPlot.dataSource = self;
    barPlot.delegate = self;
    barPlot.barOffset  = CPTDecimalFromFloat(-0.5f);
    //barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor darkGrayColor].CGColor]];
    barPlot.cornerRadius = 5;
    barPlot.identifier = @"Bar Plot 1";
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
}
#pragma mark - CPTBarPlot delegate method

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    [self.resultsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];;
}
-(float) percentageCorrectForResult:(Result*)result{
    NSLog(@"Result: C:%d I:%d", result.questionsCorrect.count,result.questionsIncorrect.count);
    float correct = result.questionsCorrect.count;
    float incorrect = result.questionsIncorrect.count;
    float percentageCorrect = correct/(correct + incorrect);
    percentageCorrect *=100;
    return percentageCorrect;
}

#pragma mark - Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        return self.results.count;
    }
    else {
        return 0;
    }
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    
	if ( fieldEnum == CPTBarPlotFieldBarLocation ) {
		// location
        num = [NSDecimalNumber numberWithInt:index +1];
	}
	else if ( fieldEnum == CPTBarPlotFieldBarTip ) {
		// length - calculate percentage correct
        num = [NSDecimalNumber numberWithFloat:[self percentageCorrectForResult:[self.results objectAtIndex:index]]];
	}
	else {
		// base
        num = [NSDecimalNumber numberWithInt:0];
    }
    
	return num;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    static CPTMutableTextStyle *whiteText = nil;
    
    if (!whiteText ) {
        whiteText       = [[CPTMutableTextStyle alloc] init];
        whiteText.color = [CPTColor whiteColor];
    }
    
    CPTTextLayer *newLayer = nil;
    int percentageCorrect = (int)  [self percentageCorrectForResult:[self.results objectAtIndex:index]];
    newLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%d", index] style:whiteText];   
    
    return nil;
}
#pragma mark -
#pragma mark Plot Space Delegate Methods

-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
	// Impose a limit on how far user can scroll in x
	if ( coordinate == CPTCoordinateX ) {
		CPTPlotRange *maxRange			  = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(self.results.count+5)];
		CPTMutablePlotRange *changedRange = [newRange mutableCopy];
		[changedRange shiftEndToFitInRange:maxRange];
		[changedRange shiftLocationToFitInRange:maxRange];
		newRange = changedRange;
	}
    else {
        CPTPlotRange *maxRange			  = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
		CPTMutablePlotRange *changedRange = [newRange mutableCopy];
		[changedRange shiftEndToFitInRange:maxRange];
		[changedRange shiftLocationToFitInRange:maxRange];
		newRange = changedRange;    
    }
    
	return newRange;
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
