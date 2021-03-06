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
#import "Packet.h"
#import "ServerAdapter.h"
#import "User.h"
#import "SoundManager.h"

#define ImageWidth 230
#define ImageHeight 306
#define MosquitoScheduleTimeCount 0.05

enum{
    kTagBackground = 0,
    kTagNomalPlayer,
    kTagAttackPlayer,
    kTagLabel,
    kTagIntro,
    kTagMosquite,
    kTagResult
};

enum{
    pTagInit = 0,
    pTagWait,
    pTagStart,
    pTagMove,
    pTagSuccess,
    pTagFail
};


enum{
    mTagMove = 0,
    mTagSpot,
    mtagStay,
    mTagAviod
};


//지나간 모기 수
static NSInteger gMosquitoCount = 0;

//잡은 모기 수
static NSInteger gScore = 0;
static CCLabelTTF* gLabelScore;

BOOL gBoolTouch = true;
BOOL gBoolReceive = true;

@implementation GamePlayLayer

@synthesize mSpriteBackground, mSpriteStartIntro, mAnimateStartIntro;
@synthesize mSpriteNomalPlayer1, mAnimateReadyPlayer1;
@synthesize mSpriteNomalPlayer2, mAnimateReadyPlayer2;
@synthesize mSpriteMosquite;
@synthesize mTimeCount, mTimeTarget, mHp;
@synthesize mLabelGameTime, mGameTime, mLabelHp;
@synthesize mSpriteCatch, mSpriteAttack_left, mSpriteAttack_right;
@synthesize mSpriteGameWin, mSpriteGameLose,mAlertView;
@synthesize mGameStart;
@synthesize mReceivePacket, mServerAdapter;
@synthesize mUser;
@synthesize mReceiveThread, mWattingThread;
@synthesize mSoundManager;
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
        
        mAnimateReadyPlayer1 = [CCAnimate alloc];
        [self createAnimate:mAnimateReadyPlayer1 runImage:@"ready_left.png" 
                  lastImage:@"nomal_left.png" delay:0.02f];
        
        mAnimateReadyPlayer2 = [CCAnimate alloc];
        [self createAnimate:mAnimateReadyPlayer2 runImage:@"ready_right.png" 
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
        
        mServerAdapter = [ServerAdapter sharedServerAdapter];
        mUser = [User sharedUser];
        
        mSoundManager = [SoundManager sharedSoundManager];
        
        //서버를 연결 했다면 기다렸다가 시작
        if( mServerAdapter.mServerOn )
        {
            mReceivePacket = [[Packet alloc]init];
            
            mWattingThread = [[NSThread alloc]initWithTarget:self selector:@selector(GameWaitting) object:nil];
            [mWattingThread start];
        }
        else // 솔로 플레이
        {
            //게임 접속 후 3초 후 시작
            mUser.mHost = [NSNumber numberWithInt:1];
            mTimeCount = 0;
            [mSpriteStartIntro runAction:[CCSequence actions:mAnimateStartIntro, [CCCallFunc actionWithTarget:self selector:@selector(GameStart)],nil]];       
        }
    }
    return self;
}

#pragma mark create

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
    mLabelGameTime = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:18];
    mLabelGameTime.anchorPoint = CGPointMake(0, 0);
    mLabelGameTime.position = CGPointMake(10, 450);
    mLabelGameTime.visible = false;
    [self addChild:mLabelGameTime];
    
    
    gLabelScore = [CCLabelTTF labelWithString:@"Score : 0" fontName:@"Arial" fontSize:18];
    gLabelScore.anchorPoint = CGPointMake(0, 0);
    gLabelScore.position = CGPointMake(200, 450);
    gLabelScore.visible = false;
    [self addChild:gLabelScore z:kTagLabel tag:kTagLabel];
    
    mLabelHp = [CCLabelTTF labelWithString:@"Hp : 5" fontName:@"Arial" fontSize:18];
    mLabelHp.anchorPoint = CGPointMake(0, 0);
    mLabelHp.position = CGPointMake(200, 390);
    mLabelHp.visible = false;
    [self addChild:mLabelHp z:kTagLabel tag:kTagLabel];
}

#pragma mark display

//점수 올라감
-(void)displayScore
{
    gScore++;
    NSString* str = [[NSString alloc]initWithFormat:@"Score : %d", gScore];
    [gLabelScore setString:str];
}

-(void)displayGameTime
{
    NSString* str = [[NSString alloc]initWithFormat:@"%d", mGameTime];
    [mLabelGameTime setString:str];
}

-(void)displayHp
{
    NSString* str = [[NSString alloc]initWithFormat:@"Hp : %d", mHp];
    [mLabelHp setString:str];    
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
    
    gBoolTouch = true;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    sleep(1); //Win or Lose 1초동안 보여주기 위하여
    
    [self removeChild:mSpriteGameWin cleanup:YES];
    [self removeChild:mSpriteGameLose cleanup:YES];
    
    if( buttonIndex == 0 ) // 취소
    {
        [[CCDirector sharedDirector]pushScene:[GameMainScene node]];
    }
    else if( buttonIndex == 1 ) //확인 
    {
        mWattingThread = [[NSThread alloc]initWithTarget:self selector:@selector(GameWaitting) object:nil];
        [mWattingThread start];
    }
}


