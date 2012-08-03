//
//  User.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 29..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize mRoom, mPlayer, mHost;


static User* _shreadUser;

+(User*)sharedUser
{
    @synchronized( [User class] )
    {
        if( !_shreadUser )
            [[self alloc]init];
        return _shreadUser;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized( [User class] )
    {
        _shreadUser = [super alloc];
        return _shreadUser;
    }
    return nil;
}

-(id)init
{
    if( self = [super init] )
    {
        mRoom = [[NSNumber alloc]initWithInt:0];
        mPlayer = [[NSNumber alloc]initWithInt:0];
        mHost = [[NSNumber alloc]initWithInt:0];
    }
    return self;
}

@end
