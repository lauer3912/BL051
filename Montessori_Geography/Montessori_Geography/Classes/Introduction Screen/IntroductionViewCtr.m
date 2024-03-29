//
//  IntroductionViewCtr.m
//  Montessori_Geography
//
//  Created by Chirag on 30/12/13.
//  Copyright (c) 2013 MAC 227. All rights reserved.
//

#import "IntroductionViewCtr.h"
#import "AppConstant.h"

@interface IntroductionViewCtr ()

@end

@implementation IntroductionViewCtr
@synthesize plane_flying,plane_landing,plane_takeoff;

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
    //Set Localized String of the view
    
    [GlobalMethods replaceTextWithLocalizedTextInSubviewsForView:self.view];
    
    lblBlue.layer.cornerRadius = 8.0;
    lblBorderMenu.layer.cornerRadius = 8.0;
    
    // drop shadow
    [AsiaView.layer setCornerRadius:8.0f];
    [AsiaView.layer setShadowColor:[UIColor blackColor].CGColor];
    [AsiaView.layer setShadowOpacity:0.2];
    [AsiaView.layer setShadowRadius:8.0];
    [AsiaView.layer setShadowOffset:CGSizeMake(-5, 5)];
    AsiaView.layer.masksToBounds = NO;
    
    //Retrive Current Stage & Group & Game Mode
    
    _CurrentMode = [GlobalMethods ReturnCurrentSatgeGroupForKey:CurrentGameMode];
    
    //Set UI Of Game Mode Country/Flag
    [self SetGameModeUI:_CurrentMode MovePlane:NO];
    
    //Apply Custom Font
    [self SetCustomFont];
    
    //Zoom Map To Asia
    self.view.userInteractionEnabled = NO;
    
    [self setPlaneSoundsPlayer];
    // if (_CurrentStage == 0 && _CurrentGroup == 0)
    //{
    [self performSelector:@selector(ZoomAsiaMap) withObject:nil afterDelay:1.0];
    //}
    //else
    //{
    //Set Asia Witout Zoom If app not in first time
    //}
    
    
    //inAppPurchase Notification Fire Declaration Start
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductNotPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchaseFailed:) name:IAPHelperProductNotPurchasedNotification object:nil];
    // End
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)SetCustomFont
{
    lblWelcome.font = KGPrimaryPenmanship2(lblWelcome.font.pointSize + (2*kSizeDiff));
    lblMonte.font = KGPrimaryPenmanship2(lblMonte.font.pointSize + (4*kSizeDiff));
    lblAsia.font = KGPrimaryPenmanship2(lblAsia.font.pointSize + kSizeDiff);
    lblStageTitle.font = KGPrimaryPenmanship2(lblStageTitle.font.pointSize + kSizeDiff);
    
    //Home Screen
    btnMapsPurchase.titleLabel.font = KGPrimaryPenmanship2(btnReset.titleLabel.font.pointSize + kSizeDiff);
    btnFlagsPurchase.titleLabel.font = KGPrimaryPenmanship2(btnReset.titleLabel.font.pointSize + kSizeDiff);
    btnMapsFlagsPurchase.titleLabel.font = KGPrimaryPenmanship2(btnReset.titleLabel.font.pointSize + kSizeDiff);
    btnReset.titleLabel.font = KGPrimaryPenmanship2(btnReset.titleLabel.font.pointSize + kSizeDiff);
    btnRestorePurchases.titleLabel.font = KGPrimaryPenmanship2(btnRestorePurchases.titleLabel.font.pointSize + kSizeDiff);
    
    lblMapsPurchase.font = KGPrimaryPenmanship2(lblMapsPurchase.font.pointSize + kSizeDiff);
    lblFlagsPurchase.font = KGPrimaryPenmanship2(lblFlagsPurchase.font.pointSize + kSizeDiff);
    lblMapsFlagsPurchase.font = KGPrimaryPenmanship2(lblMapsFlagsPurchase.font.pointSize + kSizeDiff);
    lblReset.font = KGPrimaryPenmanship2(lblReset.font.pointSize + kSizeDiff);
    
    lblMonte_Purchase.font = KGPrimaryPenmanship2(lblMonte_Purchase.font.pointSize + (3*kSizeDiff));
    lblAsia_Purchase.font = KGPrimaryPenmanship2(lblAsia_Purchase.font.pointSize + (3*kSizeDiff));
    
    //Set Border To Purchase Buttos
    btnMapsPurchase.layer.cornerRadius = 3;
    btnFlagsPurchase.layer.cornerRadius = 3;
    btnMapsFlagsPurchase.layer.cornerRadius = 3;
    btnReset.layer.cornerRadius = 3;
    
}

-(void)ZoomAsiaMap
{
    lblLine1.alpha = 0.0;
    lblWelcome.alpha = 0.0;
    
    // We need to extract the properties of the Plane Path from the plist file.
    NSString* plistsource = [[NSBundle mainBundle] pathForResource:@"MGAPlanePath" ofType:@"plist"];
    NSDictionary *temp = [NSDictionary dictionaryWithContentsOfFile:plistsource];
    // get the path Detail we are interested in.
    
    NSArray *ArryIntroPath = [temp valueForKey:@"introductionpath"];
    NSArray *ArryCurrentStageGroup = [[ArryIntroPath objectAtIndex:_CurrentStage] valueForKey:@"groups"];
    
    int group_ = _CurrentGroup;
    if (group_ == 111)
        group_ = [ArryCurrentStageGroup count] - 1;
    
    NSDictionary *DicPathCurretnGroup = [ArryCurrentStageGroup objectAtIndex:group_];
    [self CreatePlaneAnimationPath:DicPathCurretnGroup];
    [self PlayPlaneSoundwithDictionary:DicPathCurretnGroup];
    //Map Zoom
    [UIView animateWithDuration:4.50 animations:^{
        AsiaView.frame = CGRectMake(AsiaView.frame.origin.x, 90, AsiaView.frame.size.width, AsiaView.frame.size.height);
        WelComeView.transform = CGAffineTransformScale(WelComeView.transform, 0.80, 0.80);
        WelComeView.frame = CGRectMake(292, 100, 440, 70);
        img_Map.frame = CGRectMake(-1129, -265, 2138, 1361);
    } completion:^(BOOL finished) {
        
        [AsiaView addSubview:WelComeView];
        WelComeView.frame = CGRectMake(20, 10, 440, 70);
        ViewContry.hidden = NO;
        [self AddIntroImagesForStage];
        //Menu Down
        [UIView animateWithDuration:10.00 delay:1.00 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            View_Menu.frame = CGRectMake(View_Menu.frame.origin.x, 0, View_Menu.frame.size.width, View_Menu.frame.size.height);
            View_Purchase.frame = CGRectMake(View_Purchase.frame.origin.x, 0, View_Purchase.frame.size.width, View_Purchase.frame.size.height);
            
            img_Shadow.frame = CGRectMake(img_Shadow.frame.origin.x, 0, img_Shadow.frame.size.width, img_Shadow.frame.size.height);
            
            WelComeView.transform = CGAffineTransformScale(WelComeView.transform, 0.70, 0.70);
            AsiaView.transform = CGAffineTransformScale(AsiaView.transform, 0.60, 0.60);
            AsiaView.frame = CGRectMake(View_Menu.frame.origin.x, 0, View_Menu.frame.size.width, View_Menu.frame.size.height);
            AsiaView.alpha = 0.0;
            
        } completion:^(BOOL finished){
            
        }];
        
    }];
    
    //Logo Reveal
    [UIView animateWithDuration:1.90 delay:5.90 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        img_Logo.frame = CGRectMake(img_Logo.frame.origin.x, img_Logo.frame.origin.y, 365, img_Logo.frame.size.height);
        
    } completion:^(BOOL finished){
        
    }];
}
-(void)EnableViewInteraction
{
    self.view.userInteractionEnabled = YES;
    [self SetImagesToGroups:_CurrentStage Group:_CurrentGroup];
}

