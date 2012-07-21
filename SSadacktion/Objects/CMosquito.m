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

#define scheduleTimeCount 0.1
#define spotX 130
#define spotY 150
#define imageWidth 50
#define imageHeight 50

@implementation CMosquito

@synthesize mTimeTarget, mTimeCount, mTimeStay;
@synthesize mMoveVelocityX, mMoveVelocityY;

-(id)init
{
    if( self = [super init] )
    {
        srand(time(NULL));
        mTimeCount = 0;
        mTimeTarget = 0;
        mTimeStay = 1.5;
        mMoveVelocityX = 0;
        mMoveVelocityY = 0;
    }
    return self;
}

//모기 움직이기 시작
-(void)moveStart
{
    mTimeTarget = rand()%3+2;
    mTimeCount = 0;
    mMoveVelocityX = rand()%10;
    mMoveVelocityY = rand()%10;
    
    [self unscheduleAllSelectors];
    
    [self schedule:@selector(move) interval:scheduleTimeCount];
//    [[SoundManager sharedSoundManager]playSystemSound:@"mosquito" fileType:@"wav"];
}

//스케쥴로써 모기는 움직인다.
-(void)move
{
    mTimeCount++;
    
    if( (mTimeCount*scheduleTimeCount) >= mTimeTarget ) //제한시간 끝났을 때
    {
        [self unschedule:@selector(move)];
        NSLog(@"제한시간 끝");
        [self moveToSpot]; //플레이어가 잡을 수 있는 지점으로 날라가기 시작
        return;
    }
    
    if( (mTimeCount % 10) == 0 )
    {
        mMoveVelocityX = rand()%20;
        mMoveVelocityY = rand()%20;
    }
    
    CGPoint _prePos = [self position];
    CGPoint _newPos = CGPointMake( _prePos.x + mMoveVelocityX, _prePos.y + mMoveVelocityY );
    [self setPosition:_newPos];
}

//목표 지점까지 날라가기
-(void)moveToSpot
{
    NSInteger distanceX = self.position.x - spotX;
    NSInteger distanceY = self.position.y - spotY;
    
    NSLog(@"%d : %d", distanceX, distanceY);
    
    mMoveVelocityX = distanceX / 5 * -1;
    mMoveVelocityY = distanceY / 5 * -1;
    
    mTimeCount = 0;
    
    [self schedule:@selector(movePosition) interval:0.1];
}

//스케쥴로 애니메이션 효과와 같이 이동한다.
-(void)movePosition
{
    mTimeCount++;
    
    CGPoint _prePos = [self position];
    CGPoint _newPos = CGPointMake( _prePos.x + mMoveVelocityX, _prePos.y + mMoveVelocityY );
    [self setPosition:_newPos];
    
    if( mTimeCount == 5 ) // 목표지점까지 갔다면 스케쥴로 끝.
    {
        [self unschedule:@selector(movePosition)];
        mTimeCount = 0;
        [self schedule:@selector(moveStay) interval:scheduleTimeCount];
    }
}

//플레이어 사이에 멈추는 것
-(void)moveStay
{
    mTimeCount++;
    
    if( (mTimeCount*scheduleTimeCount) >= mTimeStay ) //제한시간 끝났을 때
    {
        [self unschedule:@selector(moveStay)];
        NSLog(@"Stay 제한시간 끝");
        mTimeCount = 0;
        [self schedule:@selector(moveAvoid) interval:scheduleTimeCount];
        
//        [[SoundManager sharedSoundManager]playSystemSound:@"mosquito" fileType:@"wav"];
        return;
    }
}

//Stay 시간 이후 화면밖으로 나가서 새로운 모기가 생성되도록.
-(void)moveAvoid
{
    mTimeCount++;
    
    CGPoint _prePos = [self position];
    CGPoint _newPos = CGPointMake( _prePos.x + mMoveVelocityX, _prePos.y - spotY/3 );
    [self setPosition:_newPos];
    
    if( mTimeCount == 5 ) // 화면 밖으로 갔다면 스케쥴로 끝.
    {
        [self unschedule:@selector(moveAvoid)]; 
        [self resetMosquito];
    }
}

-(void)resetMosquito
{
    mTimeCount = 0;
    self.position = CGPointMake(10, 300);
    [self moveStart]; //새로운 모기 시작.
    [GamePlayLayer BoolTouch:true];
    [GamePlayLayer displayMosquito]; //게임화면 모기 카운트 늘리고
}

-(void)LevelUp
{
    
    //[[SoundManager sharedSoundManager]playSystemSound:@"ssadacktion" fileType:@"aif"];
    //충돌
    NSLog(@"충돌");
    [self unscheduleAllSelectors]; //모든 스케쥴러 정지
    mTimeStay -= 0.2; //머무는 시간 줄여서 난이도 높이기
    if( mTimeStay < 0.5 )
        mTimeStay = 0.5;
    
    
    [GamePlayLayer displayScore]; //점수 올리기
    
    [self resetMosquito];
}

-(BOOL)checkCollision
{
    NSLog(@"머물었던 시간 : %f", mTimeStay);
    
    CGPoint position = [self position];
    
    if( (position.x >= spotX && position.x <= spotX+imageWidth) || 
       (position.x+imageWidth >= spotX && position.x+imageWidth <= spotX+imageWidth) )
       {
           if( (position.y >= spotY-imageHeight && position.y <= spotY) ||
              (position.y-imageHeight >= spotY-imageHeight && position.y-imageHeight <= spotY) )
           {
               return TRUE;
           }
              
       }
//   [[SoundManager sharedSoundManager]playSystemSound:@"hit" fileType:@"aif"];
    return FALSE;
}

@end
