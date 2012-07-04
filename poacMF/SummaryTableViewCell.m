//
//  SummaryTableViewCell.m
//  poacMF
//
//  Created by Chris Vanderschuere on 28/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "SummaryTableViewCell.h"

@implementation SummaryTableViewCell
@synthesize nameLabel = _nameLabel, dateLabel = _dateLabel, setLabel = _setLabel, correctLabel = _correctLabel, incorrectLabel = _incorrectLabel, lengthLabel = _lengthLabel;

-(void) setupCellForResult:(Result *)result withStudent:(Student *)student{
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName,student.lastName];
    if (result) {
        self.dateLabel.text = [NSDateFormatter localizedStringFromDate:result.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
        self.setLabel.text = [NSString stringWithFormat:@"%@: %@",result.test.questionSet.typeName,result.test.questionSet.name];
        self.correctLabel.text = [NSNumber numberWithInt:result.correctResponses.count * ((60)/([result.endDate timeIntervalSinceDate:result.startDate]))].stringValue;
        self.incorrectLabel.text = [NSNumber numberWithInt:result.incorrectResponses.count * ((60.0f)/([result.endDate timeIntervalSinceDate:result.startDate]))].stringValue;
        self.lengthLabel.text = [NSString stringWithFormat:@"%.0f",[result.endDate timeIntervalSinceDate:result.startDate]];
    }
    else {
        self.setLabel.text = @"No Timings";
        self.dateLabel.text = self.correctLabel.text = self.incorrectLabel.text = self.lengthLabel.text = nil;
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
