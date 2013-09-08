//
//  Ninja.h
//  samurai
//
//  Created by CA2015 on 13/09/06.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Zako.h"

@interface Ninja : Zako
{
    int _shurikenState;
    ccTime _waiting;
    b2RevoluteJoint* _joint;
}
@property (nonatomic, strong) CCSprite* arm;
@property (nonatomic, assign) b2Body* armBody;
@property (nonatomic, strong) id<ProjectileProtocol> delegate;

+ (Ninja*)ninja;

- (void)makeShuriken;

@end
