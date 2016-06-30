//
//  BTManager.m
//  Airmouse
//
//  Created by anthony on 1/15/16.
//  Copyright © 2016 Topper Studios. All rights reserved.
//

#import "BTManager.h"
#import "VTPostRequest.h"

@implementation BTManager

static NSString *BL_UUID = @"63cebf9f-421d-47e4-ad6e-9a66aa0b341c";
static NSString *BL_CHAR_UUID = @"abfa3eec-92ad-4e28-bce4-976bab515044";

#define DOUBLE_SIZE (sizeof(double))
#define INT_SIZE (sizeof(int))
#define SERVICE_TYPE @"abcdef"

//-(void) start {
//    if (self.manager) {
//        return;
//    }
//
//    CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc]
//                                               initWithType:[CBUUID UUIDWithString:BL_CHAR_UUID]
//                                               properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify
//                                               value:nil permissions:CBAttributePermissionsReadable];
//    CBMutableService *s = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:BL_UUID] primary:NO];
//    s.characteristics = @[characteristic];
//
//    self.service = s;
//    self.manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
////    [self.manager addService:self.service];
//    [self.manager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:BL_UUID]]}];
//    NSLog(@"Called, %@ %@",self.manager,self.service);
//}
//
//-(void) peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
//    if (error) {
//        NSLog(@"Error publishing service: %@", [error localizedDescription]);
//    }
//}
//
//- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
//                                       error:(NSError *)error {
//
//    if (error) {
//        NSLog(@"Error advertising: %@", [error localizedDescription]);
//    }
//
//}
//
//- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
//    NSLog(@"%@",peripheral);
//}
//
//-(void) updateCharacteristic:(NSData *) data {
//    if (!self.manager.isAdvertising) return;
//    CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc]
//                                               initWithType:[CBUUID UUIDWithString:BL_CHAR_UUID]
//                                               properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify
//                                               value:data permissions:CBAttributePermissionsReadable];
//    [self.manager updateValue:data forCharacteristic:characteristic onSubscribedCentrals:nil];
//    NSLog(@"%@",data);
//}
//
//-(void) start {
//    if (self.session == nil) {
//        //create peer picker and show picker of connections
//        GKPeerPickerController *peerPicker = [[GKPeerPickerController alloc] init];
//        peerPicker.delegate = self;
//        peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
//        [peerPicker show];
//    }
//}
//
//-(GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
//    GKSession *session = [[GKSession alloc] initWithSessionID:BL_UUID displayName:nil sessionMode:GKSessionModePeer];
//    return session;
//}
//
//-(void) peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
//    session.delegate = self;
//    self.session = session;
//    picker.delegate = nil;
//    [picker dismiss];
//}
//
//- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
//{
//    if (state == GKPeerStateConnected){
//        [session setDataReceiveHandler:self withContext:nil]; //set ViewController to receive data
//    }
//    else {
//        self.session.delegate = nil;
//        self.session = nil; //allow session to reconnect if it gets disconnected
//    }
//}



-(void) start {
    calibratingPeer = 0;
    
    self.peer = [[MCPeerID alloc] initWithDisplayName:@"Airmouse connector"];
    self.session = [[MCSession alloc] initWithPeer:self.peer securityIdentity:nil encryptionPreference:MCEncryptionNone];
    self.session.delegate = self;
    NSLog(@"ad");
    self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICE_TYPE discoveryInfo:nil session:self.session];
    [self.assistant start];
    self.assistant.delegate = self;
    
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peer serviceType:SERVICE_TYPE];
    self.browser.delegate = self;
    [self.browser startBrowsingForPeers];
    
    //    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peer discoveryInfo:nil serviceType:SERVICE_TYPE];
    //    [self.advertiser startAdvertisingPeer];
    //    self.advertiser.delegate = self;
    
    NSLog(@"%@ %@  %@  %@",self.peer,self.session,self.assistant,self.assistant.delegate);
    
}

-(void) session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

-(void) advertiserAssistantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant {
    NSLog(@"advertiserAssistantWillPresentInvitation %@",advertiserAssistant);
}

-(void) advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant {
    NSLog(@"advertiserAssistantDidDismissInvitation %@",advertiserAssistant);
    [self.assistant stop];
}

-(void) advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    NSLog(@"didNotStartAdvertisingPeer %@",error);
}

