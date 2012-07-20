//
//  RootViewController.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright rlatngus0333@naver.com 2012년. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface RootViewController : UIViewController <GKMatchmakerViewControllerDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate>
{
    GKMatch *myMatch;
    SEL m_recieveDataCallback;
    id m_setCallbackClass;
}
@property (nonatomic, retain) GKMatch *myMatch;
-(void)startGameCenter;
-(BOOL)isGameCenterAvailable;
-(void)authenticateLocalPlayer;
-(void)showMatchMaker;
-(void)setRecieveDataCallback:(id)callClass selector:(SEL)selector;
-(void)sendData:(NSString *)sendData;

@end
