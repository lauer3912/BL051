//
//  StagesAllGroupViewCtr.m
//  Montessori_Geography
//
//  Created by MAC236 on 18/03/14.
//  Copyright (c) 2014 MAC 227. All rights reserved.
//

#import "StagesAllGroupViewCtr.h"
#import "AppConstant.h"

@interface StagesAllGroupViewCtr ()

@end

@implementation StagesAllGroupViewCtr
@synthesize _currentGameMode,_currentStage;
@synthesize _StageAllGroupDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //get Current Stage Data
    _imgView_Stage_Map.image = [UIImage imageNamed:[NSString stringWithFormat:@"stage%d_allGroups_map",_currentStage+1]];

    NSArray *_CurrentStageArray = [GlobalMethods ReturnCurrentStageArray:_currentStage ForKey:@"Stage"];
    
    // Next, setup the game pieces and placeholders for each country.
    
    _gamePieceArray = [[NSMutableArray alloc] init]; // This array will hold a pointer to all game piece objects used during this stage.
    _gamePiecesCompletedInCurrentStep = [[NSMutableArray alloc] init]; // Used to track which game pieces have been successfully completed during each step.
    
    for (int i = 0; i < [_CurrentStageArray count]; i++) {
        NSDictionary *dicAllGroup = [_CurrentStageArray objectAtIndex:i];
        NSArray *countries = [dicAllGroup objectForKey:@"countries"];
        
        for (NSDictionary *countryDictionary in countries) {
            UIImage *activeImage = [UIImage imageNamed:[countryDictionary objectForKey:@"active_image_filename"]];
            UIImage *inactiveImage = [UIImage imageNamed:[countryDictionary objectForKey:@"inactive_image_filename"]];
            UIImage *placeholderImage = [UIImage imageNamed:[countryDictionary objectForKey:@"placeholder_image_filename"]];
            
            //For Flag
            UIImage *activeImage_flag = [UIImage imageNamed:[countryDictionary objectForKey:@"active_image_filename_flag"]];
            UIImage *placeholderImage_flag = [UIImage imageNamed:[countryDictionary objectForKey:@"placeholder_image_filename_flag"]];
            UIImage *inactiveImage_flag = [UIImage imageNamed:[countryDictionary objectForKey:@"inactive_image_filename_flag"]];
            //
            
            // Create the game piece object.
            MGAGamePiece *gamePiece = [[MGAGamePiece alloc] initWithImage:inactiveImage];
            gamePiece.delegate = self;
            
            UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:placeholderImage];
            gamePiece.placeholder = placeholderImageView;
            
            gamePiece.image_active = activeImage;
            gamePiece.image_inactive = inactiveImage;
            gamePiece.image_placeholder = placeholderImage;
            
            //For Flag
            gamePiece.image_active_flag = activeImage_flag;
            gamePiece.image_inactive_flag = inactiveImage_flag;
            gamePiece.image_placeholder_flag = placeholderImage_flag;
            //
            
            gamePiece.name = [countryDictionary objectForKey:@"name"];
            gamePiece.scaleStep0 = [[countryDictionary objectForKey:@"scaleStep0"] floatValue];
            gamePiece.maxDistanceFromCenterStep2 = [[countryDictionary objectForKey:@"maxDistanceFromCenterStep2"] floatValue];
            
            // Setup the game piece label. We will position it on the screen later.
            UILabel *gamePieceLabel = [[UILabel alloc] init];
            [gamePieceLabel setTextAlignment:NSTextAlignmentCenter];
            [gamePieceLabel setTextColor:[UIColor blackColor]];
            [gamePieceLabel setFont:[UIFont systemFontOfSize:24.0f]];
            [gamePieceLabel setText:gamePiece.name];
            [gamePieceLabel sizeToFit];
            gamePiece.lbl_name = gamePieceLabel;
            
            // Get the various frames for this game piece
            NSDictionary *frames = [countryDictionary objectForKey:@"frames_allGroups"];
            
            //For Flag
            NSDictionary *frames_flag = [countryDictionary objectForKey:@"frames_allGroups_flag"];
            //
            
            NSDictionary *frameStep1 = [frames objectForKey:@"frameStep1"];
            gamePiece.frameStep1 = CGRectMake([[frameStep1 objectForKey:@"x"] floatValue],
                                              [[frameStep1 objectForKey:@"y"] floatValue],
                                              [[frameStep1 objectForKey:@"width"] floatValue],
                                              [[frameStep1 objectForKey:@"height"] floatValue]);
            
            //For Flag
            NSDictionary *frameStep1_flag = [frames_flag objectForKey:@"frameStep1"];
            gamePiece.frameStep1_flag = CGRectMake([[frameStep1_flag objectForKey:@"x"] floatValue],
                                                   [[frameStep1_flag objectForKey:@"y"] floatValue],
                                                   [[frameStep1_flag objectForKey:@"width"] floatValue],
                                                   [[frameStep1_flag objectForKey:@"height"] floatValue]);
            //
            
            
            NSDictionary *frameStep2Placeholder = [frames objectForKey:@"frameStep2Placeholder"];
            gamePiece.frameStep2Placeholder = CGRectMake([[frameStep2Placeholder objectForKey:@"x"] floatValue],
                                                         [[frameStep2Placeholder objectForKey:@"y"] floatValue],
                                                         [[frameStep2Placeholder objectForKey:@"width"] floatValue],
                                                         [[frameStep2Placeholder objectForKey:@"height"] floatValue]);
            
            //For Flag
            NSDictionary *frameStep2Placeholder_flag = [frames_flag objectForKey:@"frameStep2Placeholder"];
            gamePiece.frameStep2Placeholder_flag = CGRectMake([[frameStep2Placeholder_flag objectForKey:@"x"] floatValue],
                                                              [[frameStep2Placeholder_flag objectForKey:@"y"] floatValue],
                                                              [[frameStep2Placeholder_flag objectForKey:@"width"] floatValue],
                                                              [[frameStep2Placeholder_flag objectForKey:@"height"] floatValue]);
            //
            
            NSDictionary *frameStep2GamePiece = [frames objectForKey:@"frameStep2GamePiece"];
            gamePiece.frameStep2GamePiece = CGRectMake([[frameStep2GamePiece objectForKey:@"x"] floatValue],
                                                       [[frameStep2GamePiece objectForKey:@"y"] floatValue],
                                                       [[frameStep2GamePiece objectForKey:@"width"] floatValue],
                                                       [[frameStep2GamePiece objectForKey:@"height"] floatValue]);
            
            //For Flag
            NSDictionary *frameStep2GamePiece_flag = [frames_flag objectForKey:@"frameStep2GamePiece"];
            gamePiece.frameStep2GamePiece_flag = CGRectMake([[frameStep2GamePiece_flag objectForKey:@"x"] floatValue],
                                                            [[frameStep2GamePiece_flag objectForKey:@"y"] floatValue],
                                                            [[frameStep2GamePiece_flag objectForKey:@"width"] floatValue],
                                                            [[frameStep2GamePiece_flag objectForKey:@"height"] floatValue]);
            //
            
            [_gamePieceArray addObject:gamePiece];
        }

    }
    [self setupStep0];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _lbl_Instruction.font = Questrial_Regular(_lbl_Instruction.font.pointSize);
    _lblStageTitle.font = Questrial_Regular(_lblStageTitle.font.pointSize);
    
    //Set Stage Title
    _lblStageTitle.text = [GlobalMethods ReturnStageTitle:_currentStage];
    
    //Fade Out Stage Title Before Step 0 Starts
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _lblStageTitle.alpha = 0.0;
    } completion:^(BOOL finished){
    }];
    
    // Fade out the current view to prepare for step 1.
    [UIView animateWithDuration:1.0
                          delay:2.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _imgView_Stage_Map.alpha = 0.0f;
                         
                         for (MGAGamePiece *gamePiece in _gamePieceArray) {
                             gamePiece.alpha = 0.0f;
                         }
                     }
                     completion:^(BOOL finished){
                         [self startStep1];
                     }];
}

