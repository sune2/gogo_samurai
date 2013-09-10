//
//  Ninja.m
//  samurai
//
//  Created by CA2015 on 13/09/06.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Ninja.h"
#import "GB2ShapeCache.h"

#define kJointAnchorPosX 46.53/32
#define kJointAnchorPosY 68.89/32

@implementation Ninja

+ (Ninja*)ninja {
    Ninja* res = (Ninja*)[super enemyWithName:@"ninja1"];
    res.scale = 88.0 / res.textureRect.size.width;
    res.arm = [CCSprite spriteWithFile:@"ninja2.png"];
    [res addChild:res.arm z:-3];
    return res;
}

- (void)initBodyWithWorld:(b2World *)world at:(CGPoint)point {
    [super initBodyWithWorld:world at:point];

    // 体
    b2BodyDef armDef;
    armDef.type = b2_dynamicBody;
    armDef.position.Set(point.x/self.PTMRatio, point.y/self.PTMRatio);

    _armBody = world->CreateBody(&armDef);

    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_armBody forShapeName:@"ninja2"];
    [_arm setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"ninja2"]];

    b2RevoluteJointDef jointDef;
    jointDef.Initialize(self.b2Body, _armBody, b2Vec2(self.position.x/self.PTMRatio+kJointAnchorPosX,
                                                         self.position.y/self.PTMRatio+kJointAnchorPosY));

    _joint = (b2RevoluteJoint*)world->CreateJoint(&jointDef);

    _joint->EnableLimit(YES);
    _joint->SetLimits(CC_DEGREES_TO_RADIANS(-80.0), CC_DEGREES_TO_RADIANS(-80.0));

}

- (BOOL)canShuriken {
    return _shurikenState == 0;
}
- (void)makeShuriken {
    if ([self canShuriken]) {
        _shurikenState = 1;
    }
}

- (void)updateShuriken:(ccTime)delta {
    switch (_shurikenState) {
        case 1:
        {
            _joint->SetLimits(CC_DEGREES_TO_RADIANS(-80.0), CC_DEGREES_TO_RADIANS(30.0));
//            _armBody->ApplyAngularImpulse(-10);
            _waiting  = 1;
            _shurikenState = 2;
        }
            break;
        case 2:
        {
            _armBody->SetAngularVelocity(10);
            _waiting -= delta;
//            if (_waiting < 0) {
            if (_armBody->GetAngle() > CC_DEGREES_TO_RADIANS(-20.0)) {
                _joint->SetLimits(CC_DEGREES_TO_RADIANS(-80.0), CC_DEGREES_TO_RADIANS(-80.0));
                _shurikenState = 3;
            }
        }
            break;
        case 3:
        {
            Projectile* shuriken = [self makeBullet];
            [self.delegate generatedProjectile:shuriken];

            _shurikenState = 4;
            _waiting = 1;
        }
            break;
        case 4:
        {
            _waiting -= delta;
            if (_waiting < 0) {
                _shurikenState = 0;
            }
        }
        default:
            break;
    }
}

- (Projectile*)makeBullet {
    Projectile* shuriken = [Projectile projectileWithName:@"shuriken"];
    [shuriken initBodyWithWorld:self.world at:ccp(self.position.x, self.position.y+50)];
    shuriken.scale = self.scale;
    shuriken.linearVelocity = b2Vec2(-10,0);
    shuriken.angularVelocity = 10;
    return shuriken;
}

- (void)update:(ccTime)delta {
    _curTime += delta;
    
    [self updateShuriken:delta];

    b2Vec2 pos = self.b2Body->GetPosition();
    if (pos.y < 0) {
        self.b2Body->SetLinearVelocity(b2Vec2(self.b2Body->GetLinearVelocity().x, 0));
        b2Vec2 tmp = b2Vec2(pos.x,0) - self.b2Body->GetPosition();
        self.b2Body->SetTransform(b2Vec2(pos.x,0), self.b2Body->GetAngle());
        self.armBody->SetTransform(self.armBody->GetPosition()+tmp, self.armBody->GetAngle());
    }

    // 体の位置
    b2Body* b = _armBody;
    _arm.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
    _arm.position = ccp((b->GetPosition().x*self.PTMRatio - self.position.x)/self.scale,
                           (b->GetPosition().y*self.PTMRatio - self.position.y)/self.scale);

    // イベント処理
    while(_eventIndex < self.events.count &&
          [self.events[_eventIndex][@"time"] floatValue] < _curTime) {
        NSString *command = self.events[_eventIndex][@"name"];
        if ([command isEqualToString:@"shuriken"]) {
            [self makeShuriken];
        }
        _eventIndex++;
    }
}

- (void)removeFromParent {
    [super removeFromParent];
    self.world->DestroyBody(_armBody);
}

@end
