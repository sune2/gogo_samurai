//
//  Samurai.m
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Samurai.h"
#import "../Define.h"
#import "GB2ShapeCache.h"
#import "MyParticle.h"

#define kKatanaAnchorPosX 2.1
#define kKatanaAnchorPosY 1.7

@implementation Samurai

+ (Samurai*)samurai {
    Samurai *res = [super spriteWithFile:@"samurai.png"];
    
    res.scale = 116.0 / res.textureRect.size.width;
    [res setPTMRatio:PTM_RATIO];
    res.katana = [CCSprite spriteWithFile:@"katana.png"];
//    res.katana.scale = 116.0 / res.katana.textureRect.size.width;
    [res addChild:res.katana];
    res.katana.position = CGPointMake(kKatanaAnchorPosX*PTM_RATIO/res.scale,
                                      kKatanaAnchorPosY*PTM_RATIO/res.scale);

    res.hp = 3;
    res.tag = SpriteTagSamurai;
    return res;
}

- (void)initBodyWithWorld:(b2World *)world at:(CGPoint)point {
    // サムライの体
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(point.x/self.PTMRatio,point.y/self.PTMRatio);
    bodyDef.fixedRotation = YES;
    
	b2Body *body = world->CreateBody(&bodyDef);

    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:@"samurai"];
    [self setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"samurai"]];
    
    body->SetUserData(self);

    [self setB2Body:body];
    
    // 刀
    b2BodyDef katanaDef;
    katanaDef.type = b2_dynamicBody;
    katanaDef.position.Set(point.x/self.PTMRatio+kKatanaAnchorPosX, point.y/self.PTMRatio+kKatanaAnchorPosY);

    _katanaBody = world->CreateBody(&katanaDef);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_katanaBody forShapeName:@"katana"];
    [_katana setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"katana"]];
    
    b2RevoluteJointDef jointDef;
//    jointDef.Initialize(body, _katanaBody, b2Vec2(_katana.position.x/self.PTMRatio,
//                                                  _katana.position.y/self.PTMRatio));
    jointDef.Initialize(body, _katanaBody, b2Vec2(katanaDef.position.x,
                                                  katanaDef.position.y));
    
    world->CreateJoint(&jointDef);


    _initPos = point;
}

- (BOOL)canDash {
    if (_counterCounter) return NO;
    if (self.position.x > _initPos.x) return NO;
    return YES;
}

- (BOOL)onGround {
    for (b2ContactEdge* contactEdge = self.b2Body->GetContactList(); contactEdge;
         contactEdge = contactEdge->next) {
        b2Contact* contact = contactEdge->contact;
        if (contact->IsTouching()) {
            
            b2Fixture *fixture = contact->GetFixtureA();
            CCNode* node = (CCNode*)fixture->GetUserData();
            if (node.tag == 10) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL) isDashing {
    return _dashCounter > 0;
}

- (BOOL)isCountering {
    return _counterCounter > 0;
}

- (BOOL)canJump {
    if (self.position.x > _initPos.x) return NO;
    if (_counterCounter) return NO;
    if (_counterCounter) return NO;
    return [self onGround];
}

- (BOOL)canCounter {
    return [self canJump];
}


- (void)jump {
    if ([self canJump]) {
        self.b2Body->ApplyLinearImpulse(b2Vec2(0,50), self.b2Body->GetWorldCenter());
    }
}

- (void)dashSlice {
    if ([self canDash]) {
        self.b2Body->SetLinearVelocity(b2Vec2(50,self.b2Body->GetLinearVelocity().y));
        _dashCounter = 30;
//        self.position = ccp(self.position.x + 200, self.position.y);
    }
}

- (void)counter {
    if ([self canCounter]) {
        _katanaBody->SetAngularVelocity(40);
        _counterCounter = 10;
    }
}

- (void)update:(ccTime)delta {
    if (_dashCounter >= 1) {
        CCParticleSystemQuad* particle = [MyParticle particleDash];
        particle.position = ccp(_katanaBody->GetPosition().x*PTM_RATIO,
                                _katanaBody->GetPosition().y*PTM_RATIO);
        [[self parent] addChild:particle z:3];


        if (self.position.x > _initPos.x + 200) {
            self.position = ccp(_initPos.x + 200, self.position.y);
            _dashCounter = 1;
        }

        _dashCounter--;
        if (_dashCounter == 0) {
            self.b2Body->SetLinearVelocity(b2Vec2(0,0));
        }

    }
    if (_counterCounter >= 1) {        
        _counterCounter--;
        if (_counterCounter == 0){
            _katanaBody->SetAngularVelocity(0);
            _katanaBody->SetTransform(_katanaBody->GetPosition(), 0);
        }
    }
    
    if (self.position.x < _initPos.x) {
        // 戻り過ぎ
    } else if ((self.position.x > _initPos.x) && (_dashCounter == 0)) {
        self.b2Body->SetLinearVelocity(b2Vec2(0,self.b2Body->GetLinearVelocity().y));
        if ([self onGround]) {
            self.position = ccp(self.position.x-5, self.position.y);
        }
    }
    
    // 刀の位置
    b2Body* b = _katanaBody;
    _katana.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
    
}

@end
