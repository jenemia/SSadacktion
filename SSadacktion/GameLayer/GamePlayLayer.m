//
//  GamePlayLayer.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "GamePlayLayer.h"
#import "GameMainScene.h"
#import "CMosquito.h"

#define ImageWidth 230
#define ImageHeight 306

enum{
    kTagBackground = 0,
    kTagNomalPlayer,
    kTagAttackPlayer,
    kTagLabel,
    kTagIntro,
    kTagMosquite,
    kTagResult
};

//지나간 모기 수
static CCLabelTTF* gLabelMosquitoCount;
static NSInteger gMosquitoCount = 0;

//잡은 모기 수
static NSInteger gScore = 0;
static CCLabelTTF* gLabelScore;

BOOL gBoolTouch = true;

@implementation GamePlayLayer

@synthesize mSpriteBackground, mSpriteStartIntro, mAnimateStartIntro;
@synthesize mSpriteNomalPlayer1, mAnimateAttackPlayer1, mAnimateCatchPlayer1;
@synthesize mSpriteNomalPlayer2, mAnimateAttackPlayer2, mAnimateCatchPlayer2;
@synthesize mSpriteMosquite;
@synthesize mTimeCount, mTimeTarget, mHp;
@synthesize mGameStart;
@synthesize mLabelGameTime, mGameTime, mLabelHp;
@synthesize mSpriteCatch, mSpriteAttack_left, mSpriteAttack_right;
@synthesize mSpriteGameWin, mSpriteGameLose;
@synthesize mAlertView;