#pragma mark event

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if( mGameStart == true )
    {
        if( gBoolTouch == true )
        {
            
            NSLog(@"touch");
            gBoolTouch = false;
            Packet* sendPacket = [[Packet alloc]init];
            
            if( [mSpriteMosquite checkCollision] ) //모기 충돌 체크
            {
                if( mServerAdapter.mServerOn )
                {
                    sendPacket.mState = [NSNumber numberWithInt:pTagSuccess];
                    [sendPacket SetPacketWithUser:mUser];
                    sendPacket.mX = [NSNumber numberWithInt:1];
                    sendPacket.mY = [NSNumber numberWithInt:1];
                    [mServerAdapter send:sendPacket];
                }
                else
                {
                    [self CatchSuccess];
                }
            }
            else  //실패, 싸다구
            {
                if( mServerAdapter.mServerOn )
                {
                    sendPacket.mState = [NSNumber numberWithInt:pTagFail];
                    [sendPacket SetPacketWithUser:mUser];
                    sendPacket.mX = [NSNumber numberWithInt:1];
                    sendPacket.mY = [NSNumber numberWithInt:1];
                    [mServerAdapter send:sendPacket];
                }
                else 
                {
                    [self CatchFail];
                }
            }
        }
    }
}


-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

#pragma mark schedule
//Room에 player가 두명 들어 올때까지 대기
-(void)GameWaitting
{
    while(true)
    {
        [NSThread sleepForTimeInterval:0.1];
        
        Packet* sendPacket = [[Packet alloc]init];
        sendPacket.mState = [NSNumber numberWithInt:pTagWait];
        [sendPacket SetPacketWithUser:mUser];
        
        [mServerAdapter send:sendPacket];
        
        mReceivePacket = [mServerAdapter receive];
        if( [mReceivePacket.mState intValue] == pTagStart ) //서버에서 게임 시작을 알리면.
        {
            [mWattingThread cancel];
            break;
        }
    }
    
    //게임 접속 후 3초 후 시작
    mTimeCount = 0;
    [mSpriteStartIntro runAction:[CCSequence actions:mAnimateStartIntro, [CCCallFunc actionWithTarget:self selector:@selector(GameStart)],nil]];
}


//start intro 끝나고 나서 호출됨.
-(void)GameStart
{
    [mSpriteStartIntro stopAllActions];
    [self unscheduleAllSelectors];
    //인트로 끝내고, display초기화
    mSpriteStartIntro.visible = FALSE;
    mGameStart = true;
    gScore = 0;
    gMosquitoCount = 0;
    mGameTime = 0;
    mHp = 5;
    NSLog(@"Game Start!!");
    
    //모기,display화면에 출력
    mSpriteMosquite.visible = true;
    gLabelScore.visible = true;
    mLabelGameTime.visible = true;
    mLabelHp.visible = true;
    
    NSString* str = [[NSString alloc]initWithFormat:@"Score : %d", gScore];
    [gLabelScore setString:str];
    
    mSpriteGameWin.visible = false;
    mSpriteGameLose.visible = false;
    
   // [self schedule:@selector(GameFlowTime) interval:1.0f]; //30초 제한 카운트
    
    gBoolReceive = true;
    
    //서버의 패킷을 계속 받기 위하여
    mReceiveThread = [[NSThread alloc]initWithTarget:self selector:@selector(ReceivingServer) object:nil];
    [mReceiveThread start];
    gBoolReceive = true;
    
    gBoolTouch = true;
    
    mSpriteMosquite.mTimeTarget = 1.5f;
    [mSpriteMosquite moveSetting];
    [mSoundManager playSystemSound:@"mosquito" fileType:@"wav"];
    [self schedule:@selector(GameMosquitoMove) interval:MosquitoScheduleTimeCount];
}

//모기 움직임 관리
-(void)GameMosquitoMove
{
    if( [mUser.mHost intValue] )
    {
        switch (mSpriteMosquite.mState) {
            case mTagMove :
                if( [mSpriteMosquite isMove] ) //move 조건이 끝났을 때 다음 단계로
                {
                    mSpriteMosquite.mState = mTagSpot;
                    [mSpriteMosquite moveSpotSetting];
                }
                else
                    [mSpriteMosquite move];
                break;
            case mTagSpot :
                if( [mSpriteMosquite isMoveSpot] )
                {
                    mSpriteMosquite.mState = mtagStay;                
                }
                else 
                    [mSpriteMosquite moveSpot];                
                
                break;
            case mtagStay :
                if( [mSpriteMosquite isMoveStay] )
                {
                    mSpriteMosquite.mState = mTagAviod;
                }
                [mSpriteMosquite moveStay];
                break;
            case mTagAviod :
                if( [mSpriteMosquite isMoveAvoid] ) //모기가 다 피하고
                {
                    mSpriteMosquite.mState = mTagMove; 
                    [mSpriteMosquite moveSetting]; //새로시작                       
                    [mSoundManager playSystemSound:@"mosquito" fileType:@"wav"];                 
                }
                else
                    [mSpriteMosquite moveAvoid];
                break;
            default:
                break;
        }
    
        Packet* sendPacket = [[Packet alloc]init];
        sendPacket.mState = [NSNumber numberWithInt:pTagMove];
        [sendPacket SetPacketWithUser:mUser];
        sendPacket.mX = [NSNumber numberWithInt:mSpriteMosquite.position.x];
        sendPacket.mY = [NSNumber numberWithInt:mSpriteMosquite.position.y];
    
        [mServerAdapter send:sendPacket];
    }
}

