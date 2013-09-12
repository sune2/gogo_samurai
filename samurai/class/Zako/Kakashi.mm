//
//  Kakashi.m
//  samurai
//
//  Created by CA2015 on 13/09/12.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Kakashi.h"

@implementation Kakashi

+ (Kakashi *)kakashi
{
    Kakashi* res = (Kakashi *)[super enemyWithName:@"ninja"];
    res.scale = 57.0 / res.textureRect.size.width;
    return res;
}

+ (Kakashi *)kakashiWithParams: (NSDictionary *)params
{
    Kakashi* res = [self kakashi];
    NSArray* keys = [params allKeys];
    
    if ([keys containsObject:@"hp"])
        res.hp = [[params objectForKey:@"hp"] intValue];
    
    return res;
}

- (void)update:(ccTime)delta
{
    
    b2Vec2 pos = self.b2Body->GetPosition();
    
    if (pos.y < 1) {
        // 左に移動する
        self.b2Body->SetLinearVelocity(b2Vec2(-5, self.b2Body->GetLinearVelocity().y));
    }
    
    if (pos.y < 0) {
        self.b2Body->SetLinearVelocity(b2Vec2(self.b2Body->GetLinearVelocity().x, 0));
        self.b2Body->SetTransform(b2Vec2(pos.x,0), self.b2Body->GetAngle());
    }
    
    [self updateMuteki:delta];
}

@end
