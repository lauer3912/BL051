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
    
    lblBlue.layer.cornerRadius = 8.0;
    lblBorderMenu.layer.cornerRadius = 8.0;
    
    [AsiaView.layer setCornerRadius:8.0f];
    // drop shadow
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
   // if (_CurrentStage == 0 && _CurrentGroup == 0)
    //{
        [self performSelector:@selector(ZoomAsiaMap) withObject:nil afterDelay:1.0];
        [self performSelector:@selector(EnableViewInteraction) withObject:nil afterDelay:PlaneAnimationTime+1.0];
    //}
    //else
    //{
        //Set Asia Witout Zoom If app not in first time
       // [self SetAisaWithZoomWithoutAnimation];
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
    lblWelcome.font = Questrial_Regular(lblWelcome.font.pointSize);
    lblMonte.font = Questrial_Regular(lblMonte.font.pointSize);
    lblAsia.font = Questrial_Regular(lblAsia.font.pointSize);
    lblStageTitle.font = Questrial_Regular(lblStageTitle.font.pointSize);
    
    //Home Screen
    btnMapsPurchase.titleLabel.font = Questrial_Regular(btnReset.titleLabel.font.pointSize);
    btnFlagsPurchase.titleLabel.font = Questrial_Regular(btnReset.titleLabel.font.pointSize);
    btnMapsFlagsPurchase.titleLabel.font = Questrial_Regular(btnReset.titleLabel.font.pointSize);
    btnReset.titleLabel.font = Questrial_Regular(btnReset.titleLabel.font.pointSize);
    btnRestorePurchases.titleLabel.font = Questrial_Regular(btnRestorePurchases.titleLabel.font.pointSize);
    
    lblMapsPurchase.font = Questrial_Regular(lblMapsPurchase.font.pointSize);
    lblFlagsPurchase.font = Questrial_Regular(lblFlagsPurchase.font.pointSize);
    lblMapsFlagsPurchase.font = Questrial_Regular(lblMapsFlagsPurchase.font.pointSize);
    lblReset.font = Questrial_Regular(lblReset.font.pointSize);
    
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
    NSArray *ArryCurrentStageGroup = [[ArryIntroPath objectAtIndex:0] valueForKey:@"groups"];
    NSDictionary *DicPathCurretnGroup = [ArryCurrentStageGroup objectAtIndex:0];
    [self CreatePlaneAnimationPath:DicPathCurretnGroup];

    //Map Zoom
    [UIView animateWithDuration:4.50 animations:^{
        AsiaView.frame = CGRectMake(AsiaView.frame.origin.x, 90, AsiaView.frame.size.width, AsiaView.frame.size.height);
        WelComeView.transform = CGAffineTransformScale(WelComeView.transform, 0.80, 0.80);
        WelComeView.frame = CGRectMake(292, 100, 440, 70);
        img_Map.frame = CGRectMake(-1302, -316, 2400, 1855);
    } completion:^(BOOL finished) {
        
        [AsiaView addSubview:WelComeView];
        WelComeView.frame = CGRectMake(20, 10, 440, 70);
        img_Map.frame = CGRectMake(0, 0, 1024, 768);
        img_Map.image = [UIImage imageNamed:@"asia_map"];
        
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
-(void)SetAisaWithZoomWithoutAnimation
{
    lblLine1.alpha = 0.0;
    lblWelcome.alpha = 0.0;
    
    
    NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:_CurrentStage ForGroup:_CurrentGroup];
    
    [self performSelector:@selector(EnableViewInteraction) withObject:nil afterDelay:0.1+1];
    
    NSArray *ArrayPath = [[DicPathCurretnGroup valueForKey:@"start"] valueForKey:@"path"];
    NSDictionary *DicTemp = [ArrayPath objectAtIndex:0];
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    
    [trackPath moveToPoint:P([[DicTemp valueForKey:@"x"] floatValue], [[DicTemp valueForKey:@"y"] floatValue]+20)];
    [trackPath addLineToPoint:P([[DicTemp valueForKey:@"x"] floatValue], [[DicTemp valueForKey:@"y"] floatValue])];
    
    [self movePlane:trackPath PlaneLastPoint:P([[DicTemp valueForKey:@"x"] floatValue], [[DicTemp valueForKey:@"y"] floatValue]) AnimationTime:0.1];
    
    
    //Aisa
    View_Purchase.frame = CGRectMake(View_Purchase.frame.origin.x, 0, View_Purchase.frame.size.width, View_Purchase.frame.size.height);
    img_Shadow.frame = CGRectMake(img_Shadow.frame.origin.x, 0, img_Shadow.frame.size.width, img_Shadow.frame.size.height);
    WelComeView.transform = CGAffineTransformScale(WelComeView.transform, 0.80, 0.80);
    WelComeView.frame = CGRectMake(292, 10, 440, 70);
    img_Map.frame = CGRectMake(0, 0, 1024, 768);
    img_Map.image = [UIImage imageNamed:@"asia_map"];
    
    //Show Logo
    img_Logo.frame = CGRectMake(img_Logo.frame.origin.x, img_Logo.frame.origin.y, 365, img_Logo.frame.size.height);
}
-(void)EnableViewInteraction
{
    self.view.userInteractionEnabled = YES;
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
   /* CAShapeLayer *centerline = [CAShapeLayer layer];
    centerline.path = trackPath.CGPath;
    centerline.strokeColor = [UIColor greenColor].CGColor;
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

#pragma mark - Toches Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    if (CGRectContainsPoint(plane.frame,currentPoint)==YES)
    {
        //Frame Before MoveNext Stage
        NSLog(@"Plane Touched");
        //NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:_CurrentStage ForGroup:_CurrentGroup];
        NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:0 ForGroup:0];
        
        
        [self CreatePlaneAnimationPath:[DicPathCurretnGroup valueForKey:@"start"]];
        
        //Set Stage Title
        lblStageTitle.text = [GlobalMethods ReturnStageTitle:_CurrentStage];
        
        [UIView animateWithDuration:5.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            if ([btnMenu isSelected])
            {
                [btnMenu setSelected:NO];
            }
            [self.view bringSubviewToFront:View_Menu];

            //Fade In Stage Title
            lblStageTitle.alpha = 1.0;
            
            //img_Map.frame = CGRectMake(-1755, -1041, 2920, 2195);
            img_Map.frame = CGRectMake(-1639, -934, 2920, 2195);
            img_Logo.frame = CGRectMake(img_Logo.frame.origin.x, self.view.frame.size.height, img_Logo.frame.size.width, img_Logo.frame.size.height);
            View_Purchase.frame = CGRectMake(View_Menu.frame.origin.x, -90, View_Menu.frame.size.width, View_Menu.frame.size.height);
            View_Menu.frame = CGRectMake(View_Menu.frame.origin.x, -90, View_Menu.frame.size.width,  View_Menu.frame.size.height);
            img_Shadow.frame = CGRectMake(751, -113, 290, 113);
            self.view.backgroundColor = [UIColor whiteColor];
            
        } completion:^(BOOL finished){
            
                lblStageTitle.alpha = 0.0;
            
                StagesViewCtr *obj_StagesViewCtr = [[StagesViewCtr alloc]initWithNibName:@"StagesViewCtr" bundle:nil];
                obj_StagesViewCtr._currentGameMode = _CurrentMode;
                obj_StagesViewCtr._currentStage = _CurrentStage;
                obj_StagesViewCtr._currentGroup = _CurrentGroup;
//            obj_StagesViewCtr._currentStage = 0;
//            obj_StagesViewCtr._currentGroup = 1;
                obj_StagesViewCtr._Stagedelegate = self;
                [self.navigationController pushViewController:obj_StagesViewCtr animated:NO];
        }];
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

#pragma mark - Zoom Out After Satge Complete
-(void)ZoomOutForNextStage
{
    [UIView animateWithDuration:3.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        WelComeView.frame = CGRectMake(292, 10, 440, 70);
        
    } completion:^(BOOL finished){
    }];
    
    [UIView animateWithDuration:5.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        img_Map.frame = CGRectMake(0, 0, 1024, 768);
        img_Logo.frame = CGRectMake(img_Logo.frame.origin.x, self.view.frame.size.height-img_Logo.frame.size.height, img_Logo.frame.size.width, img_Logo.frame.size.height);
        img_Shadow.frame = CGRectMake(img_Shadow.frame.origin.x, 0, img_Shadow.frame.size.width, img_Shadow.frame.size.height);
        View_Purchase.frame = CGRectMake(View_Menu.frame.origin.x, 0, View_Menu.frame.size.width, View_Menu.frame.size.height);
        View_Menu.frame = CGRectMake(View_Menu.frame.origin.x, 0, View_Menu.frame.size.width,  View_Menu.frame.size.height);
        
        self.view.backgroundColor = RGBCOLOR(235.0, 248.0, 255.0);
        
    } completion:^(BOOL finished){
        
    }];
}

#pragma Mark - Stage Completion Delegate
-(void)StageComplete
{
    [self ZoomOutForNextStage];
    
    //Move Plane to next stage
    NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:_CurrentStage ForGroup:_CurrentGroup];
    
    [self CreatePlaneAnimationPath:[DicPathCurretnGroup valueForKey:@"end"]];
    
    NSArray *_currentStageArray = [GlobalMethods ReturnCurrentStageArray:_CurrentStage ForKey:@"Stage"];
    int TotalGroup = _currentStageArray.count;
    if (_CurrentGroup < TotalGroup-1) {
        _CurrentGroup++;
    }
    else if (_CurrentGroup >= TotalGroup-1)
    {
        _CurrentStage++;
        _CurrentGroup = 0;
        
        NSString *strCurrentStage = [NSString stringWithFormat:@"%d",_CurrentStage];
        [NSUserDefaults saveObject:strCurrentStage forKey:CurrentStage_Map];
    }
    NSString *strCurrentGroup = [NSString stringWithFormat:@"%d",_CurrentGroup];
    [NSUserDefaults saveObject:strCurrentGroup forKey:CurrentGroup_Map];
    
    NSLog(@"Stage : %d --> Group : %d",_CurrentStage,_CurrentGroup);
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
        if (planeMove)
            [self MovePlaneToCurrentStageFromOtherStage];
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
        if (![[NSUserDefaults retrieveObjectForKey:InApp_Maps_identifier] isEqualToString:@"YES"])
        {
            if ([AppDel checkConnection])
                [GlobalMethods BuyProduct:InApp_Maps_identifier];
            else
                DisplayAlertWithTitle(@"Error Message", @"Please check your internet connection");
        }
    }
    else if ([sender tag] == 222)
    {
        if (![[NSUserDefaults retrieveObjectForKey:InApp_Flags_identifier] isEqualToString:@"YES"])
        {
             if ([AppDel checkConnection])
                 [GlobalMethods BuyProduct:InApp_Flags_identifier];
             else
                 DisplayAlertWithTitle(@"Error Message", @"Please check your internet connection");
        }
    }
    else if ([sender tag] == 333)
    {
        if (![[NSUserDefaults retrieveObjectForKey:InApp_Maps_Flags_identifier] isEqualToString:@"YES"])
        {
             if ([AppDel checkConnection])
                 [GlobalMethods BuyProduct:InApp_Maps_Flags_identifier];
             else
                 DisplayAlertWithTitle(@"Error Message", @"Please check your internet connection");
        }
    }
}
-(IBAction)btnRestorePurchasedPressed:(id)sender
{
    [GlobalMethods RestoreInApp];
}
-(void)CheckPurchaseAndUpdateUI
{
    if ([[NSUserDefaults retrieveObjectForKey:InApp_Maps_identifier] isEqualToString:@"YES"])
        [btnMapsPurchase setTitle:@"UNLOCKED" forState:UIControlStateNormal];
    
    if ([[NSUserDefaults retrieveObjectForKey:InApp_Flags_identifier] isEqualToString:@"YES"])
        [btnFlagsPurchase setTitle:@"UNLOCKED" forState:UIControlStateNormal];
    
    if ([[NSUserDefaults retrieveObjectForKey:InApp_Maps_Flags_identifier] isEqualToString:@"YES"])
        [btnMapsFlagsPurchase setTitle:@"UNLOCKED" forState:UIControlStateNormal];
}

#pragma mark - Reset Game 
-(IBAction)btnResetPressed:(id)sender
{
    UIAlertView *AlertReset = [[UIAlertView alloc]initWithTitle:@"Reset Current Progress?" message:@"Are you sure you want to reset your current progress? All progress and airplane upgrades will be lost and you will restart from stage 1." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Reset",@"Cancel", nil];
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
    
    NSArray *ArrayPath = [[DicPathCurretnGroup valueForKey:@"start"] valueForKey:@"path"];
    NSDictionary *DicTemp = [ArrayPath objectAtIndex:0];
    
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
    float cp1Y = [self getRandomNumberBetween:Fromy1 to:Fromy2+50];
    
    CGPoint s = plane.position;
    CGPoint e = P([[DicTemp valueForKey:@"x"] floatValue], [[DicTemp valueForKey:@"y"] floatValue]);
    CGPoint cp1 = P(cp1X, cp1Y);
    CGPoint cp2 = P([[DicTemp valueForKey:@"x"] floatValue], [[DicTemp valueForKey:@"y"] floatValue]+50);
    
    UIBezierPath *trackpath = [UIBezierPath bezierPath];
    [trackpath moveToPoint:s];
    [trackpath addCurveToPoint:e controlPoint1:cp1 controlPoint2:cp2];
    
    [self movePlane:trackpath PlaneLastPoint:e AnimationTime:StepCompleteAnimationTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
