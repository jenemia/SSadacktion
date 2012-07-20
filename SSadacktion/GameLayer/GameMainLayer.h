//
//  GameMainLayer.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "cocos2d.h"

@interface GameMainLayer : CCLayer
{
    CGSize mWinSize;
}

@property (strong, nonatomic) CCSprite* mSpriteBackground;
@property (strong, nonatomic) CCMenuItem* mMenuGameStart;

-(id)init;

@end