#pragma mark - Instruction Label Instance Methods
- (void)showInstructionWithText1:(NSString *)text1 withText2:(NSString *)text2 completion:(void (^)(void))completion {
    // Animate the view into the screen coming up from the bottom.
    [_lbl_Instruction setText:text1];
    
    float labelHeight = _lbl_Instruction.frame.size.height;
    CGRect labelFrame = CGRectMake(0.0, self.view.bounds.size.height - labelHeight, self.view.bounds.size.width, labelHeight);
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _lbl_Instruction.frame = labelFrame;
                     }
                     completion:^(BOOL finished){
                         if (text2) {
                             // Animate the transition of the label text changing from text1 to text2.
                             CATransition *animation = [CATransition animation];
                             animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                             animation.type = kCATransitionFade;
                             animation.duration = 1.5;
                             [_lbl_Instruction.layer addAnimation:animation forKey:@"kCATransitionFade"];
                             [_lbl_Instruction setText:text2];
                         }
                         
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)hideInstructionWithTextWithCompletion:(void (^)(void))completion {
    // Animate the view off the screen going down to the bottom.
    float labelHeight = _lbl_Instruction.frame.size.height;
    CGRect newFrame = CGRectMake(0.0, self.view.bounds.size.height, self.view.bounds.size.width, labelHeight);
    [UIView animateWithDuration:0.7
                          delay:5.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _lbl_Instruction.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         if (completion) {
                             completion();
                         }
                     }];
}


