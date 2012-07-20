//
//  GamePlaye.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "GamePlayScene.h"
#import "GamePlayLayer.h"

@implementation GamePlayScene

@synthesize mLayerGamePlay;

-(id)init
{
    if( self = [super init] )
    {
        mLayerGamePlay = [GamePlayLayer node];
        [self addChild:mLayerGamePlay];
    }
    return self;
}

@end
