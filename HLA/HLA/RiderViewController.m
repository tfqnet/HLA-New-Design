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
#import "AppDelegate.h"
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
@synthesize titleHLPTerm;
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
@synthesize requestPlanCode,requestSINo,requestAge,requestCoverTerm,requestBasicSA;
@synthesize pTypeCode,PTypeSeq,pTypeDesc,riderCode,riderDesc,popOverConroller;
@synthesize FLabelCode,FLabelDesc,FRidName,FInputCode,FFieldName,FTbName,FCondition;
@synthesize expAge,minSATerm,maxSATerm,minTerm,maxTerm,maxRiderTerm,planOption,deductible,maxRiderSA;
@synthesize inputHL1KSA,inputHL1KSATerm,inputHL100SA,inputHL100SATerm,inputHLPercentage,inputHLPercentageTerm;
@synthesize LRiderCode,LSumAssured,LTerm,LUnits,atcRidCode,atcPlanChoice,existRidCode,GYI,requestMOP;
@synthesize occLoad,occClass,occCPA,riderBH,riderH,storedMaxTerm,basicRate,LSDRate;
@synthesize annualRiderPrem,halfRiderPrem,quarterRiderPrem,monthRiderPrem,LPlanOpt,pentaSQL,plnOptC,planOptHMM,LDeduct,deducHMM,LAge;
@synthesize planHSPII,planMGII,planMGIV,LSmoker,planCodeRider,LRidHL100,LRidHL1K,LRidHLP,riderRate;
@synthesize annualRiderSum,halfRiderSum,quarterRiderSum,monthRiderSum,medPlanCodeRider;
@synthesize annualMedRiderPrem,halfMedRiderPrem,quarterMedRiderPrem,monthMedRiderPrem,annualMedRiderSum,halfMedRiderSum,quarterMedRiderSum,monthMedRiderSum;
@synthesize riderPrem,medRiderPrem,medPentaSQL,OccpCat,CombNo,RBBenefit,RBLimit,RBGroup,medRiderCode;
@synthesize arrCombNo,AllCombNo,medPlanOpt,arrRBBenefit,pTypeOccp;
@synthesize dataInsert,LSex,sex,age,_maxRiderSA;
@synthesize waiverRiderAnn,waiverRiderAnn2,waiverRiderHalf,waiverRiderHalf2,waiverRiderMonth,waiverRiderMonth2,waiverRiderQuar,waiverRiderQuar2;
@synthesize basicPremAnn,basicPremHalf,basicPremMonth,basicPremQuar,incomeRiderGYI,incomeRiderSA,basicGYIRate,incomeRiderCSV;
@synthesize incomeRiderAnn,incomeRiderHalf,incomeRiderMonth,incomeRiderQuar,incomeRiderPrem,basicCSVRate,riderCSVRate,pTypeAge;
@synthesize inputSA,inputCSV,inputGYI,inputIncomeAnn,secondLARidCode;
@synthesize RiderList = _RiderList;
@synthesize RiderListPopover = _RiderListPopover;
@synthesize planPopover = _planPopover;
@synthesize deducPopover = _deducPopover;
@synthesize planList = _planList;
@synthesize deductList = _deductList;
@synthesize planCondition,deducCondition,incomeRiderCode,incomeRiderTerm, LRidHLTerm, LRidHLPTerm, LRidHL100Term,LOccpCode;
@synthesize occLoadRider,LTypeAge,LTypeDeduct,LTypeOccpCode,LTypePlanOpt,LTypeRiderCode,LTypeRidHL100,LTypeRidHL100Term,LTypeRidHL1K,LTypeRidHLP,LTypeRidHLPTerm,LTypeRidHLTerm,LTypeSex,LTypeSmoker,LTypeSumAssured,LTypeTerm,LTypeUnits;
@synthesize occLoadType,classField,payorRidCode,getSINo,getPlanCode,getAge,getTerm,getBasicSA,getMOP,requestAdvance,getAdvance;
@synthesize requestOccpClass,getOccpClass;
@synthesize delegate = _delegate;

#pragma mark - Cycle View

- (void)viewDidLoad
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"HLA_Rates.sqlite"]];
    
    //--------- edited by heng
    AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    zzz.MhiMessage = @"";
    //-----------
    
    getSINo = [self.requestSINo description];
    getPlanCode = [self.requestPlanCode description];
    getAge = self.requestAge;
    getTerm = self.requestCoverTerm;
    getBasicSA = [[self.requestBasicSA description] doubleValue];
    getMOP = self.requestMOP;
    getAdvance = self.requestAdvance;
    getOccpClass = self.requestOccpClass;
    NSLog(@"Rider-Sum:%.2f,Age:%d,covered:%d,SINo:%@, planCode:%@, MOP:%d, advance:%d, occpClass:%d",getBasicSA,getAge,getTerm,getSINo,getPlanCode,getMOP,getAdvance,getOccpClass);
    
    deducBtn.hidden = YES;
    deleteBtn.hidden = TRUE;
    deleteBtn.enabled = FALSE;
    incomeRider = NO;
    PtypeChange = NO;
    
    if (requestSINo) {
        if (!listPType) {
            listPType = [[RiderPTypeTbViewController alloc]initWithString:getSINo];
            listPType.delegate = self;
        }
        pTypeCode = [[NSString alloc] initWithFormat:@"%@",listPType.selectedCode];
        PTypeSeq = [listPType.selectedSeqNo intValue];
        pTypeDesc = [[NSString alloc] initWithFormat:@"%@",listPType.selectedDesc];
        pTypeAge = [listPType.selectedAge intValue];
        pTypeOccp = [[NSString alloc] initWithFormat:@"%@",listPType.selectedOccp];
        [self.btnPType setTitle:pTypeDesc forState:UIControlStateNormal];
    }
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    CGRect frame=CGRectMake(53,395, 80, 50);
    titleRidCode.text = @"Rider";
    titleRidCode.frame = frame;
    titleRidCode.textAlignment = UITextAlignmentCenter;
    titleRidCode.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleRidCode.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    titleRidCode.numberOfLines = 2;
    
    CGRect frame2=CGRectMake(133,395, 105, 50);
    titleSA.frame = frame2;
    titleSA.textAlignment = UITextAlignmentCenter;
    titleSA.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleSA.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame3=CGRectMake(238,395, 62, 50);
    titleTerm.frame = frame3;
    titleTerm.textAlignment = UITextAlignmentCenter;
    titleTerm.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleTerm.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame4=CGRectMake(300,395, 62, 50);
    titleUnit.frame = frame4;
    titleUnit.textAlignment = UITextAlignmentCenter;
    titleUnit.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleUnit.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame5=CGRectMake(362,395, 62, 50);
    titleClass.text = @"Occ \nClass";
    titleClass.frame = frame5;
    titleClass.textAlignment = UITextAlignmentCenter;
    titleClass.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleClass.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    titleClass.numberOfLines = 2;

    CGRect frame6=CGRectMake(424,395, 62, 50);
    titleLoad.text = @"Occp \nLoading";
    titleLoad.frame = frame6;
    titleLoad.textAlignment = UITextAlignmentCenter;
    titleLoad.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleLoad.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    titleLoad.numberOfLines = 2;
    
    CGRect frame7=CGRectMake(486,395, 63, 50);
    titleHL1K.frame = frame7;
    titleHL1K.textAlignment = UITextAlignmentCenter;
    titleHL1K.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleHL1K.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame8=CGRectMake(549,395, 63, 50);
    titleHL100.text = @"HL(SA)\nterm";
    titleHL100.frame = frame8;
    titleHL100.textAlignment = UITextAlignmentCenter;
    titleHL100.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleHL100.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    titleHL100.numberOfLines = 2;
    
    CGRect frame9=CGRectMake(612,395, 63, 50);
    titleHLP.frame = frame9;
    titleHLP.textAlignment = UITextAlignmentCenter;
    titleHLP.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleHLP.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame10=CGRectMake(675,395, 64, 50);
    titleHLPTerm.text = @"HL %\nTerm";
    titleHLPTerm.frame = frame10;
    titleHLPTerm.textAlignment = UITextAlignmentCenter;
    titleHLPTerm.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    titleHLPTerm.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    titleHLPTerm.numberOfLines = 2;
    
    [self getBasicPentaRate];
    [self getOccLoad];
    [self getCPAClassType];
    [self getOccpCatCode];
    [self getLSDRate];
    NSLog(@"basicRate:%d,lsdRate:%d,pa_cpa:%d",basicRate,LSDRate,occLoad);
    
    [self calculateBasicPremium];   //calculate basicPrem
    
    [self getListingRiderByType];
    [self getListingRider];     //get stored rider
    
    [self calculateRiderPrem];  //calculate riderPrem
    [self calculateWaiver];     //calculate waiverPrem
    [self calculateMedRiderPrem];       //calculate medicalPrem
    
     if (medRiderPrem != 0) {
        [self MHIGuideLines];
     } else {
         BOOL dodelete = NO;
         for (int p=0; p<LRiderCode.count; p++) {
             
             riderCode = [LRiderCode objectAtIndex:p];
             [self getRiderTermRule];
             [self calculateSA];
             double riderSA = [[LSumAssured objectAtIndex:p] doubleValue];
             if (riderSA > maxRiderSA)
             {
                 dodelete = YES;
                 sqlite3_stmt *statement;
                 if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
                 {
                     NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\"",requestSINo,riderCode];
                     
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
                     sqlite3_close(contactDB);
                 }
             }
         }
         if (dodelete) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Some Rider(s) has been deleted due to marketing rule." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert setTag:1005];
             [alert show];
         }
         
     }
    
    myTableView.rowHeight = 50;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorColor = [UIColor clearColor];
    myTableView.opaque = NO;
    myTableView.backgroundView = nil;
    