#pragma mark - Step 0 (Intro) Instance Methods
- (void)setupStep0 {
    _currentStep = kSTEP0;
    _currentGamePieceIndex = 0;
    
    //Setup mapframe for step 0
    _imgView_Stage_Map.frame = [GlobalMethods ReturnFrameForAllGroup:_currentStage+1];
    
    
    // Apply the frame for step 1 for each game piece
    for (MGAGamePiece *gamePiece in _gamePieceArray) {
        
        gamePiece.placeholder.frame = gamePiece.frameStep2Placeholder;
        if (_currentGameMode == kModeCountry)
        {
            gamePiece.image = gamePiece.image_inactive;
            gamePiece.frame = gamePiece.frameStep2Placeholder;
            gamePiece.placeholder.alpha = 0.0;
        }
        else
        {
            gamePiece.image = gamePiece.image_active_flag;
            gamePiece.frame = CGRectMake(gamePiece.placeholder.center.x, -(self.view.bounds.size.height/2), gamePiece.frameStep1_flag.size.width, gamePiece.frameStep1_flag.size.height);
            gamePiece.placeholder.alpha = 1.0;
            gamePiece.placeholder.image = gamePiece.image_active;
        }
        
        [self.view addSubview:gamePiece];
        [self.view addSubview:gamePiece.placeholder];
    }
    
}
#pragma mark - Step 1 (Taping - No Map) Instance Methods
- (void)startStep1 {
    
    _imgView_Stage_Map.alpha = 0.0f;
    
    _currentStep = kSTEP1;
    _currentGamePieceIndex = 0;
    
    _nooftimesCompletedStep1 = 0;
    
    Step_Timer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self selector:@selector(ChangeInActiveForHint:) userInfo: nil repeats:NO];
    
    // First empty the array that tracks which game pieces have been completed for this step.
    [_gamePiecesCompletedInCurrentStep removeAllObjects];
    
    // Move the game pieces to the top off the screen, off the screen
    // so they can drop into place to begin the next step.
    
    int gamePieceCount = (int)[_gamePieceArray count];
    
    int maxWidth = 0;
    int maxHeight = 0;
    
    // TODO: Layout currently only supports 1 row of pieces. Need a more scalable solution for when 3+ pieces are shown.
    for (int i = 0; i < gamePieceCount; i++) {
        MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:i];
        if (_currentGameMode == kModeCountry)
        {
            gamePiece.image = gamePiece.image_active;
            gamePiece.frame = gamePiece.frameStep1;
            if (maxWidth < gamePiece.frame.size.width) {
                maxWidth = gamePiece.frame.size.width;
            }
            if (maxHeight < gamePiece.frame.size.height) {
                maxHeight = gamePiece.frame.size.height;
            }
        }
        else
        {
            gamePiece.image = gamePiece.image_active_flag;
            gamePiece.frame = gamePiece.frameStep1_flag;
            gamePiece.placeholder.alpha = 0.0f;
            if (maxWidth < gamePiece.frameStep1.size.width) {
                maxWidth = gamePiece.frameStep1.size.width;
            }
            if (maxHeight < gamePiece.frameStep1.size.height) {
                maxHeight = gamePiece.frameStep1.size.height;
            }
        }
        
        gamePiece.alpha = 1.0f;
        [gamePiece setUserInteractionEnabled:NO];
    }
    
    //Calculate Row : Column
    int row = (self.view.bounds.size.height-_lbl_Instruction.frame.size.height)/maxHeight;
    int column = gamePieceCount / row;
    if (gamePieceCount % row != 0) {
        column = column + 1;
    }
    
    int xAxis = 0;
    int yAxis = 0;
    int tempWidth = self.view.bounds.size.width/column;
    int tempHeight = (self.view.bounds.size.height-_lbl_Instruction.frame.size.height)/row;
    
    //Set the center of all game pieace
    for (int i = 0; i < gamePieceCount; i++) {
        
        CGRect Tempframe = CGRectMake(xAxis*tempWidth, yAxis*tempHeight, tempWidth, tempHeight);
        MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:i];
        gamePiece.center = CGPointMake(CGRectGetMidX(Tempframe), -CGRectGetMidY(Tempframe));
        
        if ((xAxis+1) % column == 0) {
            xAxis = 0;
            yAxis++;
        }
        else{
            xAxis++;
        }
    }
    
    // Get all the centers of the game pieces.
    NSMutableArray *tempGamePieceCentersArray = [[NSMutableArray alloc] initWithCapacity:gamePieceCount];
    for (MGAGamePiece *gamePiece in _gamePieceArray) {
        [tempGamePieceCentersArray addObject:[NSValue valueWithCGPoint:gamePiece.center]];
    }
    
    // Next, shuffle the centers array randomly.
    [tempGamePieceCentersArray shuffle];
    
    // Now apply the shuffled centers to each game piece.
    for (int i = 0; i < gamePieceCount; i++) {
        MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:i];
        
        CGPoint newCenter = [[tempGamePieceCentersArray objectAtIndex:i] CGPointValue];
        
        gamePiece.center = newCenter;
    }
    
    // Now we let the game pieces drop down into the screen form the top.
    for (int i = 0; i < gamePieceCount; i++) {
        MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:i];
        
        CGPoint center = CGPointMake(gamePiece.center.x, gamePiece.center.y*-1);
        [gamePiece makeGamePieceTappableWithCenter:center];
        
        [gamePiece performSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:YES] afterDelay:2.0];
    }
    
    // Start with the first game piece in this stage.
    _currentGamePieceIndex = 0;
    MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:_currentGamePieceIndex];
    void (^completion)(void) = ^(void) {
        [_lbl_Instruction setText:gamePiece.name];
    };
    [self showInstructionWithText1:[NSString stringWithFormat:@"Show me %@", gamePiece.name] withText2:[NSString stringWithFormat:@"%@", gamePiece.name] completion:completion];
}

