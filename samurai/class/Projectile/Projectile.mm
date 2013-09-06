//
//  Projectile.m
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Projectile.h"
#import "Define.h"
#import "GB2ShapeCache.h"

@implementation Projectile

+ (Projectile*)projectileWithName:(NSString*)name {
    Projectile *res = [super spriteWithFile:[NSString stringWithFormat:@"%@.png", name]];
//    res.scale = 116.0 / res.textureRect.size.width;
    [res setPTMRatio:PTM_RATIO];
    res.name = name;
    return res;
}

- (void)initBodyWithWorld:(b2World *)world at:(CGPoint)point {
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(point.x/self.PTMRatio,point.y/self.PTMRatio);
    
	b2Body *body = world->CreateBody(&bodyDef);
	
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:self.name];
    [self setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:self.name]];
    
    [self setB2Body:body];
}

- (void)update:(ccTime)delta {
    self.b2Body->SetAngularVelocity(self.angularVelocity);
    self.b2Body->SetLinearVelocity(self.linearVelocity);
}


@end
