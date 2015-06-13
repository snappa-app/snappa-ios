//
//  PlayerNameView.m
//  Snappa
//
//  Created by Sam Edson on 10/17/15.
//  Copyright © 2015 Sam Edson. All rights reserved.
//

#import "PlayerNameView.h"

#define SHOW_RECOVER 0

@interface PlayerNameView()

@property (nonatomic, strong) id<PlayerNameViewHandler> delegate;

@end


@implementation PlayerNameView

- (id)initWithFrame:(CGRect)frame
           delegate:(id<PlayerNameViewHandler>)delegate {
    self = [super initWithFrame:frame];
    if ( !self ) { return nil; }
    
    _delegate = delegate;
    
    CGFloat left = frame.origin.x;
    CGFloat right = left + frame.size.width;
    CGFloat top = frame.origin.y;
    CGFloat bottom = top + frame.size.height / 2;
    
    CGFloat xMargin = 20;
    CGFloat yMargin = 50;

    CGFloat width = 120;
    CGFloat height = 40;
    
    CGRect usLeftSize = CGRectMake(right - xMargin - width,
                                   top + 2 * yMargin,
                                   width,
                                   height);
    self.usLeftName = [[UITextField alloc] initWithFrame:usLeftSize];
    self.usLeftName.textAlignment = NSTextAlignmentRight;
    self.usLeftName.placeholder = @"Them Left";

    CGRect usRightSize = CGRectMake(left + xMargin,
                                    top + 2 * yMargin,
                                    width,
                                    height);
    self.usRightName = [[UITextField alloc] initWithFrame:usRightSize];
    self.usRightName.placeholder = @"Them Right";

    CGRect themLeftSize = CGRectMake(left + xMargin,
                                     bottom - yMargin - height,
                                     width,
                                     height);
    self.themLeftName = [[UITextField alloc] initWithFrame:themLeftSize];
    self.themLeftName.placeholder = @"Us Left";

    CGRect themRightSize = CGRectMake(right - xMargin - width,
                                      bottom - yMargin - height,
                                      width,
                                      height);
    self.themRightName = [[UITextField alloc] initWithFrame:themRightSize];
    self.themRightName.textAlignment = NSTextAlignmentRight;
    self.themRightName.placeholder = @"Us Right";

    CGRect instructionsSize = CGRectMake(left + ((right - left) / 2) - 150,
                                         top + ((bottom - top) / 2) - 4,
                                         300,
                                         80);
    UITextView *instructions = [[UITextView alloc] initWithFrame:instructionsSize];
    instructions.text = @"Enter Player Names";
    instructions.textAlignment = NSTextAlignmentCenter;
    UIFont *instructionsFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
                                               size:32];
    [instructions setFont:instructionsFont];
    [self addSubview:instructions];
    
    NSArray *nameInputs = @[self.usLeftName,
                            self.usRightName,
                            self.themLeftName,
                            self.themRightName];
    
    for (int i = 0; i < 4; i++) {
        UITextField *nameInput = [nameInputs objectAtIndex:i];
        nameInput.backgroundColor = [UIColor whiteColor];
        [nameInput setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
                                           size:18]];
        nameInput.tintColor = [UIColor blackColor];
//        nameInput.layer.borderWidth = 4;
        [nameInput addTarget:self
                      action:@selector(textFieldDidChange)
            forControlEvents:UIControlEventEditingChanged];
        [self addSubview:nameInput];

    }
    
    CGRect finishButtonFrame = CGRectMake(left + xMargin,
                                          bottom - 20,
                                          right - left - (2 * xMargin),
                                          60);
    self.finishButton = [[UIButton alloc] initWithFrame:finishButtonFrame];
    self.finishButton.backgroundColor = [UIColor blackColor];
    [self.finishButton.titleLabel setFont:instructionsFont];
    [self.finishButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.finishButton addTarget:self
                     action:@selector(finishPlayerNames)
           forControlEvents:UIControlEventTouchUpInside];
    self.finishButton.hidden = true;
    [self addSubview:self.finishButton];
    
    
    CGRect skipButtonFrame = CGRectMake(left + ((right - left) / 2) - 50,
                                        30,
                                        100,
                                        40);
    UIButton *skipButton = [[UIButton alloc] initWithFrame:skipButtonFrame];
    [skipButton addTarget:self
                   action:@selector(skipPlayerNames)
         forControlEvents:UIControlEventTouchUpInside];
    [skipButton setTitle:@"skip →"
                forState:UIControlStateNormal];
    [skipButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
                                                   size:14]];
    [skipButton setTitleColor:[UIColor blackColor]
                     forState:UIControlStateNormal];
