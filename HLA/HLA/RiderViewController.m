//
//  RiderViewController.m
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "RiderViewController.h"
#import "BasicPlanViewController.h"
#import "NewLAViewController.h"

#import "MainScreen.h"

@interface RiderViewController ()

@end

@implementation RiderViewController
@synthesize titleRidCode;
@synthesize titleSA;
@synthesize titleTerm;
@synthesize titleUnit;
@synthesize myTableView;
@synthesize termLabel;
@synthesize sumLabel;
@synthesize planLabel;
@synthesize cpaLabel;
@synthesize unitLabel;
@synthesize occpLabel;
@synthesize HLLabel;
@synthesize HLTLabel;
@synthesize termField;
@synthesize sumField;
@synthesize cpaField;
@synthesize unitField;
@synthesize occpField;
@synthesize HLField;
@synthesize HLTField;
@synthesize planBtn;
@synthesize deducBtn;
@synthesize minDisplayLabel;
@synthesize maxDisplayLabel;
@synthesize btnPType;
@synthesize btnAddRider;
@synthesize requestPlanCode,requestSINo,requestAge,requestCoverTerm,requestBasicSA,requestOccpCode;
@synthesize pTypeCode,PTypeSeq,pTypeDesc,riderCode,riderDesc,popOverConroller;
@synthesize FLabelCode,FLabelDesc,FRidName,FInputCode,FFieldName,FTbName,FCondition;
@synthesize expAge,minSATerm,maxSATerm,minTerm,maxTerm,maxRiderTerm,planCode,SINoPlan,planOption,deductible,maxRiderSA;
@synthesize inputHL1KSA,inputHL1KSATerm,inputHL100SA,inputHL100SATerm,inputHLPercentage,inputHLPercentageTerm;
@synthesize LRiderCode,LSumAssured,LTerm,LUnits,atcRidCode,atcPlanChoice,existRidCode,GYI,requestMOP;
@synthesize occLoad,occClass,occCPA,riderBH,riderH,storedMaxTerm,basicRate,LSDRate;
@synthesize annualRiderPrem,halfRiderPrem,quarterRiderPrem,monthRiderPrem,LPlanOpt,pentaSQL,plnOptC,planOptHMM,LDeduct,deducHMM,LAge;
@synthesize planHSPII,planMGII,planMGIV,LSmoker,planCodeRider,LRidHL100,LRidHL1K,LRidHLP,riderRate;
@synthesize annualRiderSum,halfRiderSum,quarterRiderSum,monthRiderSum,medPlanCodeRider;
@synthesize annualMedRiderPrem,halfMedRiderPrem,quarterMedRiderPrem,monthMedRiderPrem,annualMedRiderSum,halfMedRiderSum,quarterMedRiderSum,monthMedRiderSum;
@synthesize basicPrem,riderPrem,medRiderPrem,medPentaSQL,OccpCat,CombNo,RBBenefit,RBLimit,RBGroup,medRiderCode;
@synthesize arrCombNo,AllCombNo,medPlanOpt,arrRBBenefit,TPlanOpt,TRiderCode,LTRiderCode;

#pragma mark - Cycle View

- (void)viewDidLoad
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    requestSINo = riderBH.storedSINo;
    requestAge = riderBH.storedAge;
    requestCoverTerm = riderBH.storedCovered;
    requestPlanCode = riderBH.storedPlanCode;
    requestBasicSA = [riderBH.storedbasicSA intValue];
    requestOccpCode = riderBH.storedOccpCode;
    requestMOP = riderBH.storedMOP;
    NSLog(@"Rider-Age:%d,covered:%d,SINo:%@ planCode:%@",requestAge,requestCoverTerm,requestSINo,requestPlanCode);
    
    deducBtn.hidden = YES;
    SINoPlan = [[NSString alloc] initWithFormat:@"%@",[self.requestSINo description]];
    planCode = [[NSString alloc] initWithFormat:@"%@",[self.requestPlanCode description]];
    incomeRider = NO;
    if (requestSINo) {
        if (!listPType) {
            listPType = [[RiderPTypeTbViewController alloc]initWithString:SINoPlan];
            listPType.delegate = self;
        }
        pTypeCode = [[NSString alloc] initWithFormat:@"%@",listPType.selectedCode];
        PTypeSeq = [listPType.selectedSeqNo intValue];
        pTypeDesc = [[NSString alloc] initWithFormat:@"%@",listPType.selectedDesc];
        [self.btnPType setTitle:pTypeDesc forState:UIControlStateNormal];
    }
    
    [self getListingRider];
    [self getListingRider2];
    myTableView.rowHeight = 50;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.opaque = NO;
    myTableView.backgroundView = nil;
    [self.view addSubview:myTableView];
    
    [self getOccLoad];
    [self getOccpCatCode];
    
    [super viewDidLoad];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark - keyboard display
-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    minDisplayLabel.text = @"";
    maxDisplayLabel.text = @"";
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            minDisplayLabel.text = @"";
            maxDisplayLabel.text = @"";
            break;
        case 1:
            minDisplayLabel.text = [NSString stringWithFormat:@"Min Term: %d",minTerm];
            maxDisplayLabel.text = [NSString stringWithFormat:@"Max Term: %.f",maxRiderTerm];
            break;
        case 2:
            minDisplayLabel.text = [NSString stringWithFormat:@"Min SA: %d",minSATerm];
            maxDisplayLabel.text = [NSString stringWithFormat:@"Max SA: %.f",maxRiderSA];
            break;
        case 3:
            minDisplayLabel.text = @"Min Unit: 1";
            maxDisplayLabel.text = @"Max Unit: 4";
            break;
            
        default:
            minDisplayLabel.text = @"";
            maxDisplayLabel.text = @"";
            break;
    }
    return YES;
}


#pragma mark - logic cycle

-(void)toggleForm
{
    NSUInteger i;
    for (i=0; i<[FLabelCode count]; i++) {
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"RITM"]]) {
            termLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            term = YES;
        }
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"SUMA"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"SUAS"]]) {
            sumLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            sumA = YES;
        }
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"GYIRM"]]) {
            sumLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            sumA = YES;
            incomeRider = YES;
        }
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"PLOP"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"PLCH"]]) {
            planLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            plan = YES;
        }
        
        cpaLabel.textColor = [UIColor grayColor];
        cpaField.enabled = NO;
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"UNIT"]]) {
            unitLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            unit = YES;
        }
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"DEDUC"]]) {
            unitLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            deduc = YES;
        }
        
        occpLabel.textColor = [UIColor grayColor];
        occpField.enabled = NO;
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL1K"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL10"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HLP"]]) {
            HLLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            hload = YES;
        }
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL1KT"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL10T"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HLPT"]]) {
            HLTLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            hloadterm = YES;
        }
    }
    [self replaceActive];
}

-(void)replaceActive
{
    if (term) {
        termLabel.textColor = [UIColor blackColor];
        termField.enabled = YES;
    } else {
        termLabel.textColor = [UIColor grayColor];
        termField.enabled = NO;
    }
    
    if (sumA) {
        sumLabel.textColor = [UIColor blackColor];
        sumField.enabled = YES;
    } else {
        sumLabel.textColor = [UIColor grayColor];
        sumField.enabled = NO;
    }
    
    if (plan) {
        planLabel.textColor = [UIColor blackColor];
        planBtn.enabled = YES;
    } else {
        planLabel.textColor = [UIColor grayColor];
        planBtn.enabled = NO;
        planLabel.text = @"PA Class";
    }
    
    if (unit) {
        unitLabel.textColor = [UIColor blackColor];
        unitField.hidden = NO;
        unitField.enabled = YES;
        deducBtn.hidden = YES;
    }
    
    if (deduc) {
        unitLabel.textColor = [UIColor blackColor];
        unitField.hidden = YES;
        deducBtn.hidden = NO;
    }
    
    if (!unit && !deduc) {
        unitLabel.text = @"Units";
        unitLabel.textColor = [UIColor grayColor];
        deducBtn.hidden = YES;
        unitField.hidden = NO;
        unitField.enabled = NO;
    }
    
    if (hload) {
        HLLabel.textColor = [UIColor blackColor];
        HLField.enabled = YES;
    } else {
        HLLabel.textColor = [UIColor grayColor];
        HLField.enabled = NO;
    }
    
    if (hloadterm) {
        HLTLabel.textColor = [UIColor blackColor];
        HLTField.enabled = YES;
    } else {
        HLTLabel.textColor = [UIColor grayColor];
        HLTField.enabled = NO;
    }
}



#pragma mark - calculation

