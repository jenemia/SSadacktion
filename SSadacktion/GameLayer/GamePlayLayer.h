//
//  GamePlayLayer.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "cocos2d.h"

@class CMosquito;

@interface GamePlayLayer : CCLayer

@property (strong, nonatomic) CCSprite* mSpriteBackground;
@property (strong, nonatomic) CCSprite* mSpriteStartIntro;
@property (strong, nonatomic) CCAnimate* mAnimateStartIntro;

@property (strong, nonatomic) CCSprite* mSpriteNomalPlayer1;
@property (strong, nonatomic) CCAnimate* mAnimateAttackPlayer1;
@property (strong, nonatomic) CCAnimate* mAnimateCatchPlayer1;

@property (strong, nonatomic) CCSprite* mSpriteNomalPlayer2;
@property (strong, nonatomic) CCAnimate* mAnimateAttackPlayer2;
@property (strong, nonatomic) CCAnimate* mAnimateCatchPlayer2;

@property (strong, nonatomic) CMosquito* mSpriteMosquite;

@property (nonatomic) NSInteger mTimeCount;
@property (nonatomic) NSInteger mTimeTarget;

@property (nonatomic) BOOL mGameStart;

+(void)displayScore;
+(void)displayMosquito;
+(void)BoolTouch:(BOOL)result;
@end
