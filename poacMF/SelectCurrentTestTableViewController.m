//
//  SelectCurrentTestTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 24/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "SelectCurrentTestTableViewController.h"
#import "QuestionSet.h"

@interface SelectCurrentTestTableViewController ()

@end

@implementation SelectCurrentTestTableViewController
@synthesize context = _context;
@synthesize delegate = _delegate;

-(void) setContext:(NSManagedObjectContext *)context{
    _context = context;
    if(context)
        [self setupFetchedResultsController];
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

#pragma mark - NSFetchedResultsController Methods
 - (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"QuestionSet"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"difficultyLevel" ascending:YES selector:@selector(compare:)],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
    request.predicate = nil;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"typeName"
                                                                                   cacheName:nil];
}
#pragma mark - Table view data source
         
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"questionSetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    QuestionSet *qSet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = qSet.name; 
    
    return cell;
}
 - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;//[self.fetchedResultsController sectionIndexTitles];
}
 - (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
     if ([sectionName isEqualToString:@"Addition"]) {
         return @"+";
     }
     else if ([sectionName isEqualToString:@"Subtraction"]) {
         return @"-";
     }
     else if ([sectionName isEqualToString:@"Multiplication"]) {
         return @"x";
     }
     else if ([sectionName isEqualToString:@"Division"]) {
         return @"/";
     }
     
 }
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
 return NO;
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
    if ([self.delegate respondsToSelector:@selector(didSelectQuestionSet:)]) {
        [self.delegate didSelectQuestionSet:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
