//
//  Rikishi.m
//  samurai
//
//  Created by kz on 13/09/07.
//  Copyright 2013年 gogo-samurai. All rights reserved.
//

#import "Rikishi.h"
#import "GB2ShapeCache.h"
#import "MyParticle.h"

#define kJointAnchorPosX 1.9
#define kJointAnchorPosY 1.1

@implementation Rikishi

+ (Rikishi*)rikishi {
    Rikishi* res = (Rikishi*)[super enemyWithName:@"rikisi_leg"];
    res.karada = [CCSprite spriteWithFile:@"rikisi.png"];
    [res addChild:res.karada z:-3];
    res.scale = 91/res.contentSize.width;
    res.stopPos = 300;
    res.moveTime = 5;
    res.hp = 2;
    return res;
}

+ (Rikishi*)rikishiWithParams:(NSDictionary *)params {
    Rikishi* res = [self rikishi];
    NSArray* keys = [params allKeys];
    
    if ([keys containsObject:@"moveTime"])
        res.moveTime = [[params objectForKey:@"moveTime"] floatValue];
    if ([keys containsObject:@"stopPos"])
        res.stopPos = [[params objectForKey:@"stopPos"] floatValue];
    return res;
}

- (void)initBodyWithWorld:(b2World *)world at:(CGPoint)point {
    [super initBodyWithWorld:world at:point];

    // 体
    b2BodyDef karadaDef;
    karadaDef.type = b2_dynamicBody;
    karadaDef.position.Set(point.x/self.PTMRatio, point.y/self.PTMRatio);

    _karadaBody = world->CreateBody(&karadaDef);
    _karadaBody->SetUserData(self);
    
    _mainBody = _karadaBody;
    _bodies.push_back(_karadaBody);
//    [self.bodies addObject:[NSData dataWithBytes:_karadaBody length:sizeof(b2Body)]];
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_karadaBody forShapeName:@"rikisi"];
    [_karada setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"rikisi"]];

    b2RevoluteJointDef jointDef;
    jointDef.Initialize(self.b2Body, _karadaBody,
                        b2Vec2(self.position.x/self.PTMRatio+kJointAnchorPosX,
                               self.position.y/self.PTMRatio+kJointAnchorPosY));

    b2RevoluteJoint* joint = (b2RevoluteJoint*)world->CreateJoint(&jointDef);

    joint->EnableLimit(YES);
    joint->SetLimits(CC_DEGREES_TO_RADIANS(-80.0), 0.0);
}

- (BOOL)canGanko {
    return _shikoState == 0 && _gankoState == 0;
}

- (void)makeGanko {
    return;
    if ([self canGanko]) {
        _gankoState = 1;
    }
}

- (BOOL)isEarthquaking {
    return _shikoState == 4;
}

- (BOOL)canShiko {
    return _shikoState == 0 && _gankoState == 0;
}

// 角速度1で足をあげる
// 80度まで上がったら足をおろして地震攻撃
- (void)makeShiko {
    if ([self canShiko]) {
        _shikoState = 1;
    }
}

- (void)updateShiko:(ccTime)delta {
    switch (_shikoState) {
        case 1:
        {
            if (self.karadaBody->GetAngle() <= CC_DEGREES_TO_RADIANS(-70)) {
                _shikoState = 2;
            } else {
                self.karadaBody->SetAngularVelocity(-1);
            }
        }
            break;
        case 2:
        {
            if (self.karadaBody->GetAngle() >= CC_DEGREES_TO_RADIANS(-10)) {
                _shikoState = 3;
            }
        }
            break;
        case 3:
        {
            CCParticleSystemQuad* part = [MyParticle particleEarthquake];
            part.position = ccp([[CCDirector sharedDirector] winSize].width/2,10);
            
            [[self parent] addChild:part z:3];
            
            _shikoState = 4;
            _waiting = 0.2;
        }
            break;
        case 4:
        {
            _waiting -= delta;
            if (_waiting < 0) {
                _shikoState = 0;
            }
        }
        default:
            break;
    }
}


- (void)updateGanko:(ccTime)delta {
    switch (_gankoState) {
        case 1:
        {
            CCParticleSystemQuad* part = [MyParticle particleGanko];
            part.position = ccp(self.position.x+40, self.position.y+60);
            [[self parent] addChild:part z:3];

            CCParticleSystemQuad* part2 = [MyParticle particleGanko];
            part2.position = ccp(self.position.x+50, self.position.y+60);
            [[self parent] addChild:part2 z:3];

            _waiting = 1;
            _gankoState = 2;
            _repNum = 3;
        }
            break;
        case 2:
        {
            _waiting -= delta;
            if (_waiting < 0) {
                _gankoState = 3;
            }
        }
            break;
        case 3:
        {
            Projectile* ganko = [Projectile projectileWithName:@"ganko"];
            [ganko initBodyWithWorld:self.world at:ccp(self.position.x+20, self.position.y+65)];
            ganko.scale = self.scale;
            ganko.linearVelocity = b2Vec2(-10,0);
            [self.delegate generatedProjectile:ganko];

            if (_repNum >= 2) {
                _repNum--;
                _waiting = 0.3;
                _gankoState = 2;
            } else {
                _waiting = 1;
                _gankoState = 4;
            }
        }
            break;
        case 4:
        {
            _waiting -= delta;
            if (_waiting < 0) {
                _gankoState = 0;
            }
        }
        default:
            break;
    }
}


- (void)update:(ccTime)delta {
    _curTime += delta;
    
    [self updateShiko:delta];
    [self updateGanko:delta];
    [self updateMuteki:delta];
    
    [self checkOutOfScreen];
        
    b2Vec2 pos = self.b2Body->GetPosition();
    
    if (pos.y < 1) {
        if (pos.x > self.stopPos/PTM_RATIO || _curTime > self.moveTime) {
            // 左に移動する
            self.b2Body->SetLinearVelocity(b2Vec2(-5, self.b2Body->GetLinearVelocity().y));
        } else {
            self.b2Body->SetLinearVelocity(b2Vec2(0, self.b2Body->GetLinearVelocity().y));
        }
    }

    if (pos.y < 0) {
        self.b2Body->SetLinearVelocity(b2Vec2(self.b2Body->GetLinearVelocity().x, 0));
        b2Vec2 tmp = b2Vec2(pos.x,0) - self.b2Body->GetPosition();
        self.b2Body->SetTransform(b2Vec2(pos.x,0), self.b2Body->GetAngle());
        self.karadaBody->SetTransform(self.karadaBody->GetPosition()+tmp, self.karadaBody->GetAngle());
    }

    // 体の位置
    b2Body* b = _karadaBody;
    _karada.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
    _karada.position = ccp((b->GetPosition().x*self.PTMRatio - self.position.x)/self.scale,
                           (b->GetPosition().y*self.PTMRatio - self.position.y)/self.scale);
    
    
    // イベント処理
    while(_eventIndex < self.events.count &&
          [self.events[_eventIndex][@"time"] floatValue] < _curTime) {
        NSString *command = self.events[_eventIndex][@"name"];
        if ([command isEqualToString:@"shiko"]) {
            [self makeShiko];
        }
        _eventIndex++;
    }
}

- (void)removeFromParent {
    [super removeFromParent];
    self.world->DestroyBody(self.karadaBody);
}




@end
