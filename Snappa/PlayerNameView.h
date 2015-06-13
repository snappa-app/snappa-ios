//
//  PlayerNameView.h
//  Snappa
//
//  Created by Sam Edson on 10/17/15.
//  Copyright © 2015 Sam Edson. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PlayerNameViewHandler <NSObject>

- (void)didNamePlayerUsLeft:(NSString *)usLeft
                    usRight:(NSString *)usRight
                   themLeft:(NSString *)themLeft
                  themRight:(NSString *)themRight;

- (void)didLoadSavedGame;

@end

@interface PlayerNameView : UIView

- (id)initWithFrame:(CGRect)frame
           delegate:(id<PlayerNameViewHandler>)delegate;

@property (nonatomic, strong) UITextField *usLeftName;
@property (nonatomic, strong) UITextField *usRightName;
@property (nonatomic, strong) UITextField *themLeftName;
@property (nonatomic, strong) UITextField *themRightName;

@property (nonatomic, strong) UIButton *finishButton;

@end
