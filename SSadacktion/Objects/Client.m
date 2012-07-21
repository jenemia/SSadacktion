//
//  Client.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 22..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "Client.h"
#import <sys/socket.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>

@implementation Client

@synthesize mSocket;
@synthesize mRoom, mPlayer, mX, mY, mState;
@synthesize mThread;
@synthesize mHost, mGameStart;

static Client* _sharedClient = nil;

+(Client*)sharedClient
{
    @synchronized([Client class])
    {
        if( !_sharedClient)
            [[self alloc]init];
        return _sharedClient;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([Client class])
    {
        _sharedClient = [super alloc];
        return _sharedClient;
    }
    return nil;
}

-(id)init
{
    mSocket = socket(PF_INET, SOCK_STREAM, 0);
    if( mSocket == -1 )
        return nil;
    
    mRoom =0, mPlayer=0, mX=0, mY=0;
    mHost = 0, mGameStart=0;
    
    [self connect:@"192.168.0.11" port:5555]; //서버 연결
    [self send]; // 처음 계정 설정
    
    mThread = [[NSThread alloc]initWithTarget:self selector:@selector(StartReceive) object:nil];
    [mThread start];
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [mThread cancel];
}

-(void)StartReceive
{   
    usleep(30);
    char text[1024] = {0,}; 
    int len;
    len = [self receive];
    
    NSLog(@"%s", text);
}

-(int)connect:(NSString *)host port:(unsigned short)port
{
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

-(int)send
{
    //state, room, player, x, y, host, GameStart
    NSString* str = [[NSString alloc]initWithFormat:@"state,%d,room,%d,player,%d,x,%d,y,%d,host,%d,gamestart,%d,,", mState,mRoom,mPlayer,mX,mY,mHost,mGameStart];
    const char* message = [str UTF8String];
    
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

-(int)receive
{
    char text[1024] = {0,}; 
    int len;
    
    len = read(mSocket, text, 1024);
    NSString* _result = [[NSString alloc]initWithFormat:@"%s",text];
    
    //state, room, player, x, y, host, GameStart
    NSArray* arr = [_result componentsSeparatedByString:@","];
    mRoom = (NSInteger)[arr objectAtIndex:3];
    mPlayer = (NSInteger)[arr objectAtIndex:5];
    mX = (NSInteger)[arr objectAtIndex:7];
    mY = (NSInteger)[arr objectAtIndex:9];
    mHost = (NSInteger)[arr objectAtIndex:11];
    mGameStart = (NSInteger)[arr objectAtIndex:13];
    
  	return len;
}

-(void)close
{
    close(mSocket);
}
@end
