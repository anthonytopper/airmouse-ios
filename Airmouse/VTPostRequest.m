//
//  VTPostRequest.m
//  VibeTribe
//
//  Created by Anthony Topper on 2/14/16.
//  Copyright (c) 2016 Topper Studios. All rights reserved.
//

#import "VTPostRequest.h"

@implementation VTPostRequest

-(BOOL) rawPostRequestToURL:(NSString *) url withRawData:(NSData *) data headers:(NSDictionary *) headers callback:(VTPostCallback) cb {
    NSString *length = [NSString stringWithFormat:@"%lul",(unsigned long)[data length]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"POST"];
    [req setValue:length forHTTPHeaderField:@"Content-Length"];
    for (NSString *key in headers) {
        [req setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    [req setHTTPBody:data];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (connection) {
    } else {
        NSLog(@"CONNECTION FAILED to URL: %@",url);
        return false;
    }
    response = [[NSMutableData alloc] init];
    callback = cb;
    return true;
}

-(BOOL) postRequestToURL:(NSString*) url withPostData:(NSString*) post callback:(VTPostCallback) cb {
    //    NSLog(@"Making post");
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *headers = @{};
    return [self rawPostRequestToURL:url withRawData:postData headers:headers callback:cb];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    [response appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (callback != NULL) {
        callback(nil,error);
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (callback != NULL) {
        callback(response,nil);
    }
}

@end
