//
//  Packet.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 22..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "Packet.h"
#import "SBJson.h"
#import <sys/socket.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>

@implementation Packet

@synthesize mRoom, mPlayer, mX, mY, mState;
@synthesize mHost;

-(id)init
{
    mState = [[NSNumber alloc]initWithInt:0];
    mRoom =  [[NSNumber alloc]initWithInt:0];
    mPlayer =  [[NSNumber alloc]initWithInt:0];
    mX =  [[NSNumber alloc]initWithInt:0];
    mY =  [[NSNumber alloc]initWithInt:0];
    mHost =  [[NSNumber alloc]initWithInt:0];

    return self;
}

-(void)SetPacketWithUser:(User *)user
{
    mRoom = user.mRoom;
    mPlayer = user.mPlayer;
    mHost = user.mHost;
}
@end
