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
    
    lblWhite.layer.cornerRadius = 8.0;
    lblBlue.layer.cornerRadius = 8.0;
    lblBlue.hidden = YES;
    //Retrive Current Stage & Group & Game Mode
    
    _CurrentMode = [GlobalMethods ReturnCurrentSatgeGroupForKey:CurrentGameMode];
    
    //Set UI Of Game Mode Country/Flag
    [self SetGameModeUI:_CurrentMode];
    
    //Apply Custom Font
    [self SetCustomFont];

    //Zoom Map To Asia
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(ZoomAsiaMap) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(EnableViewInteraction) withObject:nil afterDelay:PlaneAnimationTime+1.0];
    
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
    
    //Home Screen
    btnMapsPurchase.titleLabel.font = Questrial_Regular(btnReset.titleLabel.font.pointSize);
    btnFlagsPurchase.titleLabel.font = Questrial_Regular(btnReset.titleLabel.font.pointSize);
    btnMapsFlagsPurchase.titleLabel.font = Questrial_Regular(btnReset.titleLabel.font.pointSize);
    btnReset.titleLabel.font = Questrial_Regular(btnReset.titleLabel.font.pointSize);
    
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
    
    NSDictionary *DicPath = [temp valueForKey:@"introduction"];
    [self CreatePlaneAnimationPath:DicPath];

    //Map Zoom
    [UIView animateWithDuration:4.50 animations:^{
        View_Purchase.frame = CGRectMake(View_Purchase.frame.origin.x, 0, View_Purchase.frame.size.width, View_Purchase.frame.size.height);
        img_Shadow.frame = CGRectMake(img_Shadow.frame.origin.x, 0, img_Shadow.frame.size.width, img_Shadow.frame.size.height);
        WelComeView.transform = CGAffineTransformScale(WelComeView.transform, 0.80, 0.80);
        WelComeView.frame = CGRectMake(292, 10, 440, 70);
        img_Map.frame = CGRectMake(-1302, -316, 2400, 1855);
    } completion:^(BOOL finished) {
        img_Map.frame = CGRectMake(0, 0, 1024, 768);
        img_Map.image = [UIImage imageNamed:@"asia_map"];
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
-(void)PlaneFlyOff
{
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
	[trackPath moveToPoint:P(719, 510)];
    
    [trackPath addCurveToPoint:P(-100, 510) controlPoint1:P(452, 340) controlPoint2:P(175, 390)];
    
    [self movePlane:trackPath PlaneLastPoint:P(-100, 510) AnimationTime:5.0];
}
-(void)movePlane:(UIBezierPath*)trackPath PlaneLastPoint:(CGPoint)point AnimationTime:(CGFloat)animationTime
{
    /*CAShapeLayer *centerline = [CAShapeLayer layer];
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
        NSDictionary *DicPathCurretnGroup = [GlobalMethods ReturnPathForPlaneAnimationForStage:_CurrentStage ForGroup:_CurrentGroup];
        
        [self CreatePlaneAnimationPath:[DicPathCurretnGroup valueForKey:@"start"]];
        
        [UIView animateWithDuration:3.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            WelComeView.frame = CGRectMake(292, -80, 440, 70);
            
        } completion:^(BOOL finished){
        }];
        
        [UIView animateWithDuration:5.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            if ([btnMenu isSelected])
            {
                [btnMenu setSelected:NO];
                [btnMenu setImage:[UIImage imageNamed:@"menu_grey"] forState:UIControlStateNormal];
                img_Arrow.hidden = YES;
            }
            
            img_Map.frame = CGRectMake(-1755, -1041, 2920, 2195);
            img_Logo.frame = CGRectMake(img_Logo.frame.origin.x, self.view.frame.size.height, img_Logo.frame.size.width, img_Logo.frame.size.height);
            View_Purchase.frame = CGRectMake(View_Purchase.frame.origin.x, -180, View_Purchase.frame.size.width, 180);
            img_Shadow.frame = CGRectMake(img_Shadow.frame.origin.x, -200, img_Shadow.frame.size.width, 200);
            self.view.backgroundColor = [UIColor whiteColor];
            
        } completion:^(BOOL finished){
            
                StagesViewCtr *obj_StagesViewCtr = [[StagesViewCtr alloc]initWithNibName:@"StagesViewCtr" bundle:nil];
                obj_StagesViewCtr._currentGameMode = _CurrentMode;
                obj_StagesViewCtr._currentStage = _CurrentStage;
                obj_StagesViewCtr._currentGroup = _CurrentGroup;
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
        View_Purchase.frame = CGRectMake(View_Purchase.frame.origin.x, 0, View_Purchase.frame.size.width, View_Purchase.frame.size.height);
        img_Shadow.frame = CGRectMake(img_Shadow.frame.origin.x, 0, img_Shadow.frame.size.width, img_Shadow.frame.size.height);
        
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
        [self SetGameModeUI:kModeCountry];
    else if ([btnSelected tag] == 22)
        [self SetGameModeUI:kModeFlag];
    
    NSString *strCurrentGameMode = [NSString stringWithFormat:@"%d",_CurrentMode];
    [NSUserDefaults saveObject:strCurrentGameMode forKey:CurrentGameMode];
}
-(void)SetGameModeUI:(int)modeValue
{
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
}

#pragma mark - Menu OpenClose
-(IBAction)btnMenuOpenClosePressed:(id)sender
{
    [self.view bringSubviewToFront:View_Purchase];
    [self.view bringSubviewToFront:WelComeView];
    
    int height = 180;
    int Shadow_height = 200;
    if ([btnMenu isSelected])
    {
        height = 180;
        Shadow_height = 200;
        [btnMenu setSelected:NO];
        [btnMenu setImage:[UIImage imageNamed:@"menu_grey"] forState:UIControlStateNormal];
        img_Arrow.hidden = YES;
    }
    else
    {
        lblWhite.layer.cornerRadius = 0.0;
        lblBlue.hidden = NO;
        height = 680;
        Shadow_height = 700;
        [btnMenu setSelected:YES];
        [btnMenu setImage:[UIImage imageNamed:@"menu_blue"] forState:UIControlStateNormal];
        img_Arrow.hidden = NO;
    }
    
    //Check purchase and update UI
    [self CheckPurchaseAndUpdateUI];
    
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        View_Purchase.frame = CGRectMake(View_Purchase.frame.origin.x, View_Purchase.frame.origin.y, View_Purchase.frame.size.width, height);
        img_Shadow.frame = CGRectMake(img_Shadow.frame.origin.x, img_Shadow.frame.origin.y, img_Shadow.frame.size.width, Shadow_height);
        
    } completion:^(BOOL finished){
        
        if ([img_Arrow isHidden])
        {
            lblBlue.hidden = YES;
            lblWhite.layer.cornerRadius = 8.0;
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
-(void)CheckPurchaseAndUpdateUI
{
    if ([[NSUserDefaults retrieveObjectForKey:InApp_Maps_identifier] isEqualToString:@"YES"])
        [btnMapsPurchase setTitle:@"UNLOCKED" forState:UIControlStateNormal];
    
    if ([[NSUserDefaults retrieveObjectForKey:InApp_Flags_identifier] isEqualToString:@"YES"])
        [btnFlagsPurchase setTitle:@"UNLOCKED" forState:UIControlStateNormal];
    
    if ([[NSUserDefaults retrieveObjectForKey:InApp_Maps_Flags_identifier] isEqualToString:@"YES"])
        [btnMapsFlagsPurchase setTitle:@"UNLOCKED" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
