//
//  Enemy.mm
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Enemy.h"
#import "Define.h"
#import "GB2ShapeCache.h"
#import "MyParticle.h"

@implementation Enemy

+ (Enemy*)enemyWithName:(NSString *)name {
    Enemy *res = [super spriteWithFile:[NSString stringWithFormat:@"%@.png", name]];
//    res.scale = 91.0 / res.textureRect.size.width;
    [res setPTMRatio:PTM_RATIO];
    res.name = name;
    res.tag = SpriteTagZako;
    res.hp = 1;
    return res;
}

- (void)initBodyWithWorld:(b2World *)world at:(CGPoint)point {
    self.world = world;
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(point.x/self.PTMRatio,point.y/self.PTMRatio);
    bodyDef.fixedRotation = YES;

	b2Body *body = world->CreateBody(&bodyDef);

    body->SetUserData(self);
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:self.name];
    [self setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:self.name]];

    [self setB2Body:body];
    [self scheduleUpdate];
}

- (void)update:(ccTime)delta {
    b2Vec2 pos = self.b2Body->GetPosition();
    if (pos.y < 0) {
        self.b2Body->SetLinearVelocity(b2Vec2(self.b2Body->GetLinearVelocity().x, 0));
        // ジョイントで何かくっついたりしていてやばそうならくっついているものも同じだけ動かしてやる
        self.b2Body->SetTransform(b2Vec2(pos.x,0), self.b2Body->GetAngle());
    }
}

- (Projectile*)makeBullet {
    return nil;
}

- (void)removeFromParent {
    [super removeFromParent];
    self.world->DestroyBody(self.b2Body);
}

- (void)damaged {
    CCParticleSystemQuad* blood = [MyParticle particleEnemyBlood];
    blood.position = ccp(self.b2Body->GetWorldCenter().x*PTM_RATIO,
                         self.b2Body->GetWorldCenter().y*PTM_RATIO);
    [[self parent] addChild:blood];
    self.hp--;
    if (self.hp == 0) {
        [self.delegate enemyDied:self];
    }
}

@end
