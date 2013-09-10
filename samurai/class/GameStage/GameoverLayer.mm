
//
//  GameoverLayer.m
//  samurai
//
//  Created by CA2015 on 13/09/09.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "GameoverLayer.h"

@implementation GameoverLayer

- (id) initWithScore: (int)score
{
    self = [super init];
    if (self) {
        self.touchEnabled = YES;
        _winSize = [[CCDirector sharedDirector] winSize];

        NSString* scoreStr = [NSString stringWithFormat:@"Score: %d", score];
        CCMenuItemLabel* scoreLabel = [CCMenuItemFont itemWithString:scoreStr];
        CCMenu* scoreMenu = [CCMenu menuWithItems:scoreLabel, nil];
        scoreMenu.position = ccp(_winSize.width / 2, _winSize.height / 2);
        
        [self addChild:scoreMenu];
        
        [self createBackMenu];
    }
    return self;
}

+ (id) nodeWithScore: (int)score
{
    return [[[self alloc] initWithScore:score] autorelease];
}

- (void) createBackMenu
{
    // Reset Button
    CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
        [_delegate resetButtonPushed];
    }];
    
    CCMenuItemLabel *top = [CCMenuItemFont itemWithString:@"Top" block:^(id sender) {
        [_delegate backToIntroLayer];
    }];
    
    
    CCMenu *menu = [CCMenu menuWithItems:reset, top, nil];
    [menu alignItemsHorizontally s];
    [menu setPosition:ccp(_winSize.width/2, _winSize.height/2 - 40)];
    [self addChild:menu];
    
}

@end
