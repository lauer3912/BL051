//
//  StagesViewCtr.h
//  Montessori_Geography
//
//  Created by Chirag on 08/01/14.
//  Copyright (c) 2014 MAC 227. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

#import "MGAGamePiece.h"

@protocol StageCompleteDelegate <NSObject>

@optional
-(void)StageComplete;
@end

@interface StagesViewCtr : UIViewController <MGAGamePieceDelegate>
{
    NSMutableArray *_gamePieceArray;
    
    int _currentStage;
    int _currentGroup;
    int _currentStep;
    int _currentGamePieceIndex;
    int _currentGameMode;
    
    int _nooftimesCompletedStep1;
    
    NSMutableArray *_gamePiecesCompletedInCurrentStep;
    
    IBOutlet UILabel *_lbl_Instruction;
    IBOutlet UIImageView *_imgView_Stage_Map;
    
    //Plane For Fly After Activity Completion
    CALayer *plane;
    
    //Timer For No Action in Step 1 & 3
    NSTimer *Step_Timer;
    
    //Stage or Group Complete Delegate
    id <StageCompleteDelegate> _Stagedelegate;
}
@property (nonatomic,strong) id <StageCompleteDelegate> _Stagedelegate;
@property (nonatomic,readwrite) int _currentGameMode;
@property (nonatomic,readwrite) int _currentStage;
@property (nonatomic,readwrite) int _currentGroup;
@end
