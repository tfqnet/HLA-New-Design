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
#import "PDSBrowserViewController.h"
#import "PDSViewController.h"

@interface SIMenuViewController ()

@end

@implementation SIMenuViewController
@synthesize myTableView, SIshowQuotation;
@synthesize RightView;
@synthesize ListOfSubMenu,SelectedRow;
@synthesize menulaH,menuBH,menuPH,menuLa2ndH,getCommDate;
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
@synthesize Name2ndLA,NameLA,getLAIndexNo,NamePayor,getSex,getbasicTempHL,getSmoker;

id RiderCount;

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
    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]];
    
//    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Life Assured", @"   2nd Life Assured", @"   Payor", @"Basic Plan", @"Rider", @"Premium", nil ];
//    SelectedRow = [[NSMutableArray alloc] initWithObjects:@"4", @"5", nil ];
     ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Life Assured", @"   2nd Life Assured", @"   Payor", @"Basic Plan", nil ];
    
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
    self.myTableView.frame = CGRectMake(0, 0, 220, 748);
    [self hideSeparatorLine];
    self.RightView.frame = CGRectMake(223, 0, 801, 748);
    [super viewWillAppear:animated];
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
            if (_BasicController == nil) {
                self.BasicController = [self.storyboard instantiateViewControllerWithIdentifier:@"BasicPlanView"];
                _BasicController.delegate = self;
            }
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
            [self addChildViewController:premView];
            [self.RightView addSubview:premView.view];
        
            previousPath = selectedPath;
            blocked = NO;
            [self hideSeparatorLine];
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
        if (indexPath.row == 4) {
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
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
        
        [self RemovePDS];
        [self select2ndLA];
        [self hideSeparatorLine];
        [myTableView reloadData];
    }
    
    else if (indexPath.row == 2)    //Payor
    {
        
        [self RemovePDS];
        [self selectPayor];
        [self hideSeparatorLine];
        [myTableView reloadData];
    }
    
    else if (indexPath.row == 3)    //basic plan
    { 
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
            
            [self RemovePDS];
            [self selectBasicPlan];
            [self hideSeparatorLine];
            [myTableView reloadData];
        }
    }
    
    else if (indexPath.row == 4)    //rider
    {
        
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
            [self hideSeparatorLine];
            [myTableView reloadData];
        }
    }
    
    else if (indexPath.row == 5)    //premium
    {
        [self calculatedPrem];
        
        
        [myTableView reloadData];
    }
    else if (indexPath.row == 6)    //quotation
    {
        
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
        
        if (cont == TRUE) {
            
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            spinner.center = CGPointMake(400, 350);
            
            spinner.hidesWhenStopped = YES;
            [self.view addSubview:spinner];
            UILabel *spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 370, 120, 40) ];
            spinnerLabel.text  = @" Please Wait...";
            spinnerLabel.backgroundColor = [UIColor blackColor];
            spinnerLabel.opaque = YES;
            spinnerLabel.textColor = [UIColor whiteColor];
            [self.view addSubview:spinnerLabel];
            [spinner startAnimating];
            
            
            //dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                //dispatch_async(downloadQueue, ^{
                
                ReportViewController *ReportPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Report"];
                ReportPage.SINo = getSINo;
                [self presentViewController:ReportPage animated:NO completion:Nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinner stopAnimating];
                    spinnerLabel.text = @"";
                    
                    [ReportPage dismissViewControllerAnimated:NO completion:Nil];
                    
                    
                    BrowserViewController *controller = [[BrowserViewController alloc] init];
                    controller.title = @"Quotation";
                    controller.Module = 1;
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
                });
                
                
            });
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"SI has been deleted" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
            [alert show];
        }
    }
    
    else if (indexPath.row == 8) {   //English PDS
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(400, 350);
        
        spinner.hidesWhenStopped = YES;
        [self.view addSubview:spinner];
        UILabel *spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 370, 120, 40) ];
        spinnerLabel.text  = @" Please Wait...";
        spinnerLabel.backgroundColor = [UIColor blackColor];
        spinnerLabel.opaque = YES;
        spinnerLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:spinnerLabel];
        [spinner startAnimating];
        
        
        //dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            //dispatch_async(downloadQueue, ^{
            
            
            PDSViewController *PDSPage = [[PDSViewController alloc ] init ];
            PDSPage.SINo = getSINo;
            PDSPage.PDSLanguage = @"E";
            [self presentViewController:PDSPage animated:NO completion:Nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                spinnerLabel.text = @"";
                
                [PDSPage dismissViewControllerAnimated:NO completion:Nil];
                
                
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
                
                UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
                [v removeFromSuperview];
            });
            
            
        });
        
    }
    else if (indexPath.row == 9) {   //Malay PDS
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(400, 350);
        
        spinner.hidesWhenStopped = YES;
        [self.view addSubview:spinner];
        UILabel *spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 370, 120, 40) ];
        spinnerLabel.text  = @" Please Wait...";
        spinnerLabel.backgroundColor = [UIColor blackColor];
        spinnerLabel.opaque = YES;
        spinnerLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:spinnerLabel];
        [spinner startAnimating];
        
        
        //dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            //dispatch_async(downloadQueue, ^{
            
            
            PDSViewController *PDSPage = [[PDSViewController alloc ] init ];
            PDSPage.SINo = getSINo;
            PDSPage.PDSLanguage = @"M";
            [self presentViewController:PDSPage animated:NO completion:Nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                spinnerLabel.text = @"";
                
                [PDSPage dismissViewControllerAnimated:NO completion:Nil];
                
                
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
            });
            
            
        });
        
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

-(void)BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL andMOP:(int)aaMOP andPlanCode:(NSString *)aaPlanCode andAdvance:(int)aaAdvance
{
    NSLog(@"::receive databasicSINo:%@",aaSINo);
    getSINo = aaSINo;
    getMOP = aaMOP;
    getTerm = aaCovered;
    getbasicSA = aaBasicSA;
    getbasicHL = aaBasicHL;
    getbasicTempHL = aaBasicTempHL;
    getPlanCode = aaPlanCode;
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
    [self setMenulaH:nil];
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
    getAdvance = 0;
}

-(void)RemovePDS{
    [ListOfSubMenu removeObject:@"Quotation"];
    [ListOfSubMenu removeObject:@"Product Disclosure Sheet"];
    [ListOfSubMenu removeObject:@"   English"];
    [ListOfSubMenu removeObject:@"   Malay"];
}

@end
