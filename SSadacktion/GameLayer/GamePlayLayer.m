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
@synthesize mSpriteNomalPlayer1, mAnimateAttackPlayer1, mAnimateCatchPlayer1;
@synthesize mSpriteNomalPlayer2, mAnimateAttackPlayer2, mAnimateCatchPlayer2;

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
        mAnimateAttackPlayer1 = [CCAnimate alloc];
        [self createAnimate:mAnimateAttackPlayer1 runImage:@"attack_left.png" 
                  lastImage:@"nomal_left.png"];
        
        mAnimateCatchPlayer1 = [CCAnimate alloc];
        [self createAnimate:mAnimateCatchPlayer1 runImage:@"catch_left.png" 
                  lastImage:@"nomal_left.png"];
        
        mAnimateAttackPlayer2 = [CCAnimate alloc];
        [self createAnimate:mAnimateAttackPlayer2 runImage:@"attack_right.png" 
                  lastImage:@"nomal_right.png"];
        
        mAnimateCatchPlayer2 = [CCAnimate alloc];
        [self createAnimate:mAnimateCatchPlayer2 runImage:@"catch_right.png" 
                  lastImage:@"nomal_right.png"];
    }
    return self;
}


#pragma mark method

-(void)createPlayer
{
    mSpriteNomalPlayer1 = [[CCSprite alloc]initWithFile:@"nomal_left.png"];
    mSpriteNomalPlayer1.anchorPoint = CGPointMake(0, 0);
    mSpriteNomalPlayer1.position = CGPointMake(20, 10);
    [self addChild:mSpriteNomalPlayer1 z:kTagNomalPlayer tag:kTagNomalPlayer];
    
    mSpriteNomalPlayer2 = [[CCSprite alloc]initWithFile:@"nomal_right.png"];
    mSpriteNomalPlayer2.anchorPoint = CGPointMake(0, 0);
    mSpriteNomalPlayer2.position = CGPointMake(150, 10);
    [self addChild:mSpriteNomalPlayer2 z:kTagNomalPlayer tag:kTagNomalPlayer];
}

-(void)createAnimate:(CCAnimate*)animate runImage:(NSString*)runImage lastImage:(NSString*)lastImage
{
    NSMutableArray* aniFrame = [NSMutableArray array];
    
    //attack 애니메이션 생성. 마지막에 nomal sprite추가하여 원래대로 되돌아 오기.
    CCSprite* sprite = [[CCSprite alloc]initWithFile:runImage];

    for( NSInteger idx=1; idx<10; idx++ )
    {
        CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:sprite.texture rect:CGRectMake(0, 0, 150, 250)];
        [aniFrame addObject:frame];
    }
    
    //왼쪽이면 flipX는 FALSE, 오른쪽이면 YES
    sprite = [[CCSprite alloc]initWithFile:lastImage];
    
    CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:sprite.texture rect:CGRectMake(0, 0, 150, 250)];
    [aniFrame addObject:frame];
    
    CCAnimation* animation = [CCAnimation animationWithFrames:aniFrame delay:0.02f];
    animate = [animate initWithAnimation:animation restoreOriginalFrame:NO];
}

-(void)completeAnimateA
{
    [mSpriteNomalPlayer1 stopAllActions];
}
-(void)completeAnimateB
{
    [mSpriteNomalPlayer2 stopAllActions];
}

#pragma mark event
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [mSpriteNomalPlayer1 runAction:[CCSequence actions:mAnimateAttackPlayer1, [CCCallFunc actionWithTarget:self selector:@selector(completeAnimateA)],nil]];
    [mSpriteNomalPlayer2 runAction:[CCSequence actions:mAnimateAttackPlayer2, [CCCallFunc actionWithTarget:self selector:@selector(completeAnimateB)],nil]];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end
