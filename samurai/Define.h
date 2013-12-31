//
//  Define.h
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "cocos2d.h"

#define PTM_RATIO 32
#define kGravityPower -30.0
#define kLeftSpeed 5
#define kBackgroundColor ccc4BFromccc4F(ccc4f(0.45,0.45,0.45,1))
#define kMenuVerticalPadding 13
#define kPauseVerticalPadding 25

// color
#define kEasyColor ccc3(204,255,204)
#define kNormalColor ccc3(153,153,255)
#define kHardColor ccc3(255,51,153)

typedef enum {
    SpriteTagSamurai = 1,
    SpriteTagKatana,
    SpriteTagZako,
    SpriteTagProjectile,
    SpriteTagBoss,
    SpriteTagGround
} SpriteTag;

typedef enum {
    DifficultyEasy = 1,
    DifficultyNormal,
    DifficultyHard
} Difficulty;

BOOL isSpriteEnemy(CCSprite* sprite);

BOOL isOutOfScreen(CGRect rect);

