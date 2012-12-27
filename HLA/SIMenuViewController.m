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
@synthesize getMOP,getTerm,getbasicHL,getPlanCode,getAdvance;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resignFirstResponder];
    
    //--for table view
    [self.view addSubview:myTableView];
    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]];
    
    //--for detail view
//    self.RightView.backgroundColor = [UIColor colorWithRed:(5.0/255.0) green:(150.0/255.0) blue:(200.0/255.0) alpha:1.0];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Life Assured", @"   2nd Life Assured", @"   Payor", @"Basic Plan", @"Rider", @"Premium", @"Quotation", nil ];
    
    SelectedRow = [[NSMutableArray alloc] initWithObjects:@"4", @"5", @"6", nil ];
    PlanEmpty = YES;
    
    if (_LAController == nil) {
        self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
        _LAController.delegate = self;
    }
    self.LAController.requestSINo = [self.requestSINo description];
    [self addChildViewController:self.LAController];
    [self.RightView addSubview:self.LAController.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    NSLog(@"menu disappear!");
    PlanEmpty = YES;
    [SelectedRow addObject:@"4" ];
    [SelectedRow addObject:@"5" ];
    [SelectedRow addObject:@"6" ];
    _LAController = nil;
    _BasicController = nil;
    _PayorController = nil;
    _SecondLAController = nil;
    getSINo = nil;
    [self.myTableView reloadData];
    
    self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
    _LAController.delegate = self;
    [self addChildViewController:self.LAController];
    [self.RightView addSubview:self.LAController.view];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)toogleView
{
    if (PlanEmpty)
    {
        [SelectedRow addObject:@"4"];
        [SelectedRow addObject:@"5"];
//        NSLog(@"Plan empty");
    }
    else {
        [SelectedRow removeObject:@"4"];
        [SelectedRow removeObject:@"5"];
//          NSLog(@"Plan not empty");
    }
    
    if ([SIshowQuotation isEqualToString:@"NO"] || SIshowQuotation == NULL ) {
        [SelectedRow addObject:@"6"];
    }
    else {
        //[SelectedRow removeObject:@"6"];
    }
    
    [self.myTableView reloadData];
}


#pragma mark - action

-(void)select2ndLA
{
    if (getAge >= 18)
    {
        if (_SecondLAController == nil) {
            self.SecondLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
            _SecondLAController.delegate = self;
        }
        self.SecondLAController.requestCommDate = getCommDate;
        self.SecondLAController.requestSINo = getSINo;
        [self addChildViewController:self.SecondLAController];
        [self.RightView addSubview:self.SecondLAController.view];
    }
    else if (getAge < 16 && getOccpCode.length != 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Life Assured" message:@"Life Assured is less than 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (getOccpCode.length == 0) {
        NSLog(@"no where!");
    }
    else {
        NSLog(@"age 16-17");
        if (getSINo.length != 0) {
            
            NSLog(@"with SI");
            [self checkingPayor];
            if (payorSINo.length != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                
                self.SecondLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
                _SecondLAController.delegate = self;
                self.SecondLAController.requestCommDate = getCommDate;
                self.SecondLAController.requestSINo = getSINo;
                [self addChildViewController:self.SecondLAController];
                [self.RightView addSubview:self.SecondLAController.view];
            }
        }
        else {
            if (getPayorIndexNo != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                if (_SecondLAController == nil) {
                    self.SecondLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
                    _SecondLAController.delegate = self;
                }
                self.SecondLAController.requestCommDate = getCommDate;
                self.SecondLAController.requestSINo = getSINo;
                [self addChildViewController:self.SecondLAController];
                [self.RightView addSubview:self.SecondLAController.view];
            }
        }
    }
}

-(void)selectPayor
{
    if (getAge >= 18) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Life Assured's age must not greater or equal to 18 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (getAge < 16 && getOccpCode.length != 0) {
        
        if (_PayorController == nil) {
            self.PayorController = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
            _PayorController.delegate = self;
        }
        self.PayorController.requestCommDate = getCommDate;
        self.PayorController.requestSINo = getSINo;
        [self addChildViewController:self.PayorController];
        [self.RightView addSubview:self.PayorController.view];
    }
    else if (getOccpCode.length == 0) {
        NSLog(@"no where!");
    }
    else {
        NSLog(@"age 16-17");
        if (getSINo.length != 0) {
            
            NSLog(@"with SI");
            [self checking2ndLA];
            if (CustCode2.length != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                
                self.PayorController = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
                _PayorController.delegate = self;
                
                self.PayorController.requestCommDate = getCommDate;
                self.PayorController.requestSINo = getSINo;
                [self addChildViewController:self.PayorController];
                [self.RightView addSubview:self.PayorController.view];
            }
        }
        else {
            if (get2ndLAIndexNo != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                if (_PayorController == nil) {
                    self.PayorController = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
                    _PayorController.delegate = self;
                }
                self.PayorController.requestCommDate = getCommDate;
                self.PayorController.requestSINo = getSINo;
                [self addChildViewController:self.PayorController];
                [self.RightView addSubview:self.PayorController.view];
            }
        }
    }
}

