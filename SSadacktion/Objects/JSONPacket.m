//
//  JSONPacket.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "JSONPacket.h"

enum Game
{
    kTagInit = 0, //초기화
    kTagJoin,   //회원가입
    kTagStart,
};

enum GamePlay
{
    kTagInitPlay = 0,   //초기화
    kTagMove,   //모기 이동
    kTagCatch,  //모기 잡기
    kTagAttack  //싸다구
};

@implementation JSONPacket
@synthesize mUserName;
@synthesize mRoom;
@synthesize mPlayer;
@synthesize mScore;
@synthesize mState;
@synthesize mPlayState;
@synthesize mPositionX;
@synthesize mPositionY;


-(id)init
{
    if( self = [super init] )
    {
        mUserName = [[NSString alloc]initWithFormat:@""];
        mRoom = [[NSString alloc]initWithFormat:@""];
        mPlayer = [[NSString alloc]initWithFormat:@""];
        mScore = [[NSString alloc]initWithFormat:@""];
        mState = [[NSString alloc]initWithFormat:@""];
        mPlayState = [[NSString alloc]initWithFormat:@""];
        mPositionX = [[NSString alloc]initWithFormat:@""];
        mPositionY = [[NSString alloc]initWithFormat:@""];
    }
    return self;
}

-(void)initAll
{
    mUserName = [[NSString alloc]initWithFormat:@""];
    mRoom = [[NSString alloc]initWithFormat:@""];
    mPlayer = [[NSString alloc]initWithFormat:@""];
    mScore = [[NSString alloc]initWithFormat:@""];
    mState = [[NSString alloc]initWithFormat:@""];
    mPlayState = [[NSString alloc]initWithFormat:@""];
    mPositionX = [[NSString alloc]initWithFormat:@""];
    mPositionY = [[NSString alloc]initWithFormat:@""];
}

@end
