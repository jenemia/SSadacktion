//
//  GamePlayLayer.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "cocos2d.h"

@interface GamePlayLayer : CCLayer

@property (strong, nonatomic) CCSprite* mSpriteBackground;

@property (strong, nonatomic) CCSprite* mSpriteNomalPlayer1;
@property (strong, nonatomic) CCAnimate* mAnimateAttackPlayer1;
@property (strong, nonatomic) CCAnimate* mAnimateCatchPlayer1;

@property (strong, nonatomic) CCSprite* mSpriteNomalPlayer2;
@property (strong, nonatomic) CCAnimate* mAnimateAttackPlayer2;
@property (strong, nonatomic) CCAnimate* mAnimateCatchPlayer2;

@property (strong, nonatomic) 
@end
