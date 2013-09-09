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
    
    scene.menuLayer.delegate = scene;
    
    // レイヤーを追加する
    [scene addChild:scene.workLayer z:0];
    [scene addChild:scene.menuLayer z:1];
    [scene addChild:scene.bgLayer z:-1];

    return scene;
}

- (void)update: (ccTime)dt
{
    [self manageMenu];
    if (_workLayer.life == 0 && _goLayer == nil) {
        [self gameover];
    }
}

- (void)gameover
{
    CCLayerColor* coloredLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 170)];
    [self addChild:coloredLayer z:2];
    
    _goLayer = [GameoverLayer nodeWithScore:_workLayer.score];
    [self addChild:_goLayer z:3];
    
    _workLayer.touchEnabled = NO;
}

- (void)manageMenu
{
    _menuLayer.score = _workLayer.score;
    _menuLayer.life = _workLayer.life;
}

- (void)resetButtonPushed {
    [[CCDirector sharedDirector] replaceScene:[GameStage scene]];
}

@end
