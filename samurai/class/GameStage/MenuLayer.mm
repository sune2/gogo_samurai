//
//  Menu.m
//  samurai
//
//  Created by CA2015 on 13/09/06.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "MenuLayer.h"

@implementation MenuLayer

-(id)init
{
    self = [super init];
    if (self) {
        self.touchEnabled = NO;
        _score = 0;
        _life = 3;
        _winSize = [[CCDirector sharedDirector] winSize];
        _lifeDangos = [[NSMutableArray alloc] init];
        _menuExpanded = NO;
        [self createMenu];
        [self addDango];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)createMenu
{
    
    // Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
    
    // Score
    _scoreLabel = [self labelWithInteger:_score];
    _scoreLabel.isEnabled = NO;
    _scoreLabel.disabledColor = ccWHITE;

//	// Reset Button
//    CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
//         [_delegate resetButtonPushed];
//     }];

//    CCMenuItemLabel *top = [CCMenuItemFont itemWithString:@"Top" block:^(id sender) {
//        [_delegate backToIntroLayer];
//    }];
    
    CCMenuItemLabel *menuLabel = [CCMenuItemFont itemWithString:@"[PAUSE]" block:^(id sender) {
        if (!_menuExpanded) [self expandMenu];
    }];

    // CCMenu *menu = [CCMenu menuWithItems:_scoreLabel, reset, top, nil];
    CCMenu* menu = [CCMenu menuWithItems:_scoreLabel, menuLabel, nil];
	[menu alignItemsVertically];
    
	[menu setPosition:ccp(_winSize.width/2, _winSize.height-50)];
	
	[self addChild: menu z:1];
    
}

- (void)expandMenu
{
    _menuExpanded = YES;
    [_delegate pauseWorkLayer];
    CCLayerColor* bg = [CCLayerColor layerWithColor:ccc4(0, 0 , 0, 150)];
    [self addChild:bg z:10];
    
    CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"[RESTART]" block:^(id sender){
        [_delegate resetButtonPushed];
    }];
    
    CCMenuItemLabel *top = [CCMenuItemFont itemWithString:@"[TOP]" block:^(id sender) {
        [_delegate backToIntroLayer];
    }];
    
    CCMenuItemLabel *resume = [CCMenuItemFont itemWithString:@"[UNPAUSE]" block:^(id sender) {
        _menuExpanded = NO;
        [_delegate resumeWorkLayer];
        [bg removeFromParent];
    }];
    
    CCMenu* menu = [CCMenu menuWithItems:resume, reset, top, nil];

    [menu alignItemsVerticallyWithPadding:kPauseVerticalPadding];
    [bg addChild:menu z:11];

}

- (void)addDango{
    // Samurai Life
    for (int i = 0; i < 3; i++) {
        [_lifeDangos addObject:[self createDangoSpriteAt:(i+1) * 30]];
    }

    for (CCSprite* dango in _lifeDangos) {
        [self addChild: dango];
    }
}

- (CCSprite *) createDangoSpriteAt: (float)X
{
    CCSprite* ret = [CCSprite spriteWithFile:@"dango.gif"];
    ret.scale = 64 / ret.contentSize.width;
    ret.position = ccp(X, _winSize.height - 30);
    return ret;
}

- (CCMenuItemLabel*) labelWithInteger:(int)i
{
    NSString* tmpstr = [NSString stringWithFormat:@"%d", i];
    CCMenuItemLabel* lbl = [CCMenuItemFont itemWithString:tmpstr];
    return lbl;
}

- (void)update: (ccTime)dt
{
    [super update:dt];
    [self updateLabels];
}

- (void)updateLabels
{
    NSString* tmp = [NSString stringWithFormat:@"%d", _score];
    [_scoreLabel setString:tmp];
    
    // 残機表示
    for (int i=0; i<3; i++) {
        if (_life >= i+1) {
            ((CCSprite*)_lifeDangos[i]).visible = YES;
        } else {
            ((CCSprite*)_lifeDangos[i]).visible = NO;
        }
    }
}


@end
