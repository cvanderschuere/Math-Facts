//
//  AEQuestionSetController.h
//  poacMF
//
//  Created by Matt Hunter on 5/24/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AEQuestionSetController : UIViewController <UITableViewDelegate, 
	UITableViewDataSource, UITextFieldDelegate> {
    
		UITableView		*thisTableView;
		NSMutableArray	*listOfQuestionSets;
		UITextField		*nameSetTF;
		UISwitch		*addSwitch;
		UISwitch		*subSwitch;
		UISwitch		*multSwitch;
		UISwitch		*divSwitch;
		
	}

@property (nonatomic)	IBOutlet	UITableView		*thisTableView;
@property (nonatomic)				NSMutableArray	*listOfQuestionSets;
@property (nonatomic)				UITextField		*nameSetTF;
@property (nonatomic)				UISwitch		*addSwitch;
@property (nonatomic)				UISwitch		*subSwitch;
@property (nonatomic)				UISwitch		*multSwitch;
@property (nonatomic)				UISwitch		*divSwitch;

-(IBAction)			cancelClicked;
-(IBAction)			saveClicked;
-(UITextField *)	createTextField;
-(IBAction)			switchSet: (id) sender;

@end
