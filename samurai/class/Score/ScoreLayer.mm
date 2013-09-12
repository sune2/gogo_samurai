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
        
        [self addBackground];
        [self addTitle];
//        [self addRanking];
        [self addMenu];
        [self addTextField];
        [self initScrollLayer];
        
    }
    return self;
}

- (void) initScrollLayer
{
    int pageMax = 3;//ページ数
    CGSize s = [[CCDirector sharedDirector] winSize];
    //ScrollLayer
    ScrollLayer* scroll = [ScrollLayer node];
    scroll.delegate = self;
    [scroll changeContentWidth:s.width*pageMax];
    [self addChild:scroll];
    
    CGFloat width = self.contentSize.width;
    CGFloat height = self.contentSize.height;
    
    //Label
    CCMenu* ranking1 = [self makeRankingWithDifficulty:DifficultyEasy];
    ranking1.position =  ccp( width/2 ,  height/2-30);
    [scroll addScrollChild:ranking1];

    CCMenu* ranking2 = [self makeRankingWithDifficulty:DifficultyNormal];
    ranking2.position =  ccp( width/2+width , height/2-30);
    [scroll addScrollChild:ranking2];

    CCMenu* ranking3 = [self makeRankingWithDifficulty:DifficultyHard];
    ranking3.position =  ccp( width/2+width*2 , height/2-30);
    [scroll addScrollChild:ranking3];
    
    scroll.contentSize = CGSizeMake(100, 300);
}

- (void)scrollPageChanged:(int)page {
    NSString * str;
    if (page == 0) {
        str = @"RANKING - EASY ▷";
    } else if (page == 1) {
        str = @"◁ RANKING - NORMAL ▷";
    } else {
        str = @"◁ RANKING - HARD";
        
    }
    _titleLabel.string = str;
}

- (void)addBackground
{
    CCLayerColor* background = [CCLayerColor layerWithColor:kBackgroundColor];
    [self addChild: background z:-3];
    
    // 月
    CCSprite* moon = [CCSprite spriteWithFile:@"fullmoon.png"];
    moon.position = ccp(440, 250);
    moon.scale = 0.3 * 800 / moon.contentSize.width;
    moon.opacity = 128;
    [self addChild:moon z:-2];
}

- (void)addTitle
{
    _titleLabel = [CCLabelTTF labelWithString:@"Ranking - EASY ▷" fontName:@"Marker Felt" fontSize:30];
    _titleLabel.color = ccc3(0, 255, 200);
    _titleLabel.position = ccp(_winSize.width / 2, _winSize.height - 30);
    
    [self addChild:_titleLabel];
}

- (CCMenu*)makeRankingWithDifficulty: (Difficulty)difficulty
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if (difficulty == DifficultyEasy) {
        _scores = [ud arrayForKey:@"Easy"];
    } else if (difficulty == DifficultyNormal) {
        _scores = [ud arrayForKey:@"Normal"];
    } else {
        _scores = [ud arrayForKey:@"Hard"];
    }
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_scores count]; i++) {
        CCMenuItemLabel* tmp = [CCMenuItemFont itemWithString:[self rankersScore:i]];
        [arr addObject:tmp];
    }
    CCMenu* menu = [CCMenu menuWithArray:arr];
    menu.enabled = NO;
//    menu.position = ccp(_winSize.width/2, _winSize.height/2 - 30);
    [menu alignItemsVertically];

    return menu;
}

- (void)addMenu
{
    NSString* backStr = @"[BACK]";
    CCMenuItemFont* backLabel = [CCMenuItemFont itemWithString:backStr block:^(id sender) {
        [self saveSamuraiName:_tf];
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
    menu.enabled = NO;
    [self addChild:menu];
    
    NSString* currentName = [_ud objectForKey:@"Name"];
    
    _tf = [[UITextField alloc] init];
//    _tf.text = currentName;
    _tf.placeholder = currentName;
    _tf.backgroundColor = [UIColor whiteColor];
    _tf.borderStyle = UITextBorderStyleRoundedRect;
    _tf.returnKeyType = UIReturnKeyDefault;
    _tf.delegate = self;
    _tf.keyboardType = UIKeyboardTypeASCIICapable;
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
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
   
    NSString* newName = (tf.text.length > 0) ? tf.text : _tf.placeholder;
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
    // [self saveSamuraiName:tf];
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
