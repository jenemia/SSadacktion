//
//  SoundManager.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SoundManager : NSObject

@property (strong, nonatomic) NSMutableDictionary* mSoundIDDic;

+(SoundManager*)sharedSoundManager;
-(void)playSystemSound:(NSString*)fileName fileType:(NSString*)type;

@end
