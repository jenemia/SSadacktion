//
//  CMosquito.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "cocos2d.h"

@interface CMosquito : CCSprite

@property (nonatomic) NSInteger mTimeCount;
@property (nonatomic) CGFloat mTimeTarget;
@property (nonatomic) CGFloat mTimeStay;

@property (nonatomic) NSInteger mMoveVelocityX;
@property (nonatomic) NSInteger mMoveVelocityY;

-(void)moveStart;
-(BOOL)checkCollision;
@end
