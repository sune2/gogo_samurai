//
//  BackgroundLayer.h
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Define.h"
#import "GLES-Render.h"

@interface BackgroundLayer : CCLayer
{
    CCSprite* _bgSprite[3];
}

@end
