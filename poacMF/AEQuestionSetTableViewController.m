//
//  AEQuestionSetTableViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 20/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "AEQuestionSetTableViewController.h"
#import "AppLibrary.h"

@interface AEQuestionSetTableViewController ()


@property (nonatomic, strong) NSMutableArray *questionArray;

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UIStepper *typeStepper;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;

-(IBAction)stepperUpdated:(UIStepper*)sender;



@end

@implementation AEQuestionSetTableViewController
@synthesize questionSetToUpdate = _questionSetToUpdate, administratorToCreateIn = _administratorToCreateIn, nameTextField = _nameTextField;
@synthesize typeStepper = _typeStepper, typeLabel = _typeLabel, questionArray = _questionArray;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Configure for updatedUser if in edit mode
    if (self.questionSetToUpdate) {
		self.nameTextField.text = self.questionSetToUpdate.name;
		self.typeStepper.value = self.questionSetToUpdate.type.intValue;
        [self stepperUpdated: self.typeStepper];
        
        self.questionArray = self.questionSetToUpdate.questions.allObjects.mutableCopy;
        [self.questionArray sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"quesionOrder" ascending:YES]]];
        
        self.title = [@"Edit " stringByAppendingString:self.questionSetToUpdate.name];
        
	}//end editMode
    else{
        self.questionArray = [NSMutableArray array];
        self.title = @"Create Question Set";
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark Button Methods
-(IBAction) cancelClicked {
    //Dismiss View
	[self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}//end method

-(IBAction) saveClicked {
	//TODO: Need to check for valid values and unique username
	AppLibrary *al = [[AppLibrary alloc] init];
	if (nil == self.nameTextField.text){
		NSString *msg = @"Name must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
    
    //Create new student if necessary
    if (!self.questionSetToUpdate) {
        self.questionSetToUpdate = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionSet" inManagedObjectContext:self.administratorToCreateIn.managedObjectContext];
        [self.administratorToCreateIn addQuestionSetsObject:self.questionSetToUpdate];
    }
	
    self.questionSetToUpdate.name = self.nameTextField.text;    
    
    //Update all current tests to new values if changed
    if (self.questionSetToUpdate.type.doubleValue != self.typeStepper.value) {
        self.questionSetToUpdate.type = [NSNumber numberWithDouble:self.typeStepper.value];
    }
        
    
    NSLog(@"Updated Question Set: %@", self.questionSetToUpdate);
    
	[self dismissModalViewControllerAnimated:YES];
}//end method
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
    return section == 0?2:self.questionArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indexPath.row == 0?@"nameCell":@"typeCell"];
        
        //Connect up subviews ***Really bad way to do this-should make custom subclass
        if (indexPath.row == 0) {
            //Name Cell
            self.nameTextField = (UITextField*) [cell.contentView viewWithTag:5];
            self.nameTextField.delegate = self;
        }
        else {
            //Type Cell
            self.typeStepper = (UIStepper *) [cell.contentView viewWithTag:15];
            [self.typeStepper addTarget:self action:@selector(stepperUpdated:) forControlEvents:UIControlEventValueChanged];
            self.typeLabel = (UILabel*) [cell.contentView viewWithTag:10];
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

}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return indexPath.section == 1;
}


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
