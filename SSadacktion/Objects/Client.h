//
//  Client.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 22..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject

@property (nonatomic) NSInteger mSocket;

@property (nonatomic) NSInteger mState;
@property (nonatomic) NSInteger mRoom;
@property (nonatomic) NSInteger mPlayer;
@property (nonatomic) NSInteger mX;
@property (nonatomic) NSInteger mY;
@property (nonatomic) NSInteger mHost;
@property (nonatomic) NSInteger mGameStart;

@property (strong, nonatomic) NSThread* mThread;

+(Client*)sharedClient;
-(id)init;
-(int)connect:(NSString*)host port:(unsigned short)port;
-(int)send;
-(int)receive;
-(void)close;
@end
