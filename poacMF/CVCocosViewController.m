//
//  CVCocosViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 07/06/2012.
//  Copyright (c) 2012 Matt Hunter. All rights reserved.
//

#import "CVCocosViewController.h"
#import "LaunchRocketScene.h"

@interface CVCocosViewController ()

@end

@implementation CVCocosViewController

@synthesize scene = _scene;
@synthesize test = _test;

-(void) setTest:(Test *)test{
    _test = test;
}

- (void)setupCocos2D {    
    CCDirector* director = [CCDirector sharedDirector];
    CCGLView *glview = [CCGLView viewWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
    
    [director setView:glview];
    
    [self.view addSubview:glview];
    
    self.scene = [LaunchRocketScene node];
    [director pushScene:self.scene];
    [director startAnimation];
    
}
-(void) tearDownCocos2D{
    CCDirector* director = [CCDirector sharedDirector];
    
    // Since v0.99.4 you have to remove the OpenGL View manually
    [director.view removeFromSuperview];
    
    // kill the director
    [director end];

}

#pragma mark - View Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCocos2D];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self tearDownCocos2D];
    // Release any retained subviews of the main view.
}
-(void) didReceiveMemoryWarning{
    [[CCDirector sharedDirector] purgeCachedData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
