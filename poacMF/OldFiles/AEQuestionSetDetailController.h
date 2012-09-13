//
//  AEQuestionSetDetailController.h
//  poacMF
//
//  Created by Matt Hunter on 5/22/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AEQuestionSetDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	/*
    UITableView		*thisTableView;
	UITextField		*xValueTF;
	UITextField		*yValueTF;
	UIPickerView	*questionSetPicker;
	NSMutableArray	*listOfQuestionSets;
	int				selectedSetIndex;
     */
	
}

@property (nonatomic, weak)	IBOutlet	UITableView		*thisTableView;
@property (nonatomic, strong)				UITextField		*xValueTF;
@property (nonatomic, strong)				UITextField		*yValueTF;
@property (nonatomic, weak)	IBOutlet	UIPickerView	*questionSetPicker;
@property (nonatomic, strong)				NSMutableArray	*listOfQuestionSets;
@property (nonatomic)						int				selectedSetIndex;

-(IBAction) cancelClicked;
-(IBAction) saveClicked;
-(UITextField *) createTextField;

@end