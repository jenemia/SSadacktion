//
//  ServerAdapter.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 27..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Packet;

@interface ServerAdapter : NSObject

@property (nonatomic) NSInteger mSocket;
@property (nonatomic) BOOL mServerOn;

+(ServerAdapter*)sharedServerAdapter;
-(int)connect;
-(int)send:(Packet*)packet;
-(Packet*)receive;

@end
