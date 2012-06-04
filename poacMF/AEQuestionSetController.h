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

@property (nonatomic, retain)	IBOutlet	UITableView		*thisTableView;
@property (nonatomic, retain)				NSMutableArray	*listOfQuestionSets;
@property (nonatomic, retain)				UITextField		*nameSetTF;
@property (nonatomic, retain)				UISwitch		*addSwitch;
@property (nonatomic, retain)				UISwitch		*subSwitch;
@property (nonatomic, retain)				UISwitch		*multSwitch;
@property (nonatomic, retain)				UISwitch		*divSwitch;

-(IBAction)			cancelClicked;
-(IBAction)			saveClicked;
-(UITextField *)	createTextField;
-(IBAction)			switchSet: (id) sender;

@end
