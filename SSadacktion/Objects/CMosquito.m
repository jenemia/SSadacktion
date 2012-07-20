//
//  CMosquito.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "CMosquito.h"
#import "GamePlayLayer.h"

#define scheduleTimeCount 0.1
#define spotX 130
#define spotY 150

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
    mTimeStay = 1.5;
    mMoveVelocityX = rand()%10;
    mMoveVelocityY = rand()%10;
    
    [self unscheduleAllSelectors];
    
    [self schedule:@selector(move) interval:scheduleTimeCount];
}

//스케쥴로써 모기는 움직인다.
-(void)move
{
    NSLog(@"move");
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
        NSLog(@"change");
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

-(void)moveStay
{
    mTimeCount++;
    
    if( (mTimeCount*scheduleTimeCount) >= mTimeStay ) //제한시간 끝났을 때
    {
        [self unschedule:@selector(moveStay)];
        NSLog(@"Stay 제한시간 끝");
        mTimeCount = 0;
        [self schedule:@selector(moveAvoid) interval:scheduleTimeCount];
        return;
    }
}

-(void)moveAvoid
{
    mTimeCount++;
    
    CGPoint _prePos = [self position];
    CGPoint _newPos = CGPointMake( _prePos.x + mMoveVelocityX, _prePos.y - spotY/3 );
    [self setPosition:_newPos];
    
    if( mTimeCount == 5 ) // 화면 밖으로 갔다면 스케쥴로 끝.
    {
        [self unschedule:@selector(moveAvoid)];
        mTimeCount = 0;
        [GamePlayLayer displayMosquito];
        self.position = CGPointMake(10, 300);
        [self moveStart];
    }
}

@end
