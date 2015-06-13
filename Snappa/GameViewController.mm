//
//  ViewController.m
//  Snappa
//
//  Created by Sam Edson on 6/13/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#import "GameViewController.h"

#import "UIImageEffects.h"
#import "Util.h"

#include "SnappaGame.h"


#define OLD_DRINKSTRING 0

static const CGFloat iPhoneXInfoViewOffset = 45;
static const CGFloat iPhoneXWholeViewOffset = 80;

@interface GameViewController () {
    SnappaGame *snappaGame_;
}

@property (nonatomic, strong) NSArray *playerButtonsInOrder;

@property (nonatomic, strong) DragChoiceView *cupChoicesView;
@property (nonatomic, strong) DragChoiceView *throwChoicesView;

@property (nonatomic, strong) NSString *gameID;

@property (nonatomic) bool hasBeenMovedDown;

@end


@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    std::array<std::string, 4> players = { "UsLeft",
                                           "UsRight",
                                           "ThemLeft",
                                           "ThemRight" };
    snappaGame_ = new SnappaGame(players);
    snappaGame_->start();
    
    self.gameID = [Util randomStringWithLength:32];
    
    self.playerButtonsInOrder = @[self.usLeftPlayerButton,
                                  self.usRightPlayerButton,
                                  self.themLeftPlayerButton,
                                  self.themRightPlayerButton];
    self.hasBeenMovedDown = false;
        
    CGRect frame = self.view.frame;

    // Cover view
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y - 200,
                                                              frame.size.width, frame.size.height + 200)];
    self.coverView.backgroundColor = [UIColor darkGrayColor];
    self.coverView.hidden = true;
    [self.view addSubview:self.coverView];
    
    // Putting magic numbers here tells the Affine Transform to not
    // transform this subview. Super hacky.
    CGRect infoViewFrame = CGRectMake(frame.origin.x,
                                      frame.origin.y,
                                      320,
                                      568);
    if ([Util isIphoneX]) {
        infoViewFrame = CGRectMake(frame.origin.x,
                                   frame.origin.y - iPhoneXInfoViewOffset,
                                   320,
                                   720);
    }
    self.infoView = [[InfoView alloc] initWithFrame:infoViewFrame
                                           delegate:self];
    self.infoView.hidden = true;
    [self.view addSubview:self.infoView];
    
    
    // Roll Five From Sink Buttons
    self.rolledFiveFromSinkButton.hidden = true;
    self.rolledOtherFromSinkButton.hidden = true;
    
    
    DragChoiceViewChoice *leftChoice = [[DragChoiceViewChoice alloc] init];
    leftChoice.name = @"Sank\nCup";
    leftChoice.handler = ThrowStringCupSink;
    DragChoiceViewChoice *topChoice = [[DragChoiceViewChoice alloc] init];
    topChoice.name = @"Hit Cup Off Table";
    topChoice.handler = ThrowStringCup;
    DragChoiceViewChoice *rightChoice = [[DragChoiceViewChoice alloc] init];
    rightChoice.name = @"Hit\nCup\nRoll\nFive";
    rightChoice.handler = ThrowStringCupFive;
    DragChoiceViewChoice *bottomChoice = [[DragChoiceViewChoice alloc] init];
    bottomChoice.name = @"Hit Table Off Back";
    bottomChoice.handler = ThrowStringBack;
    
    CGRect cupChoicesFrame = CGRectMake(frame.origin.x, frame.origin.y - 70,
                                        frame.size.width, frame.size.height);
    _cupChoicesView = [[DragChoiceView alloc] initWithFrame:cupChoicesFrame
                                                     parent:self
                                                   delegate:self
                                                  coverView:_coverView
                                                 leftChoice:leftChoice
                                                  topChoice:topChoice
                                                rightChoice:rightChoice
                                               bottomChoice:bottomChoice];
    [_cupChoicesView.operatorButton setTitle:@"Score" forState:UIControlStateNormal];

    [self.view addSubview:_cupChoicesView];
    
    
    DragChoiceViewChoice *leftChoiceThrow = [[DragChoiceViewChoice alloc] init];
    leftChoiceThrow.name = @"←\nCatch";
    leftChoiceThrow.handler = ThrowStringLeftCatch;
    DragChoiceViewChoice *topChoiceThrow = [[DragChoiceViewChoice alloc] init];
    topChoiceThrow.name = @"Miss Table";
    topChoiceThrow.handler = ThrowStringMissTable;
    DragChoiceViewChoice *rightChoiceThrow = [[DragChoiceViewChoice alloc] init];
    rightChoiceThrow.name = @"→\nCatch";
    rightChoiceThrow.handler = ThrowStringRightCatch;
    DragChoiceViewChoice *bottomChoiceThrow = [[DragChoiceViewChoice alloc] init];
    bottomChoiceThrow.name = @"Nothing";
    bottomChoiceThrow.handler = ThrowStringSloppyPlay;
    
    CGRect throwChoicesFrame = CGRectMake(frame.origin.x, frame.origin.y + 70,
                                          frame.size.width, frame.size.height);
    _throwChoicesView = [[DragChoiceView alloc] initWithFrame:throwChoicesFrame
                                                       parent:self
                                                     delegate:self
                                                    coverView:_coverView
                                                   leftChoice:leftChoiceThrow
                                                    topChoice:topChoiceThrow
                                                  rightChoice:rightChoiceThrow
                                                 bottomChoice:bottomChoiceThrow];
    [_throwChoicesView.operatorButton setTitle:@"NA" forState:UIControlStateNormal];
    
    
    // Disable these at the start so that you can't click them when
    // choosing the starting player
    self.usLeftPlayerButton.enabled = false;
    self.usRightPlayerButton.enabled = false;
    self.themLeftPlayerButton.enabled = false;
    self.themRightPlayerButton.enabled = false;
    
    [self.view addSubview:_throwChoicesView];
    
    // PlayerNameView
    self.playerNameView = [[PlayerNameView alloc] initWithFrame:self.view.frame
                                                       delegate:self];
    [self.view addSubview:self.playerNameView];
    
    // Screen Correction
    static const CGFloat deviceScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    static const CGFloat deviceScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    static const CGFloat iphone5ScreenWidth = 320;
    static const CGFloat iphone5ScreenHeight = 568;

    // Starting Choice View
    CGRect startingChoiceFrame = _startingChoiceView.frame;
    
    // iPhone X
    if ([Util isIphoneX]) {
        [_startingChoiceView setFrame:CGRectMake(startingChoiceFrame.origin.x,
                                                 startingChoiceFrame.origin.y - 100,
                                                 startingChoiceFrame.size.width,
                                                 startingChoiceFrame.size.height)];
        self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                     (deviceScreenWidth / iphone5ScreenWidth),
                                                     (deviceScreenWidth / iphone5ScreenWidth));


    } else {
        [_startingChoiceView setFrame:CGRectMake(startingChoiceFrame.origin.x,
                                                 startingChoiceFrame.origin.y - 150,
                                                 startingChoiceFrame.size.width,
                                                 startingChoiceFrame.size.height)];
        self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                     (deviceScreenWidth / iphone5ScreenWidth),
                                                     (deviceScreenHeight / iphone5ScreenHeight));
    }
    
    [self periodicallySyncWithServer];
}

