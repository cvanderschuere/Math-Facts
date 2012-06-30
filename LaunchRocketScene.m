//
//  LaunchRocketScene.m
//  poacMF
//
//  Created by Chris Vanderschuere on 08/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//
/*
#import "LaunchRocketScene.h"
#import "Test.h"
#import "GameOverScene.h"
#import "SimpleAudioEngine.h"


@implementation Background

-(id) init
{
	if( (self=[super initWithColor:ccc4(0,0,0,0)] ))
    {
        CCSprite *background = [CCSprite spriteWithFile:@"LaunchSceneBackground.png"];  
        background.position = CGPointMake(background.contentSize.width/2, background.contentSize.height/2);
        background.blendFunc = (ccBlendFunc){GL_ONE, GL_ZERO};
        [self addChild:background];
        
    }
    return self;
}

@end

@implementation LaunchRocketScene
@synthesize mainLayer = _mainLayer;

-(id) init{
    self = [super init];
    if (self) {
        //self.backgroundLayer = [Background node];
        self.mainLayer = [LaunchRocketLayer node];
        
        //Add child
        [self addChild:[Background node]];
        [self addChild:self.mainLayer];
        
    }
    return self;
}
@end

@implementation LaunchRocketLayer

@synthesize rockets = _rockets;
@synthesize labelX = _labelX, labelY = _labelY, labelZ = _labelZ;

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(255,255,255,0)])) {
        
		// Enable touch events
		self.isTouchEnabled = YES;
		
		// Get the dimensions of the window for calculation purposes
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //Add Number Labels
        self.labelX = [CCLabelTTF labelWithString:@"10" fontName:@"Marker Felt" fontSize:60];
        self.labelX.position = CGPointMake(winSize.width/2, winSize.height - self.labelX.contentSize.height/2);
        self.labelY = [CCLabelTTF labelWithString:@"15" fontName:@"Marker Felt" fontSize:60];
        self.labelY.position = CGPointMake(winSize.width/2, winSize.height - self.labelX.contentSize.height - self.labelY.contentSize.height/2);
        self.labelZ = [CCLabelTTF labelWithString:@"25" fontName:@"Marker Felt" fontSize:60];
        self.labelZ.position = CGPointMake(winSize.width/2,  winSize.height - self.labelX.contentSize.height - self.labelY.contentSize.height - self.labelZ.contentSize.height/2 - 10);

        
        [self addChild:self.labelX z:1 tag:2];
        [self addChild:self.labelY z:1 tag:2];
        [self addChild:self.labelZ z:1 tag:2];
        
        //Add = line and operator symbol
        CCLabelTTF *equalSymbol = [CCLabelTTF labelWithString:@"—————————" fontName:@"Marker Felt" fontSize:40];
        equalSymbol.position = CGPointMake(winSize.width/2, winSize.height - self.labelX.contentSize.height - self.labelY.contentSize.height/2 - 10);
        [self addChild:equalSymbol z:1 tag:100];
        
        
        //Create Rocket array
        self.rockets = [NSMutableArray arrayWithCapacity:10];
        
        //Add 10 Rockets to bottom of screen
        for (int i = 0; i<10; i++) {
            CCSprite *rocket = [CCSprite spriteWithFile:@"rocket.png" rect:CGRectMake(0, 0, 80, 163)];
            rocket.position = ccp(i*(winSize.width/10) + rocket.contentSize.width/2, rocket.contentSize.height);
            [self.rockets addObject:rocket];
            [self addChild:rocket];
        }
		
		// Call game logic about every second
        [self schedule:@selector(gameLogic:) interval:1];
        [self schedule:@selector(update:) interval:1.0/60.0];
        //[[CCDirector sharedDirector].scheduler scheduleSelector:@selector(gameLogic:) forTarget:self interval:1.0 paused:NO];
        //[[CCDirector sharedDirector].scheduler scheduleSelector:@selector(update:) forTarget:self interval:1.0 paused:NO];
		
		// Start up the background music
		//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
		
	}
	return self;
}



/*
-(void)spriteMoveFinished:(id)sender {
    
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
	
	if (sprite.tag == 1) { // target
		[_targets removeObject:sprite];
		
		GameOverScene *gameOverScene = [GameOverScene node];
		[gameOverScene.layer.label setString:@"You Lose :["];
		[[CCDirector sharedDirector] replaceScene:gameOverScene];
		
	} else if (sprite.tag == 2) { // projectile
		[_projectiles removeObject:sprite];
	}
	
}

-(void)addTarget {
    
	CCSprite *target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)]; 
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = target.contentSize.height/2;
	int maxY = winSize.height - target.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 8.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	// Add to targets array
	target.tag = 1;
	[_targets addObject:target];
	
}
*/
-(void)gameLogic:(ccTime)dt {
		
}

