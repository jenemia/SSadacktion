//
//  GameMain.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "cocos2d.h"

@class GameMainLayer;
@class Client;

@interface GameMainScene : CCScene
{
    CGSize mWinSize;
}

@property (strong, nonatomic) GameMainLayer* mLayerGameMain;


@end
