//
//  UserDetailTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "UserDetailTableViewController.h"
#import "AppConstants.h"
#import "Test.h"
#import "QuestionSet.h"
#import "Administrator.h"
#import "AEUserTableViewController.h"

@interface UserDetailTableViewController ()

//Graph
@property (nonatomic, strong) NSFetchedResultsController* graphTimingsFetchedResultsController;
@property (nonatomic, strong) CPTScatterPlot *correctPlot;
@property (nonatomic, strong) CPTScatterPlot *incorrectPlot;
@property (nonatomic) int maxNumberY;


@end

@implementation UserDetailTableViewController
@synthesize editButton = _editButton;
@synthesize shareButton = _shareButton;
@synthesize student = _student;
@synthesize popover = _popover;
@synthesize graphView = _graphView;
@synthesize graphTimingsFetchedResultsController = _graphTimingsFetchedResultsController;
@synthesize correctPlot = _correctPlot, incorrectPlot = _incorrectPlot, maxNumberY = _maxNumberY;

-(void) setStudent:(Student *)student{
    if (![_student isEqual:student]) {
        _student = student;
        //Set Title and setup observer
        self.title = _student.firstName;
        
        if (_student){   //Enable Button Segues
            self.shareButton.enabled = self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
            [self setupFetchedResultsController];
        }
        else {   //Disable and clear tableview
            self.fetchedResultsController = nil;
            self.shareButton.enabled = self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}
#pragma mark - Fetching

- (void)performFetchWithFRC:(NSFetchedResultsController*)frc
{
    if (frc) {
        if (frc.fetchRequest.predicate) {
            if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), frc.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        } else {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), frc.fetchRequest.entityName);
        }
        NSError *error;
        [frc performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    //Either reload tableView or reload graph
    if ([frc isEqual:self.fetchedResultsController]) {
        [self.tableView reloadData];
    }
    else {
        
    }
}

- (void)setGraphTimingsFetchedResultsController:(NSFetchedResultsController *)newfrc{
    NSFetchedResultsController *oldfrc = _graphTimingsFetchedResultsController;
    if (newfrc != oldfrc) {
        _graphTimingsFetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetchWithFRC:newfrc]; 
        } else {
            if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.tableView reloadData];
        }
    }
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Only enable segues if student exists
    if (_student)   
        self.shareButton.enabled = self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
    else    //Disable
        self.shareButton.enabled = self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = NO;

    [self constructGraph];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setEditButton:nil];
    [self setShareButton:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
                                 duration: (NSTimeInterval) duration
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graphView.hostedGraph.defaultPlotSpace;
    if (self.graphTimingsFetchedResultsController.fetchedObjects.count>8) {
        float length = UIInterfaceOrientationIsLandscape(toInterfaceOrientation)?9.0:5.0;
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(self.graphTimingsFetchedResultsController.fetchedObjects.count - length + .5) length:CPTDecimalFromFloat(length)];
    }
    else {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.5f) length:CPTDecimalFromFloat(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)?9.0:5.0)];
    }
}
#pragma mark - Storyboard
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showTestSegue"]) {
        //Get selected test from frc and pass it along
        Test* selectedTest = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
        [segue.destinationViewController setTest:selectedTest];
    }
    else if ([segue.identifier isEqualToString:@"editStudentSegue"]) {
        //Pass student to update
        [[[segue.destinationViewController viewControllers] lastObject] setCreatedStudentsAdmin:self.student.administrator];
        [[[segue.destinationViewController viewControllers] lastObject] setStudentToUpdate:self.student];

    }
}

