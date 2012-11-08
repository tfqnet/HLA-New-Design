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
#import "ColorHexCode.h"

#import "MainScreen.h"

@interface RiderViewController ()

@end

@implementation RiderViewController
@synthesize titleRidCode;
@synthesize titleSA;
@synthesize titleTerm;
@synthesize titleUnit;
@synthesize titleClass;
@synthesize titleLoad;
@synthesize titleHL1K;
@synthesize titleHL100;
@synthesize titleHLP;
@synthesize editBtn;
@synthesize deleteBtn;
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
@synthesize arrCombNo,AllCombNo,medPlanOpt,arrRBBenefit;
@synthesize RiderList = _RiderList;
@synthesize RiderListPopover = _RiderListPopover;
@synthesize dataInsert,LSex,sex,age,_maxRiderSA;

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
    requestBasicSA = [riderBH.storedbasicSA doubleValue];
    requestOccpCode = riderBH.storedOccpCode;
    requestMOP = riderBH.storedMOP;
    NSLog(@"Rider-Sum:%.2f,Age:%d,covered:%d,SINo:%@ planCode:%@",requestBasicSA,requestAge,requestCoverTerm,requestSINo,requestPlanCode);
    
    deducBtn.hidden = YES;
    deleteBtn.hidden = TRUE;
    deleteBtn.enabled = FALSE;
    SINoPlan = [[NSString alloc] initWithFormat:@"%@",[self.requestSINo description]];
    planCode = [[NSString alloc] initWithFormat:@"%@",[self.requestPlanCode description]];
    incomeRider = NO;
    PtypeChange = NO;
    
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
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    CGRect frame=CGRectMake(0,411, 100, 50);
    titleRidCode.frame = frame;
    titleRidCode.textAlignment = UITextAlignmentCenter;
    titleRidCode.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleRidCode.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame2=CGRectMake(100,411, 129, 50);
    titleSA.frame = frame2;
    titleSA.textAlignment = UITextAlignmentCenter;
    titleSA.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleSA.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame3=CGRectMake(229,411, 62, 50);
    titleTerm.frame = frame3;
    titleTerm.textAlignment = UITextAlignmentCenter;
    titleTerm.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleTerm.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame4=CGRectMake(291,411, 62, 50);
    titleUnit.frame = frame4;
    titleUnit.textAlignment = UITextAlignmentCenter;
    titleUnit.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleUnit.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame5=CGRectMake(353,411, 62, 50);
    titleClass.frame = frame5;
    titleClass.textAlignment = UITextAlignmentCenter;
    titleClass.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleClass.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];

    CGRect frame6=CGRectMake(415,411, 62, 50);
    titleLoad.frame = frame6;
    titleLoad.textAlignment = UITextAlignmentCenter;
    titleLoad.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleLoad.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame7=CGRectMake(477,411, 84, 50);
    titleHL1K.frame = frame7;
    titleHL1K.textAlignment = UITextAlignmentCenter;
    titleHL1K.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleHL1K.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame8=CGRectMake(561,411, 84, 50);
    titleHL100.frame = frame8;
    titleHL100.textAlignment = UITextAlignmentCenter;
    titleHL100.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleHL100.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame9=CGRectMake(645,411, 84, 50);
    titleHLP.frame = frame9;
    titleHLP.textAlignment = UITextAlignmentCenter;
    titleHLP.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleHLP.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    [self getBasicPentaRate];
    [self getOccLoad];
    [self getOccpCatCode];
    [self getLSDRate];
    NSLog(@"basicRate:%d,lsdRate:%d,pa_cpa:%d",basicRate,LSDRate,occLoad);
    
    [self calculateBasicPremium];
    
    [self getListingRider];
    myTableView.rowHeight = 50;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.opaque = NO;
    myTableView.backgroundView = nil;
    [self.view addSubview:myTableView];
    
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
//        double maxRiderTerm2 = fmax(requestCoverTerm,storedMaxTerm);
        maxRiderTerm = fmin(maxRiderTerm1,maxRiderTerm2);
        
        if (maxRiderTerm < minTerm) {
            maxRiderTerm = maxTerm;
        }
    }
    
    else if ([riderCode isEqualToString:@"I20R"]||[riderCode isEqualToString:@"I30R"]||[riderCode isEqualToString:@"I40R"] || [riderCode isEqualToString:@"IE20R"] || [riderCode isEqualToString:@"IE30R"] ) //edited by heng
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
    double dblPseudoBSA = self.requestBasicSA / 0.05;
    double dblPseudoBSA2 = dblPseudoBSA * 0.1;
    double dblPseudoBSA3 = dblPseudoBSA * 5;
    double dblPseudoBSA4 = dblPseudoBSA * 2;
    
