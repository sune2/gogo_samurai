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

        //BGM開始
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"title.mp3" loop:YES];
        [self scheduleUpdate];


        // メニュー
        [self initTitle];
        [self createMenu];

        // 灰色
		CCLayerColor* background = [CCLayerColor layerWithColor:kBackgroundColor];
		[self addChild: background z:-3];

        // 桜
        CCParticleSystemQuad* petal = [MyParticle particleCherryPetal];
        petal.position = ccp(size.width/2, size.height);
        [self addChild:petal];
        
        // 月
        CCSprite* moon = [CCSprite spriteWithFile:@"fullmoon.png"];
        moon.position = ccp(440, 250);
        moon.scale = 0.3 * 800 / moon.contentSize.width;
        moon.opacity = 128;
        [self addChild:moon z:-2];

        //
        CCSprite* sprite = [WorkLayer node];
        [self addChild:sprite];
	}
	
	return self;
}

- (void)initTitle {
    // Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
    // Title
    CCMenuItemFont *title = [CCMenuItemFont itemWithString:@"GOGO! Samurai BOY!"];
    [title setFontSize:30];
    title.color = ccWHITE;

    CCMenu* titleLabel = [CCMenu menuWithItems:title, nil];
    titleLabel.enabled = NO;
	[titleLabel setPosition:ccp(self.contentSize.width/2, self.contentSize.height*3/4)];

    [self addChild:titleLabel z:1];
}

-(void)createMenu
{
	// Enter Button
	CCMenuItemLabel *enterButtle = [CCMenuItemFont itemWithString:@"[START]" block:^(id sender){
        [_menu removeFromParent];
        [self createDifficulties];
	}];
    
    // Score Button
	CCMenuItemLabel *enterScore = [CCMenuItemFont itemWithString:@"[SCORE]" block:^(id sender){
		[[CCDirector sharedDirector] pushScene: [ScoreBoard scene]];
	}];

    enterButtle.color = ccWHITE;
    enterScore.color = ccWHITE;

    _menu = [CCMenu menuWithItems:enterButtle, enterScore, nil];
	
	[_menu alignItemsVertically];
    
    [_menu setPosition:ccp( self.contentSize.width/2, self.contentSize.height/4)];
	
	[self addChild: _menu z:1];
}

-(void)createDifficulties
{
    // 難易度選択
    CCMenuItemLabel *easyLabel = [CCMenuItemFont itemWithString:@"[Easy]" block:^(id sender){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ohshu.mp3" loop:YES];
		[[CCDirector sharedDirector] replaceScene: [GameStage scene]];
	}];

    // Score Button
	CCMenuItemLabel *normalLabel = [CCMenuItemFont itemWithString:@"[Normal]" block:^(id sender){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ohshu.mp3" loop:YES];
		[[CCDirector sharedDirector] replaceScene: [GameStage scene]];
	}];

    CCMenuItemLabel *hardLabel = [CCMenuItemFont itemWithString:@"[Hard]" block:^(id sender){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ohshu.mp3" loop:YES];
		[[CCDirector sharedDirector] replaceScene: [GameStage scene]];
	}];

    CCMenuItemLabel *backLabel = [CCMenuItemFont itemWithString:@"[Back]" block:^(id sender){
        [_difficulties removeFromParent];
        [self createMenu];
	}];

    _difficulties = [CCMenu menuWithItems:easyLabel, normalLabel, hardLabel, backLabel, nil];
    [_difficulties alignItemsVertically];
    _difficulties.position = ccp(self.contentSize.width/2, self.contentSize.height/4);

    [self addChild:_difficulties];
}




//- (void)update:(ccTime)delta {
//    if (rand() % (60*3) == 0) {
//        CCParticleSystemQuad* cherry = [MyParticle particleCherryBlossom];
//        
//        CGSize size = [[CCDirector sharedDirector] winSize];
//        
//        cherry.position = ccp(rand()%(int)size.width, rand()%(int)size.height);
//        [self addChild:cherry];
//    }
//}

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