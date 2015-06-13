//
//  DragChoiceView.h
//  Snappa
//
//  Created by Sam Edson on 6/28/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DragChoiceViewChoice.h"

#include <string>


@protocol DragChoiceViewCaller <NSObject>

- (void)dragNoop;
- (void)dragChoiceStep:(std::string)input;

@end


@interface DragChoiceView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *operatorButton;

- (id)initWithFrame:(CGRect)frame
             parent:(UIViewController *)parent
           delegate:(id<DragChoiceViewCaller>)delegate
          coverView:(UIView *)converView
         leftChoice:(DragChoiceViewChoice *)leftChoice
          topChoice:(DragChoiceViewChoice *)topChoice
        rightChoice:(DragChoiceViewChoice *)rightChoice
       bottomChoice:(DragChoiceViewChoice *)bottomChoice;

- (void)handleLeftButton:(id)sender;
- (void)handleTopButton:(id)sender;
- (void)handleRightButton:(id)sender;
- (void)handleBottomButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@end
