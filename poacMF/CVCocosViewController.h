//
//  CVCocosViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>

// cocos2d import
#import "cocos2d.h"
#import "LaunchRocketScene.h"

@interface CVCocosViewController : UIViewController

@property (nonatomic, strong) LaunchRocketScene *scene;
@property (nonatomic, strong) CCDirector *director;

@end
