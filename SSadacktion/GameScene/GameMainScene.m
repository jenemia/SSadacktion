//
//  GameMain.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "GameMainScene.h"
#import "GameMainLayer.h"


@implementation GameMainScene

@synthesize mLayerGameMain;

-(id)init
{
    if( ![super init] )
        return nil;
    
    mWinSize = [[CCDirector sharedDirector]winSize];
    mLayerGameMain = [GameMainLayer node];
    [self addChild:mLayerGameMain];
    
    return self;
}

@end
