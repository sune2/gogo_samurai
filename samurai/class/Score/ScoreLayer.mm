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
        
        _winSize = [[CCDirector sharedDirector] winSize];

        [self addTitle];
        [self addRanking];
        [self addMenu];
        
    }
    return self;
}

- (void)addTitle
{
    NSString* tStr = [NSString stringWithFormat:@"SCORE"];
    CCMenuItemFont* tLabel = [CCMenuItemFont itemWithString:tStr];
    [tLabel setFontSize:30];
    [tLabel setColor:ccc3(0,255,200)];
    // [tLabel setFontName:@"HiraMinProN-W3"];
    CCMenu* tMenu = [CCMenu menuWithItems:tLabel, nil];
    [tMenu setPosition:ccp(_winSize.width / 2, _winSize.height - 30)];
    
    [self addChild:tMenu];
}

- (void)addRanking
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _scores = [ud arrayForKey:@"Rank"];
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_scores count]; i++) {
        CCMenuItemFont* tmp = [CCMenuItemFont itemWithString:[self rankersScore:i]];
        [arr addObject:tmp];
    }
    CCMenu* menu = [CCMenu menuWithArray:arr];
    menu.enabled = NO;
    menu.position = ccp(_winSize.width/2, _winSize.height/2 + 15);
    [menu alignItemsVertically];
    
    [self addChild:menu];

}

- (void)addMenu
{
    NSString* backStr = @"[BACK]";
    CCMenuItemFont* backLabel = [CCMenuItemFont itemWithString:backStr block:^(id sender) {
        [_delegate backToIntroLayer];
    }];
    
    NSString* renameStr = @"Samurai Name:";
    CCMenuItemFont* renameLabel = [CCMenuItemFont itemWithString:renameStr];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* currentName = [ud objectForKey:@"Name"];

    UITextField* tf = [[UITextField alloc] init];
    tf.text = currentName;
    tf.backgroundColor = [UIColor whiteColor];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    
    CCUIViewWrapper* tfWrapper = [CCUIViewWrapper wrapperForUIView:tf];
    tfWrapper.contentSize = CGSizeMake(100,20);
    tfWrapper.position = ccp(100,100);
    tfWrapper.rotation = 270;
//    [self addChild:tfWrapper z:5];
    
    CCLayerColor* hoge = [CCLayerColor layerWithColor:ccc4BFromccc4F(ccc4f(0, 0, 0, 0))];
    [hoge addChild:tfWrapper];
    [self addChild:hoge];
    
    NSString* newName = tf.text;
    
    [ud setObject:newName forKey:@"Name"];
    [ud synchronize];

    
    CCMenu* menu = [CCMenu menuWithItems:renameLabel, backLabel, nil];
    [menu alignItemsVerticallyWithPadding:10];
    menu.position = ccp(_winSize.width/2, 40);
    [self addChild:menu];
}

- (NSString*) rankersScore: (int) i
{
    NSString* name = [[_scores objectAtIndex:i] objectForKey:@"name"];
    NSString* score = [[_scores objectAtIndex:i] objectForKey:@"score"];
    NSString* str = [NSString stringWithFormat:@"%d. %@: %@", i+1, name, score];
    // CCMenuItemFont* ret = [CCMenuItemFont itemWithString:str];
    return str;
}

@end
