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
        _ud = [NSUserDefaults standardUserDefaults];
        [self addTitle];
        [self addRanking];
        [self addMenu];
        [self addTextField];
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
    [self addTextField];
    
    CCMenu* menu = [CCMenu menuWithItems:backLabel, nil];
    menu.position = ccp(_winSize.width/2, 20);
    [self addChild:menu];
}

- (void)addTextField
{
    NSString* renameStr = @"Samurai Name:";
    CCMenuItemFont* renameLabel = [CCMenuItemFont itemWithString:renameStr];
    NSString* currentName = [_ud objectForKey:@"Name"];

    _tf = [[UITextField alloc] init];
    _tf.text = currentName;
    _tf.backgroundColor = [UIColor whiteColor];
    _tf.borderStyle = UITextBorderStyleBezel;
    _tf.returnKeyType = UIReturnKeyDefault;
    _tf.delegate = self;
    
    [_tf addTarget:self
           action:@selector(saveSamuraiName)
 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    CCUIViewWrapper* tfWrapper = [CCUIViewWrapper wrapperForUIView:_tf];
    tfWrapper.contentSize = CGSizeMake(100,30);
    tfWrapper.rotation = 270;
    tfWrapper.position = ccp(30, _winSize.width/2);
    [self addChild:tfWrapper z:5];
}

- (void) saveSamuraiName:(UITextField*)tf
{
    NSString* newName = tf.text;
    [_ud setObject:newName forKey:@"Name"];
    [_ud synchronize];
}

- (NSString*) rankersScore: (int) i
{
    NSString* name = [[_scores objectAtIndex:i] objectForKey:@"name"];
    NSString* score = [[_scores objectAtIndex:i] objectForKey:@"score"];
    NSString* str = [NSString stringWithFormat:@"%d. %@: %@", i+1, name, score];
    // CCMenuItemFont* ret = [CCMenuItemFont itemWithString:str];
    return str;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)onExit
{
    [super onExit];
    [_tf removeFromSuperview];
}
@end
