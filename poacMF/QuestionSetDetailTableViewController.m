//
//  QuestionSetDetailTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "QuestionSetDetailTableViewController.h"
#import "AEQuestionViewController.h"
#import "AEQuestionSetTableViewController.h"

@interface QuestionSetDetailTableViewController ()

@end

@implementation QuestionSetDetailTableViewController

@synthesize questionSet = _questionSet, popover = _popover;

-(void) setQuestionSet:(QuestionSet *)questionSet{
    if (![_questionSet isEqual:questionSet]) {
        _questionSet = questionSet;
    
        //Set title for nav bar
        self.title = questionSet.name;
        
        //Setup frc
        if(_questionSet)
            [self setupFetchedResultsController];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"editQuestionSetSegue"]) {
        [[[segue.destinationViewController viewControllers] lastObject] setQuestionSetToUpdate:self.questionSet];
    }
    
}

#pragma mark - NSFetchedResultsController Methods
- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"questionOrder" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"questionSet.name == %@ AND questionSet.type == %@ AND questionSet.difficultyLevel == %@",self.questionSet.name, self.questionSet.type,self.questionSet.difficultyLevel];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.questionSet.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Include insert row
    return [super tableView:tableView numberOfRowsInSection:section] + 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Questions";
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
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
    if (indexPath.row == [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section]-1) {
        //Include Insert Row
        return [tableView dequeueReusableCellWithIdentifier:@"addQuestionCell"];
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    Question *question = (Question*) [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ = %@",question.x?question.x.stringValue:@"__",self.questionSet.typeSymbol,question.y?question.y.stringValue:@"__",question.z?question.z.stringValue:@"__"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedCell.reuseIdentifier isEqualToString:@"addQuestionCell"]) {
        AEQuestionViewController *aeQuestion = [self.storyboard instantiateViewControllerWithIdentifier:@"AEQuestionViewController"];
        aeQuestion.contextToCreateIn = self.questionSet.managedObjectContext;
        
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:aeQuestion];
        [self.popover presentPopoverFromRect:selectedCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if ([selectedCell.reuseIdentifier isEqualToString:@"questionCell"]) {
        AEQuestionViewController *aeQuestion = [self.storyboard instantiateViewControllerWithIdentifier:@"AEQuestionViewController"];
        aeQuestion.questionToUpdate = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:aeQuestion];
        [self.popover presentPopoverFromRect:selectedCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    }


    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
