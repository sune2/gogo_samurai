//
//  ScoreLayer.m
//  samurai
//
//  Created by CA2015 on 13/09/09.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "ScoreLayer.h"


@implementation ScoreLayer

- (id)init
{
    self = [super init];
    if (self) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        
        NSString* tStr = [NSString stringWithFormat:@"Bu-koh"];
        CCMenuItemFont* tLabel = [CCMenuItemFont itemWithString:tStr];
        [tLabel setFontSize:30];
        // [tLabel setFontName:@"HiraMinProN-W3"];
        CCMenu* tMenu = [CCMenu menuWithItems:tLabel, nil];
        [tMenu setPosition:ccp(winSize.width / 2, winSize.height - 30)];
        
        [self addChild:tMenu];
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"score" ofType:@"plist"];
        _scores = [[NSArray alloc] initWithContentsOfFile:path];
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [_scores count]; i++) {
            CCMenuItemFont* tmp = [self rankersScore:i];
            [arr addObject:tmp];
        }
        CCMenu* menu = [CCMenu menuWithArray:arr];
        menu.enabled = NO;
        [menu alignItemsVertically];
        
        [self addChild:menu];
        
        NSString* backStr = [NSString stringWithFormat:@"[Modoru]"];
        CCMenuItemFont* backLabel = [CCMenuItemFont itemWithString:backStr block:^(id sender) {
            [_delegate backToIntroLayer];
        }];
        CCMenu* backMenu = [CCMenu menuWithItems:backLabel, nil];
        backMenu.position = ccp(400, 20);
        [self addChild:backMenu];
        
    }
    return self;
}

- (CCMenuItemFont *) rankersScore: (int) i
{
    NSString* name = [[_scores objectAtIndex:i] objectForKey:@"name"];
    NSString* score = [[_scores objectAtIndex:i] objectForKey:@"score"];
    NSString* str = [NSString stringWithFormat:@"%@: %@", name, score];
    CCMenuItemFont* ret = [CCMenuItemFont itemWithString:str];
    return ret;
}

@end