-(id)init
{
    if( self = [super init] )
    {
        self.isTouchEnabled = YES;
        mGameStart = false;
        gScore = 0;
        gMosquitoCount = 0;
        mGameTime = 0;
        mHp = 5;
        
        [self createBackground];
        [self createPlayer];
        
        mAnimateAttackPlayer1 = [CCAnimate alloc];
        [self createAnimate:mAnimateAttackPlayer1 runImage:@"catch_left.png" 
                  lastImage:@"nomal_left.png" delay:0.02f];
        
        mAnimateCatchPlayer1 = [CCAnimate alloc];
        [self createAnimate:mAnimateCatchPlayer1 runImage:@"catch_left.png" 
                  lastImage:@"nomal_left.png" delay:0.02f];
        
        mAnimateAttackPlayer2 = [CCAnimate alloc];
        [self createAnimate:mAnimateAttackPlayer2 runImage:@"catch_right.png" 
                  lastImage:@"nomal_right.png" delay:0.02f];
        
        mAnimateCatchPlayer2 = [CCAnimate alloc];
        [self createAnimate:mAnimateCatchPlayer2 runImage:@"catch_right.png" 
                  lastImage:@"nomal_right.png" delay:0.02f];
        
        [self createLabels];
        
        //모기        
        mSpriteMosquite = [[CMosquito alloc]initWithFile:@"mosquito.png"];
        
        mSpriteMosquite.anchorPoint = CGPointMake(0, 0);
        mSpriteMosquite.position = CGPointMake(10, 300);
        mSpriteMosquite.visible = false;
        [self addChild:mSpriteMosquite z:kTagMosquite tag:kTagMosquite];
        
        mAlertView = [[UIAlertView alloc] initWithTitle:@"게임 메세지" message:@"다시 시작하겠습니까?" delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인",nil];
        mAlertView.delegate = self;
        
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
    
    mSpriteAttack_left = [[CCSprite alloc]initWithFile:@"attack_left.png"];
    mSpriteAttack_left.anchorPoint = CGPointMake(0, 0);
    mSpriteAttack_left.position = CGPointMake(0 , 150);
    mSpriteAttack_left.visible = false;
    [self addChild:mSpriteAttack_left z:kTagResult tag:kTagResult];
    
    mSpriteAttack_right = [[CCSprite alloc]initWithFile:@"attack_right.png"];
    mSpriteAttack_right.anchorPoint = CGPointMake(0, 0);
    mSpriteAttack_right.position = CGPointMake(140, 130);
    mSpriteAttack_right.visible = false;
    [self addChild:mSpriteAttack_right z:kTagResult tag:kTagResult];
    
    mSpriteCatch = [[CCSprite alloc]initWithFile:@"catch.png"];
    mSpriteCatch.anchorPoint = CGPointMake(0, 0);
    mSpriteCatch.position = CGPointMake(50, 100);
    mSpriteCatch.visible = false;
    [self addChild:mSpriteCatch z:kTagResult tag:kTagResult];
}

-(void)createPlayer
{
    mSpriteNomalPlayer1 = [[CCSprite alloc]initWithFile:@"nomal_left.png"];
    mSpriteNomalPlayer1.anchorPoint = CGPointMake(0, 0);
    mSpriteNomalPlayer1.position = CGPointMake(-20, 10);
    [self addChild:mSpriteNomalPlayer1 z:kTagNomalPlayer tag:kTagNomalPlayer];
    
    mSpriteNomalPlayer2 = [[CCSprite alloc]initWithFile:@"nomal_right.png"];
    mSpriteNomalPlayer2.anchorPoint = CGPointMake(0, 0);
    mSpriteNomalPlayer2.position = CGPointMake(120, 10);
    [self addChild:mSpriteNomalPlayer2 z:kTagNomalPlayer tag:kTagNomalPlayer];
}

-(void)createAnimate:(CCAnimate*)animate runImage:(NSString*)runImage lastImage:(NSString*)lastImage delay:(float)delay
{
    NSMutableArray* aniFrame = [NSMutableArray array];
    
    //attack 애니메이션 생성. 마지막에 nomal sprite추가하여 원래대로 되돌아 오기.
    CCSprite* sprite = [[CCSprite alloc]initWithFile:runImage];

    for( NSInteger idx=1; idx<10; idx++ )
    {
        CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:sprite.texture rect:CGRectMake(0, 0, ImageWidth, ImageHeight)];
        [aniFrame addObject:frame];
    }
    
    sprite = [[CCSprite alloc]initWithFile:lastImage];
    
    CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:sprite.texture rect:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    [aniFrame addObject:frame];
    
CCAnimation* animation = [CCAnimation animationWithFrames:aniFrame delay:delay];
    animate = [animate initWithAnimation:animation restoreOriginalFrame:NO];
}

-(void)createLabels
{
    gLabelScore = [CCLabelTTF labelWithString:@"Score : 0" fontName:@"Arial" fontSize:18];
    gLabelScore.anchorPoint = CGPointMake(0, 0);
    gLabelScore.position = CGPointMake(200, 450);
    gLabelScore.visible = false;
    [self addChild:gLabelScore z:kTagLabel tag:kTagLabel];
    
    gLabelMosquitoCount = [CCLabelTTF labelWithString:@"Mosquito : 0" fontName:@"Arial" fontSize:18];
    gLabelMosquitoCount.anchorPoint = CGPointMake(0, 0);
    gLabelMosquitoCount.position = CGPointMake(200, 420);
    gLabelMosquitoCount.visible = false;
    [self addChild:gLabelMosquitoCount z:kTagLabel tag:kTagLabel];
    
    mLabelGameTime = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:18];
    mLabelGameTime.anchorPoint = CGPointMake(0, 0);
    mLabelGameTime.position = CGPointMake(10, 450);
    mLabelGameTime.visible = false;
    [self addChild:mLabelGameTime];
    
    mLabelHp = [CCLabelTTF labelWithString:@"Hp : 5" fontName:@"Arial" fontSize:18];
    mLabelHp.anchorPoint = CGPointMake(0, 0);
    mLabelHp.position = CGPointMake(200, 390);
    mLabelHp.visible = false;
    [self addChild:mLabelHp z:kTagLabel tag:kTagLabel];
}
//점수 올라감
+(void)displayScore
{
    gScore++;
    NSString* str = [[NSString alloc]initWithFormat:@"Score : %d", gScore];
    [gLabelScore setString:str];
}

//모기 숫자 올라감
+(void)displayMosquito
{
    gMosquitoCount++;
    NSString* str = [[NSString alloc]initWithFormat:@"Mosquito : %d", gMosquitoCount];
    [gLabelMosquitoCount setString:str];
}

-(void)displayGameTime
{
    mGameTime++;
    NSString* str = [[NSString alloc]initWithFormat:@"%d", mGameTime];
    [mLabelGameTime setString:str];
}

-(void)displayHp
{
    NSString* str = [[NSString alloc]initWithFormat:@"Hp : %d", mHp];
    [mLabelHp setString:str];    
}

+(void)BoolTouch:(BOOL)result
{
    gBoolTouch = result;
}

-(void)completeAnimate
{
    NSLog(@"compelete");
    [mSpriteNomalPlayer1 stopAllActions];
    [mSpriteNomalPlayer2 stopAllActions];
    [mSpriteCatch stopAllActions];
    [mSpriteAttack_left stopAllActions];
    mSpriteCatch.visible = false;
    mSpriteAttack_left.visible = false;
    mSpriteAttack_right.visible = false;
}

