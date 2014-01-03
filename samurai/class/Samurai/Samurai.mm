//
//  Samurai.m
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Samurai.h"
#import "Define.h"
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
    res.katana.tag = SpriteTagKatana;
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
    _katanaBody->SetUserData(self.katana);
    
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
    return _dashState == 0;
}
- (BOOL)canJump {
    if (_jumpState) return NO;
    return [self onGround];
}

- (BOOL)canCounter {
    return _counterState == 0;
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
    return _dashState == 1 || _dashState == 5;
}

- (BOOL)isCountering {
    return _counterState == 1;
}



- (void)jump {
    if ([self canJump]) {
        _jumpState = 1;
        _jumpWaiting = 1;
        self.b2Body->ApplyLinearImpulse(b2Vec2(0,32), self.b2Body->GetWorldCenter());
    }
}

- (void)dashSlice {
    if ([self canDash]) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"dash.mp3"];
        _dashState = 1;
    }
}

- (void)counter {
    if ([self canCounter]) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"counter.mp3"];
        _counterState = 1;
        _counterWaiting = 0.8;
    }
}

- (void)updateDashSlice:(ccTime)delta {
    switch (_dashState) {
        case 1:
        {
            self.b2Body->SetLinearVelocity(b2Vec2(80,self.b2Body->GetLinearVelocity().y));
            
            CCParticleSystemQuad* particle = [MyParticle particleDash];
            particle.position = ccpAdd(self.position, ccp(48,72));
            [[self parent] addChild:particle z:3];
            
            if (self.position.x > _initPos.x + 200) {
                self.b2Body->SetLinearVelocity(b2Vec2(0,self.b2Body->GetLinearVelocity().y));
                self.position = ccp(_initPos.x + 200, self.position.y);
                _dashState = 5;
                _dashWaiting = 0.2;
            }
        }
            break;
        case 5:
        {
            self.b2Body->SetLinearVelocity(b2Vec2(0,self.b2Body->GetLinearVelocity().y));
            _dashWaiting -= delta;
            if (_dashWaiting < 0) {
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
            float speed = 5;
            if (_dashHurry) speed = 20;
            self.b2Body->SetLinearVelocity(b2Vec2(-speed,self.b2Body->GetLinearVelocity().y));
            if (self.position.x <= _initPos.x) {
                _dashHurry = NO;
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
            CCParticleSystemQuad* particle = [MyParticle particleDash];
            particle.position = ccp(_katanaBody->GetPosition().x * PTM_RATIO,
                                    _katanaBody->GetPosition().y * PTM_RATIO);
            [[self parent] addChild:particle z:3];

            _katanaBody->SetAngularVelocity(80);
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
            CCParticleSystemQuad* blood = [MyParticle particleBlood];
            blood.position = ccp(self.b2Body->GetWorldCenter().x * PTM_RATIO,
                                 self.b2Body->GetWorldCenter().y * PTM_RATIO);
            [[self parent] addChild:blood];

            self.b2Body->SetLinearVelocity(b2Vec2(-6,self.b2Body->GetLinearVelocity().y));
            _mutekiWaiting -= delta;
            if (_mutekiWaiting < 0) {
                if (_hp > 0) {
                    [self runAction:[CCBlink actionWithDuration:0.3+0.1+2 blinks:10]];
                } else {
                    self.visible = NO;
                }
                _mutekiState = 2;
                _mutekiWaiting = 0.3;
            }
        }
            break;
        case 2:
        {
            self.b2Body->SetLinearVelocity(b2Vec2(2,self.b2Body->GetLinearVelocity().y));
            _mutekiWaiting -= delta;
            if (_mutekiWaiting < 0) {
                self.b2Body->SetLinearVelocity(b2Vec2(0,self.b2Body->GetLinearVelocity().y));
                self.position = ccp(_initPos.x, self.position.y);
                _mutekiState = 3;
                _mutekiWaiting = 0.1;
            }
        }
            break;
        case 3:
        {
            self.b2Body->SetLinearVelocity(b2Vec2(0,self.b2Body->GetLinearVelocity().y));
            _mutekiWaiting -= delta;
            if (_mutekiWaiting < 0) {
                _mutekiState = 4;
                _mutekiWaiting = 2;
            }

        }
            break;
        case 4:
        {
            _mutekiWaiting -= delta;
            if (_mutekiWaiting < 0) {
                _mutekiState = 0;
            }
        }
            break;
        default:
            break;
    }
}

- (void)updateJump:(ccTime)delta {
    if (_jumpState) {
        _jumpWaiting -= delta;
        if (_jumpWaiting < 0) {
            _jumpState = 0;
        }
    }
}

- (void)update:(ccTime)delta {
    [self updateCounter:delta];
    [self updateDashSlice:delta];
    [self updateMuteki:delta];
    [self updateJump:delta];

    // 落下
    if (_isRakka) {
        if ([self onGround]) {
            self.b2Body->SetLinearVelocity(b2Vec2(self.b2Body->GetLinearVelocity().x,0));
            _isRakka = NO;
        } else {
            self.b2Body->SetLinearVelocity(b2Vec2(self.b2Body->GetLinearVelocity().x,-40));
        }
    }
//    // 初期位置より後ろにいたら戻る
//    if (self.position.x < _initPos.x) {
//        self.b2Body->SetLinearVelocity(b2Vec2(0,self.b2Body->GetLinearVelocity().y));
//        self.position = ccp(_initPos.x, self.position.y);
//    }

    // 刀の位置
    b2Body* b = _katanaBody;
    _katana.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
    b->SetLinearVelocity(_b2Body->GetLinearVelocity());
}

- (void)removeFromParent {
    [super removeFromParent];
    _world->DestroyBody(self.b2Body);
}

- (void)damaged {
//    return;
    if (_mutekiState == 0) {
        self.hp--;
        _mutekiState = 1;
        _mutekiWaiting = 0.1;
        [[SimpleAudioEngine sharedEngine] playEffect:@"damaged.mp3"];
    }
}

- (void)rakka {
    if (![self onGround]) {
        _isRakka = YES;
//        self.b2Body->SetLinearVelocity(b2Vec2(0,-40));
    }
}

- (void)modoru {
    if (_dashState == 3) {
        _dashHurry = YES;
    }
}


@end
