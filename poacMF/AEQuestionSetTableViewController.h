//
//  AEQuestionSetTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 20/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionSet.h"
#import "Administrator.h"
#import "AEQuestionViewController.h"

/*
 *Object Creating Rules*

    //Add QuestionSet
    
        //Save
            //Create Question Set (Set administrator)
            //Assign values 
            //Use array of questions to assign to question set 
        //Cancel
            //Delete created questions

    //Edit Question Set
        //Set all values to current values
        //Create array of questions

        //Save
            //make changes to values
            //delete all current questions and reassign to questions and order of array

        //Cancel
            //disregard changes to values
            //delete all created questions
*/



@interface AEQuestionSetTableViewController : UITableViewController <UITextFieldDelegate, AEQuestionProtocol>

@property (nonatomic, strong) QuestionSet *questionSetToUpdate;
@property (nonatomic, strong) Administrator *administratorToCreateIn;

@end
