//
//  UserProgressViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "StudentMainViewController.h"
#import "CVCocosViewController.h"
#import "SubjectDetailViewController.h"
#import "Test.h"


@interface StudentMainViewController ()

@property (nonatomic, strong) UIActionSheet* logoutSheet;

@end

@implementation StudentMainViewController
@synthesize subjectScrollView = _subjectScrollView;
@synthesize pageControl = _pageControl;
@synthesize currentStudent = _currentStudent;
@synthesize subjects2DArray = _subjects2DArray;
@synthesize logoutSheet = _logoutSheet;

-(void) setCurrentStudent:(Student *)currentStudent{
    NSLog(@"Current Student: %@",currentStudent);
    if (![_currentStudent isEqual:currentStudent]) {
        _currentStudent = currentStudent;

        self.title = _currentStudent.firstName;
        
        //Sort Tests into respective categories
        NSMutableArray *subject1 = [NSMutableArray array];
        NSMutableArray *subject2 = [NSMutableArray array];
        NSMutableArray *subject3 = [NSMutableArray array];
        NSMutableArray *subject4 = [NSMutableArray array];
        
        for (Test* test in self.currentStudent.tests) {
            switch (test.questionSet.type.intValue) {
                case QUESTION_TYPE_MATH_ADDITION:
                    [subject1 addObject:test];
                    break;
                case QUESTION_TYPE_MATH_SUBTRACTION:
                    [subject2 addObject:test];
                    break;
                case QUESTION_TYPE_MATH_MULTIPLICATION:
                    [subject3 addObject:test];
                    break;
                case QUESTION_TYPE_MATH_DIVISION:
                    [subject4 addObject:test];
                    break;
                default:
                    break;
            }
        }
    //Set main array    
    self.subjects2DArray = [NSMutableArray arrayWithObjects:subject1,subject2,subject3,subject4, nil];
        
    }
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    
    }
    return self;
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"subjectDetailSegue"]) {
        //Get tag from uibutton to deterine what subject array to send
        //[segue.destinationViewController setSubjectTests:[self.subjects2DArray objectAtIndex:[sender tag]]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    pageControlBeingUsed = NO;
    [self reloadScrollView];
    
}
-(void) reloadScrollView{
    //Remove all old subviews
    for (UIView *subview in self.subjectScrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    //Load ScrollView
    __block int indexOfAdded = 0;
    [self.subjects2DArray enumerateObjectsUsingBlock:^(NSMutableArray* testArray, NSUInteger idx, BOOL *stop){
        if (testArray.count>0) {
            //Add button to scrollview (set tag to index of array for use in segue
            UIView* externalView = [[UIView alloc] initWithFrame:CGRectMake(indexOfAdded * self.subjectScrollView.bounds.size.width, 0, self.subjectScrollView.bounds.size.width, self.subjectScrollView.bounds.size.height)];
            externalView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTitle:[[[testArray objectAtIndex:0] questionSet] typeName] forState:UIControlStateNormal];
            button.tag = idx;
            [button addTarget:self action:@selector(didSelectSubject:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(50, 50, externalView.frame.size.width - 100, externalView.frame.size.height - 100);
            [externalView addSubview:button];
            [self.subjectScrollView addSubview:externalView];
            indexOfAdded++;
        }
        
    }];
    
    //Update ContentSize
    self.subjectScrollView.contentSize = CGSizeMake(self.subjectScrollView.bounds.size.width * indexOfAdded, 0);
    self.pageControl.numberOfPages = indexOfAdded;
}

- (void)viewDidUnload
{
    [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (IBAction)changePage:(UIPageControl*)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.subjectScrollView.bounds.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.subjectScrollView.bounds.size;
    
    NSLog(@"New Page: %d",self.pageControl.currentPage);

    [self.subjectScrollView scrollRectToVisible:frame animated:YES];
    
    // Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!pageControlBeingUsed) {
        // Update the page when more than 50% of the previous/next page is visible
        CGFloat pageWidth = self.subjectScrollView.frame.size.width;
        int page = floor((self.subjectScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl.currentPage = page;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}
#pragma mark - Button Methods
-(void) didSelectSubject:(NSMutableArray*)selectedArray{
    [self performSegueWithIdentifier:@"subjectDetailSegue" sender:selectedArray]; //Simple way to get around @selector
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
}//end method
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.parentViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}
@end
