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
#import "SimpleAudioEngine.h"
#include <vector.h>
@class Enemy;

@protocol EnemyProtocol
-(void) enemyDied:(Enemy*)enemy;
-(void) enemyVanished:(Enemy*)enemy;
@end

@interface Enemy : CCPhysicsSprite
{
    int _eventIndex;
    std::vector<b2Body*> _bodies;
    
    int _mutekiState;
    ccTime _mutekiWaiting;
    CGFloat _mutekiPosX;
    CGPoint _initPos;
}

@property(nonatomic, assign) ccTime curTime;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, assign) b2World* world;
@property (nonatomic, strong) id<ProjectileProtocol,EnemyProtocol> delegate;
@property (nonatomic, strong) NSArray* events;
@property(nonatomic, assign) int hp;
@property(nonatomic, assign)int score;
@property(nonatomic, assign) b2Body* mainBody;// 真ん中になりそうなbody 血が出る

+ (Enemy*)enemyWithName:(NSString*)name;
- (void)initBodyWithWorld:(b2World*)world at:(CGPoint)point;
- (void)damaged;
- (int) bodiesCount;
- (b2Body*)getBodyAt:(NSInteger)index;
- (BOOL)isEarthquaking;
- (void)updateMuteki:(ccTime)delta;
- (BOOL)isMuteki;
- (void)checkOutOfScreen;

@end

