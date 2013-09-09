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

@protocol MenuLayerDelegate
-(void)resetButtonPushed;
@end

@interface MenuLayer : CCLayer
{
    CCMenuItemLabel* _scoreLabel;
    NSMutableArray* _lifeDangos;
    CGSize _winSize;
}
@property (assign) int score;
@property (assign) int life;
@property (strong) id<MenuLayerDelegate> delegate;

@end

