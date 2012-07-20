//
//  GamePlayLayer.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "GamePlayLayer.h"
#import "CMosquito.h"

enum{
    kTagBackground = 0,
    kTagNomalPlayer,
    kTagAttackPlayer,
    kTagIntro,
    kTagLabel,
    kTagMosquite
};

CCLabelTTF* gLabelMosquitoCount;
NSInteger gMosquitoCount;

@implementation GamePlayLayer

@synthesize mSpriteBackground, mSpriteStartIntro, mAnimateStartIntro;
@synthesize mSpriteNomalPlayer1, mAnimateAttackPlayer1, mAnimateCatchPlayer1;
@synthesize mSpriteNomalPlayer2, mAnimateAttackPlayer2, mAnimateCatchPlayer2;
@synthesize mSpriteMosquite;
@synthesize mTimeCount, mTimeTarget;
@synthesize mGameStart;
@synthesize mScore,mLabelScore;

-(id)init
{
    if( self = [super init] )
    {
        self.isTouchEnabled = YES;
        mGameStart = false;
        mScore = 0;
        gMosquitoCount = 0;
        
        [self createBackground];
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
        
        [self createLabels];
        
        //모기        
        mSpriteMosquite = [[CMosquito alloc]initWithFile:@"mosquito.png"];
        
        mSpriteMosquite.anchorPoint = CGPointMake(0, 0);
        mSpriteMosquite.position = CGPointMake(10, 300);
        mSpriteMosquite.visible = false;
        [self addChild:mSpriteMosquite z:kTagMosquite tag:kTagMosquite];
        
        //게임 접속 후 3초 후 시작
        mTimeCount = 0;
        [mSpriteStartIntro runAction:[CCSequence actions:mAnimateStartIntro, [CCCallFunc actionWithTarget:self selector:@selector(IntroEnd)],nil]];
        
    }
    return self;
}


#pragma mark method

-(void)createBackground
{
    mSpriteBackground = [CCSprite spriteWithFile:@"background.png"];
    mSpriteBackground.anchorPoint = CGPointMake(0, 0);
    [mSpriteBackground setPosition:CGPointMake(0, 0)];
    
    [self addChild:mSpriteBackground z:kTagBackground tag:kTagBackground];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"StartIntro.plist"];
    
    NSMutableArray* aniFrames = [NSMutableArray array];
    
    for( NSInteger idx=1; idx<=5; idx++ )
    {
        CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:[NSString stringWithFormat:@"0%d.png", idx]];
        [aniFrames addObject:frame];
    }
    
    CCAnimation* animation = [CCAnimation animationWithFrames:aniFrames delay:1];
    mAnimateStartIntro = [[CCAnimate alloc]initWithAnimation:animation restoreOriginalFrame:NO];

    mSpriteStartIntro = [CCSprite spriteWithSpriteFrameName:@"01.png"];
    mSpriteStartIntro.anchorPoint = CGPointMake(0, 0);
    mSpriteStartIntro.position = CGPointMake(50, 320);
    [self addChild:mSpriteStartIntro z:kTagIntro tag:kTagIntro];
}

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

-(void)createLabels
{
    mLabelScore = [CCLabelTTF labelWithString:@"Score : 0" fontName:@"Arial" fontSize:18];
    mLabelScore.anchorPoint = CGPointMake(0, 0);
    mLabelScore.position = CGPointMake(200, 450);
    [self addChild:mLabelScore z:kTagLabel tag:kTagLabel];
    
    gLabelMosquitoCount = [CCLabelTTF labelWithString:@"Mosquito : 0" fontName:@"Arial" fontSize:18];
    gLabelMosquitoCount.anchorPoint = CGPointMake(0, 0);
    gLabelMosquitoCount.position = CGPointMake(200, 420);
    [self addChild:gLabelMosquitoCount z:kTagLabel tag:kTagLabel];
}

-(void)completeAnimateA
{
    [mSpriteNomalPlayer1 stopAllActions];
}
-(void)completeAnimateB
{
    [mSpriteNomalPlayer2 stopAllActions];
}

-(void)displayScore:(NSInteger)score
{
    NSString* str = [[NSString alloc]initWithFormat:@"Score : %d", score];
    [mLabelScore setString:str];
}

+(void)displayMosquito
{
    gMosquitoCount++;
    NSString* str = [[NSString alloc]initWithFormat:@"Mosquito : %d", gMosquitoCount];
    [gLabelMosquitoCount setString:str];
}
#pragma mark schedule
//start intro 끝나고 나서 호출됨.
-(void)IntroEnd
{
    mSpriteStartIntro.visible = FALSE;
    mGameStart = true;
    NSLog(@"Game StarT!!");
    
    mSpriteMosquite.visible = true;
    [mSpriteMosquite moveStart];
}

#pragma mark event
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if( mGameStart == true )
    {
        [mSpriteNomalPlayer1 runAction:[CCSequence actions:mAnimateAttackPlayer1, [CCCallFunc actionWithTarget:self selector:@selector(completeAnimateA)],nil]];
        [mSpriteNomalPlayer2 runAction:[CCSequence actions:mAnimateAttackPlayer2, [CCCallFunc actionWithTarget:self selector:@selector(completeAnimateB)],nil]];
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end