//Check and set image of group whether it is complete - active - placeholder
-(void)AddIntroImagesForStage
{
    NSString* plistsource = [[NSBundle mainBundle] pathForResource:@"IntroImages" ofType:@"plist"];
    NSDictionary *temp = [NSDictionary dictionaryWithContentsOfFile:plistsource];
    
    NSArray *_stageDataArray = [temp objectForKey:@"stages"];
    
    for (int i = 0; i < [_stageDataArray count]; i++) {
        NSArray *_groupDataArray = [[_stageDataArray objectAtIndex:i] valueForKey:@"group"];
        for (int j = 0; j < [_groupDataArray count]; j++) {
            
            NSDictionary *DicMapFrame = [[_groupDataArray objectAtIndex:j] valueForKey:@"map"];
            
            UIImageView *imgViewGroup = [[UIImageView alloc] init];
            imgViewGroup.frame = CGRectMake([[DicMapFrame objectForKey:@"x"] floatValue],
                                            [[DicMapFrame objectForKey:@"y"] floatValue],
                                            [[DicMapFrame objectForKey:@"width"] floatValue],
                                            [[DicMapFrame objectForKey:@"height"] floatValue]);
            imgViewGroup.image = [UIImage imageNamed:[NSString stringWithFormat:@"stage%d_group%d_placeholder",i+1,j+1]];
            imgViewGroup.contentMode = UIViewContentModeScaleToFill;
            imgViewGroup.userInteractionEnabled = YES;
            imgViewGroup.tag = [[NSString stringWithFormat:@"%d%d",i+1,j+1] intValue];
            [imgViewGroup setAccessibilityIdentifier:@"placeholder"];
            [ViewContry addSubview:imgViewGroup];
            
            NSDictionary *DicFlag_PinFrame = [[_groupDataArray objectAtIndex:j] valueForKey:@"flag_pin"];
            
            UIImage *imgOrange = [UIImage imageNamed:@"orange_pin"];
            UIButton *btnGroupFlag_Pin = [UIButton buttonWithType:UIButtonTypeCustom];
            btnGroupFlag_Pin.frame = CGRectMake([[DicFlag_PinFrame objectForKey:@"x"] floatValue],
                                                    [[DicFlag_PinFrame objectForKey:@"y"] floatValue],
                                                    imgOrange.size.width,
                                                    imgOrange.size.height);
            [btnGroupFlag_Pin setImage:imgOrange forState:UIControlStateNormal];
            btnGroupFlag_Pin.hidden = YES;
            btnGroupFlag_Pin.userInteractionEnabled = YES;
           // btnGroupFlag_Pin.showsTouchWhenHighlighted = YES;
            btnGroupFlag_Pin.tag = [[NSString stringWithFormat:@"%d%d",i+1,j+1] intValue];
            [btnGroupFlag_Pin setAccessibilityIdentifier:@"flag_pin_orange"];
            [btnGroupFlag_Pin addTarget:self action:@selector(btnFlagPressed:) forControlEvents:UIControlEventTouchUpInside];
            [ViewContry addSubview:btnGroupFlag_Pin];
            
        }
        
        if (i < [_stageDataArray count] - 1) {
            NSDictionary *DicGreen_flag_Pin_Frame = [[_stageDataArray objectAtIndex:i] valueForKey:@"green_flag_pin_frame"];
            
            UIImage *imgGreen = [UIImage imageNamed:@"green_pin"];
            UIButton *btnStageFlag_Pin = [UIButton buttonWithType:UIButtonTypeCustom];
            btnStageFlag_Pin.frame = CGRectMake([[DicGreen_flag_Pin_Frame objectForKey:@"x"] floatValue],
                                                [[DicGreen_flag_Pin_Frame objectForKey:@"y"] floatValue], imgGreen.size.width, imgGreen.size.height);
            [btnStageFlag_Pin setImage:imgGreen forState:UIControlStateNormal];
            btnStageFlag_Pin.hidden = YES;
            btnStageFlag_Pin.userInteractionEnabled = YES;
            //btnStageFlag_Pin.showsTouchWhenHighlighted = YES;
            btnStageFlag_Pin.tag = [[NSString stringWithFormat:@"%d",i+1] intValue];
            [btnStageFlag_Pin setAccessibilityIdentifier:@"flag_pin_green"];
            [btnStageFlag_Pin addTarget:self action:@selector(btnFlagPressed:) forControlEvents:UIControlEventTouchUpInside];
            [ViewContry addSubview:btnStageFlag_Pin];
        }
    }
    
}
-(void)SetImagesToGroups:(int)CurrStage Group:(int)CurrGroup
{
    for (id subView in ViewContry.subviews) {
        NSString *strTag;
        if (_CurrentGroup == 111) {
            strTag = [NSString stringWithFormat:@"%d9",CurrStage+1];
        }
        else{
            strTag = [NSString stringWithFormat:@"%d%d",CurrStage+1,CurrGroup+1];
        }
        int TempStage = 0;
        int TempGroup = 0;
        
        if ([subView isKindOfClass:[UIImageView class]]) {
            
            UIImageView *imgViewComplete = (UIImageView*)subView;
            TempGroup = imgViewComplete.tag % 10;
            TempStage = imgViewComplete.tag / 10;
            
            if (imgViewComplete.tag < [strTag intValue]) {
                
                NSString *strTagStart = [NSString stringWithFormat:@"%d0",CurrStage+1];
                if (_CurrentGroup == 111 && imgViewComplete.tag > [strTagStart intValue]) {
                        imgViewComplete.image = [UIImage imageNamed:[NSString stringWithFormat:@"stage%d_group%d_active",TempStage,TempGroup]];
                        [imgViewComplete setAccessibilityIdentifier:@"active"];
                }
                else{
                        imgViewComplete.image = [UIImage imageNamed:[NSString stringWithFormat:@"stage%d_group%d_complete",TempStage,TempGroup]];
                        [imgViewComplete setAccessibilityIdentifier:@"complete"];
                }
            }
            else if (imgViewComplete.tag == [strTag intValue])
            {
                imgViewComplete.image = [UIImage imageNamed:[NSString stringWithFormat:@"stage%d_group%d_active",TempStage,TempGroup]];
                [imgViewComplete setAccessibilityIdentifier:@"active"];
            }
            else{
                imgViewComplete.image = [UIImage imageNamed:[NSString stringWithFormat:@"stage%d_group%d_placeholder",TempStage,TempGroup]];
                [imgViewComplete setAccessibilityIdentifier:@"placeholder"];
            }
        }
        else if ([subView isKindOfClass:[UIButton class]])
        {
            UIButton *btnComplete = (UIButton*)subView;
            //TempGroup = btnComplete.tag % 10;
            //TempStage = btnComplete.tag / 10;
            
            if (btnComplete.tag < [strTag intValue]) {
                
                NSString *strTagStart = [NSString stringWithFormat:@"%d0",CurrStage+1];
                if (_CurrentGroup == 111 && btnComplete.tag > [strTagStart intValue]) {
                    [self SetPin_Flag:btnComplete Identifier:@"flag_pin_orange_active"];
                }
                else{
                    [self SetPin_Flag:btnComplete Identifier:@"flag_pin_orange_complete"];
                }
            }
            else if (btnComplete.tag == [strTag intValue])
            {
                [self SetPin_Flag:btnComplete Identifier:@"flag_pin_orange_active"];
            }
            else{
                btnComplete.hidden = YES;
            }
        }
    }
    [self ShowGreenPin_Flag];
}
-(void)SetPin_Flag:(UIButton*)btnName Identifier:(NSString*)strIdentifier
{
    UIImage *img;
    if (_CurrentMode == kModeCountry) {
        img = [UIImage imageNamed:@"orange_pin"];
    }
    else if (_CurrentMode == kModeFlag){
        img = [UIImage imageNamed:@"orange_flag"];
    }
    [btnName setImage:img forState:UIControlStateNormal];
    btnName.frame = CGRectMake(btnName.frame.origin.x, btnName.frame.origin.y, img.size.width, img.size.height);
    btnName.hidden = NO;
    [btnName setAccessibilityIdentifier:strIdentifier];
    [ViewContry bringSubviewToFront:btnName];
}
-(void)ShowGreenPin_Flag
{
    NSArray *_totalStageArray = [GlobalMethods ReturnCurrentStageArray:_CurrentStage ForKey:@"AllStage"];
    for (int i = 0; i < _totalStageArray.count - 1; i++) {
        
        UIButton *btnGreen = (UIButton*)[ViewContry viewWithTag:i+1];
        if (i < _CurrentStage) {
            [self SetGreenPin_Flag:btnGreen Identifier:@"flag_pin_green_complete"];
        }
        else{
            btnGreen.hidden = YES;
        }
    }
    if (_CurrentGroup == 111) {
        UIButton *btnGreen = (UIButton*)[ViewContry viewWithTag:_CurrentStage+1];
        [self SetGreenPin_Flag:btnGreen Identifier:@"flag_pin_green_active"];
    }
}
-(void)SetGreenPin_Flag:(UIButton*)btnName Identifier:(NSString*)strIdentifier
{
    UIImage *img;
    if (_CurrentMode == kModeCountry) {
        img = [UIImage imageNamed:@"green_pin"];
    }
    else if (_CurrentMode == kModeFlag){
        img = [UIImage imageNamed:@"green_flag"];
    }
    [btnName setImage:img forState:UIControlStateNormal];
    btnName.frame = CGRectMake(btnName.frame.origin.x, btnName.frame.origin.y, img.size.width, img.size.height);
    btnName.hidden = NO;
    [btnName setAccessibilityIdentifier:strIdentifier];
    [ViewContry bringSubviewToFront:btnName];
}
#pragma mark - Create Path for Plane Animation
-(void)CreatePlaneAnimationPath:(NSDictionary*)dicPath
{
    CGPoint planePosition = P(0, 0);
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    
    NSArray *ArrayPath = [dicPath valueForKey:@"path"];
    for (int i = 0; i < [ArrayPath count]; i++)
    {
        NSDictionary *DicTemp = [ArrayPath objectAtIndex:i];
        if (i == 0)
            [trackPath moveToPoint:P([[DicTemp valueForKey:@"x"] floatValue], [[DicTemp valueForKey:@"y"] floatValue])];
        else
            [trackPath addCurveToPoint:P([[DicTemp valueForKey:@"x1"] floatValue], [[DicTemp valueForKey:@"y1"] floatValue]) controlPoint1:P([[DicTemp valueForKey:@"px1"] floatValue], [[DicTemp valueForKey:@"py1"] floatValue]) controlPoint2:P([[DicTemp valueForKey:@"px2"] floatValue], [[DicTemp valueForKey:@"py2"] floatValue])];
        
        if (i == [ArrayPath count] - 1)
        {
            planePosition = P([[DicTemp valueForKey:@"x1"] floatValue], [[DicTemp valueForKey:@"y1"] floatValue]);
        }
    }
    NSDictionary *DicAirplaneInfo = [dicPath valueForKey:@"airplane"];
    
    [self movePlane:trackPath PlaneLastPoint:planePosition AnimationTime:[[DicAirplaneInfo valueForKey:@"animationtime"] floatValue]];
    
}

