//
//  BTManager.h
//  Airmouse
//
//  Created by anthony on 1/15/16.
//  Copyright © 2016 Topper Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <GameKit/GameKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface BTManager : NSObject<MCNearbyServiceAdvertiserDelegate,MCSessionDelegate,MCAdvertiserAssistantDelegate,MCNearbyServiceBrowserDelegate> {
    NSString *nextPath;
    int calibratingPeer;
    int calCount;
}
@property (nonatomic,retain) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic,retain) MCAdvertiserAssistant *assistant;
@property (nonatomic,retain) MCSession *session;
@property (nonatomic,retain) MCPeerID *peer;
@property (nonatomic,retain) MCNearbyServiceBrowser *browser;
@property (nonatomic) BOOL isCal;
//@property (nonatomic,retain) CBPeripheralManager *manager;
//@property (nonatomic,retain) CBMutableService *service;
-(void) start;
-(void) updateX:(double) x y:(double) y z:(double) z c:(BOOL) c r:(BOOL) r click:(int) click action:(int) action;
@end
