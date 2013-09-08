//
//  Rikishi.h
//  samurai
//
//  Created by kz on 13/09/07.
//  Copyright 2013年 gogo-samurai. All rights reserved.
//

#import "Boss.h"
#import "Projectile.h"

@interface Rikishi : Boss
{
    int _shikoState;
    int _gankoState;
    ccTime _waiting;
    int _repNum;
}

@property (nonatomic, strong) CCSprite* karada;
@property (nonatomic, assign) b2Body* karadaBody;
@property (nonatomic, strong) id<ProjectileProtocol> delegate;


+ (Rikishi*)rikishi;

- (BOOL)canGanko;
- (void)makeGanko;
- (BOOL)canShiko;
- (void)makeShiko;

@end