//    NSLog(@"dblPseudoBSA:%.f, dblPseudoBSA3:%.f",maxRiderSA,dblPseudoBSA3);
    
    if ([riderCode isEqualToString:@"CCTR"])
    {
        _maxRiderSA = dblPseudoBSA3;
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
        
    }
    else if ([riderCode isEqualToString:@"ETPD"])
    {
        _maxRiderSA = fmin(dblPseudoBSA2,120000);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
        NSLog(@"maxEtpd:%.f",maxRiderSA);
    }
    else if ([riderCode isEqualToString:@"I20R"]||[riderCode isEqualToString:@"I30R"]||[riderCode isEqualToString:@"I40R"]||[riderCode isEqualToString:@"ID20R"]||[riderCode isEqualToString:@"ID30R"]||[riderCode isEqualToString:@"ID40R"]||[riderCode isEqualToString:@"IE20R"]||[riderCode isEqualToString:@"IE30R"])
    {
        NSLog(@"enter gyi");
        [self getGYI];
        double BasicSA_GYI = self.requestBasicSA * GYI;
        _maxRiderSA = fmin(BasicSA_GYI,9999999);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    else if ([riderCode isEqualToString:@"CPA"]) {
        if (riderH.storedOccpClass == 1 || riderH.storedOccpClass == 2) {
            if (dblPseudoBSA < 100000) {
                _maxRiderSA = fmin(dblPseudoBSA3,200000);
                NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.f",_maxRiderSA];
                maxRiderSA = [a_maxRiderSA doubleValue];
            }
            else if (dblPseudoBSA >= 100000) {
                _maxRiderSA = fmin(dblPseudoBSA4,1000000);
                NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.f",_maxRiderSA];
                maxRiderSA = [a_maxRiderSA doubleValue];
            }
        }
        else if (riderH.storedOccpClass == 3 || riderH.storedOccpClass == 4) {
            _maxRiderSA = fmin(dblPseudoBSA3,100000);
            NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.f",_maxRiderSA];
            maxRiderSA = [a_maxRiderSA doubleValue];
        }
    }
    else if ([riderCode isEqualToString:@"PA"]) {
        _maxRiderSA = fmin(dblPseudoBSA3,1000000);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    
    else {
        _maxRiderSA = maxSATerm;
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
}

-(void)calculateBasicPremium
{
    double BasicSA = requestBasicSA;
    double PolicyTerm = requestCoverTerm;
    double BasicHLoad = [riderBH.storedbasicHL intValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    //calculate basic premium
    double _BasicAnnually = basicRate * (BasicSA/1000) * 1;
    double _BasicHalfYear = basicRate * (BasicSA/1000) * 0.5125;
    double _BasicQuarterly = basicRate * (BasicSA/1000) * 0.2625;
    double _BasicMonthly = basicRate * (BasicSA/1000) * 0.0875;
    NSString *BasicAnnually = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicAnnually]];
    NSString *BasicHalfYear = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicHalfYear]];
    NSString *BasicQuarterly = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicQuarterly]];
    NSString *BasicMonthly = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicMonthly]];
    double BasicAnnually_ = [[BasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicHalfYear_ = [[BasicHalfYear stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicQuarterly_ = [[BasicQuarterly stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicMonthly_ = [[BasicMonthly stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    NSLog(@"Basic A:%.3f, S:%.3f, Q:%.3f, M:%.3f",_BasicAnnually,_BasicHalfYear,_BasicQuarterly,_BasicQuarterly);
    
    //calculate occupationLoading
    double _OccpLoadA = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 1;
    double _OccpLoadH = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.5125;
    double _OccpLoadQ = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.2625;
    double _OccpLoadM = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.0875;
    NSString *OccpLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadA]];
    NSString *OccpLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadH]];
    NSString *OccpLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadQ]];
    NSString *OccpLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadM]];
    double OccpLoadA_ = [[OccpLoadA stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double OccpLoadH_ = [[OccpLoadH stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double OccpLoadQ_ = [[OccpLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double OccpLoadM_ = [[OccpLoadM stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    NSLog(@"OccpLoad A:%.3f, S:%.3f, Q:%.3f, M:%.3f",_OccpLoadA,_OccpLoadH,_OccpLoadQ,_OccpLoadM);
    
    //calculate basic health loading
    double _BasicHLAnnually = BasicHLoad * (BasicSA/1000) * 1;
    double _BasicHLHalfYear = BasicHLoad * (BasicSA/1000) * 0.5125;
    double _BasicHLQuarterly = BasicHLoad * (BasicSA/1000) * 0.2625;
    double _BasicHLMonthly = BasicHLoad * (BasicSA/1000) * 0.0875;
    NSString *BasicHLAnnually = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicHLAnnually]];
    NSString *BasicHLHalfYear = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicHLHalfYear]];
    NSString *BasicHLQuarterly = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicHLQuarterly]];
    NSString *BasicHLMonthly = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicHLMonthly]];
    double BasicHLAnnually_ = [[BasicHLAnnually stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicHLHalfYear_ = [[BasicHLHalfYear stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicHLQuarterly_ = [[BasicHLQuarterly stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicHLMonthly_ = [[BasicHLMonthly stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    NSLog(@"BasicHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",_BasicHLAnnually,_BasicHLHalfYear,_BasicHLQuarterly,_BasicHLMonthly);
    
    //calculate LSD
    double _LSDAnnually = LSDRate * (BasicSA/1000) * 1;
    double _LSDHalfYear = LSDRate * (BasicSA/1000) * 0.5125;
    double _LSDQuarterly = LSDRate * (BasicSA/1000) * 0.2625;
    double _LSDMonthly = LSDRate * (BasicSA/1000) * 0.0875;
    NSString *LSDAnnually2 = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDAnnually]];
    NSString *LSDHalfYear2 = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDHalfYear]];
    NSString *LSDQuarterly2 = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDQuarterly]];
    NSString *LSDMonthly2 = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDMonthly]];
    //for negative value
    LSDAnnually2 = [LSDAnnually2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    LSDHalfYear2 = [LSDHalfYear2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    LSDQuarterly2 = [LSDQuarterly2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    LSDMonthly2 = [LSDMonthly2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    LSDAnnually2 = [LSDAnnually2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    LSDHalfYear2 = [LSDHalfYear2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    LSDQuarterly2 = [LSDQuarterly2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    LSDMonthly2 = [LSDMonthly2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    double LSDAnnually_ = [[LSDAnnually2 stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double LSDHalfYear_ = [[LSDHalfYear2 stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double LSDQuarterly_ = [[LSDQuarterly2 stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double LSDMonthly_ = [[LSDMonthly2 stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    NSLog(@"LSD A:%.3f, S:%.3f, Q:%.3f, M:%.3f",_LSDAnnually,_LSDHalfYear,_LSDQuarterly,_LSDMonthly);
    NSLog(@"LSD A:%@, S:%@, Q:%@, M:%@",LSDAnnually2,LSDHalfYear2,LSDQuarterly2,LSDMonthly2);
    NSLog(@"LSD A:%.2f, S:%.2f, Q:%.2f, M:%.2f",LSDAnnually_,LSDHalfYear_,LSDQuarterly_,LSDMonthly_);
    
    //calculate Total basic premium
    double _basicTotalA;
    double _basicTotalS;
    double _basicTotalQ;
    double _basicTotalM;
    if (BasicSA < 1000) {
        _basicTotalA = BasicAnnually_ + OccpLoadA_ + BasicHLAnnually_ + LSDAnnually_;
        _basicTotalS = BasicHalfYear_ + OccpLoadH_ + BasicHLHalfYear_ + LSDHalfYear_;
        _basicTotalQ = BasicQuarterly_ + OccpLoadQ_ + BasicHLQuarterly_ + LSDQuarterly_;
        _basicTotalM = BasicMonthly_ + OccpLoadM_ + BasicHLMonthly_ + LSDMonthly_;
        
    } else {
        _basicTotalA = BasicAnnually_ + OccpLoadA_ + BasicHLAnnually_ - LSDAnnually_;
        _basicTotalS = BasicHalfYear_ + OccpLoadH_ + BasicHLHalfYear_ - LSDHalfYear_;
        _basicTotalQ = BasicQuarterly_ + OccpLoadQ_ + BasicHLQuarterly_ - LSDQuarterly_;
        _basicTotalM = BasicMonthly_ + OccpLoadM_ + BasicHLMonthly_ - LSDMonthly_;
    }
    
    NSString *basicTotalA = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalA]];
    NSLog(@"BasicTotal A:%.3f, S:%.3f, Q:%.3f, M:%.3f",_basicTotalA,_basicTotalS,_basicTotalQ,_basicTotalM);
    
    basicPrem = [[basicTotalA stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
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
                if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"Level"]) {
                    plnOptC = @"L";
                } else if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"Increasing"]) {
                    plnOptC = @"I";
                } else if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"Level_NCB"]) {
                    plnOptC = @"B";
                } else if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"Increasing_NCB"]) {
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
            //            NSLog(@"%@",pentaSQL);
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
        age = [[LAge objectAtIndex:i] intValue];
        sex = [[NSString alloc] initWithFormat:@"%@",[LSex objectAtIndex:i]];
        //get rate
        if ([[LRiderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"I40R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"ID20R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"ID30R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"ID40R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"IE20R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"IE30R"])
        {
            [self getRiderRateAge:planCodeRider riderTerm:ridTerm];
        }
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"CPA"]) {
            [self getRiderRateClass:planCodeRider riderTerm:ridTerm];
        }
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"PA"]) {
            [self getRiderRateAgeClass:planCodeRider riderTerm:ridTerm];
        }
        else {
            [self getRiderRateAgeSex:planCodeRider riderTerm:ridTerm];
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
        NSLog(@"riderRate:%.2f, ridersum:%.3f, riderHL:%.3f, basicHL:%.3f",riderRate,ridSA,riderHLoad,BasicHLoad);
        
        double annFac;
        double halfFac;
        double quarterFac;
        double monthFac;
        if ([[LRiderCode objectAtIndex:i] isEqualToString:@"PA"]) {
            annFac = 1;
            halfFac = 0.5;
            quarterFac = 0.25;
            monthFac = ((double)1)/12;
        }
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"HB"]) {
            annFac = 1;
            halfFac = 0.55;
            quarterFac = 0.3;
            monthFac = 0.1;
        }
        else {
            annFac = 1;
            halfFac = 0.5125;
            quarterFac = 0.2625;
            monthFac = 0.0875;
        }
        NSLog(@"fac1:%.5f,fac2:%.5f,fac3:%.5f,fac4:%.5f",annFac,halfFac,quarterFac,monthFac);
        
        //calculate occupationLoading
        double OccpLoadA = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * annFac;
        double OccpLoadH = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * halfFac;
        double OccpLoadQ = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * quarterFac;
        double OccpLoadM = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * monthFac;
        
        //calculate rider health loading
        double RiderHLAnnually = riderHLoad * (BasicSA/1000) * annFac;
        double RiderHLHalfYear = riderHLoad * (BasicSA/1000) * halfFac;
        double RiderHLQuarterly = riderHLoad * (BasicSA/1000) * quarterFac;
        double RiderHLMonthly = riderHLoad * (BasicSA/1000) * monthFac;
        NSLog(@"RiderHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",RiderHLAnnually,RiderHLHalfYear,RiderHLQuarterly,RiderHLMonthly);
        
        double annualRider;
        double halfYearRider;
        double quarterRider;
        double monthlyRider;
        if ([[LRiderCode objectAtIndex:i] isEqualToString:@"ETPD"])
        {
            double fsar = (65 - self.requestAge) * ridSA;
            annualRider = (riderRate *ridSA /100 *annFac) + (RiderHLAnnually /10 *ridSA /100 *annFac) + (fsar /1000 *OccpLoadA *annFac);
            halfYearRider = (riderRate *ridSA /100 *halfFac) + (RiderHLHalfYear /10 *ridSA /100 *halfFac) + (fsar /1000 *OccpLoadH *halfFac);
            quarterRider = (riderRate *ridSA /100 *quarterFac) + (RiderHLQuarterly /10 *ridSA /100 *quarterFac) + (fsar /1000 *OccpLoadQ *quarterFac);
            monthlyRider = (riderRate *ridSA /100 *monthFac) + (RiderHLMonthly /10 *ridSA /100 *monthFac) + (fsar /1000 *OccpLoadM *monthFac);
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"I40R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"IE20R"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"IE30R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm + 1)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm + 1)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm + 1)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm + 1)/2);
            annualRider = (riderRate *ridSA /1000 *annFac) + (occLoadFactorA *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + (occLoadFactorH *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + (occLoadFactorQ *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + (occLoadFactorM *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"ICR"])
        {
            annualRider = (riderRate *ridSA /1000 *annFac) + ((OccpLoadA *ridTerm) *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + ((OccpLoadH *ridTerm) *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + ((OccpLoadQ *ridTerm) *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + ((OccpLoadM *ridTerm) *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"ID20R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm - 20)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm - 20)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm - 20)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm - 20)/2);
            annualRider = (riderRate *ridSA /1000 *annFac) + (occLoadFactorA *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + (occLoadFactorH *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + (occLoadFactorQ *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + (occLoadFactorM *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"ID30R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm - 30)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm - 30)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm - 30)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm - 30)/2);
            annualRider = (riderRate *ridSA /1000 *annFac) + (occLoadFactorA *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + (occLoadFactorH *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + (occLoadFactorQ *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + (occLoadFactorM *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"ID40R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm - 40)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm - 40)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm - 40)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm - 40)/2);
            annualRider = (riderRate *ridSA /1000 *annFac) + (occLoadFactorA *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + (occLoadFactorH *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + (occLoadFactorQ *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + (occLoadFactorM *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"CIWP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_STD"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_PRE"])
        {
            double RiderHLAnnually = BasicHLoad * (BasicSA/1000) * annFac;
            double RiderHLHalfYear = BasicHLoad * (BasicSA/1000) * halfFac;
            double RiderHLQuarterly = BasicHLoad * (BasicSA/1000) * quarterFac;
            double RiderHLMonthly = BasicHLoad * (BasicSA/1000) * monthFac;
            
            annualRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadA + RiderHLAnnually/100) * annFac;
            halfYearRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadH + RiderHLHalfYear/100) * halfFac;
            annualRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadQ + RiderHLQuarterly/100) * quarterFac;
            annualRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadM + RiderHLMonthly/100) * monthFac;
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"PLCP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PTR"])
        {
            double RiderHLAnnually = BasicHLoad * (BasicSA/1000) * annFac;
            double RiderHLHalfYear = BasicHLoad * (BasicSA/1000) * halfFac;
            double RiderHLQuarterly = BasicHLoad * (BasicSA/1000) * quarterFac;
            double RiderHLMonthly = BasicHLoad * (BasicSA/1000) * monthFac;
            
            annualRider = (riderRate *ridSA /1000 *annFac) + (OccpLoadA *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + (OccpLoadM *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + (OccpLoadQ *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + (OccpLoadM *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"C+"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"CCTR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"CIR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"LCPR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"CPA"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PA"])
        {
            annualRider = (riderRate *ridSA /1000 *annFac) + (OccpLoadA *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + (OccpLoadM *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + (OccpLoadQ *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + (OccpLoadM *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
            
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
                medPentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"HSP_II\" AND PlanOption=\"%@\"",planHSPII];
            }
            else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"MG_II"])
            {
                planMGII = [LPlanOpt objectAtIndex:i];
                medPentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"MG_II\" AND PlanOption=\"%@\"",planMGII];
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
        age = [[LAge objectAtIndex:i] intValue];
        sex = [[NSString alloc] initWithFormat:@"%@",[LSex objectAtIndex:i]];
        //getrate
        if ([[LRiderCode objectAtIndex:i] isEqualToString:@"HB"]) {
            [self getRiderRateSex:medPlanCodeRider riderTerm:ridTerm];
        }
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"HSP_II"]) {
            [self getRiderRateAgeClass:medPlanCodeRider riderTerm:ridTerm];
        }
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"MG_IV"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"MG_II"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"HMM"]) {
            [self getRiderRateAgeSexClass:medPlanCodeRider riderTerm:ridTerm];
        }
        else {
            continue;
        }
        
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
        NSLog(@"riderRate:%.2f, ridersum:%.3f, HL:%.3f",riderRate,ridSA,riderHLoad);
        
        double annFac;
        double halfFac;
        double quarterFac;
        double monthFac;
        if ([[LRiderCode objectAtIndex:i] isEqualToString:@"PA"]) {
            annFac = 1;
            halfFac = 0.5;
            quarterFac = 0.25;
            monthFac = ((double)1)/12;
        }
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"HB"]) {
            annFac = 1;
            halfFac = 0.55;
            quarterFac = 0.3;
            monthFac = 0.1;
        }
        else {
            annFac = 1;
            halfFac = 0.5125;
            quarterFac = 0.2625;
            monthFac = 0.0875;
        }
        NSLog(@"fac1:%.5f,fac2:%.5f,fac3:%.5f,fac4:%.5f",annFac,halfFac,quarterFac,monthFac);
        
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
            annualRider = riderRate * (1 + RiderHLAnnually/100) * annFac;
            halfYearRider = riderRate * (1 + RiderHLHalfYear/100) * halfFac;
            quarterRider = riderRate * (1 + RiderHLQuarterly/100) * quarterFac;
            monthlyRider = riderRate * (1 + RiderHLMonthly/100) * monthFac;
        }
        else if ([[LRiderCode objectAtIndex:i] isEqualToString:@"HB"])
        {
            int selectUnit = [[LUnits objectAtIndex:i] intValue];
            annualRider = riderRate * (1 + RiderHLAnnually/100) * selectUnit * annFac;
            halfYearRider = riderRate * (1 + RiderHLHalfYear/100) * selectUnit * halfFac;
            quarterRider = riderRate * (1 + RiderHLQuarterly/100) * selectUnit * quarterFac;
            monthlyRider = riderRate * (1 + RiderHLMonthly/100) * selectUnit * monthFac;
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
        [popOverConroller presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else{
		[popOverConroller dismissPopoverAnimated:YES];
	}
}

- (IBAction)btnAddRiderPressed:(id)sender
{
    self.RiderList = [[RiderListTbViewController alloc] initWithStyle:UITableViewStylePlain];
    _RiderList.delegate = self;
    _RiderList.requestPtype = self.pTypeCode;
    _RiderList.requestSeq = self.PTypeSeq;
    _RiderList.requestOccpClass = riderH.storedOccpClass;
    _RiderList.requestAge = self.requestAge;
    self.RiderListPopover = [[UIPopoverController alloc] initWithContentViewController:_RiderList];
    
    [self.RiderListPopover setPopoverContentSize:CGSizeMake(600.0f, 400.0f)];
    [self.RiderListPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
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
                popView.requestSA = self.requestBasicSA;
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
                popView.requestSA = self.requestBasicSA;
                popView.requestOption = planOption;
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

- (IBAction)editPressed:(id)sender
{
    if ([self.myTableView isEditing]) {
        [self.myTableView setEditing:NO animated:TRUE];
        deleteBtn.hidden = true;
        [editBtn setTitle:@"Delete" forState:UIControlStateNormal ];
    }
    else{
        [self.myTableView setEditing:YES animated:TRUE];
        deleteBtn.hidden = FALSE;
        [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        [editBtn setTitle:@"Cancel" forState:UIControlStateNormal ];
    }
}

- (IBAction)deletePressed:(id)sender
{
    NSArray *visibleCells = [myTableView visibleCells];
    NSMutableArray *ItemToBeDeleted = [[NSMutableArray alloc] init];
    
    for (UITableViewCell *cell in visibleCells)
    {
        if (cell.selected) {
            NSIndexPath *indexPath = [myTableView indexPathForCell:cell];
            NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
            [ItemToBeDeleted addObject:zzz];
        }
    }
    
    NSString *msg;
    if ([ItemToBeDeleted count] > 1) {
        msg = @"Are you sure want to delete these Rider(s)?";
    } else {
        int value = [[ItemToBeDeleted objectAtIndex:0] intValue];
        msg = [NSString stringWithFormat:@"Delete Rider:%@",[LRiderCode objectAtIndex:value]];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"No", nil];
    [alert setTag:1001];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001 && buttonIndex == 0)
    {
        NSArray *visibleCells = [myTableView visibleCells];
        NSMutableArray *ItemToBeDeleted = [[NSMutableArray alloc] init];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (UITableViewCell *cell in visibleCells)
        {
            if (cell.selected) {
                NSIndexPath *indexPath = [myTableView indexPathForCell:cell];
                
                NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
                [ItemToBeDeleted addObject:zzz];
                [indexPaths addObject:indexPath];
            }
        }
        
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            for(int a=0; a<ItemToBeDeleted.count; a++) {
                int value = [[ItemToBeDeleted objectAtIndex:a] intValue];
                value = value - a;
                
                NSString *querySQL = [NSString stringWithFormat:
                                      @"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\"",requestSINo,[LRiderCode objectAtIndex:value]];
                NSLog(@"%@",querySQL);
                if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"rider delete!");
                        
                    } else {
                        NSLog(@"rider delete Failed!");
                    }
                    sqlite3_finalize(statement);
                }
            
                [LRiderCode removeObjectAtIndex:value];
                [LSumAssured removeObjectAtIndex:value];
                [LTerm removeObjectAtIndex:value];
                [LPlanOpt removeObjectAtIndex:value];
                [LUnits removeObjectAtIndex:value];
                [LDeduct removeObjectAtIndex:value];
                [LRidHL1K removeObjectAtIndex:value];
                [LRidHL100 removeObjectAtIndex:value];
                [LRidHLP removeObjectAtIndex:value];
                [LSmoker removeObjectAtIndex:value];
                [LAge removeObjectAtIndex:value];
            }
            sqlite3_close(contactDB);
        }

        [myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];        
        [self.myTableView reloadData];
        
        deleteBtn.enabled = FALSE;
        [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
    }
    else if (alertView.tag == 1002 && buttonIndex == 0) {
        [self deleteRider];
    }
}

#pragma mark - validate

-(void)validateTerm
{
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    BOOL HL1kTerm = NO;
    BOOL HL100kTerm = NO;
    BOOL HLPTerm = NO;
    NSUInteger i;
    for (i=0; i<[FLabelCode count]; i++)
    {
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL1KT"]]) {
            HL1kTerm = YES;
        }
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL10T"]]) {
            HL100kTerm = YES;
        }
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HLPT"]]) {
            HLPTerm = YES;
        }
    }
    
    if (termField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([termField.text intValue] > maxRiderTerm) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Term must be less than or equal to %.f",maxRiderTerm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([termField.text intValue] < minTerm) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Term must be greater than or equal to %d",minTerm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([HLTField.text intValue] > [termField.text intValue]) {
        NSString *msg;
        if (HL1kTerm) {
            msg = [NSString stringWithFormat:@"Health Loading (per 1k SA) Term cannot be greater than %d",[termField.text intValue]];
        } else if (HL100kTerm) {
            msg = [NSString stringWithFormat:@"Health Loading (per 100 SA) Term cannot be greater than %d",[termField.text intValue]];
        } else if (HLPTerm) {
            msg = [NSString stringWithFormat:@"Health Loading (%%) Term cannot be greater than %d",[termField.text intValue]];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([termField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Rider Term must be numeric 0 to 9 or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (sumA) {
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
    NSLog(@"keyin SA:%d,max:%.f",[sumField.text intValue],maxRiderSA);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
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
        sumField.text = @"";
    }
    else if ([sumField.text intValue] < minSATerm && incomeRider) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Guaranteed Yearly Income must be greater than or equal to %d",minSATerm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        sumField.text = @"";
    }
    else if ([sumField.text intValue] > maxRiderSA && !(incomeRider)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Sum Assured must be less than or equal to %.f",maxRiderSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        sumField.text = @"";
    }
    else if ([sumField.text intValue] > maxRiderSA && incomeRider) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Guaranteed Yearly Income must be less than or equal to %.f",maxRiderSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        sumField.text = @"";
    }
    else if (incomeRider && msg.length > 4) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Guaranteed Yearly Income only allow 2 decimal." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        sumField.text = @"";
    }
    else if (!(incomeRider) && msg.length > 4) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider Sum Assured only allow 2 decimal." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        sumField.text = @"";
    }
    else if ([sumField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Input must be numeric 0 to 9 or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
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
    
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        
    double numHL = [HLField.text doubleValue];
    int HLValue = numHL;
    float HLFraction = numHL - HLValue;
    NSString *msg = [formatter stringFromNumber:[NSNumber numberWithFloat:HLFraction]];
    
    double aaHL = numHL/25;
    int bbHL = aaHL;
    float ccHL = aaHL - bbHL;
    NSString *msg2 = [formatter stringFromNumber:[NSNumber numberWithFloat:ccHL]];
    NSLog(@"value:%.2f,devide:%.2f,int:%d, minus:%.2f,msg:%@",numHL,aaHL,bbHL,ccHL,msg2);
    
    BOOL HL1kTerm = NO;
    BOOL HL100kTerm = NO;
    BOOL HLPTerm = NO;
    NSUInteger i;
    for (i=0; i<[FLabelCode count]; i++)
    {
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL1KT"]]) {
            HL1kTerm = YES;
        }
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL10T"]]) {
            HL100kTerm = YES;
        }
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HLPT"]]) {
            HLPTerm = YES;
        }
    }
    
    if (plan && planOption.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider Plan Option/Choice is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (deduc && deductible.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider Deductible is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([HLTField.text intValue] > [termField.text intValue]) {
        NSString *msg;
        if (HL1kTerm) {
            msg = [NSString stringWithFormat:@"Health Loading (per 1k SA) Term cannot be greater than %d",[termField.text intValue]];
        } else if (HL100kTerm) {
            msg = [NSString stringWithFormat:@"Health Loading (per 100 SA) Term cannot be greater than %d",[termField.text intValue]];
        } else if (HLPTerm) {
            msg = [NSString stringWithFormat:@"Health Loading (%%) Term cannot be greater than %d",[termField.text intValue]];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([HLField.text rangeOfCharacterFromSet:set].location != NSNotFound||[HLTField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Health Loading must be numeric 0 to 9 or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (inputHLPercentage.length != 0 && [HLField.text intValue] > 500) {
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
    double medicDouble = medRiderPrem * 2;
    
    if (medicDouble > totalPrem) {
        double minus = totalPrem - medRiderPrem;
        
        if (minus > 0) {
            
            double varSA = medRiderPrem/minus * requestBasicSA + 0.5;
            NSString *newBasicSA = [NSString stringWithFormat:@"%.2f",varSA];
            NSLog(@"newBasicSA:%@",newBasicSA);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Basic Sum Assured will be increase to RM%@ in accordance to MHI Guideline",newBasicSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"No", nil];
            [alert show];
            
            //update basicSA to varSA
            sqlite3_stmt *statement;
            if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
                NSString *querySQL = [NSString stringWithFormat:
                                      @"UPDATE Trad_Details SET BasicSA=\"%@\" WHERE SINo=\"%@\"",newBasicSA, SINoPlan];
                
                if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        NSLog(@"BasicSA update!");
                        
                        dataInsert = [[NSMutableArray alloc] init];
                        BasicPlanHandler *ss = [[BasicPlanHandler alloc] init];
                        [dataInsert addObject:[[BasicPlanHandler alloc] initWithSI:SINoPlan andAge:requestAge andOccpCode:requestOccpCode andCovered:requestCoverTerm andBasicSA:newBasicSA andBasicHL:riderBH.storedbasicHL andMOP:requestMOP andPlanCode:requestPlanCode]];
                        
                        for (NSUInteger i=0; i< dataInsert.count; i++) {
                            ss = [dataInsert objectAtIndex:i];
                            NSLog(@"storedbasic:%@",ss.storedSINo);
                        }
                        
                    } else {
                        NSLog(@"BasicSA update Failed!");
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(contactDB);
            }
            
            for (NSUInteger u=0; u<[LRiderCode count]; u++)
            {
                if (![[LRiderCode objectAtIndex:u]isEqualToString:@"C+"]||![[LRiderCode objectAtIndex:u]isEqualToString:@"CIR"]||![[LRiderCode objectAtIndex:u]isEqualToString:@"MG_II"]||![[LRiderCode objectAtIndex:u]isEqualToString:@"MG_IV"]||![[LRiderCode objectAtIndex:u]isEqualToString:@"HB"]||![[LRiderCode objectAtIndex:u]isEqualToString:@"HSP_II"]||![[LRiderCode objectAtIndex:u]isEqualToString:@"HMM"]||![[LRiderCode objectAtIndex:u]isEqualToString:@"CIWP"]||![[LRiderCode objectAtIndex:u]isEqualToString:@"LCWP"]||![[LRiderCode objectAtIndex:u]isEqualToString:@"PR"]||![[LRiderCode objectAtIndex:u]isEqualToString:@"SP_STD"]||![[LRiderCode objectAtIndex:u]isEqualToString:@"SP_PRE"])
                {
                    riderCode = [LRiderCode objectAtIndex:u];
                    [self calculateSA];
                    
                    double riderSA = [[LSumAssured objectAtIndex:u] doubleValue];
                    double RiderSA = (medRiderPrem/minus) * riderSA;
                    NSLog(@"newRiderSA:%.2f",RiderSA);
                    
                    if ([[LSumAssured objectAtIndex:u] intValue] > 0)
                    {
                        if (RiderSA > maxRiderSA)
                        {
                            //update riderSA
                            sqlite3_stmt *statement;
                            if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
                            {
                                NSString *updatetSQL = [NSString stringWithFormat:
                                                        @"UPDATE Trad_Rider_Details SET SumAssured=\"%.2f\" WHERE SINo=\"%@\" AND RiderCode=\"%@\" AND PTypeCode=\"%@\" AND Seq=\"%d\"",maxRiderSA,SINoPlan,riderCode,pTypeCode, PTypeSeq];
                                
                                if(sqlite3_prepare_v2(contactDB, [updatetSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                    if (sqlite3_step(statement) == SQLITE_DONE) {
                                        [self getListingRider];
                                        NSLog(@"Update RiderSA success!");
                                    } else {
                                        NSLog(@"Update RiderSA failed!");
                                    }
                                    sqlite3_finalize(statement);
                                }
                                sqlite3_close(contactDB);
                            }
                            NSLog(@"need to update riderSA!");
                        }
                    }
                }
                else {
                    continue;
                }
            }
            
            /*
             [self calculateBasicPremium];
             [self calculateRiderPrem];
             double newPrem = basicPrem + riderPrem + medRiderPrem;
             NSLog(@"%.2f",newPrem);
             */
        } else {
            NSLog(@"value minus not greater than 0");
        }
    } else {
        NSLog(@"value medicDouble less than totalPrem");
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Traditional" message:[NSString stringWithFormat:@"Total Daily Room & Board Benefit for combination of all MedGLOBAL rider(s) must be less than or equal to RM%d for 1st LA.",RBLimit] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Traditional" message:[NSString stringWithFormat:@"Total Daily Room & Board Benefit for combination of all MedGLOBAL rider(s) must be less than or equal to RM%d for 1st LA.",RBLimit] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    if (pTypeDesc != NULL) {
        if (![desc isEqualToString:pTypeDesc]) {
            PtypeChange = YES;
        }
    }
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
        [self clearField];
    }
    NSLog(@"RiderCode:%@",code);
    riderCode = [[NSString alloc] initWithFormat:@"%@",code];
    riderDesc = [[NSString alloc] initWithFormat:@"%@",desc];
    [self.btnAddRider setTitle:riderDesc forState:UIControlStateNormal];
    [self.RiderListPopover dismissPopoverAnimated:YES];
    
    BOOL foundPayor = YES;
    BOOL foundLiving = YES;
    BOOL either = NO;
    BOOL either2 = NO;
    if ([riderCode isEqualToString:@"PTR"]) { foundPayor = NO; }
    if ([riderCode isEqualToString:@"PLCP"]) { foundLiving = NO; }

    //validation part
    [self getOccpNotAttach];
    if ([atcRidCode count] != 0 && [riderCode isEqualToString:@"CPA"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider not available - does not meet underwriting rules" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.btnAddRider setTitle:@"" forState:UIControlStateNormal];
    }
    else if ([LRiderCode count] != 0)
    {
        NSUInteger i;
        for (i=0; i<[LRiderCode count]; i++) {
            NSLog(@"riderExist:%@, rider enter:%@",[LRiderCode objectAtIndex:i],riderCode);
            
            if ([riderCode isEqualToString:@"PTR"] && [[LRiderCode objectAtIndex:i] isEqualToString:@"PR"]) {
                NSLog(@"enterList-a");
                foundPayor = YES;
            }
            if ([riderCode isEqualToString:@"PLCP"] && [[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"]) {
                foundLiving = YES;
                NSLog(@"enterList-b");
            }
            if (([riderCode isEqualToString:@"LCWP"]) && ([[LRiderCode objectAtIndex:i] isEqualToString:@"PR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_PRE"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_STD"])) {
                either = YES;
            }
            if (([riderCode isEqualToString:@"PR"]) && ([[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_PRE"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_STD"])) {
                either = YES;
            }
            if (([riderCode isEqualToString:@"SP_PRE"]) && ([[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_STD"])) {
                either = YES;
            }
            if (([riderCode isEqualToString:@"SP_STD"]) && ([[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"PR"]||[[LRiderCode objectAtIndex:i] isEqualToString:@"SP_PRE"])) {
                either = YES;
            }
            if (([riderCode isEqualToString:@"LCWP"]) && ([[LRiderCode objectAtIndex:i] isEqualToString:@"PR"])) {
                either2 = YES;
            }
            if (([riderCode isEqualToString:@"PR"]) && ([[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"])) {
                either2 = YES;
            }
        }
        
        if (!(foundPayor)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Rider PR before PTR" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [self.btnAddRider setTitle:@"" forState:UIControlStateNormal];
            [alert show];
        }
        else if (!foundLiving) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Rider LCWP before PLCP." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [self.btnAddRider setTitle:@"" forState:UIControlStateNormal];
            [alert show];
        }
        else if ((either) && ([pTypeCode isEqualToString:@"LA"]) && (PTypeSeq == 2)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select either PR, LCWP, WOP_SP(Standard) or WOP_SP(Premier)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self.btnAddRider setTitle:@"" forState:UIControlStateNormal];
        }
        else if ((either2) && ([pTypeCode isEqualToString:@"PY"]) && (PTypeSeq == 1)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select either PR or LCWP." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self.btnAddRider setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            NSLog(@"enterList-2!");
            [self getLabelForm];
            [self toggleForm];
            [self getRiderTermRule];
        }
    }
    else if (!(foundPayor)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Rider PR before PTR" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.btnAddRider setTitle:@"" forState:UIControlStateNormal];
        [alert show];
    }
    else if (!foundLiving) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Rider LCWP before PLCP." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.btnAddRider setTitle:@"" forState:UIControlStateNormal];
        [alert show];
    }
    else {
        NSLog(@"outList!");
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
                }
            }
        } else {
            [self.planBtn setTitle:itemdesc forState:UIControlStateNormal];
            planOption = [[NSString alloc] initWithFormat:@"%@",itemdesc];
        }
    }
    else if (pressedDeduc) {
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
                        @"SELECT PremPayOpt_6 FROM Trad_Sys_Rider_GYI WHERE PlanCode=\"%@\" AND FromAge <=\"%d\" AND ToAge >= \"%d\"",riderCode,self.requestAge,self.requestAge];

        } else if (self.requestMOP == 9) {
            querySQL = [[NSString alloc] initWithFormat:
                        @"SELECT PremPayOpt_9 FROM Trad_Sys_Rider_GYI WHERE PlanCode=\"%@\" AND FromAge <=\"%d\" AND ToAge >= \"%d\"",riderCode,self.requestAge,self.requestAge];
        
        } else if (self.requestMOP == 12) {
            querySQL = [[NSString alloc] initWithFormat:
                        @"SELECT PremPayOpt_12 FROM Trad_Sys_Rider_GYI WHERE PlanCode=\"%@\" AND FromAge <=\"%d\" AND ToAge >= \"%d\"",riderCode,self.requestAge,self.requestAge];
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
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
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
    LSex = [[NSMutableArray alloc] init];
    LAge = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                @"SELECT a.RiderCode, a.SumAssured, a.RiderTerm, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, a.HL100SA, a.HLPercentage, c.Smoker,c.Sex, c.ALB FROM Trad_Rider_Details a, Trad_LAPayor b, Clt_Profile c WHERE a.PTypeCode=b.PTypeCode AND a.Seq=b.Sequence AND b.CustCode=c.CustCode AND a.SINo=b.SINo AND a.SINo=\"%@\"",SINoPlan];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [LRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                
                const char *aaRidSA = (const char *)sqlite3_column_text(statement, 1);
                [LSumAssured addObject:aaRidSA == NULL ? @"" :[[NSString alloc] initWithUTF8String:aaRidSA]];
                
                const char *aaTerm = (const char *)sqlite3_column_text(statement, 2);
                [LTerm addObject:aaTerm == NULL ? @"" :[[NSString alloc] initWithUTF8String:aaTerm]];
                
                const char *zzplan = (const char *) sqlite3_column_text(statement, 3);
                [LPlanOpt addObject:zzplan == NULL ? @"" :[[NSString alloc] initWithUTF8String:zzplan]];
                
                const char *aaUnit = (const char *)sqlite3_column_text(statement, 4);
                [LUnits addObject:aaUnit == NULL ? @"" :[[NSString alloc] initWithUTF8String:aaUnit]];
                
                const char *deduct2 = (const char *) sqlite3_column_text(statement, 5);
                [LDeduct addObject:deduct2 == NULL ? @"" :[[NSString alloc] initWithUTF8String:deduct2]];
                
                const char *ridHL = (const char *)sqlite3_column_text(statement, 6);
                [LRidHL1K addObject:ridHL == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridHL]];
                
                const char *ridHL100 = (const char *)sqlite3_column_text(statement, 7);
                [LRidHL100 addObject:ridHL100 == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridHL100]];
                
                const char *ridHLP = (const char *)sqlite3_column_text(statement, 8);
                [LRidHLP addObject:ridHLP == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridHLP]];
                
                [LSmoker addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)]];
                [LSex addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)]];
                [LAge addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)]];
            }
            
            if ([LRiderCode count] == 0) {
                myTableView.hidden = YES;
                titleRidCode.hidden = YES;
                titleSA.hidden = YES;
                titleTerm.hidden = YES;
                titleUnit.hidden = YES;
                titleClass.hidden = YES;
                titleLoad.hidden = YES;
                titleHL1K.hidden = YES;
                titleHL100.hidden = YES;
                titleHLP.hidden = YES;
            } else {
                myTableView.hidden = NO;
                titleRidCode.hidden = NO;
                titleSA.hidden = NO;
                titleTerm.hidden = NO;
                titleUnit.hidden = NO;
                titleClass.hidden = NO;
                titleLoad.hidden = NO;
                titleHL1K.hidden = NO;
                titleHL100.hidden = NO;
                titleHLP.hidden = NO;
                
                if ([sumField.text intValue] > _maxRiderSA) {
                    NSLog(@"will delete %@",riderCode);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Some Rider(s) has been deleted due to marketing rule." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert setTag:1002];
                    [alert show];
                }
                else {
                    
                    [self calculateRiderPrem];
                    [self calculateMedRiderPrem];
                    
                    if (medRiderPrem != 0) {
                        [self MHIGuideLines];
                    } else {
                        NSLog(@"No medical rider!");
                    }
                    
                }
            }
            
            [self.myTableView reloadData];
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
                [atcRidCode addObject:zzRidCode == NULL ? @"" :[[NSString alloc] initWithUTF8String:zzRidCode]];
                
                const char *zzPlan = (const char *)sqlite3_column_text(statement, 1);
                [atcPlanChoice addObject:zzPlan == NULL ? @"" :[[NSString alloc] initWithUTF8String:zzPlan]];
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
                
                UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider record sucessfully updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [SuccessAlert show];
                
            } else {
                NSLog(@"Update Rider failed!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
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
                NSLog(@"maxStored:%d",storedMaxTerm);
                
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
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    NSString *sumAss = [formatter stringFromNumber:[NSNumber numberWithDouble:requestBasicSA]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LSD FROM Trad_Sys_LSD_HLAIB WHERE PremPayOpt=\"%d\" AND FromSA <=\"%@\" AND ToSA >= \"%@\"",self.requestMOP,sumAss,sumAss];
        
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

//---

-(void)getRiderRateSex:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND Sex=\"%@\"",aaplan,aaterm,aaterm,sex];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_double(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Rider_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAge:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\"",aaplan,aaterm,aaterm,age,age];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_double(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Rider_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSex:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\" AND Sex=\"%@\"",aaplan,aaterm,aaterm,age,age,sex];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_double(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Rider_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSexClass:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\" AND Sex=\"%@\" AND occpClass = \"%d\"", aaplan,aaterm,aaterm,age,age,sex, riderH.storedOccpClass];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_double(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Rider_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeClass:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND "
                              " FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\" AND occpClass = \"%d\"",
                              aaplan,aaterm,aaterm,age,age, riderH.storedOccpClass];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_double(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Rider_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateClass:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND "
                              " FromMortality=0 AND occpClass = \"%d\"",
                              aaplan,aaterm,aaterm, riderH.storedOccpClass];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_double(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Rider_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

//----


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

-(void)deleteRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\"",requestSINo,riderCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"rider delete!");
                [self clearField];
                [self getListingRider];
                
            } else {
                NSLog(@"rider delete Failed!");
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
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    CGRect frame=CGRectMake(-30,0, 130, 50);
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=frame;
    label1.text= [LRiderCode objectAtIndex:indexPath.row];
    label1.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label1];
    
    CGRect frame2=CGRectMake(100,0, 129, 50);
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=frame2;
    NSString *num = [formatter stringFromNumber:[NSNumber numberWithDouble:[[LSumAssured objectAtIndex:indexPath.row] doubleValue]]];
    label2.text= num;
    label2.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label2];
    
    CGRect frame3=CGRectMake(229,0, 62, 50);
    UILabel *label3=[[UILabel alloc]init];
    label3.frame=frame3;
    label3.text= [LTerm objectAtIndex:indexPath.row];
    label3.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label3];
    
    CGRect frame4=CGRectMake(291,0, 62, 50);
    UILabel *label4=[[UILabel alloc]init];
    label4.frame=frame4;
    label4.text= [LUnits objectAtIndex:indexPath.row];
    label4.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label4];
    
    CGRect frame5=CGRectMake(353,0, 62, 50);
    UILabel *label5=[[UILabel alloc]init];
    label5.frame=frame5;
    label5.text= [NSString stringWithFormat:@"%d",occClass];
    label5.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label5];
    
    CGRect frame6=CGRectMake(415,0, 62, 50);
    UILabel *label6=[[UILabel alloc]init];
    label6.frame=frame6;
    label6.text= [NSString stringWithFormat:@"%d",occLoad];
    label6.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label6];
    
    CGRect frame7=CGRectMake(477,0, 84, 50);
    UILabel *label7=[[UILabel alloc]init];
    label7.frame=frame7;
    NSString *hl1k;
    if ([[LRidHL1K objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
        hl1k = @"";
    } else {
        hl1k = [LRidHL1K objectAtIndex:indexPath.row];
    }
    label7.text= hl1k;
    label7.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label7];
    
    CGRect frame8=CGRectMake(561,0, 84, 50);
    UILabel *label8=[[UILabel alloc]init];
    label8.frame=frame8;
    NSString *hl100;
    if ([[LRidHL100 objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
        hl100 = @"";
    } else {
        hl100 = [LRidHL100 objectAtIndex:indexPath.row];
    }
    label8.text= hl100;
    label8.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label8];
    
    CGRect frame9=CGRectMake(645,0, 84, 50);
    UILabel *label9=[[UILabel alloc]init];
    label9.frame=frame9;
    NSString *hlp;
    if ([[LRidHLP objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
        hlp = @"";
    } else {
        hlp = [LRidHLP objectAtIndex:indexPath.row];
    }
    label9.text=hlp;
    label9.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label9];
    
    if (indexPath.row % 2 == 0) {
        label1.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label2.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label3.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label4.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label5.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label6.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label7.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label8.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label9.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label7.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label8.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label9.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    }
    else {
        label1.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label2.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label3.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label4.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label5.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label6.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label7.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label8.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label9.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label7.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label8.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label9.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [myTableView visibleCells])
        {
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
        }
        
        if (!gotRowSelected) {
            [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            deleteBtn.enabled = FALSE;
        }
        else {
            [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            deleteBtn.enabled = TRUE;
        }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [myTableView visibleCells])
        {
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
        }
        
        if (!gotRowSelected) {
            [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            deleteBtn.enabled = FALSE;
        }
        else {
            [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            deleteBtn.enabled = TRUE;
        }
    }
}

#pragma mark - Memory Management

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOverConroller = nil;
}

- (void)viewDidUnload
{
    [self setDataInsert:nil];
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
    [self setTitleClass:nil];
    [self setTitleLoad:nil];
    [self setTitleHL1K:nil];
    [self setTitleHL100:nil];
    [self setTitleHLP:nil];
    [self setEditBtn:nil];
    [self setDeleteBtn:nil];
    [super viewDidUnload];
}

-(void)clearField
{
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
    unitField.text = @"";
    
    [self.planBtn setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    [self.deducBtn setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
}

@end
