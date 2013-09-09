//
//  MyParticle.m
//  samurai
//
//  Created by kz on 13/09/08.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "MyParticle.h"

@implementation MyParticle

+ (CCParticleSystemQuad*)particleBlood {
    CCParticleSystemQuad* res = [CCParticleFire node];
    res.startSpin = res.startSpinVar = 0;
    res.endSpin = res.endSpinVar = 0;
    res.duration = 0.2;
    res.totalParticles = 150;
    res.life = 0.3; res.lifeVar = 0.329;
    res.startSize = 32; res.startSizeVar = 32;
    res.endSize = 0; res.endSizeVar = 0;
    res.angle = 0; res.angleVar = 141;
    res.speed = 260; res.speedVar = 220;
    res.gravity = ccp(0,-1000);
    res.radialAccel = 0; res.radialAccelVar = 0;
    res.tangentialAccel = 309; res.tangentialAccelVar = 0;
    res.posVar = ccp(0,0);
    res.startColor = res.endColor = ccc4f(1, 0, 0, 1);
    res.startColorVar = res.endColorVar = ccc4f(1, 0, 0, 0);
    res.autoRemoveOnFinish = YES;
    return res;
}

+ (CCParticleSystemQuad*)particleEnemyBlood {
    CCParticleSystemQuad* res = [CCParticleFire node];
    res.startSpin = res.startSpinVar = 0;
    res.endSpin = res.endSpinVar = 0;
    res.duration = 0.2;
    res.totalParticles = 150;
    res.life = 0.3; res.lifeVar = 0.329;
    res.startSize = 32; res.startSizeVar = 32;
    res.endSize = 0; res.endSizeVar = 0;
    res.angle = 0; res.angleVar = 141;
    res.speed = 260; res.speedVar = 220;
    res.gravity = ccp(0,-1000);
    res.radialAccel = 0; res.radialAccelVar = 0;
    res.tangentialAccel = 309; res.tangentialAccelVar = 0;
    res.posVar = ccp(0,0);
    res.startColor = res.endColor = ccc4f(0.9, 0.9, 0.9, 1);
    res.startColorVar = res.endColorVar = ccc4f(0, 0, 0, 0);
    res.autoRemoveOnFinish = YES;
    return res;    
}

+ (CCParticleSystemQuad*)particleGanko {
    CCParticleSystemQuad* res = [CCParticleSun node];
    res.totalParticles = 5;
    res.endColor = res.startColor;
    res.startColorVar = res.endColorVar = ccc4f(0, 0, 0, 0);
    res.speed = 0;
    res.speedVar = 0;
    res.startSize = res.endSize = 10;
    res.startSizeVar = res.endSizeVar = 0;
    res.life = 2.5;
    res.lifeVar = 0;
    res.duration = 0;
    res.autoRemoveOnFinish = YES;
    return res;
}

+ (CCParticleSystemQuad*)particleDash {
    CCParticleSystemQuad* res = [CCParticleFire node];
    res.startColor = ccc4f(0,0,1,1);
    res.endColor = ccc4f(0,0,1,0);
    res.startColorVar = res.endColorVar = ccc4f(0,0,0,0);
    
    res.life = 0.1;
    res.duration = 0.1;
    res.autoRemoveOnFinish = YES;
    return res;
}

@end
