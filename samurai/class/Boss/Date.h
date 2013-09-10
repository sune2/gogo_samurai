//
//  Date.h
//  samurai
//
//  Created by CA2015 on 13/09/10.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Boss.h"
#import "Projectile.h"

@interface Date : Boss
{
    int _earthquakeState;
    int _gankoState;
    ccTime _waiting;
    int _repNum;
}

@property (nonatomic, strong) CCSprite* karada;
@property (nonatomic, assign) b2Body* karadaBody;
@property (nonatomic, strong) id<ProjectileProtocol> delegate;


+ (Date*)date;

- (BOOL)canGanko;
- (void)makeGanko;
- (BOOL)canEarthquake;
- (void)makeEarthquake;
- (BOOL)isEarthquaking;

@end