//    myTableView.delegate = self;
//    myTableView.dataSource = self;
//    [myTableView reloadData];
    
    [self.view addSubview:myTableView];
    
    [editBtn setBackgroundImage:[[UIImage imageNamed:@"iphone_delete_button.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f] forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editBtn.titleLabel.shadowColor = [UIColor lightGrayColor];
    editBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    [deleteBtn setBackgroundImage:[[UIImage imageNamed:@"iphone_delete_button.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.shadowColor = [UIColor lightGrayColor];
    deleteBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
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
            if (incomeRider) {
                
                NSString *strMaxRiderSA = [NSString stringWithFormat:@"%.2f", maxRiderSA];
                NSRange rangeofDot = [ strMaxRiderSA rangeOfString:@"."];
                NSString *ValueToDisplay = @"";
                
                if (rangeofDot.location != NSNotFound) {
                    NSString *substring = [strMaxRiderSA substringFromIndex:rangeofDot.location ];
                    NSString *substring2 = [substring substringFromIndex:[substring length]-1];
                    
                    if (substring.length == 3 && [substring isEqualToString:@".00"]) {
                        ValueToDisplay = [strMaxRiderSA substringToIndex:rangeofDot.location ];
                    }
                    else if (substring.length == 3 && [substring2 isEqualToString:@"0"]) {
                        ValueToDisplay = [strMaxRiderSA substringToIndex:[strMaxRiderSA length]-1];
                    }
                    else {
                        ValueToDisplay = strMaxRiderSA;
                    }
                }
                else {
                    ValueToDisplay = strMaxRiderSA;
                }
                minDisplayLabel.text = [NSString stringWithFormat:@"Min GYI: %d",minSATerm];
                maxDisplayLabel.text = [NSString stringWithFormat:@"Max GYI: %@",ValueToDisplay];
                
            } else {
                minDisplayLabel.text = [NSString stringWithFormat:@"Min SA: %d",minSATerm];
                maxDisplayLabel.text = [NSString stringWithFormat:@"Max SA: %.f",maxRiderSA];
            }
            break;
            
        case 3:
            minDisplayLabel.text = @"Min Unit: 1";
            maxDisplayLabel.text = [NSString stringWithFormat:@"Max Unit: %.f",maxRiderSA];
            break;
            
        default:
            minDisplayLabel.text = @"";
            maxDisplayLabel.text = @"";
            break;
    }
    return YES;
}

-(void)displayedMinMax
{    
    if ([sumField isFirstResponder] == TRUE) {
        
        if (incomeRider) {
        
            NSString *strMaxRiderSA = [NSString stringWithFormat:@"%.2f", maxRiderSA];
            NSRange rangeofDot = [ strMaxRiderSA rangeOfString:@"."];
            NSString *ValueToDisplay = @"";
            
            if (rangeofDot.location != NSNotFound) {
                NSString *substring = [strMaxRiderSA substringFromIndex:rangeofDot.location ];
                 NSString *substring2 = [substring substringFromIndex:[substring length]-1];
                
                if (substring.length == 3 && [substring isEqualToString:@".00"]) {
                    ValueToDisplay = [strMaxRiderSA substringToIndex:rangeofDot.location ];
                }
                else if (substring.length == 3 && [substring2 isEqualToString:@"0"]) {
                    ValueToDisplay = [strMaxRiderSA substringToIndex:[strMaxRiderSA length]-1];
                }
                else {
                    ValueToDisplay = strMaxRiderSA;
                }
            }
            else {
                ValueToDisplay = strMaxRiderSA;
            }
            minDisplayLabel.text = [NSString stringWithFormat:@"Min GYI: %d",minSATerm];
            maxDisplayLabel.text = [NSString stringWithFormat:@"Max GYI: %@",ValueToDisplay];
        }
        else {
            minDisplayLabel.text = [NSString stringWithFormat:@"Min SA: %d",minSATerm];
            maxDisplayLabel.text = [NSString stringWithFormat:@"Max SA: %.f",maxRiderSA];
        }
    }
    else if ([termField isFirstResponder] == TRUE) {
            minDisplayLabel.text = [NSString stringWithFormat:@"Min Term: %d",minTerm];
            maxDisplayLabel.text = [NSString stringWithFormat:@"Max Term: %.f",maxRiderTerm];
    }
    else if ([unitField isFirstResponder] == TRUE) {
        
        minDisplayLabel.text = @"Min Unit: 1";
        maxDisplayLabel.text = [NSString stringWithFormat:@"Max Unit: %.f",maxRiderSA];
    }
    else {
            minDisplayLabel.text = @"";
            maxDisplayLabel.text = @"";
    }
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
            
            planCondition = [FCondition objectAtIndex:i];
            
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
            
            deducCondition = [FCondition objectAtIndex:i];
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
        termField.textColor = [UIColor blackColor];
        
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
        planBtn.hidden = NO;
        [self.planBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        classField.hidden = YES;
        
        NSString *strSA = [NSString stringWithFormat:@"%.2f",getBasicSA];
        self.planList = [[RiderPlanTb alloc] initWithString:planCondition andSumAss:strSA];
        _planList.delegate = self;
        
        [self.planBtn setTitle:_planList.selectedItemDesc forState:UIControlStateNormal];
        planOption = [[NSString alloc] initWithFormat:@"%@",_planList.selectedItemDesc];
    }
    else {
        planLabel.textColor = [UIColor grayColor];
        planLabel.text = @"PA Class";
        planBtn.enabled = NO;
        planBtn.hidden = YES;
        classField.hidden = NO;
        classField.enabled = NO;
        
        NSString *msg = @"";
        if (occCPA > 4) { msg = @"D"; }
        else { msg = [NSString stringWithFormat:@"%d",occCPA]; }
        
        classField.text = msg;
        classField.textColor = [UIColor darkGrayColor];
    }
    
    if (unit) {
        unitLabel.textColor = [UIColor blackColor];
        unitField.textColor = [UIColor blackColor];
        unitField.hidden = NO;
        unitField.enabled = YES;
        deducBtn.hidden = YES;
    }
    
    if (deduc) {
        unitLabel.textColor = [UIColor blackColor];
        unitField.hidden = YES;
        deducBtn.hidden = NO;
        
        NSString *strSA = [NSString stringWithFormat:@"%.2f",getBasicSA];
        self.deductList = [[RiderDeducTb alloc] initWithString:deducCondition andSumAss:strSA andOption:planOption];
            _deductList.delegate = self;
        
        [self.deducBtn setTitle:_deductList.selectedItemDesc forState:UIControlStateNormal];
        deductible = [[NSString alloc] initWithFormat:@"%@",_deductList.selectedItemDesc];
        NSLog(@"deduc:%@",deductible);
        
    }
    
    if (!unit && !deduc) {
        unitLabel.text = @"Units";
        unitLabel.textColor = [UIColor grayColor];
        deducBtn.hidden = YES;
        unitField.hidden = NO;
        unitField.enabled = NO;
        unitField.text = @"0";
        unitField.textColor = [UIColor darkGrayColor];
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
    
    NSString *msg = @"";
    if (occCPA > 4) { msg = @"D"; }
    else { msg = [NSString stringWithFormat:@"%d",occCPA]; }
    cpaField.text = msg;
    cpaField.textColor = [UIColor darkGrayColor];
    
    if (occLoadType == 0) { occpField.text = @"STD"; }
    else { occpField.text = [NSString stringWithFormat:@"%d",occLoadType]; }
    occpField.textColor = [UIColor darkGrayColor];
}


#pragma mark - calculation

-(void)calculateTerm
{
    int period = expAge - self.pTypeAge;
    int period2 = 80 - self.pTypeAge;
    double age1 = fmin(period2,60);
    
    if ([riderCode isEqualToString:@"CIWP"])
    {
        [self getMaxRiderTerm];
        double maxRiderTerm1 = fmin(period,getTerm);
        double maxRiderTerm2 = fmax(getMOP,storedMaxTerm);
        maxRiderTerm = fmin(maxRiderTerm1,maxRiderTerm2);
    }
    else if ([riderCode isEqualToString:@"LCWP"]||[riderCode isEqualToString:@"PR"]||[riderCode isEqualToString:@"PLCP"]||
        [riderCode isEqualToString:@"PTR"]||[riderCode isEqualToString:@"SP_STD"]||[riderCode isEqualToString:@"SP_PRE"])
    {
        [self getMaxRiderTerm];
        double maxRiderTerm1 = fmin(getTerm,age1);
        double maxRiderTerm2 = fmax(getMOP,storedMaxTerm);
//        double maxRiderTerm2 = fmax(getTerm,storedMaxTerm);
        maxRiderTerm = fmin(maxRiderTerm1,maxRiderTerm2);
        NSLog(@"maxTerm1:%.f, maxTerm2:%.f, maxTerm:%.f",maxRiderTerm1,maxRiderTerm2,maxRiderTerm);
        
        if (maxRiderTerm < minTerm) {
            maxRiderTerm = maxTerm;
        }
        
        if (([riderCode isEqualToString:@"PLCP"] || [riderCode isEqualToString:@"PTR"]) && maxRiderTerm > maxTerm) {
            maxRiderTerm = maxTerm;
        }
    }
    else if ([riderCode isEqualToString:@"I20R"]||[riderCode isEqualToString:@"I30R"]||[riderCode isEqualToString:@"I40R"] || [riderCode isEqualToString:@"IE20R"] || [riderCode isEqualToString:@"IE30R"] ) //edited by heng
    {
        maxRiderTerm = maxTerm;
        termField.text = [NSString stringWithFormat:@"%d",maxTerm];
        termField.textColor = [UIColor darkGrayColor];
    }
    
    else if ([riderCode isEqualToString:@"ID20R"]||[riderCode isEqualToString:@"ID30R"]||[riderCode isEqualToString:@"ID40R"]||[riderCode isEqualToString:@"MG_II"]||[riderCode isEqualToString:@"MG_IV"]||[riderCode isEqualToString:@"HB"]||[riderCode isEqualToString:@"HSP_II"]||[riderCode isEqualToString:@"CPA"]||[riderCode isEqualToString:@"PA"]||[riderCode isEqualToString:@"HMM"])
    {
        maxRiderTerm = fmin(period,getTerm);
        termField.text = [NSString stringWithFormat:@"%.f",maxRiderTerm];
        termField.textColor = [UIColor darkGrayColor];
    }
    
    else {
        maxRiderTerm = fmin(period,getTerm);
    }
    
    NSLog(@"expAge-alb:%d,covperiod:%d,maxRiderTerm:%.f,age1:%.f",period,getTerm,maxRiderTerm,age1);
}

-(void)calculateSA
{
    double dblPseudoBSA = getBasicSA / 0.05;
    double dblPseudoBSA2 = dblPseudoBSA * 0.1;
    double dblPseudoBSA3 = dblPseudoBSA * 5;
    double dblPseudoBSA4 = dblPseudoBSA * 2;
    int MaxUnit;
//    NSLog(@"dblPseudoBSA:%.f, dblPseudoBSA3:%.f",maxRiderSA,dblPseudoBSA3);
    
    if ([riderCode isEqualToString:@"CCTR"])
    {
        _maxRiderSA = dblPseudoBSA3;
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    else if ([riderCode isEqualToString:@"ETPD"])
    {
        _maxRiderSA = fmin(dblPseudoBSA2,120000);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    else if ([riderCode isEqualToString:@"I20R"]||[riderCode isEqualToString:@"I30R"]||[riderCode isEqualToString:@"I40R"]||[riderCode isEqualToString:@"ID20R"]||[riderCode isEqualToString:@"ID30R"]||[riderCode isEqualToString:@"ID40R"]||[riderCode isEqualToString:@"IE20R"]||[riderCode isEqualToString:@"IE30R"])
    {
        NSLog(@"enter gyi");
        [self getGYI];
        double BasicSA_GYI = getBasicSA * GYI;
        _maxRiderSA = fmin(BasicSA_GYI,9999999);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    else if ([riderCode isEqualToString:@"CPA"])
    {
        if (getOccpClass == 1 || getOccpClass == 2) {
            if (dblPseudoBSA < 100000) {
                _maxRiderSA = fmin(dblPseudoBSA3,200000);
                NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
                maxRiderSA = [a_maxRiderSA doubleValue];
            }
            else if (dblPseudoBSA >= 100000) {
                _maxRiderSA = fmin(dblPseudoBSA4,1000000);
                NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
                maxRiderSA = [a_maxRiderSA doubleValue];
            }
        }
        else if (getOccpClass == 3 || getOccpClass == 4) {
            _maxRiderSA = fmin(dblPseudoBSA3,100000);
            NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
            maxRiderSA = [a_maxRiderSA doubleValue];
        }
    }
    else if ([riderCode isEqualToString:@"PA"]) {
        _maxRiderSA = fmin(dblPseudoBSA3,1000000);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    else if ([riderCode isEqualToString:@"PTR"]) {
        _maxRiderSA = fmin(dblPseudoBSA3,500000);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    else if ([riderCode isEqualToString:@"HB"]) {
        if (dblPseudoBSA >= 10000 && dblPseudoBSA <= 25000) {
            MaxUnit = 4;
        }
        else if (dblPseudoBSA >= 25001 && dblPseudoBSA <= 50000) {
            MaxUnit = 6;
        }
        else if (dblPseudoBSA >= 50001 && dblPseudoBSA <= 75000) {
            MaxUnit = 8;
        }
        else if (dblPseudoBSA > 75000) {
            MaxUnit = 10;
        }
        maxRiderSA = MaxUnit;
    }
    else {
        _maxRiderSA = maxSATerm;
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
//    NSLog(@"maxSA(%@):%.f",riderCode,maxRiderSA);
}

-(void)calculateBasicPremium
{
    double BasicSA = getBasicSA;
    double PolicyTerm = getTerm;
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
//    NSLog(@"Basic A:%.3f, S:%.3f, Q:%.3f, M:%.3f",_BasicAnnually,_BasicHalfYear,_BasicQuarterly,_BasicQuarterly);
    
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
//    NSLog(@"OccpLoad A:%.3f, S:%.3f, Q:%.3f, M:%.3f",_OccpLoadA,_OccpLoadH,_OccpLoadQ,_OccpLoadM);
    
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
//    NSLog(@"BasicHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",_BasicHLAnnually,_BasicHLHalfYear,_BasicHLQuarterly,_BasicHLMonthly);
    
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
//    NSLog(@"LSD A:%.3f, S:%.3f, Q:%.3f, M:%.3f",_LSDAnnually,_LSDHalfYear,_LSDQuarterly,_LSDMonthly);
//    NSLog(@"LSD A:%@, S:%@, Q:%@, M:%@",LSDAnnually2,LSDHalfYear2,LSDQuarterly2,LSDMonthly2);
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
    NSString *basicTotalS = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalS]];
    NSString *basicTotalQ = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalQ]];
    NSString *basicTotalM = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalM]];
    
    basicPremAnn = [[basicTotalA stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    basicPremHalf = [[basicTotalS stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    basicPremQuar = [[basicTotalQ stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    basicPremMonth = [[basicTotalM stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    NSLog(@"TAP A:%.2f, S:%.2f, Q:%.2f, M:%.2f",basicPremAnn,basicPremHalf,basicPremQuar,basicPremMonth);
}

-(void)calculateRiderPrem
{
    annualRiderPrem = [[NSMutableArray alloc] init];
    halfRiderPrem = [[NSMutableArray alloc] init];
    quarterRiderPrem = [[NSMutableArray alloc] init];
    monthRiderPrem = [[NSMutableArray alloc] init];
    
    waiverRiderAnn = [[NSMutableArray alloc] init];
    waiverRiderHalf = [[NSMutableArray alloc] init];
    waiverRiderQuar = [[NSMutableArray alloc] init];
    waiverRiderMonth = [[NSMutableArray alloc] init];
    waiverRiderAnn2 = [[NSMutableArray alloc] init];
    waiverRiderHalf2 = [[NSMutableArray alloc] init];
    waiverRiderQuar2 = [[NSMutableArray alloc] init];
    waiverRiderMonth2 = [[NSMutableArray alloc] init];
    
    annualMedRiderPrem = [[NSMutableArray alloc] init];
    halfMedRiderPrem = [[NSMutableArray alloc] init];
    quarterMedRiderPrem = [[NSMutableArray alloc] init];
    monthMedRiderPrem = [[NSMutableArray alloc] init];
    
    incomeRiderCode = [[NSMutableArray alloc] init];
    incomeRiderTerm = [[NSMutableArray alloc] init];
    incomeRiderAnn = [[NSMutableArray alloc] init];
    incomeRiderHalf = [[NSMutableArray alloc] init];
    incomeRiderQuar = [[NSMutableArray alloc] init];
    incomeRiderMonth = [[NSMutableArray alloc] init];
    incomeRiderSA = [[NSMutableArray alloc] init];
    incomeRiderCSV = [[NSMutableArray alloc] init];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];

    NSUInteger i;
    for (i=0; i<[LRiderCode count]; i++) {
        
        NSString *RidCode = [[NSString alloc] initWithFormat:@"%@",[LRiderCode objectAtIndex:i]];
        
        //getpentacode
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            if ([RidCode isEqualToString:@"C+"])
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
            else if ([RidCode isEqualToString:@"HMM"])
            {
                planOptHMM = [LPlanOpt objectAtIndex:i];
                deducHMM = [LDeduct objectAtIndex:i];
                pentaSQL = [[NSString alloc] initWithFormat:
                            @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"HMM\" AND PlanOption=\"%@\" AND Deductible=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planOptHMM,deducHMM,[LAge objectAtIndex:i],[LAge objectAtIndex:i]];
            }
            else if ([RidCode isEqualToString:@"HSP_II"])
            {
                if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"Standard"]) {
                    planHSPII = @"S";
                } else if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"Deluxe"]) {
                    planHSPII = @"D";
                } else if ([[LPlanOpt objectAtIndex:i] isEqualToString:@"Premier"]) {
                    planHSPII = @"P";
                }
                pentaSQL = [[NSString alloc] initWithFormat:
                            @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"HSP_II\" AND PlanOption=\"%@\"",planHSPII];
            }
            else if ([RidCode isEqualToString:@"MG_II"])
            {
                planMGII = [LPlanOpt objectAtIndex:i];
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"MG_II\" AND PlanOption=\"%@\"",planMGII];
            }
            else if ([RidCode isEqualToString:@"I20R"] || [RidCode isEqualToString:@"I30R"] || [RidCode isEqualToString:@"I40R"] || [RidCode isEqualToString:@"ID20R"] || [RidCode isEqualToString:@"ID30R"] || [RidCode isEqualToString:@"ID40R"] || [RidCode isEqualToString:@"IE20R"] || [RidCode isEqualToString:@"IE30R"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND PremPayOpt=\"%d\"",[LRiderCode objectAtIndex:i],getMOP];
                
            }
            else if ([RidCode isEqualToString:@"ICR"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"ICR\" AND Smoker=\"%@\"",[LSmoker objectAtIndex:i]];
                
            } else if ([RidCode isEqualToString:@"MG_IV"])
            {
                planMGIV = [LPlanOpt objectAtIndex:i];
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"MG_IV\" AND PlanOption=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planMGIV,[LAge objectAtIndex:i],[LAge objectAtIndex:i]];
            }
            else if ([RidCode isEqualToString:@"CIWP"]||[RidCode isEqualToString:@"LCWP"]||[RidCode isEqualToString:@"PR"]||[RidCode isEqualToString:@"SP_STD"]||[RidCode isEqualToString:@"SP_PRE"]) {
                sqlite3_close(contactDB);
                continue;
            }
            else {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND Channel=\"AGT\"",RidCode];
            }
            
            const char *query_stmt = [pentaSQL UTF8String];
            if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
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
        if ([RidCode isEqualToString:@"I20R"]||[RidCode isEqualToString:@"I30R"]||[RidCode isEqualToString:@"I40R"]||[RidCode isEqualToString:@"ID20R"]||[RidCode isEqualToString:@"ID30R"]||[RidCode isEqualToString:@"ID40R"]||[RidCode isEqualToString:@"IE20R"]||[RidCode isEqualToString:@"IE30R"])
        {
            [self getRiderRateAge:planCodeRider riderTerm:ridTerm];
        }
        else if ([RidCode isEqualToString:@"CPA"]) {
            [self getRiderRateClass:planCodeRider riderTerm:ridTerm];
        }
        else if ([RidCode isEqualToString:@"PA"]||[RidCode isEqualToString:@"HSP_II"]) {
            [self getRiderRateAgeClass:planCodeRider riderTerm:ridTerm];
        }
        else if ([RidCode isEqualToString:@"HB"]) {
            [self getRiderRateSex:planCodeRider riderTerm:ridTerm];
        }
        else if ([RidCode isEqualToString:@"MG_IV"]||[RidCode isEqualToString:@"MG_II"]||[RidCode isEqualToString:@"HMM"]) {
            [self getRiderRateAgeSexClass:planCodeRider riderTerm:ridTerm];
        }
        else {
            [self getRiderRateAgeSex:planCodeRider riderTerm:ridTerm];
        }
        
        double BasicSA = getBasicSA;
        double BasicHLoad = [riderBH.storedbasicHL doubleValue];
        double ridSA = [[LSumAssured objectAtIndex:i] doubleValue];
        double PolicyTerm = getTerm;
        double riderHLoad;
        if ([LRidHL1K count] != 0) {
            riderHLoad = [[LRidHL1K objectAtIndex:i] doubleValue];
        } else if ([LRidHL100 count] != 0) {
            riderHLoad = [[LRidHL100 objectAtIndex:i] doubleValue];
        } else if ([LRidHLP count] != 0) {
            riderHLoad = [[LRidHLP objectAtIndex:i] doubleValue];
        }
        NSLog(@"~riderRate(%@):%.2f, ridersum:%.3f, HL:%.3f",[LRiderCode objectAtIndex:i],riderRate,ridSA,riderHLoad);
        
        double annFac;
        double halfFac;
        double quarterFac;
        double monthFac;
        if ([RidCode isEqualToString:@"HB"]) {
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
        
        //calculate occupationLoading
        pTypeOccp = [LOccpCode objectAtIndex:i];
        [self getOccLoadRider];
        double OccpLoadA = occLoadRider * ((PolicyTerm + 1)/2) * (BasicSA/1000) * annFac;
        double OccpLoadH = occLoadRider * ((PolicyTerm + 1)/2) * (BasicSA/1000) * halfFac;
        double OccpLoadQ = occLoadRider * ((PolicyTerm + 1)/2) * (BasicSA/1000) * quarterFac;
        double OccpLoadM = occLoadRider * ((PolicyTerm + 1)/2) * (BasicSA/1000) * monthFac;
        NSLog(@"OccpLoad A:%.3f, S:%.3f, Q:%.3f, M:%.3f",OccpLoadA,OccpLoadH,OccpLoadQ,OccpLoadM);
        
        //calculate rider health loading
        double RiderHLAnnually = riderHLoad * (BasicSA/1000) * annFac;
        double RiderHLHalfYear = riderHLoad * (BasicSA/1000) * halfFac;
        double RiderHLQuarterly = riderHLoad * (BasicSA/1000) * quarterFac;
        double RiderHLMonthly = riderHLoad * (BasicSA/1000) * monthFac;
//        NSLog(@"RiderHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",RiderHLAnnually,RiderHLHalfYear,RiderHLQuarterly,RiderHLMonthly);
        
        double annualRider;
        double halfYearRider;
        double quarterRider;
        double monthlyRider;
        if ([RidCode isEqualToString:@"ETPD"])
        {
            double fsar = (65 - getAge) * ridSA;
            NSLog(@"fsar:%.2f",fsar);
            /*
            annualRider = (riderRate *ridSA /100 *annFac) + (RiderHLAnnually /10 *ridSA /100 *annFac) + (fsar /1000 *OccpLoadA *annFac);
            halfYearRider = (riderRate *ridSA /100 *halfFac) + (RiderHLHalfYear /10 *ridSA /100 *halfFac) + (fsar /1000 *OccpLoadH *halfFac);
            quarterRider = (riderRate *ridSA /100 *quarterFac) + (RiderHLQuarterly /10 *ridSA /100 *quarterFac) + (fsar /1000 *OccpLoadQ *quarterFac);
            monthlyRider = (riderRate *ridSA /100 *monthFac) + (RiderHLMonthly /10 *ridSA /100 *monthFac) + (fsar /1000 *OccpLoadM *monthFac); */
            
            annualRider = (riderRate *ridSA /100 *annFac) + (RiderHLAnnually /10 *ridSA /100 *annFac);
            halfYearRider = (riderRate *ridSA /100 *halfFac) + (RiderHLHalfYear /10 *ridSA /100 *halfFac);
            quarterRider = (riderRate *ridSA /100 *quarterFac) + (RiderHLQuarterly /10 *ridSA /100 *quarterFac);
            monthlyRider = (riderRate *ridSA /100 *monthFac) + (RiderHLMonthly /10 *ridSA /100 *monthFac);
        }
        else if ([RidCode isEqualToString:@"I20R"]||[RidCode isEqualToString:@"I30R"]||[RidCode isEqualToString:@"I40R"]||[RidCode isEqualToString:@"IE20R"]||[RidCode isEqualToString:@"IE30R"])
        {
            double occLoadFactorA = occLoadRider * (((double)(ridTerm + 1))/2);
            double occLoadFactorH = occLoadRider * (((double)(ridTerm + 1))/2);
            double occLoadFactorQ = occLoadRider * (((double)(ridTerm + 1))/2);
            double occLoadFactorM = occLoadRider * (((double)(ridTerm + 1))/2);
            
            double calLoadA = occLoadFactorA *ridSA /1000 *annFac;
            double calLoadH = occLoadFactorH *ridSA /1000 *halfFac;
            double calLoadQ = occLoadFactorQ *ridSA /1000 *quarterFac;
            double calLoadM = occLoadFactorM *ridSA /1000 *monthFac;
            NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
            NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
            NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
            NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
            strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            annualRider = (riderRate *ridSA /1000 *annFac) + ([strLoadA doubleValue]) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + ([strLoadH doubleValue]) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + ([strLoadQ doubleValue]) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + ([strLoadM doubleValue]) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        else if ([RidCode isEqualToString:@"ICR"])
        {
            /*
            annualRider = (riderRate *ridSA /1000 *annFac) + ((OccpLoadA *ridTerm) *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + ((OccpLoadH *ridTerm) *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + ((OccpLoadQ *ridTerm) *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + ((OccpLoadM *ridTerm) *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac); */
            annualRider = (riderRate *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        else if ([RidCode isEqualToString:@"ID20R"])
        {
            double occLoadFactorA = occLoadRider * (((double)(ridTerm - 20))/2);
            double occLoadFactorH = occLoadRider * (((double)(ridTerm - 20))/2);
            double occLoadFactorQ = occLoadRider * (((double)(ridTerm - 20))/2);
            double occLoadFactorM = occLoadRider * (((double)(ridTerm - 20))/2);
            
            double calLoadA = occLoadFactorA *ridSA /1000 *annFac;
            double calLoadH = occLoadFactorH *ridSA /1000 *halfFac;
            double calLoadQ = occLoadFactorQ *ridSA /1000 *quarterFac;
            double calLoadM = occLoadFactorM *ridSA /1000 *monthFac;
            NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
            NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
            NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
            NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
            strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            annualRider = (riderRate *ridSA /1000 *annFac) + ([strLoadA doubleValue]) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + ([strLoadH doubleValue]) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + ([strLoadQ doubleValue]) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + ([strLoadM doubleValue]) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        else if ([RidCode isEqualToString:@"ID30R"])
        {
            double occLoadFactorA = occLoadRider * (((double)(ridTerm - 30))/2);
            double occLoadFactorH = occLoadRider * (((double)(ridTerm - 30))/2);
            double occLoadFactorQ = occLoadRider * (((double)(ridTerm - 30))/2);
            double occLoadFactorM = occLoadRider * (((double)(ridTerm - 30))/2);
            
            double calLoadA = occLoadFactorA *ridSA /1000 *annFac;
            double calLoadH = occLoadFactorH *ridSA /1000 *halfFac;
            double calLoadQ = occLoadFactorQ *ridSA /1000 *quarterFac;
            double calLoadM = occLoadFactorM *ridSA /1000 *monthFac;
            NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
            NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
            NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
            NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
            strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            annualRider = (riderRate *ridSA /1000 *annFac) + ([strLoadA doubleValue]) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + ([strLoadH doubleValue]) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + ([strLoadQ doubleValue]) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + ([strLoadM doubleValue]) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        else if ([RidCode isEqualToString:@"ID40R"])
        {
            double occLoadFactorA = occLoadRider * (((double)(ridTerm - 40))/2);
            double occLoadFactorH = occLoadRider * (((double)(ridTerm - 40))/2);
            double occLoadFactorQ = occLoadRider * (((double)(ridTerm - 40))/2);
            double occLoadFactorM = occLoadRider * (((double)(ridTerm - 40))/2);
            
            double calLoadA = occLoadFactorA *ridSA /1000 *annFac;
            double calLoadH = occLoadFactorH *ridSA /1000 *halfFac;
            double calLoadQ = occLoadFactorQ *ridSA /1000 *quarterFac;
            double calLoadM = occLoadFactorM *ridSA /1000 *monthFac;
            NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
            NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
            NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
            NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
            strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            annualRider = (riderRate *ridSA /1000 *annFac) + ([strLoadA doubleValue]) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + ([strLoadH doubleValue]) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + ([strLoadQ doubleValue]) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + ([strLoadM doubleValue]) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        else if ([RidCode isEqualToString:@"MG_II"]||[RidCode isEqualToString:@"MG_IV"]||[RidCode isEqualToString:@"HSP_II"]||[RidCode isEqualToString:@"HMM"])
        {
            annualRider = riderRate * (1 + RiderHLAnnually/100) * annFac;
            halfYearRider = riderRate * (1 + RiderHLHalfYear/100) * halfFac;
            quarterRider = riderRate * (1 + RiderHLQuarterly/100) * quarterFac;
            monthlyRider = riderRate * (1 + RiderHLMonthly/100) * monthFac;
        }
        else if ([RidCode isEqualToString:@"HB"])
        {
            int selectUnit = [[LUnits objectAtIndex:i] intValue];
            annualRider = riderRate * (1 + RiderHLAnnually/100) * selectUnit * annFac;
            halfYearRider = riderRate * (1 + RiderHLHalfYear/100) * selectUnit * halfFac;
            quarterRider = riderRate * (1 + RiderHLQuarterly/100) * selectUnit * quarterFac;
            monthlyRider = riderRate * (1 + RiderHLMonthly/100) * selectUnit * monthFac;
        }
        else if ([RidCode isEqualToString:@"PLCP"]||[RidCode isEqualToString:@"PTR"])
        {
            double RiderHLAnnually = BasicHLoad * (BasicSA/1000) * annFac;
            double RiderHLHalfYear = BasicHLoad * (BasicSA/1000) * halfFac;
            double RiderHLQuarterly = BasicHLoad * (BasicSA/1000) * quarterFac;
            double RiderHLMonthly = BasicHLoad * (BasicSA/1000) * monthFac;
            
            double calLoadA = occLoadRider *ridSA /1000 *annFac;
            double calLoadH = occLoadRider *ridSA /1000 *halfFac;
            double calLoadQ = occLoadRider *ridSA /1000 *quarterFac;
            double calLoadM = occLoadRider *ridSA /1000 *monthFac;
            NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
            NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
            NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
            NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
            strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            annualRider = (riderRate *ridSA /1000 *annFac) + ([strLoadA doubleValue]) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + ([strLoadA doubleValue]) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + ([strLoadA doubleValue]) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + ([strLoadA doubleValue]) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        else if ([RidCode isEqualToString:@"CIR"]||[RidCode isEqualToString:@"C+"]||[RidCode isEqualToString:@"CCTR"])
        {
            annualRider = (riderRate *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        else {
            double calLoadA = occLoadRider *ridSA /1000 *annFac;
            double calLoadH = occLoadRider *ridSA /1000 *halfFac;
            double calLoadQ = occLoadRider *ridSA /1000 *quarterFac;
            double calLoadM = occLoadRider *ridSA /1000 *monthFac;
            NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
            NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
            NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
            NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
            strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            annualRider = (riderRate *ridSA /1000 *annFac) + ([strLoadA doubleValue]) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + ([strLoadH doubleValue]) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + ([strLoadQ doubleValue]) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + ([strLoadM doubleValue]) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        
        NSString *calRiderAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:annualRider]];
        NSString *calRiderHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:halfYearRider]];
        NSString *calRiderQuarter = [formatter stringFromNumber:[NSNumber numberWithDouble:quarterRider]];
        NSString *calRiderMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:monthlyRider]];
        calRiderAnn = [calRiderAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
        calRiderHalf = [calRiderHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
        calRiderQuarter = [calRiderQuarter stringByReplacingOccurrencesOfString:@"," withString:@""];
        calRiderMonth = [calRiderMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
        [annualRiderPrem addObject:calRiderAnn];
        [halfRiderPrem addObject:calRiderHalf];
        [quarterRiderPrem addObject:calRiderQuarter];
        [monthRiderPrem addObject:calRiderMonth];
        NSLog(@"RiderTotal(%@) A:%@, S:%@, Q:%@, M:%@",[LRiderCode objectAtIndex:i],calRiderAnn,calRiderHalf,calRiderQuarter,calRiderMonth);
        
        //for waiver CIWP
        if (!([RidCode isEqualToString:@"LCPR"]) && !([RidCode isEqualToString:@"CIR"]) && !([RidCode isEqualToString:@"PR"]) && !([RidCode isEqualToString:@"LCWP"]) && !([RidCode isEqualToString:@"SP_STD"]) && !([RidCode isEqualToString:@"SP_PRE"]) && !([RidCode isEqualToString:@"CIWP"]) && !([RidCode isEqualToString:@"ICR"])) {
            
            [waiverRiderAnn addObject:calRiderAnn];
            [waiverRiderHalf addObject:calRiderHalf];
            [waiverRiderQuar addObject:calRiderQuarter];
            [waiverRiderMonth addObject:calRiderMonth];
//            NSLog(@"waiver1 insert(%@) A:%@, S:%@, Q:%@, M:%@",RidCode,calRiderAnn,calRiderHalf,calRiderQuarter,calRiderMonth);
        }
        
        //for other waiver
        if (!([RidCode isEqualToString:@"PLCP"]) && !([RidCode isEqualToString:@"CIWP"]) && !([RidCode isEqualToString:@"LCWP"]) && !([RidCode isEqualToString:@"SP_STD"]) && !([RidCode isEqualToString:@"SP_PRE"]) && !([RidCode isEqualToString:@"PR"]) && !([RidCode isEqualToString:@"PTR"])) {
            
            [waiverRiderAnn2 addObject:calRiderAnn];
            [waiverRiderHalf2 addObject:calRiderHalf];
            [waiverRiderQuar2 addObject:calRiderQuarter];
            [waiverRiderMonth2 addObject:calRiderMonth];
//            NSLog(@"waiver2 insert(%@) A:%@, S:%@, Q:%@, M:%@",RidCode,calRiderAnn,calRiderHalf,calRiderQuarter,calRiderMonth);
        }
        
        //for medical rider
        if ([RidCode isEqualToString:@"MG_II"]||[RidCode isEqualToString:@"MG_IV"]||[RidCode isEqualToString:@"HSP_II"]||[RidCode isEqualToString:@"HMM"]||[RidCode isEqualToString:@"HB"]||[RidCode isEqualToString:@"CIR"]||[RidCode isEqualToString:@"C+"]) {
            [annualMedRiderPrem addObject:calRiderAnn];
            [halfMedRiderPrem addObject:calRiderHalf];
            [quarterMedRiderPrem addObject:calRiderQuarter];
            [monthMedRiderPrem addObject:calRiderMonth];
//            NSLog(@"medical insert(%@) A:%@, S:%@, Q:%@, M:%@",RidCode,calRiderAnn,calRiderHalf,calRiderQuarter,calRiderMonth);
        }
        
        //for income rider
        if ([RidCode isEqualToString:@"I20R"]||[RidCode isEqualToString:@"I30R"]||[RidCode isEqualToString:@"I40R"]||[RidCode isEqualToString:@"IE20R"]||[RidCode isEqualToString:@"IE30R"]||[RidCode isEqualToString:@"ID20R"]||[RidCode isEqualToString:@"ID30R"]||[RidCode isEqualToString:@"ID40R"]) {
            
            [incomeRiderCode addObject:RidCode];
            [incomeRiderTerm addObject:[NSString stringWithFormat:@"%d",ridTerm]];
            [incomeRiderSA addObject:[NSString stringWithFormat:@"%.2f",ridSA]];
            [incomeRiderAnn addObject:calRiderAnn];
            [incomeRiderHalf addObject:calRiderHalf];
            [incomeRiderQuar addObject:calRiderQuarter];
            [incomeRiderMonth addObject:calRiderMonth];
            NSLog(@"income insert(%@) A:%@, S:%@, Q:%@, M:%@",RidCode,calRiderAnn,calRiderHalf,calRiderQuarter,calRiderMonth);
            
            //get CSV rate
            [self getRiderCSV:RidCode];
            NSString *csv = [NSString stringWithFormat:@"%.2f",riderCSVRate];
            [incomeRiderCSV addObject:csv];
        }
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

-(void)calculateWaiver
{
    if (waiverRiderAnn.count != 0 && waiverRiderAnn2.count != 0) {
    
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencySymbol:@""];
        [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
        double waiverAnnSum = 0;
        double waiverHalfSum = 0;
        double waiverQuarSum = 0;
        double waiverMonthSum = 0;
        for (NSUInteger m=0; m<[waiverRiderAnn count]; m++) {
            waiverAnnSum = waiverAnnSum + [[waiverRiderAnn objectAtIndex:m] doubleValue];
            waiverHalfSum = waiverHalfSum + [[waiverRiderHalf objectAtIndex:m] doubleValue];
            waiverQuarSum = waiverQuarSum + [[waiverRiderQuar objectAtIndex:m] doubleValue];
            waiverMonthSum = waiverMonthSum + [[waiverRiderMonth objectAtIndex:m] doubleValue];
        }
//        NSLog(@"AccRiderPrem1 A:%.2f, S:%.2f, Q:%.2f, M:%.2f",waiverAnnSum,waiverHalfSum,waiverQuarSum,waiverMonthSum);
    
        double waiverAnnSum2 = 0;
        double waiverHalfSum2 = 0;
        double waiverQuarSum2 = 0;
        double waiverMonthSum2 = 0;
        for (NSUInteger m=0; m<[waiverRiderAnn2 count]; m++) {
            waiverAnnSum2 = waiverAnnSum2 + [[waiverRiderAnn2 objectAtIndex:m] doubleValue];
            waiverHalfSum2 = waiverHalfSum2 + [[waiverRiderHalf2 objectAtIndex:m] doubleValue];
            waiverQuarSum2 = waiverQuarSum2 + [[waiverRiderQuar2 objectAtIndex:m] doubleValue];
            waiverMonthSum2 = waiverMonthSum2 + [[waiverRiderMonth2 objectAtIndex:m] doubleValue];
        }
//        NSLog(@"AccRiderPrem2 A:%.2f, S:%.2f, Q:%.2f, M:%.2f",waiverAnnSum2,waiverHalfSum2,waiverQuarSum2,waiverMonthSum2);
    
        NSMutableArray *waiverRidAnnTol = [[NSMutableArray alloc] init];
        NSMutableArray *waiverRidHalfTol = [[NSMutableArray alloc] init];
        NSMutableArray *waiverRidQuarTol = [[NSMutableArray alloc] init];
        NSMutableArray *waiverRidMonthTol = [[NSMutableArray alloc] init];
    
        NSUInteger i;
        for (i=0; i<[LRiderCode count]; i++) {
        
            NSString *RidCode = [[NSString alloc] initWithFormat:@"%@",[LRiderCode objectAtIndex:i]];
        
            //getpentacode
            const char *dbpath = [databasePath UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
            {
                if ([RidCode isEqualToString:@"CIWP"]||[RidCode isEqualToString:@"LCWP"]||[RidCode isEqualToString:@"PR"]||[RidCode isEqualToString:@"SP_STD"]||[RidCode isEqualToString:@"SP_PRE"]) {
                    pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND Channel=\"AGT\"",RidCode];
                }
                else {
                    sqlite3_close(contactDB);
                    continue;
                }
            
                const char *query_stmt = [pentaSQL UTF8String];
                if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW) {
                        planCodeRider =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    }
                    else {
                        NSLog(@"error access PentaPlanCode");
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(contactDB);
            }
            else {
                sqlite3_close(contactDB);
            }
        
            int ridTerm = [[LTerm objectAtIndex:i] intValue];
            age = [[LAge objectAtIndex:i] intValue];
            sex = [[NSString alloc] initWithFormat:@"%@",[LSex objectAtIndex:i]];
        
            //get rate
            [self getRiderRateAgeSex:planCodeRider riderTerm:ridTerm];
        
            double BasicSA = getBasicSA;
            double BasicHLoad = [riderBH.storedbasicHL doubleValue];
            double ridSA = [[LSumAssured objectAtIndex:i] doubleValue];
            double PolicyTerm = getTerm;
            double riderHLoad;
            if ([LRidHL1K count] != 0) {
                riderHLoad = [[LRidHL1K objectAtIndex:i] doubleValue];
            } else if ([LRidHL100 count] != 0) {
                riderHLoad = [[LRidHL100 objectAtIndex:i] doubleValue];
            } else if ([LRidHLP count] != 0) {
                riderHLoad = [[LRidHLP objectAtIndex:i] doubleValue];
            }
            NSLog(@"waiverRate(%@):%.2f, waiverSum:%.3f, HL:%.3f",RidCode,riderRate,ridSA,riderHLoad);
        
            double annFac = 1;
            double halfFac = 0.5125;
            double quarterFac = 0.2625;
            double monthFac = 0.0875;
        
            //calculate occupationLoading
            pTypeOccp = [LOccpCode objectAtIndex:i];
            [self getOccLoadRider];
            double OccpLoadA = occLoadRider * ((PolicyTerm + 1)/2) * (BasicSA/1000) * annFac;
            double OccpLoadH = occLoadRider * ((PolicyTerm + 1)/2) * (BasicSA/1000) * halfFac;
            double OccpLoadQ = occLoadRider * ((PolicyTerm + 1)/2) * (BasicSA/1000) * quarterFac;
            double OccpLoadM = occLoadRider * ((PolicyTerm + 1)/2) * (BasicSA/1000) * monthFac;
            NSLog(@"RiderOccpL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",OccpLoadA,OccpLoadH,OccpLoadQ,OccpLoadM);
        
            //calculate rider health loading
            double RiderHLAnnually = BasicHLoad * (BasicSA/1000) * annFac;
            double RiderHLHalfYear = BasicHLoad * (BasicSA/1000) * halfFac;
            double RiderHLQuarterly = BasicHLoad * (BasicSA/1000) * quarterFac;
            double RiderHLMonthly = BasicHLoad * (BasicSA/1000) * monthFac;
//            NSLog(@"RiderHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",RiderHLAnnually,RiderHLHalfYear,RiderHLQuarterly,RiderHLMonthly);
        
            double annualRider;
            double halfYearRider;
            double quarterRider;
            double monthlyRider;
            if ([RidCode isEqualToString:@"CIWP"])
            {
                double waiverAnnPrem = ridSA/100 * (waiverAnnSum+basicPremAnn);
                double waiverHalfPrem = ridSA/100 * (waiverHalfSum+basicPremHalf) *2;
                double waiverQuarPrem = ridSA/100 * (waiverQuarSum+basicPremQuar) *4;
                double waiverMonthPrem = ridSA/100 * (waiverMonthSum+basicPremMonth) *12;
//                NSLog(@"waiverSA A:%.2f, S:%.2f, Q:%.2f, M:%.2f",waiverAnnPrem,waiverHalfPrem,waiverQuarPrem,waiverMonthPrem);
            
                double annualRider_ = waiverAnnPrem * (riderRate/100 + ((double)ridTerm)/1000 *0 + RiderHLAnnually/100);
                double halfYearRider_ = waiverHalfPrem * (riderRate/100 + ((double)ridTerm)/1000 *0 + RiderHLHalfYear/100);
                double quarterRider_ = waiverQuarPrem * (riderRate/100 + ((double)ridTerm)/1000 *0 + RiderHLQuarterly/100);
                double monthlyRider_ = waiverMonthPrem * (riderRate/100 + ((double)ridTerm)/1000 *0 + RiderHLMonthly/100);
                NSLog(@"waiverPrem A:%.2f S:%.2f, Q:%.2f, M:%.2f",annualRider_,halfYearRider_,quarterRider_,monthlyRider_);
            
                annualRider = annualRider_ * annFac;
                halfYearRider = halfYearRider_ * halfFac;
                quarterRider = quarterRider_ * quarterFac;
                monthlyRider = monthlyRider_ * monthFac;
            }
            else if ([RidCode isEqualToString:@"LCWP"]||[RidCode isEqualToString:@"PR"]||[RidCode isEqualToString:@"SP_STD"]||[RidCode isEqualToString:@"SP_PRE"])
            {
                double waiverAnnPrem = ridSA/100 * (waiverAnnSum2+basicPremAnn);
                double waiverHalfPrem = ridSA/100 * (waiverHalfSum2+basicPremHalf) *2;
                double waiverQuarPrem = ridSA/100 * (waiverQuarSum2+basicPremQuar) *4;
                double waiverMonthPrem = ridSA/100 * (waiverMonthSum2+basicPremMonth) *12;
//                NSLog(@"waiverSA A:%.2f, S:%.2f, Q:%.2f, M:%.2f",waiverAnnPrem,waiverHalfPrem,waiverQuarPrem,waiverMonthPrem);
            
                double annualRider_ = waiverAnnPrem * (riderRate/100 + ((double)ridTerm)/1000 * occLoadRider + RiderHLAnnually/100);
                double halfYearRider_ = waiverHalfPrem * (riderRate/100 + ((double)ridTerm)/1000 * occLoadRider + RiderHLHalfYear/100);
                double quarterRider_ = waiverQuarPrem * (riderRate/100 + ((double)ridTerm)/1000 * occLoadRider + RiderHLQuarterly/100);
                double monthlyRider_ = waiverMonthPrem * (riderRate/100 + ((double)ridTerm)/1000 * occLoadRider + RiderHLMonthly/100);
                NSLog(@"waiverPrem A:%.2f S:%.2f, Q:%.2f, M:%.2f",annualRider_,halfYearRider_,quarterRider_,monthlyRider_);
            
                annualRider = annualRider_ * annFac;
                halfYearRider = halfYearRider_ * halfFac;
                quarterRider = quarterRider_ * quarterFac;
                monthlyRider = monthlyRider_ * monthFac;
            }
        
            NSString *calRiderAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:annualRider]];
            NSString *calRiderHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:halfYearRider]];
            NSString *calRiderQuarter = [formatter stringFromNumber:[NSNumber numberWithDouble:quarterRider]];
            NSString *calRiderMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:monthlyRider]];
            calRiderAnn = [calRiderAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
            calRiderHalf = [calRiderHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
            calRiderQuarter = [calRiderQuarter stringByReplacingOccurrencesOfString:@"," withString:@""];
            calRiderMonth = [calRiderMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            [waiverRidAnnTol addObject:calRiderAnn];
            [waiverRidHalfTol addObject:calRiderHalf];
            [waiverRidQuarTol addObject:calRiderQuarter];
            [waiverRidMonthTol addObject:calRiderMonth];
            NSLog(@"waiverTotal(%@) A:%@, S:%@, Q:%@, M:%@",RidCode,calRiderAnn,calRiderHalf,calRiderQuarter,calRiderMonth);
        }
    
        NSUInteger a;
        for (a=0; a<[waiverRidAnnTol count]; a++) {
            
            annualRiderSum = annualRiderSum + [[waiverRidAnnTol objectAtIndex:a] doubleValue];
            halfRiderSum = halfRiderSum + [[waiverRidHalfTol objectAtIndex:a] doubleValue];
            quarterRiderSum = quarterRiderSum + [[waiverRidQuarTol objectAtIndex:a] doubleValue];
            monthRiderSum = monthRiderSum + [[waiverRidMonthTol objectAtIndex:a] doubleValue];
            NSLog(@"allRiderSum A:%.2f S:%.2f, Q:%.2f, M:%.2f",annualRiderSum,halfRiderSum,quarterRiderSum,monthRiderSum);
        }
        riderPrem = annualRiderSum;
        double totalPrem = riderPrem + basicPremAnn;
        NSLog(@"RiderPrem:%.2f totalPrem:%.2f",riderPrem,totalPrem);
    }
    else {
        NSLog(@"no waiver exist!");
    }
}

-(void)calculateMedRiderPrem
{
    if (annualMedRiderPrem.count != 0) {
        
        annualMedRiderSum = 0;
        halfMedRiderSum = 0;
        quarterMedRiderSum = 0;
        monthMedRiderSum = 0;
        for (NSUInteger a=0; a<[annualMedRiderPrem count]; a++) {
            annualMedRiderSum = annualMedRiderSum + [[annualMedRiderPrem objectAtIndex:a] doubleValue];
            halfMedRiderSum = halfMedRiderSum + [[halfMedRiderPrem objectAtIndex:a] doubleValue];
            quarterMedRiderSum = quarterMedRiderSum + [[quarterMedRiderPrem objectAtIndex:a] doubleValue];
            monthMedRiderSum = monthMedRiderSum + [[monthMedRiderPrem objectAtIndex:a] doubleValue];
        }
        medRiderPrem = annualMedRiderSum;
        NSLog(@"medPrem:%.2f",medRiderPrem);
    }
    else {
        NSLog(@"non exist medical rider!");
        medRiderPrem = 0;
    }
}

-(void)calculateIncomeRider
{
    if (incomeRiderAnn.count > 0) {
        double sumIncomeAnn = 0;
        double sumIncomeHalf = 0;
        double sumIncomeQuart = 0;
        double sumIncomeMonth = 0;
        for (NSUInteger k=0; k<[incomeRiderAnn count]; k++) {
            sumIncomeAnn = sumIncomeAnn + [[incomeRiderAnn objectAtIndex:k] doubleValue];
            sumIncomeHalf = sumIncomeHalf + [[incomeRiderHalf objectAtIndex:k] doubleValue];
            sumIncomeQuart = sumIncomeQuart +[[incomeRiderQuar objectAtIndex:k] doubleValue];
            sumIncomeMonth = sumIncomeMonth + [[incomeRiderMonth objectAtIndex:k] doubleValue];
        }
        incomeRiderPrem = sumIncomeAnn;
        NSLog(@"incomeRiderPrem:%.2f",incomeRiderPrem);
    }
    else {
        NSLog(@"non exist income rider!");
        incomeRiderPrem = 0;
    }
}

-(void)calculateIncomeRiderInput
{    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];

    //getpentacode
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND PremPayOpt=\"%d\"",riderCode,getMOP];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
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
        
    int ridTerm = [termField.text intValue];
    age = getAge;
    sex = riderH.storedSex;
    
    //get rate
    [self getRiderRateAge:planCodeRider riderTerm:ridTerm];
    
    double BasicSA = getBasicSA;
    double ridSA = [sumField.text doubleValue];
    double riderHLoad = [HLField.text doubleValue];
//    NSLog(@"riderRate(%@):%.2f, ridersum:%.3f, HL:%.3f",riderCode,riderRate,ridSA,riderHLoad);
    
    double annFac = 1;
    double halfFac = 0.5125;
    double quarterFac = 0.2625;
    double monthFac = 0.0875;
        
    //calculate rider health loading
    double RiderHLAnnually = riderHLoad * (BasicSA/1000) * annFac;
    double RiderHLHalfYear = riderHLoad * (BasicSA/1000) * halfFac;
    double RiderHLQuarterly = riderHLoad * (BasicSA/1000) * quarterFac;
    double RiderHLMonthly = riderHLoad * (BasicSA/1000) * monthFac;
//    NSLog(@"RiderHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",RiderHLAnnually,RiderHLHalfYear,RiderHLQuarterly,RiderHLMonthly);
    
    double annualRider;
    double halfYearRider;
    double quarterRider;
    double monthlyRider;
    if ([riderCode isEqualToString:@"I20R"]||[riderCode isEqualToString:@"I30R"]||[riderCode isEqualToString:@"I40R"]||[riderCode isEqualToString:@"IE20R"]||[riderCode isEqualToString:@"IE30R"])
    {
        double occLoadFactorA = occLoadRider * (((double)(ridTerm + 1))/2);
        double occLoadFactorH = occLoadRider * (((double)(ridTerm + 1))/2);
        double occLoadFactorQ = occLoadRider * (((double)(ridTerm + 1))/2);
        double occLoadFactorM = occLoadRider * (((double)(ridTerm + 1))/2);
        
        double calLoadA = occLoadFactorA *ridSA /1000 *annFac;
        double calLoadH = occLoadFactorH *ridSA /1000 *halfFac;
        double calLoadQ = occLoadFactorQ *ridSA /1000 *quarterFac;
        double calLoadM = occLoadFactorM *ridSA /1000 *monthFac;
        NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
        NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
        NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
        NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
        strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        annualRider = (riderRate *ridSA /1000 *annFac) + ([strLoadA doubleValue]) + (RiderHLAnnually *ridSA /1000 *annFac);
        halfYearRider = (riderRate *ridSA /1000 *halfFac) + ([strLoadH doubleValue]) + (RiderHLHalfYear *ridSA /1000 *halfFac);
        quarterRider = (riderRate *ridSA /1000 *quarterFac) + ([strLoadQ doubleValue]) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
        monthlyRider = (riderRate *ridSA /1000 *monthFac) + ([strLoadM doubleValue]) + (RiderHLMonthly *ridSA /1000 *monthFac);
    }
    if ([riderCode isEqualToString:@"ID20R"])
    {
        double occLoadFactorA = occLoadRider * (((double)(ridTerm - 20))/2);
        double occLoadFactorH = occLoadRider * (((double)(ridTerm - 20))/2);
        double occLoadFactorQ = occLoadRider * (((double)(ridTerm - 20))/2);
        double occLoadFactorM = occLoadRider * (((double)(ridTerm - 20))/2);
        
        double calLoadA = occLoadFactorA *ridSA /1000 *annFac;
        double calLoadH = occLoadFactorH *ridSA /1000 *halfFac;
        double calLoadQ = occLoadFactorQ *ridSA /1000 *quarterFac;
        double calLoadM = occLoadFactorM *ridSA /1000 *monthFac;
        NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
        NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
        NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
        NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
        strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        annualRider = (riderRate *ridSA /1000 *annFac) + ([strLoadA doubleValue]) + (RiderHLAnnually *ridSA /1000 *annFac);
        halfYearRider = (riderRate *ridSA /1000 *halfFac) + ([strLoadH doubleValue]) + (RiderHLHalfYear *ridSA /1000 *halfFac);
        quarterRider = (riderRate *ridSA /1000 *quarterFac) + ([strLoadQ doubleValue]) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
        monthlyRider = (riderRate *ridSA /1000 *monthFac) + ([strLoadM doubleValue]) + (RiderHLMonthly *ridSA /1000 *monthFac);
    }
    else if ([riderCode isEqualToString:@"ID30R"])
    {
        double occLoadFactorA = occLoadRider * (((double)(ridTerm - 30))/2);
        double occLoadFactorH = occLoadRider * (((double)(ridTerm - 30))/2);
        double occLoadFactorQ = occLoadRider * (((double)(ridTerm - 30))/2);
        double occLoadFactorM = occLoadRider * (((double)(ridTerm - 30))/2);
        
        double calLoadA = occLoadFactorA *ridSA /1000 *annFac;
        double calLoadH = occLoadFactorH *ridSA /1000 *halfFac;
        double calLoadQ = occLoadFactorQ *ridSA /1000 *quarterFac;
        double calLoadM = occLoadFactorM *ridSA /1000 *monthFac;
        NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
        NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
        NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
        NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
        strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        annualRider = (riderRate *ridSA /1000 *annFac) + ([strLoadA doubleValue]) + (RiderHLAnnually *ridSA /1000 *annFac);
        halfYearRider = (riderRate *ridSA /1000 *halfFac) + ([strLoadA doubleValue]) + (RiderHLHalfYear *ridSA /1000 *halfFac);
        quarterRider = (riderRate *ridSA /1000 *quarterFac) + ([strLoadA doubleValue]) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
        monthlyRider = (riderRate *ridSA /1000 *monthFac) + ([strLoadA doubleValue]) + (RiderHLMonthly *ridSA /1000 *monthFac);
    }
    else if ([riderCode isEqualToString:@"ID40R"])
    {
        double occLoadFactorA = occLoadRider * (((double)(ridTerm - 40))/2);
        double occLoadFactorH = occLoadRider * (((double)(ridTerm - 40))/2);
        double occLoadFactorQ = occLoadRider * (((double)(ridTerm - 40))/2);
        double occLoadFactorM = occLoadRider * (((double)(ridTerm - 40))/2);
        
        double calLoadA = occLoadFactorA *ridSA /1000 *annFac;
        double calLoadH = occLoadFactorH *ridSA /1000 *halfFac;
        double calLoadQ = occLoadFactorQ *ridSA /1000 *quarterFac;
        double calLoadM = occLoadFactorM *ridSA /1000 *monthFac;
        NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
        NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
        NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
        NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
        strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
        strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        annualRider = (riderRate *ridSA /1000 *annFac) + ([strLoadA doubleValue]) + (RiderHLAnnually *ridSA /1000 *annFac);
        halfYearRider = (riderRate *ridSA /1000 *halfFac) + ([strLoadH doubleValue]) + (RiderHLHalfYear *ridSA /1000 *halfFac);
        quarterRider = (riderRate *ridSA /1000 *quarterFac) + ([strLoadQ doubleValue]) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
        monthlyRider = (riderRate *ridSA /1000 *monthFac) + ([strLoadM doubleValue]) + (RiderHLMonthly *ridSA /1000 *monthFac);
    }
    
    //edited by heng to avoid negative yield
    [self getRiderCSV:riderCode];       //get CSV rate 
    inputCSV = riderCSVRate;
    
    NSString *calRiderAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:annualRider]];
    NSString *calRiderHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:halfYearRider]];
    NSString *calRiderQuarter = [formatter stringFromNumber:[NSNumber numberWithDouble:quarterRider]];
    NSString *calRiderMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:monthlyRider]];
    calRiderAnn = [calRiderAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
    calRiderHalf = [calRiderHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
    calRiderQuarter = [calRiderQuarter stringByReplacingOccurrencesOfString:@"," withString:@""];
    calRiderMonth = [calRiderMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
    inputIncomeAnn = [calRiderAnn doubleValue];
    NSLog(@"inputIncomeRiderTot(%@) A:%@, S:%@, Q:%@, M:%@",riderCode,calRiderAnn,calRiderHalf,calRiderQuarter,calRiderMonth);
}


#pragma mark - Action

- (IBAction)btnPTypePressed:(id)sender
{
    if(![popOverConroller isPopoverVisible]){
        
		RiderPTypeTbViewController *popView = [[RiderPTypeTbViewController alloc] initWithString:getSINo];
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
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    self.RiderList = [[RiderListTbViewController alloc] initWithStyle:UITableViewStylePlain];
    _RiderList.delegate = self;
    _RiderList.requestPtype = self.pTypeCode;
    _RiderList.requestSeq = self.PTypeSeq;
    _RiderList.requestOccpClass = riderH.storedOccpClass;
    _RiderList.requestAge = self.pTypeAge;
    self.RiderListPopover = [[UIPopoverController alloc] initWithContentViewController:_RiderList];
    
    [self.RiderListPopover setPopoverContentSize:CGSizeMake(600.0f, 400.0f)];
    [self.RiderListPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)planBtnPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
  
    //if (_planList == Nil) {
        NSString *strSA = [NSString stringWithFormat:@"%.2f",getBasicSA];
        self.planList = [[RiderPlanTb alloc] initWithStyle:UITableViewStylePlain];
        self.planList = [[RiderPlanTb alloc] initWithString:planCondition andSumAss:strSA];
    
    //}
        _planList.delegate = self;
        self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_planList];
    
    [self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 400.0f)];
    [self.planPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)deducBtnPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSString *strSA = [NSString stringWithFormat:@"%.2f",getBasicSA];
    self.deductList = [[RiderDeducTb alloc] initWithString:deducCondition andSumAss:strSA andOption:planOption];
    _deductList.delegate = self;
    self.deducPopover = [[UIPopoverController alloc] initWithContentViewController:_deductList];
    
    [self.deducPopover setPopoverContentSize:CGSizeMake(350.0f, 400.0f)];
    [self.deducPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)doSaveRider:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    [myTableView setEditing:FALSE]; 
    [self.myTableView setEditing:NO animated:TRUE];
    deleteBtn.hidden = true;
    [editBtn setTitle:@"Delete" forState:UIControlStateNormal ];
    
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
    
    if (riderCode.length == 0 || btnAddRider.titleLabel.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select a Rider." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (term) {
        NSLog(@"validate - 1st term");
        [self validateTerm];
    }
    else if (sumA) {
        NSLog(@"validate - 2nd sum");
        [self validateSum];
    }
    else if (unit) {
        NSLog(@"validate - 3rd unit");
        [self validateUnit];
    }
    else {
        NSLog(@"validate - 4th save");
        [self validateSaver];
    }
     
}

/*
- (IBAction)goBack:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (dataInsert.count != 0) {
        for (NSUInteger i=0; i< dataInsert.count; i++) {
            BasicPlanHandler *ss = [dataInsert objectAtIndex:i];
            MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
            main.modalPresentationStyle = UIModalPresentationFullScreen;
            main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            main.mainLaH = riderH;
            main.mainBH = ss;
            main.IndexTab = 3;
            main.showQuotation = @"NO";
            [self presentViewController:main animated:YES completion:nil];
        }
    }
    else {
        MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        main.modalPresentationStyle = UIModalPresentationFullScreen;
        main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        main.mainLaH = riderH;
        main.mainBH = riderBH;
        main.IndexTab = 3;
        main.showQuotation = @"NO";
        [self presentModalViewController:main animated:YES];
    }
}*/

- (IBAction)editPressed:(id)sender
{
    [self resignFirstResponder];
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
        msg = [NSString stringWithFormat:@"Delete Rider:%@",[LTypeRiderCode objectAtIndex:value]];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert setTag:1001];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001 && buttonIndex == 0) //delete
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
                NSString *rider = [LTypeRiderCode objectAtIndex:value];
                
                NSString *querySQL = [NSString stringWithFormat:
                            @"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\"",requestSINo,rider];
                
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
            
                [LTypeRiderCode removeObjectAtIndex:value];
                [LTypeSumAssured removeObjectAtIndex:value];
                [LTypeTerm removeObjectAtIndex:value];
                [LTypePlanOpt removeObjectAtIndex:value];
                [LTypeUnits removeObjectAtIndex:value];
                [LTypeDeduct removeObjectAtIndex:value];
                [LTypeRidHL1K removeObjectAtIndex:value];
                [LTypeRidHL100 removeObjectAtIndex:value];
                [LTypeRidHLP removeObjectAtIndex:value];
                [LTypeSmoker removeObjectAtIndex:value];
                [LTypeAge removeObjectAtIndex:value];
                
                if ([pTypeCode isEqualToString:@"PY"] && ([rider isEqualToString:@"LCWP"]||[rider isEqualToString:@"PR"])) {
                    [self checkPayorRider:rider];
                    
                    if (payorRidCode.length != 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Some Rider(s) has been deleted due to marketing rule." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert setTag:1007];
                        [alert show];
                    }
                }
            }
            sqlite3_close(contactDB);
        }

        [myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];        
        [self.myTableView reloadData];
        [self getListingRiderByType];
        [self getListingRider];     //get stored rider
        [self calculateRiderPrem];  //calculate riderPrem
        [self calculateWaiver];     //calculate waiverPrem
        [self calculateMedRiderPrem];       //calculate medicalPrem
        if (medRiderPrem != 0) {
            [self MHIGuideLines];
        }
        
        deleteBtn.enabled = FALSE;
        [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        [_delegate RiderAdded];
    }
    else if (alertView.tag == 1002 && buttonIndex == 0) //delete
    {
        [self deleteRider];
    }
    else if (alertView.tag == 1003 && buttonIndex == 0)
    {
        [self checkingRider];
        if (existRidCode.length == 0) {
            [self saveRider];
        }
        else {
            [self updateRider];
        }
    }
    else if (alertView.tag == 1004 && buttonIndex == 0)     //deleted 2nd LA rider
    {
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\"",requestSINo,secondLARidCode];
            
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
            
            NSString *querySQL2 = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\"",requestSINo,riderCode];
            
            if (sqlite3_prepare_v2(contactDB, [querySQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"rider delete!");
                } else {
                    NSLog(@"rider delete Failed!");
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
        [self getListingRiderByType];
        [self getListingRider];     //get stored rider
        [self calculateRiderPrem];  //calculate riderPrem
        [self calculateWaiver];     //calculate waiverPrem
        [self calculateMedRiderPrem];       //calculate medicalPrem
        if (medRiderPrem != 0) {
            [self MHIGuideLines];
        }
        [_delegate RiderAdded];
    }
    else if (alertView.tag == 1005 && buttonIndex ==0)      //deleting due to business rule
    {
        [self getListingRiderByType];
        [self getListingRider];     //get stored rider
        [self calculateRiderPrem];  //calculate riderPrem
        [self calculateWaiver];     //calculate waiverPrem
        [self calculateMedRiderPrem];       //calculate medicalPrem
        if (medRiderPrem != 0) {
            [self MHIGuideLines];
        }
        [_delegate RiderAdded];
    }
    else if (alertView.tag == 1006 && buttonIndex == 0) //displayed label min/max
    {
        [self displayedMinMax];
    }
    else if (alertView.tag == 1007 && buttonIndex == 0) //deleted payor
    {
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\"",requestSINo,payorRidCode];
            
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
            sqlite3_close(contactDB);
        }
        [self getListingRiderByType];
        [self getListingRider];     //get stored rider
        [self calculateRiderPrem];  //calculate riderPrem
        [self calculateWaiver];     //calculate waiverPrem
        [self calculateMedRiderPrem];       //calculate medicalPrem
        if (medRiderPrem != 0) {
            [self MHIGuideLines];
        }
        [_delegate RiderAdded];
    }
}

#pragma mark - validate

-(void)validateTerm
{
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
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
        [alert setTag:1006];
        [alert show];
        [termField becomeFirstResponder];
    }
    else if ([termField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Rider Term must be numeric 0 to 9 only" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert setTag:1006];
        [alert show];
        [termField becomeFirstResponder];
    }
    else if ([termField.text intValue] > maxRiderTerm) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Term must be less than or equal to %.f",maxRiderTerm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1006];
        [alert show];
        [termField becomeFirstResponder];
    }
    else if ([termField.text intValue] < minTerm) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Term must be greater than or equal to %d",minTerm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1006];
        [alert show];
        [termField becomeFirstResponder];
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
        [HLTField becomeFirstResponder];
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
    NSLog(@"keyin SA:%.f,max:%.f",[sumField.text doubleValue],maxRiderSA);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    NSRange rangeofDot = [sumField.text rangeOfString:@"."];
    NSString *substring = @"";
    
    if (rangeofDot.location != NSNotFound) {
        substring = [sumField.text substringFromIndex:rangeofDot.location ];
    }
    
    if (sumField.text.length <= 0) {
        if (incomeRider) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Guaranteed Yearly Income\n is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert setTag:1006];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider Sum Assured is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert setTag:1006];
            [alert show];
        }
        [sumField becomeFirstResponder];
    }
    else if ([sumField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Input must be numeric 0 to 9 or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert setTag:1006];
        [alert show];
        [sumField becomeFirstResponder];
    }
    else if (incomeRider && substring.length > 3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Guaranteed Yearly Income only allow 2 decimal." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert setTag:1006];
        [alert show];
        [sumField becomeFirstResponder];
    }
    else if (!(incomeRider) && substring.length > 3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider Sum Assured only allow 2 decimal." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert setTag:1006];
        [alert show];
        [sumField becomeFirstResponder];
    }
    else if ([sumField.text doubleValue] < minSATerm && !(incomeRider)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Sum Assured must be greater than or equal to %d",minSATerm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1006];
        [alert show];
        [sumField becomeFirstResponder];
    }
    else if ([sumField.text doubleValue] < minSATerm && incomeRider) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Guaranteed Yearly Income must be greater than or equal to %d",minSATerm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1006];
        [alert show];
        [sumField becomeFirstResponder];
    }
    else if ([sumField.text doubleValue] > maxRiderSA && !(incomeRider)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Sum Assured must be less than or equal to %.f",maxRiderSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1006];
        [alert show];
        [sumField becomeFirstResponder];
    }
    else if ([sumField.text doubleValue] > maxRiderSA && incomeRider) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Guaranteed Yearly Income must be less than or equal to %.f",maxRiderSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1006];
        [alert show];
        [sumField becomeFirstResponder];
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
    NSRange rangeofDot = [unitField.text rangeOfString:@"."];

    if (unitField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider Unit is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1006];
        [alert show];
        [unitField becomeFirstResponder];
    }
    else if ([unitField.text intValue] > maxRiderSA) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Unit must be in the\n range of 1 - %.f",maxRiderSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1006];
        [alert show];
        [unitField becomeFirstResponder];
    }
    else if (rangeofDot.location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Unit must be in the\n range of 1 - %.f and no decimal allowed",maxRiderSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1006];
        [alert show];
        [unitField becomeFirstResponder];
    }
    else {
        NSLog(@"validate - 3rd save");
        [self validateSaver];
    }
}

