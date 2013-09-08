//
//  Menu.h
//  samurai
//
//  Created by CA2015 on 13/09/06.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLES-Render.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "Define.h"
#import "Samurai.h"
#import "WorkLayer.h"

@interface MenuLayer : CCLayer
{
    CCMenuItemLabel* _scoreLabel;
    CCMenuItemLabel* _lifeLabel;
}
@property (assign) int score;
@property (assign) int life;

@end
