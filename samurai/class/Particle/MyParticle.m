//
//  MyParticle.m
//  samurai
//
//  Created by kz on 13/09/08.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "MyParticle.h"
//#import "CCDirector.h"

@implementation MyParticle

+ (CCParticleSystemQuad*)particleBlood {
    CCParticleSystemQuad* res = [CCParticleFire node];
    res.startSpin = res.startSpinVar = 0;
    res.endSpin = res.endSpinVar = 0;
    res.emissionRate = 100;
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
    res.emissionRate = 100;
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
    res.startColor = res.endColor = ccc4f(0.0, 0.0, 0., 1);
    res.startColorVar = res.endColorVar = ccc4f(0, 0, 0, 1);
    res.autoRemoveOnFinish = YES;
    
    ccBlendFunc func;
    func.src = GL_SRC_ALPHA;
    func.dst = GL_ONE_MINUS_SRC_ALPHA;
    res.blendFunc = func;

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
    res.emissionRate = 50;
    res.life = 0.1;
    res.duration = 0.1;
    res.autoRemoveOnFinish = YES;
    return res;
}

+ (CCParticleSystemQuad*)particleEarthquake {
    CCParticleSystemQuad* res = [CCParticleFire node];
    res.startSpin = res.startSpinVar = 0;
    res.endSpin = res.endSpinVar = 0;
    res.duration = 0.2;
    res.totalParticles = 1000;
    res.emissionRate = 1500;
    res.life = 0.1; res.lifeVar = 0.2;
    res.startSize = 40; res.startSizeVar = 5;
    res.endSize = 20; res.endSizeVar = 0;
    res.angle = 0; res.angleVar = 0;
    res.speed = 27; res.speedVar = 6.57;
    res.gravity = ccp(0,-80);
    res.radialAccel = 0; res.radialAccelVar = 0;
    res.tangentialAccel = 0; res.tangentialAccelVar = 0;
    res.posVar = ccp([[CCDirector sharedDirector] winSize].width,2);
//    res.posVar = ccp(50,0);
    res.startColor = ccc4f(0.6, 0.1, 0.8, 1);
    res.endColor = ccc4f(1, 0, 0.78, 1);
    res.startColorVar = ccc4f(0.5, 0, 0.4, 0.0);
    res.endColorVar = ccc4f(0.4, 0, 0.4, 0);

//    ccBlendFunc func;
//    func.src = GL_SRC_ALPHA;
//    func.dst = GL_ONE_MINUS_SRC_ALPHA;
//    res.blendFunc = func;

    res.autoRemoveOnFinish = YES;

    return res;
}

@end