-(void)calculateTerm
{
    int period = expAge - self.requestAge;
    int period2 = 80 - self.requestAge;
    double age1 = fmin(period2,60);
    
    if ([riderCode isEqualToString:@"CIWP"])
    {
        [self getMaxRiderTerm];
        double maxRiderTerm1 = fmin(period,self.requestCoverTerm);
        double maxRiderTerm2 = fmax(requestMOP,storedMaxTerm);
        maxRiderTerm = fmin(maxRiderTerm1,maxRiderTerm2);
    }
    
    else if ([riderCode isEqualToString:@"LCWP"]||[riderCode isEqualToString:@"PR"]||[riderCode isEqualToString:@"PLCP"]||
        [riderCode isEqualToString:@"PTR"]||[riderCode isEqualToString:@"SP_STD"]||[riderCode isEqualToString:@"SP_PRE"])
    {
        [self getMaxRiderTerm];
        double maxRiderTerm1 = fmin(self.requestCoverTerm,age1);
        double maxRiderTerm2 = fmax(requestMOP,storedMaxTerm);
        maxRiderTerm = fmin(maxRiderTerm1,maxRiderTerm2);
    }
    
    else if ([riderCode isEqualToString:@"I20R"]||[riderCode isEqualToString:@"I30R"]||[riderCode isEqualToString:@"I40R"])
    {
        termField.text = [NSString stringWithFormat:@"%d",maxTerm];
        termField.textColor = [UIColor darkGrayColor];
    }
    
    else if ([riderCode isEqualToString:@"ID20R"]||[riderCode isEqualToString:@"ID30R"]||[riderCode isEqualToString:@"ID40R"]||[riderCode isEqualToString:@"MG_II"]||[riderCode isEqualToString:@"MG_IV"]||[riderCode isEqualToString:@"HB"]||[riderCode isEqualToString:@"HSP_II"]||[riderCode isEqualToString:@"CPA"]||[riderCode isEqualToString:@"PA"]||[riderCode isEqualToString:@"HMM"])
    {
        maxRiderTerm = fmin(period,self.requestCoverTerm);
        termField.text = [NSString stringWithFormat:@"%.f",maxRiderTerm];
        termField.textColor = [UIColor darkGrayColor];
    }
    
    else {
        maxRiderTerm = fmin(period,self.requestCoverTerm);
    }
    
    NSLog(@"expAge-alb:%d,covperiod:%d,maxRiderTerm:%.f,age1:%.f",period,self.requestCoverTerm,maxRiderTerm,age1);
}

-(void)calculateSA
{
    int dblPseudoBSA = self.requestBasicSA / 0.05;
    double dblPseudoBSA2 = dblPseudoBSA * 0.1;
    double dblPseudoBSA3 = dblPseudoBSA * 5;
    double dblPseudoBSA4 = dblPseudoBSA * 2;
    
    if ([riderCode isEqualToString:@"CCTR"])
    {
        maxRiderSA = dblPseudoBSA * 5;
    }
    
    else if ([riderCode isEqualToString:@"ETPD"])
    {
        maxRiderSA = fmin(dblPseudoBSA2,120000);
    }
    
    else if ([riderCode isEqualToString:@"I20R"]||[riderCode isEqualToString:@"I30R"]||[riderCode isEqualToString:@"I40R"]||[riderCode isEqualToString:@"ID20R"]||[riderCode isEqualToString:@"ID30R"]||[riderCode isEqualToString:@"ID40R"])
    {
        [self getGYI];
        double BasicSA_GYI = self.requestBasicSA * GYI;
        maxRiderSA = fmin(BasicSA_GYI,9999999);
    }
    
    else if ([riderCode isEqualToString:@"CPA"]) {
        if (riderH.storedOccpClass == 1 || riderH.storedOccpClass == 2) {
            if (dblPseudoBSA < 100000) {
                maxRiderSA = fmin(dblPseudoBSA3,200000);
            }
            else if (dblPseudoBSA >= 100000) {
                maxRiderSA = fmin(dblPseudoBSA4,1000000);
            }
        }
        else if (riderH.storedOccpClass == 3 || riderH.storedOccpClass == 4) {
            maxRiderSA = fmin(dblPseudoBSA3,100000);
        }
    }
    
    else if ([riderCode isEqualToString:@"PA"]) {
        maxRiderSA = fmin(dblPseudoBSA3,1000000);
    }
    
    else {
        maxRiderSA = maxSATerm;
    }
}

-(void)calculateBasicPremium
{
    double BasicSA = requestBasicSA;
    double PolicyTerm = requestCoverTerm;
    double BasicHLoad = [riderBH.storedbasicHL intValue];
    
    //calculate basic premium
    double BasicAnnually = basicRate * (BasicSA/1000) * 1;
    double BasicHalfYear = basicRate * (BasicSA/1000) * 0.5125;
    double BasicQuarterly = basicRate * (BasicSA/1000) * 0.2625;
    double BasicMonthly = basicRate * (BasicSA/1000) * 0.0875;
    NSLog(@"Basic A:%.3f, S:%.3f, Q:%.3f, M:%.3f",BasicAnnually,BasicHalfYear,BasicQuarterly,BasicQuarterly);
    
    //calculate occupationLoading
    double OccpLoadA = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 1;
    double OccpLoadH = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.5125;
    double OccpLoadQ = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.2625;
    double OccpLoadM = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.0875;
    NSLog(@"OccpLoad A:%.3f, S:%.3f, Q:%.3f, M:%.3f",OccpLoadA,OccpLoadH,OccpLoadQ,OccpLoadM);
    
    //calculate basic health loading
    double BasicHLAnnually = BasicHLoad * (BasicSA/1000) * 1;
    double BasicHLHalfYear = BasicHLoad * (BasicSA/1000) * 0.5125;
    double BasicHLQuarterly = BasicHLoad * (BasicSA/1000) * 0.2625;
    double BasicHLMonthly = BasicHLoad * (BasicSA/1000) * 0.0875;
    NSLog(@"BasicHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",BasicHLAnnually,BasicHLHalfYear,BasicHLQuarterly,BasicHLMonthly);
    
    //calculate LSD
    double LSDAnnually = LSDRate * (BasicSA/1000) * 1;
    double LSDHalfYear = LSDRate * (BasicSA/1000) * 0.5125;
    double LSDQuarterly = LSDRate * (BasicSA/1000) * 0.2625;
    double LSDMonthly = LSDRate * (BasicSA/1000) * 0.0875;
    NSLog(@"LSD A:%.3f, S:%.3f, Q:%.3f, M:%.3f",LSDAnnually,LSDHalfYear,LSDQuarterly,LSDMonthly);
    
    //calculate Total basic premium
    double basicTotalA = BasicAnnually + OccpLoadA + BasicHLAnnually - LSDAnnually;
    double basicTotalS = BasicHalfYear + OccpLoadH + BasicHLHalfYear - LSDHalfYear;
    double basicTotalQ = BasicQuarterly + OccpLoadQ + BasicHLQuarterly - LSDQuarterly;
    double basicTotalM = BasicMonthly + OccpLoadM + BasicHLMonthly - LSDMonthly;
    NSLog(@"BasicTotal A:%.3f, S:%.3f, Q:%.3f, M:%.3f",basicTotalA,basicTotalS,basicTotalQ,basicTotalM);
    
    /*
     NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
     [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
     [formatter setMaximumFractionDigits:2];
     NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithDouble:basicTotalA]];
     NSLog(@"basicPrem:%@",numberString);
     */
    
    basicPrem = basicTotalA;
    NSLog(@"basicPrem:%.2f",basicPrem);
}

