//
//  GamePlayLayer.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "cocos2d.h"

@class CMosquito;
@class Packet, ServerAdapter;
@class User;

@interface GamePlayLayer : CCLayer <UIAlertViewDelegate>

//배경과 intro
@property (strong, nonatomic) CCSprite* mSpriteBackground;
@property (strong, nonatomic) CCSprite* mSpriteStartIntro;
@property (strong, nonatomic) CCAnimate* mAnimateStartIntro;
//플레이어 케릭터, 각 상태에 따라
@property (strong, nonatomic) CCSprite* mSpriteNomalPlayer1;
@property (strong, nonatomic) CCAnimate* mAnimateAttackPlayer1;
@property (strong, nonatomic) CCAnimate* mAnimateCatchPlayer1;

@property (strong, nonatomic) CCSprite* mSpriteNomalPlayer2;
@property (strong, nonatomic) CCAnimate* mAnimateAttackPlayer2;
@property (strong, nonatomic) CCAnimate* mAnimateCatchPlayer2;
//모기
@property (strong, nonatomic) CMosquito* mSpriteMosquite;
//게임 인터페이스
@property (strong, nonatomic) CCLabelTTF* mLabelGameTime;
@property (strong, nonatomic) CCLabelTTF* mLabelHp;
@property (nonatomic) NSInteger mGameTime;
@property (nonatomic) NSInteger mTimeCount;
@property (nonatomic) NSInteger mTimeTarget;
@property (nonatomic) NSInteger mHp;
//액션 이미지
@property (strong, nonatomic) CCSprite* mSpriteAttack_left;
@property (strong, nonatomic) CCSprite* mSpriteAttack_right;
@property (strong, nonatomic) CCSprite* mSpriteCatch;
//게임 결과
@property (strong, nonatomic) CCSprite* mSpriteGameWin;
@property (strong, nonatomic) CCSprite* mSpriteGameLose;
@property (strong, nonatomic) UIAlertView* mAlertView;
//게임 상태
@property (nonatomic) BOOL mGameStart;
//게임 서버
@property (strong, nonatomic) Packet* mReceivePacket;
@property (strong, nonatomic) ServerAdapter* mServerAdapter;
//게임 유저 정보
@property (strong, nonatomic) User* mUser;

+(void)displayScore;
//-(void)displayMosquito;
+(void)BoolTouch:(BOOL)result;
@end
