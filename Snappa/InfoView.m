//
//  InfoView.m
//  Snappa
//
//  Created by Sam Edson on 10/21/15.
//  Copyright © 2015 Sam Edson. All rights reserved.
//

#import "InfoView.h"

NSString *instructionsText = @"\
\n\n\n\n\n\
We the players of the game called Snappa, to create more coherent play and ensure the proper, rapid consumption of a 30, do hereby codify these rules for matches, present and future, to act as an introduction to new players, a clarification for veteran players, and as final word in any dispute.\
\n\n\n\
1. Two teams of two shall be seated across a table, each player with an initially full mug of beer.\
\n\n\
2. Mugs shall be glass or ceramic, and the table shall be roughly 7 feet by 4 feet. Mugs shall be placed at a hand's length from the rear and side of the table.\
\n\n\
3. The dice to be used will be a standard Western cube die, unloaded and with low-radius corners.\
\n\n\
4. Gameplay shall begin with a toss by one team. While the dice is in the air, the opposite team shall declare high or low. The number that the dice shows shall be ruled high or low based upon being greater than 3 or less than or equal to 3, respectively. If the opposing team's call is correct, they shall receive first toss; if they are incorrect, the throwing team shall have first toss.\
\n\n\
5. Teams and players within shall alternate tosses as the game progresses. Each player shall toss every fourth shot. If play falls out of order, each player shall take a sip to sloppy play.\
\n\n\
6. Each toss should be an underhanded throw (although exceptions can be made), reaching a reasonable height above the table, such that the throw is clearly dominated by vertical and not horizontal motion.\
\n\n\
7. All players shall remain seated at the start of the throw. Once the dice has left the tosser's hand, the defending team may leave their seats.\
\n\n\
8. 'Low' calls shall be at the discretion of the defending team. 'Low' shall be defined as a path that does not feel as if it reached the minimum height defined above.\
\n\n\
9. If the dice touches the ceiling or any foreign object above the plane of the table, the dice shall be considered 'dead' and the turn will be over without penalization.\
\n\n\n\
10. The dice shall be 'in play' as soon as it touches the table.\
\n\n\
   (a) If the dice never touches the table, the throwing team shall owe 1/3 of their beer.\
\n\n\
   (b) If the dice touches the table, but bounces off the sides of the table, the throw shall be dead and there will be no penalization.\
\n\n\
   (c) If the dice bounces off the far edge of the table, or off of the cup and off any edge of the table, the throw is live. If the defending team catches the dice, there is no penalization. If the dice is dropped or trapped, the throwing team gets 1 point, and the defending team owes 1/3 of their beer.\
\n\n\
   (d) If the dice enters the cup and stays in the cup, a 'sink', the throwing team shall score 1 point, and the defending team owes the remainder of their beer.\
\n\n\
   (e) If the tossing team sinks its own cup, the tossing team shall owe the remainder of their beer but no point shall be scored.\
\n\n\n\
11. Catching is defined as the point at which the die has come to rest.\
\n\n\
   (a) A catch must be made with one hand. Bobbling is permitted so long as the final stopping is made with one hand.\
\n\n\
   (b) A team may reach for the same dice and both have their hands on the dice when it comes to rest. If, upon separation, the dice is controlled, a catch is counted.\
\n\n\
   (c) A catch is not made when the dice is stopped outside the hands. If a die is stopped with an open hand against a surface, it shall be discounted as a catch, herein called a 'trap'. If a die is stopped on an another body part, it shall also be discounted as a catch.\
\n\n\
   (d) A catch may not be made over the airspace of the table off of a table surface bounce.\
\n\n\
   (e) If a catch is attempted and failed on a side-bound toss, and the dice then bounces again off the edge or off of a cup, the toss becomes live.\
\n\n\
   (f) If a dice is live, and bobbled back onto the table, the defense may only catch the dice with the hand between the surface of the table and the dice. Otherwise, if the dice again goes off any edge or if the dice comes to rest on the table, it shall be discounted as a catch.\
\n\n\n\
12. Rules of 5s\
\n\n\
   (a) If, upon a toss bouncing off of the cup, the dice remains on the table, it shall be allowed to continue spinning until it comes to rest. If the upright face shows a 5, the defending team shall drink 1/3, but no point shall be scored. One snag is allowed per game per team, by the defense stopping the spinning dice.\
\n\n\
   (b) Upon a sink, the defending team shall roll the dice. If a 5 is shown, the defending team shall owe 1 full beer, but no point shall be scored.\
\n\n\n\
13. Games shall be played to 7 points, but must be won by minimum 2, except under agreement by both teams. All beer must be finished upon the game-ending point.\
\n\n\
14. Each partner shall be responsible for his own beer and may drink whenever he so chooses, so long as the beer is finished by any finishing throw. Partners may agree to trade beer; however the requisite amount of beer must be finished except under extenuating circumstances.\
\n\n\
15. Each team shall high five, fist bump, or salute mugs upon scoring of points.\
\n\n\
16. Play honorably.\
\n\n\
\n\n\
\n\n\
\n\n\
\n\n\
";

