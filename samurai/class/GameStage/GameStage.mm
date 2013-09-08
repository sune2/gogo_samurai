//
//  GameStage.m
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "GameStage.h"

@implementation GameStage

- (id)init
{
    [super init];
    if (self) {
        [self scheduleUpdate];
    }
    return self;
}

+(GameStage *)scene
{
    GameStage* scene = [GameStage node];
    scene.workLayer = [WorkLayer node];
    scene.menuLayer = [MenuLayer node];
    scene.bgLayer = [BackgroundLayer node];
    
    
    // レイヤーを追加する
    [scene addChild:scene.workLayer z:1];
    [scene addChild:scene.menuLayer z:2];
    [scene addChild:scene.bgLayer z:-1];

    return scene;
}

- (void)update: (ccTime)dt
{
    [self manageScore];
}

- (void)manageScore
{
    self.menuLayer.score = self.workLayer.score;
    self.menuLayer.life = self.workLayer.life;
}

@end
