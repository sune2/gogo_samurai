//
//  Boss.h
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Box2D.h"
#import "CCPhysicsSprite.h"
#import "Projectile.h"

@interface Boss : CCPhysicsSprite
{
}

@property(nonatomic, strong) NSString* name;
@property(nonatomic, assign) b2World* world;

+ (Boss*)bossWithName:(NSString*)name;
- (void)initBodyWithWorld:(b2World*)world at:(CGPoint)point;

@end