#pragma mark - No Action Found
-(void)ChangeInActiveForHint:(NSTimer *)timer
{
    //Select GamePiece For Hint
    MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:_currentGamePieceIndex];
    // Setup game pieces for dragging step and move them to their starting location on the screen.
    
    // Animate the transition of the GamePiece Blue To dark Blue.
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 10.0;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    [animation setValue:@"StepNoAction" forKey:@"kCATransitionFadeNoActionStep"];
    [gamePiece.layer addAnimation:animation forKey:@"kCATransitionFadeNoActionStep"];
    
    if (_currentGameMode == kModeCountry)
        gamePiece.image = gamePiece.image_inactive;
    else
        gamePiece.image = gamePiece.image_inactive_flag;
}
- (void)shuffleStep1 {
    int gamePieceCount = (int)[_gamePieceArray count];
    
    // Get all the centers of the game pieces.
    NSMutableArray *tempGamePieceCentersArray = [[NSMutableArray alloc] initWithCapacity:gamePieceCount];
    for (MGAGamePiece *gamePiece in _gamePieceArray) {
        [tempGamePieceCentersArray addObject:[NSValue valueWithCGPoint:gamePiece.center]];
    }
    
    // Next, shuffle the centers array randomly.
    [tempGamePieceCentersArray shuffle];
    
    // Now apply the shuffled centers to each game piece.
    for (int i = 0; i < gamePieceCount; i++) {
        MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:i];
        
        CGPoint newCenter = [[tempGamePieceCentersArray objectAtIndex:i] CGPointValue];
        
        [gamePiece makeGamePieceTappableWithCenter:newCenter];
    }
    
    //Repeat Step 1 once again
    if (_currentStep == kSTEP1)
    {
        //empty the array that tracks which game pieces have been completed for this step.
        [_gamePiecesCompletedInCurrentStep removeAllObjects];
        
        //Timer Set If User will not touch any objects
        Step_Timer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self selector:@selector(ChangeInActiveForHint:) userInfo: nil repeats:NO];
        
        // Start with the first game piece in this stage.
        _currentGamePieceIndex = 0;
        MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:_currentGamePieceIndex];
        void (^completion)(void) = ^(void) {
            [_lbl_Instruction setText:gamePiece.name];
        };
        [self showInstructionWithText1:[NSString stringWithFormat:@"Show me %@", gamePiece.name] withText2:[NSString stringWithFormat:@"%@", gamePiece.name] completion:completion];
    }
}

