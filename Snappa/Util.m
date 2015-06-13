//
//  Util.m
//  Snappa
//
//  Created by Sam Edson on 7/13/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#import "Util.h"

NSString *saveGameKey = @"saveGameKey";
NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";


@implementation Util


+ (void)saveGame:(NSString *)gameLog {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:gameLog forKey:saveGameKey];
    [standardUserDefaults synchronize];
}

+ (NSString *)getSavedGame {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [standardUserDefaults objectForKey:saveGameKey];
}

+ (bool)isIphoneX {
    const CGFloat deviceScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    return deviceScreenHeight >= 812;
}

+ (CGRect)addHeight:(CGFloat)height toRect:(CGRect)rect {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + height);
}

+ (NSString *)randomStringWithLength:(int)len {
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:len];
    for (NSUInteger i = 0U; i < len; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

+ (NSString *)getDeviceID {
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *deviceId = [[currentDevice identifierForVendor] UUIDString];
    return deviceId;
}

@end