- (void)viewDidAppear:(BOOL)animated {
    [self moveViewDownOnce];
    [self.view bringSubviewToFront:_coverView];
    [self.view bringSubviewToFront:_throwChoicesView];
    [self.view bringSubviewToFront:_cupChoicesView];
    [self.view bringSubviewToFront:_startingChoiceView];
    [self.view bringSubviewToFront:_infoView];
    [self.view bringSubviewToFront:_playerNameView];
}

- (void)moveViewDownOnce {
    if (!self.hasBeenMovedDown && [Util isIphoneX]) {
        CGRect frame = self.view.frame;
        [self.view setFrame:CGRectMake(frame.origin.x,
                                       frame.origin.y + iPhoneXWholeViewOffset,
                                       frame.size.width,
                                       frame.size.height)];
        self.hasBeenMovedDown = true;
    }
}

- (void)step:(std::string)input {
    SnappaOutput output;
    if (input == UndoThrowString) {
        output = snappaGame_->undo();
    } else {
        output = snappaGame_->step(SnappaEvent(input));
        if (output.message() == "") {
            return;
        }
    }
    
    NSString *outputString = [NSString stringWithUTF8String:output.message().c_str()];
    NSLog(@"LOG:\n%@", [NSString stringWithUTF8String:snappaGame_->getLog().c_str()]);

    [self setCurrentPlayerPosition];
    
    if ([outputString rangeOfString:@"||"].length != 0) {
        [self parseOutputStringAndUpdate:outputString];
    } else {
        NSLog(@"[Error] invalid formatted output string");
    }
    
    [self saveGame];
}


- (void)setCurrentPlayerPosition:(PlayerPosition)position {
    SnappaOutput output = snappaGame_->setCurrentPlayer(position);
    
    NSLog(@"LOG:\n%@", [NSString stringWithUTF8String:snappaGame_->getLog().c_str()]);
    
    [self setCurrentPlayerPosition];
}

