//
//  ScoreLayer.h
//  samurai
//
//  Created by CA2015 on 13/09/09.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "CCUIViewWrapper.h"
#import "Define.h"

@protocol backProtocol
- (void) backToIntroLayer;
@end

@interface ScoreLayer : CCLayer<UITextFieldDelegate>
{
    CGSize _winSize;
    NSArray* _scores;
    UITextField* _tf;
    CCUIViewWrapper* _tfWrapper;
    NSUserDefaults* _ud;
}
@property (strong) id<backProtocol> delegate;

@end
