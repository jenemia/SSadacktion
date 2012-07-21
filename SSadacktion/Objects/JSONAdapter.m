//
//  JSONAdapter.m
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import "JSONAdapter.h"
#import "JSON.h"

@implementation JSONAdapter

@synthesize mResponseData;

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
        NSLog(@"init");
        mResponseData = [NSMutableData data];		
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://192.168.0.11:5554"]];
        [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [request setHTTPMethod:@"POST"];
        [request setHTTPMethod:@"GET"];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    NSLog(@"connectied");
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:mResponseData 
                                                     encoding:NSUTF8StringEncoding];
	
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
	NSArray *luckyNumbers = [json objectWithString:responseString error:&error];
	[responseString release];	
	
	if (luckyNumbers == nil)
		NSLog(@"%@",[NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]]);
	else {		
		NSMutableString *text = [NSMutableString stringWithString:@"Lucky numbers:\n"];
		
		for (int i = 0; i < [luckyNumbers count]; i++) 
			[text appendFormat:@"%@\n", [luckyNumbers objectAtIndex:i]];
        
        NSLog(@"%@",text);
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


@end
