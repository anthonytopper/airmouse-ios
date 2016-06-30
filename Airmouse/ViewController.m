//
//  ViewController.m
//  Airmouse
//
//  Created by anthony on 1/15/16.
//  Copyright © 2016 Topper Studios. All rights reserved.
//

#import "ViewController.h"
#import "Quaternion.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 1.0f/10.0f;
    self.motionManager.gyroUpdateInterval = 1.0f/10.0f;
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMDeviceMotion  *deviceMotion, NSError *error) {
                                                 [self outputMotionData:deviceMotion];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    click = -1;
    action = -1;
    calCount = -1;
    self.bluetooth = [[BTManager alloc] init];
    [self.bluetooth start];
    self.bluetooth.assistant.delegate = self;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) outputMotionData:(CMDeviceMotion *) data {
    CMAcceleration acceleration = data.gravity;
    
    Quaternion *quat = [self getDeviceRotationFromMotion:data];
    
    self.xLabel.text = [NSString stringWithFormat:@"%.3f",quat.x];
    self.yLabel.text = [NSString stringWithFormat:@"%.3f",quat.y];
    self.zLabel.text = [NSString stringWithFormat:@"%.3f",quat.z];
    
    
//    [self.bluetooth updateX:quat.x y:quat.y z:quat.z c:calibrateActionON r:releaseActionON click:click action:action];
    
    if (calibrateActionON) {calCount = (++calCount) % 7;
        prev = YES;
    }
    
//    if (self.bluetooth.isCal && prev) {
//        // is calibrating
//        NSLog(@"call");
//        [self.bluetooth updateX:quat.x y:quat.y z:quat.z c:calibrateActionON r:releaseActionON click:click action:action];
//        prev = NO;
//    }
//    else if (!self.bluetooth.isCal) {
        [self.bluetooth updateX:quat.x y:quat.y z:quat.z c:calibrateActionON r:releaseActionON click:click action:action];
//    }
    

    
    calibrateActionON = NO;
    releaseActionON = NO;
    click = -1;
    action = -1;
}

-(Quaternion *) getDeviceRotationFromMotion:(CMDeviceMotion *) data {
    Quaternion *e = [[Quaternion alloc] initWithValues:0 y:1 z:0 w:0];
    CMQuaternion cm = data.attitude.quaternion;
    Quaternion *quat = [[Quaternion alloc] initWithValues:cm.x y:cm.y z:cm.z w: cm.w];
    Quaternion *quatConjugate = [[Quaternion alloc] initWithValues:-cm.x y:-cm.y z:-cm.z w: cm.w];
    [quat multiplyWithRight:e];
    [quat multiplyWithRight:quatConjugate];
    return quat;
}

- (IBAction)calibrateAction:(id)sender {
    
    Quaternion *rot = [self getDeviceRotationFromMotion:self.motionManager.deviceMotion];
    
    //x,z
    calibrateActionON = YES;
    
    
}
- (IBAction)releaseAction:(id)sender {
    releaseActionON = YES;
}

- (IBAction)rightClick:(id)sender {
    click = kCGMouseButtonRight;
    action = kCGEventRightMouseUp;
}

- (IBAction)leftClick:(id)sender {
    click = kCGMouseButtonLeft;
    action = kCGEventLeftMouseUp;
}

- (IBAction)leftDown:(id)sender {
    click = kCGMouseButtonLeft;
    action = kCGEventLeftMouseDown;
}

- (IBAction)rightDown:(id)sender {
    click = kCGMouseButtonRight;
    action = kCGEventRightMouseDown;
}
@end







