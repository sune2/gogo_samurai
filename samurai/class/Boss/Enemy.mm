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
    res.score = 10;
    return res;
}

- (void)initBodyWithWorld:(b2World *)world at:(CGPoint)point {
    self.world = world;
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(point.x/self.PTMRatio,point.y/self.PTMRatio);
    bodyDef.fixedRotation = YES;

	b2Body *body = world->CreateBody(&bodyDef);

    _mainBody = body;
    body->SetUserData(self);
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:self.name];
    [self setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:self.name]];

    [self setB2Body:body];
    
    _bodies.push_back(self.b2Body);
    //self.bodies = [[NSMutableArray alloc] init];
    // [self.bodies addObject:[NSData dataWithBytes:self.b2Body length:sizeof(b2Body)]];

    [self scheduleUpdate];
}

- (void)update:(ccTime)delta {
    [self updateMuteki:delta];
    [self checkOutOfScreen];
    b2Vec2 pos = self.b2Body->GetPosition();
    if (pos.y < 0) {
        self.b2Body->SetLinearVelocity(b2Vec2(self.b2Body->GetLinearVelocity().x, 0));
        // ジョイントで何かくっついたりしていてやばそうならくっついているものも同じだけ動かしてやる
        self.b2Body->SetTransform(b2Vec2(pos.x,0), self.b2Body->GetAngle());
    }
}

- (void)checkOutOfScreen {
    if (isOutOfScreen(CGRectMake(self.position.x-self.anchorPoint.x,
                                 self.position.y-self.anchorPoint.y,
                                 self.contentSize.width*self.scale,
                                 self.contentSize.height*self.scale))) {
        
        [self.delegate enemyVanished:self];
    }
}


- (void)updateMuteki:(ccTime)delta {
    switch (_mutekiState) {
        case 1:
        {
            CCParticleSystemQuad* blood = [MyParticle particleEnemyBlood];
            blood.position = ccp(_mainBody->GetWorldCenter().x * PTM_RATIO,
                                 _mainBody->GetWorldCenter().y * PTM_RATIO);
            [[self parent] addChild:blood];
            
            _mutekiWaiting -= delta;
            if (_mutekiWaiting < 0) {
                if (self.hp > 0) {
                    [self runAction:[CCBlink actionWithDuration:0.3+0.1+2 blinks:10]];
                } else {
                    [self.delegate enemyDied:self];
                }
                _mutekiState = 2;
                _mutekiWaiting = 0.3;
            }
        }
            break;
        case 2:
        {
            _mutekiWaiting -= delta;
            if (_mutekiWaiting < 0) {
                _mutekiState = 3;
                _mutekiWaiting = 0.1;
            }
        }
            break;
        case 3:
        {            
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

- (void)removeFromParent {
    [super removeFromParent];
    self.world->DestroyBody(self.b2Body);
}

- (void)damaged {
    if (_mutekiState == 0) {
        self.hp--;
        _mutekiState = 1;
        _mutekiWaiting = 0.1;
        _mutekiPosX = self.position.x;
        [[SimpleAudioEngine sharedEngine] playEffect:@"kill.mp3"];
    }
}

- (int)bodiesCount {
    return _bodies.size();
}
- (b2Body*)getBodyAt:(NSInteger)index{
    return _bodies[index];
}

- (BOOL)isEarthquaking {
    return NO;
}
- (BOOL)isMuteki {
    return _mutekiState;
}

@end