-(void) advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession * _Nonnull))invitationHandler {
    //    self.session = [[MCSession alloc] initWithPeer:[[MCPeerID alloc] initWithDisplayName:@"Arab the sat"]];
    //    self.session.delegate = self;
    invitationHandler(YES,self.session);
    NSLog(@"didReceiveInvitationFromPeer %@ %@",peerID,self.session);
    [self.advertiser stopAdvertisingPeer];
}

-(void) session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"didChangeState %ldl",(long)state);
}
-(void) session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSLog(@"didReceiveData %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    int hasPath;
    int pathLength;
    char pathString [256];
    
    [data getBytes:&hasPath range:NSMakeRange(0, INT_SIZE)];
    if (hasPath != 0) {
        [data getBytes:&pathLength range:NSMakeRange(INT_SIZE, INT_SIZE)];
        [data getBytes:pathString range:NSMakeRange(INT_SIZE * 2, pathLength)];
        nextPath = [NSString stringWithCString:pathString encoding:NSUTF8StringEncoding];
    }
    
}
- (void) session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    NSLog(@"didReceiveCertificate %@, %@, %@",session, certificate, peerID);
    certificateHandler(YES);
}

-(void) browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    NSLog(@"didNotStartBrowsingForPeers: %@",error);
}

-(void) browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info {
    NSLog(@"foundPeer %@  %@  %@",browser,peerID,info);
    [self.browser invitePeer:peerID toSession:self.session withContext:nil timeout:-1]; // IMPORTANT
}

-(void) browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"lostPeer: %@ %@",browser,peerID);
}

-(void) updateX:(double) x y:(double) y z:(double) z c:(BOOL) c r:(BOOL) r click:(int) click action:(int) action {
    if (self.session.connectedPeers.count == 0) return;
    
    int peerToContact = -1;
    if (c) {
        if (calCount == 2) calibratingPeer = (++calibratingPeer) % (self.session.connectedPeers.count);
        calCount = (++calCount) % 3;
        peerToContact = calibratingPeer;
        NSLog(@"calCount %d;  calibratingPeer %d;  peertoContact %d;  peer count %d;",calCount,calibratingPeer,peerToContact,self.session.connectedPeers.count);
        if (calCount == 2 && calibratingPeer == self.session.connectedPeers.count-1) {
            _isCal = NO;
        } else {
            _isCal = YES;
        }
    }
    
    int ci = c? 1 : 0;
    int ri = r? 1 : 0;
    
    int hasPath = nextPath? 1 : 0;
    
    NSMutableData *data = [NSMutableData dataWithBytes:&x length:DOUBLE_SIZE];
    [data appendData:[NSData dataWithBytes:&y length:DOUBLE_SIZE]];
    [data appendData:[NSData dataWithBytes:&z length:DOUBLE_SIZE]];
    [data appendData:[NSData dataWithBytes:&ci length:INT_SIZE]];
    [data appendData:[NSData dataWithBytes:&ri length:INT_SIZE]];
    [data appendData:[NSData dataWithBytes:&click length:INT_SIZE]];
    [data appendData:[NSData dataWithBytes:&action length:INT_SIZE]];
    
    [data appendData:[NSData dataWithBytes:&hasPath length:INT_SIZE]];
    
    if (hasPath) {
        const char *pathString = nextPath.cString;
        const int length = (int)nextPath.cStringLength;
        [data appendData:[NSData dataWithBytes:&length length:INT_SIZE]];
        [data appendData:[NSData dataWithBytes:pathString length:length]];
    }
    
    NSError *err;
    
    NSArray *dest = self.session.connectedPeers;//(peerToContact < 0) ? self.session.connectedPeers : @[self.session.connectedPeers[peerToContact]];
    
    BOOL sent = [self.session sendData:data toPeers:dest withMode:((c||r)? MCSessionSendDataReliable : MCSessionSendDataUnreliable) error:&err];
    
    if (c){
        VTPostRequest *req = [VTPostRequest new];
        [req postRequestToURL:@"https://test01-anthonytopper.c9.io/set" withPostData:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@{@"coord":@{@"x":@(x),@"y":@(y),@"z":@(z)}, @"client":@(peerToContact), @"calibration":@(calCount)} options:0 error:nil] encoding:NSUTF8StringEncoding] callback:^(NSData *d, NSError *e){
            
            
            
        }];
    }
    
//    NSLog(@"sending %@ error: %@ wasSent: %d",data,err,sent);
}

@end










