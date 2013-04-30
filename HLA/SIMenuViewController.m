//
//  SIMenuViewController.m
//  HLA Ipad
//
//  Created by shawal sapuan on 10/3/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIMenuViewController.h"
#import "NewLAViewController.h"
#import "BasicPlanViewController.h"
#import "RiderViewController.h"
#import "SecondLAViewController.h"
#import "PayorViewController.h"
#import "PremiumViewController.h"
#import "MainScreen.h"
#import "ReportViewController.h"
#import "BrowserViewController.h"
#import "PDSViewController.h"
#import "CashPromiseViewController.h"
#import "AppDelegate.h"

@interface SIMenuViewController ()

@end

@implementation SIMenuViewController
@synthesize myTableView, SIshowQuotation;
@synthesize RightView;
@synthesize ListOfSubMenu,SelectedRow;
@synthesize menuBH,menuPH,menuLa2ndH,getCommDate;
@synthesize getAge,getSINo,getOccpCode,getbasicSA;
@synthesize payorCustCode,payorSINo,CustCode2,clientID2,getPayorIndexNo,get2ndLAIndexNo;
@synthesize LAController = _LAController;
@synthesize PayorController = _PayorController;
@synthesize SecondLAController = _SecondLAController;
@synthesize BasicController = _BasicController;
@synthesize getIdPay,getIdProf,getPayAge,getPayDOB,getPayOccp,getPaySex,getPaySmoker;
@synthesize get2ndLAAge,get2ndLADOB,get2ndLAOccp,get2ndLASex,get2ndLASmoker,getOccpClass;
@synthesize getMOP,getTerm,getbasicHL,getPlanCode,getAdvance,requestSINo2;
@synthesize RiderController = _RiderController;
@synthesize Name2ndLA,NameLA,getLAIndexNo,NamePayor,getSex,getbasicTempHL,getSmoker,getBasicPlan, PDFCreator, riderCode;
@synthesize FS = _FS;
@synthesize HLController = _HLController;
id RiderCount;


- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF
{
    NSLog(@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath);
    
    
	//BrowserViewController *controller = [[BrowserViewController alloc] init];
	BrowserViewController *controller = [[BrowserViewController alloc] initWithFilePath:htmlToPDF.PDFpath PDSorSI:PDSorSI];
	if([PDSorSI isEqualToString:@"PDS"]){
		controller.title = [NSString stringWithFormat:@"PDS_%@.pdf",self.getSINo];

	}	
	else{
		controller.title = [NSString stringWithFormat:@"%@.pdf",self.getSINo];
	}
	
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    //#if EXPERIEMENTAL_ORIENTATION_SUPPORT
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0, ^){
    UINavigationController *container = [[UINavigationController alloc] init];
    [container setNavigationBarHidden:YES animated:NO];
    [container setViewControllers:[NSArray arrayWithObject:navController] animated:NO];
    
    //container.view
    //CDVViewController *browserController = [CDVViewController new];
    //browserController.wwwFolderName = @"www";
    //browserController.startPage = @"Page1.html";//(NSString *)objectHTML;
    //browserController.view.frame = CGRectMake(100, 0, 500, 500);
    //[container.view addSubview:browserController.view];
    
    
    
    //self.window.rootViewController = container;
    //#else
    //self.window.rootViewController = navController;
    //#endif
	
	[spinner_SI stopAnimating ];
	[self.view setUserInteractionEnabled:YES];
	[_FS Reset];
	
	UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
	[v removeFromSuperview];
	v = Nil;
	
	if (previousPath == Nil) {
		previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
	}
	
	[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	selectedPath = previousPath;
	spinner_SI = Nil;
	
    [self presentModalViewController:container animated:YES];
    container = Nil;
	controller= Nil;
}

- (void)HTMLtoPDFDidFail:(NDHTMLtoPDF*)htmlToPDF
{
    NSLog(@"HTMLtoPDF did fail (%@)", htmlToPDF);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resignFirstResponder];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]]];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    //--for table view
    [self.view addSubview:myTableView];
    [self.view addSubview:RightView];
    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]];
    
//    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Life Assured", @"   2nd Life Assured", @"   Payor", @"Basic Plan", @"Rider", @"Premium", nil ];
//    SelectedRow = [[NSMutableArray alloc] initWithObjects:@"4", @"5", nil ];
     ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Life Assured", @"   2nd Life Assured", @"   Payor", @"Basic Plan", @"Health Loading", nil ];
    
    PlanEmpty = YES;
    added = NO;
    saved = YES;
    payorSaved = YES;
    
    myTableView.rowHeight = 44;
    [myTableView reloadData];
    
    if (_LAController == nil) {
        self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
        _LAController.delegate = self;
    }
    self.LAController.requestSINo = [self.requestSINo description];
    [self addChildViewController:self.LAController];
    [self.RightView addSubview:self.LAController.view];
    blocked = NO;
    selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewRowAnimationNone];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    CGRect rectApp = [[UIScreen mainScreen] applicationFrame];
    rectApp.origin = CGPointZero;
    
    self.view.superview.autoresizingMask =  UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.superview.autoresizesSubviews = YES;
    self.RightView.superview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.RightView.superview.autoresizesSubviews = YES;
        
    self.view.autoresizesSubviews = YES;
    
    
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceUp) {
        
        NSLog(@"%d",[[UIDevice currentDevice] orientation]);
        NSLog(@"left!");
        self.myTableView.frame = CGRectMake(0, 0, 220, 748);
        self.RightView.frame = CGRectMake(223-10, 0, 801, 748);
        
        [self hideSeparatorLine];
        [self.view bringSubviewToFront:myTableView];
        
        int y = myTableView.frame.size.height;
        UIView *topping = [[UIView alloc] initWithFrame:CGRectMake(0, y, 220, 748-y)];
        [self.view addSubview:topping];
        [self.view bringSubviewToFront:topping];
        [topping setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]]];
    }
    else if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
        
        NSLog(@"right!");
        self.myTableView.frame = CGRectMake(0, 0, 220, 748);
        self.RightView.frame = CGRectMake(223, 0, 801, 748);
        [self hideSeparatorLine];
    }
	 */
	self.view.autoresizesSubviews = NO;
	
    self.myTableView.frame = CGRectMake(0, 0, 220, 748);
    [self hideSeparatorLine];
    self.RightView.frame = CGRectMake(223, 0, 801, 748);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)Reset
{
    if ([self.requestSINo isEqualToString:self.requestSINo2] || (self.requestSINo == NULL && self.requestSINo2 == NULL) ) {
        
        PlanEmpty = YES;
        added = NO;
//        [SelectedRow addObject:@"4" ];
//        [SelectedRow addObject:@"5" ];
        [ListOfSubMenu removeObject:@"Rider"];
        [ListOfSubMenu removeObject:@"Premium"];
        
        [self RemovePDS];
        
        [self clearDataLA];
        [self clearDataPayor];	
        [self clearData2ndLA];
        [self clearDataBasic];
        
        [self hideSeparatorLine];
        [self.myTableView reloadData];
        
        self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
        _LAController.delegate = self;
        [self addChildViewController:self.LAController];
        [self.RightView addSubview:self.LAController.view];
        blocked = NO;
        selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
        previousPath = selectedPath;
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewRowAnimationNone];
		

		AppDelegate *appDel= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
		appDel.MhiMessage = Nil;
        appDel = Nil;
    }
    else {
        requestSINo2 = self.requestSINo;
    }
}

-(void)toogleView
{
    if (PlanEmpty && added)
    {
        [ListOfSubMenu removeObject:@"Rider"];
        [ListOfSubMenu removeObject:@"Premium"];
//        [SelectedRow addObject:@"4"];
//        [SelectedRow addObject:@"5"];
        
    }
    else if (!PlanEmpty && !added) {
        [ListOfSubMenu addObject:@"Rider"];
        [ListOfSubMenu addObject:@"Premium"];
        [ListOfSubMenu addObject:@"Quotation"];
        [ListOfSubMenu addObject:@"Product Disclosure Sheet"];
        [ListOfSubMenu addObject:@"   English"];
        [ListOfSubMenu addObject:@"   Malay"];
//        [SelectedRow removeObject:@"4"];
//        [SelectedRow removeObject:@"5"];
        
        added = YES;
        
        
        

    }
    [self CalculateRider];
    [self hideSeparatorLine];
    
    [self.myTableView reloadData];
}

-(void)hideSeparatorLine
{
    CGRect frame = myTableView.frame;
    frame.size.height = MIN(44 * [ListOfSubMenu count], 748);
    myTableView.frame = frame;
}


#pragma mark - action

-(void)select2ndLA
{
    NSLog(@"select 2ndLA:: age:%d, occp:%@, SI:%@",getAge,getOccpCode,getSINo);
    if (getAge >= 18 && getAge <=70 && ![getOccpCode isEqualToString:@"(null)"])
    {
        if (_SecondLAController == nil) {
            self.SecondLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
            _SecondLAController.delegate = self;
        }
        self.SecondLAController.requestLAIndexNo = getLAIndexNo;
        self.SecondLAController.requestCommDate = getCommDate;
        self.SecondLAController.requestSINo = getSINo;
        [self addChildViewController:self.SecondLAController];
        [self.RightView addSubview:self.SecondLAController.view];
        
        previousPath = selectedPath;
        blocked = NO;
    }
    else if (getAge > 70) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 70 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        blocked = YES;
    }
    else if (getAge < 16 && getOccpCode.length != 0 && ![getOccpCode isEqualToString:@"(null)"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Life Assured" message:@"Life Assured is less than 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        blocked = YES;
    }
    else if (getOccpCode.length == 0 || [getOccpCode isEqualToString:@"(null)"]) {
        NSLog(@"no where!");
        blocked = YES;
    }
    else {
        NSLog(@"age 16-17");
        if (getSINo.length != 0 && ![getSINo isEqualToString:@"(null)"]) {
            NSLog(@"with SI");
            
            [self checkingPayor];
            if (payorSINo.length != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                blocked = YES;
            }
            else {
                
                self.SecondLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
                _SecondLAController.delegate = self;
                self.SecondLAController.requestLAIndexNo = getLAIndexNo;
                self.SecondLAController.requestCommDate = getCommDate;
                self.SecondLAController.requestSINo = getSINo;
                [self addChildViewController:self.SecondLAController];
                [self.RightView addSubview:self.SecondLAController.view];
                
                previousPath = selectedPath;
                blocked = NO;
            }
        }
        else {
            if (getPayorIndexNo != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                blocked = YES;
            }
            else {
                if (_SecondLAController == nil) {
                    self.SecondLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
                    _SecondLAController.delegate = self;
                }
                self.SecondLAController.requestLAIndexNo = getLAIndexNo;
                self.SecondLAController.requestCommDate = getCommDate;
                self.SecondLAController.requestSINo = getSINo;
                [self addChildViewController:self.SecondLAController];
                [self.RightView addSubview:self.SecondLAController.view];
                
                previousPath = selectedPath;
                blocked = NO;
            }
        }
    }
}

