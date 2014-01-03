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
    Date* res = (Date*)[super enemyWithName:@"date_leg"];
    res.karada = [CCSprite spriteWithFile:@"date_main.png"];
    res.scale = 219.0 / res.contentSize.width;
    [res addChild:res.karada z:-3];
    res.tag = SpriteTagBoss;
    res.hp = 10;
    res.difficulty = DifficultyEasy;
    res.score = 2000000;
    return res;
}

+ (Date*)dateWithParams:(NSDictionary *)params {
    Date* res = [self date];
    NSArray* keys = [params allKeys];
    
    if ([keys containsObject:@"hp"])
        res.hp = [[params objectForKey:@"hp"] intValue];
    if ([keys containsObject:@"difficulty"]) {
        NSString* str = [params objectForKey:@"difficulty"];
        if ([str isEqualToString:@"easy"]) {
            res.difficulty = DifficultyEasy;
            res.hp = 8;
            res.score = 2000000;
        } else if ([str isEqualToString:@"normal"]) {
            res.difficulty = DifficultyNormal;
            res.hp = 9;
            res.score = 4000000;
        } else if ([str isEqualToString:@"hard"]) {
            res.difficulty = DifficultyHard;
            res.hp = 10;
            res.score = 8000000;
        }
    }
    
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
    _bodies.push_back(_karadaBody);
    
    self.mainBody = _karadaBody;
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_karadaBody forShapeName:@"date_main"];
    [_karada setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"date_main"]];
    
    b2RevoluteJointDef jointDef;
    jointDef.Initialize(self.b2Body, _karadaBody, b2Vec2(self.position.x/self.PTMRatio+kJointAnchorPosX,
                                                         self.position.y/self.PTMRatio+kJointAnchorPosY));
    
    b2RevoluteJoint* joint = (b2RevoluteJoint*)world->CreateJoint(&jointDef);
    
    joint->EnableLimit(YES);
    joint->SetLimits(CC_DEGREES_TO_RADIANS(-60.0), CC_DEGREES_TO_RADIANS(-1.0) );
    
    _initPos = point;
    
    _yellowMoon = [CCSprite spriteWithFile:@"date_moon_yellow.png"];
    _yellowMoon.anchorPoint = ccp(0,0);
    _yellowMoon.scale = 0.7;
    [self.karada addChild:_yellowMoon z:-2];
    _yellowMoon.opacity = 0;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"horagai.mp3"];
}

- (BOOL)canGanko {
    if (_gankoState) return NO;
    if (self.difficulty == DifficultyEasy && _earthquakeState) return NO;
    return YES;
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
    if (self.difficulty == DifficultyEasy && _gankoState) {
        return NO;
    }
    if (_earthquakeState) return NO;
    return YES;
}

// 角速度1で足をあげる
// 80度まで上がったら足をおろして地震攻撃
- (void)makeEarthquake {
    if ([self canEarthquake]) {
        _earthquakeState = 1;
        [[SimpleAudioEngine sharedEngine] playEffect:@"uma.mp3"];
       
    }
}

