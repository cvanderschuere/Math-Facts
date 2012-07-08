//
//  StudentGraphPopoverViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 08/07/2012.
//  Copyright (c) 2012 CDVConcepts. All rights reserved.
//

#import "StudentGraphPopoverViewController.h"
#import "Test.h"

#define NUMBER_OF_RESULTS 8

@interface StudentGraphPopoverViewController ()
@property (nonatomic, strong) CPTScatterPlot *correctPlot;
@property (nonatomic, strong) CPTScatterPlot *incorrectPlot;
@property (nonatomic) int maxNumberY;

@end

@implementation StudentGraphPopoverViewController
@synthesize graphView = _graphView;
@synthesize correctPlot = _correctPlot, incorrectPlot = _incorrectPlot, maxNumberY = _maxNumberY;
@synthesize resultsArray = _resultsArray;

-(void) setResultsArray:(NSArray *)resultsArray{
    if (![_resultsArray isEqualToArray:resultsArray]) {
        //Filter out practice results
        resultsArray = [resultsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isPractice == %@",[NSNumber numberWithBool:NO]]];
        
        //Sort by startDate
        resultsArray = [resultsArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]]];
        
        _resultsArray = resultsArray;
        [self.graphView.hostedGraph reloadData];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self constructGraph];
	// Do any additional setup after loading the view.
}
#pragma mark - Graph Methods
-(void) constructGraph{
    // Create barChart from theme
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    self.graphView.hostedGraph             = graph;
    graph.plotAreaFrame.masksToBorder = NO;
    
    graph.paddingLeft   = 58;
    graph.paddingTop    = 0;
    graph.paddingRight  = 0;
    graph.paddingBottom = 40;
    
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate = self;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.0f) length:CPTDecimalFromFloat(65.0f)];
    if (self.resultsArray.count>8) {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(self.resultsArray.count - NUMBER_OF_RESULTS + .5) length:CPTDecimalFromFloat(NUMBER_OF_RESULTS)];
    }
    else {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.5f) length:CPTDecimalFromFloat(NUMBER_OF_RESULTS)];
    }
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    x.majorIntervalLength = CPTDecimalFromString(@".5");
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
    
    
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    CPTMutableTextStyle *xStyle = x.labelTextStyle.mutableCopy;
    xStyle.fontSize = 10;
	NSMutableArray *customLabels = [NSMutableArray array];
    
    //Use date as label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd";
    
	[self.resultsArray enumerateObjectsUsingBlock:^(Result* result, NSUInteger idx, BOOL *stop){
        //Use Date formatter to make date
        NSString *dateString = [dateFormatter stringFromDate:result.startDate];
        
		CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%@ (%@)\n   %@",result.test.questionSet.typeSymbol, result.test.questionSet.name,dateString] textStyle:x.labelTextStyle];
		newLabel.tickLocation = [[NSDecimalNumber numberWithFloat:(idx+1)] decimalValue];
        newLabel.alignment = CPTAlignmentCenter;
        newLabel.offset = 2.0f;
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
    y.titleLocation               = CPTDecimalFromFloat(30.0f);
    y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.0f) length:CPTDecimalFromFloat(65.0f)];
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
    
    
    // Create a correct plot
    self.correctPlot = [[CPTScatterPlot alloc] init];
    self.correctPlot.identifier = @"CorrectPlot";
    
    CPTMutableLineStyle *lineStyle = [self.correctPlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 3.f;
    lineStyle.lineColor              = [CPTColor greenColor];
    lineStyle.dashPattern            = [NSArray arrayWithObjects:[NSNumber numberWithFloat:5.0f], [NSNumber numberWithFloat:5.0f], nil];
    self.correctPlot.dataLineStyle = lineStyle;
    
    // Add plot symbols
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol plusPlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor whiteColor]];
    plotSymbol.lineStyle     = lineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);
    self.correctPlot.plotSymbol = plotSymbol;
    
    self.correctPlot.dataSource = self;
    [graph addPlot:self.correctPlot];
    
    // Create a incorrect plot
    self.incorrectPlot = [[CPTScatterPlot alloc] init];
    self.incorrectPlot.identifier = @"IncorrectPlot";
    
    lineStyle = [self.incorrectPlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 3.f;
    lineStyle.lineColor              = [CPTColor redColor];
    lineStyle.dashPattern            = [NSArray arrayWithObjects:[NSNumber numberWithFloat:5.0f], [NSNumber numberWithFloat:5.0f], nil];
    self.incorrectPlot.dataLineStyle = lineStyle;
    
    // Add plot symbols
    plotSymbol = [CPTPlotSymbol rectanglePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor redColor]];
    plotSymbol.lineStyle     = lineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);
    self.incorrectPlot.plotSymbol = plotSymbol;
    
    self.incorrectPlot.dataSource = self;
    [graph addPlot:self.incorrectPlot];
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.resultsArray.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ( index >= self.resultsArray.count) {
        return nil;
    }
    if (fieldEnum == CPTScatterPlotFieldX) {
        //Make records evenly spaced along axis
        return [NSNumber numberWithFloat:(index+1)];
    }
    else {
        Result* result = [self.resultsArray objectAtIndex:index];
        return [NSNumber numberWithFloat:[plot.identifier isEqual:@"CorrectPlot"]?[self questionsCorrectPerMinutesForResult:result]:[self questionsIncorrectPerMinutesForResult:result]];
    }
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{    
    static CPTMutableTextStyle *whiteText = nil;
    
    if (!whiteText ) {
        whiteText       = [[CPTMutableTextStyle alloc] init];
        whiteText.color = [CPTColor whiteColor];
    }
    
    CPTTextLayer *newLayer = nil;
    Result* result = [self.resultsArray objectAtIndex:index];
    
    int percentageCorrect = (int)  [plot.identifier isEqual:@"CorrectPlot"]?[self questionsCorrectPerMinutesForResult:result]:[self questionsIncorrectPerMinutesForResult:result];
    newLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%d", percentageCorrect] style:whiteText];   
    
    return newLayer;
}
-(float) questionsCorrectPerMinutesForResult:(Result*)result{
    return result.correctResponses.count * ((60.0f)/([result.endDate timeIntervalSinceDate:result.startDate]));
}
-(float) questionsIncorrectPerMinutesForResult:(Result*)result{
    return result.incorrectResponses.count * ((60.0f)/([result.endDate timeIntervalSinceDate:result.startDate]));
}
#pragma mark -
#pragma mark Plot Space Delegate Methods

-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
	// Impose a limit on how far user can scroll in x
	if ( coordinate == CPTCoordinateX ) {
		CPTPlotRange *maxRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.5f) length:CPTDecimalFromFloat(self.resultsArray.count)];
		CPTMutablePlotRange *changedRange = [newRange mutableCopy];
		[changedRange shiftEndToFitInRange:maxRange];
		[changedRange shiftLocationToFitInRange:maxRange];
		newRange = changedRange;
	}
    else {
        CPTPlotRange *maxRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.0f) length:CPTDecimalFromFloat(self.maxNumberY + 10)];
		CPTMutablePlotRange *changedRange = [newRange mutableCopy];
		[changedRange shiftEndToFitInRange:maxRange];
		[changedRange shiftLocationToFitInRange:maxRange];
		newRange = changedRange;    
    }
    
	return newRange;
}
-(BOOL) plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint{
    NSLog(@"Scale: %f",interactionScale);
    return NO;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
