//
//  DragChoiceViewChoice.h
//  Snappa
//
//  Created by Sam Edson on 6/28/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <string>


@interface DragChoiceViewChoice : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) std::string handler;

@end
