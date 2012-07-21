//
//  SoundManager.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

@synthesize mSoundIDDic;

static SoundManager* _sharedSoundManager = nil;

+(SoundManager*)sharedSoundManager
{
    @synchronized([SoundManager class])
    {
        if( !_sharedSoundManager)
            [[self alloc]init];
        return _sharedSoundManager;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([SoundManager class])
    {
        _sharedSoundManager = [super alloc];
        return _sharedSoundManager;
    }
    return nil;
}

-(id)init
{
    if( (self = [super init]) )
    {
        mSoundIDDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)playSystemSound:(NSString *)fileName fileType:(NSString *)type
{
    @try {
        NSNumber* num = (NSNumber*)[mSoundIDDic objectForKey:fileName];
        NSLog(@"%d", mSoundIDDic.count);
        SystemSoundID soundID;
        
        if( num == nil )
        {
            NSBundle* mainBundle = [NSBundle mainBundle];
            NSString* path = [mainBundle pathForResource:fileName ofType:type];
            AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
            
            num = [[NSNumber alloc]initWithUnsignedInt:soundID];
            [mSoundIDDic setObject:num forKey:fileName];
            [mSoundIDDic setObject:num forKey:@"aa"];
        }
        else { //같은 파일 있을 때
            soundID = [num unsignedIntValue];
        }
        
        AudioServicesPlaySystemSound(soundID);
    }
    @catch (NSException *exception) {
        NSLog(@"Exception form playSystemSound : %@", exception);
    }
}

-(void)dealloc
{
    if( mSoundIDDic != nil && [mSoundIDDic count]>0 )
    {
        NSArray* IDs = [mSoundIDDic allValues];
        if( IDs != nil )
        {
            for( NSInteger i=0; i<[IDs count]; i++ )
            {
                NSNumber* num = (NSNumber*)[IDs objectAtIndex:i];
                if( num == nil )
                    continue;
                
                SystemSoundID soundID = [num unsignedLongValue];
                AudioServicesDisposeSystemSoundID(soundID);
            }
        }
    }
   [super dealloc];
}
@end
