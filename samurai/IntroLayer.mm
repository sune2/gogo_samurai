//
//  IntroLayer.m
//  samurai
//
//  Created by CA2015 on 13/09/04.
//  Copyright gogo-samurai 2013年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import "GameStage.h"
#import "GB2ShapeCache.h"
#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(id) init
{
	if( (self=[super init])) {
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"shapeDef.plist"];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"bg.jpg"];
			background.rotation = 0;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
		
		// add the label as a child to this Layer
		[self addChild: background];
	}
	
	return self;
}

-(void)createMenu
{
    // Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
    // Title
    CCMenuItemLabel *title = [CCMenuItemFont itemWithString:@"GoGo! Samurai boy!"];
    
    
	// Reset Button
	CCMenuItemLabel *enterButtle = [CCMenuItemFont itemWithString:@"[Shutsu-Jin]" block:^(id sender){
		[[CCDirector sharedDirector] replaceScene: [GameStage scene]];
	}];
    
    // Score Button
	CCMenuItemLabel *enterScore = [CCMenuItemFont itemWithString:@"[Bu-koh]" block:^(id sender){
		[[CCDirector sharedDirector] replaceScene: [GameStage scene]];
	}];
    
    title.color = ccBLACK;
    enterButtle.color = ccBLACK;
    enterScore.color = ccBLACK;
    
    CCMenu *menu = [CCMenu menuWithItems:title, enterButtle, enterScore, nil];
	
	[menu alignItemsVertically];
    
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	
	[self addChild: menu z:1];
}

-(void) onEnter
{
	[super onEnter];
    
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameStage scene] ]];
    
    [self createMenu];
}
@end