#pragma mark - delegates

- (void)dragNoop {
    // I could really spend time to figure out why this causes the DragChoiceViews' operator
    // buttons to go on top of the infoView during steps but I'm not because I don't have time
    [self.view bringSubviewToFront:self.infoView];
}

- (void)dragChoiceStep:(std::string)input {
    [self step:input];
    
    // I could really spend time to figure out why this causes the DragChoiceViews' operator
    // buttons to go on top of the infoView during steps but I'm not because I don't have time
    [self.view bringSubviewToFront:self.infoView];
}

- (void)didNamePlayerUsLeft:(NSString *)usLeft
                    usRight:(NSString *)usRight
                   themLeft:(NSString *)themLeft
                  themRight:(NSString *)themRight {
    
    self.playerNames = @[usLeft, usRight, themLeft, themRight];
    for (int i = 0; i < 4; i++) {
        NSString *playerName = self.playerNames[i];
        UIButton *playerButton = (UIButton *)self.playerButtonsInOrder[i];
        [playerButton setTitle:playerName
                      forState:UIControlStateNormal];
        playerButton.layer.cornerRadius = 50;
        playerButton.layer.borderWidth = 5;
        playerButton.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    
    [self.playerNameView removeFromSuperview];
}

- (void)didLoadSavedGame {
    [self.playerNameView removeFromSuperview];
    
    [self loadSavedGame:[Util getSavedGame]];
}

- (void)composeQuestionsEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Snappa App"];
        [controller setToRecipients:@[@"snappaapp@gmail.com"]];
        [controller setMessageBody:@"" isHTML:NO];
        if (controller) [self presentViewController:controller animated:YES completion:nil];
    } else {
        NSLog(@"CANNOT SEND MAIL");
    }
}


#pragma mark - WTF

- (void)parseOutputStringAndUpdate:(NSString *)outputString {
    NSArray *actionPointsSplit = [outputString componentsSeparatedByString:@"||"];
    
    NSString *pointsString = actionPointsSplit[1];
    NSArray *pointsSplit = [pointsString componentsSeparatedByString:@"|"];
    
    NSString *usPoints = pointsSplit[1];
    long usThirds = [pointsSplit[3] integerValue];
    NSString *themPoints = pointsSplit[5];
    long themThirds = [pointsSplit[7] integerValue];
    
    
    
    NSString *usDrinkString = [self makeDrinkStringEmojisForDrinks:(int)usThirds / 3
                                                            thirds:(int)usThirds];
    [self.usLabel setText:[NSString stringWithFormat:@"%@\n%@", usPoints, usDrinkString]];
    
    
#if OLD_DRINKSTRING
#else
//    if (self.usLabel.text.length >= 8) {
//        [self.usLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
//                                              size:20]];
//    } else {
//        [self.usLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
//                                              size:30]];
//    }
#endif
    
    
    

    NSString *themDrinkString = [self makeDrinkStringEmojisForDrinks:(int)themThirds / 3
                                                              thirds:(int)themThirds];
    [self.themLabel setText:[NSString stringWithFormat:@"%@\n%@", themPoints, themDrinkString]];

#if OLD_DRINKSTRING
#else
//    if (self.themLabel.text.length >= 8) {
//        [self.themLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
//                                                size:20]];
//    } else {
//        [self.themLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
//                                                size:30]];
//    }
#endif
    
    
    
    
    if ([outputString rangeOfString:@"CupSink"].length != 0) {
        self.rolledFiveFromSinkButton.hidden = false;
        self.rolledOtherFromSinkButton.hidden = false;
        [self.view bringSubviewToFront:self.rolledFiveFromSinkButton];
        [self.view bringSubviewToFront:self.rolledOtherFromSinkButton];
    }
}

- (NSString *)makeDrinkStringEmojisForDrinks:(int)drinks
                                      thirds:(int)thirds {
#if OLD_DRINKSTRING
    return [self addDrinkStringFractions:[NSString stringWithFormat:@"%i", drinks]
                               forThirds:thirds];
#else
    NSString *drinkString = @"";
    if (drinks != 0 && drinks <= 4) {
        while (drinks > 0) {
            if (drinks % 2 == 0) {
                drinkString = [@"🍻" stringByAppendingString:drinkString];
                drinks -= 2;
            } else {
                drinkString = [@"🍺" stringByAppendingString:drinkString];
                drinks -= 1;
            }
        }
        return [self addDrinkStringFractions:drinkString forThirds:thirds];
    } else {
        if ((drinks == 0 && thirds == 0) || drinks > 0) {
            drinkString = [NSString stringWithFormat:@"%i", drinks];
        }
        NSLog(@"%@", drinkString);
        drinkString = [self addDrinkStringFractions:drinkString
                                          forThirds:thirds];
        NSLog(@"%@", drinkString);
        NSLog(@"%@", [NSString stringWithFormat:@"%@x🍺", drinkString]);
        NSLog(@"---------");
        return [NSString stringWithFormat:@"%@x🍺", drinkString];
    }
#endif
}

