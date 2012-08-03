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

@property (strong, nonatomic) NSString* mState;
@property (strong, nonatomic) NSString* mRoom;
@property (strong, nonatomic) NSString* mPlayer;
@property (strong, nonatomic) NSString* mX;
@property (strong, nonatomic) NSString* mY;
@property (strong, nonatomic) NSString* mHost;
@property (strong, nonatomic) NSString* mGameStart;

@property (strong, nonatomic) NSThread* mThread;

+(Client*)sharedClient;
-(void)StartThread;
-(id)init;
-(int)connect:(NSString*)host port:(unsigned short)port;
-(int)send;
-(int)receive;
-(void)close;
@end
