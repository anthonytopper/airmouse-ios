//
//  Quaternion.h
//  Airmouse
//
//  Created by anthony on 1/15/16.
//  Copyright © 2016 Topper Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quaternion : NSObject
@property (nonatomic) double w;
@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) double z;
- (Quaternion*) multiplyWithRight:(Quaternion*)q;
- (id) initWithValues:(double)x2 y:(double)y2 z:(double)z2 w:(double)w2;
@end
