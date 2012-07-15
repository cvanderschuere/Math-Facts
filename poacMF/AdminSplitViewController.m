//
//  AdminSplitViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "AdminSplitViewController.h"
#import "UsersTableViewController.h"
#import "UserDetailTableViewController.h"
#import "QuestionSetDetailTableViewController.h"
#import "Student.h"
#import "SegmentedControlNavigationController.h"

@interface AdminSplitViewController ()

@property (nonatomic, strong) UIPopoverController* masterPopoverController;

@end

@implementation AdminSplitViewController

@synthesize currentCourse = _currentCourse;
@synthesize masterPopoverController = _masterPopoverController;

-(void) setCurrentCourse:(Course *)currentCourse{
    if (![_currentCourse isEqual:currentCourse]) {
        //Remove old observer
        [[NSNotificationCenter defaultCenter] removeObserver:self  // remove observing of old document (if any)
                                                        name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                      object:_currentCourse.managedObjectContext.persistentStoreCoordinator];

        
        _currentCourse = currentCourse;
        
        //Register for iCloud
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(documentContentsChanged:)
                                                     name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                   object:_currentCourse.managedObjectContext.persistentStoreCoordinator];
        
        //Pass it on to whatever viewcontroller want it
        for (UINavigationController* vc in self.viewControllers) {
            if ([[[vc viewControllers] lastObject] respondsToSelector:@selector(setCurrentCourse:)]) {
                [[[vc viewControllers] lastObject] performSelector:@selector(setCurrentCourse:) withObject:_currentCourse];
            }
            if ([vc.viewControllers.lastObject respondsToSelector:@selector(setDelegate:)]) {
                [vc.viewControllers.lastObject performSelector:@selector(setDelegate:) withObject:self];
            }
        }
    }
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        AdminMasterTableViewController *adminMaster = [[[self.viewControllers objectAtIndex:0] viewControllers] lastObject];
        adminMaster.delegate = self;
        
        self.delegate = self;
    }
    return self;
}

#pragma mark - AdminSplitViewCommunicationDelegate
-(void) didSelectObject:(id)aObject{
    UINavigationController *navController = [self.viewControllers lastObject];
    if ([aObject isKindOfClass:[Student class]]) {
        UserDetailTableViewController *detailTVC = nil;
        //Check if this is the current student being shown
        if (navController.viewControllers.count>0 && [navController.viewControllers.lastObject isKindOfClass:[UserDetailTableViewController class]])
        {
            detailTVC = [navController.viewControllers objectAtIndex:0];
            [detailTVC setStudent:aObject];
        }
        else {
            UserDetailTableViewController *detailTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserDetailTableViewController"];
            [detailTVC setStudent:aObject];
            
            //Check if needs to show revealMaster button
            if ([[navController.viewControllers objectAtIndex:0] revealMasterButton]) {
                UIBarButtonItem *masterButton = [[navController.viewControllers objectAtIndex:0] revealMasterButton];
                masterButton.title = @"Students";

                [detailTVC.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:[[navController.viewControllers objectAtIndex:0] revealMasterButton],detailTVC.navigationItem.leftBarButtonItem, nil] animated:NO];
                detailTVC.revealMasterButton = masterButton;
            }
            
            [navController setViewControllers:[NSArray arrayWithObject:detailTVC] animated:NO];
        }
    }
    else if ([aObject isKindOfClass:[QuestionSet class]]) {
        QuestionSetDetailTableViewController *detailTVC = nil;
        //Check if this is the current student being shown
        if (navController.viewControllers.count>0 && [navController.viewControllers.lastObject isKindOfClass:[QuestionSetDetailTableViewController class]])
        {
            detailTVC = [navController.viewControllers objectAtIndex:0];
            [detailTVC setQuestionSet:aObject];
        }
        else {
            QuestionSetDetailTableViewController *detailTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionSetDetailTableViewController"];
            [detailTVC setQuestionSet:aObject];
            
            NSLog(@"NavController %@",navController.viewControllers);
            //Check if needs to show revealMaster button
            if ([[navController.viewControllers objectAtIndex:0] revealMasterButton]) {
                UIBarButtonItem *masterButton = [[navController.viewControllers objectAtIndex:0] revealMasterButton];
                masterButton.title = @"Sets";
                
                [detailTVC.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:masterButton,detailTVC.navigationItem.leftBarButtonItem, nil] animated:NO];
                detailTVC.revealMasterButton = masterButton;
            }

            [navController setViewControllers:[NSArray arrayWithObject:detailTVC] animated:NO];
        }
    }
    
}
-(void) didDeleteObject:(id)aObject{
    UINavigationController *navController = [self.viewControllers lastObject];
    if (navController.viewControllers.count==0)
        return;
    
    id currentVC = [navController.viewControllers objectAtIndex:0];
    
    if ([aObject isKindOfClass:[Student class]] && [currentVC isKindOfClass:[UserDetailTableViewController class]]) {
        //Check to see if object currently being shown was deleted
        if ([[currentVC student] isEqual:aObject]) {
            [currentVC setStudent:nil];
        }
    }
    else if ([aObject isKindOfClass:[QuestionSet class]] && [currentVC isKindOfClass:[QuestionSetDetailTableViewController class]]) {
        if ([[currentVC questionSet] isEqual:aObject]) {
            [currentVC setQuestionSet:nil];
        }
    }

}
#pragma mark - UISplitViewDelegate Methods
-(BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    NSLog(@"Controlers: %@",svc.viewControllers);
    return UIInterfaceOrientationIsPortrait(orientation);
}
-(void) splitViewController:(UISplitViewController *)svc willHideViewController:(SegmentedControlNavigationController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    UserDetailTableViewController* detailController = [[[svc.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0];
    NSLog(@"ViewControllers:%@ Navitation Items:%@",detailController,detailController.navigationItem.leftBarButtonItems);
    barButtonItem.title = [[[[svc.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] isKindOfClass:[UserDetailTableViewController class]]?@"Students":@"Sets";
    detailController.revealMasterButton = barButtonItem;
    [detailController.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:barButtonItem,detailController.navigationItem.leftBarButtonItem, nil] animated:NO];
}
-(void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    UserDetailTableViewController* detailController = [[[svc.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0];
    
    //Remove button
    detailController.revealMasterButton = nil;
    if (detailController.navigationItem.leftBarButtonItems.count>1)
        [detailController.navigationItem setLeftBarButtonItem:[detailController.navigationItem.leftBarButtonItems objectAtIndex:1] animated:NO];
}
-(void) splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController{
    self.masterPopoverController = pc;
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.masterPopoverController dismissPopoverAnimated:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#pragma mark - iCloud
- (void)documentContentsChanged:(NSNotification *)notification
{
    [self.currentCourse.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
