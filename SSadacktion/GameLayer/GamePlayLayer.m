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
    kTagNomalPlayer,
    kTagAttackPlayer
};

@implementation GamePlayLayer

@synthesize mSpriteBackground;
@synthesize mSpriteNomalPlayer1, mSpriteAttackPlayer1;
@synthesize mSpriteNomalPlayer2, mSpriteAttackPlayer2;

-(id)init
{
    if( self = [super init] )
    {
        self.isTouchEnabled = YES;
        mSpriteBackground = [CCSprite spriteWithFile:@"background.png"];
        mSpriteBackground.anchorPoint = CGPointMake(0, 0);
        [mSpriteBackground setPosition:CGPointMake(0, 0)];
        
        [self addChild:mSpriteBackground z:kTagBackground tag:kTagBackground];
        
        [self createPlayer];
    }
    return self;
}


#pragma mark method

-(void)createPlayer
{
    mSpriteNomalPlayer1 = [[CCSprite alloc]initWithFile:@"nomal.png"];
    mSpriteNomalPlayer1.anchorPoint = CGPointMake(0, 0);
    mSpriteNomalPlayer1.position = CGPointMake(20, 10);
    [self addChild:mSpriteNomalPlayer1 z:kTagNomalPlayer tag:kTagNomalPlayer];
    
    mSpriteAttackPlayer1 = [[CCSprite alloc]initWithFile:@"attack.png"];
    mSpriteAttackPlayer1.anchorPoint = CGPointMake(0,0);
    mSpriteAttackPlayer1.position = mSpriteNomalPlayer1.position;
    mSpriteAttackPlayer1.visible = false;
    [self addChild:mSpriteAttackPlayer1 z:kTagAttackPlayer tag:kTagAttackPlayer];
    
    mSpriteNomalPlayer2 = [[CCSprite alloc]initWithFile:@"nomal.png"];
    mSpriteNomalPlayer2.anchorPoint = CGPointMake(0, 0);
    mSpriteNomalPlayer2.position = CGPointMake(180, 10);
    mSpriteNomalPlayer2.flipX = YES;
    [self addChild:mSpriteNomalPlayer2 z:kTagNomalPlayer tag:kTagNomalPlayer];
    
    mSpriteAttackPlayer2 = [[CCSprite alloc]initWithFile:@"attack.png"];
    mSpriteAttackPlayer2.anchorPoint = CGPointMake(0, 0);
    mSpriteAttackPlayer2.position = CGPointMake(180, 10);
    mSpriteAttackPlayer2.flipX = YES;
    mSpriteAttackPlayer2.visible = false;
    [self addChild:mSpriteAttackPlayer2 z:kTagAttackPlayer tag:kTagAttackPlayer];    
}

#pragma mark event
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"began");
    mSpriteNomalPlayer1.visible = FALSE;
    mSpriteAttackPlayer1.visible = YES;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"ended");    
    mSpriteNomalPlayer1.visible = YES;
    mSpriteAttackPlayer1.visible = FALSE;
}

@end