- (void)update:(ccTime)dt {
    
	NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
	for (CCSprite *projectile in _projectiles) {
		CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width/2), 
										   projectile.position.y - (projectile.contentSize.height/2), 
										   projectile.contentSize.width, 
										   projectile.contentSize.height);
        
		NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
		for (CCSprite *target in _targets) {
			CGRect targetRect = CGRectMake(target.position.x - (target.contentSize.width/2), 
										   target.position.y - (target.contentSize.height/2), 
										   target.contentSize.width, 
										   target.contentSize.height);
            
			if (CGRectIntersectsRect(projectileRect, targetRect)) {
				[targetsToDelete addObject:target];				
			}						
		}
		
		for (CCSprite *target in targetsToDelete) {
			[_targets removeObject:target];
			[self removeChild:target cleanup:YES];									
			_projectilesDestroyed++;
			if (_projectilesDestroyed > 30) {
				GameOverScene *gameOverScene = [GameOverScene node];
				[gameOverScene.layer.label setString:@"You Win!"];
				[[CCDirector sharedDirector] replaceScene:gameOverScene];
			}
		}
		
		if (targetsToDelete.count > 0) {
			[projectilesToDelete addObject:projectile];
		}
	}
	
	for (CCSprite *projectile in projectilesToDelete) {
		[_projectiles removeObject:projectile];
		[self removeChild:projectile cleanup:YES];
	}
}

- (void)pauseGame {
    NSLog(@"Paused!");
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //Detech rocket pressed
    CGPoint location = [self convertTouchToNodeSpace:[touches anyObject]];
    
    [self.rockets enumerateObjectsUsingBlock:^(CCSprite* rocket,NSUInteger idx,BOOL *stop){
        if (CGRectContainsPoint(rocket.boundingBox, location))
        {
            NSLog(@"Touched Rocket: %@", rocket);
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            ccBezierConfig bezier;
            bezier.endPosition = self.labelZ.position;
            
            id bezierForward = [CCBezierTo actionWithDuration:2 bezier:bezier];
            [rocket runAction:bezierForward];
            
        }

    }];
    
	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
    location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	
	// Set up initial location of projectile
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CCSprite *projectile = [CCSprite spriteWithFile:@"Projectile.png" rect:CGRectMake(0, 0, 20, 20)];
	projectile.position = ccp(20, winSize.height/2);
	
	// Determine offset of location to projectile
	int offX = location.x - projectile.position.x;
	int offY = location.y - projectile.position.y;
	
	// Bail out if we are shooting down or backwards
	if (offX <= 0) return;
    
    // Ok to add now - we've double checked position
    [self addChild:projectile];
    
	// Play a sound!
	//[[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
	
	// Determine where we wish to shoot the projectile to
	int realX = winSize.width + (projectile.contentSize.width/2);
	float ratio = (float) offY / (float) offX;
	int realY = (realX * ratio) + projectile.position.y;
	CGPoint realDest = ccp(realX, realY);
	
	// Determine the length of how far we're shooting
	int offRealX = realX - projectile.position.x;
	int offRealY = realY - projectile.position.y;
	float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
	float velocity = 480/1; // 480pixels/1sec
	float realMoveDuration = length/velocity;
	
	// Move projectile to actual endpoint
	[projectile runAction:[CCSequence actions:
						   [CCMoveTo actionWithDuration:realMoveDuration position:realDest], nil]];
	
	// Add to projectiles array
	projectile.tag = 2;
	[_projectiles addObject:projectile];
	
}
*/


@end

