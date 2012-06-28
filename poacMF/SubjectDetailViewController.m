//
//  SubjectDetailViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 10/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "SubjectDetailViewController.h"
#import "Test.h"
#import "TestSelectCell.h"

@interface SubjectDetailViewController ()
@property (nonatomic, strong) NSMutableArray *subjectTests;
@property (nonatomic, strong) UIActionSheet* logoutSheet;

@end

@implementation SubjectDetailViewController

@synthesize subjectTests = _subjectTests, gridView = _gridView, currentStudent = _currentStudent;
@synthesize logoutSheet = _logoutSheet;

-(void) setCurrentStudent:(Student *)currentStudent{
    if (![currentStudent isEqual:_currentStudent]) {
        _currentStudent = currentStudent;
        
        //Find current test
        Test* currentTest = [[currentStudent.tests filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Test* evaluatedObject,NSDictionary* bindings){
            return evaluatedObject.isCurrentTest.boolValue;
        }]] anyObject];
        
        [self updateDateForType:currentTest.questionSet];
    }
}
-(void) updateDateForType: (QuestionSet*) questionSet{
    //Set title
    self.title = questionSet.typeName;
    
    //Fetch all tests of same type
    NSMutableArray* testsOfSubject = [self.currentStudent.tests filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Test* evaluatedObject,NSDictionary* bindings){
        return [evaluatedObject.questionSet.type isEqualToNumber:questionSet.type];
    }]].allObjects.mutableCopy;
    
    //Sort by sort order
    [testsOfSubject sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"questionSet.difficultyLevel" ascending:YES]]];
    
    //Fetch all question sets of type
    NSFetchRequest *questionSets = [NSFetchRequest fetchRequestWithEntityName:@"QuestionSet"];
    questionSets.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"difficultyLevel" ascending:YES]];
    questionSets.predicate = [NSPredicate predicateWithFormat:@"type == %@",questionSet.type];
    
    NSMutableArray *subjectTests = [_currentStudent.managedObjectContext executeFetchRequest:questionSets error:NULL].mutableCopy;  
    
    //Replace with tests
    for (Test* test in testsOfSubject) {
        [subjectTests replaceObjectAtIndex:[subjectTests indexOfObjectIdenticalTo:test.questionSet] withObject:test];
    }
    self.subjectTests = subjectTests;

}

