//
//  IntroductionViewCtr.h
//  Montessori_Geography
//
//  Created by Chirag on 30/12/13.
//  Copyright (c) 2013 MAC 227. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "StagesViewCtr.h"
#import "StagesAllGroupViewCtr.h"

@interface IntroductionViewCtr : UIViewController <StageCompleteDelegate,UIAlertViewDelegate,StageCompleteForAllGroupDelegate,AVAudioPlayerDelegate>
{
    //Welcome View
   __weak IBOutlet UIView *WelComeView,*AsiaView,*ViewContry;
   __weak IBOutlet UILabel *lblWelcome,*lblMonte,*lblAsia,*lblLine1,*lblStageTitle;
   __weak IBOutlet UIButton *btnMap,*btnFlag,*btnMenu;
    
   __weak IBOutlet UIImageView *img_Map,*img_Logo;
    
    CALayer *plane;
    
    int _CurrentMode;
    int _CurrentStage;
    int _CurrentGroup;
    
    
    //Purchase Screen
   __weak IBOutlet UIView *View_Purchase,*View_Menu;
   __weak IBOutlet UIButton *btnMapsPurchase,*btnFlagsPurchase,*btnMapsFlagsPurchase,*btnReset,*btnRestorePurchases;
   __weak IBOutlet UILabel *lblMapsPurchase,*lblFlagsPurchase,*lblMapsFlagsPurchase,*lblReset;
   __weak IBOutlet UIImageView *img_Shadow;
   __weak IBOutlet UILabel *lblBlue,*lblBorderMenu;
   __weak IBOutlet UILabel *lblMonte_Purchase,*lblAsia_Purchase;
    
    NSTimer *plane_timer;
    CGFloat plane_Animation_Time,plane_Current_Time;
}
@property (nonatomic,strong) AVAudioPlayer *plane_flying;
@property (nonatomic,strong) AVAudioPlayer *plane_landing;
@property (nonatomic,strong) AVAudioPlayer *plane_takeoff;

@end