//
//  Date.m
//  samurai
//
//  Created by CA2015 on 13/09/10.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Date.h"
#import "GB2ShapeCache.h"
#import "MyParticle.h"

#define kJointAnchorPosX 4.03
#define kJointAnchorPosY 2.375

@implementation Date


+ (Date*)date {
    Date* res = (Date*)[super bossWithName:@"date_leg"];
    res.karada = [CCSprite spriteWithFile:@"date_main.png"];
    res.scale = 219.0 / res.contentSize.width;
    [res addChild:res.karada z:-3];
    return res;
}

- (void)initBodyWithWorld:(b2World *)world at:(CGPoint)point {
    [super initBodyWithWorld:world at:point];
    
    // 体
    b2BodyDef karadaDef;
    karadaDef.type = b2_dynamicBody;
    karadaDef.position.Set(point.x/self.PTMRatio, point.y/self.PTMRatio);
    
    _karadaBody = world->CreateBody(&karadaDef);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_karadaBody forShapeName:@"date_main"];
    [_karada setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"date_main"]];
    
    b2RevoluteJointDef jointDef;
    jointDef.Initialize(self.b2Body, _karadaBody, b2Vec2(self.position.x/self.PTMRatio+kJointAnchorPosX,
                                                         self.position.y/self.PTMRatio+kJointAnchorPosY));
    
    b2RevoluteJoint* joint = (b2RevoluteJoint*)world->CreateJoint(&jointDef);
    
    joint->EnableLimit(YES);
    joint->SetLimits(CC_DEGREES_TO_RADIANS(-70.0), CC_DEGREES_TO_RADIANS(-1.0) );
}

- (BOOL)canGanko {
    return _earthquakeState == 0 && _gankoState == 0;
}

- (void)makeGanko {
    if ([self canGanko]) {
        _gankoState = 1;
    }
}

- (BOOL)isEarthquaking {
    return _earthquakeState == 4;
}

- (BOOL)canEarthquake {
    return _earthquakeState == 0 && _gankoState == 0;
}

// 角速度1で足をあげる
// 80度まで上がったら足をおろして地震攻撃
- (void)makeEarthquake {
    if ([self canEarthquake]) {
        _earthquakeState = 1;
    }
}

- (void)updateEarthquake:(ccTime)delta {
    switch (_earthquakeState) {
        case 1:
        {
            if (self.karadaBody->GetAngle() <= CC_DEGREES_TO_RADIANS(-50)) {
                _earthquakeState = 2;
            } else {
                self.karadaBody->SetAngularVelocity(-1);
            }
        }
            break;
        case 2:
        {
            if (self.karadaBody->GetAngle() >= CC_DEGREES_TO_RADIANS(-10)) {
                _earthquakeState = 3;
            }
        }
            break;
        case 3:
        {
            CCParticleSystemQuad* part = [MyParticle particleEarthquake];
            part.position = ccp([[CCDirector sharedDirector] winSize].width/2,10);
            
            [[self parent] addChild:part z:3];
            
            _earthquakeState = 4;
            _waiting = 0.4;
        }
            break;
        case 4:
        {
            _waiting -= delta;
            if (_waiting < 0) {
                _earthquakeState = 0;
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
            [_delegate generatedProjectile:ganko];
            
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
    [self updateEarthquake:delta];
    [self updateGanko:delta];
    
    b2Vec2 pos = self.b2Body->GetPosition();
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
}

- (void)removeFromParent {
    [super removeFromParent];
    self.world->DestroyBody(self.karadaBody);
}




@end