-(void)validateSaver
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSCharacterSet *setTerm = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    NSRange rangeofDot = [HLField.text rangeOfString:@"."];
    NSString *substring = @"";
    
    if (rangeofDot.location != NSNotFound) {
        substring = [HLField.text substringFromIndex:rangeofDot.location ];
    }
        
    double numHL = [HLField.text doubleValue];
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
    else if ([HLField.text rangeOfCharacterFromSet:set].location != NSNotFound||[HLTField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Health Loading must be numeric 0 to 9 or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLField becomeFirstResponder];
        
    }
    else if (inputHLPercentage.length != 0 && [HLField.text intValue] > 500) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) cannot greater than 500%" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLField becomeFirstResponder];
        
    }
    else if (HLField.text.length == 0 && HLTField.text.length != 0) {
        
        NSString *msg;
        if (HL1kTerm) {
            msg = @"Health Loading (per 1k SA) is required.";
        } else if (HL100kTerm) {
            msg = @"Health Loading (per 100 SA) is required.";
        } else if (HLPTerm) {
            msg = @"Health Loading (%) is required.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLField becomeFirstResponder];
        
    }
    else if (HLField.text.length != 0 && HLTField.text.length == 0) {
        
        NSString *msg;
        if (HL1kTerm) {
            msg = @"Health Loading (per 1k SA) Term is required.";
        } else if (HL100kTerm) {
            msg = @"Health Loading (per 100 SA) Term is required.";
        } else if (HLPTerm) {
            msg = @"Health Loading (%) Term is required.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLTField becomeFirstResponder];
        
    }
    else if (inputHL1KSA.length != 0 && [HLField.text intValue] > 10000) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (Per 1k SA) cannot greater than 10000." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLField becomeFirstResponder];
        
    }
    else if (inputHL1KSA.length !=0 && substring.length > 3) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (Per 1k SA) only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if (inputHL100SA.length !=0 && substring.length > 3) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (Per 100k SA) only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if (inputHLPercentage.length != 0 && substring.length > 1) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) must not contains decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if (inputHLPercentage.length != 0 && msg2.length > 1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) must be in multiple of 25 or 0." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if ([HLTField.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        
        NSString *msg;
        if (HL1kTerm) {
            msg = @"Invalid input. Please enter numeric value (0-9) into Health Loading (per 1k SA) Term.";
        } else if (HL100kTerm) {
            msg = @"Invalid input. Please enter numeric value (0-9) into Health Loading (per 100k SA) Term.";
        } else if (HLPTerm) {
            msg = @"Invalid input. Please enter numeric value (0-9) into Health Loading (%) Term.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLTField becomeFirstResponder];
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
    else if (([riderCode isEqualToString:@"HMM"] && LRiderCode.count != 0)||([riderCode isEqualToString:@"HSP_II"] && LRiderCode.count != 0)||([riderCode isEqualToString:@"MG_II"] && LRiderCode.count != 0)||([riderCode isEqualToString:@"MG_IV"] && LRiderCode.count != 0)) {
        NSLog(@"go RoomBoard!");
        [self RoomBoard];
    }
    else if (([riderCode isEqualToString:@"I20R"] && LRiderCode.count != 0) || ([riderCode isEqualToString:@"I30R"] && LRiderCode.count != 0) || ([riderCode isEqualToString:@"I40R"] && LRiderCode.count != 0) || ([riderCode isEqualToString:@"IE20R"] && LRiderCode.count != 0) || ([riderCode isEqualToString:@"IE30R"] && LRiderCode.count != 0) || ([riderCode isEqualToString:@"ID20R"] && LRiderCode.count != 0) || ([riderCode isEqualToString:@"ID30R"] && LRiderCode.count != 0) || ([riderCode isEqualToString:@"ID40R"] && LRiderCode.count != 0)) {
        
        NSLog(@"go Negative Yield!");
        [self calculateIncomeRider];        //calculate existing income rider
        [self calculateIncomeRiderInput];   //calculate entered income rider         
        [self NegativeYield];
    }
    else if (([riderCode isEqualToString:@"I20R"] && LRiderCode.count == 0) || ([riderCode isEqualToString:@"I30R"] && LRiderCode.count == 0) || ([riderCode isEqualToString:@"I40R"] && LRiderCode.count == 0) || ([riderCode isEqualToString:@"IE20R"] && LRiderCode.count == 0) || ([riderCode isEqualToString:@"IE30R"] && LRiderCode.count == 0) || ([riderCode isEqualToString:@"ID20R"] && LRiderCode.count == 0) || ([riderCode isEqualToString:@"ID30R"] && LRiderCode.count == 0) || ([riderCode isEqualToString:@"ID40R"] && LRiderCode.count == 0)) {
        
        NSLog(@"go Negative Yield2 - empty listing!");
        [self calculateIncomeRider];
        [self calculateIncomeRiderInput];
        [self NegativeYield];
    }
    else {
        [self checkingRider];
        if (existRidCode.length == 0) {
            
            [self saveRider];
        } else {
            
            [self updateRider];
        }
    }
}

