//
//  JSONAdapter.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSONPacket;

@interface JSONAdapter : NSObject

@property (strong, nonatomic) NSMutableData* mResponseData;
@property (strong, nonatomic) NSMutableURLRequest* mRequest;
@property (strong, nonatomic) NSURLConnection* mConnection;
@property (strong, nonatomic) JSONPacket* mPacket;
+(JSONAdapter*)sharedJSONAdapter;
-(void)Send;
@end
