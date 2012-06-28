//
//  TestSelectCell.m
//  poacMF
//
//  Created by Chris Vanderschuere on 15/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "TestSelectCell.h"

@implementation TestSelectCell

@synthesize difficultyLevel = _difficultyLevel;
@synthesize locked = _locked;
@synthesize passedLevel = _passedLevel;

-(id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        //Modify back view
        UIView *colorView = [[UIView alloc] initWithFrame:frame];
        colorView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:colorView];
                
        //Create label in center
        UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, frame.size.width-60, frame.size.height-60)];
        levelLabel.font = [UIFont fontWithName:@"Marker Felt" size:40];
        levelLabel.textColor = [UIColor whiteColor];
        levelLabel.textAlignment = UITextAlignmentCenter;
        levelLabel.backgroundColor = [UIColor clearColor];
        levelLabel.tag = 4;
        [self.contentView addSubview:levelLabel];
        
        UIImageView *lockedImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, frame.size.width-60, frame.size.height-60)];
        lockedImage.tag = 5;
        [self.contentView addSubview:lockedImage];
        
        //Create start images
        UIImageView *star3 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width -30, frame.size.height-30, 30, 30)];
        star3.tag = 3;
        UIImageView *star2 = [[UIImageView alloc] initWithFrame:CGRectOffset(star3.frame, -20, 0)];
        star2.tag = 2;
        UIImageView *star1 = [[UIImageView alloc] initWithFrame:CGRectOffset(star2.frame, -20, 0)];
        star1.tag = 1;
        
        //Add to contentview
        [self.contentView addSubview:star1];
        [self.contentView addSubview:star2];
        [self.contentView addSubview:star3];
        
    }
    return self;
}

-(void) setPassedLevel:(NSNumber *)passedLevel{
    _passedLevel = passedLevel;
    
    UIImageView* star1 = (UIImageView*) [self.contentView viewWithTag:1];
    UIImageView* star2 = (UIImageView*) [self.contentView viewWithTag:2];
    UIImageView* star3 = (UIImageView*) [self.contentView viewWithTag:3];

    
    switch (_passedLevel.intValue) {
        case 0:
            star1.image = [UIImage imageNamed:@"goldenStarOff.png"];
            star2.image = star3.image = nil;
            //star1.image = star2.image = star3.image = [UIImage imageNamed:@"goldenStarOff.png"];
            break;
        case 1:
            star1.image = [UIImage imageNamed:@"goldenStarOn.png"];
            star2.image = star3.image = nil;
            break;
        case 2:
            star3.image = [UIImage imageNamed:@"goldenStarOff.png"];
            star2.image = star1.image = [UIImage imageNamed:@"goldenStarOn.png"];
            break;
        case 3:
            star1.image = star2.image = star3.image = [UIImage imageNamed:@"goldenStarOn.png"];
            break;
        default:
            star1.image = star2.image = star3.image = nil;
            break;
    }
    
    
}
-(void) setDifficultyLevel:(NSNumber *)difficultyLevel{
    _difficultyLevel = difficultyLevel;
    
    UILabel* difficultyLabel = (UILabel*) [self.contentView viewWithTag:4];
    difficultyLabel.text = difficultyLevel.stringValue;
}
-(void) setLocked:(BOOL)locked{
    _locked = locked;
    UIImageView *lockedImage = (UIImageView*) [self.contentView viewWithTag:5];
    lockedImage.image = locked?[UIImage imageNamed:@"lock"]:nil;
    [self.contentView viewWithTag:4].alpha = locked?0:1;
}
@end
