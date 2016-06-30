//
//  Quaternion.m
//  Airmouse
//
//  Created by anthony on 1/15/16.
//  Copyright © 2016 Topper Studios. All rights reserved.
//

#import "Quaternion.h"

@implementation Quaternion


- (Quaternion*) multiplyWithRight:(Quaternion*)q {
    double newW = _w*q.w - _x*q.x - _y*q.y - _z*q.z;
    double newX = _w*q.x + _x*q.w + _y*q.z - _z*q.y;
    double newY = _w*q.y + _y*q.w + _z*q.x - _x*q.z;
    double newZ = _w*q.z + _z*q.w + _x*q.y - _y*q.x;
    self.w = newW;
    self.x = newX;
    self.y = newY;
    self.z = newZ;
    // one multiplication won't denormalise but when multipling again and again
    // we should assure that the result is normalised
    return self;
}

- (id) initWithValues:(double)x2 y:(double)y2 z:(double)z2 w:(double)w2 {
    if ((self = [super init])) {
        self.x = x2; self.y = y2; self.z = z2; self.w = w2;
    }
    return self;
}

@end
