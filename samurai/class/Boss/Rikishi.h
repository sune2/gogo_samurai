//
//  Rikishi.h
//  samurai
//
//  Created by kz on 13/09/07.
//  Copyright 2013年 gogo-samurai. All rights reserved.
//

#import "Enemy.h"

@interface Rikishi : Enemy
{
    int _shikoState;
    int _gankoState;
    ccTime _waiting;
    int _repNum;
}

@property (nonatomic, strong) CCSprite* karada;
@property (nonatomic, assign) b2Body* karadaBody;
@property(nonatomic, assign) float moveTime;
@property(nonatomic, assign) float stopPos;

+ (Rikishi*)rikishi;
+ (Rikishi*)rikishiWithParams:(NSDictionary*)params;

- (BOOL)canGanko;
- (void)makeGanko;
- (BOOL)canShiko;
- (void)makeShiko;
- (BOOL)isEarthquaking;

@end