-(void)calculateRiderPrem
{
    annualRiderPrem = [[NSMutableArray alloc] init];
    halfRiderPrem = [[NSMutableArray alloc] init];
    quarterRiderPrem = [[NSMutableArray alloc] init];
    monthRiderPrem = [[NSMutableArray alloc] init];
    NSUInteger i;
    for (i=0; i<[LRiderCode count]; i++) {
        //getpentacode
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            if ([[LRiderCode objectAtIndex:i] isEqualToString:@"C+"])
            {
                if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"1"]) {
                    plnOptC = @"L";
                } else if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"2"]) {
                    plnOptC = @"I";
                } else if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"3"]) {
                    plnOptC = @"B";
                } else if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"4"]) {
                    plnOptC = @"N";
                }
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",plnOptC];
                
            }
            
            else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"I40R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"ID20R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"ID30R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"ID40R"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND PremPayOpt=\"%d\"",[LRiderCode objectAtIndex:i],requestMOP];
            }
            
            else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"ICR"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"ICR\" AND Smoker=\"%@\"",[LSmoker objectAtIndex:i]];
                
            }            
            
            else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"CCTR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"CIR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"ETPD"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"LCPR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"CPA"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PA"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"CIWP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PLCP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PTR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_STD"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_PRE"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND Channel=\"AGT\"",[LRiderCode objectAtIndex:i]];
            }
            
            else {
                continue;
            }
            NSLog(@"%@",pentaSQL);
            if (sqlite3_prepare_v2(contactDB, [pentaSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    planCodeRider =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    
                } else {
                    NSLog(@"error access PentaPlanCode");
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
        
        int ridTerm = [[LTerm objectAtIndex:i] intValue];
        //get rate
        if ([[LRiderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"I40R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"ID20R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"ID30R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"ID40R"])
        {
            [self getIncomeRiderRate:planCodeRider riderTerm:ridTerm];
        }
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"CPA"]) {
            [self getCPARiderRate:planCodeRider riderTerm:ridTerm];
        }
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"PA"]) {
            [self getPARiderRate:planCodeRider riderTerm:ridTerm];
        }
        else {
            [self getRiderRate:planCodeRider riderTerm:ridTerm];
        }
        
        double BasicSA = requestBasicSA;
        double BasicHLoad = [riderBH.storedbasicHL doubleValue];
        
        double ridSA = [[LSumAssured objectAtIndex:i] doubleValue];
        double PolicyTerm = requestCoverTerm;
        double riderHLoad;
        if ([LRidHL1K count] != 0) {
            riderHLoad = [[LRidHL1K objectAtIndex:i] doubleValue];
        }
        else if ([LRidHL100 count] != 0) {
            riderHLoad = [[LRidHL100 objectAtIndex:i] doubleValue];
        }
        else if ([LRidHLP count] != 0) {
            riderHLoad = [[LRidHLP objectAtIndex:i] doubleValue];
        }
        NSLog(@"riderRate:%d, ridersum:%.3f, riderHL:%.3f, basicHL:%.3f",riderRate,ridSA,riderHLoad,BasicHLoad);
        
        //calculate occupationLoading
        double OccpLoadA = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 1;
        double OccpLoadH = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.5125;
        double OccpLoadQ = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.2625;
        double OccpLoadM = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.0875;
        
        //calculate rider health loading
        double RiderHLAnnually = riderHLoad * (BasicSA/1000) * 1;
        double RiderHLHalfYear = riderHLoad * (BasicSA/1000) * 0.5125;
        double RiderHLQuarterly = riderHLoad * (BasicSA/1000) * 0.2625;
        double RiderHLMonthly = riderHLoad * (BasicSA/1000) * 0.0875;
        NSLog(@"RiderHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",RiderHLAnnually,RiderHLHalfYear,RiderHLQuarterly,RiderHLMonthly);
        
        double annualRider;
        double halfYearRider;
        double quarterRider;
        double monthlyRider;
        if ([[LRiderCode objectAtIndex:i] isEqualToString:@"ETPD"])
        {
            double fsar = (65 - self.requestAge) * ridSA;
            annualRider = (riderRate + RiderHLAnnually/10)*(ridSA/100) * 1 + fsar/1000 * OccpLoadA * 1;
            halfYearRider = (riderRate + RiderHLHalfYear/10)*(ridSA/100) * 0.5125 + fsar/1000 * OccpLoadA * 0.5125;
            quarterRider = (riderRate + RiderHLQuarterly/10)*(ridSA/100) * 0.2625 + fsar/1000 * OccpLoadA * 0.2625;
            monthlyRider = (riderRate + RiderHLMonthly/10)*(ridSA/100) * 0.0875 + fsar/1000 * OccpLoadA * 0.0875;
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"I40R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm + 1)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm + 1)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm + 1)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm + 1)/2);
            annualRider = (riderRate + occLoadFactorA + RiderHLAnnually) * (ridSA/1000) * 1;
            halfYearRider = (riderRate + occLoadFactorH + RiderHLHalfYear) * (ridSA/1000) * 0.5125;
            quarterRider = (riderRate + occLoadFactorQ + RiderHLQuarterly) * (ridSA/1000) * 0.2625;
            monthlyRider = (riderRate + occLoadFactorM + RiderHLMonthly) * (ridSA/1000) * 0.0875;
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"ICR"])
        {
            annualRider = (riderRate + OccpLoadA * ridTerm + RiderHLAnnually) * ridSA/1000 * 1;
            halfYearRider = (riderRate + OccpLoadH * ridTerm + RiderHLHalfYear) * ridSA/1000 * 0.5125;
            quarterRider = (riderRate + OccpLoadQ * ridTerm + RiderHLQuarterly) * ridSA/1000 * 0.2625;
            monthlyRider = (riderRate + OccpLoadM * ridTerm + RiderHLMonthly) * ridSA/1000 * 0.0875;
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"ID20R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm - 20)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm - 20)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm - 20)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm - 20)/2);
            annualRider = (riderRate + occLoadFactorA + RiderHLAnnually) * (ridSA/1000) * 1;
            halfYearRider = (riderRate + occLoadFactorH + RiderHLHalfYear) * (ridSA/1000) * 0.5125;
            quarterRider = (riderRate + occLoadFactorQ + RiderHLQuarterly) * (ridSA/1000) * 0.2625;
            monthlyRider = (riderRate + occLoadFactorM + RiderHLMonthly) * (ridSA/1000) * 0.0875;
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"ID30R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm - 30)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm - 30)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm - 30)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm - 30)/2);
            annualRider = (riderRate + occLoadFactorA + RiderHLAnnually) * (ridSA/1000) * 1;
            halfYearRider = (riderRate + occLoadFactorH + RiderHLHalfYear) * (ridSA/1000) * 0.5125;
            quarterRider = (riderRate + occLoadFactorQ + RiderHLQuarterly) * (ridSA/1000) * 0.2625;
            monthlyRider = (riderRate + occLoadFactorM + RiderHLMonthly) * (ridSA/1000) * 0.0875;
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"ID40R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm - 40)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm - 40)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm - 40)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm - 40)/2);
            annualRider = (riderRate + occLoadFactorA + RiderHLAnnually) * (ridSA/1000) * 1;
            halfYearRider = (riderRate + occLoadFactorH + RiderHLHalfYear) * (ridSA/1000) * 0.5125;
            quarterRider = (riderRate + occLoadFactorQ + RiderHLQuarterly) * (ridSA/1000) * 0.2625;
            monthlyRider = (riderRate + occLoadFactorM + RiderHLMonthly) * (ridSA/1000) * 0.0875;
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"CIWP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_STD"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_PRE"])
        {
            double RiderHLAnnually = BasicHLoad * (BasicSA/1000) * 1;
            double RiderHLHalfYear = BasicHLoad * (BasicSA/1000) * 0.5125;
            double RiderHLQuarterly = BasicHLoad * (BasicSA/1000) * 0.2625;
            double RiderHLMonthly = BasicHLoad * (BasicSA/1000) * 0.0875;
            NSLog(@"RiderHLWaiver A:%.3f, S:%.3f, Q:%.3f, M:%.3f",RiderHLAnnually,RiderHLHalfYear,RiderHLQuarterly,RiderHLMonthly);
            
            annualRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadA + RiderHLAnnually/100) * 1;
            halfYearRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadH + RiderHLHalfYear/100) * 0.5125;
            annualRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadQ + RiderHLQuarterly/100) * 0.2625;
            annualRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadM + RiderHLMonthly/100) * 0.0875;
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"PLCP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PTR"])
        {
            double RiderHLAnnually = BasicHLoad * (BasicSA/1000) * 1;
            double RiderHLHalfYear = BasicHLoad * (BasicSA/1000) * 0.5125;
            double RiderHLQuarterly = BasicHLoad * (BasicSA/1000) * 0.2625;
            double RiderHLMonthly = BasicHLoad * (BasicSA/1000) * 0.0875;
            
            annualRider = (riderRate + OccpLoadA + RiderHLAnnually) * ridSA/1000 * 1;
            halfYearRider = (riderRate + OccpLoadH + RiderHLHalfYear) * ridSA/1000 * 0.5125;
            annualRider = (riderRate + OccpLoadQ + RiderHLQuarterly) * ridSA/1000 * 0.2625;
            annualRider = (riderRate + OccpLoadM + RiderHLMonthly) * ridSA/1000 * 0.0875;
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"C+"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"CCTR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"CIR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"LCPR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"CPA"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PA"])
        {
            annualRider = (riderRate + OccpLoadA + RiderHLAnnually) * (ridSA/1000) * 1;
            halfYearRider = (riderRate + OccpLoadH  + RiderHLHalfYear) * (ridSA/1000) * 0.5125;
            quarterRider = (riderRate + OccpLoadQ  + RiderHLQuarterly) * (ridSA/1000) * 0.2625;
            monthlyRider = (riderRate + OccpLoadM + RiderHLMonthly) * (ridSA/1000) * 0.0875;
        } else {
            annualRider = 0;
            halfYearRider = 0;
            quarterRider = 0;
            monthlyRider = 0;
        }
        
        NSString *calRiderAnn = [NSString stringWithFormat:@"%.3f",annualRider];
        NSString *calRiderHalf = [NSString stringWithFormat:@"%.3f",halfYearRider];
        NSString *calRiderQuarter = [NSString stringWithFormat:@"%.3f",quarterRider];
        NSString *calRiderMonth = [NSString stringWithFormat:@"%.3f",monthlyRider];
        NSLog(@"cal(%@) A:%@ S:%@ Q:%@ M:%@",[LRiderCode objectAtIndex:i],calRiderAnn,calRiderHalf,calRiderQuarter,calRiderMonth);
        
        [annualRiderPrem addObject:calRiderAnn];
        [halfRiderPrem addObject:calRiderHalf];
        [quarterRiderPrem addObject:calRiderQuarter];
        [monthRiderPrem addObject:calRiderMonth];
    }
    
    annualRiderSum = 0;
    halfRiderSum = 0;
    quarterRiderSum = 0;
    monthRiderSum = 0;
    NSUInteger a;
    for (a=0; a<[annualRiderPrem count]; a++) {
        annualRiderSum = annualRiderSum + [[annualRiderPrem objectAtIndex:a] doubleValue];
        halfRiderSum = halfRiderSum + [[halfRiderPrem objectAtIndex:a] doubleValue];
        quarterRiderSum = quarterRiderSum + [[quarterRiderPrem objectAtIndex:a] doubleValue];
        monthRiderSum = monthRiderSum + [[monthRiderPrem objectAtIndex:a] doubleValue];
    }
    riderPrem = annualRiderSum;
    NSLog(@"RiderPrem:%.2f",riderPrem);
}

