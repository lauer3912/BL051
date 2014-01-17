//
//  IntroductionViewCtr.h
//  Montessori_Geography
//
//  Created by Chirag on 30/12/13.
//  Copyright (c) 2013 MAC 227. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "StagesViewCtr.h"

@interface IntroductionViewCtr : UIViewController <StageCompleteDelegate>
{
    //Welcome View
    IBOutlet UIView *WelComeView;
    IBOutlet UILabel *lblWelcome,*lblMonte,*lblAsia,*lblLine1;
    IBOutlet UIButton *btnMap,*btnFlag,*btnMenu;
    
    IBOutlet UIImageView *img_Map,*img_Logo;
        
    CALayer *plane;
    
    int _CurrentMode;
    int _CurrentStage;
    int _CurrentGroup;
    
    
    //Purchase Screen
    IBOutlet UIView *View_Purchase;
    IBOutlet UIButton *btnMapsPurchase,*btnFlagsPurchase,*btnMapsFlagsPurchase,*btnReset;
    IBOutlet UILabel *lblMapsPurchase,*lblFlagsPurchase,*lblMapsFlagsPurchase,*lblReset;
    IBOutlet UIImageView *img_Arrow,*img_Shadow;
    IBOutlet UILabel *lblWhite,*lblBlue;
    
}
@end
