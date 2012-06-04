//
//  ResultsViewCell.m
//  poacMF
//
//  Created by Matt Hunter on 5/6/11.
//  Copyright 2011 Matt Hunter. All rights reserved.
//

#import "ResultsViewCell.h"


@implementation ResultsViewCell

@synthesize testTypeLabel,mathTypeLabel,resultsNumberCorrect;
@synthesize resultsTotalCount,resultsTimeTaken,requiredNumberCorrect;
@synthesize requiredTotalCount,requiredTimeTaken, testDate, passFailLabel;

- (void)dealloc {
	[testTypeLabel release];
	[mathTypeLabel release];
	[resultsNumberCorrect release];
	[resultsTotalCount release];
	[resultsTimeTaken release];
	[requiredNumberCorrect release];
	[requiredTotalCount release];
	[requiredTimeTaken release];
	[testDate release];
	[passFailLabel release];
    [super dealloc];
}

@end
