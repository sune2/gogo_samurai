//
//  TextParticle.h
//  samurai
//
//  Created by kz on 13/12/30.
//  Copyright 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface TextParticle : CCLabelTTF

- (id)initWithInt:(int)sc;
- (void)run;
- (void)setPositionWithBody:(b2Body*)body;

@end