-(void)calculateMedRiderPrem
{
    annualMedRiderPrem = [[NSMutableArray alloc] init];
    halfMedRiderPrem = [[NSMutableArray alloc] init];
    quarterMedRiderPrem = [[NSMutableArray alloc] init];
    monthMedRiderPrem = [[NSMutableArray alloc] init];
    NSUInteger i;
    for (i=0; i<[LRiderCode count]; i++) {
        //getpentacode
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            if ([[LRiderCode objectAtIndex:i] isEqualToString:@"HMM"])
            {
                planOptHMM = [LPlanOpt objectAtIndex:i];
                deducHMM = [LDeduct objectAtIndex:i];
                medPentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"HMM\" AND PlanOption=\"%@\" AND Deductible=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planOptHMM,deducHMM,[LAge objectAtIndex:i],[LAge objectAtIndex:i]];
            }
            
            else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"HSP_II"])
            {
                if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"Standard"]) {
                    planHSPII = @"S";
                } else if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"Deluxe"]) {
                    planHSPII = @"D";
                } else if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"Premier"]) {
                    planHSPII = @"P";
                }
                medPentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",planHSPII];
            }
            
            else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"MG_II"])
            {
                planMGII = [LPlanOpt objectAtIndex:i];
                medPentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",planMGII];
            }
            
            else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"MG_IV"])
            {
                planMGIV = [LPlanOpt objectAtIndex:i];
                medPentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"MG_IV\" AND PlanOption=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planMGIV,[LAge objectAtIndex:i],[LAge objectAtIndex:i]];
            }
            
            else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"HB"]) {
                medPentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND Channel=\"AGT\"",[LRiderCode objectAtIndex:i]];
            }
            else {
                continue;
            }
            NSLog(@"SQL:%@",medPentaSQL);
            if (sqlite3_prepare_v2(contactDB, [medPentaSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    medPlanCodeRider =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    
                } else {
                    NSLog(@"error access PentaPlanCode");
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
        
        int ridTerm = [[LTerm objectAtIndex:i] intValue];
        [self getRiderRate:medPlanCodeRider riderTerm:ridTerm];
        
        double BasicSA = requestBasicSA;
        double ridSA = [[LSumAssured objectAtIndex:i] doubleValue];
        double riderHLoad;
        if ([LRidHL1K count] != 0) {
            riderHLoad = [[LRidHL1K objectAtIndex:i] doubleValue];
        }
        else if ([LRidHL100 count] != 0) {
            riderHLoad = [[LRidHL100 objectAtIndex:i] doubleValue];
        }
        else if ([LRidHLP count] != 0) {
            riderHLoad = [[LRidHLP objectAtIndex:i] doubleValue];
        }
        NSLog(@"riderRate:%d, ridersum:%.3f, HL:%.3f",riderRate,ridSA,riderHLoad);
        
        //calculate rider health loading
        double RiderHLAnnually = riderHLoad * (BasicSA/1000) * 1;
        double RiderHLHalfYear = riderHLoad * (BasicSA/1000) * 0.5125;
        double RiderHLQuarterly = riderHLoad * (BasicSA/1000) * 0.2625;
        double RiderHLMonthly = riderHLoad * (BasicSA/1000) * 0.0875;
        NSLog(@"RiderHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",RiderHLAnnually,RiderHLHalfYear,RiderHLQuarterly,RiderHLMonthly);
        
        double annualRider;
        double halfYearRider;
        double quarterRider;
        double monthlyRider;
        if ([[LRiderCode objectAtIndex:i] isEqualToString:@"MG_II"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"MG_IV"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"HSP_II"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"HMM"])
        {
            annualRider = riderRate * (1 + RiderHLAnnually/100) * 1;
            halfYearRider = riderRate * (1 + RiderHLHalfYear/100) * 0.5125;
            quarterRider = riderRate * (1 + RiderHLQuarterly/100) * 0.2625;
            monthlyRider = riderRate * (1 + RiderHLMonthly/100) * 0.0875;
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"HB"])
        {
            int selectUnit = [[LUnits objectAtIndex:i] intValue];
            annualRider = riderRate * (1 + RiderHLAnnually/100) * selectUnit * 1;
            halfYearRider = riderRate * (1 + RiderHLHalfYear/100) * selectUnit * 0.5125;
            quarterRider = riderRate * (1 + RiderHLQuarterly/100) * selectUnit * 0.2625;
            monthlyRider = riderRate * (1 + RiderHLMonthly/100) * selectUnit * 0.0875;
        }
        
        else {
            annualRider = 0;
            halfYearRider = 0;
            quarterRider = 0;
            monthlyRider = 0;
        }
        
        NSString *calRiderAnn = [NSString stringWithFormat:@"%.3f",annualRider];
        NSString *calRiderHalf = [NSString stringWithFormat:@"%.3f",halfYearRider];
        NSString *calRiderQuarter = [NSString stringWithFormat:@"%.3f",quarterRider];
        NSString *calRiderMonth = [NSString stringWithFormat:@"%.3f",monthlyRider];
        NSLog(@"cal(%@) A:%@ S:%@ Q:%@ M:%@",[LRiderCode objectAtIndex:i],calRiderAnn,calRiderHalf,calRiderQuarter,calRiderMonth);
        
        [annualMedRiderPrem addObject:calRiderAnn];
        [halfMedRiderPrem addObject:calRiderHalf];
        [quarterMedRiderPrem addObject:calRiderQuarter];
        [monthMedRiderPrem addObject:calRiderMonth];
    }
    annualMedRiderSum = 0;
    halfMedRiderSum = 0;
    quarterMedRiderSum = 0;
    monthMedRiderSum = 0;
    NSUInteger a;
    
    for (a=0; a<[annualMedRiderPrem count]; a++) {
        annualMedRiderSum = annualMedRiderSum + [[annualMedRiderPrem objectAtIndex:a] doubleValue];
        halfMedRiderSum = halfMedRiderSum + [[halfMedRiderPrem objectAtIndex:a] doubleValue];
        quarterMedRiderSum = quarterMedRiderSum + [[quarterMedRiderPrem objectAtIndex:a] doubleValue];
        monthMedRiderSum = monthMedRiderSum + [[monthMedRiderPrem objectAtIndex:a] doubleValue];
    }
    medRiderPrem = annualMedRiderSum;
    NSLog(@"medPrem:%.2f",medRiderPrem);
}


#pragma mark - Action

- (IBAction)btnPTypePressed:(id)sender
{
    if(![popOverConroller isPopoverVisible]){
        
		RiderPTypeTbViewController *popView = [[RiderPTypeTbViewController alloc] initWithString:SINoPlan];
        popView.requestSINo = SINoPlan;
		popOverConroller = [[UIPopoverController alloc] initWithContentViewController:popView];
        popView.delegate = self;
		
		[popOverConroller setPopoverContentSize:CGSizeMake(350.0f, 400.0f)];        
        [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else{
		[popOverConroller dismissPopoverAnimated:YES];
	}
}

- (IBAction)btnAddRiderPressed:(id)sender
{
    if(![popOverConroller isPopoverVisible]){
		RiderListTbViewController *popView = [[RiderListTbViewController alloc] init];
        popView.requestPtype = self.pTypeCode;
        popView.requestSeq = self.PTypeSeq;
		popOverConroller = [[UIPopoverController alloc] initWithContentViewController:popView];
        popView.delegate = self;
		
		[popOverConroller setPopoverContentSize:CGSizeMake(600.0f, 400.0f)];
        [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else{
		[popOverConroller dismissPopoverAnimated:YES];
	}
}

- (IBAction)planBtnPressed:(id)sender
{
    NSUInteger i;
    for (i=0; i<[FLabelCode count]; i++) {
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"PLOP"]] ||
                [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"PLCH"]]) {
            if(![popOverConroller isPopoverVisible]) {
                pressedPlan = YES;
                RiderFormTbViewController *popView = [[RiderFormTbViewController alloc] init];
                popView.requestCondition = [NSString stringWithFormat:@"%@",[FCondition objectAtIndex:i]];
                popOverConroller = [[UIPopoverController alloc] initWithContentViewController:popView];
                popView.delegate = self;
                
                [popOverConroller setPopoverContentSize:CGSizeMake(350.0f, 400.0f)];
                [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            } else {
                [popOverConroller dismissPopoverAnimated:YES];
                pressedPlan = NO;
            }
        }
    }
}

- (IBAction)deducBtnPressed:(id)sender
{
    NSUInteger i;
    for (i=0; i<[FLabelCode count]; i++) {
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"DEDUC"]]) {
            if(![popOverConroller isPopoverVisible]){
                pressedDeduc = YES;
                RiderFormTbViewController *popView = [[RiderFormTbViewController alloc] init];
                popView.requestCondition = [NSString stringWithFormat:@"%@",[FCondition objectAtIndex:i]];
                popOverConroller = [[UIPopoverController alloc] initWithContentViewController:popView];
                popView.delegate = self;
                
                [popOverConroller setPopoverContentSize:CGSizeMake(350.0f, 400.0f)];
                [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            } else {
                [popOverConroller dismissPopoverAnimated:YES];
                pressedDeduc = NO;
            }
        }
    }
}

