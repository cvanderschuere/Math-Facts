//
//  CVCocosViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <UIKit/UIKit.h>

// cocos2d import
//#import "cocos2d.h"
//#import "LaunchRocketScene.h"
#import "Test.h"

@interface CVCocosViewController : UIViewController

@property (nonatomic, strong) Test *test;
//@property (nonatomic, strong) LaunchRocketScene *scene;
@property (weak, nonatomic) IBOutlet UIImageView *background;

@end
