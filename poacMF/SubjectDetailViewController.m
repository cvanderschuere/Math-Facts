//
//  SubjectDetailViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 10/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "SubjectDetailViewController.h"
#import "Test.h"

@interface SubjectDetailViewController ()

@end

@implementation SubjectDetailViewController

@synthesize subjectTests = _subjectTests, gridView = _gridView;

-(void) setSubjectTests:(NSMutableArray *)subjectTests{
    if (![_subjectTests isEqualToArray:subjectTests]) {
        //Sort incoming data
        [subjectTests sortUsingComparator:^NSComparisonResult(Test* test1, Test* test2){
            //Sort by difficulty of question set
            return [test1.questionSet.difficultyLevel compare:test2.questionSet.difficultyLevel];            
        }];
        //Set value and reload data
        _subjectTests = subjectTests;
        self.title = [[[_subjectTests objectAtIndex:0] questionSet] typeName];
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
    [self.gridView reloadData];

}

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
    
    AQGridViewCell * cell = (AQGridViewCell *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil )
    {
        cell = [[AQGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 120, 120)
                                     reuseIdentifier: CellIdentifier];
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        colorView.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:colorView];
    }
    
    
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return ( CGSizeMake(142.0, 142.0) );
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



@end
