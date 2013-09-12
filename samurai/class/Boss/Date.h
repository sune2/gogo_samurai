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
#import "Define.h"
#import "Rikishi.h"
#import "Kakashi.h"
#import "Ninja.h"

@protocol DateDelegate

- (void)dateAddEnemey:(Enemy*)enemy;

@end

@interface Date : Enemy
{
    int _earthquakeState;
    int _gankoState;
    ccTime _waiting;
    int _repNum;
    
    ccTime _shokanWaiting;
    
    CCSprite* _yellowMoon;
    
}

@property (nonatomic, strong) CCSprite* karada;
@property (nonatomic, assign) b2Body* karadaBody;
@property (nonatomic, assign) Samurai* samurai;
@property (nonatomic, assign) Difficulty difficulty;
@property(nonatomic, strong) id<ProjectileProtocol,EnemyProtocol,DateDelegate> delegate;

+ (Date*)date;
+ (Date*)dateWithParams:(NSDictionary*)params;

- (BOOL)canGanko;
- (void)makeGanko;
- (BOOL)canEarthquake;
- (void)makeEarthquake;
- (BOOL)isEarthquaking;

@end
