//
//  LaunchRocketScene.h
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "cocos2d.h"

@interface Background:CCLayerColor

@end

@interface LaunchRocketLayer : CCLayer
{
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
    int _projectilesDestroyed;
}

@end


@interface LaunchRocketScene : CCScene

@property (nonatomic, strong) Background *backgroundLayer;
@property (nonatomic, strong) LaunchRocketLayer *mainLayer;

@end