-(void)MHIGuideLines
{
    double totalPrem;
    double medicDouble;
    double minus;
    double varSA;
    double riderSA;
    double RiderSA;
    bool pop = false;
    
    totalPrem = basicPremAnn + riderPrem;
    medicDouble = medRiderPrem * 2;
    NSLog(@"~totalPrem:%.2f, medicalPrem:%.2f, medicDouble:%.2f",totalPrem,medRiderPrem,medicDouble);

    if (medicDouble > totalPrem) {
        minus = totalPrem - medRiderPrem;
        NSLog(@"minus:%.2f",minus);
        NSLog(@"basicSA:%.f",getBasicSA);
        if (minus > 0) {
            
            varSA = medRiderPrem/minus * getBasicSA + 0.5;
            NSString *newBasicSA = [NSString stringWithFormat:@"%.f",varSA];
            NSLog(@":1-UPDATE newBasicSA:%.f",varSA);
            getBasicSA = [newBasicSA doubleValue];
            [self getLSDRate];
            pop = true;
            
            //update basicSA to varSA
            sqlite3_stmt *statement;
            if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
                NSString *querySQL = [NSString stringWithFormat:
                                      @"UPDATE Trad_Details SET BasicSA=\"%@\" WHERE SINo=\"%@\"",newBasicSA, getSINo];
                
                if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                        /*
                        dataInsert = [[NSMutableArray alloc] init];
                        BasicPlanHandler *ss = [[BasicPlanHandler alloc] init];
                        [dataInsert addObject:[[BasicPlanHandler alloc] initWithSI:SINoPlan andAge:requestAge andOccpCode:pTypeOccp andCovered:getTerm andBasicSA:newBasicSA andBasicHL:riderBH.storedbasicHL andMOP:requestMOP andPlanCode:requestPlanCode andAdvance:riderBH.storedAdvance]];
                        
                        for (NSUInteger i=0; i< dataInsert.count; i++) {
                            ss = [dataInsert objectAtIndex:i];
                            NSLog(@"storedbasicSA:%@",ss.storedbasicSA);
                        } */
                        
                    } else {
                        NSLog(@"BasicSA update Failed!");
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(contactDB);
            }
            
            //update riderSA
            for (NSUInteger u=0; u<[LRiderCode count]; u++)
            {
                NSString *ridCode = [[NSString alloc] initWithFormat:@"%@",[LRiderCode objectAtIndex:u]];
                
                if (!([ridCode isEqualToString:@"C+"]) && !([ridCode isEqualToString:@"CIR"]) && !([ridCode isEqualToString:@"MG_II"]) && !([ridCode isEqualToString:@"MG_IV"]) && !([ridCode isEqualToString:@"HB"]) && !([ridCode isEqualToString:@"HSP_II"]) && !([ridCode isEqualToString:@"HMM"]) && !([ridCode isEqualToString:@"CIWP"]) && !([ridCode isEqualToString:@"LCWP"]) && !([ridCode isEqualToString:@"PR"]) && !([ridCode isEqualToString:@"SP_STD"]) && !([ridCode isEqualToString:@"SP_PRE"]))
                {
                    riderCode = [LRiderCode objectAtIndex:u];
                    [self getRiderTermRule];
                    riderSA = [[LSumAssured objectAtIndex:u] doubleValue];
                    
                    if (riderSA > 0)
                    {
                        RiderSA = (medRiderPrem/minus) * riderSA;
                        NSLog(@"1-newRiderSA(%@):%.2f, oldRiderSA:%.2f, maxSA:%d",riderCode,RiderSA,riderSA,maxSATerm);
                        
                        double newSA;
                        if (RiderSA > maxSATerm) {
                            newSA = maxSATerm;
                        }
                        else {
                            newSA = RiderSA;
                        }
                        
                        NSLog(@":1-UPDATE newRiderSA(%@):%.2f",riderCode,newSA);
                        sqlite3_stmt *statement;
                        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
                        {
                            NSString *updatetSQL = [NSString stringWithFormat:
                                    @"UPDATE Trad_Rider_Details SET SumAssured=\"%.f\" WHERE SINo=\"%@\" AND RiderCode=\"%@\" AND PTypeCode=\"%@\" AND Seq=\"%d\"",newSA,getSINo,riderCode,pTypeCode, PTypeSeq];
                            
                            if(sqlite3_prepare_v2(contactDB, [updatetSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                if (sqlite3_step(statement) == SQLITE_DONE) {
//                                    NSLog(@"Update RiderSA success!");
                                } else {
                                    NSLog(@"Update RiderSA failed!");
                                }
                                sqlite3_finalize(statement);
                            }
                            sqlite3_close(contactDB);
                        }
                    }
                }
                else {
                    continue;
                }
            }
            
            [self calculateBasicPremium];
            [self getListingRiderByType];
            [self getListingRider];     //get stored rider
            [self calculateRiderPrem];  //calculate riderPrem
            [self calculateWaiver];     //calculate waiverPrem
            [self calculateMedRiderPrem];       //calculate medicalPrem
            
            //--second cycle--//
            
            totalPrem = basicPremAnn + riderPrem;
            medicDouble = medRiderPrem * 2;
            NSLog(@"~newTotalPrem:%.2f, newMedicalPrem:%.2f, newMedicDouble:%.2f",totalPrem,medRiderPrem,medicDouble);
            
            if (medicDouble > totalPrem) {
                minus = totalPrem - medRiderPrem;
                if (minus > 0) {
                    
                    varSA = medRiderPrem/minus * getBasicSA + 0.5;
                    newBasicSA = [NSString stringWithFormat:@"%.f",varSA];
                    NSLog(@":2-UPDATE newBasicSA:%.f",varSA);
                    getBasicSA = [newBasicSA doubleValue];
                    [self getLSDRate];
                    pop = true;
        
                    //update basicSA to varSA
                    sqlite3_stmt *statement;
                    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
                        NSString *querySQL = [NSString stringWithFormat:
                                              @"UPDATE Trad_Details SET BasicSA=\"%@\" WHERE SINo=\"%@\"",newBasicSA, getSINo];
                        
                        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                            if (sqlite3_step(statement) == SQLITE_DONE) {
                                
                                /*
                                dataInsert = [[NSMutableArray alloc] init];
                                BasicPlanHandler *ss = [[BasicPlanHandler alloc] init];
                                [dataInsert addObject:[[BasicPlanHandler alloc] initWithSI:SINoPlan andAge:requestAge andOccpCode:pTypeOccp andCovered:getTerm andBasicSA:newBasicSA andBasicHL:riderBH.storedbasicHL andMOP:requestMOP andPlanCode:requestPlanCode andAdvance:riderBH.storedAdvance]];
                                
                                for (NSUInteger i=0; i< dataInsert.count; i++) {
                                    ss = [dataInsert objectAtIndex:i];
                                    NSLog(@"storedbasicSA:%@",ss.storedbasicSA);
                                } */
                                
                            } else {
                                NSLog(@"BasicSA update Failed!");
                            }
                            sqlite3_finalize(statement);
                        }
                        sqlite3_close(contactDB);
                    }
                    
                    //update riderSA
                    for (NSUInteger u=0; u<[LRiderCode count]; u++)
                    {
                        NSString *ridCode = [[NSString alloc] initWithFormat:@"%@",[LRiderCode objectAtIndex:u]];
                        
                        if (!([ridCode isEqualToString:@"C+"]) && !([ridCode isEqualToString:@"CIR"]) && !([ridCode isEqualToString:@"MG_II"]) && !([ridCode isEqualToString:@"MG_IV"]) && !([ridCode isEqualToString:@"HB"]) && !([ridCode isEqualToString:@"HSP_II"]) && !([ridCode isEqualToString:@"HMM"]) && !([ridCode isEqualToString:@"CIWP"]) && !([ridCode isEqualToString:@"LCWP"]) && !([ridCode isEqualToString:@"PR"]) && !([ridCode isEqualToString:@"SP_STD"]) && !([ridCode isEqualToString:@"SP_PRE"]))
                        {
                            riderCode = [LRiderCode objectAtIndex:u];
                            [self getRiderTermRule];
                            riderSA = [[LSumAssured objectAtIndex:u] doubleValue];
                            
                            if (riderSA > 0)
                            {
                                RiderSA = (medRiderPrem/minus) * riderSA;
                                NSLog(@"2-newRiderSA(%@):%.2f, oldRiderSA:%.2f, maxSA:%d",riderCode,RiderSA,riderSA,maxSATerm);
                                
                                double newSA;
                                if (RiderSA > maxSATerm)
                                {
                                    newSA = maxSATerm;
                                } else {
                                    newSA = RiderSA;
                                }
                                
                                NSLog(@":2-UPDATE newRiderSA(%@):%.2f",riderCode,newSA);
                                //update riderSA
                                sqlite3_stmt *statement;
                                if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
                                {
                                    NSString *updatetSQL = [NSString stringWithFormat:
                                        @"UPDATE Trad_Rider_Details SET SumAssured=\"%.f\" WHERE SINo=\"%@\" AND RiderCode=\"%@\" AND PTypeCode=\"%@\" AND Seq=\"%d\"",newSA,getSINo,riderCode,pTypeCode, PTypeSeq];
                                    
                                    if(sqlite3_prepare_v2(contactDB, [updatetSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                        if (sqlite3_step(statement) == SQLITE_DONE) {
                                            //                                                NSLog(@"Update RiderSA success!");
                                        } else {
                                            NSLog(@"Update RiderSA failed!");
                                        }
                                        sqlite3_finalize(statement);
                                    }
                                    sqlite3_close(contactDB);
                                }

                            }
                        }
                        else {
                            continue;
                        }
                    }
                    
                    [self calculateBasicPremium];
                    [self getListingRiderByType];
                    [self getListingRider];     //get stored rider
                    [self calculateRiderPrem];  //calculate riderPrem
                    [self calculateWaiver];     //calculate waiverPrem
                    [self calculateMedRiderPrem];       //calculate medicalPrem
                    
                    //--third cycle--//
                    
                    totalPrem = basicPremAnn + riderPrem;
                    medicDouble = medRiderPrem * 2;
                    NSLog(@"~newTotalPrem:%.2f, newMedicalPrem:%.2f, newMedicDouble:%.2f",totalPrem,medRiderPrem,medicDouble);
                }
            }
            
            if (pop) {
                AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                //zzz.MhiMessage = [NSString stringWithFormat:@"Basic Sum Assured will be increase to RM%@ in accordance to MHI Guideline",newBasicSA];
                zzz.MhiMessage = newBasicSA;
                
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Basic Sum Assured will be increase to RM%@ in accordance to MHI Guideline",newBasicSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"No", nil];
                //[alert show];
                [_delegate BasicSARevised:newBasicSA];
            }else {
                AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                zzz.MhiMessage = @"";
                
            }
           
        }
        else {
            NSLog(@"value minus not greater than 0");
        }
    }
    else {
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
                
                [self getListCombNo];   //get combNo for all saved rider
                NSString *tempCombNo = [NSString stringWithFormat:@"%d",CombNo];
                [arrCombNo addObject:tempCombNo];
                
                [self getListRBBenefit];        //get existing benefit
                NSString *tempBenefit = [NSString stringWithFormat:@"%d",RBBenefit];
                [arrRBBenefit addObject:tempBenefit];
                
                NSLog(@"CombNo:%d, Benefit:%d Code:%@",CombNo,RBBenefit,[LRiderCode objectAtIndex:i]);
                
            } else {
                continue;
            }
        }
        
        //start combine validate
        //--calculate existing benefit
        double allBenefit = 0;
        for (NSUInteger x=0; x<arrRBBenefit.count; x++) {
            allBenefit = allBenefit + [[arrRBBenefit objectAtIndex:x] doubleValue];
        }
        NSLog(@"total listBenefit:%.f",allBenefit);
        
        [self getCombNo];       //--get selected CombNo
        NSString *tempCombNo = [NSString stringWithFormat:@"%d",CombNo];
        [arrCombNo addObject:tempCombNo];
        
        NSSortDescriptor *aDesc = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];     //--sort combNo
        [arrCombNo sortUsingDescriptors:[NSArray arrayWithObjects:aDesc, nil]];
        
        NSString *newComb =[[NSString alloc] init];     //--combine all CombNo
        for ( NSUInteger y=0; y<arrCombNo.count; y++) {
            newComb = [newComb stringByAppendingString:[arrCombNo objectAtIndex:y]];        
        }
        AllCombNo = [newComb intValue];
        NSLog(@"newComb:%@",newComb);
        
        [self getRBBenefit];        //--get selected RBBenefit and calculate all bnefit
        allBenefit = allBenefit + RBBenefit;
        NSLog(@"total allBenefit:%.f",allBenefit);
        
        //get Limit,RBGroup
        [self getRBLimit];
        
        if (allBenefit > RBLimit) {
            if (RBGroup == 1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Traditional" message:[NSString stringWithFormat:@"Total Daily Room & Board Benefit for combination of all MedGLOBAL rider(s) must be less than or equal to RM%d for 1st LA.",RBLimit] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                [self roomBoardDefaultPlan];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Traditional" message:[NSString stringWithFormat:@"Total Daily Room & Board Benefit for combination of all MedGLOBAL, HSP II and Major Medi rider(s) must be less than or equal to RM%d for 1st LA.",RBLimit] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                [self roomBoardDefaultPlan];
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
                [self roomBoardDefaultPlan];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Traditional" message:[NSString stringWithFormat:@"Total Daily Room & Board Benefit for combination of all MedGLOBAL, HSP II and Major Medi rider(s) must be less than or equal to RM%d for 1st LA.",RBLimit] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self roomBoardDefaultPlan];
            }
        } else {
            NSLog(@"will update data");
            [self updateRider];
        }
    }
}

