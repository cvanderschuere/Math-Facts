//
//  TestDetailViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "TestDetailViewController.h"
#import "Result.h"
#import "AdjustTestPopoverViewController.h"
#import "ResultDetailViewController.h"

@interface TestDetailViewController ()

@property (nonatomic, strong) NSMutableArray* testResults;
@property (nonatomic, strong) NSMutableArray* practiceResults;

@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic) int maxNumberY;

@end

@implementation TestDetailViewController
@synthesize popover = _popover;
@synthesize test = _test;
@synthesize resultsTableView = _resultsTableView;
@synthesize testResults = _testResults, practiceResults = _practiceResults;
@synthesize graphView = _graphView;
@synthesize maxNumberY = _maxNumberY;

-(void) setTest:(Test *)test{
    if (![_test isEqual:test]) {
        _test = test;
        
        self.title = [NSString stringWithFormat:@"%@. %@ (%@)",_test.student.firstNameInital,_test.student.lastName,_test.questionSet.name];
        
        self.testResults = _test.results.allObjects.mutableCopy;
        
        [self.testResults sortUsingComparator:^NSComparisonResult(Result *obj1, Result *obj2){
            return [obj1.startDate compare:obj2.startDate];
        }];
        
        self.practiceResults = _test.practice.results.allObjects.mutableCopy;
        [self.practiceResults sortUsingComparator:^NSComparisonResult(Result *obj1, Result *obj2){
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
-(void) viewWillDisappear:(BOOL)animated{
    [self.popover dismissPopoverAnimated:animated];
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
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"resultDetailSegue"]) {
        //Find index path of sender
        NSIndexPath* selectedCellIndex = [self.resultsTableView indexPathForCell:sender];
        if (selectedCellIndex.section == 0)
            [segue.destinationViewController setResult:(Result*)[self.testResults objectAtIndex:selectedCellIndex.row]];
        else if (selectedCellIndex.section == 1)
            [segue.destinationViewController setResult:(Result*)[self.practiceResults objectAtIndex:selectedCellIndex.row]];

        //Clear Selection
        [self.resultsTableView deselectRowAtIndexPath:selectedCellIndex animated:NO];
    }
}

-(void)constructBarChart
{
    // Create barChart from theme
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    self.graphView.hostedGraph             = graph;
    graph.plotAreaFrame.masksToBorder = NO;
    

    graph.paddingLeft   = 60;
    graph.paddingTop    = 0;
    graph.paddingRight  = 0;
    graph.paddingBottom = 30;
    
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate = self;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(55.0f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(7.0f)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    // Define some custom labels for the data elements
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
	NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:self.testResults.count];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd";
    
	[self.testResults enumerateObjectsUsingBlock:^(Result* result, NSUInteger idx, BOOL *stop){
        //Use Date formatter to make date
        NSString *dateString = [dateFormatter stringFromDate:result.startDate];
        
		CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:dateString textStyle:x.labelTextStyle];
		newLabel.tickLocation = [[NSDecimalNumber numberWithFloat:idx + .5] decimalValue];
        newLabel.alignment = CPTAlignmentCenter;
        newLabel.offset = 1;
		[customLabels addObject:newLabel];
        
        //Checkf if new max Y number
        if (self.maxNumberY < result.correctResponses.count)
            self.maxNumberY = result.correctResponses.count;
        if (self.maxNumberY < result.incorrectResponses.count)
            self.maxNumberY = result.incorrectResponses.count;
        
	}];
    
	x.axisLabels = [NSSet setWithArray:customLabels];
        
    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle               = nil;
    y.majorTickLineStyle          = nil;
    y.minorTickLineStyle          = nil;
    y.majorIntervalLength         = CPTDecimalFromString(@"10");
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    y.title                       = @"Questions / Minute";
    y.titleOffset                 = 40.0f;
    y.titleLocation               = CPTDecimalFromFloat(20.0f);
    y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(55.0f)];
    
    /*
    //Correct Scatter Plot
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.identifier = @"Green Plot";
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 3.f;
    lineStyle.lineColor              = [CPTColor greenColor];
    lineStyle.dashPattern            = [NSArray arrayWithObjects:[NSNumber numberWithFloat:5.0f], [NSNumber numberWithFloat:5.0f], nil];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    
    // Put an area gradient under the plot above
    CPTColor *areaColor       = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    areaGradient.angle = -90.0f;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    dataSourceLinePlot.areaFill      = areaGradientFill;
    dataSourceLinePlot.areaBaseValue = CPTDecimalFromString(@"1.75");
    
    // Animate in the new plot, as an example
    dataSourceLinePlot.opacity        = 0.0f;
    dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionAuto;
    [graph addPlot:dataSourceLinePlot toPlotSpace:plotSpace];
    */

    // Correct plot
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor lightGrayColor] horizontalBars:NO];
    barPlot.baseValue  = CPTDecimalFromString(@"0");
    barPlot.dataSource = self;
    barPlot.delegate = self;
    barPlot.barOffset  = CPTDecimalFromFloat(-0.5f);
    //barPlot.barWidth = [NSDecimalNumber decimalNumberWithString:@"0.5"].decimalValue;
    barPlot.cornerRadius = 5;
    barPlot.identifier = @"Bar Plot Correct";
    [graph addPlot:barPlot toPlotSpace:plotSpace];
    
    // Incorrect plot
    CPTBarPlot *barPlot2 = [CPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithComponentRed:1 green:0 blue:0 alpha:.2] horizontalBars:NO];
    barPlot2.baseValue  = CPTDecimalFromString(@"0");
    barPlot2.dataSource = self;
    barPlot2.delegate = self;
    barPlot2.barOffset  = CPTDecimalFromFloat(-0.5f);
    //barPlot2.barWidth = [NSDecimalNumber decimalNumberWithString:@"0.5"].decimalValue;
    barPlot2.cornerRadius = 5;
    barPlot2.identifier = @"Bar Plot Incorrect";
    [graph addPlot:barPlot2 toPlotSpace:plotSpace];

}
#pragma mark - CPTBarPlot delegate method

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    UITableViewCell *selectedCell = [self.resultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [self performSegueWithIdentifier:@"resultDetailSegue" sender:selectedCell];
}
-(float) percentageCorrectForResult:(Result*)result{
    float correct = result.correctResponses.count;
    float incorrect = result.incorrectResponses.count;
    float percentageCorrect = correct/(correct + incorrect);
    percentageCorrect *=100;
    return percentageCorrect;
}
-(float) questionsCorrectPerMinutesForResult:(Result*)result{
    return result.correctResponses.count * ((60.0f)/([result.endDate timeIntervalSinceDate:result.startDate]));
}
-(float) questionsIncorrectPerMinutesForResult:(Result*)result{
    return result.incorrectResponses.count * ((60.0f)/([result.endDate timeIntervalSinceDate:result.startDate]));
}

