
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
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        NSString* scoreStr = [NSString stringWithFormat:@"Score: %d", score];
        CCMenuItemLabel* scoreLabel = [CCMenuItemFont itemWithString:scoreStr];
        CCMenu* scoreMenu = [CCMenu menuWithItems:scoreLabel, nil];
        scoreMenu.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:scoreMenu];
    }
    return self;
}

+ (id) nodeWithScore: (int)score
{
    return [[[self alloc] initWithScore:score] autorelease];
}

@end