- (NSString *)addDrinkStringFractions:(NSString *)drinkString
                            forThirds:(int)thirds {
    if ([drinkString compare:@"0"] == 0 and thirds > 0) {
        drinkString = @"";
    }
    if (thirds % 3 == 1) {
        return [NSString stringWithFormat:@"%@⅓", drinkString];
    } else if (thirds % 3 == 2) {
        return [NSString stringWithFormat:@"%@⅔", drinkString];
    }
    
    return drinkString;
}

- (void)setCurrentPlayerPosition {
    PlayerPosition currentPosition = snappaGame_->getCurrentPlayer();
    PlayerPosition nextPosition = snappaGame_->nextPlayer();

    for (UIButton *playerButton in self.playerButtonsInOrder) {
        playerButton.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    
    ((UIButton *)self.playerButtonsInOrder[currentPosition]).layer.borderColor = [[UIColor colorWithRed:13/255.0 green:171/255.0 blue:255/255.0 alpha:1] CGColor];
    
    ((UIButton *)self.playerButtonsInOrder[nextPosition]).layer.borderColor = [[UIColor colorWithRed:13/255.0 green:171/255.0 blue:255/255.0 alpha:0.2] CGColor];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///////////////////////////////////////////////////////////////
#pragma mark - Loading, Saving, and Networking

- (void)syncWithServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (self) {
            [self syncWithServerNotAsync];
        }
    });
    return;
}

- (void)periodicallySyncWithServer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
            NSLog(@"Periodic sync");
            @synchronized (self) {
                [self syncWithServerNotAsync];
            }
            [NSThread sleepForTimeInterval:240];
        }
    });
    return;
}
                
- (void)syncWithServerNotAsync {
    // Create the game log in JSON data
    NSString *gameLog = [NSString stringWithUTF8String:snappaGame_->getLog().c_str()];

    NSString *gameLogWithNames = [NSString stringWithFormat:@"%@|%@|%@|%@\n%@", self.playerNames[0], self.playerNames[1], self.playerNames[2], self.playerNames[3], gameLog];
    NSDictionary *reqDict = @{
      @"version": @"1.0.0", // Sends whole log and overwrites the file
      @"report": gameLogWithNames,
      @"gameID": self.gameID,
      @"account": @{
              @"id": [Util getDeviceID],
      },
    };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reqDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSLog(@"%@", reqDict);
    
    // Create the request and set the parameters
    NSURL *url = [NSURL URLWithString:@"http://35.192.125.229/SnappaReport.report"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    // Sent the request
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if ([data length] > 0 && error == nil && [httpResponse statusCode] == 200) {
                                   NSLog(@"%@", response.description);
                               }
                           }];
}

- (void)saveGame {
    NSString *gameLog = [NSString stringWithUTF8String:snappaGame_->getLog().c_str()];
    // TODO: actually make this dependent on the state of the game
    if (gameLog.length > 200) {
        [Util saveGame:gameLog];
    }
}

- (void)loadSavedGame:(NSString *)gameLog {
    
    // Create a new snappa game
    SnappaGame newSnappaGame = SnappaGame(snappaGame_->getPlayers());
    
    // Decode the saved game log into our new snappa game
    SnappaOutput finalOutput = SnappaGame::decode(newSnappaGame, [gameLog UTF8String]);
    
    // Set our game to the new one
    // TODO: free the old snappaGame_
    *snappaGame_ = newSnappaGame;

    // Set the players correctly
    std::array<std::string, 4> players = snappaGame_->getPlayers();
    [self didNamePlayerUsLeft:[NSString stringWithUTF8String:players[0].c_str()]
                      usRight:[NSString stringWithUTF8String:players[1].c_str()]
                     themLeft:[NSString stringWithUTF8String:players[2].c_str()]
                    themRight:[NSString stringWithUTF8String:players[3].c_str()]];
    [self setCurrentPlayerPosition];

    // Hide the starting player selector
    [self hideStartButtons];
     
    // Act on the last action
    NSString *outputString = [NSString stringWithUTF8String:finalOutput.message().c_str()];
    if ([outputString rangeOfString:@"||"].length != 0) {
        [self parseOutputStringAndUpdate:outputString];
    } else {
        NSLog(@"[Error] invalid formatted output string");
    }
}



