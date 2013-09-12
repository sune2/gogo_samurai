//
//  GameStage.h
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "WorkLayer.h"
#import "MenuLayer.h"
#import "BackgroundLayer.h"
#import "GameoverLayer.h"
#import "IntroLayer.h"
#import "SimpleAudioEngine.h"

@interface GameStage : CCScene<MenuLayerDelegate>
{
    BOOL _gameovered;
}

// +(GameStage *)scene;
+(GameStage *)sceneWithDifficulty: (Difficulty)difficulty;
@property(nonatomic, strong) WorkLayer* workLayer;
@property(nonatomic, strong) MenuLayer* menuLayer;
@property(nonatomic, strong) BackgroundLayer* bgLayer;
@property(nonatomic, strong) GameoverLayer* goLayer;
@property(assign) Difficulty difficulty;

@end