-(void) setSubjectTests:(NSMutableArray *)subjectTests{
    if (![_subjectTests isEqualToArray:subjectTests]) {
        /*
        //Sort incoming data
        [subjectTests sortUsingComparator:^NSComparisonResult(Test* test1, Test* test2){
            //Sort by difficulty of question set
            return [test1.questionSet.difficultyLevel compare:test2.questionSet.difficultyLevel];            
        }];
        for (Test* test in subjectTests) {
            NSLog(@"Test: %@",test.questionSet.difficultyLevel);
        }
        */
        
        //Set value and reload data
        _subjectTests = subjectTests;
        [self.gridView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _emptyCellIndex = NSNotFound;
    
    //Setup Grid View
    // grid view sits on top of the background image
    self.gridView = [[AQGridView alloc] initWithFrame: self.view.bounds];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.backgroundColor = [UIColor clearColor];
    self.gridView.opaque = NO;
    self.gridView.dataSource = self;
    self.gridView.delegate = self;
    self.gridView.scrollEnabled = NO;
    
    if ( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) )
    {
        // bring 1024 in to 1020 to make a width divisible by five
        self.gridView.leftContentInset = 2.0;
        self.gridView.rightContentInset = 2.0;
    }
    
    [self.view addSubview: self.gridView];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Reload with new scores
    [self.gridView reloadData];

}
-(IBAction) logOut: (id) sender {
    if (self.logoutSheet.visible)
        return [self.logoutSheet dismissWithClickedButtonIndex:-1 animated:YES];
    
    //2) confirmatory logout prompt if they are logged in
    self.logoutSheet = [[UIActionSheet alloc] initWithTitle:@"Logout?" 
                                                   delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Logout" 
                                          otherButtonTitles:@"Cancel", nil, nil];
    self.logoutSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    self.logoutSheet.delegate = self;
    [self.logoutSheet showFromBarButtonItem:sender animated:YES];
    
    //Save on logout
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveDatabase" object:nil];

}//end method

#pragma mark -
#pragma mark GridView Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return [self.subjectTests count];
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * EmptyIdentifier = @"EmptyIdentifier";
    static NSString * CellIdentifier = @"CellIdentifier";
    
    if ( index == _emptyCellIndex )
    {
        NSLog( @"Loading empty cell at index %u", index );
        AQGridViewCell * hiddenCell = [gridView dequeueReusableCellWithIdentifier: EmptyIdentifier];
        if ( hiddenCell == nil )
        {
            // must be the SAME SIZE AS THE OTHERS
            // Yes, this is probably a bug. Sigh. Look at -[AQGridView fixCellsFromAnimation] to fix
            hiddenCell = [[AQGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 120, 120)
                                               reuseIdentifier: EmptyIdentifier];
        }
        
        hiddenCell.hidden = YES;
        return ( hiddenCell );
    }
        
    id object = [self.subjectTests objectAtIndex:index];

    TestSelectCell * cell = (TestSelectCell *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil )
    {
        cell = [[TestSelectCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 120, 120)
                                     reuseIdentifier: CellIdentifier];
    }
    
    if ([object isKindOfClass:[Test class]]) {
        Test *test = object;
        
        cell.difficultyLevel = [NSNumber numberWithInt:test.questionSet.difficultyLevel.intValue +1];
        cell.locked = NO;
        
        
        if (test.isCurrentTest.boolValue) {
            //Show highlight
            cell.layer.borderWidth = 3;
            cell.layer.borderColor = [UIColor yellowColor].CGColor;
        }
        else {
            cell.layer.borderWidth = 0;
        }

        //Calculate Pass level
        if (test.results.count>0) {
            int maxCorrect = 0;
            for (Result* result in test.results) {
                if (result.correctResponses.count>maxCorrect) {
                    maxCorrect = result.correctResponses.count;
                }
            }
            
            if (maxCorrect>=test.passCriteria.intValue) {
                //Passed
                cell.passedLevel = [NSNumber numberWithInt:1];
            }
            else {
                //Hasn't passed yet
                cell.passedLevel = [NSNumber numberWithInt:0];
            }
            
        }
        else { //Unattempted
            cell.passedLevel = [NSNumber numberWithInt:-1];
        }

            }
    else{
        //Question Set
        cell.locked = YES;
        cell.difficultyLevel = [NSNumber numberWithInt:[object difficultyLevel].intValue +1];
        cell.passedLevel = [NSNumber numberWithInt:-1];
        cell.layer.borderWidth = 0;

    }
    
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return ( CGSizeMake(142.0, 142.0) );
}
#pragma mark - AQGridView Delegate
-(void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index{
    id object = [self.subjectTests objectAtIndex:index];
    if ([object isKindOfClass:[Test class]]) {
        if ([object isCurrentTest].boolValue) {
            //Current Test
            Test *currentTest = (Test*) object;
            UIActionSheet* actionSheet = nil;
            //Determine took practice last or timing last
            
            NSArray *practices = [[currentTest practice].results.allObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]]];
            NSArray *timings = [currentTest.results.allObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]]];
            
            
            if ([[[practices.lastObject startDate] earlierDate:[timings.lastObject startDate]] isEqualToDate:[timings.lastObject startDate]] || (timings.count == 0 && practices.count != 0)) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"Timing"  delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Start Timing",nil];
            }
            else {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"Practice"  delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Start Practice",nil];
            }
            [actionSheet showFromRect:[gridView rectForItemAtIndex:index]  inView:self.view animated:YES];
        }
        else {
            //Previous test
            [self.gridView deselectItemAtIndex:index animated:YES];
        }
    }
    else if ([object isKindOfClass:[QuestionSet class]]) {
        [self.gridView deselectItemAtIndex:index animated:YES];
    }
}
#pragma mark - UIActionSheet Delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([actionSheet.title isEqualToString:@"Logout?"]) {
        if (buttonIndex == 0) {
            [self.parentViewController dismissViewControllerAnimated:YES completion:NULL];
        }
    }
    else {
        if ([actionSheet.title isEqualToString:@"Timing"]) {
            //Launch Test
            [TestFlight passCheckpoint:@"StartTest"];
            [self performSegueWithIdentifier:@"startTestSegue" sender:self.gridView];
        }
        else if ([actionSheet.title isEqualToString:@"Practice"]) {
            //Launch Practice
            [TestFlight passCheckpoint:@"StartPractice"];
            [self performSegueWithIdentifier:@"startPracticeSegue" sender:self.gridView];
        }
        
        [self.gridView deselectItemAtIndex:self.gridView.selectedIndex animated:YES];
    }
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"startTestSegue"]) {
        //Pass test to TestVC
        Test *selectedTest = [self.subjectTests objectAtIndex:[sender selectedIndex]];
        NSLog(@"Selected Test: %@",selectedTest.questionSet.name);
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setTest:selectedTest];
    }
    else if ([segue.identifier isEqualToString:@"startPracticeSegue"]) {
        //Pass test to TestVC
        Test *selectedTest = [self.subjectTests objectAtIndex:[sender selectedIndex]];
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setPractice:selectedTest.practice];
    }

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
- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
                                 duration: (NSTimeInterval) duration
{
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        // width will be 768, which divides by four nicely already
        NSLog( @"Setting left+right content insets to zero" );
        self.gridView.leftContentInset = 0.0;
        self.gridView.rightContentInset = 0.0;
    }
    else
    {
        // width will be 1024, so subtract a little to get a width divisible by five
        NSLog( @"Setting left+right content insets to 2.0" );
        self.gridView.leftContentInset = 2.0;
        self.gridView.rightContentInset = 2.0;
    }
}