-(void)movePlane:(UIBezierPath*)trackPath PlaneLastPoint:(CGPoint)point AnimationTime:(CGFloat)animationTime
{
    /*CAShapeLayer *centerline = [CAShapeLayer layer];
     centerline.path = trackPath.CGPath;
     centerline.strokeColor = [UIColor orangeColor].CGColor;
     centerline.fillColor = [UIColor clearColor].CGColor;
     centerline.lineWidth = 2.0;
     centerline.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:2], nil];
     [self.view.layer addSublayer:centerline];*/
	
    if (!plane)
    {
        UIImage *imgPlane = [UIImage imageNamed:@"plane_3.png"];
        plane = [CALayer layer];
        plane.bounds = CGRectMake(0, 0, imgPlane.size.width, imgPlane.size.height);
        plane.contents = (id)(imgPlane.CGImage);
        [self.view.layer addSublayer:plane];
    }
    else
    {
        [self bringSublayerToFront:plane];
    }
    plane.position = point;
    
    [plane removeAllAnimations];
    
	CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	anim.path = trackPath.CGPath;
	anim.rotationMode = kCAAnimationRotateAutoReverse;
	anim.repeatCount = 1;
	anim.duration = animationTime;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
	[plane addAnimation:anim forKey:@"race"];
    
}
//Bring plane to front
- (void)bringSublayerToFront:(CALayer *)layer {
    CALayer *superlayer = layer.superlayer;
    [layer removeFromSuperlayer];
    [superlayer insertSublayer:layer atIndex:[layer.sublayers count]-1];
}

