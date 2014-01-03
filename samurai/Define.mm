//
//  Define.m
//  samurai
//
//  Created by CA2015 on 13/09/10.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Define.h"

BOOL isSpriteEnemy(CCSprite* sprite) {
    return sprite.tag == SpriteTagZako || sprite.tag == SpriteTagBoss;
}

BOOL isOutOfScreen(CGRect rect) {
    CGSize _windowSize = [CCDirector sharedDirector].winSize;
    CGPoint pos = rect.origin;
    CGSize size = rect.size;
    BOOL res = pos.x < -size.width - 20 ||
    pos.y < -size.height - 20 ||
    _windowSize.width + 20 < pos.x ||
    _windowSize.height + 20 < pos.y;
    return res;
}

NSString* difficultyStr(Difficulty diff) {
    NSString* res;
    if (diff == DifficultyEasy) {
        res =  @"Easy";
    } else if (diff == DifficultyNormal) {
        res = @"Normal";
    } else if (diff == DifficultyHard) {
        res = @"Hard";
    }
    return res;
}

ccColor3B difficultyColor(Difficulty diff) {
    ccColor3B res;
    if (diff == DifficultyEasy) {
        res = kEasyColor;
    } else if (diff == DifficultyNormal) {
        res = kNormalColor;
    } else if (diff == DifficultyHard) {
        res = kHardColor;
    }
    return res;
}

CGSize resizeForAd(CGSize size) {
    return CGSizeMake(size.width, size.height - kAdHeight);
}