@interface InfoView()

@property (nonatomic, strong) id<InfoViewHandler> delegate;

@end

@implementation InfoView

- (id)initWithFrame:(CGRect)frame
           delegate:(id<InfoViewHandler>)delegate {
    self = [super initWithFrame:frame];
    if ( !self ) { return nil; }
    
    self.delegate = delegate;
        
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:self.backgroundImageView];
    
    CGFloat marginX = 10;
    CGFloat marginY = 20;
//    CGFloat width = self.frame.size.width;

    
//    CGRect instructionsLabelFrame = CGRectMake(marginX,
//                                               marginY + 140,
//                                               width - 2 * marginX,
//                                               40);
//    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:instructionsLabelFrame];
//    [instructionsLabel setText:@"Instructions Coming Soon"];
//    [instructionsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
//                                               size:24]];
//    instructionsLabel.textAlignment = NSTextAlignmentCenter;
//    instructionsLabel.textColor = [UIColor whiteColor];
//    [self addSubview:instructionsLabel];

    
    // TODO
    // TODO
    // TODO
    // TODO
    // ADD DRAWINGS INSTRUCTIONS
    
    
    CGRect infoFrame = CGRectMake(frame.origin.x + marginX,
                         
                                  frame.origin.y + marginY,
                                  frame.size.width - 2 * marginX,
                                  frame.size.height - 2 * marginX);
    UITextView *infoText = [[UITextView alloc] initWithFrame:infoFrame];
    infoText.text = instructionsText;
    infoText.delegate = self;
    infoText.editable = false;
    [infoText setScrollEnabled:YES];
    [infoText setUserInteractionEnabled:YES];
    infoText.backgroundColor = [UIColor clearColor];
    [infoText setTextColor:[UIColor blackColor]];
//    [infoText setTextColor:[UIColor whiteColor]];
    [infoText setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
                                      size:18]];
    [self addSubview:infoText];
    
    
//    CGRect emailButtonFrame = CGRectMake(0,
//                                         marginY + 4200,
//                                         width - 2 * marginX,
//                                         40);
//    UIButton *emailButton = [[UIButton alloc] initWithFrame:emailButtonFrame];
//    [emailButton setTitle:@"Questions? Email Me."
//                 forState:UIControlStateNormal];
//    [emailButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
//                                                    size:24]];
//    [emailButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [emailButton addTarget:self.delegate
//                    action:@selector(composeQuestionsEmail)
//          forControlEvents:UIControlEventTouchUpInside];
////    [emailButton setTitleColor:[UIColor blackColor]
////                      forState:UIControlStateNormal];
//    [infoText addSubview:emailButton];
    
    
    
    CGRect closeButtonFrame = CGRectMake(0,
                                         24,
                                         70,
                                         70);
    self.closeButton = [[UIButton alloc] initWithFrame:closeButtonFrame];
    [self.closeButton addTarget:self
                         action:@selector(closeInfo)
               forControlEvents:UIControlEventTouchUpInside];
    
    CGRect closeButtonInnerFrame = CGRectMake(15,
                                              15,
                                              36,
                                              36);
    UIButton *closeButtonInner = [[UIButton alloc] initWithFrame:closeButtonInnerFrame];

    [closeButtonInner setTitle:@"X" forState:UIControlStateNormal];
    [closeButtonInner.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
                                                         size:24]];
    
    [closeButtonInner setTitleColor:[UIColor blackColor]
                           forState:UIControlStateNormal];
    closeButtonInner.layer.cornerRadius = closeButtonInner.frame.size.width / 2;
    closeButtonInner.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [closeButtonInner addTarget:self
                         action:@selector(closeInfo)
               forControlEvents:UIControlEventTouchUpInside];
    
//    closeButtonInner.layer.cornerRadius = self.closeButton.frame.size.width / 2;
//    closeButtonInner.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//
    
    UIButton *closeButtonInterceptor = [[UIButton alloc] initWithFrame:closeButtonFrame];
    [closeButtonInterceptor addTarget:self
                         action:@selector(closeInfo)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.closeButton addSubview:closeButtonInner];
    [self.closeButton addSubview:closeButtonInterceptor];
    [self.closeButton bringSubviewToFront:closeButtonInterceptor];
    
    [self addSubview:self.closeButton];
    [self bringSubviewToFront:self.closeButton];
    
    return self;
}

- (void)closeInfo {
    self.hidden = true;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    [self.backgroundImageView setImage:backgroundImage];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [textView resignFirstResponder];
}

@end
