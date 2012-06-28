//
//  SummaryTableViewCell.h
//  poacMF
//
//  Created by Chris Vanderschuere on 28/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Result.h"
#import "Test.h"

@interface SummaryTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *setLabel;
@property (nonatomic, strong) IBOutlet UILabel *correctLabel;
@property (nonatomic, strong) IBOutlet UILabel *incorrectLabel;
@property (nonatomic, strong) IBOutlet UILabel *lengthLabel;

-(void) setupCellForResult:(Result*)result withStudent: (Student*) student;

@end
