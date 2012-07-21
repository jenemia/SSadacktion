//
//  JSONPacket.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONPacket : NSObject

@property (strong, nonatomic) NSString* mUserName;
@property (strong, nonatomic) NSString* mRoom;
@property (strong, nonatomic) NSString* mPlayer;
@property (strong, nonatomic) NSString* mScore;
@property (strong, nonatomic) NSString* mState;
@property (strong, nonatomic) NSString* mPlayState;
@property (strong, nonatomic) NSString* mPositionX;
@property (strong, nonatomic) NSString* mPositionY;
@end
