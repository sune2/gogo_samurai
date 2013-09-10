
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



//        NSString* scoreStr = [NSString stringWithFormat:@"Score: %d", score];
//        CCMenuItemLabel* scoreLabel = [CCMenuItemFont itemWithString:scoreStr];
//        CCMenu* scoreMenu = [CCMenu menuWithItems:scoreLabel, nil];
//        scoreMenu.position = ccp(_winSize.width * 3 / 4, _winSize.height / 2);
        
//        [self addChild:scoreMenu];
        [self createBackMenu];
        [self manageRanking:score];
    }
    return self;
}

+ (id) nodeWithScore: (int)score
{
    return [[[self alloc] initWithScore:score] autorelease];
}

- (void) manageRanking: (int)score
{
    _path = [[NSBundle mainBundle] pathForResource:@"score" ofType:@"plist"];
    _scores = [[NSMutableArray alloc] initWithContentsOfFile:_path];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:score], @"score",
                          @"CyberAgent", @"name",
                          [NSNumber numberWithBool:YES], @"new",
                          nil];
    
    [_scores addObject:dict];
    NSSortDescriptor* scoreSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score"
                                                                          ascending:NO];
    _scores = (NSMutableArray*)[_scores sortedArrayUsingDescriptors:@[scoreSortDescriptor]];
    
    
    NSMutableArray* tmp = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_scores count]; i++) {
        CCMenuItemFont* label = [self rankersScore:i];
        [tmp addObject:label];
    }
    CCMenu* scoreMenu = [CCMenu menuWithArray:tmp];
    [scoreMenu alignItemsVertically];
    [scoreMenu setPosition:ccp(_winSize.width * 1 / 4, _winSize.height/2)];
    
    [self addChild:scoreMenu];
    
    [self saveScore: _scores];
    
}

- (void)saveScore: (NSArray *)arr
{
    NSMutableArray* tmp = [[NSMutableArray alloc] init];
    NSMutableArray* slicedArr = (NSMutableArray*)[arr subarrayWithRange:NSMakeRange(0, 5)];
    for (NSDictionary* d in slicedArr) {
        NSMutableDictionary* md = (NSMutableDictionary*)d;
        [md setObject:[NSNumber numberWithBool:NO] forKey:@"new"];
        [tmp addObject:md];
    }
    [tmp writeToFile:_path atomically:YES];
}

- (CCMenuItemFont *)rankersScore: (int)rank
{
    // rankは0-origin
    NSDictionary* sDict = [_scores objectAtIndex:rank];
    NSString* name = [sDict objectForKey:@"name"];
    NSString* score = [sDict objectForKey:@"score"];
    NSString* str = [NSString stringWithFormat:@"%d. %@: %@", rank+1, name, score];
    CCMenuItemFont* ret = [CCMenuItemFont itemWithString:str];
    
    if ([[sDict objectForKey:@"new"] boolValue]) {
        ret.color = ccYELLOW;
    }
    
    if (rank == 5) {
        ret.color = ccc3(150,150,150);
    }
    
    return ret;
}

- (void) createBackMenu
{
    CCMenuItemFont *goLabel = [CCMenuItemFont itemWithString:@"LOSE"];
    [goLabel setFontSize:30];
    [goLabel setColor:ccORANGE];
    // goLabel.isEnabled = NO;
    CCMenu* gameover = [CCMenu menuWithItems:goLabel, nil];
    gameover.position = ccp(_winSize.width/2, _winSize.height - 40);

    [self addChild:gameover];
    
    
    // Reset Button
    CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"[RESTART]" block:^(id sender){
        [_delegate resetButtonPushed];
    }];
    
    CCMenuItemLabel *top = [CCMenuItemFont itemWithString:@"[TOP]" block:^(id sender) {
        [_delegate backToIntroLayer];
    }];
    
    CCMenuItemLabel *share = [CCMenuItemFont itemWithString:@"[SHARE]" block:^(id sender) {
        [self createShareMenu];
    }];

    
    CCMenu *menu = [CCMenu menuWithItems:reset, top, share, nil];
    [menu alignItemsVertically];
    [menu setPosition:ccp(_winSize.width * 3/4, _winSize.height * 2/4)];
    [self addChild:menu];
}

- (void) createShareMenu
{
    // Reset Button
    CCMenuItemLabel *twitter = [CCMenuItemFont itemWithString:@"[Twitter]" block:^(id sender){
        
    }];
    
    CCMenuItemLabel *facebook = [CCMenuItemFont itemWithString:@"[facebook]" block:^(id sender) {
        
    }];
    
    
    CCMenu *shareMenu = [CCMenu menuWithItems:twitter, facebook, nil];
    [shareMenu alignItemsVertically];
    [shareMenu setPosition:ccp(_winSize.width * 3/4, _winSize.height * 1/4)];
    [self addChild:shareMenu];

}

@end