#pragma mark schedule
//start intro 끝나고 나서 호출됨.
-(void)IntroEnd
{
    mSpriteStartIntro.visible = FALSE;
    mGameStart = true;
    gScore = 0;
    gMosquitoCount = 0;
    mGameTime = 0;
    mHp = 5;
    NSLog(@"Game Start!!");
    
    mSpriteMosquite.visible = true;
    gLabelScore.visible = true;
    gLabelMosquitoCount.visible = true;
    mLabelGameTime.visible = true;
    mLabelHp.visible = true;
    
    NSString* str = [[NSString alloc]initWithFormat:@"Score : %d", gScore];
    [gLabelScore setString:str];
    
    mSpriteGameWin = false;
    mSpriteGameLose = false;
    
    [self schedule:@selector(gameStartTime) interval:1.0f];
    
    mSpriteMosquite.position = CGPointMake(10, 300);
    mSpriteMosquite.mTimeTarget = 1.5f;
    [mSpriteMosquite moveStart];
}

-(void)gameStartTime
{   
    [self displayGameTime];
    if( mGameTime == 30 )
    {
        [self GameEnd];
    }
}

-(void)GameEnd
{
    NSLog(@"GameEnd");
    gBoolTouch = false;
    mSpriteAttack_left.visible = false;
    mSpriteAttack_right.visible = false;
    mSpriteCatch.visible = false;
    
    if( gScore >= 4 )
    {
        NSLog(@"win");
        mSpriteGameWin = [[CCSprite alloc]initWithFile:@"win.png"];
        mSpriteGameWin.anchorPoint = CGPointMake(0, 0);
        mSpriteGameWin.position = CGPointMake(50, 320);
        [self addChild:mSpriteGameWin z:kTagIntro tag:kTagIntro];
    }
    else
    {
        NSLog(@"lose");
        mSpriteGameLose = [[CCSprite alloc]initWithFile:@"lose.png"];
        mSpriteGameLose.anchorPoint = CGPointMake(0, 0);
        mSpriteGameLose.position = CGPointMake(50, 320);
        [self addChild:mSpriteGameLose z:kTagIntro tag:kTagIntro];
    }

    [mSpriteMosquite initNotAlloc];
    mSpriteMosquite.visible = false;
    [self unscheduleAllSelectors];
    mGameTime = 0;
    gScore = 0;
    gMosquitoCount = 0;
    mHp = 0;
    mLabelGameTime.visible = false;
    gLabelScore.visible = false;
    gLabelMosquitoCount.visible = false;
    mLabelHp.visible = false;
    
    sleep(1);
    [mAlertView show]; //게임 재시작 또는 취소 여부 묻는 경고창.
    NSLog(@"게임종료");
}

#pragma mark event
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if( mGameStart == true )
    {
        if( gBoolTouch == true )
        {
            gBoolTouch = false;
            
            if( [mSpriteMosquite checkCollision] ) //모기 충돌 체크
            {
                [mSpriteNomalPlayer1 runAction:[CCSequence actions:mAnimateAttackPlayer1, nil]];
                [mSpriteNomalPlayer2 runAction:[CCSequence actions:mAnimateAttackPlayer2, nil]];

                mSpriteCatch.visible = true;
                id action = [CCDelayTime actionWithDuration:0.6f];
                [mSpriteCatch runAction:[CCSequence actions:action, [CCCallFunc actionWithTarget:self selector:@selector(completeAnimate)], nil]];
                
                [mSpriteMosquite LevelUp];
                mSpriteMosquite.position = CGPointMake(10, 300);
                [mSpriteMosquite moveStart];
            }
            else  //실패, 싸다구
            {
                [mSpriteNomalPlayer1 runAction:[CCSequence actions:mAnimateCatchPlayer1, nil]];
                [mSpriteNomalPlayer2 runAction:[CCSequence actions:mAnimateCatchPlayer2, nil]];
                
                mSpriteAttack_left.visible = true;
                id action = [CCDelayTime actionWithDuration:0.6f];         
                [mSpriteAttack_left runAction:[CCSequence actions:action, [CCCallFunc actionWithTarget:self selector:@selector(completeAnimate)], nil]]; 
                
                mSpriteAttack_right.visible = true;
                [mSpriteAttack_right runAction:[CCSequence actions:action, [CCCallFunc actionWithTarget:self selector:@selector(completeAnimate)], nil]]; 

                mHp--;
                [self displayHp];
                if( mHp <= 0 ) //hp떨어져서 죽을 때
                {
                    [self GameEnd];
                    return;
                }
                
                mSpriteMosquite.position = CGPointMake(10, 300); //모기의 처음 위치
                [mSpriteMosquite moveStart];
            }
                        
        }
    }
}


-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 ) // 취소
    {
        [[CCDirector sharedDirector]pushScene:[GameMainScene node]];
    }
    else if( buttonIndex == 1 ) //확인 
    {
        [self IntroEnd];
    }
}

@end