#pragma mark - Test Result Delegate
-(void) didFinishTest:(Test*)finishedTest withResult:(Result*)result{
    [TestFlight passCheckpoint:@"FinishedTest"];

    BOOL passed = finishedTest.passCriteria.intValue <= result.correctResponses.count;
    
    if (passed) {
        //Find next questionSet to create new test
        NSFetchRequest *nextQSFetch = [NSFetchRequest fetchRequestWithEntityName:@"QuestionSet"];
        nextQSFetch.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"difficultyLevel" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
        nextQSFetch.predicate = [NSPredicate predicateWithFormat:@"(type == %@ AND difficultyLevel > %@) OR type > %@",finishedTest.questionSet.type,finishedTest.questionSet.difficultyLevel,finishedTest.questionSet.type];
        nextQSFetch.fetchBatchSize = 1;
        
        NSArray* nextQs = [self.currentStudent.managedObjectContext executeFetchRequest:nextQSFetch error:NULL];
        if (nextQs.count >0) {
            QuestionSet *nextQuestionSet = [nextQs objectAtIndex:0];
            [self.currentStudent selectQuestionSet:nextQuestionSet];
            [self updateDateForType:nextQuestionSet];
        }
        else {
            //No more question sets
            [self.currentStudent setCurrentTest:nil];
        }
        
        
    }
    
        
    //Create UIAlertView to present information
    UIAlertView *finishedTestAlert = [[UIAlertView alloc] initWithTitle:passed?@"Good Work":@"Try Again" 
                                                                message:passed?[NSString stringWithFormat:@"You got %d questions correct!",result.correctResponses.count]:[NSString stringWithFormat:@"You need to get %d questions correct",finishedTest.passCriteria.intValue]
                                                               delegate:nil 
                                                      cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [finishedTestAlert show];
}



@end
