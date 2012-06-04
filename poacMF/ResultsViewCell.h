//
//  ResultsViewCell.h
//  poacMF
//
//  Created by Matt Hunter on 5/6/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


/* Note!! for the associated nib file, leave the File Owner as NSObject. Select
 the UITableCell in the nib file and set it's class to ResultsViewCell */

@interface ResultsViewCell : UITableViewCell {
	UILabel		*__weak testTypeLabel;
	UILabel		*__weak mathTypeLabel;	
	UILabel		*__weak resultsNumberCorrect;
	UILabel		*__weak resultsTotalCount;
	UILabel		*__weak resultsTimeTaken;	
	UILabel		*__weak requiredNumberCorrect;
	UILabel		*__weak requiredTotalCount;
	UILabel		*__weak requiredTimeTaken;
	UILabel		*__weak testDate;
	UILabel		*__weak passFailLabel;
    
}

@property (weak, nonatomic) IBOutlet	UILabel		*testTypeLabel;
@property (weak, nonatomic) IBOutlet	UILabel		*mathTypeLabel;	
@property (weak, nonatomic) IBOutlet	UILabel		*resultsNumberCorrect;
@property (weak, nonatomic) IBOutlet	UILabel		*resultsTotalCount;
@property (weak, nonatomic) IBOutlet	UILabel		*resultsTimeTaken;	
@property (weak, nonatomic) IBOutlet	UILabel		*requiredNumberCorrect;
@property (weak, nonatomic) IBOutlet	UILabel		*requiredTotalCount;
@property (weak, nonatomic) IBOutlet	UILabel		*requiredTimeTaken;
@property (weak, nonatomic) IBOutlet	UILabel		*testDate;
@property (weak, nonatomic) IBOutlet	UILabel		*passFailLabel;


@end
