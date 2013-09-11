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
        _gameovered = NO;
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
    if (_workLayer.life == 0) {
        [self gameover:NO];
    } else if (_workLayer.clear) {
        [self gameover:YES];
    }
}

- (void)gameover: (BOOL)clear
{
    if (_gameovered) return;
    _gameovered = YES;
    SEL sel = @selector(didGameOver:);
    [self performSelector:sel withObject:[NSNumber numberWithBool:clear] afterDelay:0.3];
    // [self scheduleOnce:@selector(sel) delay:0.3];
}

- (void)didGameOver: (NSNumber*)clear {
    [self pauseWorkLayer];

    CCLayerColor* coloredLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 170)];
    [self addChild:coloredLayer z:2];
    
    _goLayer = [GameoverLayer nodeWithScore:_workLayer.score result:[clear boolValue]];
    _goLayer.delegate = self;
    [self addChild:_goLayer z:3];
        
}

- (void)manageMenu
{
    _menuLayer.score = _workLayer.score;
    _menuLayer.life = _workLayer.life;
}

- (void)resetButtonPushed {
    [[CCDirector sharedDirector] replaceScene:[GameStage scene]];
}

- (void)backToIntroLayer {
    [[CCDirector sharedDirector] replaceScene:[IntroLayer scene]];
}

- (void)pauseWorkLayer {
    [_workLayer pauseSchedulerAndActions];
    [_bgLayer pauseSchedulerAndActions];
    _workLayer.touchEnabled = NO;
}

- (void)resumeWorkLayer {
    [_workLayer resumeSchedulerAndActions];
    [_bgLayer resumeSchedulerAndActions];
    _workLayer.touchEnabled = YES;
}


@end
