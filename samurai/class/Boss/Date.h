//
//  Date.h
//  samurai
//
//  Created by CA2015 on 13/09/10.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Enemy.h"
#import "Projectile.h"
#import "Samurai.h"

@interface Date : Enemy
{
    int _earthquakeState;
    int _gankoState;
    ccTime _waiting;
    int _repNum;
    int _mutekiState;
    ccTime _mutekiWaiting;
    CGFloat _mutekiPosX;
    CGPoint _initPos;
}

@property (nonatomic, strong) CCSprite* karada;
@property (nonatomic, assign) b2Body* karadaBody;
@property (nonatomic, assign) Samurai* samurai;

+ (Date*)date;

- (BOOL)canGanko;
- (void)makeGankoWithSamuraiPos:(CGPoint*)pos;
- (BOOL)canEarthquake;
- (void)makeEarthquake;
- (BOOL)isEarthquaking;

@end
