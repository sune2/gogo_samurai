//
//  IntroLayer.m
//  samurai
//
//  Created by CA2015 on 13/09/04.
//  Copyright gogo-samurai 2013年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"

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
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"tmpDefs.plist"];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"bg.jpg"];
			background.rotation = 0;
            background.scale = 640/background.contentSize.width;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
		
		// add the label as a child to this Layer
		[self addChild: background];
        [self createMenu];
	}
	
	return self;
}

-(void)createMenu
{
    // Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
    // Title
    CCMenuItemFont *title = [CCMenuItemFont itemWithString:@"GOGO! Samurai BOY!"];
    [title setFontSize:30];

    
	// Enter Button
	CCMenuItemLabel *enterButtle = [CCMenuItemFont itemWithString:@"[START]" block:^(id sender){
        //BGM開始
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ohshu.mp3" loop:YES];
		[[CCDirector sharedDirector] replaceScene: [GameStage scene]];
	}];
    
    // Score Button
	CCMenuItemLabel *enterScore = [CCMenuItemFont itemWithString:@"[SCORE]" block:^(id sender){
		[[CCDirector sharedDirector] pushScene: [ScoreBoard scene]];
	}];
    
    title.color = ccBLACK;
    enterButtle.color = ccBLACK;
    enterScore.color = ccBLACK;
    
    CCMenu* titleLabel = [CCMenu menuWithItems:title, nil];
    CCMenu *menu = [CCMenu menuWithItems:enterButtle, enterScore, nil];
	
	[menu alignItemsVertically];
    
	CGSize size = [[CCDirector sharedDirector] winSize];
    
    titleLabel.enabled = NO;
	[titleLabel setPosition:ccp(size.width/2, size.height*3/4)];
    [menu setPosition:ccp( size.width/2, size.height/4)];
	
    
	[self addChild:titleLabel z:1];
	[self addChild: menu z:1];
}

-(void) onEnter
{
	[super onEnter];
    
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameStage scene] ]];
    

    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"title.mp3" loop:YES];
}

+ (void)initialize
{
    NSString* defaultName = @"Samurai";
    
    NSMutableArray* defaultArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        NSMutableDictionary* scoreData = [@{
                                          @"score": [NSNumber numberWithInt:0],
                                          @"name": @"Samurai",
                                          @"new": [NSNumber numberWithBool:NO]
                                          } mutableCopy];
        [defaultArr addObject:scoreData];
    }
    NSMutableDictionary* defaultDict = [@{@"Name":defaultName, @"Rank": defaultArr} mutableCopy];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud registerDefaults:defaultDict];
    [ud synchronize];
}





@end