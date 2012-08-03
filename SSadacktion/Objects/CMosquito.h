//
//  CMosquito.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "cocos2d.h"

@class SoundManager;

@interface CMosquito : CCSprite

@property (nonatomic) NSInteger mTimeCount;
@property (nonatomic) CGFloat mTimeTarget;
@property (nonatomic) CGFloat mTimeStay;
@property (nonatomic) NSInteger mState;

@property (nonatomic) NSInteger mMoveVelocityX;
@property (nonatomic) NSInteger mMoveVelocityY;

@property (strong,nonatomic) SoundManager* mSoundManager; 

-(void)initNotAlloc;
-(void)moveSetting;
-(BOOL)checkCollision;
-(void)LevelUp;

-(void)moveSetting;
-(void)moveSpotSetting;

-(void)move;
-(void)moveSpot;
-(void)moveStay;
-(void)moveAvoid;

-(BOOL)isMove;
-(BOOL)isMoveSpot;
-(BOOL)isMoveStay;
-(BOOL)isMoveAvoid;
@end
