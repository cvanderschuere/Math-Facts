//
//  TestSelectCell.h
//  poacMF
//
//  Created by Chris Vanderschuere on 15/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "AQGridViewCell.h"

@interface TestSelectCell : AQGridViewCell

@property (nonatomic, strong) NSNumber* difficultyLevel;
@property (nonatomic, strong) NSNumber* passedLevel; //0: not passed 1: passed 2: passed+10% 3: passed+20%



@end
