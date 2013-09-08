//
//  Boss.m
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Boss.h"
#import "../Define.h"
#import "GB2ShapeCache.h"

@implementation Boss

+ (Boss*)bossWithName:(NSString *)name {
    Boss *res = [super spriteWithFile:[NSString stringWithFormat:@"%@.png", name]];
    res.scale = 91.0 / res.textureRect.size.width;
    [res setPTMRatio:PTM_RATIO];
    res.name = name;
    res.tag = SpriteTagBoss;
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

@end
