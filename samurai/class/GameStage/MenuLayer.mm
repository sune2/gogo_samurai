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
        [self createMenu];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)createMenu
{
    
    // Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Reset Button
    CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
         [_delegate resetButtonPushed];
     }];
    
    // Score
    _scoreLabel = [self labelWithInteger:_score];
    
    // Samurai Life
    for (int i = 0; i < 3; i++) {
        [_lifeDangos addObject:[self createDangoAt:(i+1) * 30]];
    }

    CCMenuItemLabel *top = [CCMenuItemFont itemWithString:@"Top" block:^(id sender) {
        [_delegate backToIntroLayer];
    }];
    

    CCMenu *menu = [CCMenu menuWithItems:_scoreLabel, reset, top, nil];
    
	[menu alignItemsVertically];
    
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height-50)];
	
	[self addChild: menu z:1];
    
    for (CCSprite* dango in _lifeDangos) {
        [self addChild: dango];
    }
}

- (CCSprite *) createDangoAt: (float)X
{
    CCSprite* ret = [CCSprite spriteWithFile:@"dango.gif"];
    ret.scaleX = 0.1;
    ret.scaleY = 0.1;
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
