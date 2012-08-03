//
//  User.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 29..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSNumber* mPlayer;
@property (strong, nonatomic) NSNumber* mRoom;
@property (strong, nonatomic) NSNumber* mHost;

+(User*)sharedUser;
@end
