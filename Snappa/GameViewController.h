//
//  ViewController.h
//  Snappa
//
//  Created by Sam Edson on 6/13/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MFMailComposeViewController.h>

#include <string>

#import "DragChoiceView.h"
#import "PlayerNameView.h"
#import "InfoView.h"

@interface GameViewController : UIViewController <MFMailComposeViewControllerDelegate, DragChoiceViewCaller, PlayerNameViewHandler, InfoViewHandler>

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) PlayerNameView *playerNameView;
@property (nonatomic, strong) NSArray *playerNames;

@property (nonatomic, strong) InfoView *infoView;

- (void)syncWithServer;
- (void)saveGame;

@property (weak, nonatomic) IBOutlet UIButton *usLeftPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *usRightPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *themLeftPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *themRightPlayerButton;

- (IBAction)setPlayerUseLeft:(id)sender;
- (IBAction)setPlayerUsRight:(id)sender;
- (IBAction)setPlayerThemLeft:(id)sender;
- (IBAction)setPlayerThemRight:(id)sender;

- (IBAction)usLeftStart:(id)sender;
- (IBAction)usRightStart:(id)sender;
- (IBAction)themLeftStart:(id)sender;
- (IBAction)themRightStart:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *usLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *usRightButton;
@property (weak, nonatomic) IBOutlet UIButton *themLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *themRightButton;
@property (weak, nonatomic) IBOutlet UILabel *startingPlayerLabel;
@property (weak, nonatomic) IBOutlet UIView *startingChoiceView;

- (IBAction)undoAction:(id)sender;
- (IBAction)playerOrderToggleAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *undoActionButton;

@property (weak, nonatomic) IBOutlet UILabel *usLabel;
@property (weak, nonatomic) IBOutlet UILabel *themLabel;

@property (weak, nonatomic) IBOutlet UIButton *rolledFiveFromSinkButton;
@property (weak, nonatomic) IBOutlet UIButton *rolledOtherFromSinkButton;
- (IBAction)rolledFiveFromSinkG3TWAstED:(id)sender;
- (IBAction)rolledOtherFromSink:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *infoButton;
- (IBAction)showInfo:(id)sender;

@end

