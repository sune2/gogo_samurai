
//
//  GameoverLayer.m
//  samurai
//
//  Created by CA2015 on 13/09/09.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "GameoverLayer.h"

@implementation GameoverLayer

- (id) initWithScore: (int)score result:(BOOL)win
{
    self = [super init];
    if (self) {
        self.touchEnabled = YES;
        _winSize = [[CCDirector sharedDirector] winSize];
        _viewController = [[UIViewController alloc] init];
        _win = win;
        _score = score;
        _shareButtonPushed = NO;


//        NSString* scoreStr = [NSString stringWithFormat:@"Score: %d", score];
//        CCMenuItemLabel* scoreLabel = [CCMenuItemFont itemWithString:scoreStr];
//        CCMenu* scoreMenu = [CCMenu menuWithItems:scoreLabel, nil];
//        scoreMenu.position = ccp(_winSize.width * 3 / 4, _winSize.height / 2);
        
//        [self addChild:scoreMenu];
        [self createResultMenu];
        [self createBackMenu];
        [self manageRanking];
    }
    return self;
}

+ (id) nodeWithScore: (int)score result:(BOOL)win
{
    return [[[self alloc] initWithScore:score result:win] autorelease];
}

- (void) manageRanking
{
//    _path = [[NSBundle mainBundle] pathForResource:@"score" ofType:@"plist"];
//    _ranking = [[NSMutableArray alloc] initWithContentsOfFile:_path];
    
    _ud = [NSUserDefaults standardUserDefaults];
    _ranking = [[_ud arrayForKey:@"Rank"] mutableCopy];
    
    NSMutableDictionary* dict = [@{
                                 @"score": [NSNumber numberWithInt:_score],
                                 @"name": @"CyberAgent",
                                 @"new": [NSNumber numberWithBool:YES]
                                 } mutableCopy];
//    [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                          [NSNumber numberWithInt:_score], @"score",
//                          @"CyberAgent", @"name",
//                          [NSNumber numberWithBool:YES], @"new",
//                          nil];
    
    [_ranking addObject:dict];
    NSSortDescriptor* scoreSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score"
                                                                          ascending:NO];
    _ranking = (NSMutableArray*)[_ranking sortedArrayUsingDescriptors:@[scoreSortDescriptor]];
    
    
    NSMutableArray* tmp = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_ranking count]; i++) {
        CCMenuItemFont* label = [self rankersScore:i];
        [tmp addObject:label];
    }
    CCMenu* scoreMenu = [CCMenu menuWithArray:tmp];
    [scoreMenu alignItemsVertically];
    [scoreMenu setPosition:ccp(_winSize.width * 1 / 4, _winSize.height/2)];
    
    [self addChild:scoreMenu];
    
    [self saveScore: _ranking];
    
}

- (void)saveScore: (NSArray *)arr
{
    NSMutableArray* tmp = [[NSMutableArray alloc] init];
    NSMutableArray* slicedArr = [[arr subarrayWithRange:NSMakeRange(0, 5)] mutableCopy];
    for (NSDictionary* d in slicedArr) {
        NSMutableDictionary* md = [d mutableCopy];
        [md setObject:[NSNumber numberWithBool:NO] forKey:@"new"];
        [tmp addObject:md];
    }
    [_ud setObject:tmp forKey:@"Rank"];
    [_ud synchronize];
    // [tmp writeToFile:_path atomically:YES];
}

- (CCMenuItemFont *)rankersScore: (int)rank
{
    // rankは0-origin
    NSDictionary* sDict = [_ranking objectAtIndex:rank];
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

- (void)createResultMenu
{
    NSString* result = _win ? @"WIN" : @"LOSE";
    CCMenuItemFont *goLabel = [CCMenuItemFont itemWithString:result];
    [goLabel setFontSize:30];
    [goLabel setColor:ccORANGE];
    // goLabel.isEnabled = NO;
    CCMenu* gameover = [CCMenu menuWithItems:goLabel, nil];
    gameover.position = ccp(_winSize.width/2, _winSize.height - 40);
    
    [self addChild:gameover];
    
}

- (void) createBackMenu
{
    
    // Reset Button
    CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"[RESTART]" block:^(id sender){
        [_delegate resetButtonPushed];
    }];
    
    CCMenuItemLabel *top = [CCMenuItemFont itemWithString:@"[TOP]" block:^(id sender) {
        [_delegate backToIntroLayer];
    }];
    
    CCMenuItemLabel *share = [CCMenuItemFont itemWithString:@"[SHARE]" block:^(id sender) {
        if (!_shareButtonPushed && [self iosVersionUpperThan6]) {
            [self createShareMenu];
            _shareButtonPushed = YES;
        }
    }];

    
    CCMenu *menu = [CCMenu menuWithItems:reset, top, share, nil];
    [menu alignItemsVertically];
    [menu setPosition:ccp(_winSize.width * 3/4, _winSize.height * 2/4)];
    [self addChild:menu];
}

- (void) createShareMenu
{

    CCMenuItemLabel* twitter = [CCMenuItemFont itemWithString:@"[Twitter]" target:self selector:@selector(postToSNS:)];
    twitter.tag = 100;
    CCMenuItemLabel* facebook = [CCMenuItemFont itemWithString:@"[facebook]" target:self selector:@selector(postToSNS:)];
    facebook.tag = 101;

    CCMenu *shareMenu = [CCMenu menuWithItems:twitter, facebook, nil];
    [shareMenu alignItemsVertically];
    [shareMenu setPosition:ccp(_winSize.width * 3/4, _winSize.height * 1/4)];
    [self addChild:shareMenu];

}

- (BOOL)iosVersionUpperThan6
{
    return [[[UIDevice currentDevice] systemVersion] intValue] >= 6.0;
}

- (void) postToSNS:(id)sender
{
    if ([self iosVersionUpperThan6]){
        
        NSString* serviceType;
        CCMenuItemImage *itemSelected = (CCMenuItemImage*)sender;
        int typeIndex = itemSelected.tag;
        
        switch (typeIndex) {
            case 100:
                serviceType = SLServiceTypeTwitter;
                CCLOG(@"twitter");
                break;
                
            case 101:
                serviceType = SLServiceTypeFacebook;
                CCLOG(@"facebook");
                break;
                
        }
        
        SLComposeViewController *composeViewController = [SLComposeViewController
                                                          composeViewControllerForServiceType:serviceType];
        
        NSString* rstr = _win ? @"Samuraiは戦に勝利しました！" : @"Samuraiは力尽きました。";
        NSString* sstr = [NSString stringWithFormat:@"武功%d #gogo_samurai", _score];
        rstr =[rstr stringByAppendingString:sstr];
        [composeViewController setInitialText:rstr];

        //cocos2d対応
        [[[CCDirector sharedDirector]parentViewController]  presentViewController:composeViewController animated:NO completion:nil];
    }
}
@end
