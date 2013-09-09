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
    [res addChild:res.katana];
    res.katana.position = CGPointMake(kKatanaAnchorPosX*PTM_RATIO/res.scale,
                                      kKatanaAnchorPosY*PTM_RATIO/res.scale);

    res.hp = 3;
    res.tag = SpriteTagSamurai;
    return res;
}

- (void)initBodyWithWorld:(b2World *)world at:(CGPoint)point {
    _world = world;
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
    jointDef.Initialize(body, _katanaBody, b2Vec2(katanaDef.position.x,
                                                  katanaDef.position.y));
    
    world->CreateJoint(&jointDef);


    _initPos = point;
    [self scheduleUpdate];
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

- (BOOL)isDashing {
    return _dashState == 1;
}

- (BOOL)isCountering {
    return _counterState == 1;
}

- (BOOL)canJump {
    if (_dashState) return NO;
    if (_counterState) return NO;
    return [self onGround];
}

- (BOOL)canCounter {
    return _counterState == 0;
}


- (void)jump {
    if ([self canJump]) {
        self.b2Body->ApplyLinearImpulse(b2Vec2(0,50), self.b2Body->GetWorldCenter());
    }
}

- (void)dashSlice {
    if ([self canDash]) {
        _dashState = 1;
        _dashWaiting = 0.1;
    }
}

- (void)counter {
    if ([self canCounter]) {
        _counterState = 1;
        _counterWaiting = 0.5;
    }
}

- (void)updateDashSlice:(ccTime)delta {
    switch (_dashState) {
        case 1:
        {
            self.b2Body->SetLinearVelocity(b2Vec2(60,self.b2Body->GetLinearVelocity().y));
            
            CCParticleSystemQuad* particle = [MyParticle particleDash];
            particle.position = ccp(_katanaBody->GetPosition().x*PTM_RATIO,
                                    _katanaBody->GetPosition().y*PTM_RATIO);
            [[self parent] addChild:particle z:3];
            
            _dashWaiting -= delta;
            if (_dashWaiting < 0) {
                self.b2Body->SetLinearVelocity(b2Vec2(0,self.b2Body->GetLinearVelocity().y));
                _dashState = 2;
            }
        }
            break;
        case 2:
        {
            self.b2Body->SetLinearVelocity(b2Vec2(0,self.b2Body->GetLinearVelocity().y));
            if ([self onGround]) {
                _dashState = 3;
            }
        }
            break;
        case 3:
        {
            self.b2Body->SetLinearVelocity(b2Vec2(-10,self.b2Body->GetLinearVelocity().y));
            if (self.position.x <= _initPos.x) {
                self.b2Body->SetLinearVelocity(b2Vec2(0,self.b2Body->GetLinearVelocity().y));
                self.position = ccp(_initPos.x, self.position.y);
                _dashState = 4;
                _dashWaiting = 0.2;
            }
        }
            break;
        case 4:
        {
            self.b2Body->SetLinearVelocity(b2Vec2(0,self.b2Body->GetLinearVelocity().y));
            _dashWaiting -= delta;
            if (_dashWaiting < 0) {
                _dashState = 0;
            }
        }
            break;
        default:
            break;
    }
}

- (void)updateCounter:(ccTime)delta {
    switch (_counterState) {
        case 1:
        {
            _katanaBody->SetAngularVelocity(40);
            _counterWaiting -= delta;
            if (_counterWaiting < 0) {
                _katanaBody->SetAngularVelocity(0);
                _katanaBody->SetTransform(_katanaBody->GetPosition(), 0);
                _counterWaiting = 0.2;
                _counterState = 2;
            }
        }
            break;
        case 2:
        {
            _counterWaiting -= delta;
            if (_counterWaiting < 0) {
                _counterState = 0;
            }
        }
            break;
        default:
            break;
    }
}

- (void)updateMuteki:(ccTime)delta {
    switch (_mutekiState) {
        case 1:
        {
            self.katanaBody->SetAngularVelocity(10);
            _mutekiWaiting -= delta;
            if (_mutekiWaiting < 0) {
                _katanaBody->SetTransform(_katanaBody->GetPosition(), 0);
                self.katanaBody->SetAngularVelocity(0);
                _mutekiState = 0;
            }
        }
            break;
        case 2:
        {

        }
        default:
            break;
    }
}

- (void)update:(ccTime)delta {
    [self updateCounter:delta];
    [self updateDashSlice:delta];
    [self updateMuteki:delta];
    
    // 刀の位置
    b2Body* b = _katanaBody;
    _katana.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());    
}

- (void)removeFromParent {
    [super removeFromParent];
    _world->DestroyBody(self.b2Body);
}

- (void)damaged {
    if (_mutekiState == 0) {
        self.hp--;
        _mutekiState = 1;
        _mutekiWaiting = 0.5;
    }
}


@end
