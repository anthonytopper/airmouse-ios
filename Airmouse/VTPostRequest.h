//
//  VTPostRequest.h
//  vibetribemvp
//
//  Created by anthony on 2/14/16.
//  Copyright © 2016 Vibe Tribe. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "VTServerConfig.h"


typedef void(^VTPostCallback)(NSData*,NSError*);

@interface VTPostRequest : NSObject {
    NSMutableData *response;
    VTPostCallback callback;
}
-(BOOL) rawPostRequestToURL:(NSString *) url withRawData:(NSData *) data headers:(NSDictionary *) headers callback:(VTPostCallback) cb;
-(BOOL) postRequestToURL:(NSString*) url withPostData:(NSString*) post callback:(VTPostCallback) callback;

@end