#pragma mark - NSFetchedResultsController Methods
- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    //Create fetch for all tests for student; Section by current
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Test"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"isCurrentTest" ascending:NO selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"questionSet.type" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"questionSet.difficultyLevel" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"questionSet.name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
    request.predicate = [NSPredicate predicateWithFormat:@"student.username == %@",self.student.username];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.student.managedObjectContext
                                                                          sectionNameKeyPath:@"isCurrentTest"
                                                                                   cacheName:nil];
    
    //Fetch all timings with current student
    NSFetchRequest *timingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Result"];
    timingRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];
    timingRequest.predicate = [NSPredicate predicateWithFormat:@"student.username == %@ AND isPractice == %@",self.student.username,[NSNumber numberWithBool:NO]];
    self.graphTimingsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:timingRequest managedObjectContext:self.student.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
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
    graph.paddingBottom = 23;
    
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate = self;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(55.0f)];
    if (self.graphTimingsFetchedResultsController.fetchedObjects.count>8) {
        float length = UIInterfaceOrientationIsLandscape(self.interfaceOrientation)?9.0:5.0;
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(self.graphTimingsFetchedResultsController.fetchedObjects.count - length + .5) length:CPTDecimalFromFloat(length)];
    }
    else {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.5f) length:CPTDecimalFromFloat(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)?9.0:5.0)];
    }
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    x.majorIntervalLength = CPTDecimalFromString(@".5");
    
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    CPTMutableTextStyle *xStyle = x.labelTextStyle.mutableCopy;
    xStyle.fontSize = 10;
	NSMutableArray *customLabels = [NSMutableArray array];
    
    /* //Use date as label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd";
    */
    
	[self.graphTimingsFetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(Result* result, NSUInteger idx, BOOL *stop){
        //Use Date formatter to make date
       // NSString *dateString = [dateFormatter stringFromDate:result.startDate];
        
		CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%@ (%@)",result.test.questionSet.typeSymbol, result.test.questionSet.name] textStyle:x.labelTextStyle];
		newLabel.tickLocation = [[NSDecimalNumber numberWithFloat:(idx+1)] decimalValue];
        newLabel.alignment = CPTAlignmentCenter;
        newLabel.offset = .5f;
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
    return self.graphTimingsFetchedResultsController.fetchedObjects.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ( index >= [self.graphTimingsFetchedResultsController.fetchedObjects count] ) {
        return nil;
    }
    if (fieldEnum == CPTScatterPlotFieldX) {
        //Make records evenly spaced along axis
        return [NSNumber numberWithFloat:(index+1)];
    }
    else {
        Result* result = [self.graphTimingsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
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
    Result* result = [self.graphTimingsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
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
		CPTPlotRange *maxRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.5f) length:CPTDecimalFromFloat(self.graphTimingsFetchedResultsController.fetchedObjects.count+.5)];
		CPTMutablePlotRange *changedRange = [newRange mutableCopy];
		[changedRange shiftEndToFitInRange:maxRange];
		[changedRange shiftLocationToFitInRange:maxRange];
		newRange = changedRange;
	}
    else {
        CPTPlotRange *maxRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(self.maxNumberY + 10)];
		CPTMutablePlotRange *changedRange = [newRange mutableCopy];
		[changedRange shiftEndToFitInRange:maxRange];
		[changedRange shiftLocationToFitInRange:maxRange];
		newRange = changedRange;    
    }
    
	return newRange;
}

#pragma mark - NSFetchedResultsController Delegate
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{		
    if ([controller isEqual:self.fetchedResultsController]) {
        if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
        {
            switch(type)
            {
                case NSFetchedResultsChangeInsert:
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    break;
                    
                case NSFetchedResultsChangeDelete:
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    break;
                    
                case NSFetchedResultsChangeUpdate:
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    break;
                    
                case NSFetchedResultsChangeMove:
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    break;
            }
        }
    }
    else {
        if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
        {
            [self.correctPlot reloadDataInIndexRange:NSMakeRange(newIndexPath.row, 1)];
            [self.incorrectPlot reloadDataInIndexRange:NSMakeRange(newIndexPath.row, 1)];
        }

    }
}


#pragma mark - Table view data source
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName = [super tableView:tableView titleForHeaderInSection:section];
    
    //Customize section header from "isCurrentTest" bool
    if ([sectionName isEqualToString:@"1"]) {
        return @"Current";
    }
    else {
        return @"History";
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil; //Disable section index titles
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.fetchedResultsController.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
    
    //Get Test
    Test *test = (Test*) [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //Customize Cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",test.questionSet.typeName,test.questionSet.name];
    cell.imageView.image = test.passed.boolValue?[UIImage imageNamed:@"passStamp"]:nil;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Attempts: %d",test.results.count];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return ![[tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"selectTestCell"];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Select Current Test Methods
- (IBAction)selectCurrentTest:(UIBarButtonItem*)sender {
    if (self.popover.popoverVisible) {
        return [self.popover dismissPopoverAnimated:YES];
    }
    
    SelectCurrentTestTableViewController* selectTest = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCurrentTestTableViewController"];
    selectTest.delegate = self;
    selectTest.student = self.student;
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:selectTest];
    [self.popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void) didSelectQuestionSet:(QuestionSet*)selectedQuestionSet{
    [self.student selectQuestionSet:selectedQuestionSet];
    [self.popover dismissPopoverAnimated:YES];
}

@end
