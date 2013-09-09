//
//  MyParticle.h
//  samurai
//
//  Created by kz on 13/09/08.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "cocos2d.h"

@interface MyParticle : NSObject

+ (CCParticleSystemQuad*) particleBlood;
+ (CCParticleSystemQuad*) particleEnemyBlood;
+ (CCParticleSystemQuad*) particleGanko;
+ (CCParticleSystemQuad*) particleDash;
+ (CCParticleSystemQuad*) particleEarthquake;

@end
