//
//  DragChoiceView.m
//  Snappa
//
//  Created by Sam Edson on 6/28/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#import "DragChoiceView.h"

#import "Util.h"


typedef enum DragAction {
    ACTION_NONE,
    ACTION_TOP,
    ACTION_LEFT,
    ACTION_RIGHT,
    ACTION_BOTTOM,
} DragAction;


@interface DragChoiceView()

@property (nonatomic, strong) UIView *xibView;

@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) id<DragChoiceViewCaller> delegate;
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, assign) std::string leftChoiceHandler;
@property (nonatomic, assign) std::string topChoiceHandler;
@property (nonatomic, assign) std::string rightChoiceHandler;
@property (nonatomic, assign) std::string bottomChoiceHandler;

@property (nonatomic) DragAction dragAction;

@end


@implementation DragChoiceView

- (id)initWithFrame:(CGRect)frame
             parent:(UIViewController *)parent
           delegate:(id<DragChoiceViewCaller>)delegate
          coverView:(UIView *)converView
         leftChoice:(DragChoiceViewChoice *)leftChoice
          topChoice:(DragChoiceViewChoice *)topChoice
        rightChoice:(DragChoiceViewChoice *)rightChoice
       bottomChoice:(DragChoiceViewChoice *)bottomChoice {
    
    self = [super initWithFrame:frame];
    if ( !self ) { return nil; }
    
    _parent = parent;
    _delegate = delegate;
    _coverView = converView;
    
    NSString *className = NSStringFromClass([self class]);
    _xibView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
    
    if(CGRectIsEmpty(frame)) {
        self.bounds = _xibView.bounds;
    }
    
    [self addSubview:_xibView];
    
    self.backgroundColor = [UIColor darkGrayColor];
    
    [self.leftButton setTitle:leftChoice.name forState:UIControlStateNormal];
    _leftChoiceHandler = leftChoice.handler;
    self.leftButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self.topButton setTitle:topChoice.name forState:UIControlStateNormal];
    _topChoiceHandler = topChoice.handler;

    [self.rightButton setTitle:rightChoice.name forState:UIControlStateNormal];
    _rightChoiceHandler = rightChoice.handler;
    self.rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self.bottomButton setTitle:bottomChoice.name forState:UIControlStateNormal];
    _bottomChoiceHandler = bottomChoice.handler;

    [self.operatorButton addTarget:self
                            action:@selector(holdOperatorButton)
                  forControlEvents:UIControlEventTouchDown];
    
    [self.operatorButton addTarget:self
                            action:@selector(dragInside:event:)
                  forControlEvents:UIControlEventTouchDragInside];
    
    [self.operatorButton addTarget:self
                            action:@selector(dragOutside:event:)
                  forControlEvents:UIControlEventTouchDragOutside];
    
    [self.operatorButton addTarget:self
                            action:@selector(releaseOperatorButton:event:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.operatorButton addTarget:self
                            action:@selector(releaseOperatorButtonOutside:event:)
                  forControlEvents:UIControlEventTouchUpOutside];
    
    [self hideChoices];
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (_operatorButton.userInteractionEnabled && [_operatorButton pointInside:[self convertPoint:point toView:_operatorButton] withEvent:event]) {
        return YES;
    }
    return NO;
}

- (void)holdOperatorButton {
    [self showChoices];
}

- (void)dragInside:(UIButton *)sender event:(UIEvent *)event {
    [self removeBorder:_leftButton];
    [self removeBorder:_topButton];
    [self removeBorder:_rightButton];
    [self removeBorder:_bottomButton];
    self.dragAction = ACTION_NONE;
}

- (void)dragOutside:(UIButton *)sender event:(UIEvent *)event {
    static const CGFloat deviceScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    static const CGFloat deviceScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    static const CGFloat iphone5ScreenWidth = 320;
    static const CGFloat iphone5ScreenHeight = 568;
    
    CGFloat widthRatio = deviceScreenWidth / iphone5ScreenWidth;
    CGFloat heightRatio = deviceScreenHeight / iphone5ScreenHeight;

    if ([Util isIphoneX]) {
        static const CGFloat iPhoneXMultiplier = 0.7;
        widthRatio = iPhoneXMultiplier * widthRatio;
        heightRatio = iPhoneXMultiplier * heightRatio;
    }
    
    if ([[event.allTouches anyObject] locationInView:_operatorButton].y < -30 * heightRatio) {
        [self addBorder:_topButton];
        [self removeBorder:_leftButton];
        [self removeBorder:_rightButton];
        [self removeBorder:_bottomButton];
        self.dragAction = ACTION_TOP;
        return;
    } else if ([[event.allTouches anyObject] locationInView:_operatorButton].y > 150 * heightRatio) {
        [self addBorder:_bottomButton];
        [self removeBorder:_leftButton];
        [self removeBorder:_topButton];
        [self removeBorder:_rightButton];
        self.dragAction = ACTION_BOTTOM;
        return;
    } else if ([[event.allTouches anyObject] locationInView:_operatorButton].x > 100 * widthRatio) {
        [self addBorder:_rightButton];
        [self removeBorder:_leftButton];
        [self removeBorder:_topButton];
        [self removeBorder:_bottomButton];
        self.dragAction = ACTION_RIGHT;
        return;
    } else if ([[event.allTouches anyObject] locationInView:_operatorButton].x < 0 * widthRatio) {
        [self addBorder:_leftButton];
        [self removeBorder:_topButton];
        [self removeBorder:_rightButton];
        [self removeBorder:_bottomButton];
        self.dragAction = ACTION_LEFT;
        return;
    }
}

