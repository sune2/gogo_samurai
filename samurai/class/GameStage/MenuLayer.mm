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
    _lifeLabel = [self labelWithInteger:_life];
    
    
    CCMenu *menu = [CCMenu menuWithItems:_scoreLabel, _lifeLabel, reset, nil];
	
	[menu alignItemsVertically];
    
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height-30)];
	
	
	[self addChild: menu z:1];
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
    tmp = [NSString stringWithFormat:@"%d", _life];
    [_lifeLabel setString:tmp];
}


@end
