//
//  StagesAllGroupViewCtr.h
//  Montessori_Geography
//
//  Created by MAC236 on 18/03/14.
//  Copyright (c) 2014 MAC 227. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

#import "MGAGamePiece.h"
#import "MapFrameModal.h"

@protocol StageCompleteForAllGroupDelegate <NSObject>

@optional
-(void)StageCompleteForAllGroup;
@end

@interface StagesAllGroupViewCtr : UIViewController <MGAGamePieceDelegate>
{
    NSMutableArray *_gamePieceArray;
    
    int _currentStage;
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
    
    
    //Map Frame Modal
    MapFrameModal *obj_mapFrame;
    
    IBOutlet UILabel *_lblStageTitle;
    
    //Stage Complete Delegate
    id <StageCompleteForAllGroupDelegate> _StageAllGroupDelegate;
}
@property (nonatomic,strong) id <StageCompleteForAllGroupDelegate> _StageAllGroupDelegate;
@property (nonatomic,readwrite) int _currentGameMode;
@property (nonatomic,readwrite) int _currentStage;


@end
