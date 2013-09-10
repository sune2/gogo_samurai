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