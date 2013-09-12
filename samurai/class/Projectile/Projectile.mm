//
//  Projectile.m
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Projectile.h"
#import "Define.h"
#import "GB2ShapeCache.h"

@implementation Projectile

+ (Projectile*)projectileWithName:(NSString*)name {
    Projectile *res = [super spriteWithFile:[NSString stringWithFormat:@"%@.png", name]];
//    NSLog(@"(%f,%f) (%f,%f)", res.textureRect.size.width, res.textureRect.size.height,
//          res.contentSize.width, res.contentSize.height);
//    res.scale = 116.0 / res.textureRect.size.width;
    [res setPTMRatio:PTM_RATIO];
    res.name = name;
    res.tag = SpriteTagProjectile;
    res.owner = ProjectileOwnerEnemy;
    return res;
}

- (void)initBodyWithWorld:(b2World *)world at:(CGPoint)point {
    _world = world;

	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(point.x/self.PTMRatio,point.y/self.PTMRatio);
    
	b2Body *body = world->CreateBody(&bodyDef);
    body->SetGravityScale(0);
	
    body->SetUserData(self);
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:self.name];
    [self setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:self.name]];
    
    [self setB2Body:body];

    _initPos = body->GetPosition();
    [self scheduleUpdate];
}

- (void)update:(ccTime)delta {
    _curTime += delta;
    self.b2Body->SetAngularVelocity(self.angularVelocity);
//    self.b2Body->SetTransform(_initPos + _curTime * self.linearVelocity, self.b2Body->GetAngle());
        self.b2Body->SetLinearVelocity(self.linearVelocity);
//
//    b2Vec2 pos = self.b2Body->GetPosition();
//    if (pos.y < _initPos.y/PTM_RATIO) {
//        self.b2Body->SetTransform(b2Vec2(pos.x,_initPos.y/PTM_RATIO), self.b2Body->GetAngle());
//    }
    
}
- (void)reflect {
    self.angularVelocity = - self.angularVelocity;
    self.linearVelocity = - self.linearVelocity;
    self.owner = ProjectileOwnerSamurai;
    [[SimpleAudioEngine sharedEngine] playEffect:@"reflect.mp3"];
    
}

- (void)removeFromParent {
    [super removeFromParent];
    _world->DestroyBody(self.b2Body);
}

@end