-(void)NegativeYield
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    //--TPremiumPayable (basic+incomeRider)
    double TPremiumPayable = (basicPremAnn + incomeRiderPrem + inputIncomeAnn) * getMOP;
    NSLog(@"basicPrem:%.2f, existIncomePrem:%.2f, inputIncomePrem:%.2f",basicPremAnn,incomeRiderPrem,inputIncomeAnn);
    
    //--rider GYI & CSV
    incomeRiderGYI = [[NSMutableArray alloc] init];
    NSMutableArray *RiderGYI = [[NSMutableArray alloc] init];
    NSMutableArray *RiderCSV = [[NSMutableArray alloc] init];
    NSMutableArray *BasicGYI = [[NSMutableArray alloc] init];
    
    double _sumRiderGYI = 0;
    double _sumRiderCSV = 0;
    if (incomeRiderCode.count != 0) {
        
        for (NSUInteger m=0; m<incomeRiderCode.count; m++) {
            
            int CovPrd = [[incomeRiderTerm objectAtIndex:m] intValue];
            NSString *RidCode = [incomeRiderCode objectAtIndex:m];
            double _riderSA = [[incomeRiderSA objectAtIndex:m] doubleValue];
            
            for (int n=1; n<=CovPrd; n++) {     //get gyi value for each income rider
                double GYIRate;
                double _GYI;
                if ([RidCode isEqualToString:@"ID20R"] ) {
                    if (CovPrd >= 21 && CovPrd < 91 ) {
                        GYIRate = 100.00;
                    }
                    else {
                        GYIRate = 0.00;
                    }
                }
                else if ([RidCode isEqualToString:@"ID30R"]) {
                    if (CovPrd >= 31 && CovPrd < 91 ) {
                        GYIRate = 100.00;
                    }
                    else {
                        GYIRate = 0.00;
                    }
                }
                else if ([RidCode isEqualToString:@"ID40R"]) {
                    if (CovPrd >= 41 && CovPrd < 91 ) {
                       GYIRate = 100.00;
                    }
                    else {
                        GYIRate = 0.00;
                    }
                }
                else if ([RidCode isEqualToString:@"I20R"]||[RidCode isEqualToString:@"IE20R"] ) {
                    if (CovPrd < 21) {
                        GYIRate = 100.00;
                    }
                    else {
                        GYIRate = 0.00;
                    }
                }
                else if ([RidCode isEqualToString:@"I30R"]||[RidCode isEqualToString:@"IE30R"]) {
                    if (CovPrd < 31) {
                        GYIRate = 100.00;
                    }
                    else {
                        GYIRate = 0.00;
                    }
                }
                else if ([RidCode isEqualToString:@"I40R"]) {
                    if (CovPrd < 41) {
                        GYIRate = 100.00;
                    }
                    else {
                        GYIRate = 0.00;
                    }
                }
                            
                _GYI = _riderSA * (GYIRate/100);
                NSString *strGYI = [formatter stringFromNumber:[NSNumber numberWithDouble:_GYI]];
                strGYI = [strGYI stringByReplacingOccurrencesOfString:@"," withString:@""];
                [RiderGYI addObject:strGYI];
            }
                
            double _sumGYI;
            for (int j=0; j<RiderGYI.count; j++) {      //sum all gyi
                _sumGYI = _sumGYI + [[RiderGYI objectAtIndex:j] doubleValue];
            }
                
            NSString *strGYI = [formatter stringFromNumber:[NSNumber numberWithDouble:_sumGYI]];
            strGYI = [strGYI stringByReplacingOccurrencesOfString:@"," withString:@""];
            [incomeRiderGYI addObject:strGYI];

            double _csv = [[incomeRiderCSV objectAtIndex:m] doubleValue];
            double _riderCSV = _csv * _riderSA / 1000;
            NSString *strCalCSV = [formatter stringFromNumber:[NSNumber numberWithDouble:_riderCSV]];
            strCalCSV = [strCalCSV stringByReplacingOccurrencesOfString:@"," withString:@""];
            [RiderCSV addObject:strCalCSV];
        }
        
        for (int h=0; h<incomeRiderGYI.count; h++) {
            _sumRiderGYI = _sumRiderGYI + [[incomeRiderGYI objectAtIndex:h] doubleValue];
        }
        
        for (int n=0; n<RiderCSV.count; n++) {
            _sumRiderCSV = _sumRiderCSV + [[RiderCSV objectAtIndex:n] doubleValue];
        }
    }
    
    //input rider GYI and CSV
    NSMutableArray *InputRiderGYI = [[NSMutableArray alloc] init];
    int inputTerm = [termField.text intValue];
    double _inputSA = [sumField.text doubleValue];
    
    for (int n=1; n<=inputTerm; n++) {
        double GYIRate;
        double _GYI;
        if ([riderCode isEqualToString:@"ID20R"] ) {
            if (inputTerm >= 21 && inputTerm < 91 ) {
                GYIRate = 100.00;
            }
            else {
                GYIRate = 0.00;
            }
        }
        else if ([riderCode isEqualToString:@"ID30R"]) {
            if (inputTerm >= 31 && inputTerm < 91 ) {
                GYIRate = 100.00;
            }
            else {
                GYIRate = 0.00;
            }
        }
        else if ([riderCode isEqualToString:@"ID40R"]) {
            if (inputTerm >= 41 && inputTerm < 91 ) {
                GYIRate = 100.00;
            }
            else {
                GYIRate = 0.00;
            }
        }
        else if ([riderCode isEqualToString:@"I20R"]||[riderCode isEqualToString:@"IE20R"] ) {
            if (inputTerm < 21) {
                GYIRate = 100.00;
            }
            else {
                GYIRate = 0.00;
            }
        }
        else if ([riderCode isEqualToString:@"I30R"]||[riderCode isEqualToString:@"IE30R"]) {
            if (inputTerm < 31) {
                GYIRate = 100.00;
            }
            else {
                GYIRate = 0.00;
            }
        }
        else if ([riderCode isEqualToString:@"I40R"]) {
            if (inputTerm < 41) {
                GYIRate = 100.00;
            }
            else {
                GYIRate = 0.00;
            }
        }
             
        _GYI = _inputSA * (GYIRate/100);
        NSString *strGYI = [formatter stringFromNumber:[NSNumber numberWithDouble:_GYI]];
        strGYI = [strGYI stringByReplacingOccurrencesOfString:@"," withString:@""];
        [InputRiderGYI addObject:strGYI];
    }
    double _sumInputGYI= 0;
    for (int k=0; k<InputRiderGYI.count; k++) {
        _sumInputGYI = _sumInputGYI + [[InputRiderGYI objectAtIndex:k] doubleValue];
    }
    double _inputCSV = inputCSV * _inputSA / 1000;
    NSLog(@"sumRiderGYI:%.2f, inputRiderGYI:%.2f",_sumRiderGYI,_sumInputGYI);
    NSLog(@"sumRiderCSV:%.2f, inputRiderCSV:%.2f",_sumRiderCSV,_inputCSV);
    
    //--basic GYI
    for (int k=1; k<=getTerm; k++) {
        int newAge = k + getAge;
        [self getBasicGYI:newAge];      //get basicGYI rate
        double _basicGYI = getBasicSA * (basicGYIRate/100);

        NSString *strGYI = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicGYI]];
        strGYI = [strGYI stringByReplacingOccurrencesOfString:@"," withString:@""];
        [BasicGYI addObject:strGYI];
    }

    double _sumBasicGYI = 0;
    for (int h=0; h<BasicGYI.count; h++) {
        _sumBasicGYI = _sumBasicGYI + [[BasicGYI objectAtIndex:h] doubleValue];
    }
    
    double totalGYI = _sumBasicGYI + _sumRiderGYI + _sumInputGYI;
    NSLog(@"totalGYI:%.2f",totalGYI);
    
    //--basic CSV
    [self getBasicCSV];         //get basciCSV rate
    double _basicCSV = basicCSVRate * (getBasicSA/1000);
    
    double totalCSV = _basicCSV + _sumRiderCSV + _inputCSV;
    NSLog(@"totalCSV:%.2f",totalCSV);
    
    double totalAll = totalCSV + totalGYI;
    NSLog(@"totalPlusGYI_CSV:%.2f, TPremiumPayable:%.2f",totalAll,TPremiumPayable);
    
    if (TPremiumPayable > totalAll) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please note that the Guaranteed Benefit payout for selected plan maybe lesser than total premium outlay.\nChoose OK to proceed.\nChoose CANCEL to select other plan." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
        [alert setTag:1003];
        [alert show];
    }
    else {
        [self checkingRider];
        if (existRidCode.length == 0) {
            
            [self saveRider];
        } else {
            
            [self updateRider];
        }
    }
}

