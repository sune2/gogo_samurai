//
//  WorkLayer.h
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLES-Render.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "Define.h"
#import "Samurai.h"

@interface WorkLayer : CCLayer
{
    b2World* world;
    GLESDebugDraw *m_debugDraw;
}
@end
