//
//  GameStage.m
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "GameStage.h"

@implementation GameStage

+(CCScene *)scene
{
    CCScene* scene = [CCScene node];
    WorkLayer* workLayer = [WorkLayer node];
    Menu* menuLayer = [Menu node];
    BackgroundLayer* bgLayer = [BackgroundLayer node];
    
    
    // レイヤーを追加する
    [scene addChild:workLayer z:1];
    [scene addChild:menuLayer z:2];
    [scene addChild:bgLayer z:-1];
    
    
    return scene;
}
@end