- (IBAction)doSaveRider:(id)sender
{
    NSUInteger i;
    for (i=0; i<[FLabelCode count]; i++)
    {
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL1K"]]) {
            inputHL1KSA = [[NSString alloc]initWithFormat:@"%@",HLField.text];
        } else if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL10"]]) {
            inputHL100SA = [[NSString alloc]initWithFormat:@"%@",HLField.text];
        } else if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HLP"]]) {
            inputHLPercentage = [[NSString alloc]initWithFormat:@"%@",HLField.text];
        }
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL1KT"]]) {
            inputHL1KSATerm = [HLTField.text intValue];
        } else if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL10T"]]) {
            inputHL100SATerm = [HLTField.text intValue];
        } else if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HLPT"]]) {
            inputHLPercentageTerm = [HLTField.text intValue];
        }
    }
    
    if (riderCode.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select a Rider." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else if (term)
    {
        NSLog(@"validate - 1st term");
        [self validateTerm];
    } else if (sumA)
    {
        NSLog(@"validate - 2nd sum");
        [self validateSum];
    } else if (unit)
    {
        NSLog(@"validate - 3rd unit");
        [self validateUnit];
    }
    else {
        NSLog(@"validate - 4th save");
        [self validateSaver];
    }
}

- (IBAction)goBack:(id)sender
{
    MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
    main.modalPresentationStyle = UIModalPresentationFullScreen;
    main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    main.mainH = riderH;
    main.mainBH = riderBH;
    main.IndexTab = 3;
    [self presentModalViewController:main animated:YES];
}



#pragma mark - validate

