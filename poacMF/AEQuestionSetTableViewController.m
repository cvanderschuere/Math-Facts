//
//  AEQuestionSetTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 20/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "AEQuestionSetTableViewController.h"
#import "AppLibrary.h"
#import "AEQuestionViewController.h"

@interface AEQuestionSetTableViewController ()


@property (nonatomic, strong) NSMutableArray *questionArray;
@property (nonatomic, strong) NSMutableArray *createdQuestions;
@property (nonatomic, strong) NSMutableArray *deletedQuestions;

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UIStepper *typeStepper;
@property (nonatomic, strong) IBOutlet UILabel *typeLabel;

@property (nonatomic, strong) UIPopoverController* popover;

@property (nonatomic) BOOL isEditing;

-(IBAction)stepperUpdated:(UIStepper*)sender;



@end

@implementation AEQuestionSetTableViewController
@synthesize questionSetToUpdate = _questionSetToUpdate, administratorToCreateIn = _administratorToCreateIn, nameTextField = _nameTextField;
@synthesize typeStepper = _typeStepper, typeLabel = _typeLabel, questionArray = _questionArray;
@synthesize popover = _popover, createdQuestions = _createdQuestions, deletedQuestions = _deletedQuestions;
@synthesize isEditing = _isEditing;

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.createdQuestions = [NSMutableArray array];
    self.questionArray = [NSMutableArray array];
    self.deletedQuestions = [NSMutableArray array];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Configure for updatedUser if in edit mode
    if (self.questionSetToUpdate) {
        self.questionArray = self.questionSetToUpdate.questions.allObjects.mutableCopy;
        [self.questionArray sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"questionOrder" ascending:YES]]];
        
        self.title = [@"Edit " stringByAppendingString:self.questionSetToUpdate.name];
        self.isEditing = YES;
        
        self.navigationItem.leftBarButtonItem = nil; //Remove ability to cancel when editing
        
	}//end editMode
    else{
        self.title = @"Create Question Set";
    }

}
-(void) viewDidAppear:(BOOL)animated{
    if (self.questionSetToUpdate) {
		self.nameTextField.text = self.questionSetToUpdate.name;
		self.typeStepper.hidden = YES;
    }
    else {
        self.typeStepper.hidden = NO;
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - IBActions
-(IBAction)stepperUpdated:(UIStepper*)sender{
    if([sender isEqual:self.typeStepper]){
        int type = (int) sender.value;  
        NSString *defaultString = nil;
        switch (type) {
            case QUESTION_TYPE_MATH_ADDITION:
                defaultString = @"Addition";
                break;
            case QUESTION_TYPE_MATH_SUBTRACTION:
                defaultString = @"Subtraction";
                break;
            case QUESTION_TYPE_MATH_MULTIPLICATION:
                defaultString = @"Multiplication";
                break;
            case QUESTION_TYPE_MATH_DIVISION:
                defaultString = @"Division";
                break;
            default:
                break;
        }
        
        self.typeLabel.text = defaultString;
    }
}
-(IBAction) cancelClicked {
    //Delete all questions created this session
    for (Question* createdQuestion in self.createdQuestions) {
        [self.administratorToCreateIn.managedObjectContext deleteObject:createdQuestion];
    }
    
    //Dismiss View
	[self dismissViewControllerAnimated:YES completion:NULL];
}//end method

-(IBAction) saveClicked {
	AppLibrary *al = [[AppLibrary alloc] init];
    
    //Check for valid values
	if (0 == self.nameTextField.text.length){
		NSString *msg = @"Name must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
    if (self.questionArray.count == 0) {
        NSString *msg = @"Question Set must contain a question";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
    }

    //Create questionSet if necessary
    if (!self.questionSetToUpdate) {
        self.questionSetToUpdate = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionSet" inManagedObjectContext:self.administratorToCreateIn.managedObjectContext];
        self.questionSetToUpdate.difficultyLevel = [NSNumber numberWithInt:self.administratorToCreateIn.questionSets.count];
        self.questionSetToUpdate.administrator = self.administratorToCreateIn;
    }
    
    //Assign Variables
    self.questionSetToUpdate.name = self.nameTextField.text;  
    if (self.questionSetToUpdate.type == nil) {
        self.questionSetToUpdate.type = [NSNumber numberWithDouble:self.typeStepper.value]; //Disable Editing type
    }
         
    //Remove all current question associations
    [self.questionSetToUpdate removeQuestions:self.questionSetToUpdate.questions];
    
    
    //Associate all new qustions to questionSet
    [self.questionSetToUpdate addQuestions:[NSSet setWithArray:self.questionArray]];
    
    NSLog(@"Updated Question Set: %@", self.questionSetToUpdate);
    
	[self dismissModalViewControllerAnimated:YES];
}//end method
-(void) didCreateQuestion:(Question*)newQuestion{
    //Add to bottom
    newQuestion.questionOrder = [NSNumber numberWithInt:self.questionArray.count];
    
    //Add to cache arrays
    [self.questionArray addObject:newQuestion];
    [self.createdQuestions addObject:newQuestion];
    
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.questionArray indexOfObject:newQuestion] inSection:1]] withRowAnimation:UITableViewRowAnimationBottom];
}
-(void) didUpdateQuestion:(Question *)updatedQuestion toQuestion:(Question *)newQuestion{
    [self.questionArray replaceObjectAtIndex:[self.questionArray indexOfObject:updatedQuestion] withObject:newQuestion];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    
    //Add new question to created questions and update question to array to be disasociated
    [self.createdQuestions addObject:newQuestion];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return section == 0?2:self.questionArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indexPath.row == 0?@"nameCell":@"typeCell"];
        if (indexPath.row == 1) {
            self.typeStepper = (UIStepper *) [cell.contentView viewWithTag:15];
            [self.typeStepper addTarget:self action:@selector(stepperUpdated:) forControlEvents:UIControlEventValueChanged];
            self.typeLabel = (UILabel*) [cell.contentView viewWithTag:10];
        }
        else if (indexPath.row == 0) {
            self.nameTextField = (UITextField*) [cell.contentView viewWithTag:5];
            self.nameTextField.delegate = self;
        }

        return cell;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section]-1) {
            //Include Insert Row
            return [tableView dequeueReusableCellWithIdentifier:@"addQuestionCell"];
        }
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
        Question *question = (Question*) [self.questionArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ = %@",question.x?question.x.stringValue:@"__",self.questionSetToUpdate?self.questionSetToUpdate.typeSymbol:@"?",question.y?question.y.stringValue:@"__",question.z?question.z.stringValue:@"__"];
        
        return cell;
    }
    return nil;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return indexPath.section == 1 && indexPath.row < self.questionArray.count;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Remove out of caches
        [self.createdQuestions removeObjectIdenticalTo:[self.questionArray objectAtIndex:indexPath.row]];
        [self.questionArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

//Limit to moving to section 1
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    //Limit reodering questions to section of questions
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];     
    }
    
    return proposedDestinationIndexPath;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{    
    // Grab the item we're moving.
    QuestionSet *setToMove = [self.questionArray objectAtIndex:fromIndexPath.row];
    
    // Remove the object we're moving from the array.
    [self.questionArray removeObject:setToMove];
    // Now re-insert it at the destination.
    [self.questionArray insertObject:setToMove atIndex:toIndexPath.row];
    
    // All of the objects are now in their correct order. Update each
    // object's displayOrder field by iterating through the array.
    int i = 0;
    for (Question *q in self.questionArray)
    {
        [q setValue:[NSNumber numberWithInt:i++] forKey:@"questionOrder"];
    }
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;//indexPath.section == 1;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    AEQuestionViewController *aeQuestion = [self.storyboard instantiateViewControllerWithIdentifier:@"AEQuestionViewController"];
    aeQuestion.delegate = self;
    aeQuestion.operatorSymbol = self.questionSetToUpdate.typeSymbol;

    if ([selectedCell.reuseIdentifier isEqualToString:@"addQuestionCell"]) {
        aeQuestion.contextToCreateIn = self.administratorToCreateIn?self.administratorToCreateIn.managedObjectContext:self.questionSetToUpdate.managedObjectContext;
    }
    else if ([selectedCell.reuseIdentifier isEqualToString:@"questionCell"]) {
        aeQuestion.questionToUpdate = [self.questionArray objectAtIndex:indexPath.row];
    }
    else {
        return;
    }
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:aeQuestion];
    [self.popover presentPopoverFromRect:selectedCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
