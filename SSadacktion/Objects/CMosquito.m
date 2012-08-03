//
//  CMosquito.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "CMosquito.h"
#import "GamePlayLayer.h"
#import "SoundManager.h"

#define scheduleTimeCount 0.05
#define spotX 130
#define spotY 150
#define imageWidth 50
#define imageHeight 50

enum{
    mTagMove = 0,
    mTagSpot,
    mtagStay,
    mTagAviod
};

@implementation CMosquito

@synthesize mTimeTarget, mTimeCount, mTimeStay, mState;
@synthesize mMoveVelocityX, mMoveVelocityY;
@synthesize mSoundManager;

-(id)init
{
    if( self = [super init] )
    {
        srand(time(NULL));
        mTimeCount = 0;
        mTimeTarget = 1.5;
        mTimeStay = 0.25;
        mMoveVelocityX = 0;
        mMoveVelocityY = 0;
        mSoundManager = [SoundManager sharedSoundManager];
    }
    return self;
}

-(void)initNotAlloc
{
    mTimeCount = 0;
    mTimeTarget = 1.5;
    mTimeStay = 0.25;
    mMoveVelocityX = 0;
    mMoveVelocityY = 0;
    [self unscheduleAllSelectors];
}

//모기 움직이기 시작
//IntroEnd, Touch 두 곳
-(void)moveSetting
{
    self.position = CGPointMake(10, 300); //초기 위치
    mTimeCount = 0;
    mMoveVelocityX = rand()%10;
    mMoveVelocityY = rand()%10;
    mState = mTagMove;
    
    [self unscheduleAllSelectors];
    [mSoundManager playSystemSound:@"mosquito" fileType:@"wav"];
}

//스케쥴로써 모기는 움직인다.
-(void)move
{
    mTimeCount++;
    
    NSInteger tmp = rand()%2;
    NSInteger minus = 1;
    if( tmp == 0 )
        minus *= -1;
    
    if( (mTimeCount % 5) == 0 )
    {
        mMoveVelocityX = rand()%50+20 * minus;
        mMoveVelocityY = rand()%50+20 * minus;
    }
    
    CGPoint _prePos = [self position];
    CGPoint _newPos = CGPointMake( _prePos.x + mMoveVelocityX, _prePos.y + mMoveVelocityY );
    [self setPosition:_newPos];
}

-(BOOL)isMove
{
    if( (mTimeCount*scheduleTimeCount) >= mTimeTarget ) //제한시간 끝났을 때
    {
        return true;
    }
    return false;
}

//목표 지점까지 날라가기 셋팅
-(void)moveSpotSetting
{
    NSInteger distanceX = self.position.x - spotX;
    NSInteger distanceY = self.position.y - spotY;

    mMoveVelocityX = distanceX / 5 * -1;
    mMoveVelocityY = distanceY / 5 * -1;
    
    mTimeCount = 0;
}

//스케쥴로 애니메이션 효과와 같이 이동한다.
-(void)moveSpot
{
    mTimeCount++;
    
    CGPoint _prePos = [self position];
    CGPoint _newPos = CGPointMake( _prePos.x + mMoveVelocityX, _prePos.y + mMoveVelocityY );
    [self setPosition:_newPos];
}

-(BOOL)isMoveSpot
{
    
    if( mTimeCount == 5 ) // 목표지점까지 갔다면 스케쥴로 끝.
    {
        mTimeCount = 0;
        return true;
    }
    return false;
}

//플레이어 사이에 멈추는 것
-(void)moveStay
{
    mTimeCount++;
}

-(BOOL)isMoveStay
{
    if( (mTimeCount*scheduleTimeCount) >= mTimeStay ) //제한시간 끝났을 때
    {
        mTimeCount = 0;        
        return true;
    }
    return false;
}

//Stay 시간 이후 화면밖으로 나가서 새로운 모기가 생성되도록.
-(void)moveAvoid
{
    mTimeCount++;
    
    CGPoint _prePos = [self position];
    CGPoint _newPos = CGPointMake( _prePos.x + mMoveVelocityX, _prePos.y - spotY/3 );
    [self setPosition:_newPos];
}

-(BOOL)isMoveAvoid
{
    if( mTimeCount == 5 ) // 화면 밖으로 갔다면 스케쥴로 끝.
    {
        mTimeCount = 0;
        self.position = CGPointMake(10, 300);
        return true;
    }
    return false;
}

-(void)LevelUp
{
    //충돌
    NSLog(@"충돌");
    [self unscheduleAllSelectors]; //모든 스케쥴러 정지
    
    mTimeTarget -= 0.2;
    if( mTimeTarget <= 0.5 )
        mTimeTarget = 0.5;

    mTimeStay -= 0.01;
    if( mTimeStay <= 0.15 )
        mTimeStay = 0.15;
    
    [GamePlayLayer displayScore]; //점수 올리기
    
    mTimeCount = 0;
}

-(BOOL)checkCollision
{
    CGPoint position = [self position];
    
    if( (position.x >= spotX && position.x <= spotX+imageWidth) || 
       (position.x+imageWidth >= spotX && position.x+imageWidth <= spotX+imageWidth) )
       {
           if( (position.y >= spotY-imageHeight && position.y <= spotY) ||
              (position.y-imageHeight >= spotY-imageHeight && position.y-imageHeight <= spotY) )
           {
               [mSoundManager playSystemSound:@"hit" fileType:@"aif"];
               return TRUE;
           }
       }
   [mSoundManager playSystemSound:@"ssadacktion" fileType:@"aif"];
    mTimeTarget += 0.2; //실패 했을 때 모기 체공시간을 늘린다.
    mTimeStay += 0.01;
    return FALSE;
}

@end
