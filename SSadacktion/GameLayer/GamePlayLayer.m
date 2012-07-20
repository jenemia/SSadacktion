//
//  GamePlayLayer.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "GamePlayLayer.h"

enum{
    kTagBackground = 0,
};

@implementation GamePlayLayer

@synthesize mSpriteBackground;
@synthesize mSpritePlayer1, mSPritePlayer2;

-(id)init
{
    if( self = [super init] )
    {
        mSpriteBackground = [CCSprite spriteWithFile:@"background.png"];
        mSpriteBackground.anchorPoint = CGPointZero;
        [mSpriteBackground setPosition:CGPointMake(0, 0)];
        
        [self addChild:mSpriteBackground z:kTagBackground tag:kTagBackground];
        
        
    }
    return self;
}

@end
