//
//  AEQuestionViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 15/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "AEQuestionViewController.h"

@interface AEQuestionViewController ()

@end

@implementation AEQuestionViewController
@synthesize xStepper = _xStepper;
@synthesize yStepper = _yStepper;
@synthesize zStepper = _zStepper;
@synthesize xLabel = _xLabel;
@synthesize operatorLabel = _operatorLabel;
@synthesize yLabel = _yLabel;
@synthesize zLabel = _zLabel;

@synthesize questionToUpdate = _questionToUpdate, contextToCreateIn = _contextToCreateIn, operatorSymbol = _operatorSymbol;
@synthesize delegate = _delegate;

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Configure for updateQuestion if in edit mode
    if (self.questionToUpdate) {
        //Set stepper Views
		self.xStepper.value = self.questionToUpdate.x?self.questionToUpdate.x.doubleValue:-1;
        self.yStepper.value = self.questionToUpdate.y?self.questionToUpdate.y.doubleValue:-1;
        self.zStepper.value = self.questionToUpdate.z?self.questionToUpdate.z.doubleValue:-1;
        
        //Update labels
        [self stepperUpdate:self.xStepper];
        [self stepperUpdate:self.yStepper];
        [self stepperUpdate:self.zStepper];
        
        self.operatorLabel.text = self.questionToUpdate.questionSet.typeSymbol;
        
        self.title = [@"Edit Question " stringByAppendingString:self.questionToUpdate.questionOrder.stringValue];

	}//end
    else{
        self.title = @"Create Question";
        self.zStepper.value = -1;
        self.operatorLabel.text = self.operatorSymbol?self.operatorSymbol:@"?";
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Check if more than one blank
	AppLibrary *al = [[AppLibrary alloc] init];
    if ((self.xStepper.value == -1 && self.yStepper.value == -1)||(self.xStepper.value == -1 && self.zStepper.value == -1)||(self.zStepper.value == -1 && self.yStepper.value == -1)){
		NSString *msg = @"Too many blanks in question";
		[al showAlertFromDelegate:nil withWarning:msg];
		return;
	}//end if
    //Check if no blanks
    else if(self.xStepper.value > -1 && self.yStepper.value > -1 && self.zStepper.value > -1) {
        NSString *msg = @"There must be a blank in question";
		[al showAlertFromDelegate:nil withWarning:msg];
		return;
    }
    
    if (self.contextToCreateIn) {
        //Create New question or update old
        BOOL isEditing = YES;
        //Create new student if necessary
        if (!self.questionToUpdate) {
            self.questionToUpdate = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:self.contextToCreateIn];
            isEditing = NO;
        }
        
        self.questionToUpdate.x = self.xStepper.value != -1?[NSNumber numberWithDouble:self.xStepper.value]:nil;
        self.questionToUpdate.y = self.yStepper.value != -1?[NSNumber numberWithDouble:self.yStepper.value]:nil;
        self.questionToUpdate.z = self.zStepper.value != -1?[NSNumber numberWithDouble:self.zStepper.value]:nil;
            
        isEditing?[self.delegate didUpdateQuestion:self.questionToUpdate]:[self.delegate didCreateQuestion:self.questionToUpdate];
    }
}

- (void)viewDidUnload {
    [self setXStepper:nil];
    [self setYStepper:nil];
    [self setZStepper:nil];
    [self setXLabel:nil];
    [self setOperatorLabel:nil];
    [self setYLabel:nil];
    [self setZLabel:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
#pragma mark - IBActions
- (IBAction)stepperUpdate:(UIStepper*)sender {
    //Update labels
    if ([sender isEqual:self.xStepper]) {
        self.xLabel.text = self.xStepper.value != -1?[NSNumber numberWithDouble:self.xStepper.value].stringValue:@"__";
    }
    else if ([sender isEqual:self.yStepper]) {
        self.yLabel.text = self.yStepper.value != -1?[NSNumber numberWithDouble:self.yStepper.value].stringValue:@"__";
    }
    else if ([sender isEqual:self.zStepper]) {
        self.zLabel.text = self.zStepper.value != -1?[NSNumber numberWithDouble:self.zStepper.value].stringValue:@"__";
    }
}


@end