#pragma mark - Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        return self.testResults.count;
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
		// length - calculate QPM
        num = [plot.identifier isEqual:@"Bar Plot Correct"]?[NSDecimalNumber numberWithFloat:[self questionsCorrectPerMinutesForResult:[self.testResults objectAtIndex:index]]]:[NSDecimalNumber numberWithFloat:[self questionsIncorrectPerMinutesForResult:[self.testResults objectAtIndex:index]]];
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
    int percentageCorrect = (int)  [plot.identifier isEqual:@"Bar Plot Correct"]?[self questionsCorrectPerMinutesForResult:[self.testResults objectAtIndex:index]]:[self questionsIncorrectPerMinutesForResult:[self.testResults objectAtIndex:index]];
    newLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%d", percentageCorrect] style:whiteText];   
    
    return newLayer;
}
#pragma mark -
#pragma mark Plot Space Delegate Methods

-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
	// Impose a limit on how far user can scroll in x
	if ( coordinate == CPTCoordinateX ) {
		CPTPlotRange *maxRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(self.testResults.count+5)];
		CPTMutablePlotRange *changedRange = [newRange mutableCopy];
		[changedRange shiftEndToFitInRange:maxRange];
		[changedRange shiftLocationToFitInRange:maxRange];
		newRange = changedRange;
	}
    else {
        CPTPlotRange *maxRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(self.maxNumberY + 5.0)];
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
    NSInteger sections = self.testResults.count>0?1:0;
    sections += (self.practiceResults.count)>0?1:0;
    return sections;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?self.testResults.count:self.practiceResults.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    
    //Customize Cell
    cell.textLabel.text = [NSDateFormatter localizedStringFromDate:[[indexPath.section==0?self.testResults:self.practiceResults objectAtIndex:indexPath.row] startDate]  dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterShortStyle];
    if (indexPath.section == 0) {
        //Determine if timing was passed
        Result* result = [self.testResults objectAtIndex:indexPath.row];
        cell.imageView.image = result.didPass.boolValue?[UIImage imageNamed:@"passStamp"]:nil;
    }
    return cell;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section==0 && self.testResults.count>0?@"Timing":@"Practice"; //Customize section header
}

- (IBAction)adjustTestPressed:(id)sender {
    if (self.popover.isPopoverVisible) {
        return [self.popover dismissPopoverAnimated:YES];
    }
    //Create view from storyboard and present
    AdjustTestPopoverViewController* adjustVC = [self.storyboard instantiateViewControllerWithIdentifier:@"adjustTestPopoverViewController"];
    adjustVC.testToAdjust = self.test;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:adjustVC];
    [self.popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}
@end