#pragma mark - Toches Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    //If Plane Touch
    if (CGRectContainsPoint(plane.frame,currentPoint)==YES)
    {
        int tempflag = 0;
        if (_CurrentGroup == 111) {
            tempflag = 1;
        }
        NSArray *_totalStageArray = [GlobalMethods ReturnCurrentStageArray:_CurrentStage ForKey:@"AllStage"];
        if (_CurrentStage <= _totalStageArray.count-1) {
            [self CheckInAppAndStartStage:_CurrentStage CurrentGroup:_CurrentGroup PreviousComplete:NO AllGroup:tempflag];
        }
    }
    //Else highlighted countries touch
    else{
        CGPoint currentPointViewContry = [touch locationInView:ViewContry];
        
        if([touch.view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imgViewContryorFlag = (UIImageView *) touch.view;
            
            NSString *strIdentifier = [imgViewContryorFlag accessibilityIdentifier];
            
            if ([strIdentifier rangeOfString:@"flag_pin"].location == NSNotFound) {
                
                for (UIImageView *imgViewContry in ViewContry.subviews) {
                    if (CGRectContainsPoint(imgViewContry.frame,currentPointViewContry)==YES)
                    {
                        CGPoint touchLocationTemp = [touch locationInView:imgViewContry];
                        
                        if (![self isTouchOnTransparentPixel:touchLocationTemp ImageView:imgViewContry]) {
                            
                            [self CheckTouchObjectForImageView:imgViewContry];
                             break;
                        }
                    }
                }
                
            }
        }
    }
}
-(void)btnFlagPressed:(id)sender
{
    UIButton *btnFlag_Pin_Selected = (UIButton*)sender;
    NSString *strIdentifier = [btnFlag_Pin_Selected accessibilityIdentifier];
    
    if ([strIdentifier rangeOfString:@"flag_pin_orange"].location != NSNotFound){
        [self CheckTouchObjectForButton:btnFlag_Pin_Selected];
    }
    else if ([strIdentifier rangeOfString:@"flag_pin_green"].location != NSNotFound){
        
        int TempStage = 0;
        
        TempStage = btnFlag_Pin_Selected.tag - 1;
        
        if ([strIdentifier rangeOfString:@"complete"].location != NSNotFound) {
            [self CheckInAppAndStartStage:TempStage CurrentGroup:111 PreviousComplete:YES AllGroup:1];
        }
        else if ([strIdentifier rangeOfString:@"active"].location != NSNotFound){
            
            [self CheckInAppAndStartStage:_CurrentStage CurrentGroup:_CurrentGroup PreviousComplete:NO AllGroup:1];
        }
    }

}
-(void)CheckTouchObjectForImageView:(UIImageView*)imgName
{
    NSString *file_name = [imgName accessibilityIdentifier] ;
    int TempStage = 0;
    int TempGroup = 0;
    
    TempGroup = imgName.tag % 10;
    TempStage = imgName.tag / 10;
    
    [self CheckStateofTouchedObject:file_name Stage:TempStage Group:TempGroup];
}
-(void)CheckTouchObjectForButton:(UIButton*)btnName
{
    NSString *file_name = [btnName accessibilityIdentifier] ;
    int TempStage = 0;
    int TempGroup = 0;
    
    TempGroup = btnName.tag % 10;
    TempStage = btnName.tag / 10;
    
    [self CheckStateofTouchedObject:file_name Stage:TempStage Group:TempGroup];
}
-(void)CheckStateofTouchedObject:(NSString*)strIdentifier Stage:(int)TempStage Group:(int)TempGroup
{
    if ([strIdentifier rangeOfString:@"complete"].location != NSNotFound) {
        [self CheckInAppAndStartStage:TempStage-1 CurrentGroup:TempGroup-1 PreviousComplete:YES AllGroup:0];
    }
    else if ([strIdentifier rangeOfString:@"active"].location != NSNotFound){
        
        int tempflag = 0;
        if (_CurrentGroup == 111) {
            tempflag = 1;
        }
        [self CheckInAppAndStartStage:_CurrentStage CurrentGroup:_CurrentGroup PreviousComplete:NO AllGroup:tempflag];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)CheckInAppAndStartStage:(int)stage CurrentGroup:(int)group PreviousComplete:(BOOL)YesNo AllGroup:(int)tempflag
{
    if (stage == 0) {
        [self StageBegan:stage CurrentGroup:group PreviousComplete:YesNo AllGroup:tempflag];
    }
    else{
        if ([[NSUserDefaults retrieveObjectForKey:InApp_Countries_Flags_ID] isEqualToString:@"YES"])
        {
            [self StageBegan:stage CurrentGroup:group PreviousComplete:YesNo AllGroup:tempflag];
        }
        else
        {
            if (_CurrentMode == kModeCountry) {
                if ([[NSUserDefaults retrieveObjectForKey:InApp_Countries_ID] isEqualToString:@"YES"])
                {
                    [self StageBegan:stage CurrentGroup:group PreviousComplete:YesNo AllGroup:tempflag];
                }
                else
                {
                    [btnMenu sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
            else if (_CurrentMode == kModeFlag)
            {
                if ([[NSUserDefaults retrieveObjectForKey:InApp_Flags_ID] isEqualToString:@"YES"])
                {
                    [self StageBegan:stage CurrentGroup:group PreviousComplete:YesNo AllGroup:tempflag];
                }
                else
                {
                    [btnMenu sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
}

#pragma mark - StageBegan With Steps
-(void)StageBegan:(int)stage CurrentGroup:(int)group PreviousComplete:(BOOL)YesNo AllGroup:(int)tempflag
{
    //NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:_CurrentStage ForGroup:_CurrentGroup];
   // NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:0 ForGroup:0];
    
   // [self CreatePlaneAnimationPath:[DicPathCurretnGroup valueForKey:@"start"]];
    [self MovePlaneWhenStageStart];
    //Set Stage Title
    lblStageTitle.text = [GlobalMethods ReturnStageTitle:stage];
    
    [UIView animateWithDuration:5.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        if ([btnMenu isSelected])
        {
            [btnMenu setSelected:NO];
        }
        [self.view bringSubviewToFront:View_Menu];
        
        //Fade In Stage Title
        lblStageTitle.alpha = 1.0;
        img_Logo.frame = CGRectMake(img_Logo.frame.origin.x, self.view.frame.size.height, img_Logo.frame.size.width, img_Logo.frame.size.height);
        View_Purchase.frame = CGRectMake(View_Menu.frame.origin.x, -90, View_Menu.frame.size.width, View_Menu.frame.size.height);
        View_Menu.frame = CGRectMake(View_Menu.frame.origin.x, -90, View_Menu.frame.size.width,  View_Menu.frame.size.height);
        img_Shadow.frame = CGRectMake(751, -113, 290, 113);
        self.view.backgroundColor = [UIColor whiteColor];
        
    } completion:^(BOOL finished){
        
        lblStageTitle.alpha = 0.0;
        
        if (tempflag == 0) {
            StagesViewCtr *obj_StagesViewCtr = [[StagesViewCtr alloc]initWithNibName:@"StagesViewCtr" bundle:nil];
            obj_StagesViewCtr._currentGameMode = _CurrentMode;
            obj_StagesViewCtr._currentStage = stage;
            obj_StagesViewCtr._currentGroup = group;
            obj_StagesViewCtr.Completed = YesNo;
            obj_StagesViewCtr._Stagedelegate = self;
            [self.navigationController pushViewController:obj_StagesViewCtr animated:NO];
        }
        else{
            StagesAllGroupViewCtr *obj_StagesAllGroupViewCtr = [[StagesAllGroupViewCtr alloc]initWithNibName:@"StagesAllGroupViewCtr" bundle:nil];
            obj_StagesAllGroupViewCtr._currentGameMode = _CurrentMode;
            obj_StagesAllGroupViewCtr._currentStage = stage;
            obj_StagesAllGroupViewCtr.Completed = YesNo;
            obj_StagesAllGroupViewCtr._StageAllGroupDelegate = self;
            [self.navigationController pushViewController:obj_StagesAllGroupViewCtr animated:NO];
        }
    }];

}
#pragma mark - Zoom Out After Satge Complete
-(void)ZoomOutForNextStage
{
    [UIView animateWithDuration:3.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        WelComeView.frame = CGRectMake(292, 10, 440, 70);
        
    } completion:^(BOOL finished){
    }];
    
    [UIView animateWithDuration:5.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //img_Map.frame = CGRectMake(0, 0, 1024, 768);
        img_Logo.frame = CGRectMake(img_Logo.frame.origin.x, self.view.frame.size.height-img_Logo.frame.size.height, img_Logo.frame.size.width, img_Logo.frame.size.height);
        img_Shadow.frame = CGRectMake(img_Shadow.frame.origin.x, 0, img_Shadow.frame.size.width, img_Shadow.frame.size.height);
        View_Purchase.frame = CGRectMake(View_Menu.frame.origin.x, 0, View_Menu.frame.size.width, View_Menu.frame.size.height);
        View_Menu.frame = CGRectMake(View_Menu.frame.origin.x, 0, View_Menu.frame.size.width,  View_Menu.frame.size.height);
        
        self.view.backgroundColor = RGBCOLOR(235.0, 248.0, 255.0);
        
    } completion:^(BOOL finished){
        
    }];
}

#pragma Mark - Stage Completion Delegate
-(void)StageComplete:(BOOL)previouslycompleted
{
    [self ZoomOutForNextStage];
    
    //Move Plane to next stage
    //NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:0 ForGroup:0];
    //Change Stage And Group for Plane Animation
    
   // [self CreatePlaneAnimationPath:[DicPathCurretnGroup valueForKey:@"end"]];
    
    if (!previouslycompleted) {
        
        NSArray *_currentStageArray = [GlobalMethods ReturnCurrentStageArray:_CurrentStage ForKey:@"Stage"];
        int TotalGroup = _currentStageArray.count;
        NSString *strCurrentGroup;
        if (_CurrentGroup < TotalGroup-1) {
            _CurrentGroup++;
            strCurrentGroup = [NSString stringWithFormat:@"%d",_CurrentGroup];
        }
        else if (_CurrentGroup >= TotalGroup-1)
        {
            NSArray *_totalStageArray = [GlobalMethods ReturnCurrentStageArray:_CurrentStage ForKey:@"AllStage"];
            
            if (_CurrentStage == _totalStageArray.count - 1) {
                _CurrentStage++;
                NSString *strCurrentStage = [NSString stringWithFormat:@"%d",_CurrentStage];
                
                if (_CurrentMode == kModeCountry) {
                    [NSUserDefaults saveObject:strCurrentStage forKey:CurrentStage_Map];
                }
                else if (_CurrentMode == kModeFlag){
                    [NSUserDefaults saveObject:strCurrentStage forKey:CurrentStage_Flag];
                }
            }
            //For All Group
            strCurrentGroup = @"111";
            _CurrentGroup = 111;
        }
        
        if (_CurrentMode == kModeCountry) {
            [NSUserDefaults saveObject:strCurrentGroup forKey:CurrentGroup_Map];
        }
        else if (_CurrentMode == kModeFlag){
            [NSUserDefaults saveObject:strCurrentGroup forKey:CurrentGroup_Flag];
        }
        [self SetImagesToGroups:_CurrentStage Group:_CurrentGroup];
    }
    
    [self MovePlaneToCurrentStageFromOtherStage];

}
-(void)PopViewSetAnimationBack
{
    [self ZoomOutForNextStage];
    
    //Move Plane to next stage
    //NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:0 ForGroup:0];
    //Change Stage And Group for Plane Animation
    
    //[self CreatePlaneAnimationPath:[DicPathCurretnGroup valueForKey:@"end"]];
    [self MovePlaneToCurrentStageFromOtherStage];
}

#pragma mark - _StageAllGroupDelegate Delegate
-(void)StageCompleteForAllGroup:(BOOL)previouslycompleted
{
    [self ZoomOutForNextStage];
    
    //Move Plane to next stage
   // NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:0 ForGroup:0];
    //Change Stage And Group for Plane Animation
    
   // [self CreatePlaneAnimationPath:[DicPathCurretnGroup valueForKey:@"end"]];
    
    if (!previouslycompleted) {
        _CurrentStage++;
        _CurrentGroup = 0;
        
        NSString *strCurrentStage = [NSString stringWithFormat:@"%d",_CurrentStage];
        NSString *strCurrentGroup = [NSString stringWithFormat:@"%d",_CurrentGroup];

        if (_CurrentMode == kModeCountry) {
            [NSUserDefaults saveObject:strCurrentStage forKey:CurrentStage_Map];
            [NSUserDefaults saveObject:strCurrentGroup forKey:CurrentGroup_Map];
        }
        else if (_CurrentMode == kModeFlag){
            [NSUserDefaults saveObject:strCurrentStage forKey:CurrentStage_Flag];
            [NSUserDefaults saveObject:strCurrentGroup forKey:CurrentGroup_Flag];
        }
    
        [self SetImagesToGroups:_CurrentStage Group:_CurrentGroup];
    }
    [self MovePlaneToCurrentStageFromOtherStage];
}
#pragma mark - Mode Selection
-(IBAction)btnModeSelectPressed:(id)sender
{
    UIButton *btnSelected = (UIButton*)sender;
    if ([btnSelected tag] == 11)
        [self SetGameModeUI:kModeCountry MovePlane:YES];
    else if ([btnSelected tag] == 22)
        [self SetGameModeUI:kModeFlag MovePlane:YES];
}
-(void)SetGameModeUI:(int)modeValue MovePlane:(BOOL)planeMove
{
    int tempPrevStage = _CurrentStage;
    int tempPrevGroup = _CurrentGroup;
    
    if (modeValue == kModeCountry)
    {
        _CurrentMode = kModeCountry;
        [btnMap setImage:[UIImage imageNamed:@"maps_blue"] forState:UIControlStateNormal];
        [btnFlag setImage:[UIImage imageNamed:@"flags_grey"] forState:UIControlStateNormal];
    }
    else
    {
        _CurrentMode = kModeFlag;
        [btnMap setImage:[UIImage imageNamed:@"maps_grey"] forState:UIControlStateNormal];
        [btnFlag setImage:[UIImage imageNamed:@"flags_blue"] forState:UIControlStateNormal];
    }
    
    if (_CurrentMode == kModeCountry)
    {
        _CurrentStage = [GlobalMethods ReturnCurrentSatgeGroupForKey:CurrentStage_Map];
        _CurrentGroup = [GlobalMethods ReturnCurrentSatgeGroupForKey:CurrentGroup_Map];
    }
    else
    {
        _CurrentStage = [GlobalMethods ReturnCurrentSatgeGroupForKey:CurrentStage_Flag];
        _CurrentGroup = [GlobalMethods ReturnCurrentSatgeGroupForKey:CurrentGroup_Flag];
    }
    
    NSString *strCurrentGameMode = [NSString stringWithFormat:@"%d",_CurrentMode];
    [NSUserDefaults saveObject:strCurrentGameMode forKey:CurrentGameMode];
    
    if (tempPrevStage == _CurrentStage && tempPrevGroup == _CurrentGroup)
    {
        //Don't Move Plane
    }
    else
    {
        //Move Plane
        if (planeMove){
            [self MovePlaneToCurrentStageFromOtherStage];
        }
        [self SetImagesToGroups:_CurrentStage Group:_CurrentGroup];
    }
    
}

#pragma mark - Menu OpenClose
-(IBAction)btnMenuOpenClosePressed:(id)sender
{
    int height , width = 0;
    int Shadow_height , Shadow_width = 0;
    int xAxis , Shadow_xAxis = 0;
    
    if ([btnMenu isSelected])
    {
        height = 90;
        width = 260;
        xAxis = 764;
        Shadow_height = 113;
        Shadow_width = 290;
        Shadow_xAxis = 751;
        [btnMenu setSelected:NO];
    }
    else
    {
        [self.view bringSubviewToFront:View_Purchase];
        height = 700;
        width = 550;
        xAxis = 484;
        Shadow_height = 723;
        Shadow_width = 565;
        Shadow_xAxis = 471;
        [btnMenu setSelected:YES];
    }
    
    //Check purchase and update UI
    [self CheckPurchaseAndUpdateUI];
    
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        View_Purchase.frame = CGRectMake(xAxis, View_Purchase.frame.origin.y, width, height);
        img_Shadow.frame = CGRectMake(Shadow_xAxis, img_Shadow.frame.origin.y, Shadow_width, Shadow_height);
        
    } completion:^(BOOL finished){
        
        if (![btnMenu isSelected]) {
            [self.view bringSubviewToFront:View_Menu];
        }
    }];
}
#pragma mark - Product Purchase NotificationCenter
- (void)productPurchased:(NSNotification *) notification
{
    // After completion of transaction provide purchased item to customer and also update purchased item's status in NSUserDefaults
    [NSUserDefaults saveObject:@"YES" forKey:notification.object];
    
    //Update UI After Purchase
    [self CheckPurchaseAndUpdateUI];
    // Method will be called when product purchased successfully.
}

- (void)productPurchaseFailed:(NSNotification *) notification
{
    NSString *status = [[notification userInfo] valueForKey:@"isAlert"];
    DisplayAlertWithTitle(@"Failed", status);
}
-(IBAction)btnPurchaseFlagsMapsPressed:(id)sender
{
    if ([sender tag] == 111)
    {
        if (![[NSUserDefaults retrieveObjectForKey:InApp_Countries_ID] isEqualToString:@"YES"])
        {
            if (![[NSUserDefaults retrieveObjectForKey:InApp_Countries_Flags_ID] isEqualToString:@"YES"]) {
                if ([AppDel checkConnection])
                    [GlobalMethods BuyProduct:InApp_Countries_ID];
                else
                    DisplayLocalizedAlertNoInternet;
            }
        }
    }
    else if ([sender tag] == 222)
    {
        if (![[NSUserDefaults retrieveObjectForKey:InApp_Flags_ID] isEqualToString:@"YES"])
        {
            if (![[NSUserDefaults retrieveObjectForKey:InApp_Countries_Flags_ID] isEqualToString:@"YES"]) {
                if ([AppDel checkConnection])
                    [GlobalMethods BuyProduct:InApp_Flags_ID];
                else
                    DisplayLocalizedAlertNoInternet;
            }
        }
    }
    else if ([sender tag] == 333)
    {
        if (![[NSUserDefaults retrieveObjectForKey:InApp_Countries_Flags_ID] isEqualToString:@"YES"])
        {
            if ([[NSUserDefaults retrieveObjectForKey:InApp_Countries_ID] isEqualToString:@"YES"] && [[NSUserDefaults retrieveObjectForKey:InApp_Flags_ID] isEqualToString:@"YES"])
            {
                //If Country & flag purchased separately
            }
            else
            {
                if ([AppDel checkConnection])
                    [GlobalMethods BuyProduct:InApp_Countries_Flags_ID];
                else
                    DisplayLocalizedAlertNoInternet;
            }
        }
    }
}
-(IBAction)btnRestorePurchasedPressed:(id)sender
{
    if ([AppDel checkConnection])
        [GlobalMethods RestoreInApp];
    else
        DisplayLocalizedAlertNoInternet;
}
-(void)CheckPurchaseAndUpdateUI
{
    if ([[NSUserDefaults retrieveObjectForKey:InApp_Countries_ID] isEqualToString:@"YES"])
    {
        [btnMapsPurchase setTitle:LSSTRING(@"UNLOCKED") forState:UIControlStateNormal];
        [btnMapsPurchase setTitle:LSSTRING(@"UNLOCKED") forState:UIControlStateHighlighted];
    }
    
    if ([[NSUserDefaults retrieveObjectForKey:InApp_Flags_ID] isEqualToString:@"YES"])
    {
        [btnFlagsPurchase setTitle:LSSTRING(@"UNLOCKED") forState:UIControlStateNormal];
        [btnFlagsPurchase setTitle:LSSTRING(@"UNLOCKED") forState:UIControlStateHighlighted];
    }
    
    if (([[NSUserDefaults retrieveObjectForKey:InApp_Countries_ID] isEqualToString:@"YES"] && [[NSUserDefaults retrieveObjectForKey:InApp_Flags_ID] isEqualToString:@"YES"]) || [[NSUserDefaults retrieveObjectForKey:InApp_Countries_Flags_ID] isEqualToString:@"YES"])
    {
        [btnMapsPurchase setTitle:LSSTRING(@"UNLOCKED") forState:UIControlStateNormal];
        [btnFlagsPurchase setTitle:LSSTRING(@"UNLOCKED") forState:UIControlStateNormal];
        [btnMapsFlagsPurchase setTitle:LSSTRING(@"UNLOCKED") forState:UIControlStateNormal];
        
        [btnMapsPurchase setTitle:LSSTRING(@"UNLOCKED") forState:UIControlStateHighlighted];
        [btnFlagsPurchase setTitle:LSSTRING(@"UNLOCKED") forState:UIControlStateHighlighted];
        [btnMapsFlagsPurchase setTitle:LSSTRING(@"UNLOCKED") forState:UIControlStateHighlighted];
    }
}

#pragma mark - Reset Game
-(IBAction)btnResetPressed:(id)sender
{
    UIAlertView *AlertReset = [[UIAlertView alloc]initWithTitle:LSSTRING(@"Reset Current Progress?") message:LSSTRING(@"Are you sure you want to reset your current progress? All progress and airplane upgrades will be lost and you will restart from stage 1.") delegate:self cancelButtonTitle:nil otherButtonTitles:LSSTRING(@"Reset"),LSSTRING(@"Cancel"), nil];
    AlertReset.tag = 1;
    [AlertReset show];
}

#pragma mark - UIAlertView Delegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            if (_CurrentStage == 0 && _CurrentGroup == 0)
            {
                [btnMenu sendActionsForControlEvents:UIControlEventTouchUpInside];
                //Don't Reset
            }
            else
            {
                [btnMenu sendActionsForControlEvents:UIControlEventTouchUpInside];
                //Reset
                
                //Reset Current stage and group value to 1
                [NSUserDefaults deleteObjectForKey:CurrentStage_Map];
                [NSUserDefaults deleteObjectForKey:CurrentStage_Flag];
                [NSUserDefaults deleteObjectForKey:CurrentGroup_Map];
                [NSUserDefaults deleteObjectForKey:CurrentGroup_Flag];
                
                if (_CurrentMode == kModeCountry)
                {
                    _CurrentStage = [GlobalMethods ReturnCurrentSatgeGroupForKey:CurrentStage_Map];
                    _CurrentGroup = [GlobalMethods ReturnCurrentSatgeGroupForKey:CurrentGroup_Map];
                }
                else
                {
                    _CurrentStage = [GlobalMethods ReturnCurrentSatgeGroupForKey:CurrentStage_Flag];
                    _CurrentGroup = [GlobalMethods ReturnCurrentSatgeGroupForKey:CurrentGroup_Flag];
                }
                
                [self SetImagesToGroups:_CurrentStage Group:_CurrentGroup];
                //Set Plane to Stage 1 group 1 After Reset
                [self MovePlaneToCurrentStageFromOtherStage];
            }
            
        }
        else if (buttonIndex == 1)
            return;
    }
}
-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}
-(void)MovePlaneToCurrentStageFromOtherStage
{
    //Set Plane to stage 1 group 1
    
    NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:_CurrentStage ForGroup:_CurrentGroup];
    
    NSDictionary *DicTemp = [[DicPathCurretnGroup valueForKey:@"start"] valueForKey:@"path"];
    
    float Fromx1 = plane.position.x;
    float Fromy1 = plane.position.y;
    
    float Fromx2 = [[DicTemp valueForKey:@"x"] floatValue];
    float Fromy2 = [[DicTemp valueForKey:@"y"] floatValue];
    
    if (Fromx1 > Fromx2)
    {
        Fromx1 = [[DicTemp valueForKey:@"x"] floatValue];
        Fromx2 = plane.position.x;
    }
    
    if (Fromy1 > Fromy2)
    {
        Fromy1 = [[DicTemp valueForKey:@"y"] floatValue];
        Fromy2 = plane.position.y;
    }
    
    //ControlPoint1
    float cp1X = [self getRandomNumberBetween:Fromx1 to:Fromx2];
    float cp1Y = [self getRandomNumberBetween:Fromy1 to:Fromy2];
    
    CGPoint s = plane.position;
    CGPoint e = P([[DicTemp valueForKey:@"x"] floatValue], [[DicTemp valueForKey:@"y"] floatValue]);
    CGPoint cp1 = P(cp1X+100, cp1Y);
    CGPoint cp2 = P([[DicTemp valueForKey:@"x"] floatValue], [[DicTemp valueForKey:@"y"] floatValue]+100);
    
    UIBezierPath *trackpath = [UIBezierPath bezierPath];
    [trackpath moveToPoint:s];
    [trackpath addCurveToPoint:e controlPoint1:cp1 controlPoint2:cp2];
    
    [self movePlane:trackpath PlaneLastPoint:e AnimationTime:StepCompleteAnimationTime];
}
-(void)MovePlaneWhenStageStart
{
    //Set Plane to stage 1 group 1
    
    NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:_CurrentStage ForGroup:_CurrentGroup];
    
    NSDictionary *DicStartPath = [[DicPathCurretnGroup valueForKey:@"start"] valueForKey:@"path"];
    NSDictionary *DicEndPath = [[DicPathCurretnGroup valueForKey:@"end"] valueForKey:@"path"];
    //random values
    
    CGPoint s = P([[DicStartPath valueForKey:@"x"] floatValue], [[DicStartPath valueForKey:@"y"] floatValue]);
    CGPoint e = P([[DicEndPath valueForKey:@"x"] floatValue], [[DicEndPath valueForKey:@"y"] floatValue]);
    
    float distanceDiff = [[DicStartPath valueForKey:@"x"] floatValue] + [[DicEndPath valueForKey:@"x"] floatValue];
    distanceDiff = distanceDiff/3;
    UIBezierPath *trackpath = [UIBezierPath bezierPath];
    [trackpath moveToPoint:s];
    if ([[DicEndPath valueForKey:@"x"] floatValue] > 1024)
    {
        float y1 = [[DicStartPath valueForKey:@"y"] floatValue] - distanceDiff;
        float y2 = [[DicStartPath valueForKey:@"y"] floatValue] + distanceDiff;
        /*if ([[DicStartPath valueForKey:@"y"] floatValue] > [[DicEndPath valueForKey:@"y"] floatValue])
        {
            y1 = [[DicStartPath valueForKey:@"y"] floatValue] - distanceDiff;
            y2 = [[DicStartPath valueForKey:@"y"] floatValue] + distanceDiff;
        }
        else
        {
            y1 = [[DicStartPath valueForKey:@"y"] floatValue] + distanceDiff;
            y2 = [[DicStartPath valueForKey:@"y"] floatValue] - distanceDiff;
        }*/
        [trackpath addCurveToPoint:e controlPoint1:P([[DicStartPath valueForKey:@"x"] floatValue] +distanceDiff, y1) controlPoint2:P([[DicStartPath valueForKey:@"x"] floatValue] + distanceDiff, y2)];
    }
    else
    {
        float y1 = [[DicStartPath valueForKey:@"y"] floatValue] + distanceDiff;
        float y2 = [[DicStartPath valueForKey:@"y"] floatValue] - distanceDiff;
        /*if ([[DicStartPath valueForKey:@"y"] floatValue] > [[DicEndPath valueForKey:@"y"] floatValue])
        {
            y1 = [[DicStartPath valueForKey:@"y"] floatValue] + distanceDiff;
            y2 = [[DicStartPath valueForKey:@"y"] floatValue] - distanceDiff;
        }
        else
        {
            y1 = [[DicStartPath valueForKey:@"y"] floatValue] - distanceDiff;
            y2 = [[DicStartPath valueForKey:@"y"] floatValue] + distanceDiff;
        }*/

        [trackpath addCurveToPoint:e controlPoint1:P([[DicStartPath valueForKey:@"x"] floatValue] -distanceDiff, y1) controlPoint2:P([[DicStartPath valueForKey:@"x"] floatValue] -distanceDiff, y2)];
    }
    
    CGFloat animationTime = [[[[DicPathCurretnGroup valueForKey:@"start"] valueForKey:@"airplane"] valueForKeyPath:@"animationtime"] floatValue];
    [self movePlane:trackpath PlaneLastPoint:e AnimationTime:animationTime];
}
#pragma mark - Check ImageView Transperant or not
- (BOOL)isTouchOnTransparentPixel:(CGPoint)point ImageView:(UIImageView*)iv{
    
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [iv.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    CGFloat alpha = pixel[3]/255.0;
    BOOL transparent = alpha < 0.01;
    
    return transparent;
}

#pragma mark - Audio Player
-(void)setPlaneSoundsPlayer
{
    if (self.plane_landing == nil)
    {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"plane_landing" ofType: @"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
        newPlayer.numberOfLoops = 0;
        self.plane_landing = newPlayer;
        [self.plane_landing prepareToPlay];
        [self.plane_landing stop];
    }
    if (self.plane_takeoff == nil)
    {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"plane_take_off" ofType: @"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
        newPlayer.numberOfLoops = 0;
        self.plane_takeoff = newPlayer;
        [self.plane_takeoff prepareToPlay];
        [self.plane_takeoff stop];
    }
    if (self.plane_flying == nil)
    {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"plane_flying" ofType: @"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
        newPlayer.numberOfLoops = -1;
        self.plane_flying = newPlayer;
        [self.plane_flying prepareToPlay];
        [self.plane_flying stop];
    }
}
-(void)PlayPlaneSoundwithDictionary:(NSDictionary*)dicPath
{
    plane_Current_Time = 0;
    NSDictionary *DicAirplaneInfo = [dicPath valueForKey:@"airplane"];
    plane_Animation_Time = [[DicAirplaneInfo valueForKey:@"animationtime"] floatValue];
    plane_timer = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(timeChanged:) userInfo:nil repeats:YES];
    [self.plane_takeoff play];
}
-(void)timeChanged:(NSTimer*)timer
{
    plane_Current_Time = plane_Current_Time + 0.10;
    if (plane_Current_Time >= plane_Animation_Time) {
        if ([self.plane_takeoff isPlaying])
            [self.plane_takeoff stop];
        
        if ([self.plane_flying isPlaying])
            [self.plane_flying stop];
        
        if ([self.plane_landing isPlaying])
            [self.plane_landing stop];
        
        if ([plane_timer isValid]) {
            [plane_timer invalidate];
            plane_timer = nil;
        }
        plane_Current_Time = 0;
        [self EnableViewInteraction];
    }
    else if (plane_Current_Time > (plane_Animation_Time - self.plane_landing.duration))
    {
        if ([self.plane_takeoff isPlaying])
            [self.plane_takeoff stop];
        
        if ([self.plane_flying isPlaying])
            [self.plane_flying stop];
    }
    else if (plane_Current_Time > (plane_Animation_Time - self.plane_landing.duration) - 0.80)
    {
        if (![self.plane_landing isPlaying])
            [self.plane_landing play];
    }
    else if (plane_Current_Time > (int)self.plane_takeoff.duration)
    {
        if ([self.plane_takeoff isPlaying])
            [self.plane_takeoff stop];
        
        if ([self.plane_landing isPlaying])
            [self.plane_landing stop];
    }
    else if (plane_Current_Time > (int)self.plane_takeoff.duration - 0.80)
    {
        if (![self.plane_flying isPlaying])
            [self.plane_flying play];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