-(void)validateTerm
{
    if (termField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([termField.text intValue] > maxRiderTerm) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Term must be less than or equal to %.f",maxRiderTerm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([termField.text intValue] < minTerm) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Term must be greater than or equal to %d",minTerm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([HLTField.text intValue] > [termField.text intValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Health Loading (per 1k SA) Term cannot be greater than %d",[termField.text intValue]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else if (sumA) {
        NSLog(@"validate - 1st sum");
        [self validateSum];
    } else if (unit) {
        NSLog(@"validate - 1st unit");
        [self validateUnit];
    } else {
        NSLog(@"validate - 1st save");
        [self validateSaver];
    }
}

-(void)validateSum
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    float num = [sumField.text floatValue];
    int riderSumA = num;
    float riderFraction = num - riderSumA;
    NSString *msg = [formatter stringFromNumber:[NSNumber numberWithFloat:riderFraction]];
    
    if (sumField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider Sum Assured is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([sumField.text intValue] < minSATerm && !(incomeRider)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Sum Assured must be greater than or equal to %d",minSATerm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([sumField.text intValue] < minSATerm && incomeRider) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Guaranteed Yearly Income must be greater than or equal to %d",minSATerm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([sumField.text intValue] > maxRiderSA && !(incomeRider)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Sum Assured must be less than or equal to %.f",maxRiderSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([sumField.text intValue] > maxRiderSA && incomeRider) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Guaranteed Yearly Income must be less than or equal to %.f",maxRiderSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (incomeRider && msg.length > 4) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Guaranteed Yearly Income only allow 2 decimal." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (unit) {
        NSLog(@"validate - 2nd unit");
        [self validateUnit];
    } else {
        NSLog(@"validate - 2nd save");
        [self validateSaver];
    }
}

-(void)validateUnit
{
    if (unitField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider Unit is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([unitField.text intValue] > 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider Unit must be in the range of 1 - 4" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        NSLog(@"validate - 3rd save");
        [self validateSaver];
    }
}

-(void)validateSaver
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
    float numHL = [HLField.text floatValue];
    int HLValue = numHL;
    float HLFraction = numHL - HLValue;
    NSString *msg = [formatter stringFromNumber:[NSNumber numberWithFloat:HLFraction]];
    
    float aaHL = HLValue/25;
    int bbHL = aaHL;
    float ccHL = aaHL - bbHL;
    NSString *msg2 = [formatter stringFromNumber:[NSNumber numberWithFloat:ccHL]];

    if (inputHLPercentage.length != 0 && [HLField.text intValue] > 500) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) cannot greater than 500%" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (inputHLPercentage.length != 0 && HLField.text.length != 0 && HLTField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (inputHL1KSA.length != 0 && [HLField.text intValue] > 10000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (Per 1k SA) cannot greater than 10000." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (inputHL1KSA.length != 0 && HLField.text.length != 0 && HLTField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (inputHL1KSA.length != 0 && msg.length > 4) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (Per 1k SA) only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (inputHLPercentage.length != 0 && msg.length > 1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) must not contains decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (inputHLPercentage.length != 0 && msg2.length > 1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) must be in multiple of 25 or 0." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (([riderCode isEqualToString:@"HMM"] && LRiderCode.count != 0)||([riderCode isEqualToString:@"HSP_II"] && LRiderCode.count != 0)||([riderCode isEqualToString:@"MG_II"] && LRiderCode.count != 0)||([riderCode isEqualToString:@"MG_IV"] && LRiderCode.count != 0)) {
        NSLog(@"go RoomBoard!");
        [self RoomBoard];
    }
    else {
        [self checkingRider];
        if (existRidCode.length == 0) {
            NSLog(@"will save rider");
            [self saveRider];
        } else {
            NSLog(@"will update rider");
            [self updateRider];
        }
    }
}

-(void)MHIGuideLines
{
    double totalPrem = basicPrem + riderPrem;
    double medicTotal = medRiderPrem * 2;
    
    if (medicTotal > totalPrem) {
        double minus = totalPrem - medRiderPrem;
        
        if (minus > 0) {
            double inc = minus * (requestBasicSA + 0.5);
            double varSA = medRiderPrem/inc;
            NSLog(@"%.f",varSA);
            
            //check attached riderSA except C+,CIR,MG_II,MG_IV,HB,HSP_II,HMM,CIWP,LCWP,PR,SP_STD,SP_PRE
            // if riderSA > 0
            //RiderSA = medRiderPrem/(minus * riderSA)
            //if RiderSA > MaxSA
            //set RiderSA = MaxSA
            
            //get NewRiderPrem except C+,CIR,MG_II,MG_IV,HB,HSP_II,HMM
            //get NewPrem
        }
    }
}

-(void)RoomBoard
{
    arrCombNo = [[NSMutableArray alloc] init];
    arrRBBenefit = [[NSMutableArray alloc] init];
    
    [self checkingRider];
    if (existRidCode.length == 0)
    {
        //validate as a new
        for (NSUInteger i=0; i<LRiderCode.count; i++)
        {
            if ([[LRiderCode objectAtIndex:i] isEqualToString:@"HMM"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"HSP_II"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"MG_II"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"MG_IV"])
            {
                medRiderCode = [LRiderCode objectAtIndex:i];
                medPlanOpt = [LPlanOpt objectAtIndex:i];
                
                [self getListCombNo];
                NSString *tempCombNo = [NSString stringWithFormat:@"%d",CombNo];
                [arrCombNo addObject:tempCombNo];
                
                [self getListRBBenefit];
                NSString *tempBenefit = [NSString stringWithFormat:@"%d",RBBenefit];
                [arrRBBenefit addObject:tempBenefit];
                
                NSLog(@"CombNo:%d, Benefit:%d Code:%@",CombNo,RBBenefit,[LRiderCode objectAtIndex:i]);
                
            } else {
                continue;
            }
        }
        
        //start combine validate
        //calculate existing benefit
        double allBenefit = 0;
        for (NSUInteger x=0; x<arrRBBenefit.count; x++) {
            allBenefit = allBenefit + [[arrRBBenefit objectAtIndex:x] doubleValue];
        }
        NSLog(@"total listBenefit:%.f",allBenefit);
        
        //get selected CombNo
        [self getCombNo];
        NSString *tempCombNo = [NSString stringWithFormat:@"%d",CombNo];
        [arrCombNo addObject:tempCombNo];
        
        //sort combNo
        NSSortDescriptor *aDesc = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
        [arrCombNo sortUsingDescriptors:[NSArray arrayWithObjects:aDesc, nil]];
        
        //combine all CombNo
        NSString *newComb =[[NSString alloc] init];
        for ( NSUInteger y=0; y<arrCombNo.count; y++) {
            newComb = [newComb stringByAppendingString:[arrCombNo objectAtIndex:y]];
        }
        AllCombNo = [newComb intValue];
        NSLog(@"newComb:%@",newComb);
        
        //get selected RBBenefit and calculate
        [self getRBBenefit];
        allBenefit = allBenefit + RBBenefit;
        NSLog(@"total allBenefit:%.f",allBenefit);
        
        //get Limit,RBGroup
        [self getRBLimit];
        
        if (allBenefit > RBLimit) {
            if (RBGroup == 1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Traditional" message:[NSString stringWithFormat:@"Total Daily Room & Board Benefit for combination of all MedGLOBAL and HSP II rider(s) must be less than or equal to RM%d for 1st LA.",RBLimit] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Traditional" message:[NSString stringWithFormat:@"Total Daily Room & Board Benefit for combination of all MedGLOBAL, HSP II and Major Medi rider(s) must be less than or equal to RM%d for 1st LA.",RBLimit] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        } else {
            NSLog(@"will continue save!");
            [self saveRider];
        }

    }
    else
    {
        //validate as existing
        NSLog(@"same medRider!");
        
        double allBenefit = 0;
        for (NSUInteger i=0; i<LRiderCode.count; i++)
        {
            if ([[LRiderCode objectAtIndex:i] isEqualToString:@"HMM"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"HSP_II"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"MG_II"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"MG_IV"])
            {
                medRiderCode = [LRiderCode objectAtIndex:i];
                medPlanOpt = [LPlanOpt objectAtIndex:i];
                
                [self getListCombNo];
                NSString *tempCombNo = [NSString stringWithFormat:@"%d",CombNo];
                [arrCombNo addObject:tempCombNo];
                
                [self getListRBBenefit];
                NSString *tempBenefit = [NSString stringWithFormat:@"%d",RBBenefit];
                [arrRBBenefit addObject:tempBenefit];
                NSLog(@"CombNo:%d, Benefit:%d Code:%@",CombNo,RBBenefit,[LRiderCode objectAtIndex:i]);
                
            } else {
                continue;
            }
        }
        
        for (NSUInteger m=0; m<LRiderCode.count; m++)
        {
            if ([[LRiderCode objectAtIndex:m] isEqualToString:riderCode]) {
                
                medRiderCode = [LRiderCode objectAtIndex:m];
                medPlanOpt = [LPlanOpt objectAtIndex:m];
                [self getListRBBenefit];
                
            } else {
                continue;
            }
        }
        
        //total up all benefit
        for (NSUInteger z=0; z<arrRBBenefit.count; z++) {
            allBenefit = allBenefit + [[arrRBBenefit objectAtIndex:z] doubleValue];
        }
        NSLog(@"currentBenefit:%.f",allBenefit);
        
        //minus benefit
        allBenefit = allBenefit - RBBenefit;
        NSLog(@"benefit:%d, newBenefit:%.f",RBBenefit,allBenefit);
        
        //sort combNo
        NSSortDescriptor *aDesc = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
        [arrCombNo sortUsingDescriptors:[NSArray arrayWithObjects:aDesc, nil]];
        
        //combine all CombNo
        NSString *newComb =[[NSString alloc] init];
        for ( NSUInteger h=0; h<arrCombNo.count; h++) {
            newComb = [newComb stringByAppendingString:[arrCombNo objectAtIndex:h]];
        }
        AllCombNo = [newComb intValue];
        NSLog(@"newComb:%@",newComb);
        
        //get selected RBBenefit and calculate
        [self getRBBenefit];
        allBenefit = allBenefit + RBBenefit;
        NSLog(@"allBenefit:%.f",allBenefit);
            
        //get Limit,RBGroup
        [self getRBLimit];
            
        if (allBenefit > RBLimit) {
            if (RBGroup == 1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Traditional" message:[NSString stringWithFormat:@"Total Daily Room & Board Benefit for combination of all MedGLOBAL and HSP II rider(s) must be less than or equal to RM%d for 1st LA.",RBLimit] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Traditional" message:[NSString stringWithFormat:@"Total Daily Room & Board Benefit for combination of all MedGLOBAL, HSP II and Major Medi rider(s) must be less than or equal to RM%d for 1st LA.",RBLimit] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        } else {
            NSLog(@"will update data");
            [self updateRider];
        }
    }
}

#pragma mark - Delegate

-(void)PTypeController:(RiderPTypeTbViewController *)inController didSelectCode:(NSString *)code seqNo:(NSString *)seq desc:(NSString *)desc
{
    pTypeCode = [[NSString alloc] initWithFormat:@"%@",code];
    PTypeSeq = [seq intValue];
    pTypeDesc = [[NSString alloc] initWithFormat:@"%@",desc];
    [self.btnPType setTitle:pTypeDesc forState:UIControlStateNormal];
    [popOverConroller dismissPopoverAnimated:YES];
//    NSLog(@"RIDERVC pType:%@, seq:%d, desc:%@",pTypeCode,PTypeSeq,pTypeDesc);
}

-(void)RiderListController:(RiderListTbViewController *)inController didSelectCode:(NSString *)code desc:(NSString *)desc
{
    
    //reset value existing
    if (riderCode != NULL) {
        term = NO;
        sumA = NO;
        plan = NO;
        unit = NO;
        deduc = NO;
        hload = NO;
        hloadterm = NO;
        planOption = nil;
        deductible = nil;
        inputHL100SA = nil;
        inputHL1KSA = nil;
        inputHLPercentage = nil;
        inputHL1KSATerm = 0;
        inputHL100SATerm = 0;
        inputHLPercentageTerm = 0;
        sumField.text = @"";
        termField.text = @"";
        HLField.text = @"";
        HLTField.text = @"";
        incomeRider = NO;
        
        [self.planBtn setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
        [self.deducBtn setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    }
    
    riderCode = [[NSString alloc] initWithFormat:@"%@",code];
    riderDesc = [[NSString alloc] initWithFormat:@"%@",desc];
    [self.btnAddRider setTitle:riderDesc forState:UIControlStateNormal];
    [popOverConroller dismissPopoverAnimated:YES];
    
    //validation part
    [self getOccpNotAttach];
    if ([atcRidCode count] != 0)
    {
        if ([riderCode isEqualToString:@"CPA"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider not available - does not meet underwriting rules" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self.btnAddRider setTitle:@"" forState:UIControlStateNormal];
        } else {
                [self getLabelForm];
                [self toggleForm];
                [self getRiderTermRule];
        }
    }
    else if ([LRiderCode count] != 0)
    {
        NSUInteger i;
        for (i=0; i<[LRiderCode count]; i++) {
            if ([riderCode isEqualToString:@"PTR"] && ![[LRiderCode objectAtIndex:i] isEqualToString:@"PR"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Rider PR before PTR" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else if ([riderCode isEqualToString:@"PLCP"] && ![[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Rider LCWP before PLCP." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else if (([riderCode isEqualToString:@"LCWP"]||[riderCode isEqualToString:@"PR"]||[riderCode isEqualToString:@"SP_PRE"]||[riderCode isEqualToString:@"SP_STD"]) && ([[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_PRE"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_STD"])) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select either PR, LCWP, WOP_SP(Standard) or WOP_SP(Premier)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                [self getLabelForm];
                [self toggleForm];
                [self getRiderTermRule];
            }
        }
    }
    else if (([riderCode isEqualToString:@"CPA"] && riderH.storedOccpClass < 1 && riderH.storedOccpClass > 4)||([riderCode isEqualToString:@"PA"] && riderH.storedOccpClass < 1 && riderH.storedOccpClass > 4)) {
        NSLog(@"Occpclass:%d",riderH.storedOccpClass);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider not available - does not meet underwriting rules" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.btnAddRider setTitle:@"" forState:UIControlStateNormal];
    }
    
    else {
        [self getLabelForm];
        [self toggleForm];
        [self getRiderTermRule];
    }
}

-(void) RiderFormController:(RiderFormTbViewController *)inController didSelectItem:(NSString *)item desc:(NSString *)itemdesc
{
    if (pressedPlan) {
        if ([atcRidCode count] != 0)
        {
            NSUInteger k;
            for (k=0; k<[atcRidCode count]; k++) {
                if ([riderCode isEqualToString:@"HMM"] && [[atcPlanChoice objectAtIndex:k] isEqualToString:itemdesc]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider not available - does not meet underwriting rules" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [self.planBtn setTitle:@"" forState:UIControlStateNormal];
                } else {
                    [self.planBtn setTitle:itemdesc forState:UIControlStateNormal];
                    planOption = [[NSString alloc] initWithFormat:@"%@",itemdesc];
                    NSLog(@"planoption:%@",planOption);
                    
//                    [self RoomBoard];
                }
            }
        }
        else {
            [self.planBtn setTitle:itemdesc forState:UIControlStateNormal];
            planOption = [[NSString alloc] initWithFormat:@"%@",itemdesc];
            NSLog(@"planoption:%@",planOption);
            
//            [self RoomBoard];
        }
    } else if (pressedDeduc) {
        [self.deducBtn setTitle:itemdesc forState:UIControlStateNormal];
        deductible = [[NSString alloc] initWithFormat:@"%@",itemdesc];
    }

    [popOverConroller dismissPopoverAnimated:YES];
    pressedPlan = NO;
    pressedDeduc = NO;
}


#pragma mark - DB handling

-(void)getLabelForm
{
    FLabelCode = [[NSMutableArray alloc] init];
    FLabelDesc = [[NSMutableArray alloc] init];
    FRidName = [[NSMutableArray alloc] init];
    FInputCode = [[NSMutableArray alloc] init];
    FTbName = [[NSMutableArray alloc] init];
    FFieldName = [[NSMutableArray alloc] init];
    FCondition = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT LabelCode,LabelDesc,RiderName,InputCode,TableName,FieldName,Condition FROM Trad_Sys_Rider_Label WHERE RiderCode=\"%@\"",riderCode];
    
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                [FLabelCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                [FLabelDesc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
                [FRidName addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
                [FInputCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)]];
                
                const char *tbname = (const char *)sqlite3_column_text(statement, 4);
                [FTbName addObject:tbname == NULL ? @"" : [[NSString alloc] initWithUTF8String:tbname]];
                
                const char *fieldname = (const char *)sqlite3_column_text(statement, 5);
                [FFieldName addObject:fieldname == NULL ? @"" :[[NSString alloc] initWithUTF8String:fieldname]];
                
                const char *condition = (const char *)sqlite3_column_text(statement, 6);
                [FCondition addObject:condition == NULL ? @"" :[[NSString alloc] initWithUTF8String:condition]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) getRiderTermRule
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT MinAge,MaxAge,ExpiryAge,MinTerm,MaxTerm,MinSA,MaxSA,MaxSAFactor FROM Trad_Sys_Rider_Mtn WHERE RiderCode=\"%@\"",riderCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                expAge =  sqlite3_column_int(statement, 2);
                minTerm =  sqlite3_column_int(statement, 3);
                maxTerm =  sqlite3_column_int(statement, 4);
                minSATerm = sqlite3_column_int(statement, 5);
                maxSATerm = sqlite3_column_int(statement, 6);
                NSLog(@"expiryAge:%d,minTerm:%d,maxTerm:%d,minSA:%d,maxSA:%d",expAge,minTerm,maxTerm,minSATerm,maxSATerm);
                
                [self calculateTerm];
                [self calculateSA];
                
            } else {
                NSLog(@"error access Trad_Mtn");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getGYI
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL;
        if (self.requestMOP == 6) {
            querySQL = [[NSString alloc] initWithFormat:
                        @"SELECT PremPayOpt_6 FROM Trad_Sys_GYI_HLAIB WHERE RiderCode=\"%@\" AND AgeFrom <=\"%d\" AND AgeTo >= \"%d\"",riderCode,self.requestAge,self.requestAge];

        } else if (self.requestMOP == 9) {
            querySQL = [[NSString alloc] initWithFormat:
                        @"SELECT PremPayOpt_9 FROM Trad_Sys_GYI_HLAIB WHERE RiderCode=\"%@\" AND AgeFrom <=\"%d\" AND AgeTo >= \"%d\"",riderCode,self.requestAge,self.requestAge];
        
        } else if (self.requestMOP == 12) {
            querySQL = [[NSString alloc] initWithFormat:
                        @"SELECT PremPayOpt_12 FROM Trad_Sys_GYI_HLAIB WHERE RiderCode=\"%@\" AND AgeFrom <=\"%d\" AND AgeTo >= \"%d\"",riderCode,self.requestAge,self.requestAge];
        }
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                GYI = sqlite3_column_int(statement, 0);
                NSLog(@"GYI:%d",GYI);
            } else {
                NSLog(@"error access Trad_Mtn");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)saveRider
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
        @"INSERT INTO Trad_Rider_Details (SINo,  RiderCode, PTypeCode, Seq, RiderTerm, SumAssured, PlanOption, Units, Deductible, HL1KSA, HL1KSATerm, HL100SA, HL100SATerm, HLPercentage, HLPercentageTerm, CreatedAt) VALUES"
        "(\"%@\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%@\", \"%d\", \"%@\", \"%d\", \"%@\")", SINoPlan,riderCode, pTypeCode, PTypeSeq, termField.text, sumField.text, planOption, unitField.text, deductible, inputHL1KSA, inputHL1KSATerm, inputHL100SA, inputHL100SATerm, inputHLPercentage, inputHL100SATerm, dateString];

        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Saved Rider!");
                [self getListingRider];
                
            } else {
                NSLog(@"Failed Save Rider!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getListingRider
{
    LRiderCode = [[NSMutableArray alloc] init];
    LSumAssured = [[NSMutableArray alloc] init];
    LTerm = [[NSMutableArray alloc] init];
    LPlanOpt = [[NSMutableArray alloc] init];
    LUnits = [[NSMutableArray alloc] init];
    LDeduct = [[NSMutableArray alloc] init];
    LRidHL1K = [[NSMutableArray alloc] init];
    LRidHL100 = [[NSMutableArray alloc] init];
    LRidHLP = [[NSMutableArray alloc] init];
    LSmoker = [[NSMutableArray alloc] init];
    LAge = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                @"SELECT a.RiderCode, a.SumAssured, a.RiderTerm, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, a.HL100SA, a.HLPercentage, c.Smoker, c.ALB FROM Trad_Rider_Details a, Trad_LAPayor b, Clt_Profile c WHERE a.PTypeCode=b.PTypeCode AND a.Seq=b.Sequence AND b.CustCode=c.CustCode AND a.SINo=b.SINo AND a.SINo=\"%@\"",SINoPlan];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [LRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                
                const char *aaRidSA = (const char *)sqlite3_column_text(statement, 1);
                [LSumAssured addObject:aaRidSA == NULL ? nil :[[NSString alloc] initWithUTF8String:aaRidSA]];
                
                const char *aaTerm = (const char *)sqlite3_column_text(statement, 2);
                [LTerm addObject:aaTerm == NULL ? nil :[[NSString alloc] initWithUTF8String:aaTerm]];
                
                const char *zzplan = (const char *) sqlite3_column_text(statement, 3);
                [LPlanOpt addObject:zzplan == NULL ? nil :[[NSString alloc] initWithUTF8String:zzplan]];
                
                const char *aaUnit = (const char *)sqlite3_column_text(statement, 4);
                [LUnits addObject:aaUnit == NULL ? nil :[[NSString alloc] initWithUTF8String:aaUnit]];
                
                const char *deduct2 = (const char *) sqlite3_column_text(statement, 5);
                [LDeduct addObject:deduct2 == NULL ? nil :[[NSString alloc] initWithUTF8String:deduct2]];
                
                const char *ridHL = (const char *)sqlite3_column_text(statement, 6);
                [LRidHL1K addObject:ridHL == NULL ? nil :[[NSString alloc] initWithUTF8String:ridHL]];
                
                const char *ridHL100 = (const char *)sqlite3_column_text(statement, 7);
                [LRidHL100 addObject:ridHL100 == NULL ? nil :[[NSString alloc] initWithUTF8String:ridHL100]];
                
                const char *ridHLP = (const char *)sqlite3_column_text(statement, 8);
                [LRidHLP addObject:ridHLP == NULL ? nil :[[NSString alloc] initWithUTF8String:ridHLP]];
                
                [LSmoker addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)]];
                [LAge addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)]];
            }
            
            if ([LRiderCode count] == 0) {
                myTableView.hidden = YES;
                titleRidCode.hidden = YES;
                titleSA.hidden = YES;
                titleTerm.hidden = YES;
                titleUnit.hidden = YES;
            } else {
                myTableView.hidden = NO;
                titleRidCode.hidden = NO;
                titleSA.hidden = NO;
                titleTerm.hidden = NO;
                titleUnit.hidden = NO;
                
                /*
                [self getBasicPentaRate];
                [self calculateBasicPremium];
                [self calculateRiderPrem];
                [self calculateMedRiderPrem];
                 */
            }
            
            [self.myTableView reloadData];
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getListingRider2
{
    LTRiderCode = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.RiderCode, a.SumAssured, a.RiderTerm, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, a.HL100SA, a.HLPercentage, c.Smoker, c.ALB FROM Trad_Rider_Details a, Trad_LAPayor b, Clt_Profile c WHERE a.PTypeCode=b.PTypeCode AND a.Seq=b.Sequence AND b.CustCode=c.CustCode AND a.SINo=b.SINo AND a.SINo=\"%@\"",SINoPlan];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [LTRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getOccpNotAttach
{
    atcRidCode = [[NSMutableArray alloc] init];
    atcPlanChoice = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT RiderCode,PlanChoice FROM Trad_Sys_Occp_NotAttach WHERE OccpCode=\"%@\"",[self.requestOccpCode description]];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char *zzRidCode = (const char *)sqlite3_column_text(statement, 0);
                [atcRidCode addObject:zzRidCode == NULL ? nil :[[NSString alloc] initWithUTF8String:zzRidCode]];
                
                const char *zzPlan = (const char *)sqlite3_column_text(statement, 1);
                [atcPlanChoice addObject:zzPlan == NULL ? nil :[[NSString alloc] initWithUTF8String:zzPlan]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkingRider
{
    existRidCode = [[NSString alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT RiderCode,SumAssured,RiderTerm,Units FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\" AND PTypeCode=\"%@\" AND Seq=\"%d\"",SINoPlan,riderCode,pTypeCode, PTypeSeq];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                existRidCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateRider
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *updatetSQL = [NSString stringWithFormat:
                               @"UPDATE Trad_Rider_Details SET RiderTerm=\"%@\", SumAssured=\"%@\", PlanOption=\"%@\", Units=\"%@\", Deductible=\"%@\", HL1KSA=\"%@\", HL1KSATerm=\"%d\", HL100SA=\"%@\", HL100SATerm=\"%d\", HLPercentage=\"%@\", HLPercentageTerm=\"%d\", CreatedAt=\"%@\" WHERE SINo=\"%@\" AND RiderCode=\"%@\" AND PTypeCode=\"%@\" AND Seq=\"%d\"",termField.text, sumField.text, planOption, unitField.text, deductible, inputHL1KSA, inputHL1KSATerm, inputHL100SA, inputHL100SATerm, inputHLPercentage, inputHL100SATerm, dateString,SINoPlan,riderCode,pTypeCode, PTypeSeq];
            
        if(sqlite3_prepare_v2(contactDB, [updatetSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                [self getListingRider];
                NSLog(@"Update Rider success!");
            } else {
                NSLog(@"Update Rider failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getOccLoad
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                    @"SELECT Class,PA_CPA,OccLoading_TL FROM Adm_Occp_Loading_Penta WHERE OccpCode=\"%@\"",[self.requestOccpCode description]];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occClass = sqlite3_column_int(statement, 0);
                occCPA = sqlite3_column_int(statement, 1);
                occLoad =  sqlite3_column_int(statement, 2);
                
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) getMaxRiderTerm
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                @"SELECT  max(RiderTerm) as term FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode !=\"I20R\" AND RiderCode !=\"I30R\" AND RiderCode !=\"I40R\" AND RiderCode !=\"ID20R\" AND RiderCode !=\"ID30R\" AND RiderCode !=\"ID40R\" AND RiderCode !=\"CIWP\" AND RiderCode !=\"LCWP\" AND RiderCode !=\"PR\" AND RiderCode !=\"PLCP\" AND RiderCode !=\"PTR\" AND RiderCode !=\"SP_STD\" AND RiderCode !=\"SP_PRE\"",SINoPlan];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                storedMaxTerm = sqlite3_column_int(statement, 0);
                
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getBasicPentaRate
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Basic_Prem WHERE PlanCode=\"%@\" AND FromTerm=\"%d\" AND FromMortality=0",[self.requestPlanCode description],requestCoverTerm];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicRate =  sqlite3_column_int(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Basic_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getLSDRate
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LSD FROM Trad_Sys_LSD_HLAIB WHERE PremPayOpt=\"%d\" AND FromSA <=\"%d\" AND ToSA >= \"%d\"",self.requestMOP,requestBasicSA,requestBasicSA];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                LSDRate =  sqlite3_column_int(statement, 0);
                
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRate:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE PlanCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND Sex=\"%@\"",aaplan,aaterm,aaterm,riderH.storedSex];
        NSLog(@"%@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_int(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Rider_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getIncomeRiderRate:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE PlanCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\"",aaplan,aaterm,aaterm,riderH.storedAge,riderH.storedAge];
        
        NSLog(@"%@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_int(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Rider_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getCPARiderRate:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE PlanCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0",aaplan,aaterm,aaterm];
        
        NSLog(@"%@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_int(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Rider_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getPARiderRate:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE PlanCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\"",aaplan,aaterm,aaterm,riderH.storedAge,riderH.storedAge];
        
        NSLog(@"%@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_int(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Rider_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getOccpCatCode
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT OccpCatCode FROM Adm_OccpCat_Occp WHERE OccpCode=\"%@\"",requestOccpCode];

        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                OccpCat = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                OccpCat = [OccpCat stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSLog(@"occpCat:\"%@\"",OccpCat);
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getCombNo
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT CombNo FROM Trad_Sys_Medical_MST WHERE RiderCode=\"%@\"",riderCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CombNo =  sqlite3_column_int(statement, 0);
//                NSLog(@"CombNo:%d",CombNo);
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getListCombNo
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT CombNo FROM Trad_Sys_Medical_MST WHERE RiderCode=\"%@\"",medRiderCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CombNo =  sqlite3_column_int(statement, 0);
//                NSLog(@"listCombNo:%d",CombNo);
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRBBenefit
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT RBBenefit from Trad_Sys_Medical_Benefit WHERE RiderCode=\"%@\" AND PlanChoice=\"%@\"",riderCode,planOption];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                RBBenefit =  sqlite3_column_int(statement, 0);
//                NSLog(@"Benefit:%d",RBBenefit);
                
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getListRBBenefit
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT RBBenefit from Trad_Sys_Medical_Benefit WHERE RiderCode=\"%@\" AND PlanChoice=\"%@\"",medRiderCode,medPlanOpt];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                RBBenefit =  sqlite3_column_int(statement, 0);
//                NSLog(@"Benefit:%d",RBBenefit);
                
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRBLimit
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
            @"SELECT `Limit`, RBGroup from Trad_Sys_Medical_Comb WHERE OccpCode=\"%@\" AND Comb=\"%d\"",OccpCat,AllCombNo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                RBLimit =  sqlite3_column_int(statement, 0);
                RBGroup =  sqlite3_column_int(statement, 1);
                NSLog(@"Limit:%d, group:%d",RBLimit,RBGroup);
                
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getTempListRider
{
    TRiderCode = [[NSMutableArray alloc] init];
    TPlanOpt = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.RiderCode, a.PlanOption FROM Trad_Rider_Details a, Trad_LAPayor b, Clt_Profile c WHERE a.PTypeCode=b.PTypeCode AND a.Seq=b.Sequence AND b.CustCode=c.CustCode AND a.SINo=b.SINo AND a.SINo=\"%@\" AND a.RiderCode != \"%@\"",SINoPlan,riderCode];
//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [TRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                
                const char *zzplan = (const char *) sqlite3_column_text(statement, 1);
                [TPlanOpt addObject:zzplan == NULL ? nil :[[NSString alloc] initWithUTF8String:zzplan]];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
    return [LRiderCode count];
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    CGRect frame=CGRectMake(0,0, 177, 50);
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=frame;
    label1.text= [LRiderCode objectAtIndex:indexPath.row];
    label1.textAlignment = UITextAlignmentCenter;
    label1.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:label1];
    
    CGRect frame2=CGRectMake(177,0, 177, 50);
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=frame2;
    label2.text= [LSumAssured objectAtIndex:indexPath.row];
    label2.textAlignment = UITextAlignmentCenter;
    label2.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:label2];
    
    CGRect frame3=CGRectMake(354,0, 177, 50);
    UILabel *label3=[[UILabel alloc]init];
    label3.frame=frame3;
    label3.text= [LTerm objectAtIndex:indexPath.row];
    label3.textAlignment = UITextAlignmentCenter;
    label3.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:label3];
    
    CGRect frame4=CGRectMake(531,0, 177, 50);
    UILabel *label4=[[UILabel alloc]init];
    label4.frame=frame4;
    label4.text= [LUnits objectAtIndex:indexPath.row];
    label4.textAlignment = UITextAlignmentCenter;
    label4.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:label4];
    /*
    CGRect frame5=CGRectMake(800,0, 200, 50);
    UILabel *label5=[[UILabel alloc]init];
    label5.frame=frame5;
    label5.text= [List objectAtIndex:indexPath.row];
    label5.textAlignment = UITextAlignmentCenter;
    label5.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:label5];
    
    CGRect frame6=CGRectMake(850,0, 150, 50);
    UILabel *label6=[[UILabel alloc]init];
    label6.frame=frame6;
    label6.text= [List objectAtIndex:indexPath.row];
    label6.textAlignment = UITextAlignmentCenter;
    label6.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:label6];
    */
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
}


#pragma mark - Memory Management

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOverConroller = nil;
}

- (void)viewDidUnload
{
    [self setMedRiderCode:nil];
    [self setInputHL1KSA:nil];
    [self setInputHL100SA:nil];
    [self setInputHLPercentage:nil];
    [self setPlanOption:nil];
    [self setDeductible:nil];
    [self setPlanCode:nil];
    [self setRequestPlanCode:nil];
    [self setRequestSINo:nil];
    [self setBtnPType:nil];
    [self setBtnAddRider:nil];
    [self setPTypeCode:nil];
    [self setPTypeDesc:nil];
    [self setRiderCode:nil];
    [self setRiderDesc:nil];
    [self setFLabelCode:nil];
    [self setFLabelDesc:nil];
    [self setFRidName:nil];
    [self setFTbName:nil];
    [self setFInputCode:nil];
    [self setFFieldName:nil];
    [self setFCondition:nil];
    [self setTermLabel:nil];
    [self setSumLabel:nil];
    [self setPlanLabel:nil];
    [self setCpaLabel:nil];
    [self setUnitLabel:nil];
    [self setOccpLabel:nil];
    [self setHLLabel:nil];
    [self setHLTLabel:nil];
    [self setTermField:nil];
    [self setSumField:nil];
    [self setCpaField:nil];
    [self setUnitField:nil];
    [self setOccpField:nil];
    [self setHLField:nil];
    [self setHLTField:nil];
    [self setPlanBtn:nil];
    [self setDeducBtn:nil];
    [self setMinDisplayLabel:nil];
    [self setMaxDisplayLabel:nil];
    [self setRequestOccpCode:nil];
    [self setMyTableView:nil];
    [self setTitleRidCode:nil];
    [self setTitleSA:nil];
    [self setTitleTerm:nil];
    [self setTitleUnit:nil];
    [self setExistRidCode:nil];
    [self setPlanCodeRider:nil];
    [self setMedPlanCodeRider:nil];
    [self setMedPentaSQL:nil];
    [self setAnnualMedRiderPrem:nil];
    [self setQuarterMedRiderPrem:nil];
    [self setHalfMedRiderPrem:nil];
    [self setMonthMedRiderPrem:nil];
    [self setPentaSQL:nil];
    [self setPlnOptC:nil];
    [self setPlanOptHMM:nil];
    [self setDeducHMM:nil];
    [self setPlanHSPII:nil];
    [self setPlanMGII:nil];
    [self setPlanMGIV:nil];
    [self setArrCombNo:nil];
    [super viewDidUnload];
}

@end
