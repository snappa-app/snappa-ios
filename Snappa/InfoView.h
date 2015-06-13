//
//  InfoView.h
//  Snappa
//
//  Created by Sam Edson on 10/21/15.
//  Copyright © 2015 Sam Edson. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol InfoViewHandler <NSObject>

- (void)composeQuestionsEmail;

@end

@interface InfoView : UIView <UITextViewDelegate>

- (id)initWithFrame:(CGRect)frame
           delegate:(id<InfoViewHandler>)delegate;

- (void)setBackgroundImage:(UIImage *)backgroundImage;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton *closeButton;

@end
