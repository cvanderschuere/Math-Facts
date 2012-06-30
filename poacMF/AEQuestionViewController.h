//
//  AEQuestionViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 15/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionSet.h"
#import "AppLibrary.h"

@protocol AEQuestionProtocol <NSObject>

-(void) didCreateQuestion:(Question*)newQuestion;
-(void) didUpdateQuestion:(Question*) updatedQuestion;

@end

//Data flow

    //Update
        //questionToUpdateIsProvided
    //Create
        //managedObjectContext and type is provided

@interface AEQuestionViewController : UIViewController

@property (nonatomic, strong) Question *questionToUpdate;
@property (nonatomic, strong) NSManagedObjectContext *contextToCreateIn;
@property (nonatomic, strong) NSString *operatorSymbol;
@property (nonatomic, weak) id<AEQuestionProtocol> delegate;

//IBOutlets
@property (weak, nonatomic) IBOutlet UIStepper *xStepper;
@property (weak, nonatomic) IBOutlet UIStepper *yStepper;
@property (weak, nonatomic) IBOutlet UIStepper *zStepper;

@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;

//IBActions
- (IBAction)stepperUpdate:(id)sender;

@end
