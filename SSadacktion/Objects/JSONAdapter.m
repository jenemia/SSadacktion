//
//  JSONAdapter.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "JSONAdapter.h"
#import "JSON.h"
#import "JSONPacket.h"

@implementation JSONAdapter

@synthesize mResponseData;
@synthesize mRequest;
@synthesize mPacket;

static JSONAdapter* _sharedJSONAdapter = nil;


+(JSONAdapter*)sharedJSONAdapter
{
    @synchronized([JSONAdapter class])
    {
        if( !_sharedJSONAdapter)
            [[self alloc]init];
        return _sharedJSONAdapter;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([JSONAdapter class])
    {
        _sharedJSONAdapter = [super alloc];
        return _sharedJSONAdapter;
    }
    return nil;
}

-(id)init
{
    if( self = [super init] )
    {
        mResponseData = [NSMutableData data];		
        mRequest = [[NSMutableURLRequest alloc] init];
        [mRequest setURL:[NSURL URLWithString:@"http://192.168.0.11:8080"]];
        [mRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [mRequest setHTTPMethod:@"POST"];
        [mRequest setHTTPMethod:@"GET"];
        [[NSURLConnection alloc] initWithRequest:mRequest delegate:self];
        
        mPacket = [[JSONPacket alloc]init];
    }
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:mResponseData 
                                                     encoding:NSUTF8StringEncoding];
	
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
	NSArray *luckyNumbers = [json objectWithString:responseString error:&error];
	[responseString release];	
	
	if (luckyNumbers == nil)
		NSLog(@"%@",[NSString stringWithFormat:@"JSON parsing failed: %@", 
                     [error localizedDescription]]);
	else {		
		NSMutableString *text = [NSMutableString stringWithString:@"Lucky numbers:\n"];
		
		for (int i = 0; i < [luckyNumbers count]; i++) 
			[text appendFormat:@"%@\n", [luckyNumbers objectAtIndex:i]];
        
        NSLog(@"%@",text);
        
        [self Send];
	}
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[mResponseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[mResponseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"%@", [NSString stringWithFormat:@"Connection failed: %@", [error description]] );
}

#pragma mark method
-(void)Send
{
    mPacket.mUserName = @"soohyun";
    
    NSMutableData* body = [[NSMutableData data] init];
//    @property (strong, nonatomic) NSString* mUserName;
//    @property (strong, nonatomic) NSString* mRoom;
//    @property (strong, nonatomic) NSString* mPlayer;
//    @property (strong, nonatomic) NSString* mScore;
//    @property (strong, nonatomic) NSString* mState;
//    @property (strong, nonatomic) NSString* mPlayState;
//    @property (strong, nonatomic) NSString* mPositionX;
//    @property (strong, nonatomic) NSString* mPositionY;
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          mPacket.mUserName, @"username",
                          mPacket.mRoom, @"room",
                          mPacket.mPlayer, @"player",
                          mPacket.mScore, @"score",
                          mPacket.mState, @"state",
                          mPacket.mPlayState, @"playstate",
                          mPacket.mPositionX, @"positionX",
                          mPacket.mPositionY, @"positionY",
                          nil];
    //string 
//    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted
//                         error:nil];
//    NSString* _str = [NSString stringWithFormat:@"%@", dic];

    NSString *jsonData = [dic JSONRepresentation];
    
    [body appendData:[jsonData dataUsingEncoding:NSUTF8StringEncoding]];
    [mRequest setHTTPBody:body];
}


@end