-(void)roomBoardDefaultPlan
{
    if ([riderCode isEqualToString:@"HMM"]) {
//        planOption = @"HMM_150";
        planOption = medPlanOpt;
        [self.planBtn setTitle:planOption forState:UIControlStateNormal];
    }
    else if ([riderCode isEqualToString:@"HSP_II"]) {
//        planOption = @"Standard";
        planOption = medPlanOpt;
        [self.planBtn setTitle:planOption forState:UIControlStateNormal];
    }
    else if ([riderCode isEqualToString:@"MG_II"]) {
//        planOption = @"MG_II_100";
        planOption = medPlanOpt;
        [self.planBtn setTitle:planOption forState:UIControlStateNormal];
    }
    else if ([riderCode isEqualToString:@"MG_IV"]) {
//        planOption = @"MGIVP_150";
        planOption = medPlanOpt;
        [self.planBtn setTitle:planOption forState:UIControlStateNormal];
    }
}


#pragma mark - DB handling

-(void)getBasicCSV
{
    sqlite3_stmt *statement;
    NSString *querySQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        if (getAdvance > 0) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate FROM Trad_Sys_Basic_CSV WHERE Age=%d AND PolYear=%d AND PremPayOpt=%d AND AdvOption=\"%d\"",getAge,getTerm,getMOP,getAdvance];
        } else {
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate FROM Trad_Sys_Basic_CSV WHERE Age=%d AND PolYear=%d AND PremPayOpt=%d AND AdvOption=\"N\"",getAge,getTerm,getMOP];
        }
        
