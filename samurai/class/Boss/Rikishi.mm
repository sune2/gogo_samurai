//
//  Rikishi.m
//  samurai
//
//  Created by kz on 13/09/07.
//  Copyright 2013年 gogo-samurai. All rights reserved.
//

#import "Rikishi.h"
#import "GB2ShapeCache.h"

#define kJointAnchorPosX 1.9
#define kJointAnchorPosY 1.1

@implementation Rikishi

+ (Rikishi*)rikishi {
    Rikishi* res = (Rikishi*)[super bossWithName:@"rikisi_leg"];
    
    res.karada = [CCSprite spriteWithFile:@"rikisi.png"];
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

    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_karadaBody forShapeName:@"rikisi"];
    [_karada setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"rikisi"]];

    b2RevoluteJointDef jointDef;
    jointDef.Initialize(self.b2Body, _karadaBody, b2Vec2(self.position.x/self.PTMRatio+kJointAnchorPosX,
                                                         self.position.y/self.PTMRatio+kJointAnchorPosY));

    b2RevoluteJoint* joint = (b2RevoluteJoint*)world->CreateJoint(&jointDef);

    joint->EnableLimit(YES);
    joint->SetLimits(CC_DEGREES_TO_RADIANS(-80.0), 0.0);
}

- (BOOL) canGanko {
    return _shikoState == 0 && _gankoState == 0;
}

- (void)makeGanko {
    if ([self canGanko]) {
        _gankoState = 1;
    }
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
            Projectile* shiko = [Projectile projectileWithName:@"shiko"];
            [shiko initBodyWithWorld:self.world at:ccp(self.position.x, self.position.y)];
            shiko.scale = self.scale;
            shiko.linearVelocity = b2Vec2(-10,0);
            shiko.type = ProjectileTypeSpecial; 

            [_delegate generatedProjectile:shiko];
            
            _shikoState = 4;
            _waiting = 1;
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

- (CCParticleSystemQuad*)generateParticleAt:(CGPoint)point {
    CCParticleSystemQuad* particle = [CCParticleSun node];
    particle.totalParticles = 5;
    particle.endColor = particle.startColor;
    particle.startColorVar = particle.endColorVar = ccc4f(0, 0, 0, 0);
    particle.speed = 0;
    particle.speedVar = 0;
    particle.startSize = particle.endSize = 10;
    particle.startSizeVar = particle.endSizeVar = 0;
    particle.life = 2.5;
    particle.lifeVar = 0;
    particle.duration = 0;
    particle.autoRemoveOnFinish = YES;
    particle.position = point;
    return particle;
}

- (void)updateGanko:(ccTime)delta {
    switch (_gankoState) {
        case 1:
        {
            CCParticleSystemQuad* part = [self generateParticleAt:ccp(self.position.x+40, self.position.y+60)];
            [[self parent] addChild:part z:3];

            CCParticleSystemQuad* part2 = [self generateParticleAt:ccp(self.position.x+50, self.position.y+60)];
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
    [self updateShiko:delta];
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
