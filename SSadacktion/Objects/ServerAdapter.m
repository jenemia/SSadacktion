//
//  ServerAdapter.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 27..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "ServerAdapter.h"
#import "SBJson.h"
#import "Packet.h"
#import <sys/socket.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>

@implementation ServerAdapter

@synthesize mSocket;
@synthesize mServerOn;

static ServerAdapter* _shreadServerAdapter;

+(ServerAdapter*)sharedServerAdapter
{
    @synchronized( [ServerAdapter class] )
    {
        if( !_shreadServerAdapter )
            [[self alloc]init];
        return _shreadServerAdapter;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized( [ServerAdapter class] )
    {
        _shreadServerAdapter = [super alloc];
        return _shreadServerAdapter;
    }
    return nil;
}

-(id)init
{
    if( self = [super init] )
    {
        mSocket = socket(PF_INET, SOCK_STREAM, 0);
        mServerOn = FALSE;
        if( mSocket == -1 )
            return nil;    
    }
    return self;
}

-(int)connect
{
    NSString* host = [[NSString alloc]initWithFormat:@"211.210.124.11"];
    unsigned short port = 5555;
    struct hostent* ent;
    ent = gethostbyname([host UTF8String]);
    if( !ent )
        return -1;
    
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = *((long*)ent->h_addr_list[0]);
    addr.sin_port = htons(port);
    
    if( connect(mSocket, (struct sockaddr *)&addr, sizeof(addr)) == -1 )
    {
        NSLog(@"connect error");
        return NO;
    }
    return YES;
}

-(int)send:(Packet*)packet;
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         packet.mState,@"State", packet.mRoom, @"Room",
                         packet.mPlayer, @"Player", packet.mX, @"PositionX", packet.mY, @"PositionY", 
                         packet.mHost, @"Host", nil];
    
    NSString* jsonString = [[[SBJsonWriter alloc]init]stringWithObject:dic];
    const char* message = [jsonString UTF8String];
    
    
    int sent=0, ret=0;
    int length = strlen(message);
    
    while( sent<length )
    {
        ret = write(mSocket, message+sent, length-sent);
        if( ret ==  -1 )
            return -1;
        sent+=ret;
    }
    return 0;
}

-(Packet*)receive
{
    char text[1024] = {0,}; 
    int len;
    
    len = read(mSocket, text, 1024);

    NSString* _recevieStr = [[NSString alloc]initWithFormat:@"%s",text];
//    NSLog(@"receive : %@", _recevieStr);
    NSDictionary* dic = [_recevieStr JSONValue];
    
    Packet* result = [[Packet alloc]init];
    result.mPlayer = [dic objectForKey:@"Player"];
    result.mRoom = [dic objectForKey:@"Room"];
    result.mHost = [dic objectForKey:@"Host"];
    result.mState = [dic objectForKey:@"State"];
    result.mX = [dic objectForKey:@"PositionX"];
    result.mY = [dic objectForKey:@"PositionY"];
    
    return result;
}

-(void)close
{
    close(mSocket);
}

@end
