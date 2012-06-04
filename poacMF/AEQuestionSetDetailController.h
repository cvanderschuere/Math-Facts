//
//  AEQuestionSetDetailController.h
//  poacMF
//
//  Created by Matt Hunter on 5/22/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AEQuestionSetDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	
    UITableView		*thisTableView;
	UITextField		*xValueTF;
	UITextField		*yValueTF;
	UIPickerView	*questionSetPicker;
	NSMutableArray	*listOfQuestionSets;
	int				selectedSetIndex;
	
}

@property (nonatomic)	IBOutlet	UITableView		*thisTableView;
@property (nonatomic)				UITextField		*xValueTF;
@property (nonatomic)				UITextField		*yValueTF;
@property (nonatomic)	IBOutlet	UIPickerView	*questionSetPicker;
@property (nonatomic)				NSMutableArray	*listOfQuestionSets;
@property (nonatomic)						int				selectedSetIndex;

-(IBAction) cancelClicked;
-(IBAction) saveClicked;
-(UITextField *) createTextField;

@end