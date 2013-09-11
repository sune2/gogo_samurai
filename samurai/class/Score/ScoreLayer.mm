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
    menu.position = ccp(_winSize.width/2, _winSize.height/2 - 30);
    [menu alignItemsVertically];
    
    [self addChild:menu];
    CCLOG(@"%fx%f", menu.contentSize.height, menu.contentSize.width);
}

- (void)addMenu
{
    NSString* backStr = @"[BACK]";
    CCMenuItemFont* backLabel = [CCMenuItemFont itemWithString:backStr block:^(id sender) {
        [_delegate backToIntroLayer];
    }];
    
    CCMenu* menu = [CCMenu menuWithItems:backLabel, nil];
    menu.position = ccp(_winSize.width/2, 20);
    [self addChild:menu];
}

- (void)addTextField
{
    NSString* renameStr = @"Samurai Name :";
    CCMenuItemFont* renameLabel = [CCMenuItemFont itemWithString:renameStr];
    CCMenu* menu = [CCMenu menuWithItems:renameLabel, nil];
    menu.anchorPoint = ccp(1.0f, 0.5f);
    menu.position = ccp(_winSize.width/2 - 80, _winSize.height - 80);
    [self addChild:menu];
    
    NSString* currentName = [_ud objectForKey:@"Name"];
    
    _tf = [[UITextField alloc] init];
    _tf.text = currentName;
    _tf.backgroundColor = [UIColor whiteColor];
    _tf.borderStyle = UITextBorderStyleRoundedRect;
    _tf.returnKeyType = UIReturnKeyDefault;
    _tf.delegate = self;
    
//    [_tf addTarget:self
//           action:@selector(saveSamuraiName)
// forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _tfWrapper = [CCUIViewWrapper wrapperForUIView:_tf];
    _tfWrapper.contentSize = CGSizeMake(150,30);
    _tfWrapper.anchorPoint = CGPointMake(0.5f, 0.5f);
    _tfWrapper.rotation = 270;
    _tfWrapper.position = ccp(20, _winSize.width / 2 + 170);
    [self addChild:_tfWrapper z:5];
}

- (void) saveSamuraiName:(UITextField*)tf
{
    if (tf.text.length > 10) {
        tf.text = [tf.text substringToIndex:10];
    }
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

-(BOOL)textFieldShouldReturn:(UITextField*)tf{
    [self saveSamuraiName:tf];
    [tf resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int maxInputLength = 10;
    NSMutableString *str = [textField.text mutableCopy];
    [str replaceCharactersInRange:range withString:string];

    if ([str length] > maxInputLength) {
        // ※ここに文字数制限を超えたことを通知する処理を追加
        return NO;
    }
    return YES;
}


- (void)onExit
{
    [super onExit];
    [_tf removeFromSuperview];
    // [_tfWrapper removeFromParentAndCleanup:YES];
}
@end