//    skipButton.layer.borderWidth = 5;
//    skipButton.backgroundColor = [UIColor blackColor];
    [self addSubview:skipButton];

#if SHOW_RECOVER
    CGRect loadSavedButtonFrame = CGRectMake(20,
                                             30,
                                             40,
                                             40);
    UIButton *loadSavedButton = [[UIButton alloc] initWithFrame:loadSavedButtonFrame];
    [loadSavedButton setTitle:@"Recover"
                   forState:UIControlStateNormal];
    loadSavedButton.backgroundColor = [UIColor redColor];
    [loadSavedButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
                                                        size:10]];
    [loadSavedButton addTarget:self
                      action:@selector(handleLoadSavedGame)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:loadSavedButton];
#endif
    
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    // Screen Correction
    const CGFloat deviceScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    const CGFloat deviceScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    if (deviceScreenHeight >= 667) {
        static const CGFloat iphone5ScreenWidth = 320;
        static const CGFloat iphone5ScreenHeight = 568;
        
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                (iphone5ScreenWidth / deviceScreenWidth),
                                                (iphone5ScreenHeight / deviceScreenHeight));
        // iPhone X
        if (deviceScreenHeight >= 812) {
            [self setFrame:CGRectMake(self.frame.origin.x - 28,
                                      self.frame.origin.y - 100,
                                      self.frame.size.width,
                                      self.frame.size.height)];
        } else if (deviceScreenHeight >= 736) {
            [self setFrame:CGRectMake(self.frame.origin.x - 45,
                                      self.frame.origin.y - 50,
                                      self.frame.size.width,
                                      self.frame.size.height)];
        } else {
            [self setFrame:CGRectMake(self.frame.origin.x - 28,
                                      self.frame.origin.y - 40,
                                      self.frame.size.width,
                                      self.frame.size.height)];
        }
    }
    
    return self;
}

- (void)textFieldDidChange {
    NSArray *nameInputs = @[self.usLeftName,
                            self.usRightName,
                            self.themLeftName,
                            self.themRightName];
    self.finishButton.hidden = false;
    for (int i = 0; i < 4; i++) {
        UITextField *nameInput = [nameInputs objectAtIndex:i];
        if (nameInput.text.length == 0) {
            self.finishButton.hidden = true;
        }
    }
}

- (void)handleLoadSavedGame {
    [_delegate didLoadSavedGame];
}

- (void)finishPlayerNames {
    NSArray *nameInputs = @[self.usLeftName,
                            self.usRightName,
                            self.themLeftName,
                            self.themRightName];
    for (int i = 0; i < 4; i++) {
        UITextField *nameInput = [nameInputs objectAtIndex:i];
        if (nameInput.isFirstResponder) {
            [nameInput resignFirstResponder];
        }
    }
    
    [_delegate didNamePlayerUsLeft:self.usLeftName.text
                           usRight:self.usRightName.text
                          themLeft:self.themLeftName.text
                         themRight:self.themRightName.text];
}

- (void)skipPlayerNames {
    NSArray *nameInputs = @[self.usLeftName,
                            self.usRightName,
                            self.themLeftName,
                            self.themRightName];
    for (int i = 0; i < 4; i++) {
        UITextField *nameInput = [nameInputs objectAtIndex:i];
        if (nameInput.isFirstResponder) {
            [nameInput resignFirstResponder];
        }
    }
    
    [_delegate didNamePlayerUsLeft:@"Them Left"
                           usRight:@"Them Right"
                          themLeft:@"Us Left"
                         themRight:@"Us Right"];
}

@end