#pragma mark - Step 2 (Dragging - On Map) Instance Methods
- (void)startStep2 {
    
    [self.view setUserInteractionEnabled:YES];
    _currentStep = kSTEP2;
    _currentGamePieceIndex = 0;
    
    //Setup mapframe for step 2
    _imgView_Stage_Map.alpha = 1.0f;
    
    // First empty the array that tracks which game pieces have been completed for this step.
    [_gamePiecesCompletedInCurrentStep removeAllObjects];
    
    // Setup game pieces for dragging step and move them to their starting location on the screen.
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _imgView_Stage_Map.alpha = 1.0f;
                         
                         for (MGAGamePiece *gamePiece in _gamePieceArray) {
                             gamePiece.alpha = 1.0f;
                             gamePiece.placeholder.alpha = 1.0f;
                             
                             if (_currentGameMode == kModeCountry)
                             {
                                 gamePiece.image = gamePiece.image_active;
                                 gamePiece.frame = gamePiece.frameStep2GamePiece;
                             }
                             else
                             {
                                 gamePiece.image = gamePiece.image_active_flag;
                                 gamePiece.frame = gamePiece.frameStep2GamePiece_flag;
                                 gamePiece.placeholder.image = gamePiece.image_placeholder;
                             }
                             
                             gamePiece.alpha = 0.0f;
                             
                             gamePiece.placeholder.frame = gamePiece.frameStep2Placeholder;
                             [self.view bringSubviewToFront:gamePiece];
                             
                         }
                     }
                     completion:^(BOOL finished){
                         [self setupGamePiecesForDragging];
                         
                         // Show the game piece labels under each game piece.
                         // Position the gamepiece label and show it.
                         for (MGAGamePiece *gamePiece in _gamePieceArray) {
                             CGPoint labeCenter = CGPointMake(gamePiece.center.x, gamePiece.center.y + gamePiece.frame.size.height/2 + 15.0);
                             gamePiece.lbl_name.center = labeCenter;
                             gamePiece.lbl_name.alpha = 0.0;
                             
                             [self.view addSubview:gamePiece.lbl_name];
                         }
                         
                         [UIView animateWithDuration:0.35
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              
                                              MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:0];
                                              gamePiece.lbl_name.alpha = 1.0;
                                              gamePiece.alpha = 1.0f;
                                          }
                                          completion:^(BOOL finished){
                                              void (^completion)(void) = ^(void) {
                                                  [self hideInstructionWithTextWithCompletion:nil];
                                              };
                                              
                                              NSString *strText1 = @"Show me where these go";
                                              if (_currentGameMode == kModeFlag)
                                                  strText1 = @"Match the flag with its country";
                                              
                                              [self showInstructionWithText1:strText1 withText2:nil completion:completion];
                                          }];
                     }];
}


- (void)setupGamePiecesForDragging {
    for (MGAGamePiece *gamePiece in _gamePieceArray) {
        [gamePiece makeGamePieceDraggable];
    }
}