-(void)selectBasicPlan
{
    if (getSINo.length != 0) {
        NSLog(@"with SI");
        
        [self checkingPayor];
        if (getAge < 10 && payorSINo.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
        else {
            
            self.BasicController = [self.storyboard instantiateViewControllerWithIdentifier:@"BasicPlanView"];
            _BasicController.delegate = self;
            
            self.BasicController.requestAge = getAge;
            self.BasicController.requestOccpCode = getOccpCode;
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
        }
    }
    else if (getOccpCode != 0 && getSINo.length == 0) {
        NSLog(@"no SI");
        
        if (getAge < 10 && getPayorIndexNo == 0) {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
        else {
            if (_BasicController == nil) {
                self.BasicController = [self.storyboard instantiateViewControllerWithIdentifier:@"BasicPlanView"];
                _BasicController.delegate = self;
            }
            self.BasicController.requestAge = getAge;
            self.BasicController.requestOccpCode = getOccpCode;
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
        }
    }
    else {
        NSLog(@"no where!");
    }
}

-(void)calculatedPrem
{
    if (getSINo.length != 0) {
    
        PremiumViewController *premView = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
        premView.requestAge = getAge;
        premView.requestOccpClass = getOccpClass;
        premView.requestOccpCode = getOccpCode;
        
        premView.requestSINo = getSINo;
        premView.requestMOP = getMOP;
        premView.requestTerm = getTerm;
        premView.requestBasicSA = getbasicSA;
        premView.requestBasicHL = getbasicHL;
        premView.requestPlanCode = getPlanCode;
        
        [self addChildViewController:premView];
        [self.RightView addSubview:premView.view];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"No record selected!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
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
                
            } else {
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
                clientID2 = sqlite3_column_int(statement, 9);
            } else {
                NSLog(@"error access Trad_LAPayor");
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
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:18];
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}


#pragma mark - table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
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
            if (_LAController == nil) {
                self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
                _LAController.delegate = self;
            }
            [self addChildViewController:self.LAController];
            [self.RightView addSubview:self.LAController.view];
        }
        
    }
    else if (indexPath.row == 1) {
        [self select2ndLA];
    }
    else if (indexPath.row == 2) {
        [self selectPayor];
    }
    else if (indexPath.row == 3) {
        [self selectBasicPlan];
    }
    
    else if (indexPath.row == 4) {
        
        RiderViewController *zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"RiderView"];
        zzz.requestAge = getAge;
        zzz.requestOccpClass = getOccpClass;
        
        zzz.requestSINo = getSINo;
        zzz.requestPlanCode = getPlanCode;
        zzz.requestCoverTerm = getTerm;
        zzz.requestBasicSA = getbasicSA;
        zzz.requestMOP = getMOP;
        zzz.requestAdvance = getAdvance;
        
        [self addChildViewController:zzz];
        [self.RightView addSubview:zzz.view];
    }
    
    else if (indexPath.row == 5) {
        [self calculatedPrem];
    }
    
    else if (indexPath.row == 6) { //quotation
        NewLAViewController *newLA = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
        [self.RightView addSubview:newLA.view];
        [self addChildViewController:newLA];
        newLA.view.superview.bounds = CGRectMake(-284, 0,1024, 748);
        
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
    }
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL found = false;
    
    if ([SelectedRow count ] == 0) {
        return  44;
    }
    else {
        NSString *aString = [[NSString alloc] initWithFormat:@"%d", indexPath.row ];
        for (int f = 0; f < [SelectedRow count]; f++) {
            NSString * stringFromArray = [SelectedRow objectAtIndex:f];
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

#pragma mark - delegate source

-(void)LAIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate andSmoker:(NSString *)aaSmoker
{
    NSLog(@"::receive data LAIndex:%d",aaIndexNo);
    getAge = aaAge;
    getOccpClass = aaOccpClass;
    getOccpCode = aaOccpCode;
    getCommDate = aaCommDate;
    getIdPay = aaIdPayor;
    getIdProf = aaIdProfile;
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
}

-(void)BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andMOP:(int)aaMOP andPlanCode:(NSString *)aaPlanCode andAdvance:(int)aaAdvance
{
    NSLog(@"::receive databasicSINo:%@",aaSINo);
    getSINo = aaSINo;
    getMOP = aaMOP;
    getTerm = aaCovered;
    getbasicSA = aaBasicSA;
    getbasicHL = aaBasicHL;
    getPlanCode = aaPlanCode;
    getAdvance = aaAdvance;
    
    if (getbasicSA.length != 0)
    {
        PlanEmpty = NO;
    }
    [self toogleView];
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
    [super viewDidUnload];
}

@end
