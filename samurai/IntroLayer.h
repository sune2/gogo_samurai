//
//  IntroLayer.h
//  samurai
//
//  Created by CA2015 on 13/09/04.
//  Copyright gogo-samurai 2013年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "GameStage.h"
#import "GB2ShapeCache.h"
#import "ScoreBoard.h"
#import "SimpleAudioEngine.h"

// HelloWorldLayer
@interface IntroLayer : CCLayer
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
