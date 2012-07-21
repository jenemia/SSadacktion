//
//  JSONAdapter.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 21..
//  Copyright (c) 2012년 rlatngus0333@naver.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONAdapter : NSObject

@property (strong, nonatomic) NSMutableData* mResponseData;
+(JSONAdapter*)sharedJSONAdapter;
@end
