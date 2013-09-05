//
//  Samurai.h
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface Samurai : NSObject
{
    b2Body* _body;
    CCSprite* _sprite;
    int _hp;
}
@end