- (void)addBorder:(UIButton *)button {
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
    button.layer.borderWidth = 5;
}

- (void)removeBorder:(UIButton *)button {
    button.layer.borderWidth = 0;
}

- (void)releaseOperatorButton:(UIButton *)sender event:(UIEvent *)event {
    [self removeBorder:_leftButton];
    [self removeBorder:_topButton];
    [self removeBorder:_rightButton];
    [self removeBorder:_bottomButton];
    [self hideChoices];
    [self.delegate dragNoop];
}

- (void)releaseOperatorButtonOutside:(UIButton *)sender event:(UIEvent *)event {
    [self removeBorder:_leftButton];
    [self removeBorder:_topButton];
    [self removeBorder:_rightButton];
    [self removeBorder:_bottomButton];
    [self hideChoices];
    
    if (self.dragAction == ACTION_TOP) {
        [self handleTopButton:nil];
        return;
    } else if (self.dragAction == ACTION_BOTTOM) {
        [self handleBottomButton:nil];
        return;
    } else if (self.dragAction == ACTION_RIGHT) {
        [self handleRightButton:nil];
        return;
    } else if (self.dragAction == ACTION_LEFT) {
        [self handleLeftButton:nil];
        return;
    }
    
//    if ([[event.allTouches anyObject] locationInView:_operatorButton].y < 0) {
//        [self handleTopButton:nil];
//        return;
//    } else if ([[event.allTouches anyObject] locationInView:_operatorButton].y > 200) {
//        [self handleBottomButton:nil];
//        return;
//    } else if ([[event.allTouches anyObject] locationInView:_operatorButton].x > 100) {
//        [self handleRightButton:nil];
//        return;
//    } else if ([[event.allTouches anyObject] locationInView:_operatorButton].x < 0) {
//        [self handleLeftButton:nil];
//        return;
//    }
}

- (void)hideChoices {
//    [UIView animateWithDuration:0.25
//                          delay:0
//                        options: UIViewAnimationCurveEaseOut
//     animations:^{
//         _leftButton.alpha = 0;
//         _topButton.alpha = 0;
//         _rightButton.alpha = 0;
//         _bottomButton.alpha = 0;
//         
//         _coverView.alpha = 0;
//     }
//     completion:^(BOOL finished){
//         _leftButton.hidden = true;
//         _topButton.hidden = true;
//         _rightButton.hidden = true;
//         _bottomButton.hidden = true;
//         
//         _coverView.hidden = true;
//     }];
    
    _leftButton.hidden = true;
    _topButton.hidden = true;
    _rightButton.hidden = true;
    _bottomButton.hidden = true;
    self.backgroundColor = [UIColor clearColor];
    _coverView.hidden = true;
}

- (void)showChoices {
    [self.parent.view bringSubviewToFront:self];
    
//    [UIView animateWithDuration:0.25
//                          delay:0
//                        options: UIViewAnimationCurveEaseIn
//     animations:^{
//         _leftButton.alpha = 1;
//         _topButton.alpha = 1;
//         _rightButton.alpha = 1;
//         _bottomButton.alpha = 1;
//         
//         _coverView.alpha = 1;
//     }
//     completion:^(BOOL finished){
//         _leftButton.hidden = false;
//         _topButton.hidden = false;
//         _rightButton.hidden = false;
//         _bottomButton.hidden = false;
//         
//         _coverView.hidden = false;
//     }];
    
    _leftButton.hidden = false;
    _topButton.hidden = false;
    _rightButton.hidden = false;
    _bottomButton.hidden = false;
    self.backgroundColor = [UIColor darkGrayColor];
    _coverView.hidden = false;
}

- (void)handleLeftButton:(id)sender {
    [self.delegate dragChoiceStep:self.leftChoiceHandler];
}

- (void)handleTopButton:(id)sender {
    [self.delegate dragChoiceStep:self.topChoiceHandler];
}

- (void)handleRightButton:(id)sender {
    [self.delegate dragChoiceStep:self.rightChoiceHandler];
}

- (void)handleBottomButton:(id)sender {
    [self.delegate dragChoiceStep:self.bottomChoiceHandler];
}

@end
