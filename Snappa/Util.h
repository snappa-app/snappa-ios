//
//  Util.h
//  Snappa
//
//  Created by Sam Edson on 7/13/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject

+ (void)saveGame:(NSString *)gameLog;
+ (NSString *)getSavedGame;
+ (bool)isIphoneX;
+ (CGRect)addHeight:(CGFloat)height toRect:(CGRect)rect;
+ (NSString *)randomStringWithLength:(int)len;
+ (NSString *)getDeviceID;

@end