-(void)GameFlowTime
{   
    mGameTime++;
    [self displayGameTime];
    if( mGameTime == 30 )
    {
        [self GameEnd];
    }
}

-(void)GameEnd
{   
    if( mHp >= 1 )
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
    
    gBoolTouch = false;
    gBoolReceive = false;
    mSpriteAttack_left.visible = false;
    mSpriteAttack_right.visible = false;
    mSpriteCatch.visible = false;
    
    mLabelGameTime.visible = false;
    gLabelScore.visible = false;
    mLabelHp.visible = false;
    
    mGameTime = 0;
    gScore = 0;
    gMosquitoCount = 0;
    mHp = 0;
    
    [mReceiveThread cancel]; 
    [self unscheduleAllSelectors];

    [mAlertView show]; //게임 재시작 또는 취소 여부 묻는 경고창.
}

-(void)ReceivingServer
{
    //게임이 종료상황( win, lose )일 때 멈추기 위하여, 재시작할때는 다시 수행.
    while(gBoolReceive)
    {
        [NSThread sleepForTimeInterval:0.03];
        mReceivePacket = [mServerAdapter receive];
        switch ([mReceivePacket.mState intValue]) {
            case pTagMove: //모기 날라가는 패킷
                if( ![mUser.mHost intValue] ) //호스트가 아닐 때만 위치를 받는다.
                {
                    CGPoint newPo = CGPointMake([mReceivePacket.mX intValue], [mReceivePacket.mY intValue]);
                    [mSpriteMosquite setPosition:newPo];
                }
                break;
            case pTagSuccess :
                [self performSelectorOnMainThread:@selector(CatchSuccess) withObject:nil waitUntilDone:YES];
                break;
            case pTagFail :
                [self performSelectorOnMainThread:@selector(CatchFail) withObject:nil waitUntilDone:YES];
                break;
            default:
                break;
        }
    }
}


//모기 잡는 것이 성공할 때
-(void)CatchSuccess
{   
    [mSoundManager playSystemSound:@"hit" fileType:@"aif"];
    //팔동작
    [mSpriteNomalPlayer1 runAction:[CCSequence actions:mAnimateReadyPlayer1, nil]];
    [mSpriteNomalPlayer2 runAction:[CCSequence actions:mAnimateReadyPlayer2, nil]];
    
    //가운데에 모기 잡는 모션
    mSpriteCatch.visible = true;
    id action = [CCDelayTime actionWithDuration:0.6f];
    [mSpriteCatch runAction:[CCSequence actions:action, [CCCallFunc actionWithTarget:self selector:@selector(completeAnimate)], nil]];
    
    //모기 레벨 업
    [mSpriteMosquite LevelUp];
    mSpriteMosquite.position = CGPointMake(10, 300);
    [mSpriteMosquite moveSetting];
    mSpriteMosquite.mState = mTagMove;
    
    gMosquitoCount++;
    [self displayScore];
}

//모기 잡는 것이 실패할 때
-(void)CatchFail
{
    [mSoundManager playSystemSound:@"ssadacktion" fileType:@"aif"];
    id action = [CCDelayTime actionWithDuration:0.6f];  
    
    //보낸 사람이 Host(왼쪽) 라면 
    if( [mReceivePacket.mHost intValue] ) //host는 왼쪽
    {
        [mSpriteNomalPlayer1 runAction:[CCSequence actions:mAnimateReadyPlayer1, nil]]; //왼쪽이 때리고
        
        mSpriteAttack_right.visible = true;      
        [mSpriteAttack_right runAction:[CCSequence actions:action, [CCCallFunc actionWithTarget:self selector:@selector(completeAnimate)], nil]];//오른쪽이 맞음  
    } 
    else
    {
        [mSpriteNomalPlayer2 runAction:[CCSequence actions:mAnimateReadyPlayer2, nil]]; //오른쪽이 때리고
        
        mSpriteAttack_left.visible = true;
        [mSpriteAttack_left runAction:[CCSequence actions:action, [CCCallFunc actionWithTarget:self selector:@selector(completeAnimate)], nil]]; //왼쪽이 맞음              
    }
    
    mHp--;
    [self displayHp];
    if( mHp <= 0 ) //hp떨어져서 죽을 때
    {
        [self GameEnd];
        return;
    }
    
    mSpriteMosquite.position = CGPointMake(10, 300); //모기의 처음 위치
    [mSpriteMosquite moveSetting];
    mSpriteMosquite.mState = mTagMove;
}

@end