//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicCSVRate =  sqlite3_column_double(statement, 0);
                NSLog(@"basicCSVRate:%.2f",basicCSVRate);
                
            } else {
                NSLog(@"error access Trad_Sys_Basic_CSV");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getBasicGYI:(int)aAge
{
    sqlite3_stmt *statement;
    NSString *querySQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        if (getAdvance > 0) {
            querySQL = [NSString stringWithFormat:
                        @"Select rate from trad_sys_Basic_GYI WHERE FromAge<=%d AND ToAge>=%d AND advOption=\"%d\" AND PremPayOpt=%d",aAge,aAge,getAdvance,getMOP];
        } else {
            querySQL = [NSString stringWithFormat:
                        @"Select rate from trad_sys_Basic_GYI WHERE FromAge<=%d AND ToAge>=%d AND advOption=\"N\" AND PremPayOpt=%d",aAge,aAge,getMOP];
        }
        
//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicGYIRate =  sqlite3_column_double(statement, 0);
//                NSLog(@"basicGYIRate:%.2f",basicGYIRate);
                
            } else {
                NSLog(@"error access trad_sys_Basic_GYI");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderCSV:(NSString *)code
{
    sqlite3_stmt *statement;
    if (sqlite3_open([RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"Select rate from Trad_Sys_Rider_CSV"
                              " where PlanCode=\"%@\" AND PremPayOpt=%d AND Age=%d ORDER by PolYear desc",code,getMOP, age];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderCSVRate =  sqlite3_column_double(statement, 0);
                NSLog(@"riderCSVRate:%.2f",riderCSVRate);
                
            } else {
                NSLog(@"error access Trad_Sys_Rider_CSV");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

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
                NSLog(@"expiryAge(%@):%d,minTerm:%d,maxTerm:%d,minSA:%d,maxSA:%d",riderCode,expAge,minTerm,maxTerm,minSATerm,maxSATerm);
                
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
        if (getMOP == 6) {
            querySQL = [[NSString alloc] initWithFormat:
                        @"SELECT PremPayOpt_6 FROM Trad_Sys_Rider_GYI WHERE PlanCode=\"%@\" AND FromAge <=\"%d\" AND ToAge >= \"%d\"",riderCode,getAge,getAge];

        } else if (getMOP == 9) {
            querySQL = [[NSString alloc] initWithFormat:
                        @"SELECT PremPayOpt_9 FROM Trad_Sys_Rider_GYI WHERE PlanCode=\"%@\" AND FromAge <=\"%d\" AND ToAge >= \"%d\"",riderCode,getAge,getAge];
        
        } else if (getMOP == 12) {
            querySQL = [[NSString alloc] initWithFormat:
                        @"SELECT PremPayOpt_12 FROM Trad_Sys_Rider_GYI WHERE PlanCode=\"%@\" AND FromAge <=\"%d\" AND ToAge >= \"%d\"",riderCode,getAge,getAge];
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
    if (([pTypeCode isEqualToString:@"LA"]) && (PTypeSeq == 2)) {
        [self check2ndLARider];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    inputSA = [sumField.text doubleValue];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
        @"INSERT INTO Trad_Rider_Details (SINo,  RiderCode, PTypeCode, Seq, RiderTerm, SumAssured, PlanOption, Units, Deductible, HL1KSA, HL1KSATerm, HL100SA, HL100SATerm, HLPercentage, HLPercentageTerm, CreatedAt) VALUES"
        "(\"%@\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%@\", \"%d\", \"%@\", \"%d\", \"%@\")", getSINo,riderCode, pTypeCode, PTypeSeq, termField.text, sumField.text, planOption, unitField.text, deductible, inputHL1KSA, inputHL1KSATerm, inputHL100SA, inputHL100SATerm, inputHLPercentage, inputHLPercentageTerm, dateString];

//        NSLog(@"%@",insertSQL);
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Saved Rider!");
                [_delegate RiderAdded];
            } else {
                NSLog(@"Failed Save Rider!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }

    if (secondLARidCode.length != 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Some Rider(s) has been deleted due to marketing rule." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1004];
        [alert show];
    }
    
    [self getListingRiderByType];
    [self getListingRider];     //get stored rider
    
    if (inputSA > _maxRiderSA) {
        NSLog(@"will delete %@",riderCode);
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Some Rider(s) has been deleted due to marketing rule." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Rider Sum Assured must be less than or equal to %.f",maxRiderSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert setTag:1002];
        [alert show];
    }
    else {
        
        [self calculateRiderPrem];  //calculate riderPrem
        [self calculateWaiver];     //calculate waiverPrem
        [self calculateMedRiderPrem];       //calculate medicalPrem
        if (medRiderPrem != 0) {
            [self MHIGuideLines];
        }
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
    LRidHLTerm = [[NSMutableArray alloc] init ]; // added by heng
    LRidHLPTerm = [[NSMutableArray alloc] init ]; // added by heng
    LRidHL100Term = [[NSMutableArray alloc] init ]; // added by heng
    LOccpCode = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                @"SELECT a.RiderCode, a.SumAssured, a.RiderTerm, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, "
                    "a.HL100SA, a.HLPercentage, c.Smoker,c.Sex, c.ALB, a.HL1KSATerm, a.HLPercentageTerm, a.HL100SATerm, c.OccpCode FROM Trad_Rider_Details a, "
                    "Trad_LAPayor b, Clt_Profile c WHERE a.PTypeCode=b.PTypeCode AND a.Seq=b.Sequence AND b.CustCode=c.CustCode "
                    "AND a.SINo=b.SINo AND a.SINo=\"%@\" ORDER by a.RiderCode asc",getSINo];
        
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
                
                const char *ridTerm = (const char *)sqlite3_column_text(statement, 12);
                [LRidHLTerm addObject:ridTerm == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridTerm]]; //added by heng
                
                const char *ridPTerm = (const char *)sqlite3_column_text(statement, 13);
                [LRidHLPTerm addObject:ridPTerm == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridPTerm]]; //added by heng
                
                const char *ridHL100Term = (const char *)sqlite3_column_text(statement, 14);
                [LRidHL100Term addObject:ridHL100Term == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridHL100Term]]; //added by heng
                
                [LOccpCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)]];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getListingRiderByType
{
    LTypeRiderCode = [[NSMutableArray alloc] init];
    LTypeSumAssured = [[NSMutableArray alloc] init];
    LTypeTerm = [[NSMutableArray alloc] init];
    LTypePlanOpt = [[NSMutableArray alloc] init];
    LTypeUnits = [[NSMutableArray alloc] init];
    LTypeDeduct = [[NSMutableArray alloc] init];
    LTypeRidHL1K = [[NSMutableArray alloc] init];
    LTypeRidHL100 = [[NSMutableArray alloc] init];
    LTypeRidHLP = [[NSMutableArray alloc] init];
    LTypeSmoker = [[NSMutableArray alloc] init];
    LTypeSex = [[NSMutableArray alloc] init];
    LTypeAge = [[NSMutableArray alloc] init];
    LTypeRidHLTerm = [[NSMutableArray alloc] init ]; // added by heng
    LTypeRidHLPTerm = [[NSMutableArray alloc] init ]; // added by heng
    LTypeRidHL100Term = [[NSMutableArray alloc] init ]; // added by heng
    LTypeOccpCode = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = @"";
        if ([pTypeCode isEqualToString:@"PY"]) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT a.RiderCode, a.SumAssured, a.RiderTerm, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, "
                        "a.HL100SA, a.HLPercentage, c.Smoker,c.Sex, c.ALB, a.HL1KSATerm, a.HLPercentageTerm, a.HL100SATerm, c.OccpCode FROM Trad_Rider_Details a, "
                        "Trad_LAPayor b, Clt_Profile c WHERE a.PTypeCode=b.PTypeCode AND a.Seq=b.Sequence AND b.CustCode=c.CustCode "
                        "AND a.SINo=b.SINo AND a.SINo=\"%@\" AND b.Ptypecode = 'PY' ",getSINo];
        }
        else {
            if (PTypeSeq == 2) {
                querySQL = [NSString stringWithFormat:
                            @"SELECT a.RiderCode, a.SumAssured, a.RiderTerm, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, "
                            "a.HL100SA, a.HLPercentage, c.Smoker,c.Sex, c.ALB, a.HL1KSATerm, a.HLPercentageTerm, a.HL100SATerm, c.OccpCode FROM Trad_Rider_Details a, "
                            "Trad_LAPayor b, Clt_Profile c WHERE a.PTypeCode=b.PTypeCode AND a.Seq=b.Sequence AND b.CustCode=c.CustCode "
                            "AND a.SINo=b.SINo AND a.SINo=\"%@\" AND b.Ptypecode = 'LA' AND  b.Sequence = '2' ",getSINo];
            }
            else {
                querySQL = [NSString stringWithFormat:
                            @"SELECT a.RiderCode, a.SumAssured, a.RiderTerm, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, "
                            "a.HL100SA, a.HLPercentage, c.Smoker,c.Sex, c.ALB, a.HL1KSATerm, a.HLPercentageTerm, a.HL100SATerm, c.OccpCode FROM Trad_Rider_Details a, "
                            "Trad_LAPayor b, Clt_Profile c WHERE a.PTypeCode=b.PTypeCode AND a.Seq=b.Sequence AND b.CustCode=c.CustCode "
                            "AND a.SINo=b.SINo AND a.SINo=\"%@\" AND b.Ptypecode = 'LA' AND b.Sequence = '1' ",getSINo];
            }
        }
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [LTypeRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                
                const char *aaRidSA = (const char *)sqlite3_column_text(statement, 1);
                [LTypeSumAssured addObject:aaRidSA == NULL ? @"" :[[NSString alloc] initWithUTF8String:aaRidSA]];
                
                const char *aaTerm = (const char *)sqlite3_column_text(statement, 2);
                [LTypeTerm addObject:aaTerm == NULL ? @"" :[[NSString alloc] initWithUTF8String:aaTerm]];
                
                const char *zzplan = (const char *) sqlite3_column_text(statement, 3);
                [LTypePlanOpt addObject:zzplan == NULL ? @"" :[[NSString alloc] initWithUTF8String:zzplan]];
                
                const char *aaUnit = (const char *)sqlite3_column_text(statement, 4);
                [LTypeUnits addObject:aaUnit == NULL ? @"" :[[NSString alloc] initWithUTF8String:aaUnit]];
                
                const char *deduct2 = (const char *) sqlite3_column_text(statement, 5);
                [LTypeDeduct addObject:deduct2 == NULL ? @"" :[[NSString alloc] initWithUTF8String:deduct2]];
                
                const char *ridHL = (const char *)sqlite3_column_text(statement, 6);
                [LTypeRidHL1K addObject:ridHL == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridHL]];
                
                const char *ridHL100 = (const char *)sqlite3_column_text(statement, 7);
                [LTypeRidHL100 addObject:ridHL100 == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridHL100]];
                
                const char *ridHLP = (const char *)sqlite3_column_text(statement, 8);
                [LTypeRidHLP addObject:ridHLP == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridHLP]];
                
                [LTypeSmoker addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)]];
                [LTypeSex addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)]];
                [LTypeAge addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)]];
                
                const char *ridTerm = (const char *)sqlite3_column_text(statement, 12);
                [LTypeRidHLTerm addObject:ridTerm == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridTerm]]; //added by heng
                
                const char *ridPTerm = (const char *)sqlite3_column_text(statement, 13);
                [LTypeRidHLPTerm addObject:ridPTerm == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridPTerm]]; //added by heng
                
                const char *ridHL100Term = (const char *)sqlite3_column_text(statement, 14);
                [LTypeRidHL100Term addObject:ridHL100Term == NULL ? @"" :[[NSString alloc] initWithUTF8String:ridHL100Term]]; //added by heng
                
                [LTypeOccpCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)]];
            }
            
            if ([LTypeRiderCode count] == 0) {
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
                editBtn.hidden = YES;
                deleteBtn.hidden = true;
                titleHLPTerm.hidden = YES;
                
                [self.myTableView setEditing:NO animated:TRUE];
                [editBtn setTitle:@"Delete" forState:UIControlStateNormal ];
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
                editBtn.hidden = NO;
                titleHLPTerm.hidden = NO;
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
        NSString *querySQL = [NSString stringWithFormat: @"SELECT RiderCode,PlanChoice FROM Trad_Sys_Occp_NotAttach WHERE OccpCode=\"%@\"",pTypeOccp];
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
        NSString *querySQL = [NSString stringWithFormat: @"SELECT RiderCode FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\" AND PTypeCode=\"%@\" AND Seq=\"%d\"",getSINo,riderCode,pTypeCode, PTypeSeq];
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
        NSString *updatetSQL = [NSString stringWithFormat: //changes in inputHLPercentageTerm by heng
                               @"UPDATE Trad_Rider_Details SET RiderTerm=\"%@\", SumAssured=\"%@\", PlanOption=\"%@\", Units=\"%@\", Deductible=\"%@\", HL1KSA=\"%@\", HL1KSATerm=\"%d\", HL100SA=\"%@\", HL100SATerm=\"%d\", HLPercentage=\"%@\", HLPercentageTerm=\"%d\", CreatedAt=\"%@\" WHERE SINo=\"%@\" AND RiderCode=\"%@\" AND PTypeCode=\"%@\" AND Seq=\"%d\"",termField.text, sumField.text, planOption, unitField.text, deductible, inputHL1KSA, inputHL1KSATerm, inputHL100SA, inputHL100SATerm, inputHLPercentage, inputHLPercentageTerm, dateString,getSINo,riderCode,pTypeCode, PTypeSeq];
//        NSLog(@"%@",updatetSQL);
        if(sqlite3_prepare_v2(contactDB, [updatetSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider record sucessfully updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [SuccessAlert show];
                
                [self getListingRider];     //get stored rider
                [self getListingRiderByType];
                [self calculateRiderPrem];  //calculate riderPrem
                [self calculateWaiver];     //calculate waiverPrem
                [self calculateMedRiderPrem];       //calculate medicalPrem
                if (medRiderPrem != 0) {
                    [self MHIGuideLines];
                }
                
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
                    @"SELECT OccLoading_TL FROM Adm_Occp_Loading_Penta WHERE OccpCode=\"%@\"",riderH.storedOccpCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occLoad =  sqlite3_column_int(statement, 0);
                
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getOccLoadRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                    @"SELECT OccLoading_TL FROM Adm_Occp_Loading_Penta WHERE OccpCode=\"%@\"",pTypeOccp];
    
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occLoadRider =  sqlite3_column_int(statement, 0);
                
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getCPAClassType
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Class,PA_CPA,OccLoading_TL FROM Adm_Occp_Loading_Penta WHERE OccpCode=\"%@\"",pTypeOccp];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occClass = sqlite3_column_int(statement, 0);
                occCPA = sqlite3_column_int(statement, 1);
                occLoadType =  sqlite3_column_int(statement, 2);
                NSLog(@"class:%d , cpa:%d, load:%d",occClass,occCPA,occLoadType);
                
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
                @"SELECT  max(RiderTerm) as term FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode !=\"I20R\" AND RiderCode !=\"I30R\" AND RiderCode !=\"I40R\" AND RiderCode !=\"ID20R\" AND RiderCode !=\"ID30R\" AND RiderCode !=\"ID40R\" AND RiderCode !=\"CIWP\" AND RiderCode !=\"LCWP\" AND RiderCode !=\"PR\" AND RiderCode !=\"PLCP\" AND RiderCode !=\"PTR\" AND RiderCode !=\"SP_STD\" AND RiderCode !=\"SP_PRE\" AND RiderCode !=\"IE20R\" AND RiderCode !=\"IE30R\"",getSINo];
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
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Basic_Prem WHERE PlanCode=\"%@\" AND FromTerm=\"%d\" AND FromMortality=0",getPlanCode,getTerm];
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
    NSString *sumAss = [formatter stringFromNumber:[NSNumber numberWithDouble:getBasicSA]];
    sumAss = [sumAss stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LSD FROM Trad_Sys_LSD_HLAIB WHERE PremPayOpt=\"%d\" AND FromSA <=\"%@\" AND ToSA >= \"%@\"",getMOP,sumAss,sumAss];