///////////////////////////////////////////////////////////////
#pragma mark - choose player

- (IBAction)setPlayerUseLeft:(id)sender {
    [self setCurrentPlayerPosition:US_LEFT];
}

- (IBAction)setPlayerUsRight:(id)sender {
    [self setCurrentPlayerPosition:US_RIGHT];
}

- (IBAction)setPlayerThemLeft:(id)sender {
    [self setCurrentPlayerPosition:THEM_LEFT];
}

- (IBAction)setPlayerThemRight:(id)sender {
    [self setCurrentPlayerPosition:THEM_RIGHT];
}


///////////////////////////////////////////////////////////////
#pragma mark - state expects high low


- (IBAction)usLeftStart:(id)sender {
    [self step:PlayerPositionStringUsLeft];
    [self hideStartButtons];
}

- (IBAction)usRightStart:(id)sender {
    [self step:PlayerPositionStringUsRight];
    [self hideStartButtons];
}

- (IBAction)themLeftStart:(id)sender {
    [self step:PlayerPositionStringThemLeft];
    [self hideStartButtons];
}

- (IBAction)themRightStart:(id)sender {
    [self step:PlayerPositionStringThemRight];
    [self hideStartButtons];
}

- (void)hideStartButtons {
    self.usLeftButton.enabled = false;
    self.usRightButton.enabled = false;
    self.themLeftButton.enabled = false;
    self.themRightButton.enabled = false;
    
    self.usLeftPlayerButton.enabled = true;
    self.usRightPlayerButton.enabled = true;
    self.themLeftPlayerButton.enabled = true;
    self.themRightPlayerButton.enabled = true;
    
    [UIView animateWithDuration:0.25
     delay:0
     options: UIViewAnimationCurveEaseOut
     animations:^{
         self.usLeftButton.alpha = 0;
         self.usRightButton.alpha = 0;
         self.themLeftButton.alpha = 0;
         self.themRightButton.alpha = 0;
         
         self.startingPlayerLabel.alpha = 0;
         self.startingChoiceView.alpha = 0;
     }
     completion:^(BOOL finished){
         self.usLeftButton.hidden = true;
         self.usRightButton.hidden = true;
         self.themLeftButton.hidden = true;
         self.themRightButton.hidden = true;
         
         self.startingPlayerLabel.hidden = true;
         self.startingChoiceView.hidden = true;
     }];
}



///////////////////////////////////////////////////////////////
#pragma mark - state expects roll five

- (IBAction)rolledFiveFromSinkG3TWAstED:(id)sender {
    [self step:RollFiveOutcomeDrinkAnotherBeer];
    self.rolledFiveFromSinkButton.hidden = true;
    self.rolledOtherFromSinkButton.hidden = true;
}

- (IBAction)rolledOtherFromSink:(id)sender {
    [self step:RollFiveOutcomeDidNotRollFive];
    self.rolledFiveFromSinkButton.hidden = true;
    self.rolledOtherFromSinkButton.hidden = true;
}


///////////////////////////////////////////////////////////////
#pragma mark - util actions

- (IBAction)undoAction:(id)sender {
    // TODO actually make this undo
    [self step:UndoThrowString];
}

- (IBAction)playerOrderToggleAction:(id)sender {
    snappaGame_->togglePlayerOrder();
    [self setCurrentPlayerPosition];
}

- (UIImage*)getBlurredImage {
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    UIGraphicsBeginImageContext(size);
    CGFloat y = 0;
    if ([Util isIphoneX]) {
        y = iPhoneXWholeViewOffset;
    }
    [self.view drawViewHierarchyInRect:(CGRect){ CGPointMake(0, y),
                                                 self.view.frame.size.width,
                                                 self.view.frame.size.height }
                    afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [UIImageEffects imageByApplyingLightEffectToImage:image];
//    image = [UIImageEffects imageByApplyingDarkEffectToImage:image];
    image = [UIImageEffects imageByApplyingBlurToImage:image
                                            withRadius:2
                                             tintColor:nil
                                 saturationDeltaFactor:1
                                             maskImage:nil];
    
    return image;
}

- (IBAction)showInfo:(id)sender {
    [self.infoView setBackgroundImage:[self getBlurredImage]];
    self.infoView.hidden = false;
}

@end