#pragma mark - MGAGamePieceDelegate Game Piece Methods
- (void)gamePieceDidTouchTransparentPixel:(MGAGamePiece *)gamePiece touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // We need to test to see if the touch if within another game pieces frame below this one.
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    for (MGAGamePiece *otherGamePiece in _gamePieceArray) {
        if (otherGamePiece != gamePiece &&
            CGRectContainsPoint(otherGamePiece.frame, touchLocation))
        {
            // [otherGamePiece touchesBegan:touches withEvent:event];
            CGPoint touchLocationTemp = [touch locationInView:otherGamePiece];
            
            if (![self isTouchOnTransparentPixel:touchLocationTemp GamePieace:otherGamePiece]) {
                
                [self tappableGamePieceTouchBegan:otherGamePiece didTouchAtPoint:touchLocation];
            }
        }
    }
}

- (void)gamePieceDidTouchTransparentPixel:(MGAGamePiece *)gamePiece touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // We need to test to see if the touch if within another game pieces frame below this one.
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    for (MGAGamePiece *otherGamePiece in _gamePieceArray) {
        if (otherGamePiece != gamePiece &&
            CGRectContainsPoint(otherGamePiece.frame, touchLocation))
        {
            // [otherGamePiece touchesMoved:touches withEvent:event];
        }
    }
}

- (void)gamePieceDidTouchTransparentPixel:(MGAGamePiece *)gamePiece touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // We need to test to see if the touch if within another game pieces frame below this one.
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    for (MGAGamePiece *otherGamePiece in _gamePieceArray) {
        if (otherGamePiece != gamePiece &&
            CGRectContainsPoint(otherGamePiece.frame, touchLocation))
        {
            // [otherGamePiece touchesMoved:touches withEvent:event];
            CGPoint touchLocationTemp = [touch locationInView:otherGamePiece];
            
            if (![self isTouchOnTransparentPixel:touchLocationTemp GamePieace:otherGamePiece]) {
                
                [self tappableGamePiece:otherGamePiece didReleaseAtPoint:touchLocation];
            }
            
        }
    }
}

#pragma mark - MGAGamePieceDelegate Draggable Game Piece Methods
- (void)draggableGamePieceTouchBegan:(MGAGamePiece *)gamePiece didTouchAtPoint:(CGPoint)point {
    [self.view bringSubviewToFront:gamePiece];
}

- (void)draggableGamePiece:(MGAGamePiece *)gamePiece didDragToPoint:(CGPoint)point {
    
}

- (void)draggableGamePiece:(MGAGamePiece *)gamePiece didReleaseAtPoint:(CGPoint)point {
    CGPoint p1 = gamePiece.placeholder.center;
    CGPoint p2 = gamePiece.center;
    
    CGFloat targetDistance = gamePiece.maxDistanceFromCenterStep2;
    
    CGFloat distanceCenters = hypotf(p1.x - p2.x, p1.y - p2.y);
    
    if (distanceCenters <= targetDistance) {
        [gamePiece placeGamePieceOnMapTarget:YES GameMode:_currentGameMode];
        
        // Disable further interation with the game piece
        [gamePiece setUserInteractionEnabled:NO];
    }
    else {
        [gamePiece returnGamePieceToOriginalLocation];
    }
}
- (void)gamePiecePlacedOnTarget:(MGAGamePiece *)gamePiece {
    if (_currentStep == kSTEP2) {
        [_gamePiecesCompletedInCurrentStep addObject:gamePiece];
        
        // Check to see if all game pieces have been correctly placed on the map.
        if ([_gamePiecesCompletedInCurrentStep count] == [_gamePieceArray count]) {
            
            //Time Invalidate - Stage Complete
            [Step_Timer invalidate];
            
            [self.view setUserInteractionEnabled:NO];
            // Stage complete.
            void (^completion)(void) = ^(void) {
                void (^completion)(void) = ^(void) {
                    
                    void (^completion)(void) = ^(void) {
                        [self PlaneAnimationPathAfterActivityCompletion];
                        [self performSelector:@selector(PopViewToNextStageorGroup) withObject:nil afterDelay:StepCompleteAnimationTime];
                    };
                    [self showInstructionWithText1:@"On to the next stage." withText2:nil completion:completion];
                };
                [self hideInstructionWithTextWithCompletion:completion];
            };
            [self showInstructionWithText1:@"Stage completed! Well done!" withText2:nil completion:completion];
        }else{
            MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:[_gamePiecesCompletedInCurrentStep count]];
            gamePiece.lbl_name.alpha = 1.0;
            gamePiece.alpha = 1.0f;
        }
    }
}