//        NSLog(@"%@",querySQL);
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

-(void)check2ndLARider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT RiderCode FROM Trad_Rider_Details WHERE SINo=\"%@\" AND PTypeCode=\"%@\" AND Seq=\"%d\"",getSINo,pTypeCode, PTypeSeq];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                secondLARidCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkPayorRider:(NSString *)aaRider
{
    payorRidCode = [[NSString alloc] init];
    sqlite3_stmt *statement;
    NSString *ridPayor = @"";
    
    if ([aaRider isEqualToString:@"LCWP"]) {
        ridPayor = @"PLCP";
    }
    else {
        ridPayor = @"PTR";
    }
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                        @"SELECT RiderCode FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\" ",getSINo,ridPayor];
        
        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                payorRidCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
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
//        NSLog(@"%@",querySQL);
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
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\" AND Sex=\"%@\" AND occpClass = \"%d\"", aaplan,aaterm,aaterm,age,age,sex, getOccpClass];
        
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
                              aaplan,aaterm,aaterm,age,age, getOccpClass];
        
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
                              aaplan,aaterm,aaterm, getOccpClass];
        
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
                              @"SELECT OccpCatCode FROM Adm_OccpCat_Occp WHERE OccpCode=\"%@\"",pTypeOccp];

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
                [self getListingRiderByType];
                [self getListingRider];     //get stored rider
                [self calculateRiderPrem];  //calculate riderPrem
                [self calculateWaiver];     //calculate waiverPrem
                [self calculateMedRiderPrem];       //calculate medicalPrem
                if (medRiderPrem != 0) {
                    [self MHIGuideLines];
                }
                
                [_delegate RiderAdded];
            } else {
                NSLog(@"rider delete Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(NSString *)getRiderDesc:(NSString *) TempRiderCode
{
    sqlite3_stmt *statement;
    NSString *returnValue = @"";
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT RiderDesc FROM Trad_Sys_Rider_Profile WHERE RiderCode=\"%@\" ", TempRiderCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                returnValue = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];;
                
            } else {
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    return returnValue;
}

#pragma mark - Delegate

-(void)PTypeController:(RiderPTypeTbViewController *)inController didSelectCode:(NSString *)code seqNo:(NSString *)seq desc:(NSString *)desc andAge:(NSString *)aage andOccp:(NSString *)aaOccp
{
    if (riderCode != NULL) {
        [self.btnAddRider setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
        riderCode = [[NSString alloc] init];
        [self clearField];
    }
    
    if ([code isEqualToString:@"PY"]) {
        NSString *dd = [desc substringWithRange:NSMakeRange(0, 5)];
        pTypeDesc = [[NSString alloc] initWithFormat:@"%@",dd];
    } else {
        pTypeDesc = [[NSString alloc] initWithFormat:@"%@",desc];
    }
    
    pTypeCode = [[NSString alloc] initWithFormat:@"%@",code];
    PTypeSeq = [seq intValue];
    pTypeAge = [aage intValue];
    pTypeOccp = [[NSString alloc] initWithFormat:@"%@",aaOccp];
    
    [self getCPAClassType];
    
    [self.btnPType setTitle:pTypeDesc forState:UIControlStateNormal];
    [popOverConroller dismissPopoverAnimated:YES];
    NSLog(@"dasdasdadas RIDERVC pType:%@, seq:%d, desc:%@",pTypeCode,PTypeSeq,pTypeDesc);
    [self getListingRiderByType];
    [myTableView reloadData];
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
                foundPayor = YES;
                NSLog(@"enterList-a");
            }
            if ([riderCode isEqualToString:@"PLCP"] && [[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"]) {
                foundLiving = YES;
                NSLog(@"enterList-b");
            }
            if (([riderCode isEqualToString:@"LCWP"] && [[LRiderCode objectAtIndex:i] isEqualToString:@"PR"]) || ([riderCode isEqualToString:@"PR"] && [[LRiderCode objectAtIndex:i] isEqualToString:@"LCWP"])) {
                either = YES;
            }
            if (([riderCode isEqualToString:@"SP_PRE"] && [[LRiderCode objectAtIndex:i] isEqualToString:@"SP_STD"]) || ([riderCode isEqualToString:@"SP_STD"] && [[LRiderCode objectAtIndex:i] isEqualToString:@"SP_PRE"])) {
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
        else if (either) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select either PR or LCWP." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self.btnAddRider setTitle:@"" forState:UIControlStateNormal];
        }
        else if(either2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select either WOP_SP(Standard) or WOP_SP(Premier)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self.btnAddRider setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            NSLog(@"enterList-2!");
            [self getLabelForm];
            [self toggleForm];
            [self getRiderTermRule];
            [self calculateTerm];
            [self calculateSA];
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
        [self calculateTerm];
        [self calculateSA];
    }
    
    if ([riderCode isEqualToString: @"HMM"]||[riderCode isEqualToString: @"HB"]||[riderCode isEqualToString: @"HSP_II"]||[riderCode isEqualToString: @"MG_II"]||[riderCode isEqualToString: @"MG_IV"]) {
        sumLabel.text = @"Sum Assured (RM)";
    }
}

-(void)PlanView:(RiderPlanTb *)inController didSelectItem:(NSString *)item desc:(NSString *)itemdesc
{
    NSLog(@"selectPlan:%@",itemdesc);
    if ([atcRidCode count] != 0)
    {
        NSUInteger k;
        for (k=0; k<[atcRidCode count]; k++) {
            if ([riderCode isEqualToString:@"HMM"] && [[atcPlanChoice objectAtIndex:k] isEqualToString:itemdesc]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider not available - does not meet underwriting rules." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    [self.planPopover dismissPopoverAnimated:YES];
}

-(void)deductView:(RiderDeducTb *)inController didSelectItem:(NSString *)item desc:(NSString *)itemdesc
{
    NSLog(@"selectDeduc:%@",itemdesc);
    [self.deducBtn setTitle:itemdesc forState:UIControlStateNormal];
    deductible = [[NSString alloc] initWithFormat:@"%@",itemdesc];
    
    [self.deducPopover dismissPopoverAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
    return [LTypeRiderCode count];
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
    
    [[cell.contentView viewWithTag:2001] removeFromSuperview ];
    [[cell.contentView viewWithTag:2002] removeFromSuperview ];
    [[cell.contentView viewWithTag:2003] removeFromSuperview ];
    [[cell.contentView viewWithTag:2004] removeFromSuperview ];
    [[cell.contentView viewWithTag:2005] removeFromSuperview ];
    [[cell.contentView viewWithTag:2006] removeFromSuperview ];
    [[cell.contentView viewWithTag:2007] removeFromSuperview ];
    [[cell.contentView viewWithTag:2008] removeFromSuperview ];
    [[cell.contentView viewWithTag:2009] removeFromSuperview ];
    [[cell.contentView viewWithTag:2010] removeFromSuperview ];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    CGRect frame=CGRectMake(-30,0, 110, 50);
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=frame;
    label1.text= [NSString stringWithFormat:@"    %@",[LTypeRiderCode objectAtIndex:indexPath.row]];
    label1.textAlignment = UITextAlignmentCenter;
    label1.tag = 2001;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label1];
    
    CGRect frame2=CGRectMake(80,0, 105, 50);
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=frame2;
    NSString *num = [formatter stringFromNumber:[NSNumber numberWithDouble:[[LTypeSumAssured objectAtIndex:indexPath.row] doubleValue]]];
    label2.text= num;
    label2.textAlignment = UITextAlignmentCenter;
    label2.tag = 2002;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label2];
    
    CGRect frame3=CGRectMake(185,0, 62, 50);
    UILabel *label3=[[UILabel alloc]init];
    label3.frame=frame3;
    label3.text= [LTypeTerm objectAtIndex:indexPath.row];
    label3.textAlignment = UITextAlignmentCenter;
    label3.tag = 2003;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label3];
    
    CGRect frame4=CGRectMake(247,0, 62, 50);
    UILabel *label4=[[UILabel alloc]init];
    label4.frame=frame4;
    label4.text= [LTypeUnits objectAtIndex:indexPath.row];
    label4.textAlignment = UITextAlignmentCenter;
    label4.tag = 2004;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label4];
    
    CGRect frame5=CGRectMake(309,0, 62, 50);
    UILabel *label5=[[UILabel alloc]init];
    label5.frame=frame5;
    label5.text= [NSString stringWithFormat:@"%d",occClass];
    label5.textAlignment = UITextAlignmentCenter;
    label5.tag = 2005;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label5];
    
    CGRect frame6=CGRectMake(371,0, 62, 50);
    UILabel *label6=[[UILabel alloc]init];
    label6.frame=frame6;
    if (occLoadType == 0) {
        label6.text= @"STD";
    } else {
        label6.text= [NSString stringWithFormat:@"%d",occLoadType];
    }
    label6.textAlignment = UITextAlignmentCenter;
    label6.tag = 2006;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label6];
    
    CGRect frame7=CGRectMake(433,0, 63, 50);
    UILabel *label7=[[UILabel alloc]init];
    label7.frame=frame7;
    NSString *hl1k;
    if ([[LTypeRidHL1K objectAtIndex:indexPath.row] isEqualToString:@"(null)"] &&
        [[LTypeRidHL100 objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
        hl1k = @"";
    }
    else if(![[LTypeRidHL100 objectAtIndex:indexPath.row] isEqualToString:@"(null)"] && ![[LTypeRidHL100 objectAtIndex:indexPath.row] isEqualToString:@""] ){
        hl1k = [formatter stringFromNumber:[NSNumber numberWithDouble:[[LTypeRidHL100 objectAtIndex:indexPath.row] doubleValue]]];
    }
    else if (![[LTypeRidHL1K objectAtIndex:indexPath.row] isEqualToString:@"(null)"] && [[LTypeRidHL1K objectAtIndex:indexPath.row] integerValue] > 0) {
        hl1k = [formatter stringFromNumber:[NSNumber numberWithDouble:[[LTypeRidHL1K objectAtIndex:indexPath.row] doubleValue]]];
    }
    else {
        hl1k = @"";
    }
    label7.text= hl1k;
    label7.textAlignment = UITextAlignmentCenter;
    label7.tag = 2007;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label7];
    
    CGRect frame8=CGRectMake(496,0, 63, 50);
    UILabel *label8=[[UILabel alloc]init];
    label8.frame=frame8;
    NSString *hl100;
    if ([[LTypeRidHLTerm objectAtIndex:indexPath.row] isEqualToString:@"0"] &&
        [[LTypeRidHL100Term objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        hl100 = @"";
    }
    else if([[LTypeRidHLTerm objectAtIndex:indexPath.row] isEqualToString:@"0"] &&
            ![[LTypeRidHL100Term objectAtIndex:indexPath.row] isEqualToString:@"0"]){
        hl100 = [LTypeRidHL100Term objectAtIndex:indexPath.row];
    }
    else {
        hl100 = [LTypeRidHLTerm objectAtIndex:indexPath.row];
    }
    label8.text= hl100;
    label8.textAlignment = UITextAlignmentCenter;
    label8.tag = 2008;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label8];
     
    CGRect frame9=CGRectMake(559,0, 63, 50);
    UILabel *label9=[[UILabel alloc]init];
    label9.frame=frame9;
    NSString *hlp;
    if ([[LTypeRidHLP objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
        hlp = @"";
    } else {
        hlp = [LTypeRidHLP objectAtIndex:indexPath.row];
    }
    label9.text=hlp;
    label9.textAlignment = UITextAlignmentCenter;
    label9.tag = 2009;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label9];
    
    CGRect frame10=CGRectMake(622,0, 64, 50);
    UILabel *label10=[[UILabel alloc]init];
    label10.frame=frame10;
    NSString *hlpTerm;
    if ([[LTypeRidHLPTerm objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        hlpTerm = @"";
    } else {
        hlpTerm = [LTypeRidHLPTerm objectAtIndex:indexPath.row];
    }
    label10.text=hlpTerm;
    label10.textAlignment = UITextAlignmentCenter;
    label10.tag = 2010;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label10];
    
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
        label10.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label7.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label8.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label9.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label10.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
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
        label10.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label7.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label8.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label9.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label10.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
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
//            [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            deleteBtn.enabled = TRUE;
        }
    }
    else {
        //[btnAddRider setTitle:[LRiderCode objectAtIndex:indexPath.row] forState:UIControlStateNormal ];
        
        RiderListTbViewController *zzz = [[RiderListTbViewController alloc] init ];
        [self RiderListController:zzz didSelectCode:[LTypeRiderCode objectAtIndex:indexPath.row] desc:[self getRiderDesc:[LTypeRiderCode objectAtIndex:indexPath.row]]];
        
        NSRange rangeofDot = [[LTypeSumAssured objectAtIndex:indexPath.row ] rangeOfString:@"."];
        NSString *SumToDisplay = @"";
        if (rangeofDot.location != NSNotFound) {
            NSString *substring = [[LTypeSumAssured objectAtIndex:indexPath.row] substringFromIndex:rangeofDot.location ];
            if (substring.length == 2 && [substring isEqualToString:@".0"]) {
                SumToDisplay = [[LTypeSumAssured objectAtIndex:indexPath.row] substringToIndex:rangeofDot.location ];
            }
            else {
                SumToDisplay = [LTypeSumAssured objectAtIndex:indexPath.row];
            }
        }
        else {
            SumToDisplay = [LTypeSumAssured objectAtIndex:indexPath.row];
        }
        
        sumField.text = SumToDisplay;
        termField.text = [LTypeTerm objectAtIndex:indexPath.row];
        unitField.text = [LTypeUnits objectAtIndex:indexPath.row];
        
        if (  ![[LTypePlanOpt objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
            [planBtn setTitle:[LTypePlanOpt objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        }
        
        if (  ![[LTypeDeduct objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
            [deducBtn setTitle:[LTypeDeduct objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        }
        
        NSRange rangeofDotHL = [[LTypeRidHL1K objectAtIndex:indexPath.row ] rangeOfString:@"."];
        NSString *HLToDisplay = @"";
        if (rangeofDotHL.location != NSNotFound) {
            NSString *substringHL = [[LTypeRidHL1K objectAtIndex:indexPath.row] substringFromIndex:rangeofDotHL.location ];
            if (substringHL.length == 2 && [substringHL isEqualToString:@".0"]) {
                HLToDisplay = [[LTypeRidHL1K objectAtIndex:indexPath.row] substringToIndex:rangeofDotHL.location ];
            }
            else {
                HLToDisplay = [LTypeRidHL1K objectAtIndex:indexPath.row];
            }
        }
        else {
            HLToDisplay = [LTypeRidHL1K objectAtIndex:indexPath.row];
        }
        
        if (![[LTypeRidHL1K objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
            HLField.text = HLToDisplay;
        }
    
        if (  ![[LTypeRidHLTerm objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            HLTField.text = [LTypeRidHLTerm objectAtIndex:indexPath.row];
        }
        
        NSRange rangeofDotHL100 = [[LTypeRidHL100 objectAtIndex:indexPath.row ] rangeOfString:@"."];
        NSString *HL100ToDisplay = @"";
        if (rangeofDotHL100.location != NSNotFound) {
            NSString *substringHL100 = [[LTypeRidHL100 objectAtIndex:indexPath.row] substringFromIndex:rangeofDotHL100.location ];
            if (substringHL100.length == 2 && [substringHL100 isEqualToString:@".0"]) {
                HL100ToDisplay = [[LTypeRidHL100 objectAtIndex:indexPath.row] substringToIndex:rangeofDotHL100.location ];
            }
            else {
                HL100ToDisplay = [LTypeRidHL100 objectAtIndex:indexPath.row];
            }
        }
        else {
            HL100ToDisplay = [LTypeRidHL100 objectAtIndex:indexPath.row];
        }
        
        if (![[LTypeRidHL100 objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
            HLField.text = HL100ToDisplay;
        }
        
        if (  ![[LTypeRidHL100Term objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            HLTField.text = [LTypeRidHL100Term objectAtIndex:indexPath.row];
        }
        
        if (  ![[LTypeRidHLP objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
            HLField.text = [LTypeRidHLP objectAtIndex:indexPath.row];
        }
        
        if (  ![[LTypeRidHLPTerm objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            HLTField.text = [LTypeRidHLPTerm objectAtIndex:indexPath.row];
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
//            [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    [self setLOccpCode:nil];
    [self setDataInsert:nil];
    [self setMedRiderCode:nil];
    [self setInputHL1KSA:nil];
    [self setInputHL100SA:nil];
    [self setInputHLPercentage:nil];
    [self setPlanOption:nil];
    [self setDeductible:nil];
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
    [self setTitleHLPTerm:nil];
    [self setPTypeOccp:nil];
    [self setClassField:nil];
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
    inputSA = 0;
    secondLARidCode = nil;
    cpaField.text = @"";
    occpField.text = @"";
    
    [self.planBtn setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    [self.deducBtn setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
}

@end
