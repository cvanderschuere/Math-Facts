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
	UILabel		*testTypeLabel;
	UILabel		*mathTypeLabel;	
	UILabel		*resultsNumberCorrect;
	UILabel		*resultsTotalCount;
	UILabel		*resultsTimeTaken;	
	UILabel		*requiredNumberCorrect;
	UILabel		*requiredTotalCount;
	UILabel		*requiredTimeTaken;
	UILabel		*testDate;
	UILabel		*passFailLabel;
    
}

@property (nonatomic) IBOutlet	UILabel		*testTypeLabel;
@property (nonatomic) IBOutlet	UILabel		*mathTypeLabel;	
@property (nonatomic) IBOutlet	UILabel		*resultsNumberCorrect;
@property (nonatomic) IBOutlet	UILabel		*resultsTotalCount;
@property (nonatomic) IBOutlet	UILabel		*resultsTimeTaken;	
@property (nonatomic) IBOutlet	UILabel		*requiredNumberCorrect;
@property (nonatomic) IBOutlet	UILabel		*requiredTotalCount;
@property (nonatomic) IBOutlet	UILabel		*requiredTimeTaken;
@property (nonatomic) IBOutlet	UILabel		*testDate;
@property (nonatomic) IBOutlet	UILabel		*passFailLabel;


@end