- (void)gamePieceReturnedToOriginalLocation:(MGAGamePiece *)gamePiece {
    
}

#pragma mark - MGAGamePieceDelegate Tappable Game Piece Methods
- (void)tappableGamePieceTouchBegan:(MGAGamePiece *)gamePiece didTouchAtPoint:(CGPoint)point {
    [self.view bringSubviewToFront:gamePiece];
    
    //Time Invalidate - If user touch the any gamePiece cancel timer of 10 seconds and set gamePiece to active
    [Step_Timer invalidate];
    
    //Remove All animation Of the Game Pieces
    for (int i = 0; i < [_gamePieceArray count]; i++)
    {
        MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:i];
        if ([_gamePieceArray objectAtIndex:_currentGamePieceIndex] == gamePiece)
        {
            //Set gamePiece inactive to active
            if (_currentGameMode == kModeCountry)
                gamePiece.image = gamePiece.image_active;
            else
                gamePiece.image = gamePiece.image_active_flag;
        }
        [gamePiece.layer removeAllAnimations];
    }
    
}

- (void)tappableGamePiece:(MGAGamePiece *)gamePiece didDragToPoint:(CGPoint)point {
    
}

- (void)tappableGamePiece:(MGAGamePiece *)gamePiece didReleaseAtPoint:(CGPoint)point {
    if ([_gamePieceArray objectAtIndex:_currentGamePieceIndex] == gamePiece) {
        [gamePiece bounceGamePiece:_currentGameMode];
        
        [self hideInstructionWithTextWithCompletion:nil];
    }
    else {
        [gamePiece shakeGamePiece:_currentGameMode];
    }
}

- (void)gamePieceBounceDidComplete:(MGAGamePiece *)gamePiece {
    [_gamePiecesCompletedInCurrentStep addObject:gamePiece];
    
    // Check to see if all game pieces have been correctly identified.
    if ([_gamePiecesCompletedInCurrentStep count] == [_gamePieceArray count]) {
        if (_currentStep == kSTEP1) {
            
            _nooftimesCompletedStep1++;
            //Time Invalidate - Stage Complete
            [Step_Timer invalidate];
            
            //Repeat Step 1 upto 3 times
            if (_nooftimesCompletedStep1 == 3)
            {
                [self.view setUserInteractionEnabled:NO];
                [self PlaneAnimationPathAfterActivityCompletion];
                [self performSelector:@selector(startStep2) withObject:nil afterDelay:StepCompleteAnimationTime];
            }
            else
            {
                //Suffle game pieces for nth time and repeat steps
                [self shuffleStep1];
            }
            
        }
    }
    else {
        
        if (_currentStep == kSTEP1)
        {
            //Set Timer of 10 Seconds for New GamePiece
            [Step_Timer invalidate];
            Step_Timer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self selector:@selector(ChangeInActiveForHint:) userInfo: nil repeats:NO];
        }
        
        // Get the next game piece for the user to identify.
        _currentGamePieceIndex++;
        MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:_currentGamePieceIndex];
        void (^completion)(void) = ^(void) {
            [_lbl_Instruction setText:gamePiece.name];
        };
        [self showInstructionWithText1:[NSString stringWithFormat:@"Show me %@", gamePiece.name] withText2:[NSString stringWithFormat:@"%@", gamePiece.name] completion:completion];
    }
}

- (void)gamePieceShakeDidComplete:(MGAGamePiece *)gamePiece {
    
    if (_currentStep == kSTEP1 || _currentStep == kSTEP3)
    {
        //Set Timer of 10 Seconds After Touches
        [Step_Timer invalidate];
        Step_Timer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self selector:@selector(ChangeInActiveForHint:) userInfo: nil repeats:NO];
    }
}
-(void)PopViewToNextStageorGroup
{
    [self.navigationController popViewControllerAnimated:NO];
    [_StageAllGroupDelegate StageCompleteForAllGroup];
}

