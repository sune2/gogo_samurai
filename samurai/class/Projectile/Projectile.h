//
//  Projectile.h
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "CCPhysicsSprite.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "SimpleAudioEngine.h"


typedef enum {
    ProjectileOwnerSamurai,
    ProjectileOwnerEnemy
} ProjectileOwner;

typedef enum {
    ProjectileTypePhysics = 0, // default
    ProjectileTypeSpecial
} ProjectileType;

@interface Projectile : CCPhysicsSprite
{
    b2Vec2 _initPos;
    b2World* _world;
    ccTime _curTime;
}
@property(nonatomic, strong) NSString* name;
@property(nonatomic, assign) b2Vec2 linearVelocity;
@property(nonatomic, assign) float32 angularVelocity;
@property(nonatomic, assign) ProjectileOwner owner;
@property(nonatomic, assign) ProjectileType type;

+(Projectile*)projectileWithName:(NSString*)name;
- (void)initBodyWithWorld:(b2World *)world at:(CGPoint)point;
- (void)reflect;

@end

@protocol ProjectileProtocol
-(void) generatedProjectile:(Projectile*)projectile;
@end
