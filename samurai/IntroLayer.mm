//
//  IntroLayer.m
//  samurai
//
//  Created by CA2015 on 13/09/04.
//  Copyright gogo-samurai 2013年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "AppDelegate.h"

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
        [[CCDirector sharedDirector] setDisplayStats:NO];
        
		// ask director for the window size
		_winSize = resizeForAd([[CCDirector sharedDirector] winSize]);

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
        petal.position = ccp(_winSize.width/2, _winSize.height+kAdHeight);
        [self addChild:petal];
        
        // 月
        CCSprite* moon = [CCSprite spriteWithFile:@"fullmoon.png"];
        moon.position = ccp(_winSize.width -  40, _winSize.height - 70);
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
    title.color = ccc3(0, 255, 200);

    CCMenu* titleLabel = [CCMenu menuWithItems:title, nil];
    titleLabel.enabled = NO;
	[titleLabel setPosition:ccp(_winSize.width/2, _winSize.height*13/16)];

    [self addChild:titleLabel z:1];
}

-(void)createMenu
{
	// Enter Button
	CCMenuItemLabel *enterButtle = [CCMenuItemFont itemWithString:@"[Start]" block:^(id sender){        
        [_menu removeFromParent];
        [self createDifficulties];
	}];
    
    // Score Button
	CCMenuItemLabel *enterScore = [CCMenuItemFont itemWithString:@"[Ranking]" block:^(id sender){
		[[CCDirector sharedDirector] pushScene: [ScoreBoard scene]];
	}];
    
    CCMenuItemLabel *guideButton = [CCMenuItemFont itemWithString:@"[How To Play]" block:^(id sender){
        [_menu removeFromParent];
        [self createGuide];
	}];

    enterButtle.color = ccWHITE;
    enterScore.color = ccWHITE;

    __block id copy_self = self;

    // Achievement Menu Item using blocks
    CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"[Leaderboard]" block:^(id sender) {
        GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
        leaderboardViewController.leaderboardDelegate = copy_self;
        leaderboardViewController.category = nil;
        leaderboardViewController.timeScope = GKLeaderboardTimeScopeAllTime;
        
        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];

        [[app navController] presentModalViewController:leaderboardViewController animated:YES];

        [leaderboardViewController release];
    }];

    _menu = [CCMenu menuWithItems:enterButtle, enterScore, itemLeaderboard, guideButton, nil];
	
	[_menu alignItemsVerticallyWithPadding:kMenuVerticalPadding];
    
    [_menu setPosition:ccp( _winSize.width/2, _winSize.height*11/32)];
	
	[self addChild: _menu z:1];
}

-(void)createDifficulties
{
    // 難易度選択
    CCMenuItemLabel *easyLabel = [CCMenuItemFont itemWithString:@"[Easy]" block:^(id sender){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ohshu.mp3" loop:YES];
		[[CCDirector sharedDirector] replaceScene: [GameStage sceneWithDifficulty:DifficultyEasy]];
	}];
    easyLabel.color = kEasyColor;

	CCMenuItemLabel *normalLabel = [CCMenuItemFont itemWithString:@"[Normal]" block:^(id sender){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ohshu.mp3" loop:YES];
		[[CCDirector sharedDirector] replaceScene: [GameStage sceneWithDifficulty:DifficultyNormal]];
	}];
    normalLabel.color = kNormalColor;

    CCMenuItemLabel *hardLabel = [CCMenuItemFont itemWithString:@"[Hard]" block:^(id sender){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ohshu.mp3" loop:YES];
		[[CCDirector sharedDirector] replaceScene: [GameStage sceneWithDifficulty:DifficultyHard]];
	}];
    hardLabel.color = kHardColor;

    CCMenuItemLabel *backLabel = [CCMenuItemFont itemWithString:@"[Back]" block:^(id sender){
        [_difficulties removeFromParent];
        [_backMenu removeFromParent];
        [self createMenu];
	}];

    _difficulties = [CCMenu menuWithItems:easyLabel, normalLabel, hardLabel, backLabel, nil];
    [_difficulties alignItemsVerticallyWithPadding:kMenuVerticalPadding];
    _difficulties.position = ccp(_winSize.width/2, _winSize.height*11/32);
    [self addChild:_difficulties];

//    _backMenu = [CCMenu menuWithItems: backLabel, nil];
//    _backMenu.position = ccp(_winSize.width/2, _winSize.height*2/16);
//    [self addChild:_backMenu];
}

- (void)createGuide {
    CCMenuItemLabel* touch = [CCMenuItemFont itemWithString:@"Tap : counter slice"];
    touch.isEnabled = NO;
    CCMenuItemLabel* right = [CCMenuItemFont itemWithString:@"Swipe Right : dash"];
    right.isEnabled = NO;
    CCMenuItemLabel* up = [CCMenuItemFont itemWithString:@"Swipe Up : jump"];
    up.isEnabled = NO;
//    CCMenuItemLabel* touch = [CCMenuItemFont itemWithString:@"Touch : counter"];
    CCMenuItemLabel *back = [CCMenuItemFont itemWithString:@"[Back]" block:^(id sender){
        [_guide removeFromParent];
//        [_guideBack removeFromParent];
        [self createMenu];
	}];
    
    CCMenuItemLabel* kara = [CCMenuItemFont itemWithString:@"_"];
    kara.visible = NO;
    kara.isEnabled = NO;
    
    _guide = [CCMenu menuWithItems:touch, right, up, kara, back, nil];
    [_guide alignItemsVertically];
    _guide.position = ccp(_winSize.width/2, _winSize.height*5/16);
    [self addChild:_guide];
}

+ (void)initialize
{
    NSString* defaultName = @"Samurai";
    NSMutableDictionary* defaultDict = [@{
                                        @"Name":defaultName,
                                        @"Easy": [IntroLayer generateNewRanking],
                                        @"Normal": [IntroLayer generateNewRanking],
                                        @"Hard": [IntroLayer generateNewRanking]
                                        } mutableCopy];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud registerDefaults:defaultDict];
    [ud synchronize];
}

+(NSMutableArray *)generateNewRanking
{
    NSMutableArray* defaultArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        NSMutableDictionary* scoreData = [@{
                                          @"score": [NSNumber numberWithInt:0],
                                          @"name": @"Samurai",
                                          @"new": [NSNumber numberWithBool:NO]
                                          } mutableCopy];
        [defaultArr addObject:scoreData];
    }
    return defaultArr;
}


-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}


@end