#pragma mark - CAAnimation Delegate
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (_currentStep == kSTEP1) {
        
        if (flag)
        {
            NSString* value = [theAnimation valueForKey:@"kCATransitionFadeNoActionStep"];
            if ([value isEqualToString:@"StepNoAction"])
            {
                MGAGamePiece *gamePiece = [_gamePieceArray objectAtIndex:_currentGamePieceIndex];
                [gamePiece bounceGamePiece:_currentGameMode];
                [self hideInstructionWithTextWithCompletion:nil];
            }
        }
    }
}

#pragma mark - Create Path for Plane Animation
-(void)PlaneAnimationPathAfterActivityCompletion
{
    int i = arc4random()%4;
    
    //random values
    float xStart = [self getRandomNumberBetween:0 to:self.view.frame.size.width];
    float xEnd = [self getRandomNumberBetween:0 to:self.view.frame.size.width];
    //ControlPoint1
    float cp1X = [self getRandomNumberBetween:200 to:self.view.frame.size.width-200];
    float cp1Y = [self getRandomNumberBetween:200 to:self.view.frame.size.width-200];
    //ControlPoint2
    float cp2X = [self getRandomNumberBetween:200 to:self.view.frame.size.width-200];
    float cp2Y = [self getRandomNumberBetween:200 to:cp1Y];
    
    CGPoint s = P(0, 0);
    CGPoint e = P(0, 0);
    if (i == 0)
    {
        //Down To Up
        s = P(xStart, 1124.0);
        e = P(xEnd, -100);
    }
    else if (i == 1)
    {
        //Up To Down
        e = P(xStart, 1124.0);
        s = P(xEnd, -100);
    }
    else if (i == 2)
    {
        //Right To Left
        s = P(1124.0, xStart);
        e = P(-100, xEnd);
    }
    else if (i == 3)
    {
        //Left To Right
        e = P(1124.0, xStart);
        s = P(-100, xEnd);
    }
    
    CGPoint cp1 = P(cp1X, cp1Y);
    CGPoint cp2 = P(cp2X, cp2Y);
    
    UIBezierPath *trackpath = [UIBezierPath bezierPath];
    
    [trackpath moveToPoint:s];
    [trackpath addCurveToPoint:e controlPoint1:cp1 controlPoint2:cp2];
    
    [self movePlane:trackpath PlaneLastPoint:e AnimationTime:StepCompleteAnimationTime];
}
-(void)movePlane:(UIBezierPath*)trackPath PlaneLastPoint:(CGPoint)point AnimationTime:(CGFloat)animationTime
{
    /*CAShapeLayer *centerline = [CAShapeLayer layer];
     centerline.path = trackPath.CGPath;
     centerline.strokeColor = [UIColor purpleColor].CGColor;
     centerline.fillColor = [UIColor clearColor].CGColor;
     centerline.lineWidth = 2.0;
     centerline.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:2], nil];
     [self.view.layer addSublayer:centerline];*/
	
    if (!plane)
    {
        plane = [CALayer layer];
        plane.bounds = CGRectMake(0, 0, 46.0, 88.0);
        plane.contents = (id)([UIImage imageNamed:@"plane.png"].CGImage);
        [self.view.layer addSublayer:plane];
    }
    else
    {
        [self bringSublayerToFront:plane];
    }
    plane.position = point;
    
	CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	anim.path = trackPath.CGPath;
	anim.rotationMode = kCAAnimationRotateAutoReverse;
	anim.repeatCount = 1;
	anim.duration = animationTime;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
	[plane addAnimation:anim forKey:@"race"];
    
}
- (void)bringSublayerToFront:(CALayer *)layer {
    CALayer *superlayer = layer.superlayer;
    [layer removeFromSuperlayer];
    [superlayer insertSublayer:layer atIndex:[layer.sublayers count]-1];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isTouchOnTransparentPixel:(CGPoint)point GamePieace:(MGAGamePiece*)gp{
    
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [gp.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    CGFloat alpha = pixel[3]/255.0;
    BOOL transparent = alpha < 0.01;
    
    return transparent;
}


@end
