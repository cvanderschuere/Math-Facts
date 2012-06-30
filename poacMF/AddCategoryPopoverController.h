//
//  AddCategoryPopoverController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddCategoryPopoverController : UIViewController


@property (nonatomic, weak) id<AddCategoryDelegate> delegate;
@property (nonatomic, strong) NSMutableArray* categoriesToChoose;
@property (nonatomic, strong) NSNumber *selectedCategory;
@property (nonatomic, weak) IBOutlet UIPickerView *categoryPicker;
- (IBAction)addCategoryPressed:(id)sender;

@end