- (void)updateEarthquake:(ccTime)delta {
    switch (_earthquakeState) {
        case 1:
        {
            if (self.karadaBody->GetAngle() <= CC_DEGREES_TO_RADIANS(-50)) {
                _earthquakeState = 2;
            } else {
                if (self.difficulty == DifficultyHard) {
                    self.karadaBody->SetAngularVelocity(-2);
                } else {
                    self.karadaBody->SetAngularVelocity(-1);
                }
            }
        }
            break;
        case 2:
        {
            if (self.difficulty == DifficultyHard) {
                self.karadaBody->ApplyAngularImpulse(1);
            }
            if (self.karadaBody->GetAngle() >= CC_DEGREES_TO_RADIANS(-10)) {
                self.b2Body->SetLinearVelocity(b2Vec2(0,0));
                self.karadaBody->SetLinearVelocity(b2Vec2(0,0));
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
            _waiting = 0.2;
            [[SimpleAudioEngine sharedEngine] playEffect:@"eq.mp3"];
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
    if (_gankoState) {
        _yellowMoon.position = ccp(10/self.scale,120/self.scale);//self.position;
    }
    switch (_gankoState) {
        case 1:
        {
            [_yellowMoon runAction:[CCFadeIn actionWithDuration:0.5]];
            
            _waiting = 1;
            _gankoState = 2;
            _repNum = 3;
            if (self.difficulty == DifficultyHard) {
                _repNum = 5;
            }
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
            Projectile* ganko = [Projectile projectileWithName:@"date_moon"];
            [ganko initBodyWithWorld:self.world at:ccp(self.position.x, self.position.y)];
            ganko.rotation = self.rotation;
            ganko.scale = 219.0 / ganko.contentSize.width;
            
            b2Vec2 toSamurai = _samurai.b2Body->GetWorldCenter() - ganko.b2Body->GetWorldCenter();
            toSamurai = 10.0 / toSamurai.Length() * toSamurai;

            ganko.linearVelocity = toSamurai;
            ganko.angularVelocity = 10;
            [self.delegate generatedProjectile:ganko];
            
            if (_repNum >= 2) {
                _repNum--;
                _waiting = 0.3;
                _gankoState = 2;
            } else {
                _waiting = 1;
                _gankoState = 4;
                [_yellowMoon runAction:[CCFadeOut actionWithDuration:0.5]];
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
    self.curTime += delta;
    
    if (rand() % 60 == 0) {
        if (self.difficulty == DifficultyEasy) {
            if (rand() % 3 == 0) {
                [self makeEarthquake];
            } else {
                [self makeGanko];
            }
        } else {
            if (rand() % 2) {
                [self makeEarthquake];
            } else {
                [self makeGanko];
            }
        }
    }
    
    _shokanWaiting -= delta;
    if (_shokanWaiting < 0) {
        if (self.difficulty == DifficultyEasy) {
            
        } else if (self.difficulty == DifficultyNormal && self.hp <= 4) {
            if (rand() % 120 == 0) {
                _shokanWaiting = 5;
                Enemy* enemy = [Kakashi kakashi];
                [enemy initBodyWithWorld:self.world at:ccp(400, 200)];
                enemy.score = 0;
                [self.delegate dateAddEnemey:enemy];
            }
        } else if (self.difficulty == DifficultyHard && self.hp <= 5) {
            if (rand() % 120 == 0) {
                _shokanWaiting = 5;
                Enemy* enemy;
                if (_shokanState) {
                    enemy = [Ninja ninja];
                    NSArray* array = [[NSArray alloc] initWithObjects:
                                      [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithDouble:1.0],@"time",
                                       @"shuriken",@"name",                                       
                                       nil],
                                      nil];
                    enemy.events = array;
                } else {
                    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            [NSNumber numberWithDouble:200], @"stopPos",
                                            [NSNumber numberWithDouble:9], @"moveTime",
                                            nil];
                    enemy = [Rikishi rikishiWithParams:params];
                    NSArray* array = [[NSArray alloc] initWithObjects:
                                      [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithDouble:1.0],@"time",
                                       @"shiko",@"name",
                                       nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithDouble:5.0],@"time",
                                       @"shiko",@"name",
                                       nil],
                                      nil];
                    enemy.events = array;                    
                }
                _shokanState = !_shokanState;
                [enemy initBodyWithWorld:self.world at:ccp(400, 200)];
                [self.delegate dateAddEnemey:enemy];
            }
        }
    }
                    
    b2Vec2 pos = self.b2Body->GetPosition();
    
    // 右側にいたら戻る
    if (pos.y < 1) {
        if (pos.x > _initPos.x/PTM_RATIO) {
            self.b2Body->SetLinearVelocity(b2Vec2(-1, self.b2Body->GetLinearVelocity().y));
        } else {
            self.b2Body->SetLinearVelocity(b2Vec2(1, self.b2Body->GetLinearVelocity().y));
        }
    }
    
    // 地面
    if (pos.y < 0) {
        self.b2Body->SetLinearVelocity(b2Vec2(self.b2Body->GetLinearVelocity().x, 0));
        b2Vec2 tmp = b2Vec2(pos.x,0) - self.b2Body->GetPosition();
        self.b2Body->SetTransform(b2Vec2(pos.x,0), self.b2Body->GetAngle());
        self.karadaBody->SetTransform(self.karadaBody->GetPosition()+tmp, self.karadaBody->GetAngle());
    }
    
    [self updateEarthquake:delta];
    [self updateGanko:delta];
    [self updateMuteki:delta];
    
    // [self checkOutOfScreen];

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
