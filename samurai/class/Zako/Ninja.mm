//
//  Ninja.m
//  samurai
//
//  Created by CA2015 on 13/09/06.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Ninja.h"

@implementation Ninja

+ (Ninja*)ninja {
    Ninja* res = (Ninja*)[super zakoWithName:@"ninja"];
    res.scale = 57.0 / res.textureRect.size.width;
    return res;
}

- (Projectile*)makeBullet {
    Projectile* shuriken = [Projectile projectileWithName:@"shuriken"];
    [shuriken initBodyWithWorld:self.world at:ccp(self.position.x, self.position.y+50)];
    shuriken.scale = self.scale;
    shuriken.linearVelocity = b2Vec2(-10,0);
    shuriken.angularVelocity = 10;
//    shuriken.b2Body->SetAngularVelocity(5);
    return shuriken;
}

@end
