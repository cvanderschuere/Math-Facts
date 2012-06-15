//
//  ResultDetailViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 15/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "ResultDetailViewController.h"
#import "Question.h"
#import "QuestionSet.h"

@interface ResultDetailViewController ()

@property (nonatomic, strong) NSMutableArray *questionsCorrect;
@property (nonatomic, strong) NSMutableArray *questionsIncorrect;

@end

@implementation ResultDetailViewController
@synthesize result = _result;
@synthesize questionsCorrect = _questionsCorrect, questionsIncorrect = _questionsIncorrect;

-(void) setResult:(Result *)result{
    _result = result;
    
    //Set title
    self.title = [NSDateFormatter localizedStringFromDate:_result.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    //Reload data
    self.questionsCorrect = _result.questionsCorrect.allObjects.mutableCopy;
    self.questionsIncorrect = _result.questionsIncorrect.allObjects.mutableCopy;
    [self.tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return self.questionsCorrect.count;
            break;
        case 1:
            return self.questionsIncorrect.count;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"resultQuestionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Question *question = indexPath.section == 0?[self.questionsCorrect objectAtIndex:indexPath.row]:[self.questionsIncorrect objectAtIndex:indexPath.row];
    
    //Format for question
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ = %@",question.x?question.x.stringValue:@"__",question.questionSet.typeSymbol,question.y?question.y.stringValue:@"__",question.z?question.z.stringValue:@"__"];
    cell.detailTextLabel.text = nil;//TODO: Add answer
    
    return cell;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Questions Correct";
            break;
        case 1:
            return @"Questions Incorrect";
        default:
            return nil;
            break;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
