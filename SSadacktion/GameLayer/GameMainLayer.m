//
//  GameMainLayer.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "GameMainLayer.h"
#import "GamePlayScene.h"
#import "Client.h"

enum{
    kTagBacground = 0,
    kTagMenu
};

@implementation GameMainLayer

@synthesize mMenuGameStart;
@synthesize mSpriteBackground;
@synthesize mClient;

-(id)init
{
    if( self = [super init] )
    {
        mWinSize = [[CCDirector sharedDirector]winSize];
        
        mSpriteBackground = [CCSprite spriteWithFile:@"menu_background.png"];
        mSpriteBackground.anchorPoint = CGPointZero;
        [mSpriteBackground setPosition:CGPointMake(0, 0)];
        [self addChild:mSpriteBackground z:kTagBacground tag:kTagBacground];
        
        mClient = [Client sharedClient];
        [mClient StartThread];
        if( [mClient.mHost isEqualToString:@"1"]) // host
        {
            mMenuGameStart = [CCMenuItemImage itemFromNormalImage:@"menu_start.png" selectedImage:@"menu_start_s.png" target:self selector:@selector(GamemenuStart)];
            
            CCMenu* menu = [CCMenu menuWithItems:mMenuGameStart, nil];
            
            [menu alignItemsVertically];
                
            [self addChild:menu z:kTagMenu tag:kTagMenu];
        } 
        else ///guest
        {
            [self wait];
        }
        
    }
    return self;
}

-(void)wait
{
    usleep(100);
    while( !mClient.mGameStart );
    
    [self GamemenuStart];
}

-(void)GamemenuStart
{
    if( [mClient.mHost isEqualToString:@"1"] )
    {
        mClient.mState = @"1";
        [mClient send];
    }
    [[CCDirector sharedDirector]pushScene:[GamePlayScene node]];
}
@end
