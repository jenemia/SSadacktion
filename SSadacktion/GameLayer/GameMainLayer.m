//
//  GameMainLayer.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "GameMainLayer.h"
#import "GamePlayScene.h"
#import "ServerAdapter.h"
#import "Packet.h"
#import "User.h"

enum{
    kTagBacground = 0,
    kTagMenu
};

enum{
    pTagInit = 0,
    pTagWait,
    pTagStart
};


@implementation GameMainLayer

@synthesize mMenuGameStart,mMenuGameStartWithServer;
@synthesize mSpriteBackground;
@synthesize mReceivePacket;


-(id)init
{
    if( self = [super init] )
    {
        mWinSize = [[CCDirector sharedDirector]winSize];
        
        mSpriteBackground = [CCSprite spriteWithFile:@"menu_background.png"];
        mSpriteBackground.anchorPoint = CGPointZero;
        [mSpriteBackground setPosition:CGPointMake(0, 0)];
        [self addChild:mSpriteBackground z:kTagBacground tag:kTagBacground];
        
        mMenuGameStart = [CCMenuItemImage itemFromNormalImage:@"menu_start.png" selectedImage:@"menu_start_s.png" target:self selector:@selector(GameMenuStart)];
        mMenuGameStartWithServer = [CCMenuItemImage itemFromNormalImage:@"menu_start.png" selectedImage:@"menu_start_s.png" target:self selector:@selector(GameMenuStartWithServer)];
        
        CCMenu* menu = [CCMenu menuWithItems:mMenuGameStart,mMenuGameStartWithServer, nil];
        [menu alignItemsVertically];
        
        [self addChild:menu z:kTagMenu tag:kTagMenu];
    }
    return self;
}

-(void)GameMenuStart
{    
    [[CCDirector sharedDirector]pushScene:[GamePlayScene node]];
}

-(void)GameMenuStartWithServer
{
    //서버 접속
    ServerAdapter* server = [ServerAdapter sharedServerAdapter];
    [server connect];
    server.mServerOn = TRUE;
    
    Packet* _packet = [[Packet alloc]init];
    _packet.mState = [NSNumber numberWithInt:pTagInit];
    [server send:_packet];
    mReceivePacket = [server receive];
    
    User* user = [User sharedUser];
    user.mPlayer = mReceivePacket.mPlayer;
    user.mRoom = mReceivePacket.mRoom;
    user.mHost = mReceivePacket.mHost;
    
    [[CCDirector sharedDirector]pushScene:[GamePlayScene node]];
}
@end
