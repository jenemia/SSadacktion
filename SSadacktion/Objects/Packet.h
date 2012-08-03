//
//  Client.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 22..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Packet : NSObject

@property (strong, nonatomic) NSNumber* mState;
@property (strong, nonatomic) NSNumber* mRoom;
@property (strong, nonatomic) NSNumber* mPlayer;
@property (strong, nonatomic) NSNumber* mX;
@property (strong, nonatomic) NSNumber* mY;
@property (strong, nonatomic) NSNumber* mHost;

-(void)SetPacketWithUser:(User*) user;
@end
