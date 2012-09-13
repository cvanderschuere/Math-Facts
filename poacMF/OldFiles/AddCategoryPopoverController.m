//
//  AddCategoryPopoverController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "AddCategoryPopoverController.h"

@interface AddCategoryPopoverController ()

@end

@implementation AddCategoryPopoverController

@synthesize categoriesToChoose = _categoriesToChoose;
@synthesize selectedCategory = _selectedCategory;
@synthesize categoryPicker = _categoryPicker;
@synthesize delegate = _delegate;

-(void) setCategoriesToChoose:(NSMutableArray *)categoriesToChoose{
    [categoriesToChoose sortUsingSelector:@selector(compare:)];
    _categoriesToChoose = categoriesToChoose;
    [self.categoryPicker reloadAllComponents];
    if (_categoriesToChoose.count>0) {
        self.selectedCategory = [_categoriesToChoose objectAtIndex:0];
    }
}

#pragma mark Picker Data Source Methods
-(NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView {
	return 1;
}//end method

-(NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component{
    return [self.categoriesToChoose count];
}//end method

-(NSString *) pickerView: (UIPickerView *) pickerView titleForRow: (NSInteger) row forComponent: (NSInteger) component {
	NSString *returnString = @"";
    int categoryType = [[self.categoriesToChoose objectAtIndex:row] intValue];
    switch (categoryType) {
        case 0:
            returnString = @"Addition";
            break;
        case 1:
            returnString = @"Subtraction";
            break;
        case 2:
            returnString = @"Multiplication";
            break;
        case 3:
            returnString = @"Division";
            break;
        default:
            returnString = @"Unknown Type";
            break;
    }
	return returnString;
}//end method

#pragma mark Picker Delegate Methods
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.categoriesToChoose.count>0) {
        self.selectedCategory = [self.categoriesToChoose objectAtIndex:row];  
    }
}//end method


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addCategoryPressed:(id)sender {
    if (self.selectedCategory) {
        //Inform delegate
        [self.delegate didAddCategoryType:self.selectedCategory];
        //Update UI
        [self.categoriesToChoose removeObject:self.selectedCategory];
        [self.categoryPicker reloadComponent:0];
        self.selectedCategory = self.categoriesToChoose.count>0?[self.categoriesToChoose objectAtIndex:0]:nil;
    }
}
@end
