//
//  Enemy.h
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Box2D.h"
#import "CCPhysicsSprite.h"
#import "Projectile.h"
#import "Define.h"

@class Enemy;

@protocol EnemyProtocol
-(void) enemyDied:(Enemy*)enemy;
@end

@interface Enemy : CCPhysicsSprite
{
    ccTime _curTime;
    int _eventIndex;
}

@property(nonatomic, strong) NSString* name;
@property(nonatomic, assign) b2World* world;
@property (nonatomic, strong) id<ProjectileProtocol,EnemyProtocol> delegate;
@property (nonatomic, strong) NSArray* events;
@property(nonatomic, assign) int hp;

+ (Enemy*)enemyWithName:(NSString*)name;
- (void)initBodyWithWorld:(b2World*)world at:(CGPoint)point;
- (void)damaged;

@end