-(void)selectPayor
{
    NSLog(@"select payor:: age:%d, occp:%@, SI:%@",getAge,getOccpCode,getSINo);
    if (getAge >= 18 && ![getOccpCode isEqualToString:@"(null)"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Life Assured's age must not greater or equal to 18 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        blocked = YES;
    }
    else if (getAge < 16 && getOccpCode.length != 0) {
        
        if ([getSINo isEqualToString:@"(null)"] || getSINo.length == 0) {
            
            if (_PayorController == nil) {
                self.PayorController = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
                _PayorController.delegate = self;
            }
            self.PayorController.requestLAIndexNo = getLAIndexNo;
            self.PayorController.requestLAAge = getAge;
            self.PayorController.requestCommDate = getCommDate;
            self.PayorController.requestSINo = getSINo;
            [self addChildViewController:self.PayorController];
            [self.RightView addSubview:self.PayorController.view];
        }
        else {
            
            self.PayorController = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
            _PayorController.delegate = self;
            
            self.PayorController.requestLAIndexNo = getLAIndexNo;
            self.PayorController.requestLAAge = getAge;
            self.PayorController.requestCommDate = getCommDate;
            self.PayorController.requestSINo = getSINo;
            [self addChildViewController:self.PayorController];
            [self.RightView addSubview:self.PayorController.view];
        }
        previousPath = selectedPath;
        blocked = NO;
    }
    else if (getOccpCode.length == 0 || [getOccpCode isEqualToString:@"(null)"]) {
        NSLog(@"no where!");
        blocked = YES;
    }
    else {
        NSLog(@"age 16-17");
        if (getSINo.length != 0 && ![getSINo isEqualToString:@"(null)"]) {
            
            NSLog(@"with SI");
            [self checking2ndLA];
            if (CustCode2.length != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                blocked = YES;
            }
            else {
                
                self.PayorController = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
                _PayorController.delegate = self;
                
                self.PayorController.requestLAIndexNo = getLAIndexNo;
                self.PayorController.requestLAAge = getAge;
                self.PayorController.requestCommDate = getCommDate;
                self.PayorController.requestSINo = getSINo;
                [self addChildViewController:self.PayorController];
                [self.RightView addSubview:self.PayorController.view];
                
                previousPath = selectedPath;
                blocked = NO;
            }
        }
        else {
            if (get2ndLAIndexNo != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                blocked = YES;
            }
            else {
                if (_PayorController == nil) {
                    self.PayorController = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
                    _PayorController.delegate = self;
                }
                self.PayorController.requestLAIndexNo = getLAIndexNo;
                self.PayorController.requestLAAge = getAge;
                self.PayorController.requestCommDate = getCommDate;
                self.PayorController.requestSINo = getSINo;
                [self addChildViewController:self.PayorController];
                [self.RightView addSubview:self.PayorController.view];
                
                previousPath = selectedPath;
                blocked = NO;
            }
        }
    }
}

-(void)selectBasicPlan
{
    NSLog(@"select basic:: age:%d, occp:%@, SI:%@",getAge,getOccpCode,getSINo);
    if (getSINo.length != 0 && ![getSINo isEqualToString:@"(null)"]) {
        NSLog(@"with SI");
        
        [self checkingPayor];
        if (getAge < 10 && payorSINo.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
        }
        else if (getAge > 70) {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 70 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
        }
        else {
            
            self.BasicController = [self.storyboard instantiateViewControllerWithIdentifier:@"BasicPlanView"];
            _BasicController.delegate = self;
            
            self.BasicController.requestAge = getAge;
            self.BasicController.requestOccpCode = getOccpCode;
            self.BasicController.requestOccpClass = getOccpClass;
            self.BasicController.requestIDPay = getIdPay;
            self.BasicController.requestIDProf = getIdProf;
            
            self.BasicController.requestIndexPay = getPayorIndexNo;
            self.BasicController.requestSmokerPay = getPaySmoker;
            self.BasicController.requestSexPay = getPaySex;
            self.BasicController.requestDOBPay = getPayDOB;
            self.BasicController.requestAgePay = getPayAge;
            self.BasicController.requestOccpPay = getPayOccp;
            
            self.BasicController.requestIndex2ndLA = get2ndLAIndexNo;
            self.BasicController.requestSmoker2ndLA = get2ndLASmoker;
            self.BasicController.requestSex2ndLA = get2ndLASex;
            self.BasicController.requestDOB2ndLA = get2ndLADOB;
            self.BasicController.requestAge2ndLA = get2ndLAAge;
            self.BasicController.requestOccp2ndLA = get2ndLAOccp;
            
            self.BasicController.requestSINo = getSINo;
            
            [self addChildViewController:self.BasicController];
            [self.RightView addSubview:self.BasicController.view];
            
            previousPath = selectedPath;
            blocked = NO;
        }
    }
    else if (getOccpCode != 0 && getSINo.length == 0) {
        NSLog(@"no SI");
        
        if (getAge < 10 && getPayorIndexNo == 0) {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
        }
        else {
            
            self.BasicController = [self.storyboard instantiateViewControllerWithIdentifier:@"BasicPlanView"];
            _BasicController.delegate = self;
            
            self.BasicController.requestAge = getAge;
            self.BasicController.requestOccpCode = getOccpCode;
            self.BasicController.requestOccpClass = getOccpClass;
            self.BasicController.requestIDPay = getIdPay;
            self.BasicController.requestIDProf = getIdProf;
            
            self.BasicController.requestIndexPay = getPayorIndexNo;
            self.BasicController.requestSmokerPay = getPaySmoker;
            self.BasicController.requestSexPay = getPaySex;
            self.BasicController.requestDOBPay = getPayDOB;
            self.BasicController.requestAgePay = getPayAge;
            self.BasicController.requestOccpPay = getPayOccp;
            
            self.BasicController.requestIndex2ndLA = get2ndLAIndexNo;
            self.BasicController.requestSmoker2ndLA = get2ndLASmoker;
            self.BasicController.requestSex2ndLA = get2ndLASex;
            self.BasicController.requestDOB2ndLA = get2ndLADOB;
            self.BasicController.requestAge2ndLA = get2ndLAAge;
            self.BasicController.requestOccp2ndLA = get2ndLAOccp;
            
            self.BasicController.requestSINo = getSINo;
            
            [self addChildViewController:self.BasicController];
            [self.RightView addSubview:self.BasicController.view];
            
            previousPath = selectedPath;
            blocked = NO;
        }
    }
    else {
        NSLog(@"no where!");
        blocked = YES;
    }
}

-(void)calculatedPrem
{
    if (getSINo.length != 0 && getAge <= 70) {
        
        [self checkingPayor];
        if (getAge < 10 && payorSINo.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
        }
        else {
            
			if (_FS == Nil) {
				self.FS = [FSVerticalTabBarController alloc];
				_FS.delegate = self;
			}
			
			spinner_SI = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			spinner_SI.center = CGPointMake(400, 350);
			
			[self.view addSubview:spinner_SI];
			UILabel *spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 370, 120, 40) ];
			spinnerLabel.text  = @" Please Wait...";
			spinnerLabel.backgroundColor = [UIColor blackColor];
			spinnerLabel.opaque = YES;
			spinnerLabel.textColor = [UIColor whiteColor];
			[self.view addSubview:spinnerLabel];
			[self.view setUserInteractionEnabled:NO];
			[spinner_SI startAnimating];
			
			
			[_FS Test ];
			
			[self RemovePDS];
            [ListOfSubMenu addObject:@"Quotation"];
            [ListOfSubMenu addObject:@"Product Disclosure Sheet"];
            [ListOfSubMenu addObject:@"   English"];
            [ListOfSubMenu addObject:@"   Malay"];
            PremiumViewController *premView = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
            premView.requestAge = getAge;
            premView.requestOccpClass = getOccpClass;
            premView.requestOccpCode = getOccpCode;
			
            premView.requestSINo = getSINo;
            premView.requestMOP = getMOP;
            premView.requestTerm = getTerm;
            premView.requestBasicSA = getbasicSA;
            premView.requestBasicHL = getbasicHL;
            premView.requestBasicTempHL = getbasicTempHL;
            premView.requestPlanCode = getPlanCode;
            premView.requestBasicPlan = getBasicPlan;
			[self addChildViewController:premView];
			
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
				
				if ([RiderCount intValue ] > 10) {
					sleep(5);
				}
				else{
					sleep(1);
				}

				
				dispatch_async(dispatch_get_main_queue(), ^{
					
					[self.RightView addSubview:premView.view];
					previousPath = selectedPath;
					blocked = NO;
					[self hideSeparatorLine];
					
					//[myTableView reloadData];
					[spinner_SI stopAnimating ];
					[self.view setUserInteractionEnabled:YES];
					[_FS Reset];
					UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
					[v removeFromSuperview];
					v = Nil;
					spinner_SI = nil;
				});
			});
			
			/*
            [self RemovePDS];
            [ListOfSubMenu addObject:@"Quotation"];
            [ListOfSubMenu addObject:@"Product Disclosure Sheet"];
            [ListOfSubMenu addObject:@"   English"];
            [ListOfSubMenu addObject:@"   Malay"];
            PremiumViewController *premView = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
            premView.requestAge = getAge;
            premView.requestOccpClass = getOccpClass;
            premView.requestOccpCode = getOccpCode;
             
            premView.requestSINo = getSINo;
            premView.requestMOP = getMOP;
            premView.requestTerm = getTerm;
            premView.requestBasicSA = getbasicSA;
            premView.requestBasicHL = getbasicHL;
            premView.requestBasicTempHL = getbasicTempHL;
            premView.requestPlanCode = getPlanCode;
            premView.requestBasicPlan = getBasicPlan;
            [self addChildViewController:premView];
            [self.RightView addSubview:premView.view];
            
            previousPath = selectedPath;
            blocked = NO;
            [self hideSeparatorLine]; 
			 */
        }
    }
    else if (getAge > 70) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 70 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        blocked = YES;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"No record selected!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        blocked = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001 && buttonIndex == 0)
    {
        saved = YES;
        _SecondLAController = nil;
        
        [self RemovePDS];
        
        [self selectBasicPlan];
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    else if (alertView.tag == 1001 && buttonIndex == 1)
    {
        saved = NO;
        blocked = YES;
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    else if (alertView.tag == 2001 && buttonIndex == 0)
    {
        payorSaved = YES;
        _PayorController = nil;
        
        [self RemovePDS];
        [self selectBasicPlan];
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    else if (alertView.tag == 2001 && buttonIndex == 1)
    {
        payorSaved = NO;
        blocked = YES;
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    else if (alertView.tag == 1002 && buttonIndex == 0)
    {
        saved = YES;
        
        
        [self RemovePDS];
        
        self.RiderController = [self.storyboard instantiateViewControllerWithIdentifier:@"RiderView"];
        _RiderController.delegate = self;
        self.RiderController.requestAge = getAge;
        self.RiderController.requestSex = getSex;
        self.RiderController.requestOccpCode = getOccpCode;
        self.RiderController.requestOccpClass = getOccpClass;
        
        self.RiderController.requestSINo = getSINo;
        self.RiderController.requestPlanCode = getPlanCode;
        self.RiderController.requestCoverTerm = getTerm;
        self.RiderController.requestBasicSA = getbasicSA;
        self.RiderController.requestBasicHL = getbasicHL;
        self.RiderController.requestBasicTempHL = getbasicTempHL;
        self.RiderController.requestMOP = getMOP;
        self.RiderController.requestAdvance = getAdvance;
        
        [self addChildViewController:self.RiderController];
        [self.RightView addSubview:self.RiderController.view];
        
        previousPath = selectedPath;
        blocked = NO;
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    else if (alertView.tag == 1002 && buttonIndex == 1)
    {
        saved = NO;
        blocked = YES;
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    else if (alertView.tag == 2002 && buttonIndex == 0)
    {
        payorSaved = YES;
        
        
        [self RemovePDS];
        
        self.RiderController = [self.storyboard instantiateViewControllerWithIdentifier:@"RiderView"];
        _RiderController.delegate = self;
        self.RiderController.requestAge = getAge;
        self.RiderController.requestSex = getSex;
        self.RiderController.requestOccpCode = getOccpCode;
        self.RiderController.requestOccpClass = getOccpClass;
        
        self.RiderController.requestSINo = getSINo;
        self.RiderController.requestPlanCode = getPlanCode;
        self.RiderController.requestCoverTerm = getTerm;
        self.RiderController.requestBasicSA = getbasicSA;
        self.RiderController.requestBasicHL = getbasicHL;
        self.RiderController.requestBasicTempHL = getbasicTempHL;
        self.RiderController.requestMOP = getMOP;
        self.RiderController.requestAdvance = getAdvance;
        
        [self addChildViewController:self.RiderController];
        [self.RightView addSubview:self.RiderController.view];
        
        previousPath = selectedPath;
        blocked = NO;
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    else if (alertView.tag == 2002 && buttonIndex == 1)
    {
        payorSaved = NO;
        blocked = YES;
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
}

#pragma mark - db

-(void)checkingPayor
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"PY\" AND a.Sequence=1",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                payorSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                payorCustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NamePayor = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSLog(@"PayorSI:%@",payorSINo);
            }
            else {
                NSLog(@"error access checkingPayor");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checking2ndLA
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=2",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CustCode2 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                Name2ndLA = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                clientID2 = sqlite3_column_int(statement, 9);
               
            } else {
                NSLog(@"error access checking2ndLA");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)CalculateRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select count(*) from trad_rider_details where sino = '%@' ", getSINo ];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                RiderCount = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                
            } else {
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getLAName
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName FROM prospect_profile WHERE IndexNo= \"%d\"",getLAIndexNo];
        
//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NameLA = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            
            } else {
                NSLog(@"error access getLAName");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)get2ndLAName
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName FROM prospect_profile WHERE IndexNo= \"%d\"",get2ndLAIndexNo];
        
//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                Name2ndLA = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSLog(@"name2ndLA:%@",Name2ndLA);
            } else {
                NSLog(@"error access get2ndLAName");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getPayorName
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName FROM prospect_profile WHERE IndexNo= \"%d\"",getPayorIndexNo];
        
//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NamePayor = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSLog(@"namePayor:%@",NamePayor);
            } else {
                NSLog(@"error access getPayorName");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
    return ListOfSubMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //--text label
    
    /*
    if (PlanEmpty) {
        if (indexPath.row == 4||indexPath.row == 5||indexPath.row == 6) {
            cell.textLabel.text = @"";
        }
        else {
            cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
        }
    }
    else {
        if (indexPath.row == 4) {
            cell.textLabel.text = [[ListOfSubMenu objectAtIndex:indexPath.row] stringByAppendingFormat:@"(%@)", RiderCount ];
        }
        else {
            cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
        }
    } */
    
    if (PlanEmpty) {
        
        cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
    }
    else {
        if (indexPath.row == 5) {
            cell.textLabel.text = [[ListOfSubMenu objectAtIndex:indexPath.row] stringByAppendingFormat:@"(%@)", RiderCount ];
        }
        else {
            cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
        }
    }
    
    //--

    
    //--detail text label

    if (indexPath.row == 0) {
        if (NameLA.length != 0) {
            NSString *str = [[NSString alloc] initWithFormat:@"%@",NameLA];
            str = [str substringToIndex:MIN(20, [str length])];
            cell.detailTextLabel.text = str;
        }
        else {
            cell.detailTextLabel.text = @"";
        }
    }
    else if (indexPath.row == 1) {
        if (Name2ndLA.length != 0) {
            NSString *str = [[NSString alloc] initWithFormat:@"%@",Name2ndLA];
            str = [str substringToIndex:MIN(20, [str length])];
            cell.detailTextLabel.text = str;
        }
        else {
            cell.detailTextLabel.text = @"";
        }
    }
    else if (indexPath.row == 2) {
        if (NamePayor.length != 0) {
            NSString *str = [[NSString alloc] initWithFormat:@"%@",NamePayor];
            str = [str substringToIndex:MIN(20, [str length])];
            cell.detailTextLabel.text = str;
        }
        else {
            cell.detailTextLabel.text = @"";
        }
    }
    else {
        cell.detailTextLabel.text = @"";
    }
     
    //--
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:18];
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:12];
    cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
    
	

	if(self.myTableView.frame.size.height > 400.00 && indexPath.row == 8 ){
			cell.textLabel.backgroundColor = [UIColor grayColor];
			cell.detailTextLabel.backgroundColor = [UIColor grayColor];
			cell.contentView.backgroundColor = [UIColor grayColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	else if(self.myTableView.frame.size.height < 400.00 && indexPath.row == 3 ){
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.detailTextLabel.backgroundColor = [UIColor clearColor ];
		cell.contentView.backgroundColor = [UIColor clearColor];
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	else{
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
    
    return cell;
}


#pragma mark - table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPath = indexPath;
    if (indexPath.row == 0)     //life assured
    {
        NSLog(@"select LA:: age:%d, occp:%@, SI:%@",getAge,getOccpCode,getSINo);
        
        if (getSINo.length != 0) {
            NSLog(@"with SI");
            
            self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
            _LAController.delegate = self;
            self.LAController.requestSINo = getSINo;
            [self addChildViewController:self.LAController];
            [self.RightView addSubview:self.LAController.view];
        }
        else {
            NSLog(@"no SI");
            self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
            _LAController.delegate = self;
            self.LAController.requestIndexNo = getLAIndexNo;
            self.LAController.requestLastIDPay = getIdPay;
            self.LAController.requestLastIDProf = getIdProf;
            self.LAController.requestCommDate = getCommDate;
            self.LAController.requestSex = getSex;
            self.LAController.requestSmoker = getSmoker;
            [self addChildViewController:self.LAController];
            [self.RightView addSubview:self.LAController.view];
        }
        previousPath = selectedPath;
        blocked = NO;
    }
    
    else if (indexPath.row == 1)    //2nd LA
    {
		if ([getOccpCode isEqualToString:@"OCC01975"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
			
		}
		else if ([getBasicPlan isEqualToString:@"HLACP"] && getAge > 63 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 63 for this product."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			alert = Nil;
		}
		else{
			//[self RemovePDS];
			[self select2ndLA];
			[self hideSeparatorLine];
			[myTableView reloadData];
		}
        
        
    }
    
    else if (indexPath.row == 2)    //Payor
    {
		if ([getOccpCode isEqualToString:@"OCC01975"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
			
		}
		else if ([getBasicPlan isEqualToString:@"HLACP"] && getAge > 63 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 63 for this product."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			alert = Nil;
		}
		else{
			//[self RemovePDS];
			[self selectPayor];
			[self hideSeparatorLine];
			[myTableView reloadData];
		}
        
        
    }
    
    else if (indexPath.row == 3)    //basic plan
    {
		if ([getOccpCode isEqualToString:@"OCC01975"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
			
		}
		else if ([getBasicPlan isEqualToString:@"HLACP"] && getAge > 63 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 63 for this product."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			alert = Nil;
		}
		else{
			if (!saved) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"2nd Life Assured has not been saved yet.Leave this page without saving?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
				[alert setTag:1001];
				[alert show];
			}
			else if (!payorSaved) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Payor has not been saved yet.Leave this page without saving?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
				[alert setTag:2001];
				[alert show];
			}
			else {
				
				//[self RemovePDS];
				[self selectBasicPlan];
				[self hideSeparatorLine];
				[myTableView reloadData];
			}
		}
        
    }
    
    else if (indexPath.row == 4)        //Health Loading
    {
		if ([getOccpCode isEqualToString:@"OCC01975"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
			
		}
		else if ([getBasicPlan isEqualToString:@"HLACP"] && getAge > 63 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 63 for this product."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			alert = Nil;
		}
		else{
			if (getSINo.length != 0 && ![getSINo isEqualToString:@"(null)"]) {
				self.HLController = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthLoadView"];
				_HLController.delegate = self;
				self.HLController.ageClient = getAge;
				self.HLController.SINo = getSINo;
				self.HLController.planChoose = getBasicPlan;
				
				[self addChildViewController:self.HLController];
				[self.RightView addSubview:self.HLController.view];
				
				previousPath = selectedPath;
				blocked = NO;
				[self hideSeparatorLine];
				[myTableView reloadData];
			}
			else {
				NSLog(@"no where!");
				blocked = YES;
			}
		}
        
    }
    
    else if (indexPath.row == 5)    //rider
    {
		if ([getOccpCode isEqualToString:@"OCC01975"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
			
		}
		else if ([getBasicPlan isEqualToString:@"HLACP"] && getAge > 63 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 63 for this product."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			alert = Nil;
		}
		else{
			[self checkingPayor];
			if (getAge > 70) {
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 70 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				[alert show];
				blocked = YES;
			}
			else if (getAge < 10 && payorSINo.length == 0) {
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				[alert show];
				blocked = YES;
			}
			else if (!saved) {
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"2nd Life Assured has not been saved yet.Leave this page without saving?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
				[alert setTag:1002];
				[alert show];
			}
			else if (!payorSaved) {		
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Payor has not been saved yet.Leave this page without saving?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
				[alert setTag:2002];
				[alert show];
			}
			else {
				
				
				//[self RemovePDS];
				
				self.RiderController = [self.storyboard instantiateViewControllerWithIdentifier:@"RiderView"];
				_RiderController.delegate = self;
				self.RiderController.requestAge = getAge;
				self.RiderController.requestSex = getSex;
				self.RiderController.requestOccpCode = getOccpCode;
				self.RiderController.requestOccpClass = getOccpClass;
				
				self.RiderController.requestSINo = getSINo;
				self.RiderController.requestPlanCode = getPlanCode;
				self.RiderController.requestPlanChoose = getBasicPlan;
				self.RiderController.requestCoverTerm = getTerm;
				self.RiderController.requestBasicSA = getbasicSA;
				self.RiderController.requestBasicHL = getbasicHL;
				self.RiderController.requestBasicTempHL = getbasicTempHL;
				self.RiderController.requestMOP = getMOP;
				self.RiderController.requestAdvance = getAdvance;
				
				[self addChildViewController:self.RiderController];
				[self.RightView addSubview:self.RiderController.view];
				
				previousPath = selectedPath;
				blocked = NO;
				[self hideSeparatorLine];
				[myTableView reloadData];
			}
		}
		
        
        
    }
    
    else if (indexPath.row == 6)    //premium
    {
		if ([getOccpCode isEqualToString:@"OCC01975"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
			
		}
		else if ([getBasicPlan isEqualToString:@"HLACP"] && getAge > 63 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 63 for this product."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			alert = Nil;
		}
		else{
			
				[self calculatedPrem];
				[myTableView reloadData];
		}

        
        

    }
    else if (indexPath.row == 7)    //quotation
    {
		PDSorSI = @"SI";

		if ([getOccpCode isEqualToString:@"OCC01975"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
			if (previousPath == Nil) {
				previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
			}
			
			[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			
		}
		else if ([getBasicPlan isEqualToString:@"HLACP"] && getAge > 63 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 63 for this product."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			alert = Nil;
			if (previousPath == Nil) {
				previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
			}
			
			[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		}
        else{
			AppDelegate *appDel= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
			
			NSString *RevisedSumAssured = appDel.MhiMessage;
			
			if (![appDel.MhiMessage isEqualToString:@""] && appDel.MhiMessage != NULL  ) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Guaranteed Yearly Income will be increase to RM%@ in accordance to MHI Guideline",RevisedSumAssured]
															   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				[alert show];
				alert = Nil;
			}
			
			RevisedSumAssured = Nil;
			appDel = Nil;
			//appDel.MhiMessage = Nil;
			/*
			 sqlite3_stmt *statement;
			 BOOL cont = FALSE;
			 if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
			 {
			 // NSString *querySQL = [NSString stringWithFormat:@"SELECT * from SI_Store_Premium "];
			 
			 NSString *QuerySQL = [ NSString stringWithFormat:@"select \"PolicyTerm\", \"BasicSA\", \"premiumPaymentOption\", \"CashDividend\",  "
			 "\"YearlyIncome\", \"AdvanceYearlyIncome\", \"HL1KSA\",  \"sex\" from Trad_Details as A, "
			 "Clt_Profile as B, trad_LaPayor as C where A.Sino = C.Sino AND C.custCode = B.custcode AND "
			 "A.sino = \"%@\" AND \"seq\" = 1 ", getSINo];
			 
			 if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
			 {
			 if (sqlite3_step(statement) == SQLITE_ROW)
			 {
			 cont = TRUE;
			 
			 } else {
			 cont = FALSE;
			 NSLog(@"error access SI_Store_Premium");
			 }
			 sqlite3_finalize(statement);
			 }
			 sqlite3_close(contactDB);
			 }
			 
			 if (cont == TRUE) {
			 
			 UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			 spinner.center = CGPointMake(500, 350);
			 
			 spinner.hidesWhenStopped = YES;
			 [self.view addSubview:spinner];
			 UILabel *spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(460, 370, 110, 50) ];
			 spinnerLabel.text  = @"Please Wait...";
			 spinnerLabel.backgroundColor = [UIColor clearColor];
			 spinnerLabel.opaque = YES;
			 spinnerLabel.textColor = [UIColor whiteColor];
			 [self.view addSubview:spinnerLabel];
			 [spinner startAnimating];
			 
			 //dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
			 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
			 //dispatch_async(downloadQueue, ^{
			 
			 ReportViewController *ReportPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Report"];
			 ReportPage.SINo = getSINo;
			 [self presentViewController:ReportPage animated:NO completion:^{
			 
			 [ReportPage dismissViewControllerAnimated:NO completion:^{
			 
			 //ReportViewController *reportVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Browser"];
			 //[self presentViewController:reportVC animated:YES completion:Nil];
			 
			 
			 }];
			 
			 }];
			 
			 dispatch_async(dispatch_get_main_queue(), ^{
			 [spinner stopAnimating];
			 spinnerLabel.text = @"";
			 NSLog(@"stop");
			 
			 BrowserViewController *controller = [[BrowserViewController alloc] init];
			 controller.title = @"Quotation";
			 
			 UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
			 UINavigationController *container = [[UINavigationController alloc] init];
			 [container setNavigationBarHidden:YES animated:NO];
			 [container setViewControllers:[NSArray arrayWithObject:navController] animated:NO];
			 
			 [self presentModalViewController:container animated:YES];
			 
			 UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
			 [v removeFromSuperview];
			 });
			 
			 
			 });
			 //dispatch_release(downloadQueue);
			 }
			 else {
			 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
			 message:@"SI has been deleted" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
			 [alert show];
			 }
			 */
			
			
			sqlite3_stmt *statement;
			BOOL cont = FALSE;
			if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
			{
				// NSString *querySQL = [NSString stringWithFormat:@"SELECT * from SI_Store_Premium "];
				
				NSString *QuerySQL = [ NSString stringWithFormat:@"select \"PolicyTerm\", \"BasicSA\", \"premiumPaymentOption\", \"CashDividend\",  "
									  "\"YearlyIncome\", \"AdvanceYearlyIncome\", \"HL1KSA\",  \"sex\" from Trad_Details as A, "
									  "Clt_Profile as B, trad_LaPayor as C where A.Sino = C.Sino AND C.custCode = B.custcode AND "
									  "A.sino = \"%@\" AND \"seq\" = 1 ", getSINo];
				
				
				
				if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
				{
					if (sqlite3_step(statement) == SQLITE_ROW)
					{
						cont = TRUE;
						
					} else {
						cont = FALSE;
						NSLog(@"error access SI_Store_Premium");
					}
					sqlite3_finalize(statement);
				}
				sqlite3_close(contactDB);
				
				
			}
			
			if (_FS == Nil) {
				self.FS = [FSVerticalTabBarController alloc];
				_FS.delegate = self;
			}
			
			
			if (cont == TRUE) {
				/*
				PremiumViewController *premView = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
				premView.requestAge = getAge;
				premView.requestOccpClass = getOccpClass;
				premView.requestOccpCode = getOccpCode;
				premView.requestSINo = getSINo;
				premView.requestMOP = getMOP;
				premView.requestTerm = getTerm;
				premView.requestBasicSA = getbasicSA;
				premView.requestBasicHL = getbasicHL;
				premView.requestBasicTempHL = getbasicTempHL;
				premView.requestPlanCode = getPlanCode;
				
				UIView *zzz = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) ];
				[zzz addSubview:premView.view];
				
				premView = Nil, zzz = Nil;
				*/
				
				//UIActivityIndicatorView *spinner_SI = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
				spinner_SI = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
				spinner_SI.center = CGPointMake(400, 350);
				
				//spinner_SI.hidesWhenStopped = YES;
				[self.view addSubview:spinner_SI];
				UILabel *spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 370, 120, 40) ];
				spinnerLabel.text  = @" Please Wait...";
				spinnerLabel.backgroundColor = [UIColor blackColor];
				spinnerLabel.opaque = YES;
				spinnerLabel.textColor = [UIColor whiteColor];
				[self.view addSubview:spinnerLabel];
				[self.view setUserInteractionEnabled:NO];
				[spinner_SI startAnimating];
				
				
				[_FS Test ];
				
				
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
					
					PremiumViewController *premView = [[PremiumViewController alloc] init ];
					premView.requestAge = getAge;
					premView.requestOccpClass = getOccpClass;
					premView.requestOccpCode = getOccpCode;
					premView.requestSINo = getSINo;
					premView.requestMOP = getMOP;
					premView.requestTerm = getTerm;
					premView.requestBasicSA = getbasicSA;
					premView.requestBasicHL = getbasicHL;
					premView.requestBasicTempHL = getbasicTempHL;
					premView.requestPlanCode = getPlanCode;
					[self presentViewController:premView animated:NO completion:Nil];
					[premView dismissViewControllerAnimated:NO completion:Nil];
					
					premView = Nil;
					
					ReportViewController *ReportPage;
					CashPromiseViewController *CPReportPage;
					
					if([getBasicPlan isEqualToString:@"HLACP" ]){
						CPReportPage = [[CashPromiseViewController alloc] init ];
						CPReportPage.SINo = getSINo;
						CPReportPage.PDSorSI = @"SI";
						[self presentViewController:CPReportPage animated:NO completion:Nil];
						
					}
					else if([getBasicPlan isEqualToString:@"HLAIB" ]){
						ReportPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Report"];
						ReportPage.SINo = getSINo;
						[self presentViewController:ReportPage animated:NO completion:Nil];
					}
					
					[self generateJSON_HLCP];
					[self copySIToDoc];
					
					dispatch_async(dispatch_get_main_queue(), ^{
						
						if([getBasicPlan isEqualToString:@"HLACP" ]){
							
							[CPReportPage dismissViewControllerAnimated:NO completion:Nil];
						}
						else if([getBasicPlan isEqualToString:@"HLAIB" ]){
							[ReportPage dismissViewControllerAnimated:NO completion:Nil];
						}
						

						NSString *path = [[NSBundle mainBundle] pathForResource:@"SI/Page1" ofType:@"html"];
						NSURL *pathURL = [NSURL fileURLWithPath:path];
						NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
						NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
						
						NSData* data = [NSData dataWithContentsOfURL:pathURL];
						[data writeToFile:[NSString stringWithFormat:@"%@/SI_Temp.html",documentsDirectory] atomically:YES];
						
						NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"SI_Temp.html"];
						//NSLog(@"delete HTML file Path: %@",HTMLPath);
						if([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {
							
							NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
							//NSLog(@"zzzz%@",targetURL);
							
							// Converting HTML to PDF
							//sleep(2);
							NSString *SIPDFName = [NSString stringWithFormat:@"%@.pdf",self.getSINo];
							self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:targetURL
																 pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
																   delegate:self
																   pageSize:kPaperSizeA4
											   //                   margins:UIEdgeInsetsMake(20, 5, 90, 5)];
																	margins:UIEdgeInsetsMake(0, 0, 0, 0)];

							
						}
						
						
						//[spinner_SI stopAnimating];
						//spinnerLabel.text = @"";

						
						
						/*
						BrowserViewController *controller = [[BrowserViewController alloc] init];
						controller.title = @"Quotation";
						
						
						if([getBasicPlan isEqualToString:@"HLACP" ]){
							
							controller.Module = 1;
						}
						else if([getBasicPlan isEqualToString:@"HLAIB" ]){
							controller.Module = 0;
						}
						
						
						UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
						UINavigationController *container = [[UINavigationController alloc] init];
						[container setNavigationBarHidden:YES animated:NO];
						[container setViewControllers:[NSArray arrayWithObject:navController] animated:NO];
						
						 
						//[self presentModalViewController:container animated:NO];
						
						navController = Nil;
						container = Nil;
						controller = Nil;
						*/
						//UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
						//[v removeFromSuperview];
						//v = Nil;
						

					});
					
					ReportPage = Nil;
					CPReportPage = Nil;
					
				});
				
				//spinner_SI = Nil;
				
				
			}
			else {
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
																message:@"SI has been deleted" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
				[alert show];
				alert = Nil;
				
			}
			
			
			statement = Nil;
		}
        
    }
    
    else if (indexPath.row == 9) {   //English PDS
		
		PDSorSI = @"PDS";
        
		if ([getOccpCode isEqualToString:@"OCC01975"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
			if (previousPath == Nil) {
				previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
			}
			
			[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			
		}
		else if ([getBasicPlan isEqualToString:@"HLACP"] && getAge > 63 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 63 for this product."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			alert = Nil;
			if (previousPath == Nil) {
				previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
			}
			
			[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		}
		else{
			
			AppDelegate *appDel= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
			
			NSString *RevisedSumAssured = appDel.MhiMessage;
			if (![appDel.MhiMessage isEqualToString:@""] && appDel.MhiMessage != NULL) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Guaranteed Yearly Income will be increase to RM%@ in accordance to MHI Guideline",RevisedSumAssured]
															   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				[alert show];
				alert = Nil;
			}
			
			RevisedSumAssured = Nil;
			appDel = Nil;
			//appDel.MhiMessage = Nil;
			
			/*
			PremiumViewController *premView = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
			premView.requestAge = getAge;
			premView.requestOccpClass = getOccpClass;
			premView.requestOccpCode = getOccpCode;
			premView.requestSINo = getSINo;
			premView.requestMOP = getMOP;
			premView.requestTerm = getTerm;
			premView.requestBasicSA = getbasicSA;
			premView.requestBasicHL = getbasicHL;
			premView.requestBasicTempHL = getbasicTempHL;
			premView.requestPlanCode = getPlanCode;
			
			UIView *zzz = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) ];
			[zzz addSubview:premView.view];
			
			premView = Nil, zzz= Nil;
			*/

			spinner_SI = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			spinner_SI.center = CGPointMake(400, 350);
			
			spinner_SI.hidesWhenStopped = YES;
			[self.view addSubview:spinner_SI];
			UILabel *spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 370, 120, 40) ];
			spinnerLabel.text  = @" Please Wait...";
			spinnerLabel.backgroundColor = [UIColor blackColor];
			spinnerLabel.opaque = YES;
			spinnerLabel.textColor = [UIColor whiteColor];
			[self.view addSubview:spinnerLabel];
			[self.view setUserInteractionEnabled:NO];
			[spinner_SI startAnimating];
			
			if (_FS == Nil) {
				self.FS = [FSVerticalTabBarController alloc];
				_FS.delegate = self;
			}
			
			[_FS Test ];
			
			
			
			//dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
				//dispatch_async(downloadQueue, ^{
			
				PremiumViewController *premView = [[PremiumViewController alloc] init ];
				premView.requestAge = getAge;
				premView.requestOccpClass = getOccpClass;
				premView.requestOccpCode = getOccpCode;
				premView.requestSINo = getSINo;
				premView.requestMOP = getMOP;
				premView.requestTerm = getTerm;
				premView.requestBasicSA = getbasicSA;
				premView.requestBasicHL = getbasicHL;
				premView.requestBasicTempHL = getbasicTempHL;
				premView.requestPlanCode = getPlanCode;
				[self presentViewController:premView animated:NO completion:Nil];
				[premView dismissViewControllerAnimated:NO completion:Nil];
				
				premView = Nil;
				
				ReportViewController *ReportPage;
				CashPromiseViewController *CPReportPage;
				
				if([getBasicPlan isEqualToString:@"HLACP" ]){
					CPReportPage = [[CashPromiseViewController alloc] init ];
					CPReportPage.SINo = getSINo;
					CPReportPage.PDSorSI = @"PDS";
					[self presentViewController:CPReportPage animated:NO completion:Nil];
					
				}
				else if([getBasicPlan isEqualToString:@"HLAIB" ]){
					ReportPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Report"];
					ReportPage.SINo = getSINo;
					[self presentViewController:ReportPage animated:NO completion:Nil];
				}
				
				if([getBasicPlan isEqualToString:@"HLACP" ]){
					
					[CPReportPage dismissViewControllerAnimated:NO completion:Nil];
				}
				else if([getBasicPlan isEqualToString:@"HLAIB" ]){
					[ReportPage dismissViewControllerAnimated:NO completion:Nil];
				}
				
				ReportPage = Nil;
				CPReportPage = Nil;
				
				PDSViewController *PDSPage = [[PDSViewController alloc ] init ];
				PDSPage.SINo = getSINo;
				PDSPage.PDSLanguage = @"E";
				if([getBasicPlan isEqualToString:@"HLACP" ]){
					PDSPage.PDSPlanCode = @"HLACP";
				}
				else{
					PDSPage.PDSPlanCode = @"HLAIB";
				}
				
				[self presentViewController:PDSPage animated:NO completion:Nil];
				
				[self generateJSON_HLCP];
				[self copyPDSToDoc];
				
				
				dispatch_async(dispatch_get_main_queue(), ^{
					
					//[spinner stopAnimating];
					//spinnerLabel.text = @"";
					//[self.view setUserInteractionEnabled:YES];
					//[_FS Reset];
					
					[PDSPage dismissViewControllerAnimated:NO completion:Nil];
					
					/*
					PDSBrowserViewController *controller = [[PDSBrowserViewController alloc] init];
					controller.PDSLanguage = @"E";
					
					//controller.title = @"Quotation";
					//controller.delegate = self;
					//controller.premH = premH;
					//controller.premBH = premBH;
					
					UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
					UINavigationController *container = [[UINavigationController alloc] init];
					[container setNavigationBarHidden:YES animated:NO];
					[container setViewControllers:[NSArray arrayWithObject:navController] animated:NO];
					
					[self presentModalViewController:container animated:YES];
					
					controller = Nil;
					*/
					
					
					NSString *path = [[NSBundle mainBundle] pathForResource:@"PDS/PDS_Eng_Page1" ofType:@"html"];
					NSURL *pathURL = [NSURL fileURLWithPath:path];
					NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
					NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
					
					NSData* data = [NSData dataWithContentsOfURL:pathURL];
					[data writeToFile:[NSString stringWithFormat:@"%@/PDS_Eng_Temp.html",documentsDirectory] atomically:YES];
					
					NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"PDS_Eng_Temp.html"];
					//NSLog(@"delete HTML file Path: %@",HTMLPath);
					if([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {
						
						NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
						//NSLog(@"zzzz%@",targetURL);
						
						// Converting HTML to PDF
						//sleep(2);
						NSString *SIPDFName = [NSString stringWithFormat:@"PDS_%@.pdf",self.getSINo];
						self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:targetURL
															 pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
															   delegate:self
															   pageSize:kPaperSizeA4
										   //                   margins:UIEdgeInsetsMake(20, 5, 90, 5)];
																margins:UIEdgeInsetsMake(0, 0, 0, 0)];
						
						targetURL = nil, SIPDFName = nil;
					}
					
					path = nil,pathURL = nil,path_forDirectory = nil, documentsDirectory = nil, data = nil, HTMLPath =nil;
					/*
					UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
					[v removeFromSuperview];
					v = Nil;
					
					
					if (previousPath == Nil) {
						previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
					}
					
					
					[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
					selectedPath = previousPath;
					 */
				});
				
				PDSPage = Nil;
				
				
			});
			

		}
        
    }
    else if (indexPath.row == 10) {   //Malay PDS
		
		PDSorSI = @"PDS";
        
		if ([getOccpCode isEqualToString:@"OCC01975"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
			if (previousPath == Nil) {
				previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
			}
			
			[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			
		}
		else if ([getBasicPlan isEqualToString:@"HLACP"] && getAge > 63 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 63 for this product."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			alert = Nil;
			if (previousPath == Nil) {
				previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
			}
			
			[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		}
		
		else{
			
			AppDelegate *appDel= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
			
			NSString *RevisedSumAssured = appDel.MhiMessage;	
			if (![appDel.MhiMessage isEqualToString:@""] && appDel.MhiMessage != NULL) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Guaranteed Yearly Income will be increase to RM%@ in accordance to MHI Guideline",RevisedSumAssured]
															   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				[alert show];
				alert = Nil;
			}
			
			RevisedSumAssured = Nil;
			appDel = Nil;
			//appDel.MhiMessage = Nil;
			/*
			PremiumViewController *premView = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
			premView.requestAge = getAge;
			premView.requestOccpClass = getOccpClass;
			premView.requestOccpCode = getOccpCode;
			premView.requestSINo = getSINo;
			premView.requestMOP = getMOP;
			premView.requestTerm = getTerm;
			premView.requestBasicSA = getbasicSA;
			premView.requestBasicHL = getbasicHL;
			premView.requestBasicTempHL = getbasicTempHL;
			premView.requestPlanCode = getPlanCode;
			
			UIView *zzz = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) ];
			[zzz addSubview:premView.view];
			
			premView = Nil, zzz= Nil;
			*/
			spinner_SI = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			spinner_SI.center = CGPointMake(400, 350);
			
			spinner_SI.hidesWhenStopped = YES;
			[self.view addSubview:spinner_SI];
			UILabel *spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 370, 120, 40) ];
			spinnerLabel.text  = @" Please Wait...";
			spinnerLabel.backgroundColor = [UIColor blackColor];
			spinnerLabel.opaque = YES;
			spinnerLabel.textColor = [UIColor whiteColor];
			[self.view addSubview:spinnerLabel];
			[self.view setUserInteractionEnabled:NO];
			[spinner_SI startAnimating];
			
			if (_FS == Nil) {
				self.FS = [FSVerticalTabBarController alloc];
				_FS.delegate = self;
			}
			
			[_FS Test ];
			
			
			//dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
				//dispatch_async(downloadQueue, ^{
				
				PremiumViewController *premView = [[PremiumViewController alloc] init ];
				premView.requestAge = getAge;
				premView.requestOccpClass = getOccpClass;
				premView.requestOccpCode = getOccpCode;
				premView.requestSINo = getSINo;
				premView.requestMOP = getMOP;
				premView.requestTerm = getTerm;
				premView.requestBasicSA = getbasicSA;
				premView.requestBasicHL = getbasicHL;
				premView.requestBasicTempHL = getbasicTempHL;
				premView.requestPlanCode = getPlanCode;
				[self presentViewController:premView animated:NO completion:Nil];
				[premView dismissViewControllerAnimated:NO completion:Nil];
				
				premView = Nil;
				
				ReportViewController *ReportPage;
				CashPromiseViewController *CPReportPage;
				
				if([getBasicPlan isEqualToString:@"HLACP" ]){
					CPReportPage = [[CashPromiseViewController alloc] init ];
					CPReportPage.SINo = getSINo;
					[self presentViewController:CPReportPage animated:NO completion:Nil];
					
				}
				else if([getBasicPlan isEqualToString:@"HLAIB" ]){
					ReportPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Report"];
					ReportPage.SINo = getSINo;
					[self presentViewController:ReportPage animated:NO completion:Nil];
				}
				
				if([getBasicPlan isEqualToString:@"HLACP" ]){
					
					[CPReportPage dismissViewControllerAnimated:NO completion:Nil];
				}
				else if([getBasicPlan isEqualToString:@"HLAIB" ]){
					[ReportPage dismissViewControllerAnimated:NO completion:Nil];
				}
				
				ReportPage = Nil;
				CPReportPage = Nil;
				
				PDSViewController *PDSPage = [[PDSViewController alloc ] init ];
				PDSPage.SINo = getSINo;
				PDSPage.PDSLanguage = @"M";
				if([getBasicPlan isEqualToString:@"HLACP" ]){
					PDSPage.PDSPlanCode = @"HLACP";
				}
				else{
					PDSPage.PDSPlanCode = @"HLAIB";
				}
				[self presentViewController:PDSPage animated:NO completion:Nil];
				
				[self generateJSON_HLCP];
				[self copyPDSToDoc];
				
				
				dispatch_async(dispatch_get_main_queue(), ^{
					//[spinner stopAnimating];
					//spinnerLabel.text = @"";
					//[self.view setUserInteractionEnabled:YES];
					//[_FS Reset];
					
					[PDSPage dismissViewControllerAnimated:NO completion:Nil];
					
					NSString *path = [[NSBundle mainBundle] pathForResource:@"PDS/PDS_BM_Page1" ofType:@"html"];
					NSURL *pathURL = [NSURL fileURLWithPath:path];
					NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
					NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
					
					NSData* data = [NSData dataWithContentsOfURL:pathURL];
					[data writeToFile:[NSString stringWithFormat:@"%@/PDS_BM_Temp.html",documentsDirectory] atomically:YES];
					
					NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"PDS_BM_Temp.html"];
					//NSLog(@"delete HTML file Path: %@",HTMLPath);
					if([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {
						
						NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
						//NSLog(@"zzzz%@",targetURL);
						
						// Converting HTML to PDF
						//sleep(2);
						NSString *SIPDFName = [NSString stringWithFormat:@"PDS_%@.pdf",self.getSINo];
						self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:targetURL
															 pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
															   delegate:self
															   pageSize:kPaperSizeA4
										   //                   margins:UIEdgeInsetsMake(20, 5, 90, 5)];
																margins:UIEdgeInsetsMake(0, 0, 0, 0)];
						
						targetURL = nil, SIPDFName = nil;
					}
					
					path = nil,pathURL = nil,path_forDirectory = nil, documentsDirectory = nil, data = nil, HTMLPath =nil;
					/*
					PDSBrowserViewController *controller = [[PDSBrowserViewController alloc] init];
					controller.PDSLanguage = @"M";
					
					//controller.title = @"Quotation";
					//controller.delegate = self;
					//controller.premH = premH;
					//controller.premBH = premBH;
					
					UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
					UINavigationController *container = [[UINavigationController alloc] init];
					[container setNavigationBarHidden:YES animated:NO];
					[container setViewControllers:[NSArray arrayWithObject:navController] animated:NO];
					
					[self presentModalViewController:container animated:YES];
					
					
					UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
					[v removeFromSuperview];
					v = Nil;
					
					if (previousPath == Nil) {
						previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
					}
					
					
					[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
					selectedPath = previousPath;
					 */
				});
				
				PDSPage = Nil;
				
				
				
				
				
			});
			

		}
	
		
		
	}
    
//    [tableView reloadData];
    
    if (blocked) {
        [tableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [tableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL found = false;
 
    if ([SelectedRow count ] == 0) {
 
        return  44;
    }
    else {
        NSString *aString = [[NSString alloc] initWithFormat:@"%d", indexPath.row ];
        
        for (int f = 0; f < [SelectedRow count]; f++) {
            NSString *stringFromArray = [SelectedRow objectAtIndex:f];
            if ([aString isEqualToString:stringFromArray]) {
                found = true;
                break;
            }
        }
        
        if (found) {
            
            return 0;
            
        }
        else {
            
            return  44;
            
        }
    }
}
 */

#pragma mark - delegate source

-(void)LAIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate andSmoker:(NSString *)aaSmoker
{
    NSLog(@"::receive data LAIndex:%d, commDate:%@",aaIndexNo,aaCommDate);
    getAge = aaAge;
    getSex = aaSex;
    getSmoker = aaSmoker;
    getOccpClass = aaOccpClass;
    getOccpCode = aaOccpCode;
    getCommDate = aaCommDate;
    getIdPay = aaIdPayor;
    getIdProf = aaIdProfile;
    getLAIndexNo = aaIndexNo;
    
    [self getLAName];
    [self.myTableView reloadData];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)PayorIndexNo:(int)aaIndexNo andSmoker:(NSString *)aaSmoker andSex:(NSString *)aaSex andDOB:(NSString *)aaDOB andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode
{
    NSLog(@"::receive data PayorIndex:%d",aaIndexNo);
    getPayorIndexNo = aaIndexNo;
    getPaySmoker = aaSmoker;
    getPaySex = aaSex;
    getPayDOB = aaDOB;
    getPayAge = aaAge;
    getPayOccp = aaOccpCode;
    
    [self getPayorName];
    [self.myTableView reloadData];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)payorSaved:(BOOL)aaTrue
{
    payorSaved = aaTrue;
}

-(void)PayorDeleted
{
    NSLog(@"::receive data Payor deleted!");
    [self clearDataPayor];
    [self getPayorName];
    [self.myTableView reloadData];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)LA2ndIndexNo:(int)aaIndexNo andSmoker:(NSString *)aaSmoker andSex:(NSString *)aaSex andDOB:(NSString *)aaDOB andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode
{
    NSLog(@"::receive data 2ndLAIndex:%d",aaIndexNo);
    get2ndLAIndexNo = aaIndexNo;
    get2ndLASmoker = aaSmoker;
    get2ndLASex = aaSex;
    get2ndLADOB = aaDOB;
    get2ndLAAge = aaAge;
    get2ndLAOccp = aaOccpCode;
    
    [self get2ndLAName];
    [self.myTableView reloadData];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)saved:(BOOL)aaTrue
{
    saved = aaTrue;
}

-(void)secondLADelete
{
    NSLog(@"::receive data 2ndLA deleted!");
    [self clearData2ndLA];
    [self get2ndLAName];
    [self.myTableView reloadData];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL andMOP:(int)aaMOP andPlanCode:(NSString *)aaPlanCode andAdvance:(int)aaAdvance andBasicPlan:(NSString *)aabasicPlan
{
    NSLog(@"::receive databasicSINo:%@, advance:%d, pentaCode:%@",aaSINo,aaAdvance,aaPlanCode);
    getSINo = aaSINo;
    getMOP = aaMOP;
    getTerm = aaCovered;
    getbasicSA = aaBasicSA;
    getbasicHL = aaBasicHL;
    getbasicTempHL = aaBasicTempHL;
    getPlanCode = aaPlanCode;
    getBasicPlan = aabasicPlan;
    getAdvance = aaAdvance;
    
    if (getbasicSA.length != 0)
    {
        PlanEmpty = NO;
    }
    
    [self checkingPayor];
    [self checking2ndLA];
    
    [self toogleView];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)RiderAdded
{
    NSLog(@"::receive data rider added!");
    [self toogleView];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)BasicSARevised:(NSString *)aabasicSA
{
    NSLog(@"::receive databasicSA revised:%@",aabasicSA);
    getbasicSA = aabasicSA;
}

-(void)HLInsert:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL
{
    NSLog(@"::receiveHL");
    getbasicHL = aaBasicHL;
    getbasicTempHL = aaBasicTempHL;
}

#pragma mark - Json

-(void)generateJSON_HLCP{
	
	riderCode = [NSMutableDictionary dictionary];
    [riderCode setObject:@"HLACP" forKey:@"HLA Cash Promise"];
    
    [riderCode setObject:@"C+" forKey:@"C+ Secure Rider"];
    [riderCode setObject:@"CCTR" forKey:@"Convertible Comprehensive Term Rider"];
    [riderCode setObject:@"CIR" forKey:@"Critical Illness Rider"];
    [riderCode setObject:@"CIWP" forKey:@"Critical Illness WP Rider"];
    [riderCode setObject:@"CPA" forKey:@"Comprehensive Personal Accident"];
    [riderCode setObject:@"EDB" forKey:@"Enhanced Death Benefit Rider "];
    [riderCode setObject:@"ETPD" forKey:@"Extended TPD Rider"];
    [riderCode setObject:@"ETPDB" forKey:@"Enhanced TPD Benefit Rider"];
    [riderCode setObject:@"HB" forKey:@"Hospitalisation Benefit"];
    [riderCode setObject:@"HMM" forKey:@"HLA Major Medi"];
    [riderCode setObject:@"HSP_II" forKey:@"Hospital & Surgical Plus II"];
    [riderCode setObject:@"ICR" forKey:@"Income Care Rider"];
    [riderCode setObject:@"LCPR" forKey:@"Living Care Plus Rider"];
    [riderCode setObject:@"MG_II" forKey:@"MedGLOBAL II"];
    [riderCode setObject:@"MG_IV" forKey:@"MedGLOBAL IV Plus"];
    [riderCode setObject:@"PA" forKey:@"Personal Accident"];
    [riderCode setObject:@"LCWP" forKey:@"Living Care Waiver Of Premium Payor Rider"];
    [riderCode setObject:@"PR" forKey:@"Waiver of Premium Payor Rider"];
    [riderCode setObject:@"SP_PRE" forKey:@"WOP Spouse Rider (Premier)"];
    [riderCode setObject:@"SP_STD" forKey:@"WOP Spouse Rider (Standard)"];
    [riderCode setObject:@"PLCP" forKey:@"Payor Living Care Plus Rider"];
    [riderCode setObject:@"PTR" forKey:@"Payor Term Rider"];
	
	NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    
    FMResultSet *results;
    NSString *query;
    int totalRecords = 0;
    int currentRecord = 0;
    
    results = [database executeQuery:@"select AgentCode,AgentName from Agent_profile"];
    NSString *agentCode;
    NSString *agentName;
    while([results next]) {
        agentCode = [results stringForColumn:@"AgentCode"];
        agentName  = [results stringForColumn:@"AgentName"];
    }
    
    results = [database executeQuery:@"select SINo, PlanCode, PlanName from SI_Temp_Trad"];
    NSString *SINo;
    NSString *PlanName;
    NSString *PlanCode;
    while([results next]) {
        SINo = [results stringForColumn:@"SINo"];
        PlanCode = [results stringForColumn:@"PlanCode"];
        PlanName = [results stringForColumn:@"PlanName"];
    }
    
    query = [NSString stringWithFormat:@"Select UpdatedAt,HL1KSA,TempHL1KSA from Trad_Details where SINo ='%@'",SINo];
    results = [database executeQuery:query];
    NSString *UpdatedAt;
    int HL1KSA = 0.0;
    int TempHL1KSA = 0;
    if ([results next]) {
        UpdatedAt = [results stringForColumnIndex:0];
        HL1KSA = [results intForColumnIndex:1];
        TempHL1KSA = [results intForColumnIndex:2];
        //NSLog(@"***%f",HL1KSA);
    }
    
    int TotalPages = 0;
	if ([PDSorSI isEqualToString:@"SI"])
		results = [database executeQuery:@"select count(*) as cnt from SI_Temp_Pages"];
    else
		results = [database executeQuery:@"select count(*) as cnt from SI_Temp_Pages_PDS"];
	
	if ([results next]) {
        TotalPages = [results intForColumn:@"cnt"];
    }
    
    //make a file name to write the data to using the documents directory:
    
    
    NSString *jsonFile = [docsPath2 stringByAppendingPathComponent:@"SI.json"];
    
    NSString *content = @"{\n";
    content = [content stringByAppendingString:@"\"SI\": [\n"];
    
    
    content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingFormat:@"\"agentCode\":\"%@\",\n", agentCode];
    content = [content stringByAppendingFormat:@"\"agentName\":\"%@\",\n", agentName];
    content = [content stringByAppendingFormat:@"\"SINo\":\"%@\",\n", SINo];
    content = [content stringByAppendingFormat:@"\"PlanCode\":\"%@\",\n", PlanCode];
    content = [content stringByAppendingFormat:@"\"PlanName\":\"%@\",\n", PlanName];
    content = [content stringByAppendingFormat:@"\"DateModified\":\"%@\",\n", UpdatedAt];
    content = [content stringByAppendingFormat:@"\"HL1KSA\":\"%d\",\n", HL1KSA];
    content = [content stringByAppendingFormat:@"\"TempHL1KSA\":\"%d\",\n", TempHL1KSA];
    content = [content stringByAppendingFormat:@"\"TotalPages\":\"%d\",\n", TotalPages];
	
    
	
    
    //SI_Temp_Trad_LA start
    totalRecords = 0;
    currentRecord = 0;
    
    query = [NSString stringWithFormat:@"Select count(*) as cnt from SI_Temp_Trad_LA where SINo ='%@'",SINo];
    results = [database executeQuery:query];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"Select LADesc,LADescM,Name,Age,Sex,Smoker,PTypeCode from SI_Temp_trad_LA where SINo ='%@'",SINo];
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"SI_Temp_trad_LA\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"LADesc\":\"%@\",\n", [results stringForColumn:@"LADesc"]];
        content = [content stringByAppendingFormat:@"\"LADescM\":\"%@\",\n", [results stringForColumn:@"LADescM"]];
        content = [content stringByAppendingFormat:@"\"Name\":\"%@\",\n", [results stringForColumn:@"Name"]];
        content = [content stringByAppendingFormat:@"\"Age\":\"%@\",\n", [results stringForColumn:@"Age"]];
        content = [content stringByAppendingFormat:@"\"Sex\":\"%@\",\n", [results stringForColumn:@"Sex"]];
        content = [content stringByAppendingFormat:@"\"Smoker\":\"%@\",\n", [results stringForColumn:@"Smoker"]];
        content = [content stringByAppendingFormat:@"\"PTypeCode\":\"%@\"\n", [results stringForColumn:@"PTypeCode"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_Trad_LA end
    
    
    //SI_Temp_Pages start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"select count(*) as cnt from SI_Temp_Pages"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Temp_Pages ORDER BY PageNum"];
    results = [database executeQuery:query];
    
    if (results != Nil){
        content = [content stringByAppendingString:@"\"SI_Temp_Pages\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"htmlName\":\"%@\",\n", [results stringForColumn:@"htmlName"]];
        content = [content stringByAppendingFormat:@"\"PageNum\":\"%@\",\n", [results stringForColumn:@"PageNum"]];
        content = [content stringByAppendingFormat:@"\"PageDesc\":\"%@\",\n", [results stringForColumn:@"PageDesc"]];
        content = [content stringByAppendingFormat:@"\"riders\":\"%@\"\n", [results stringForColumn:@"riders"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_Pages end
	
    
    
    
    //SI_Temp_Trad_Details start
    totalRecords = 0;
    currentRecord = 0;
	NSString *rCode;
    results = [database executeQuery:@"select count(*) as cnt from SI_Temp_Trad_Details"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Temp_Trad_Details ORDER BY SeqNo"];
    results = [database executeQuery:query];
    
    if (results != Nil){
        content = [content stringByAppendingString:@"\"SI_Temp_Trad_Details\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
		
		rCode = [self getRiderCode:[results stringForColumn:@"col0_1"]];
		content = [content stringByAppendingFormat:@"\"RiderCode\":\"%@\",\n", rCode];
		
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\"\n", [results stringForColumn:@"col10"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_Trad_Details end
    
    //SI_Temp_Trad_Basic start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"select count(*) as cnt from SI_Temp_Trad_Basic where DataType = 'DATA'"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT col0_1,col0_2,col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,col22,col23 FROM SI_Temp_Trad_Basic where DataType = 'DATA'"];
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"SI_Temp_Trad_Basic\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\",\n", [results stringForColumn:@"col12"]];
        content = [content stringByAppendingFormat:@"\"col13\":\"%@\",\n", [results stringForColumn:@"col13"]];
        content = [content stringByAppendingFormat:@"\"col14\":\"%@\",\n", [results stringForColumn:@"col14"]];
        content = [content stringByAppendingFormat:@"\"col15\":\"%@\",\n", [results stringForColumn:@"col15"]];
        content = [content stringByAppendingFormat:@"\"col16\":\"%@\",\n", [results stringForColumn:@"col16"]];
        content = [content stringByAppendingFormat:@"\"col17\":\"%@\",\n", [results stringForColumn:@"col17"]];
        content = [content stringByAppendingFormat:@"\"col18\":\"%@\",\n", [results stringForColumn:@"col18"]];
        content = [content stringByAppendingFormat:@"\"col19\":\"%@\",\n", [results stringForColumn:@"col19"]];
        content = [content stringByAppendingFormat:@"\"col20\":\"%@\",\n", [results stringForColumn:@"col20"]];
        content = [content stringByAppendingFormat:@"\"col21\":\"%@\",\n", [results stringForColumn:@"col21"]];
        content = [content stringByAppendingFormat:@"\"col22\":\"%@\",\n", [results stringForColumn:@"col22"]];
        content = [content stringByAppendingFormat:@"\"col23\":\"%@\"\n", [results stringForColumn:@"col23"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_Trad_Basic end
    
    //SI_Temp_Trad start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"select count(*) as cnt from SI_Temp_Trad"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT TotPremPaid,SurrenderValueHigh,SurrenderValueLow,TotalYearlylncome,SINo,PlanName,PlanCode,LAName,CashPaymentD,MCashPaymentD FROM SI_Temp_Trad"];
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"SI_Temp_Trad\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"TotPremPaid\":\"%@\",\n", [results stringForColumn:@"TotPremPaid"]];
        content = [content stringByAppendingFormat:@"\"SurrenderValueHigh\":\"%@\",\n", [results stringForColumn:@"SurrenderValueHigh"]];
        content = [content stringByAppendingFormat:@"\"SurrenderValueLow\":\"%@\",\n", [results stringForColumn:@"SurrenderValueLow"]];
        content = [content stringByAppendingFormat:@"\"TotalYearlylncome\":\"%@\",\n", [results stringForColumn:@"TotalYearlylncome"]];
        content = [content stringByAppendingFormat:@"\"SINo\":\"%@\",\n", [results stringForColumn:@"SINo"]];
        content = [content stringByAppendingFormat:@"\"PlanName\":\"%@\",\n", [results stringForColumn:@"PlanName"]];
        content = [content stringByAppendingFormat:@"\"PlanCode\":\"%@\",\n", [results stringForColumn:@"PlanCode"]];
        content = [content stringByAppendingFormat:@"\"LAName\":\"%@\",\n", [results stringForColumn:@"LAName"]];
        content = [content stringByAppendingFormat:@"\"CashPaymentD\":\"%@\",\n", [results stringForColumn:@"CashPaymentD"]];
        content = [content stringByAppendingFormat:@"\"MCashPaymentD\":\"%@\"\n", [results stringForColumn:@"MCashPaymentD"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_Trad end
    
    //SI_Temp_Trad_Overall start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"select count(*) as cnt from SI_Temp_Trad_Overall"];
    while ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT TotPremPaid1,SurrenderValueHigh1,SurrenderValueLow1,TotYearlyIncome1,TotPremPaid2,SurrenderValueHigh2,SurrenderValueLow2,TotYearlyIncome2 FROM SI_Temp_Trad_Overall"];
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"SI_Temp_Trad_Overall\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"TotPremPaid1\":\"%@\",\n", [results stringForColumn:@"TotPremPaid1"]];
        content = [content stringByAppendingFormat:@"\"SurrenderValueHigh1\":\"%@\",\n", [results stringForColumn:@"SurrenderValueHigh1"]];
        content = [content stringByAppendingFormat:@"\"SurrenderValueLow1\":\"%@\",\n", [results stringForColumn:@"SurrenderValueLow1"]];
        content = [content stringByAppendingFormat:@"\"TotYearlyIncome1\":\"%@\",\n", [results stringForColumn:@"TotYearlyIncome1"]];
        content = [content stringByAppendingFormat:@"\"TotPremPaid2\":\"%@\",\n", [results stringForColumn:@"TotPremPaid2"]];
        content = [content stringByAppendingFormat:@"\"SurrenderValueHigh2\":\"%@\",\n", [results stringForColumn:@"SurrenderValueHigh2"]];
        content = [content stringByAppendingFormat:@"\"SurrenderValueLow2\":\"%@\",\n", [results stringForColumn:@"SurrenderValueLow2"]];
        content = [content stringByAppendingFormat:@"\"TotYearlyIncome2\":\"%@\"\n", [results stringForColumn:@"TotYearlyIncome2"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_Trad_Overall end
    
    //Trad_Details start
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM Trad_Details where SINo ='%@'",SINo];
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"Trad_Details\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        //currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"BasicSA\":\"%@\",\n", [results stringForColumn:@"BasicSA"]];
        content = [content stringByAppendingFormat:@"\"AdvanceYearlyIncome\":\"%@\",\n", [results stringForColumn:@"AdvanceYearlyIncome"]];
        content = [content stringByAppendingFormat:@"\"DateModified\":\"%@\",\n", [results stringForColumn:@"UpdatedAt"]];
        content = [content stringByAppendingFormat:@"\"CashDividend\":\"%@\",\n", [results stringForColumn:@"CashDividend"]];
        content = [content stringByAppendingFormat:@"\"YearlyIncome\":\"%@\",\n", [results stringForColumn:@"YearlyIncome"]];
        content = [content stringByAppendingFormat:@"\"PartialAcc\":\"%@\",\n", [results stringForColumn:@"PartialAcc"]];
        content = [content stringByAppendingFormat:@"\"PartialPayout\":\"%@\"\n", [results stringForColumn:@"PartialPayout"]];
    }
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //Trad_Details end
    
    //SI_Temp_Trad_Rider start
    content = [content stringByAppendingString:@"\"SI_Temp_Trad_Rider\":{\n"];
    //page1 start
    content = [content stringByAppendingString:@"\"p1\":[\n"];
    content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingString:@"\"data\":[\n"];
    
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"SELECT count(*) as cnt FROM SI_Temp_Trad_Rider where PageNo = '1' order by CAST(SeqNo AS INT) asc"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Temp_Trad_Rider where PageNo = '1' order by CAST(SeqNo AS INT) asc"];
    results = [database executeQuery:query];
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"SeqNo\":\"%@\",\n", [results stringForColumn:@"SeqNo"]];
        content = [content stringByAppendingFormat:@"\"DataType\":\"%@\",\n", [results stringForColumn:@"DataType"]];
        content = [content stringByAppendingFormat:@"\"PageNo\":\"%@\",\n", [results stringForColumn:@"PageNo"]];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\"\n", [results stringForColumn:@"col12"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"],\n"];
    //page1 end
    
    //page2 start
    content = [content stringByAppendingString:@"\"p2\":[\n"];
    content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingString:@"\"data\":[\n"];
    
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"SELECT count(*) as cnt FROM SI_Temp_Trad_Rider where PageNo = '2' order by CAST(SeqNo AS INT) asc"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Temp_Trad_Rider where PageNo = '2' order by CAST(SeqNo AS INT) asc"];
    results = [database executeQuery:query];
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"SeqNo\":\"%@\",\n", [results stringForColumn:@"SeqNo"]];
        content = [content stringByAppendingFormat:@"\"DataType\":\"%@\",\n", [results stringForColumn:@"DataType"]];
        content = [content stringByAppendingFormat:@"\"PageNo\":\"%@\",\n", [results stringForColumn:@"PageNo"]];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\"\n", [results stringForColumn:@"col12"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"],\n"];
    //page2 end
    
    //page3 start
    content = [content stringByAppendingString:@"\"p3\":[\n"];
    content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingString:@"\"data\":[\n"];
    
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"SELECT count(*) as cnt FROM SI_Temp_Trad_Rider where PageNo = '3' order by CAST(SeqNo AS INT) asc"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Temp_Trad_Rider where PageNo = '3' order by CAST(SeqNo AS INT) asc"];
    results = [database executeQuery:query];
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"SeqNo\":\"%@\",\n", [results stringForColumn:@"SeqNo"]];
        content = [content stringByAppendingFormat:@"\"DataType\":\"%@\",\n", [results stringForColumn:@"DataType"]];
        content = [content stringByAppendingFormat:@"\"PageNo\":\"%@\",\n", [results stringForColumn:@"PageNo"]];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\"\n", [results stringForColumn:@"col12"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"],\n"];
    //page3 end
    
    //page4 start
    content = [content stringByAppendingString:@"\"p4\":[\n"];
    content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingString:@"\"data\":[\n"];
    
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"SELECT count(*) as cnt FROM SI_Temp_Trad_Rider where PageNo = '4' order by CAST(SeqNo AS INT) asc"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Temp_Trad_Rider where PageNo = '4' order by CAST(SeqNo AS INT) asc"];
    results = [database executeQuery:query];
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"SeqNo\":\"%@\",\n", [results stringForColumn:@"SeqNo"]];
        content = [content stringByAppendingFormat:@"\"DataType\":\"%@\",\n", [results stringForColumn:@"DataType"]];
        content = [content stringByAppendingFormat:@"\"PageNo\":\"%@\",\n", [results stringForColumn:@"PageNo"]];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\"\n", [results stringForColumn:@"col12"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"],\n"];
    //page4 end
    
    //page5 start
    content = [content stringByAppendingString:@"\"p5\":[\n"];
    content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingString:@"\"data\":[\n"];
    
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"SELECT count(*) as cnt FROM SI_Temp_Trad_Rider where PageNo = '5' order by CAST(SeqNo AS INT) asc"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Temp_Trad_Rider where PageNo = '5' order by CAST(SeqNo AS INT) asc"];
    results = [database executeQuery:query];
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"SeqNo\":\"%@\",\n", [results stringForColumn:@"SeqNo"]];
        content = [content stringByAppendingFormat:@"\"DataType\":\"%@\",\n", [results stringForColumn:@"DataType"]];
        content = [content stringByAppendingFormat:@"\"PageNo\":\"%@\",\n", [results stringForColumn:@"PageNo"]];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\"\n", [results stringForColumn:@"col12"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"],\n"];
    //page5 end
    
    //page6 start
    content = [content stringByAppendingString:@"\"p6\":[\n"];
    content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingString:@"\"data\":[\n"];
    
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"SELECT count(*) as cnt FROM SI_Temp_Trad_Rider where PageNo = '6' order by CAST(SeqNo AS INT) asc"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Temp_Trad_Rider where PageNo = '6' order by CAST(SeqNo AS INT) asc"];
    results = [database executeQuery:query];
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"SeqNo\":\"%@\",\n", [results stringForColumn:@"SeqNo"]];
        content = [content stringByAppendingFormat:@"\"DataType\":\"%@\",\n", [results stringForColumn:@"DataType"]];
        content = [content stringByAppendingFormat:@"\"PageNo\":\"%@\",\n", [results stringForColumn:@"PageNo"]];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\"\n", [results stringForColumn:@"col12"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"],\n"];
    //page6 end
    
    //page7 start
    content = [content stringByAppendingString:@"\"p7\":[\n"];
    content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingString:@"\"data\":[\n"];
    
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"SELECT count(*) as cnt FROM SI_Temp_Trad_Rider where PageNo = '7' order by CAST(SeqNo AS INT) asc"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Temp_Trad_Rider where PageNo = '7' order by CAST(SeqNo AS INT) asc"];
    results = [database executeQuery:query];
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"SeqNo\":\"%@\",\n", [results stringForColumn:@"SeqNo"]];
        content = [content stringByAppendingFormat:@"\"DataType\":\"%@\",\n", [results stringForColumn:@"DataType"]];
        content = [content stringByAppendingFormat:@"\"PageNo\":\"%@\",\n", [results stringForColumn:@"PageNo"]];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\"\n", [results stringForColumn:@"col12"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"],\n"];
    //page7 end
    
    //page8 start
    content = [content stringByAppendingString:@"\"p8\":[\n"];
    content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingString:@"\"data\":[\n"];
    
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"SELECT count(*) as cnt FROM SI_Temp_Trad_Rider where PageNo = '8' order by CAST(SeqNo AS INT) asc"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Temp_Trad_Rider where PageNo = '8' order by CAST(SeqNo AS INT) asc"];
    results = [database executeQuery:query];
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"SeqNo\":\"%@\",\n", [results stringForColumn:@"SeqNo"]];
        content = [content stringByAppendingFormat:@"\"DataType\":\"%@\",\n", [results stringForColumn:@"DataType"]];
        content = [content stringByAppendingFormat:@"\"PageNo\":\"%@\",\n", [results stringForColumn:@"PageNo"]];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\"\n", [results stringForColumn:@"col12"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"]\n"];
    //page8 end
    
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_Trad_Rider end
    
    
    
    //Trad_Rider_Details start
    totalRecords = 0;
    currentRecord = 0;
    query = [NSString stringWithFormat:@"Select count(*) as cnt from Trad_Rider_Details where SINo ='%@'",SINo];
    results = [database executeQuery:query];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"Select * from Trad_Rider_Details where SINo ='%@'",SINo];
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"Trad_Rider_Details\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"RiderCode\":\"%@\",\n", [results stringForColumn:@"RiderCode"]];
        content = [content stringByAppendingFormat:@"\"PTypeCode\":\"%@\",\n", [results stringForColumn:@"PTypeCode"]];
		content = [content stringByAppendingFormat:@"\"Seq\":\"%@\",\n", [results stringForColumn:@"Seq"]];
        content = [content stringByAppendingFormat:@"\"RiderTerm\":\"%@\",\n", [results stringForColumn:@"RiderTerm"]];
        content = [content stringByAppendingFormat:@"\"SumAssured\":\"%@\",\n", [results stringForColumn:@"SumAssured"]];
        content = [content stringByAppendingFormat:@"\"PlanOption\":\"%@\",\n", [results stringForColumn:@"PlanOption"]];
        content = [content stringByAppendingFormat:@"\"Units\":\"%@\",\n", [results stringForColumn:@"Units"]];
        content = [content stringByAppendingFormat:@"\"Deductible\":\"%@\",\n", [results stringForColumn:@"Deductible"]];
        content = [content stringByAppendingFormat:@"\"HL1KSA\":\"%@\",\n", [results stringForColumn:@"HL1KSA"]];
        content = [content stringByAppendingFormat:@"\"HL1KSATerm\":\"%@\",\n", [results stringForColumn:@"HL1KSATerm"]];
        content = [content stringByAppendingFormat:@"\"HLPercentage\":\"%@\",\n", [results stringForColumn:@"HLPercentage"]];
        content = [content stringByAppendingFormat:@"\"TempHL1KSA\":\"%@\",\n", [results stringForColumn:@"TempHL1KSA"]];
        content = [content stringByAppendingFormat:@"\"TempHL1KSATerm\":\"%@\"\n", [results stringForColumn:@"TempHL1KSATerm"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //Trad_Rider_Details end
	
    //SI_Temp_Pages_PDS start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"select count(*) as cnt from SI_Temp_Pages_PDS"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Temp_Pages_PDS ORDER BY PageNum"];
    results = [database executeQuery:query];
    
    if (results != Nil){
        content = [content stringByAppendingString:@"\"SI_Temp_Pages_PDS\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"htmlName\":\"%@\",\n", [results stringForColumn:@"htmlName"]];
        content = [content stringByAppendingFormat:@"\"PageNum\":\"%@\",\n", [results stringForColumn:@"PageNum"]];
        content = [content stringByAppendingFormat:@"\"PageDesc\":\"%@\",\n", [results stringForColumn:@"PageDesc"]];
        content = [content stringByAppendingFormat:@"\"riders\":\"%@\"\n", [results stringForColumn:@"riders"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_Pages_PDS end
	
	//SI_Store_Premium start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"select count(*) as cnt from SI_Store_premium where Type != 'BOriginal'"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM SI_Store_premium where Type != 'BOriginal'"];
    results = [database executeQuery:query];
    
    if (results != Nil){
        content = [content stringByAppendingString:@"\"SI_Store_Premium\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"Type\":\"%@\",\n", [results stringForColumn:@"Type"]];
        content = [content stringByAppendingFormat:@"\"Annually\":\"%@\",\n", [results stringForColumn:@"Annually"]];
        content = [content stringByAppendingFormat:@"\"SemiAnnually\":\"%@\",\n", [results stringForColumn:@"SemiAnnually"]];
        content = [content stringByAppendingFormat:@"\"Quarterly\":\"%@\",\n", [results stringForColumn:@"Quarterly"]];
        content = [content stringByAppendingFormat:@"\"Monthly\":\"%@\",\n", [results stringForColumn:@"Monthly"]];
        content = [content stringByAppendingFormat:@"\"FromAge\":\"%@\",\n", [results stringForColumn:@"FromAge"]];
        content = [content stringByAppendingFormat:@"\"ToAge\":\"%@\"\n", [results stringForColumn:@"ToAge"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    //SI_Store_Premium end

    
    
    
    
    
    
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}"];
    [content writeToFile:jsonFile
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
    
    
    [database close];

}

-(void)copySIToDoc{
    
    
    NSString *directory = @"SI";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentSIFolderPath = [documentsDirectory stringByAppendingPathComponent:directory];
    NSString *resourceSIFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:directory];
    
    
    if (![fileManager fileExistsAtPath:documentSIFolderPath]) {
        [fileManager createDirectoryAtPath:documentSIFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
	else{
		[fileManager removeItemAtPath:documentSIFolderPath error:&error];
		[fileManager createDirectoryAtPath:documentSIFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
	}
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:resourceSIFolderPath error:&error];
    for (NSString *SIFiles in fileList) {
        NSString *newFilePath = [documentSIFolderPath stringByAppendingPathComponent:SIFiles];
        NSString *oldFilePath = [resourceSIFolderPath stringByAppendingPathComponent:SIFiles];
        [fileManager copyItemAtPath:oldFilePath toPath:newFilePath error:&error];
    }
    
    
    
}

-(void)copyPDSToDoc{
    
    
    NSString *directory = @"PDS";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentSIFolderPath = [documentsDirectory stringByAppendingPathComponent:directory];
    NSString *resourceSIFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:directory];
    
    
    if (![fileManager fileExistsAtPath:documentSIFolderPath]) {
        [fileManager createDirectoryAtPath:documentSIFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    else{
        [fileManager removeItemAtPath:documentSIFolderPath error:&error];
        [fileManager createDirectoryAtPath:documentSIFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:resourceSIFolderPath error:&error];
    for (NSString *SIFiles in fileList) {
        NSString *newFilePath = [documentSIFolderPath stringByAppendingPathComponent:SIFiles];
        NSString *oldFilePath = [resourceSIFolderPath stringByAppendingPathComponent:SIFiles];
        [fileManager copyItemAtPath:oldFilePath toPath:newFilePath error:&error];
    }
    
    
}

-(NSString*)getRiderCode:(NSString *)rider
{
    NSString *riderName;
    
    if([[rider substringWithRange:NSMakeRange(0,3)] isEqualToString:@"WOP"]){
        riderName = [[rider componentsSeparatedByString:@") ("] objectAtIndex:0];
        riderName = [riderName stringByAppendingString:@")"];
    }
    else{
        riderName = [[rider componentsSeparatedByString:@" ("] objectAtIndex:0];
    }
    
    return [riderCode objectForKey:riderName];
}

#pragma mark - memory

- (void)viewDidUnload
{
    [self resignFirstResponder];
    [self setMyTableView:nil];
    [self setRightView:nil];
    [self setGetSINo:nil];
    [self setGetOccpCode:nil];
    [self setPayorCustCode:nil];
    [self setPayorSINo:nil];
    [self setCustCode2:nil];
    [self setGetbasicSA:nil];
    [self setMenuBH:nil];
    [self setMenuPH:nil];
    [self setGetOccpCode:nil];
    [self setGetCommDate:nil];
    [self setGetPaySmoker:nil];
    [self setGetPaySex:nil];
    [self setGetPayDOB:nil];
    [self setGetPayOccp:nil];
    [self setGet2ndLASmoker:nil];
    [self setGet2ndLASex:nil];
    [self setGet2ndLADOB:nil];
    [self setGet2ndLAOccp:nil];
    [self setGetSINo:nil];
    [self setGetbasicSA:nil];
    [self setGetbasicHL:nil];
    [self setGetPlanCode:nil];
    [self setGetBasicPlan:nil];
    [super viewDidUnload];
}

-(void)clearDataLA
{
    _LAController = nil;
    getAge = 0;
    getSex = nil;
    getSmoker = nil;
    getOccpClass = 0;
    getOccpCode = nil;
    getCommDate = nil;
    getIdPay = 0;
    getIdProf = 0;
    getLAIndexNo = 0;
    NameLA = nil;
}

-(void)clearDataPayor
{
    _PayorController = nil;
    getPayorIndexNo = 0;
    getPaySmoker = nil;
    getPaySex = nil;
    getPayDOB = nil;
    getPayAge = 0;
    getPayOccp = nil;
    NamePayor = nil;
    payorSINo = nil;
}

-(void)clearData2ndLA
{
    _SecondLAController = nil;
    get2ndLAIndexNo = 0;
    get2ndLASmoker = nil;
    get2ndLASex = nil;
    get2ndLADOB = nil;
    get2ndLAAge = 0;
    get2ndLAOccp = nil;
    Name2ndLA = nil;
    CustCode2 = nil;
}

-(void)clearDataBasic
{
    _BasicController = nil;
    getSINo = nil;
    getMOP = 0;
    getTerm = 0;
    getbasicSA = nil;
    getbasicHL = nil;
    getbasicTempHL = nil;
    getPlanCode = nil;
    getBasicPlan = nil;
    getAdvance = 0;
}

-(void)RemovePDS{
    [ListOfSubMenu removeObject:@"Quotation"];
    [ListOfSubMenu removeObject:@"Product Disclosure Sheet"];
    [ListOfSubMenu removeObject:@"   English"];
    [ListOfSubMenu removeObject:@"   Malay"];
}


@end
