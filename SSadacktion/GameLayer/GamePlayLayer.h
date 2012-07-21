//
//  GamePlayLayer.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "cocos2d.h"

@class CMosquito;

@interface GamePlayLayer : CCLayer <UIAlertViewDelegate>

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

@property (strong, nonatomic) CCLabelTTF* mLabelGameTime;
@property (strong, nonatomic) CCLabelTTF* mLabelHp;
@property (nonatomic) NSInteger mGameTime;
@property (nonatomic) NSInteger mTimeCount;
@property (nonatomic) NSInteger mTimeTarget;
@property (nonatomic) NSInteger mHp;

@property (nonatomic) BOOL mGameStart;

@property (strong, nonatomic) CCSprite* mSpriteAttack;
@property (strong, nonatomic) CCAnimate* mAnimateAttack;
@property (strong, nonatomic) CCSprite* mSpriteCatch;
@property (strong, nonatomic) CCAnimate* mAnimateCatch;

@property (strong, nonatomic) CCSprite* mSpriteGameWin;
@property (strong, nonatomic) CCSprite* mSpriteGameLose;

@property (strong, nonatomic) UIAlertView* mAlertView;

+(void)displayScore;
+(void)displayMosquito;
+(void)BoolTouch:(BOOL)result;
@end
