//
//  ScoreLayer.h
//  samurai
//
//  Created by CA2015 on 13/09/09.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "../CCTextField.h"
#import "CCUIViewWrapper.h"

@protocol backProtocol
- (void) backToIntroLayer;
@end

@interface ScoreLayer : CCLayer
{
    CGSize _winSize;
    NSArray* _scores;
}
@property (strong) id<backProtocol> delegate;

@end
