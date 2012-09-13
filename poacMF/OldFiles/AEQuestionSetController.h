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
    /*
		UITableView		*thisTableView;
		NSMutableArray	*listOfQuestionSets;
		UITextField		*nameSetTF;
		UISwitch		*addSwitch;
		UISwitch		*subSwitch;
		UISwitch		*multSwitch;
		UISwitch		*divSwitch;
	*/	
	}

@property (nonatomic, weak)	IBOutlet	UITableView		*thisTableView;
@property (nonatomic, strong)				NSMutableArray	*listOfQuestionSets;
@property (nonatomic, strong)				UITextField		*nameSetTF;
@property (nonatomic, strong)				UISwitch		*addSwitch;
@property (nonatomic, strong)				UISwitch		*subSwitch;
@property (nonatomic, strong)				UISwitch		*multSwitch;
@property (nonatomic, strong)				UISwitch		*divSwitch;

-(IBAction)			cancelClicked;
-(IBAction)			saveClicked;
-(UITextField *)	createTextField;
-(IBAction)			switchSet: (id) sender;

@end
