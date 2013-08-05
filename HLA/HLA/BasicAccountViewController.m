//
//  BasicAccountViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 6/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "BasicAccountViewController.h"
#import "EverLAViewController.h"
#import "MainScreen.h"
#import "AppDelegate.h"

@interface BasicAccountViewController ()

@end

const double Anually = 1.00, Semi = 0.50, quarterly = 0.25, Monthly = 0.083333;
const double PolicyFee = 5, IncreasePrem =0, CYFactor = 1, ExcessAllo = 0.95, RegularAllo =0.95;
int YearDiff2023, YearDiff2025, YearDiff2028, YearDiff2030, YearDiff2035, CommMonth;
int MonthDiff2023, MonthDiff2025, MonthDiff2028, MonthDiff2030, MonthDiff2035;
int FundTermPrev2023, FundTerm2023, FundTermPrev2025, FundTerm2025,FundTermPrev2028, FundTerm2028;
int FundTermPrev2030, FundTerm2030, FundTermPrev2035, FundTerm2035;
int VU2023Factor,VU2025Factor,VU2028Factor,VU2030Factor,VU2035Factor,VUCashFactor,VURetFactor,VURetOptFactor,VUCashOptFactor;
int RegWithdrawalStartYear, RegWithdrawalEndYear, RegWithdrawalIntYear;
double VU2023Fac,VU2025Fac,VU2028Fac,VU2030Fac,VU2035Fac,VUCashFac,VURetFac,VURetOptFac,VUCashOptFac;
double VUCash_FundAllo_Percen,VURet_FundAllo_Percen,VU2023_FundAllo_Percen,VU2025_FundAllo_Percen;
double VU2028_FundAllo_Percen,VU2030_FundAllo_Percen, VU2035_FundAllo_Percen, RegWithdrawalAmount;
double VU2023InstHigh, VU2023InstMedian, VU2023InstLow,VU2025InstHigh, VU2025InstMedian, VU2025InstLow;
double VU2028InstHigh, VU2028InstMedian, VU2028InstLow,VU2030InstHigh, VU2030InstMedian, VU2030InstLow;
double VU2035InstHigh, VU2035InstMedian, VU2035InstLow, NegativeValueOfMaxCashFundHigh,NegativeValueOfMaxCashFundMedian,NegativeValueOfMaxCashFundLow ;
double HSurrenderValue,MSurrenderValue,LSurrenderValue,HRiderSurrenderValue,MRiderSurrenderValue,LRiderSurrenderValue;
double TotalRiderPremium, PremReq;
double VUCashValueHigh, VU2023ValueHigh,VU2025ValueHigh,VU2028ValueHigh,VU2030ValueHigh;
double VU2035ValueHigh,VURetValueHigh;
double VU2023PrevValuehigh, VU2025PrevValuehigh,VU2028PrevValuehigh, VU2030PrevValuehigh, VU2035PrevValuehigh,VUCashPrevValueHigh;
double VURetPrevValueHigh;
double MonthVU2023PrevValuehigh, MonthVU2025PrevValuehigh,MonthVU2028PrevValuehigh, MonthVU2030PrevValuehigh, MonthVU2035PrevValuehigh,MonthVUCashPrevValueHigh;
double MonthVURetPrevValueHigh;
double VUCashValueMedian, VU2023ValueMedian,VU2025ValueMedian,VU2028ValueMedian,VU2030ValueMedian,VU2035ValueMedian,VURetValueMedian;
double VU2023PrevValueMedian, VU2025PrevValueMedian,VU2028PrevValueMedian, VU2030PrevValueMedian, VU2035PrevValueMedian,VUCashPrevValueMedian;
double VURetPrevValueMedian;
double MonthVU2023PrevValueMedian, MonthVU2025PrevValueMedian,MonthVU2028PrevValueMedian, MonthVU2030PrevValueMedian;
double  MonthVU2035PrevValueMedian,MonthVUCashPrevValueMedian,MonthVURetPrevValueMedian;
double Allo2023, Allo2025,Allo2028,Allo2030,Allo2035;
double Fund2023PartialReinvest, Fund2025PartialReinvest,Fund2028PartialReinvest,Fund2030PartialReinvest,Fund2035PartialReinvest;
double MonthFundMaturityValue2023_Bull, MonthFundMaturityValue2023_Flat,MonthFundMaturityValue2023_Bear;
double MonthFundMaturityValue2025_Bull, MonthFundMaturityValue2025_Flat,MonthFundMaturityValue2025_Bear;
double MonthFundMaturityValue2028_Bull, MonthFundMaturityValue2028_Flat,MonthFundMaturityValue2028_Bear;
double MonthFundMaturityValue2030_Bull, MonthFundMaturityValue2030_Flat,MonthFundMaturityValue2030_Bear;
double MonthFundMaturityValue2035_Bull, MonthFundMaturityValue2035_Flat,MonthFundMaturityValue2035_Bear;
BOOL TPExcess;
NSString *OriginalBump;

@implementation BasicAccountViewController
@synthesize outletBasic, txtBasicPremium, txtBasicSA,txtBUMP,txtCommFrom,txtFor;
@synthesize txtGrayRTUP,txtPolicyTerm,txtPremiumPayable,txtRTUP,txtTotalBAPremium;
@synthesize myScrollView, Label1, label2, labelComm, labelFor, segPremium;
@synthesize requestAge,requestAge2ndLA,requestAgePay,requestDOB2ndLA,requestDOBPay,requestIDPay,requestIDProf;
@synthesize requestIndex2ndLA,requestIndexPay,requestOccp2ndLA,requestOccpClass,requestOccpCode;
@synthesize requestOccpPay,requestSex2ndLA,requestSexPay,requestSINo,requestSmoker2ndLA,requestSmokerPay;
@synthesize ageClient,idPay,idProf,SINo,OccpClass, OccpCode, PayorAge, PayorDOB, PayorIndexNo;
@synthesize PayorOccpCode, PayorSex, PayorSmoker,secondLAAge,secondLADOB,secondLAIndexNo,secondLAOccpCode;
@synthesize secondLASex,secondLASmoker, minSA, minPremium, getPolicyTerm, getSINo, getSumAssured;
@synthesize GenderPP, SIDate, SILastNo, CustDate, CustLastNo, LACustCode, PYCustCode, planChoose, OccpCodePP, NamePP;
@synthesize DOBPP, IndexNo, termCover, secondLACustCode, getHL, getHLPct,getHLPctTerm,getHLTerm;
@synthesize getBumpMode, getBasicPrem, getPlanCode, getCommFrom, getFor,getRTUP, requestSexLA, getSexLA;
@synthesize requestSmokerLA, getSmokerLA, requestPlanCommDate, getPlanCommDate, requestDOB, getDOB;
@synthesize requestOccLoading,getOccLoading;
@synthesize delegate = _delegate;



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
	// Do any additional setup after loading the view.
	
	self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
	UL_databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"UL_Rates.sqlite"]];
    
	self.planList = [[PlanList alloc] init];
    _planList.delegate = self;
	self.planList.TradOrEver = @"EVER";
	self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_planList];
	
	UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
	NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
														   forKey:UITextAttributeFont];
	[segPremium setTitleTextAttributes:attributes
							   forState:UIControlStateNormal];
	
	//request LA, second LA and Payor details
	getSexLA = [self.requestSexLA description];
	ageClient = requestAge;
	OccpCode = [self.requestOccpCode description];
    OccpClass = requestOccpClass;
    idPay = requestIDPay;
    idProf = requestIDProf;
	getPlanCommDate = [self.requestPlanCommDate description];
	getSmokerLA = [self.requestSmokerLA description];
	getDOB = [self.requestDOB description];
	getOccLoading = [self.requestOccLoading description];
	
    PayorIndexNo = requestIndexPay;
    PayorSmoker = [self.requestSmokerPay description];
    PayorSex = [self.requestSexPay description];
    PayorDOB = [self.requestDOBPay description];
    PayorAge = requestAgePay;
    PayorOccpCode = [self.requestOccpPay description];
	
    secondLAIndexNo = requestIndex2ndLA;
    secondLASmoker = [self.requestSmoker2ndLA description];
    secondLASex = [self.requestSex2ndLA description];
    secondLADOB = [self.requestDOB2ndLA description];
    secondLAAge = requestAge2ndLA;
    secondLAOccpCode = [self.requestOccp2ndLA description];
	
    SINo = [self.requestSINo description];
	temp = outletBasic.titleLabel.text;
	
	[self togglePlan];
	if (self.requestSINo) {
		[self checkingExisting];
		if (getSINo.length != 0) {
			NSLog(@"view selected field");
			[self getExistingBasic];
			
			if ([getPlanCode isEqualToString:@"UV"]) {
                [self.outletBasic setTitle:@"HLA EverLife" forState:UIControlStateNormal];
                temp = outletBasic.titleLabel.text;
            }
			
			[self togglePlan];
			[self CalcTotalRiderPrem];
			[self toggleExistingField];
			
		}else {
			NSLog(@"create new");
        }
		
	} else {
        NSLog(@"SINo not exist!");
		//default plan
		[outletBasic setTitle:@"HLA EverLife" forState:UIControlStateNormal];
		txtPolicyTerm.text =  [NSString stringWithFormat:@"%d", (100 - requestAge)];
		getPlanCode = @"UV";
		// ---
    }

	if (PayorIndexNo != 0) {
        NSLog(@"exist payor! Age:%d",PayorAge);
        IndexNo = PayorIndexNo;
        [self getProspectData];
    }
	
	
	if (secondLAIndexNo != 0) {
        NSLog(@"exist secondLA!");
        IndexNo = secondLAIndexNo;
        [self getProspectData];
        NSLog(@"2ndLAAge:%d",secondLAAge);
    }
	

	[txtBasicPremium addTarget:self action:@selector(BasicPremiumDidChanged) forControlEvents:UIControlEventAllEditingEvents];
	labelComm.hidden = YES;
	labelFor.hidden = YES;
	Label1.hidden = YES;
	label2.hidden = YES;
	txtBasicPremium.tag = 0;
	txtBasicPremium.delegate = self;
	txtBasicSA.delegate = self;
	txtBasicSA.tag = 1;
	txtCommFrom.tag = 2;
	txtFor.tag = 4;
	txtCommFrom.delegate = self;
	txtFor.delegate = self;
	txtRTUP.tag = 3;
	txtRTUP.delegate = self;
	txtBUMP.tag = 5;
	txtBUMP.delegate = self;
	myScrollView.delegate = self;
	_planList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    /*
	 self.headerTitle.frame = CGRectMake(310, -20, 149, 44);
	 self.myToolBar.frame = CGRectMake(0, 0, 768, 44);
	 self.view.frame = CGRectMake(0, 20, 768, 1004); */
    
    self.view.frame = CGRectMake(0, 0, 788, 1004);
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
	
	txtBUMP.text = [NSString stringWithFormat:@"%.2f", [self CalculateBUMP]];
	txtBUMP.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[txtBUMP.text doubleValue]]];
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

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 44, 768, 960-264);
    self.myScrollView.contentSize = CGSizeMake(768, 960);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 10;
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
	
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification{
	Label1.hidden = TRUE;
	label2.hidden = TRUE;
	self.myScrollView.frame = CGRectMake(0, 44, 768, 960);
}

#pragma mark - delegate

-(void)Planlisting:(PlanList *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc{
	[outletBasic setTitle:aaDesc forState:UIControlStateNormal ];
	[self.planPopover dismissPopoverAnimated:YES];
	txtPolicyTerm.text =  [NSString stringWithFormat:@"%d", (100 - requestAge)];
	getPlanCode = aaCode;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	
	switch (textField.tag) {
        case 0: //basic premium
			[self DisplayPremiumCondtion];
			break;
			
        case 1:
			
			[self DisplayBasicSACondtion];
            break;
			
		case 2: //txtCommFrom
			labelComm.hidden = NO;
			labelFor.hidden = NO;
			labelComm.text = [NSString stringWithFormat:@"Min: %d Max: %d", 1, 100- ageClient - 1];
			labelFor.text = [NSString stringWithFormat:@"Min: %d Max: %d", 1, 100- ageClient];
            break;
		case 3: //RTUP
			Label1.hidden = TRUE;
			label2.hidden = TRUE;
		case 4:
			labelFor.text = [NSString stringWithFormat:@"Min: %d Max: %d", 1,
							 [txtPolicyTerm.text intValue ] - [txtCommFrom.text intValue] ];
            break;
        default:
            
            break;
    }
	activeField = textField;
    return YES;
}

-(void)DisplayPremiumCondtion{
	
	Label1.hidden = FALSE;
	label2.hidden = FALSE;
	
	if (segPremium.selectedSegmentIndex == 0) {
		minPremium = 780 * Anually;
		Label1.text =  [NSString stringWithFormat:@"Min: %.0f", minPremium];
		label2.text =  [NSString stringWithFormat:@"Max: Subject to underwriting"];
	}
	else if (segPremium.selectedSegmentIndex == 1){
		minPremium= 780 * Semi;
		Label1.text =  [NSString stringWithFormat:@"Min: %.0f",  minPremium];
		label2.text=  [NSString stringWithFormat:@"Max: Subject to underwriting"];
	}
	
	else if (segPremium.selectedSegmentIndex == 2){
		minPremium = 780 * quarterly;
		Label1.text =  [NSString stringWithFormat:@"Min: %.0f",  minPremium];
		label2.text =  [NSString stringWithFormat:@"Max: Subject to underwriting"];
	}
	else if (segPremium.selectedSegmentIndex == 3){
		minPremium = 780 * Monthly;
		Label1.text =  [NSString stringWithFormat:@"Min: %.0f",  minPremium];
		label2.text =  [NSString stringWithFormat:@"Max: Subject to underwriting"];
	}
	
}

-(void)DisplayBasicSACondtion{
	Label1.hidden = FALSE;
	label2.hidden = FALSE;
	double SAFac = 0;
	
	if (requestAge < 17) {
		SAFac = 60;
	}
	else if (requestAge > 16 && requestAge < 26){ //17 - 25
		SAFac = 55;
	}
	else if (requestAge > 25 && requestAge < 36){ //26 - 35
		SAFac = 50;
	}
	else if (requestAge > 35 && requestAge < 46){ // 36 - 45
		SAFac = 35;
	}
	else if (requestAge > 45 && requestAge < 56){ //46 - 55
		SAFac = 25;
	}
	else if (requestAge > 55){
		SAFac = 15;
	}
	
	if (segPremium.selectedSegmentIndex == 1) {
		minSA = SAFac * [txtBasicPremium.text doubleValue ] / Semi;
	}
	else if (segPremium.selectedSegmentIndex == 2){
		minSA = SAFac * [txtBasicPremium.text doubleValue ] / quarterly;
	}
	else if (segPremium.selectedSegmentIndex == 3){
		minSA = SAFac * [txtBasicPremium.text doubleValue ] / Monthly;
	}
	else{
		minSA = SAFac * [txtBasicPremium.text doubleValue ];
	}
	
	//minSA = SAFac * [txtBasicPremium.text doubleValue ];
	
	Label1.text = [ NSString stringWithFormat:@"Min: %.0f", minSA];
	label2.text = @"Max: Subject to underwriting";
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
	[formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
	
	
	if (textField.tag == 0 || textField.tag == 1 ) {
		if (![txtBasicPremium.text isEqualToString:@""] && ![txtBasicSA.text isEqualToString:@""] &&
			![txtBasicPremium.text isEqualToString:@"0"] && ![txtBasicSA.text isEqualToString:@"0"]) {
			txtBUMP.text = [NSString stringWithFormat:@"%.2f", [self CalculateBUMP]];
			txtBUMP.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[txtBUMP.text doubleValue]]];
		}

	}
	else if (textField.tag == 2 || textField.tag == 4 || textField.tag == 3 ){
		if (![txtRTUP.text isEqualToString:@""] && ![txtCommFrom.text isEqualToString:@""] && ![txtFor.text isEqualToString:@""] &&
			![txtRTUP.text isEqualToString:@"0"] && ![txtCommFrom.text isEqualToString:@"0"] && ![txtFor.text isEqualToString:@"0"]) {
				txtBUMP.text = [NSString stringWithFormat:@"%.2f", [self CalculateBUMP]];
			txtBUMP.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[txtBUMP.text doubleValue]]];
		}
	}

	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	
	if ([string length ] == 0) {
		return  YES;
	}
	
	if (textField.tag == 0 || textField.tag == 3) {
		
		NSRange rangeofDot = [textField.text rangeOfString:@"."];
		if (rangeofDot.location != NSNotFound ) {
			NSString *substring = [textField.text substringFromIndex:rangeofDot.location ];
			
			if ([string isEqualToString:@"."]) {
				return NO;
			}
			
			if (substring.length > 2 )
			{
				return NO;
			}
		}
		
		NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
		if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
			return NO;
		}
	}
	else{
		NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
		if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
			return NO;
		}
	}
    
	return  YES;
}

-(void)BasicPremiumDidChanged{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
	
	txtTotalBAPremium.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[txtBasicPremium.text doubleValue]]];

	//txtPremiumPayable.text = txtBasicPremium.text;
	//
	txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", [txtBasicPremium.text doubleValue ] + TotalRiderPremium];
	txtPremiumPayable.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[txtPremiumPayable.text doubleValue]]];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 1001 && buttonIndex == 0) {
        
	    EverLAViewController *EverLAPage  = [self.storyboard instantiateViewControllerWithIdentifier:@"EverLA"];
        MainScreen *MainScreenPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        MainScreenPage.IndexTab = 3;
		EverLAPage.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:MainScreenPage animated:YES completion:^(){
            [MainScreenPage presentModalViewController:EverLAPage animated:NO];
			EverLAPage.view.superview.bounds =  CGRectMake(-300, 0, 1024, 748);
        }];
    }
	else if (alertView.tag==1002 && buttonIndex == 0) {
        [self checkingSave];
    }
    else if (alertView.tag==1003 && buttonIndex == 0) {
        [self checkingSave];
    }
    else if (alertView.tag==1004 && buttonIndex == 0) {
		[self DisplayBasicSACondtion];
    }
	else if (alertView.tag==1007 && buttonIndex == 0) {
		[self Validation];
    }
	
}


#pragma mark - handle data

-(void)togglePlan
{
    NSLog(@"tooglePlan");
    [self getTermRule];
	
}

-(void)toggleExistingField{
	
	txtPolicyTerm.text = [NSString stringWithFormat:@"%d", 100 - requestAge];
	txtBasicSA.text = [NSString stringWithFormat:@"%.f", getSumAssured ];
	txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", getBasicPrem ];

	if ([getBumpMode isEqualToString:@"A"]) {
		segPremium.selectedSegmentIndex = 0;
	}
	else if([getBumpMode isEqualToString:@"S"]) {
		segPremium.selectedSegmentIndex = 1;
	}
	else if([getBumpMode isEqualToString:@"Q"]) {
		segPremium.selectedSegmentIndex = 2;
	}
	else{
		segPremium.selectedSegmentIndex = 3;
	}
	
	if (TPExcess == TRUE) {
		txtRTUP.text = [NSString stringWithFormat:@"%.2f", [getRTUP doubleValue ]];
		txtCommFrom.text = [NSString stringWithFormat:@"%d", [getCommFrom intValue ] - 1];
		txtFor.text = [NSString stringWithFormat:@"%d", [getFor intValue ] + 1];
	}
	else{
		txtRTUP.text = @"";
		txtCommFrom.text = @"";
		txtFor.text = @"";
	}

	txtTotalBAPremium.text = txtBasicPremium.text;
	//txtPremiumPayable.text = txtBasicPremium.text;
	txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", [txtBasicPremium.text doubleValue ] + TotalRiderPremium];
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
	
	txtTotalBAPremium.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[txtTotalBAPremium.text doubleValue]]];
	txtPremiumPayable.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[txtPremiumPayable.text doubleValue]]];
	
	[_delegate BasicSI:getSINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover
			andBasicSA:txtBasicSA.text andBasicHL:getHL andBasicHLTerm:getHLTerm
		 andBasicHLPct:getHLPct andBasicHLPctTerm:getHLPctTerm andPlanCode:getPlanCode andBumpMode:getBumpMode];
	
}

-(void) getTermRule
{
    termCover = 100 - ageClient;
}

-(void)getProspectData
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName, ProspectDOB, ProspectGender, ProspectOccupationCode FROM "
							  "prospect_profile WHERE IndexNo= \"%d\"",IndexNo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NamePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                DOBPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                GenderPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                OccpCodePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
            } else {
                NSLog(@"error access prospect_profile");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


-(void)getExistingBasic
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT SINo, CovPeriod, BasicSA, "
							  "ATPrem, BUMPMode, HLoading, HLoadingTerm, HLoadingPct, HLoadingPctTerm, planCode FROM UL_Details"
							  " WHERE SINo=\"%@\"",SINo];

        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                getSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                getPolicyTerm = sqlite3_column_int(statement, 1);
                getSumAssured = sqlite3_column_double(statement, 2);
				getBasicPrem = sqlite3_column_double(statement, 3);
				getBumpMode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                const char *getHL2 = (const char*)sqlite3_column_text(statement, 5);
                getHL = getHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getHL2];
                getHLTerm = sqlite3_column_int(statement, 6);	
                const char *getTempHL2 = (const char*)sqlite3_column_text(statement, 7);
                getHLPct = getTempHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getTempHL2];
                getHLPctTerm = sqlite3_column_int(statement, 8);
				getPlanCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
				//                NSLog(@"basicPlan:%@",planChoose);
                OriginalBump = getBumpMode;
            } else {
                NSLog(@"error access getExistingBasic");
            }
            sqlite3_finalize(statement);
        }
		
		
		querySQL = [NSString stringWithFormat:@"SELECT FromYear, YearInt, Amount, ForYear FROM UL_TPExcess WHERE SINo=\"%@\"",SINo];
		
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
				TPExcess = TRUE;
                getCommFrom = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] ;
                getRTUP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] ;
				getFor = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)] ;
                
            } else {
				TPExcess = FALSE;
                getCommFrom = @"";
				getRTUP = @"";
				getFor = @"";
            }
            sqlite3_finalize(statement);
        }
		
		querySQL = [NSString stringWithFormat:@"SELECT fund, option, partial_withd_pct  FROM UL_fund_maturity_option WHERE SINo=\"%@\"",SINo];
		
		Fund2023PartialReinvest = 100.00; //means fully withdraw
		Fund2025PartialReinvest = 100.00;
		Fund2028PartialReinvest = 100.00;
		Fund2030PartialReinvest = 100.00;
		Fund2035PartialReinvest = 100.00;
		
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
				if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"HLA EverGreen 2023"]) {
					if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"ReInvest"]) {
						Fund2023PartialReinvest = 0;
					}
					else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"Partial"]) {
						Fund2023PartialReinvest = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] doubleValue ] ;
					}
					else{
						Fund2023PartialReinvest = 100;
					}
				}
				else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"HLA EverGreen 2025"]) {
					if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"ReInvest"]) {
						Fund2025PartialReinvest = 0;
					}
					else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"Partial"]) {
						Fund2025PartialReinvest = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] doubleValue ] ;
					}
					else{
						Fund2025PartialReinvest = 100;
					}
				}
				else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"HLA EverGreen 2028"]) {
					if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"ReInvest"]) {
						Fund2028PartialReinvest = 0;
					}
					else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"Partial"]) {
						Fund2028PartialReinvest = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] doubleValue ] ;
					}
					else{
						Fund2028PartialReinvest = 100;
					}
				}
				else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"HLA EverGreen 2030"]) {
					if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"ReInvest"]) {
						Fund2030PartialReinvest = 0;
					}
					else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"Partial"]) {
						Fund2030PartialReinvest = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] doubleValue ] ;
					}
					else{
						Fund2030PartialReinvest = 100;
					}
				}
				else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"HLA EverGreen 2035"]) {
					if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"ReInvest"]) {
						Fund2035PartialReinvest = 0;
					}
					else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"Partial"]) {
						Fund2035PartialReinvest = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] doubleValue ] ;
					}
					else{
						Fund2035PartialReinvest = 100;
					}
				}
				
            }
            sqlite3_finalize(statement);
        }

		
        sqlite3_close(contactDB);
    }
}


-(void)checkingSave
{
    if (useExist) {
        NSLog(@"will update");
        [self updateBasicPlan];
		if (![[txtRTUP.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
			//update UL_TPExcess
			if (TPExcess == TRUE) {
				[self UpdateTPExcess];
			}
			else{
				[self InsertIntoTPExcess];
			}
		}
		else{
			//delete
			if (TPExcess == TRUE) {
				[self DeleteTPExcess];
			}
		}
		
    } else {
        NSLog(@"will save");
        [self saveBasicPlan];
    }
}

-(void)updateBasicPlan
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE UL_Details SET CovPeriod = '%@', CovPeriod=\"%@\", BasicSA=\"%@\", "
							  "AtPrem = \"%@\", BumpMode = \"%@\", DateModified=%@ "
							  " WHERE SINo=\"%@\"", txtPolicyTerm.text, txtPolicyTerm.text, txtBasicSA.text, txtBasicPremium.text,
							  [self ReturnBumpMode], @"datetime(\"now\", \"+8 hour\")", SINo];
        
        //NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"BasicPlan update!");
                //[self getPlanCodePenta];
                
				[_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:txtBasicSA.text
					andBasicHL:getHL andBasicHLTerm:getHLTerm andBasicHLPct:getHLPct andBasicHLPctTerm:getHLPctTerm
					   andPlanCode:getPlanCode andBumpMode:[self ReturnBumpMode]];
					
            }
            else {
                NSLog(@"BasicPlan update Failed!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
		
		
		NSString *SQLaddin;
		if ([OriginalBump  isEqualToString:@"A"]) {
			if ([[self ReturnBumpMode] isEqualToString:@"S"]) {
				SQLaddin = [NSString stringWithFormat: @"premium = premium * %f", Semi];
			}
			else if ([[self ReturnBumpMode] isEqualToString:@"Q"]) {
				SQLaddin = [NSString stringWithFormat: @"premium = premium * %f", quarterly];
			}
			else if ([[self ReturnBumpMode] isEqualToString:@"M"]) {
				SQLaddin = [NSString stringWithFormat: @"premium =  premium * %f", Monthly];
			}
			else{
				sqlite3_close(contactDB);
				return;
			}
		}
		else if ([OriginalBump  isEqualToString:@"S"]) {
			if ([[self ReturnBumpMode] isEqualToString:@"A"]) {
				SQLaddin = [NSString stringWithFormat: @"premium = premium / %f", Semi];
			}
			else if ([[self ReturnBumpMode] isEqualToString:@"Q"]) {
				SQLaddin = [NSString stringWithFormat: @"premium = premium / %f * %f", Semi, quarterly];
			}
			else if ([[self ReturnBumpMode] isEqualToString:@"M"]) {
				SQLaddin = [NSString stringWithFormat: @"premium = premium / %f * %f", Semi, Monthly];
			}
			else{
				sqlite3_close(contactDB);
				return;
			}
			
		}
		else if ([OriginalBump  isEqualToString:@"Q"]) {
			if ([[self ReturnBumpMode] isEqualToString:@"A"]) {
				SQLaddin = [NSString stringWithFormat: @"premium = premium / %f", quarterly];
			}
			else if ([[self ReturnBumpMode] isEqualToString:@"S"]) {
				SQLaddin = [NSString stringWithFormat: @"premium = premium / %f * %f", quarterly, Semi];
			}
			else if ([[self ReturnBumpMode] isEqualToString:@"M"]) {
				SQLaddin = [NSString stringWithFormat: @"premium = premium / %f * %f", quarterly, Monthly];
			}
			else{
				sqlite3_close(contactDB);
				return;
			}
			
		}
		else if ([OriginalBump  isEqualToString:@"M"]) {
			if ([[self ReturnBumpMode] isEqualToString:@"A"]) {
				SQLaddin = [NSString stringWithFormat: @"premium = premium / %f", Monthly];
			}
			else if ([[self ReturnBumpMode] isEqualToString:@"S"]) {
				SQLaddin = [NSString stringWithFormat: @"premium = premium / %f * %f", Monthly, Semi];
			}
			else if ([[self ReturnBumpMode] isEqualToString:@"Q"]) {
				SQLaddin = [NSString stringWithFormat: @"premium = premium / %f * %f", Monthly, quarterly];
			}
			else{
				sqlite3_close(contactDB);
				return;
			}
		}
		
		querySQL = [NSString stringWithFormat:@"UPDATE UL_Rider_Details SET %@ WHERE SINo=\"%@\"", SQLaddin, SINo];
        
        //NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"BasicPlan update!");
                //[self getPlanCodePenta];
                
				[_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:txtBasicSA.text
						andBasicHL:getHL andBasicHLTerm:getHLTerm andBasicHLPct:getHLPct andBasicHLPctTerm:getHLPctTerm
					   andPlanCode:getPlanCode andBumpMode:[self ReturnBumpMode]];
				
            }
            else {
                NSLog(@"BasicPlan update Failed!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    [self validateExistingRider];
	
}

-(void)validateExistingRider{
	
}

-(void)saveBasicPlan
{
    [self getRunningSI];
    [self getRunningCustCode];
	
    //generate SINo || CustCode
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoSI = SILastNo + 1;
    int runningNoCust = CustLastNo + 1;
    
    NSString *fooSI = [NSString stringWithFormat:@"%04d", runningNoSI];
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
    
    SINo = [[NSString alloc] initWithFormat:@"SI%@-%@",currentdate,fooSI];
    LACustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    NSLog(@"SINo:%@, CustCode:%@",SINo,LACustCode);
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
							   @"INSERT INTO UL_Details (SINo,  PlanCode, CovTypeCode, ATPrem, BasicSA, CovPeriod, OccpCode, "
							   "BumpMode, VU2023, VU2025,VU2028,VU2030,VU2035,VURet,VUCash,VURetOpt,VUCashOpt, PolicySustainYear, "
							   "DateCreated, CreatedBy, DateModified, ModifiedBy) VALUES "
							   "(\"%@\", \"UV\", \"IC\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", '0', '0', "
							   "'0','0','40','40','20','0','0','0', "
							   "datetime('now', '+8 hour'), 'HLA', datetime('now', '+8 hour'), 'HLA') ",
							   SINo, txtBasicPremium.text, txtBasicSA.text, termCover, OccpCode, [self ReturnBumpMode]];
		
		
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Saved BasicPlan!");
				if (![[txtRTUP.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
						[self InsertIntoTPExcess]; // for Regular Top up premium
				}
				
                [self updateLA];
                
                if (PayorIndexNo != 0) {
                    [self savePayor];
                }
                
                if (secondLAIndexNo != 0) {
                    [self saveSecondLA];
                }
				
				[_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:txtBasicSA.text
						andBasicHL:getHL andBasicHLTerm:getHLTerm andBasicHLPct:getHLPct andBasicHLPctTerm:getHLPctTerm
						andPlanCode:getPlanCode andBumpMode:[self ReturnBumpMode]];

		
                AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                zzz.SICompleted = YES;
                
            }
            else {
                NSLog(@"Failed Save basicPlan!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
			
        }
		
		
		
        sqlite3_close(contactDB);
    }
	
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO UL_Fund_Maturity_Option (SINO, Fund, Option, Partial_Withd_Pct, "
					 "EverGreen2025, EverGreen2028, EverGreen2030, EverGreen2035, CashFund, RetireFund ) VALUES ('%@', '%@', '%@', '%@', "
					 " '%@', '%@','%@','%@','%@','%@') ", SINo, @"HLA EverGreen 2035", @"ReInvest", @"0", @"0", @"0", @"0",@"0",@"100", @"0"  ];
		//NSLog(@"%@", insertSQL);
		
		if (sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			if (sqlite3_step(statement) == SQLITE_DONE)
			{
				
			}
			sqlite3_finalize(statement);
		}
	}
		
	
}

-(double)CalculateBUMP{
	double FirstBasicMort = [self ReturnBasicMort:ageClient]/1000.00;
	double FirstSA = [txtBasicSA.text doubleValue ];
	double SecondBasicMort = [self ReturnBasicMort:ageClient + 1]/1000.00;
	double SecondSA = 0;
	double ThirdBasicMort = [self ReturnBasicMort:ageClient + 2]/1000.00;
	double BUMP1;
	double BUMP2;
	
	//NSLog(@"%f, %f, %f", FirstBasicMort, SecondBasicMort, ThirdBasicMort);
	
	//[self getExistingBasic]; //disable as it will change getbumpmode
	[self CalcInst:@""];
	[self GetRegWithdrawal];
	[self ReturnFundFactor]; // get factor for each fund
	[self CalcYearDiff]; //get the yearDiff
	[self SurrenderValue:2];
	SecondSA = [txtBasicSA.text doubleValue ] - HSurrenderValue;
			//NSLog(@"dasdas %f", HSurrenderValue);
	if ([getHL isEqualToString:@""]) {
		getHL = @"0";
	}
	
	if ([getHLPct isEqualToString:@""]) {
		getHLPct= @"0";
	}
	
	if ([getOccLoading isEqualToString:@"STD"]) {
		getOccLoading = @"0";
	}

	double MortDate = [self GetMortDate ];
	NSString *strBumpMode = [self ReturnBumpMode];
	double ModeRate = [self ReturnModeRate:strBumpMode];
	double divideMode = [self ReturnDivideMode];
	double PremAllocation = [self ReturnPremAllocation:1];
	double ExcessPrem =  [self ReturnExcessPrem:1];
	
	double FirstBasicSA =  (FirstSA * ((FirstBasicMort * MortDate + SecondBasicMort * (12 - MortDate))/12.00 * (1 + [getHLPct intValue]/100.00 ) +
							([getHL doubleValue] /1000.00) + ([getOccLoading doubleValue ]/1000.00)));

	double SecondBasicSA =  (SecondSA * ((SecondBasicMort * MortDate + ThirdBasicMort * (12 - MortDate))/12.00 * (1 + [getHLPct intValue]/100.00 ) +
									   ([getHL doubleValue] /1000.00) + ([getOccLoading doubleValue ]/1000.00)));
	
	BUMP1 = (ModeRate * (PremAllocation * ([txtBasicPremium.text doubleValue ] * divideMode) +
				(0.95 * (ExcessPrem + [txtGrayRTUP.text doubleValue ]))) -
			 (((PolicyFee * 12) + FirstBasicSA + 0) * 12.5/12.00))/divideMode;
	
	BUMP2 = (ModeRate * ([self ReturnPremAllocation:2] * ([txtBasicPremium.text doubleValue ] * divideMode) +
				(0.95 * ([self ReturnExcessPrem:2] + [txtGrayRTUP.text doubleValue ]))) -
			 (((PolicyFee * 12) + SecondBasicSA + 0) * 12.5/12.00))/divideMode;
	
	
	if (BUMP1 < 0.00) {
		PremReq = ((((0.01 * divideMode) + (((PolicyFee * 12) + FirstBasicSA + 0) * 12.5/12.00))/ModeRate -
					(0.95 * (ExcessPrem + [txtGrayRTUP.text doubleValue ])))/PremAllocation)/divideMode;
	}
	
	NSLog(@"bump1 = %f, bump2 = %f", BUMP1, BUMP2);
	NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
	[format setNumberStyle:NSNumberFormatterDecimalStyle];
	[format setRoundingMode:NSNumberFormatterRoundHalfUp];
	[format setMaximumFractionDigits:2];

	VUCashPrevValueHigh =0;
	VURetPrevValueHigh  =0;
	VU2023PrevValuehigh = 0;
	VU2025PrevValuehigh =0;
	VU2028PrevValuehigh =0;
	VU2030PrevValuehigh = 0;
	VU2035PrevValuehigh = 0;
	
	VUCashPrevValueMedian =0;
	VURetPrevValueMedian  =0;
	VU2023PrevValueMedian = 0;
	VU2025PrevValueMedian =0;
	VU2028PrevValueMedian =0;
	VU2030PrevValueMedian = 0;
	VU2035PrevValueMedian = 0;
	
	MonthVUCashPrevValueHigh =0;
	MonthVURetPrevValueHigh  =0;
	MonthVU2023PrevValuehigh = 0;
	MonthVU2025PrevValuehigh =0;
	MonthVU2028PrevValuehigh =0;
	MonthVU2030PrevValuehigh = 0;
	MonthVU2035PrevValuehigh = 0;
	
	MonthVUCashPrevValueMedian =0;
	MonthVURetPrevValueMedian  =0;
	MonthVU2023PrevValueMedian = 0;
	MonthVU2025PrevValueMedian =0;
	MonthVU2028PrevValueMedian =0;
	MonthVU2030PrevValueMedian = 0;
	MonthVU2035PrevValueMedian = 0;
	
	for (int i =1; i <25 ; i++) {
		
		[self SurrenderValue:i];
		//NSLog(@"%f,%f,%f,%f,%f,%f,%f", VUCashPrevValueHigh,VURetPrevValueHigh,VU2023PrevValuehigh, VU2025PrevValuehigh,VU2028PrevValuehigh, VU2030PrevValuehigh, VU2035PrevValuehigh);

		//NSLog(@"%f", [self ReturnHSurrenderValue:10 andYearOrMonth:@"M" ]);
	}

	if (BUMP1 > BUMP2) {
		return [[NSString stringWithFormat:@"%@", [format stringFromNumber:[NSNumber numberWithFloat:BUMP2]]] doubleValue ];
	}
	else{
		//return [[NSString stringWithFormat:@"%.2f", BUMP1] doubleValue ];
		return [[NSString stringWithFormat:@"%@", [format stringFromNumber:[NSNumber numberWithFloat:BUMP1]]] doubleValue ];
	}
	
	
	
}

#pragma mark - Surrender Value Calculation
-(void)SurrenderValue :(int)aaPolicyYear{
	if (aaPolicyYear == YearDiff2023 || aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2028 || aaPolicyYear == YearDiff2030 ||
		aaPolicyYear == YearDiff2035) {
		//month
		HSurrenderValue = [self ReturnHSurrenderValue:aaPolicyYear andYearOrMonth:@"M" ];
		MSurrenderValue = [self ReturnMSurrenderValue:aaPolicyYear andYearOrMonth:@"M" ];;
		LSurrenderValue = 0;
		HRiderSurrenderValue = 0;
		MRiderSurrenderValue = 0;
		LRiderSurrenderValue = 0;
		
	} else {
		//year
		HSurrenderValue = [self ReturnHSurrenderValue:aaPolicyYear andYearOrMonth:@"Y" ];
		MSurrenderValue = [self ReturnMSurrenderValue:aaPolicyYear andYearOrMonth:@"Y" ];;
		LSurrenderValue = 0;
		HRiderSurrenderValue = 0;
		MRiderSurrenderValue = 0;
		LRiderSurrenderValue = 0;
	}
	
	if (aaPolicyYear == YearDiff2035) {
		HSurrenderValue = HSurrenderValue - MonthFundMaturityValue2035_Bull;
		MSurrenderValue = MSurrenderValue - MonthFundMaturityValue2035_Flat;
	}
	else if (aaPolicyYear == YearDiff2030){
		HSurrenderValue = HSurrenderValue - MonthFundMaturityValue2030_Bull;
		MSurrenderValue = MSurrenderValue - MonthFundMaturityValue2030_Flat;
	}
	else if (aaPolicyYear == YearDiff2028){
		HSurrenderValue = HSurrenderValue - MonthFundMaturityValue2028_Bull;
		MSurrenderValue = MSurrenderValue - MonthFundMaturityValue2028_Flat;
	}
	else if (aaPolicyYear == YearDiff2025){
		HSurrenderValue = HSurrenderValue - MonthFundMaturityValue2025_Bull;
		MSurrenderValue = MSurrenderValue - MonthFundMaturityValue2025_Flat;
	}
	else if (aaPolicyYear == YearDiff2023){
		HSurrenderValue = HSurrenderValue - MonthFundMaturityValue2023_Bull;
		MSurrenderValue = MSurrenderValue - MonthFundMaturityValue2023_Flat;
	}
	else{
		HSurrenderValue = HSurrenderValue - 0;
		MSurrenderValue = MSurrenderValue - 0;
	}
	
	NSLog(@"%f, %f", HSurrenderValue, MSurrenderValue );

}

-(double)ReturnHSurrenderValue :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth {
	//NSLog(@"%f", [self ReturnVUCashValueHigh:aaPolicyYear]);
	
	VUCashValueHigh = [self ReturnVUCashValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VURetValueHigh = [self ReturnVURetValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VU2023ValueHigh = [self ReturnVU2023ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VU2025ValueHigh = [self ReturnVU2025ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VU2028ValueHigh = [self ReturnVU2028ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VU2030ValueHigh = [self ReturnVU2030ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VU2035ValueHigh = [self ReturnVU2035ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	
	
	if (VUCashValueHigh == 1 && VU2023ValueHigh == 0 && VU2025ValueHigh == 0 && VU2028ValueHigh == 0 &&
		VU2030ValueHigh == 0 && VU2035ValueHigh == 0 && VURetValueHigh == 0) {
		return 0;
	} else {
		return VU2023ValueHigh + VU2025ValueHigh + VU2028ValueHigh + VU2030ValueHigh + VU2035ValueHigh +
				VUCashValueHigh + VURetValueHigh;
	}
	
}





-(double)ReturnMSurrenderValue :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth {
	//NSLog(@"%f", [self ReturnVUCashValueHigh:aaPolicyYear]);
	
	VUCashValueMedian = [self ReturnVUCashValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VURetValueMedian = [self ReturnVURetValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VU2023ValueMedian = [self ReturnVU2023ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VU2025ValueMedian = [self ReturnVU2025ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VU2028ValueMedian = [self ReturnVU2028ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VU2030ValueMedian = [self ReturnVU2030ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	VU2035ValueMedian = [self ReturnVU2035ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth];
	
	
	if (VUCashValueMedian == 1 && VU2023ValueMedian == 0 && VU2025ValueMedian == 0 && VU2028ValueMedian == 0 &&
		VU2030ValueMedian == 0 && VU2035ValueMedian == 0 && VURetValueMedian == 0) {
		return 0;
	} else {
		//NSLog(@"%f,%f,%f,%f,%f,%f,%f", VUCashValueMedian,VURetValueMedian,VU2023ValueMedian, VU2025ValueMedian,VU2028ValueMedian, VU2030ValueMedian, VU2035ValueMedian);
		return VU2023ValueMedian + VU2025ValueMedian + VU2028ValueMedian + VU2030ValueMedian + VU2035ValueMedian +
				VUCashValueMedian + VURetValueMedian;
		
	}
	
}

-(void)ReturnFundFactor{
	sqlite3_stmt *statement;
	NSString *querySQL;
	
	querySQL = [NSString stringWithFormat:@"Select VU2023,VU2025,VU2028,VU2030,VU2035,VUCash,VURet,VURetOpt, VUCashOpt From UL_Details "
					" WHERE sino = '%@'", SINo];	
	
	//NSLog(@"%@", querySQL);
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2023Factor = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] intValue];
				VU2025Factor = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] intValue];
				VU2028Factor = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] intValue];
				VU2030Factor = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)] intValue];
				VU2035Factor = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] intValue];
				VUCashFactor = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] intValue];
				VURetFactor = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] intValue];
				VURetOptFactor = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] intValue];
				VUCashOptFactor = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] intValue];
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
}

-(void)GetRegWithdrawal{
	sqlite3_stmt *statement;
	NSString *querySQL;
	
	querySQL = [NSString stringWithFormat:@"Select FromAge, ToAge, YearInt, Amount From UL_RegWithdrawal WHERE sino = '%@'", SINo];
	
	//NSLog(@"%@", querySQL);
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				RegWithdrawalStartYear = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] intValue];
				RegWithdrawalEndYear = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] intValue];
				RegWithdrawalIntYear = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] intValue];
				RegWithdrawalAmount = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)] doubleValue];
			}
			else{
				RegWithdrawalStartYear = 0;
				RegWithdrawalEndYear = 0;
				RegWithdrawalAmount = 0;
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
}



#pragma mark - Calculate Fund Surrender Value for Basic plan
-(double)ReturnVU2023ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	double currentValue;
	if (aaPolicyYear > YearDiff2023) {
		return 0.00;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			//month calculation
			for (int i = 1; i < 13; i++) {
				
				if (i == 1) {
					MonthVU2023PrevValuehigh = VU2023PrevValuehigh;
				}
				
				if (VUCashValueHigh < 0 && [self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0 ) {
					
					currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
					pow((1 + [self ReturnVU2023InstHigh:@"A" ]), (1.00/12.00)) + MonthVU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear] * [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow((1 + [self ReturnVU2023InstHigh:@"A" ]), 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
					([self ReturnMonthFundValueOfTheYearVU2023ValueHigh:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
					
				}
				else{
					currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
					pow(1 + [self ReturnVU2023InstHigh:@"A" ], 1.00/12.00) + MonthVU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2023InstHigh:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				}
				if (i == MonthDiff2023 && aaPolicyYear == YearDiff2023) {
					MonthVU2023PrevValuehigh = 0;
				}
				else{
					MonthVU2023PrevValuehigh = currentValue;
				}
				

			}
			
			VU2023PrevValuehigh = MonthVU2023PrevValuehigh;
			return MonthVU2023PrevValuehigh;
			// below part to be edit later
		}
		else{
			//year calculation
			if (VUCashValueHigh < 0 && [self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0 ) {
				
				currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				(1 + VU2023InstHigh) + VU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				([self ReturnFundValueOfTheYearVU2023ValueHigh:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
				
			}
			else{
				currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				(1 + VU2023InstHigh) + VU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			VU2023PrevValuehigh = currentValue;
			return currentValue;
			// below part to be edit later
		}
		
	}
}

-(double)ReturnVU2023ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	double currentValue;
	if (aaPolicyYear > YearDiff2023) {
		return 0.00;
	}
	else{

		if ([aaYearOrMonth isEqualToString:@"M"]) {
			for (int i = 1; i < 13; i++) {
				
				if (i == 1) {
					MonthVU2023PrevValueMedian = VU2023PrevValueMedian;
				}
				
				if (VUCashValueMedian < 0 && [self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0 ) {
					
					currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
					pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00) + MonthVU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
					([self ReturnMonthFundValueOfTheYearVU2023ValueMedian:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
					
				}
				else{
					currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
					pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00) + MonthVU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				}
				
				if (i == MonthDiff2023 && aaPolicyYear == YearDiff2023) {
					MonthVU2023PrevValueMedian = 0;
				}
				else{
					MonthVU2023PrevValueMedian = currentValue;
				}
				
			}
			
			VU2023PrevValueMedian = MonthVU2023PrevValueMedian;
			return MonthVU2023PrevValueMedian;
			// below part to be edit later
		}
		else{
			if (VUCashValueMedian < 0 && [self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0 ) {
				
				currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				(1 + VU2023InstMedian) + VU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				([self ReturnFundValueOfTheYearVU2023ValueMedian:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
				
			}
			else{
				currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				(1 + VU2023InstMedian) + VU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			VU2023PrevValueMedian = currentValue;
			return currentValue;
			// below part to be edit later
		}
		
	}
}

-(double)ReturnVU2025ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{

	double currentValue;
	if (aaPolicyYear > YearDiff2025) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			for (int i = 1; i < 13; i++) {
				
				if (i == 1) {
					MonthVU2025PrevValuehigh = VU2025PrevValuehigh;
				}
				
				if (VUCashValueHigh < 0 && [self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0 ) {
					currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
					pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00) + MonthVU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
					([self ReturnMonthFundValueOfTheYearVU2025ValueHigh:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
				}
				else{
					currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
					pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00) + MonthVU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				}
				
				if (i == MonthDiff2025 && aaPolicyYear == YearDiff2025) {
					MonthVU2025PrevValuehigh = 0;
				}
				else{
					MonthVU2025PrevValuehigh = currentValue;
				}
				

			}
			
			VU2025PrevValuehigh = MonthVU2025PrevValuehigh;
			return MonthVU2025PrevValuehigh;
		}
		else{
			if (VUCashValueHigh < 0 && [self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0 ) {
				currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				(1 + VU2025InstHigh) + VU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				([self ReturnFundValueOfTheYearVU2025ValueHigh:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
			}
			else{
				currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				(1 + VU2025InstHigh) + VU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			VU2025PrevValuehigh = currentValue;
			return currentValue;
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnVU2025ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2025) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			for (int i = 1; i < 13; i++) {
				
				if (i == 1) {
					MonthVU2025PrevValueMedian = VU2025PrevValueMedian;
				}
				
				if (VUCashValueMedian < 0 && [self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0 ) {
					currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
					pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00) + MonthVU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
					([self ReturnMonthFundValueOfTheYearVU2025ValueMedian:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
				}
				else{
					currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
					pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00) + MonthVU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				}
				
				if (i == MonthDiff2025 && aaPolicyYear == YearDiff2025) {
					MonthVU2025PrevValueMedian = 0;
				}
				else{
					MonthVU2025PrevValueMedian = currentValue;
				}
				

			}
			
			VU2025PrevValueMedian = MonthVU2025PrevValueMedian;
			return MonthVU2025PrevValueMedian;
		}
		else{
			if (VUCashValueMedian < 0 && [self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0 ) {
				currentValue =((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				(1 + VU2025InstMedian) + VU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				([self ReturnFundValueOfTheYearVU2025ValueMedian:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
			}
			else{
				currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				(1 + VU2025InstMedian) + VU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			VU2025PrevValueMedian = currentValue;
			return currentValue;
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnVU2028ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2028) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			for (int i = 1; i < 13; i++) {
				
				if (i == 1) {
					MonthVU2028PrevValuehigh = VU2028PrevValuehigh;
				}
				
				if (VUCashValueHigh < 0 && [self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0) {
					currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
					pow(1 + [self ReturnVU2028InstHigh:@"A" ], 1.00/12.00) + MonthVU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2028InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
					([self ReturnMonthFundValueOfTheYearVU2028ValueHigh:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
				}
				else{
					currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
					pow(1 + [self ReturnVU2028InstHigh:@"A" ], 1.00/12.00)+ MonthVU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2028InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				}
				
				if (i == MonthDiff2028 && aaPolicyYear == YearDiff2028) {
					MonthVU2028PrevValuehigh = 0;
				}
				else{
					MonthVU2028PrevValuehigh = currentValue;
				}
				

			}
			VU2028PrevValuehigh = MonthVU2028PrevValuehigh;
			return MonthVU2028PrevValuehigh;

		}
		else{
			if (VUCashValueHigh < 0 && [self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0) {
				currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
								(1 + VU2028InstHigh) + VU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstHigh:@"A"]) -
								([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
								([self ReturnFundValueOfTheYearVU2028ValueHigh:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
			}
			else{
				currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
								(1 + VU2028InstHigh) + VU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstHigh:@"A"]) -
								([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			VU2028PrevValuehigh = currentValue;
			return currentValue;

		}
		
	}
	
}

-(double)ReturnVU2028ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2028) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			for (int i = 1; i < 13; i++) {
				
				if (i == 1) {
					MonthVU2028PrevValueMedian = VU2028PrevValueMedian;
				}
				
				if (VUCashValueMedian < 0 && [self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0) {
					currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
					pow(1 + [self ReturnVU2028InstMedian:@"A" ], 1.00/12.00) + MonthVU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2028InstMedian:@"A"],1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
					([self ReturnMonthFundValueOfTheYearVU2028ValueMedian:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
				}
				else{
					currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
					pow(1 + [self ReturnVU2028InstMedian:@"A" ], 1.00/12.00)+ MonthVU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2028InstMedian:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				}
				if (i == MonthDiff2028 && aaPolicyYear == YearDiff2028) {
					MonthVU2028PrevValueMedian = 0;
				}
				else{
					MonthVU2028PrevValueMedian = currentValue;
				}
				
			}
			
			VU2028PrevValueMedian = MonthVU2028PrevValueMedian;
			return MonthVU2028PrevValueMedian;
		}
		else{
			if (VUCashValueMedian < 0 && [self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0) {
				currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
				(1 + VU2028InstMedian) + VU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				([self ReturnFundValueOfTheYearVU2028ValueMedian:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
			}
			else{
				currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
				(1 + VU2028InstMedian) + VU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			VU2028PrevValueMedian = currentValue;
			return currentValue;
		}
		
	}
	
}

-(double)ReturnVU2030ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2030) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			for (int i = 1; i < 13; i++) {
				if (i == 1) {
					MonthVU2030PrevValuehigh = VU2030PrevValuehigh;
				}
				
				if (VUCashValueHigh < 0 && [self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0) {
					currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
					pow(1 + [self ReturnVU2030InstHigh:@"A" ], 1.00/12.00) + MonthVU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2030InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
					([self ReturnMonthFundValueOfTheYearVU2030ValueHigh:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
				}
				else{
					currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
					pow(1 + [self ReturnVU2030InstHigh:@"A" ], 1.00/12.00) + MonthVU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2030InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				}
				
				if (i == MonthDiff2030 && aaPolicyYear == YearDiff2030) {
					MonthVU2030PrevValuehigh = 0;
				}
				else{
					MonthVU2030PrevValuehigh = currentValue;
				}
				
			}
			
			VU2030PrevValuehigh = MonthVU2030PrevValuehigh;
			return  MonthVU2030PrevValuehigh;

		}
		else{
			if (VUCashValueHigh < 0 && [self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0) {
				currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
								(1 + VU2030InstHigh) + VU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstHigh:@"A"]) -
								([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
								([self ReturnFundValueOfTheYearVU2030ValueHigh:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
			}
			else{
				currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				(1 + VU2030InstHigh) + VU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			VU2030PrevValuehigh = currentValue;
			return currentValue;

		}
		
	}
	
			// below part to be edit later
}

-(double)ReturnVU2030ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2030) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			for (int i = 1; i < 13; i++) {
				
				if (i == 1) {
					MonthVU2030PrevValueMedian = VU2030PrevValueMedian;
				}
				
				if (VUCashValueMedian < 0 && [self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0) {
					currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
					pow(1 + [self ReturnVU2030InstMedian:@"A" ], 1.00/12.00) + MonthVU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2030InstMedian:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
					([self ReturnMonthFundValueOfTheYearVU2030ValueMedian:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
				}
				else{
					currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]* [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
					pow(1 + [self ReturnVU2030InstMedian:@"A" ], 1.00/12.00) + MonthVU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow(1 + [self ReturnVU2030InstMedian:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				}
				
				if (i == MonthDiff2030 && aaPolicyYear == YearDiff2030) {
					MonthVU2030PrevValueMedian = 0;
				}
				else{
					MonthVU2030PrevValueMedian = currentValue;
				}
				


			}
			
			VU2030PrevValueMedian = MonthVU2030PrevValueMedian;
			return MonthVU2030PrevValueMedian;

		}
		else{
			if (VUCashValueMedian < 0 && [self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0) {
				currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				(1 + VU2030InstMedian) + VU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				([self ReturnFundValueOfTheYearVU2030ValueMedian:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
			}
			else{
				currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				(1 + VU2030InstMedian) + VU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			VU2030PrevValueMedian = currentValue;
			return currentValue;

		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnVU2035ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{

	double currentValue;
	if (aaPolicyYear > YearDiff2035) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			for (int i = 1; i < 13; i++) {
				if (i == 1) {
					MonthVU2035PrevValuehigh = VU2035PrevValuehigh;
				}
				
				if (VUCashValueHigh < 0 && [self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0 ) {
					
					currentValue=  ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
									pow(1 + [self ReturnVU2035InstHigh:@"A"], 1.00/12.00) + MonthVU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
									pow(1 + [self ReturnVU2035InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
									([self ReturnMonthFundValueOfTheYearVU2035ValueHigh:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
				}
				else{
					currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
									pow(1 + [self ReturnVU2035InstHigh:@"A" ], 1.00/12.00) + MonthVU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
									pow(1 + [self ReturnVU2035InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				}
				
				if (i == MonthDiff2035 && aaPolicyYear == YearDiff2035) {
					if (Fund2035PartialReinvest != 100) {
						NSLog(@"dadas %f", Fund2035PartialReinvest);
						//MonthFundMaturityValue2035_Bull = MonthVU2035PrevValuehigh * (100 - Fund2035PartialReinvest)/100.00;
					}
					else{
						MonthFundMaturityValue2035_Bull = 0;
					}
					MonthVU2035PrevValuehigh = 0;
				}
				else{
					MonthVU2035PrevValuehigh = currentValue;
				}
				
			}
			
			VU2035PrevValuehigh = MonthVU2035PrevValuehigh;
			return MonthVU2035PrevValuehigh;
		}
		else{
			if (VUCashValueHigh < 0 && [self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0 ) {
				
				currentValue=  ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				(1 + VU2035InstHigh) + VU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				([self ReturnFundValueOfTheYearVU2035ValueHigh:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
			}
			else{
				currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				(1 + VU2035InstHigh) + VU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);	
			}
			
			VU2035PrevValuehigh = currentValue;
			return currentValue;
		}
		

	}
}

-(double)ReturnVU2035ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{

	double currentValue;
	if (aaPolicyYear > YearDiff2035) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			for (int i = 1; i < 13; i++) {
				if (i == 1) {
					MonthVU2035PrevValueMedian = VU2035PrevValueMedian;
				}
				
				if (VUCashValueMedian < 0 && [self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0 ) {
					
					currentValue=  ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
					pow((1 + [self ReturnVU2035InstMedian:@"A"]), (1.00/12.00)) + MonthVU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow((1 + [self ReturnVU2035InstMedian:@"A"]), (1.00/12.00)) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
					([self ReturnMonthFundValueOfTheYearVU2035ValueMedian:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
				}
				else{
					currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] *[self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
					pow((1 + [self ReturnVU2035InstMedian:@"A" ]), (1.00/12.00)) + MonthVU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
					pow((1 + [self ReturnVU2035InstMedian:@"A"]), (1.00/12.00)) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				}
				
				
				if (i == MonthDiff2035 && aaPolicyYear == YearDiff2035) {
					if (Fund2035PartialReinvest != 100) {
						MonthFundMaturityValue2035_Flat = MonthVU2035PrevValueMedian * (100 - Fund2035PartialReinvest)/100.00;
					}
					else{
						MonthFundMaturityValue2035_Flat = 0;
					}
					MonthVU2035PrevValueMedian = 0;
				}
				else{
					MonthVU2035PrevValueMedian = currentValue;
				}

				

			}
			VU2035PrevValueMedian = MonthVU2035PrevValueMedian;
			return MonthVU2035PrevValueMedian;
		}
		else{
			if (VUCashValueMedian < 0 && [self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0 ) {
				
				currentValue=  ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] ) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				(1 + VU2035InstMedian) + VU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				([self ReturnFundValueOfTheYearVU2035ValueMedian:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
			}
			else{
				currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				(1 + VU2035InstMedian) + VU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			VU2035PrevValueMedian = currentValue;
			return currentValue;
		}
		
		
	}
}

-(double)ReturnVUCashValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{

	double tempValue = 0.00;
	
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		for (int i = 1; i < 13; i++) {
			if (i == 1) {
				MonthVUCashPrevValueHigh = VUCashPrevValueHigh;
			}
			
			tempValue = ((( [txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor +
						 [self ReturnRegTopUpPrem] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor +
						 [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor) *
						pow((1 + [self ReturnVUCashInstHigh:@"A"]), (1.00/12.00)) + MonthVUCashPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
						pow((1 + [self ReturnVUCashInstHigh:@"A"]), (1.00/12.00)) - (PolicyFee + [self ReturnTotalBasicMortHigh:aaPolicyYear]) -
						([self ReturnRegWithdrawal:aaPolicyYear] * [self ReturnRegWithdrawalFactor:i]);
			
			MonthVUCashPrevValueHigh =  tempValue;
			//NSLog(@"%f", MonthVUCashPrevValueHigh);
		}
		
		VUCashPrevValueHigh = MonthVUCashPrevValueHigh;
		if (tempValue < 0 && [self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0) {
			NegativeValueOfMaxCashFundHigh = MonthVUCashPrevValueHigh;
			return MonthVUCashPrevValueHigh;
		} else {
			NegativeValueOfMaxCashFundHigh = MonthVUCashPrevValueHigh;
			return MonthVUCashPrevValueHigh + 0; // to be edit later
		}
		
	}
	else
	{
		tempValue = ((( [txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear] * CYFactor +
					 [self ReturnRegTopUpPrem] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear] * CYFactor +
					 [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * [self ReturnVUCashFac:aaPolicyYear] * CYFactor) *
		(1 + [self ReturnVUCashInstHigh:@""]) + VUCashPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVUCashInstHigh:@"A"]) -
		(PolicyFee + [self ReturnTotalBasicMortHigh:aaPolicyYear]) * [self ReturnVUCashHigh] -
		([self ReturnRegWithdrawal:aaPolicyYear] * 1);
		
		
		VUCashPrevValueHigh = tempValue;
		if (tempValue < 0 && [self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0) {
			NegativeValueOfMaxCashFundHigh = tempValue;
			return tempValue;
		} else {
			NegativeValueOfMaxCashFundHigh = tempValue;
			return tempValue + 0; // to be edit later
		}
	}
	
	
	
	
	
}

-(double)ReturnVUCashValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	
	double tempValue = 0.00;
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		for (int i = 1; i < 13; i++) {
			if (i == 1) {
				MonthVUCashPrevValueMedian = VUCashPrevValueMedian;
			}
			tempValue = ((( [txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor +
						 [self ReturnRegTopUpPrem] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor +
						 [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor) *
						pow(1 + [self ReturnVUCashInstMedian:@"A"], 1.00/12.00) + MonthVUCashPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
						pow(1 + [self ReturnVUCashInstMedian:@"A"], 1.00/12.00) - (PolicyFee + [self ReturnTotalBasicMortMedian:aaPolicyYear]) -
						([self ReturnRegWithdrawal:aaPolicyYear] * [self ReturnRegWithdrawalFactor:i]);
			
			MonthVUCashPrevValueMedian = tempValue;

		}
		
		VUCashPrevValueMedian = MonthVUCashPrevValueMedian;
		if (tempValue < 0 && [self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0) {
			NegativeValueOfMaxCashFundMedian = MonthVUCashPrevValueMedian;
			return  MonthVUCashPrevValueMedian;
		} else {
			NegativeValueOfMaxCashFundMedian =  MonthVUCashPrevValueMedian;
			return  MonthVUCashPrevValueMedian + 0; // to be edit later
		}
	}
	else{
		tempValue = ((( [txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear] * CYFactor +
					 [self ReturnRegTopUpPrem] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear] * CYFactor +
					 [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * [self ReturnVUCashFac:aaPolicyYear] * CYFactor) *
					(1 + [self ReturnVUCashInstMedian:@""]) + VUCashPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVUCashInstMedian:@"A"]) -
					(PolicyFee + [self ReturnTotalBasicMortMedian:aaPolicyYear]) * [self ReturnVUCashMedian] -
					([self ReturnRegWithdrawal:aaPolicyYear] * 1);
		
		
		VUCashPrevValueMedian = tempValue;
		if (tempValue < 0 && [self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0) {
			NegativeValueOfMaxCashFundMedian = tempValue;
			return tempValue;
		} else {
			NegativeValueOfMaxCashFundMedian = tempValue;
			return tempValue + 0; // to be edit later
		}
	}
	
	
	
	
}


-(double)ReturnVURetValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{

	double currentValue;
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		for (int i = 1; i < 13; i++) {
			if (i == 1) {
				MonthVURetPrevValueHigh = VURetPrevValueHigh ;
			}
			
			//NSLog(@"%f", MonthVURetPrevValueHigh);
			if (VUCashValueHigh < 0 && [self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0 ) {
				currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
								pow(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"],1.00/12.00) + MonthVURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
								pow(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"], 1.00/12.00) -
								([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
								([self ReturnMonthFundValueOfTheYearVURetValueHigh:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
			}
			else{
				currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
								pow((1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]),(1.00/12.00)) + MonthVURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
								pow((1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]), (1.00/12.00)) -
								([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				
			}
			//NSLog(@"%f", MonthVURetPrevValueHigh);
			MonthVURetPrevValueHigh = currentValue;
		}
		
		VURetPrevValueHigh = MonthVURetPrevValueHigh;
		return MonthVURetPrevValueHigh;
	}
	else{
		if (VUCashValueHigh < 0 && [self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0 ) {
			currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] * CYFactor +
						   [self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
						   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@""]) + VURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]) -
			([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
			([self ReturnFundValueOfTheYearVURetValueHigh:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear]);
		}
		else{
			currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] * CYFactor +
							[self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
							[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@""]) + VURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]) -
			([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			
		}
		
		VURetPrevValueHigh = currentValue;
		return currentValue;
	}
	

}

-(double)ReturnVURetValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	
	double currentValue;
	
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		for (int i = 1; i < 13; i++) {
			if (i == 1) {
				MonthVURetPrevValueMedian = VURetPrevValueMedian ;
			}
			
			if (VUCashValueMedian < 0 && [self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0 ) {
				currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
				pow(1 + [self ReturnVURetInstMedian], 1.00/12.00) + MonthVURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVURetInstMedian], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				([self ReturnMonthFundValueOfTheYearVURetValueMedian:aaPolicyYear]/[self ReturnMonthFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
				
			}
			else{
				currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
								pow(1 + [self ReturnVURetInstMedian], 1.00/12.00) + MonthVURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
								pow(1 + [self ReturnVURetInstMedian], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				
			}
			MonthVURetPrevValueMedian = currentValue;
		}
		
		VURetPrevValueMedian = MonthVURetPrevValueMedian ;
		return MonthVURetPrevValueMedian;
	}
	else{
		if (VUCashValueMedian < 0 && [self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0 ) {
			currentValue= ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] * CYFactor +
						   [self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
						   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			(1 + [self ReturnVURetInstMedian]) + VURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstMedian]) -
			([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
			([self ReturnFundValueOfTheYearVURetValueMedian:aaPolicyYear]/[self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear]);
			
		}
		else{
			currentValue = ((([txtBasicPremium.text doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] * CYFactor +
							[self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
							[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			(1 + [self ReturnVURetInstMedian]) + VURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstMedian]) -
			([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			
		}
		
		VURetPrevValueMedian = currentValue;
		return currentValue;
	}
	
}

-(double)ReturnRegWithdrawal :(int)aaPolicyYear{
	if (aaPolicyYear >= RegWithdrawalStartYear) {
		if (aaPolicyYear <= RegWithdrawalEndYear) {
			if ((aaPolicyYear - RegWithdrawalStartYear) % RegWithdrawalIntYear == 0) {
				return RegWithdrawalAmount;
			}
			else{
				return 0;
			}
		}
		else{
			return 0;
		}
	}
	else{
		return 0;
	}
}

-(double)ReturnRegWithdrawalFactor :(int)aaMonth{
	if (aaMonth == 12) {
		return 1.00;
	}
	else{
		return 0;
	}
}
			
-(double)ReturnRegTopUpPrem{
	if (![txtGrayRTUP.text isEqualToString:@""]) {
		return [txtGrayRTUP.text doubleValue ];
	}
	else{
		return 0;
	}
}

#pragma mark - Calculate Fund Factor

#pragma mark - Calculate Yearly Fund Value

-(double)ReturnMonthFundValueOfTheYearValueTotalHigh: (int)aaPolicyYear{
	return [self ReturnMonthFundValueOfTheYearVU2023ValueHigh:aaPolicyYear] +
			[self ReturnMonthFundValueOfTheYearVU2025ValueHigh:aaPolicyYear] +
			[self ReturnMonthFundValueOfTheYearVU2028ValueHigh:aaPolicyYear] +
			[self ReturnMonthFundValueOfTheYearVU2030ValueHigh:aaPolicyYear] +
			[self ReturnMonthFundValueOfTheYearVU2035ValueHigh:aaPolicyYear] +
			[self ReturnMonthFundValueOfTheYearVURetValueHigh:aaPolicyYear];
	
}

-(double)ReturnFundValueOfTheYearValueTotalHigh: (int)aaPolicyYear{
	return [self ReturnFundValueOfTheYearVU2023ValueHigh:aaPolicyYear] +
		   [self ReturnFundValueOfTheYearVU2025ValueHigh:aaPolicyYear] +
			[self ReturnFundValueOfTheYearVU2028ValueHigh:aaPolicyYear] +
			[self ReturnFundValueOfTheYearVU2030ValueHigh:aaPolicyYear] +
			[self ReturnFundValueOfTheYearVU2035ValueHigh:aaPolicyYear] +
			[self ReturnFundValueOfTheYearVURetValueHigh:aaPolicyYear];
}

-(double)ReturnFundValueOfTheYearVU2023ValueHigh: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2023) {
		return VU2023ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2025ValueHigh: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2025) {
		return VU2025ValueHigh;
	} else {
		return 0;
	}
}


-(double)ReturnFundValueOfTheYearVU2028ValueHigh: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2028) {
		return VU2028ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2030ValueHigh: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2030) {
		return VU2030ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2035ValueHigh: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2035) {
		return VU2035ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVURetValueHigh: (int)aaPolicyYear{
	return VURetValueHigh;
}

-(double)ReturnMonthFundValueOfTheYearVU2023ValueHigh: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2023) {
		return VU2023ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2025ValueHigh: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2025) {
		return VU2025ValueHigh;
	} else {
		return 0;
	}
}


-(double)ReturnMonthFundValueOfTheYearVU2028ValueHigh: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2028) {
		return VU2028ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2030ValueHigh: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2030) {
		return VU2030ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2035ValueHigh: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2035) {
		return VU2035ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVURetValueHigh: (int)aaPolicyYear{
	return VURetValueHigh;
}

-(double)ReturnFundValueOfTheYearValueTotalMedian: (int)aaPolicyYear{
	return [self ReturnFundValueOfTheYearVU2023ValueMedian:aaPolicyYear] +
			[self ReturnFundValueOfTheYearVU2025ValueMedian:aaPolicyYear] +
			[self ReturnFundValueOfTheYearVU2028ValueMedian:aaPolicyYear] +
			[self ReturnFundValueOfTheYearVU2030ValueMedian:aaPolicyYear] +
			[self ReturnFundValueOfTheYearVU2035ValueMedian:aaPolicyYear] +
			[self ReturnFundValueOfTheYearVURetValueMedian:aaPolicyYear];
}

-(double)ReturnMonthFundValueOfTheYearValueTotalMedian: (int)aaPolicyYear{
	return [self ReturnMonthFundValueOfTheYearVU2023ValueMedian:aaPolicyYear] +
			[self ReturnMonthFundValueOfTheYearVU2025ValueMedian:aaPolicyYear] +
			[self ReturnMonthFundValueOfTheYearVU2028ValueMedian:aaPolicyYear] +
			[self ReturnMonthFundValueOfTheYearVU2030ValueMedian:aaPolicyYear] +
			[self ReturnMonthFundValueOfTheYearVU2035ValueMedian:aaPolicyYear] +
			[self ReturnMonthFundValueOfTheYearVURetValueMedian:aaPolicyYear];
	
}

-(double)ReturnFundValueOfTheYearVU2023ValueMedian: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2023) {
		return VU2023ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2025ValueMedian: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2025) {
		return VU2025ValueMedian;
	} else {
		return 0;
	}
}


-(double)ReturnFundValueOfTheYearVU2028ValueMedian: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2028) {
		return VU2028ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2030ValueMedian: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2030) {
		return VU2030ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2035ValueMedian: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2035) {
		return VU2035ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVURetValueMedian: (int)aaPolicyYear{
	return VURetValueMedian;
}

-(double)ReturnMonthFundValueOfTheYearVU2023ValueMedian: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2023) {
		return VU2023ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2025ValueMedian: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2025) {
		return VU2025ValueMedian;
	} else {
		return 0;
	}
}


-(double)ReturnMonthFundValueOfTheYearVU2028ValueMedian: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2028) {
		return VU2028ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2030ValueMedian: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2030) {
		return VU2030ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2035ValueMedian: (int)aaPolicyYear{
	if (aaPolicyYear <= YearDiff2035) {
		return VU2035ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVURetValueMedian: (int)aaPolicyYear{
	return VURetValueMedian;
}



#pragma mark - Others
-(double)ReturnVU2023Fac{
	return (double)VU2023Factor/100.00;
}

-(double)ReturnVU2025Fac :(int)aaPolicyYear {
	double factor1 = (double)VU2025Factor;
	double factor2 = factor1 + (double)VU2023Factor * (factor1/[self FactorGroup:2]);
	double factor3 = 0.00;
	
	if (aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTerm2025) {
		return factor2/100.00;
	}
	else if (aaPolicyYear > FundTerm2025){
		return factor3/100.00;
	}
	else{
		return (double)VU2025Factor/100.00;
	}
}

-(double)ReturnVU2028Fac :(int)aaPolicyYear {
	double factor1 = (double)VU2028Factor;
	double factor2 = factor1 + (double)VU2023Factor * (factor1/[self FactorGroup:2]);
	double factor3 = factor2 + (double)VU2025Factor * (factor2/[self FactorGroup:3]);;
	double factor4 = 0.00;
	
	if (aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTerm2025) {
		return factor2/100.00;
	}
	else if (aaPolicyYear >= FundTerm2025 && aaPolicyYear <= FundTerm2028) {
		return factor3/100.00;
	}
	else if (aaPolicyYear > FundTerm2028){
		return factor4/100.00;
	}
	else{
		return (double)VU2028Factor/100.00;
	}
}

-(double)ReturnVU2030Fac :(int)aaPolicyYear {
	double factor1 = (double)VU2030Factor;
	double factor2 = factor1 + (double)VU2023Factor * (factor1/[self FactorGroup:2]);
	double factor3 = factor2 + (double)VU2025Factor * (factor2/[self FactorGroup:3]);;
	double factor4 = factor3 + (double)VU2025Factor * (factor3/[self FactorGroup:4]);;
	double factor5 = 0.00;
	
	if (aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTerm2025) {
		return factor2/100.00;
	}
	else if (aaPolicyYear >= FundTerm2025 && aaPolicyYear <= FundTerm2028) {
		return factor3/100.00;
	}
	else if (aaPolicyYear >= FundTerm2028 && aaPolicyYear <= FundTerm2030) {
		return factor4/100.00;
	}
	else if (aaPolicyYear > FundTerm2030){
		return factor5/100.00;
	}
	else{
		return (double)VU2030Factor/100.00;
	}
}

-(double)ReturnVU2035Fac :(int)aaPolicyYear {
	double factor1 = (double)VU2035Factor;
	double factor2 = factor1 + (double)VU2023Factor * (factor1/[self FactorGroup:2]);
	double factor3 = factor2 + (double)VU2025Factor * (factor2/[self FactorGroup:3]);
	double factor4 = factor3 + (double)VU2025Factor * (factor3/[self FactorGroup:4]);
	double factor5 = factor4 + (double)VU2025Factor * (factor4/[self FactorGroup:5]);
	double factor6 = 0.00;
	
	if (aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTerm2025) {
		return factor2/100.00;
	}
	else if (aaPolicyYear >= FundTerm2025 && aaPolicyYear <= FundTerm2028) {
		return factor3/100.00;
	}
	else if (aaPolicyYear >= FundTerm2028 && aaPolicyYear <= FundTerm2030) {
		return factor4/100.00;
	}
	else if (aaPolicyYear >= FundTerm2030 && aaPolicyYear <= FundTerm2035) {
		return factor5/100.00;
	}
	else if (aaPolicyYear > FundTerm2030){
		return factor6/100.00;
	}
	else{
		return (double)VU2035Factor/100.00;
	}
}

-(double)ReturnVU2035Fac :(int)aaPolicyYear andMonth:(int)aaMonth   {
	double factor1 = (double)VU2035Factor;
	double factor2 = factor1 + (double)VU2023Factor * (factor1/[self FactorGroup:2]);
	double factor3 = factor2 + (double)VU2025Factor * (factor2/[self FactorGroup:3]);
	double factor4 = factor3 + (double)VU2025Factor * (factor3/[self FactorGroup:4]);
	double factor5 = factor4 + (double)VU2025Factor * (factor4/[self FactorGroup:5]);
	double factor6 = 0.00;
	
	if(aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTermPrev2025 && aaMonth > MonthDiff2023 ){
		return factor2/100.00;
	}
	else if(aaPolicyYear == FundTerm2025 && aaMonth <= MonthDiff2025){
		return factor2/100.00;
	}
	else if(aaPolicyYear >= FundTerm2025 && aaPolicyYear <= FundTermPrev2028 && aaMonth > MonthDiff2025 ){
		return factor3/100.00;
	}
	else if(aaPolicyYear == FundTerm2028 && aaMonth <= MonthDiff2028){
		return factor3/100.00;
	}
	else if(aaPolicyYear >= FundTerm2028 && aaPolicyYear <= FundTermPrev2030 && aaMonth > MonthDiff2028 ){
		return factor4/100.00;
	}
	else if(aaPolicyYear == FundTerm2030 && aaMonth <= MonthDiff2030){
		return factor4/100.00;
	}
	else if(aaPolicyYear >= FundTerm2030 && aaPolicyYear <= FundTermPrev2035 && aaMonth > MonthDiff2030 ){
		return factor5/100.00;
	}
	else if(aaPolicyYear > FundTermPrev2035 && aaMonth <= MonthDiff2035){
		return factor5/100.00;
	}
	else if(aaPolicyYear > FundTermPrev2035 && aaMonth > MonthDiff2035){
		return factor6/100.00;
	}
	else{
		return (double)VU2035Factor/100.00;
	}
	
	
}


-(double)ReturnVUCashFac :(int)aaPolicyYear {
	double factor2;
	double factor3;
	double factor4;
	double factor5;
	double factor6;
	
	if(VUCashOptFactor > 0 && [self FactorGroup:2] == 0){
		factor2 = (double)VUCashOptFactor;
	}
	else{
		factor2 = (double)VUCashFactor;
	}
	
	if(VUCashOptFactor > 0 && [self FactorGroup:3] == 0){
		factor3 = (double)VUCashOptFactor;
	}
	else{
		factor3 = (double)VUCashFactor;
	}
	
	if(VUCashOptFactor > 0 && [self FactorGroup:4] == 0){
		factor4 = (double)VUCashOptFactor;
	}
	else{
		factor4 = (double)VUCashFactor;
	}
	
	if(VUCashOptFactor > 0 && [self FactorGroup:5] == 0){
		factor5 = (double)VUCashOptFactor;
	}
	else{
		factor5 = (double)VUCashFactor;
	}
	
	if(VUCashOptFactor > 0 && [self FactorGroup:6] == 0){
		factor6 = (double)VUCashOptFactor;
	}
	else{
		factor6 = (double)VUCashFactor;
	}
	
	
		if(aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTerm2025){
			return factor2/100.00;
		}
		else if(aaPolicyYear >= FundTerm2025 && aaPolicyYear <= FundTerm2028){
			return factor3/100.00;
		}
		else if(aaPolicyYear >= FundTerm2028 && aaPolicyYear <= FundTerm2030){
			return factor4/100.00;
		}
		else if(aaPolicyYear >= FundTerm2030 && aaPolicyYear <= FundTerm2035){
			return factor5/100.00;
		}
		else if(aaPolicyYear > FundTerm2035){
			return factor6/100.00;
		}
		else{
			return (double)VUCashFactor/100.00;
		}
		
}

-(double)ReturnVUCashFac :(int)aaPolicyYear andMonth:(int)aaMonth  {
	double factor2;
	double factor3;
	double factor4;
	double factor5;
	double factor6;
	
	if(VUCashOptFactor > 0 && [self FactorGroup:2] == 0){
		factor2 = (double)VUCashOptFactor;
	}
	else{
		factor2 = (double)VUCashFactor;
	}

	if(VUCashOptFactor > 0 && [self FactorGroup:3] == 0){
		factor3 = (double)VUCashOptFactor;
	}
	else{
		factor3 = (double)VUCashFactor;
	}

	if(VUCashOptFactor > 0 && [self FactorGroup:4] == 0){
		factor4 = (double)VUCashOptFactor;
	}
	else{
		factor4 = (double)VUCashFactor;
	}

	if(VUCashOptFactor > 0 && [self FactorGroup:5] == 0){
		factor5 = (double)VUCashOptFactor;
	}
	else{
		factor5 = (double)VUCashFactor;
	}

	if(VUCashOptFactor > 0 && [self FactorGroup:6] == 0){
		factor6 = (double)VUCashOptFactor;
	}
	else{
		factor6 = (double)VUCashFactor;
	}

		if(aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTermPrev2025 && aaMonth > MonthDiff2023 ){
			return factor2/100.00;
		}
		else if(aaPolicyYear == FundTerm2025 && aaMonth <= MonthDiff2023){
			return factor2/100.00;
		}
		else if(aaPolicyYear >= FundTerm2025 && aaPolicyYear <= FundTermPrev2028 && aaMonth > MonthDiff2025 ){
			return factor3/100.00;
		}
		else if(aaPolicyYear == FundTerm2028 && aaMonth <= MonthDiff2028){
			return factor3/100.00;
		}
		else if(aaPolicyYear >= FundTerm2028 && aaPolicyYear <= FundTermPrev2030 && aaMonth > MonthDiff2028 ){
			return factor4/100.00;
		}
		else if(aaPolicyYear == FundTerm2030 && aaMonth <= MonthDiff2030){
			return factor4/100.00;
		}
		else if(aaPolicyYear >= FundTerm2030 && aaPolicyYear <= FundTermPrev2035 && aaMonth > MonthDiff2030 ){
			return factor5/100.00;
		}
		else if(aaPolicyYear > FundTermPrev2035 && aaMonth <= MonthDiff2035){
			return factor5/100.00;
		}
		else if(aaPolicyYear > FundTermPrev2035 && aaMonth > MonthDiff2035){
			return factor6/100.00;
		}
		else{
			return (double)VUCashFactor/100.00;
		}
	
}

-(double)ReturnVURetFac :(int)aaPolicyYear {
	double factor1;
	double factor2;
	double factor3;
	double factor4;
	double factor5;
	double factor6;
	
	if (VURetFactor > 0) {
		factor1 =(double)VURetFactor;
		factor2 = factor1 + (double)VU2023Factor * (double)(factor1/[self FactorGroup:2]);
		factor3 = factor2 + (double)VU2025Factor * (double)(factor2/[self FactorGroup:3]);
		factor4 = factor3 + (double)VU2028Factor * (double)(factor3/[self FactorGroup:4]);
		factor5 = factor4 + (double)VU2030Factor * (double)(factor4/[self FactorGroup:5]);
		factor6 = factor5 + (double)VU2035Factor * (double)(factor5/[self FactorGroup:6]);
	}
	else if (VURetOptFactor > 0){
		if ([self FactorGroup:2] == 0) {
			factor2 = (double)VURetOptFactor;
		}
		else{
			factor2 = 0.00;
		}
			
		if ([self FactorGroup:3] == 0) {
			factor3 = (double)VURetOptFactor;
		}
		else{
			factor3 = 0.00;
		}
		
		if ([self FactorGroup:4] == 0) {
			factor4 = (double)VURetOptFactor;
		}
		else{
			factor4 = 0.00;
		}
		
		if ([self FactorGroup:5] == 0) {
			factor5 = (double)VURetOptFactor;
		}
		else{
			factor5 = 0.00;
		}
		
		if ([self FactorGroup:6] == 0) {
			factor6 = (double)VURetOptFactor;
		}
		else{
			factor6 = 0.00;
		}
	}
	
	if (aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTermPrev2025) {
		return factor2/100.00;
	}
	else if (aaPolicyYear >= FundTerm2025 && aaPolicyYear <= FundTermPrev2028) {
		return factor3/100.00;
	}
	else if (aaPolicyYear >= FundTerm2028 && aaPolicyYear <= FundTermPrev2030) {
		return factor4/100.00;
	}
	else if (aaPolicyYear >= FundTerm2030 && aaPolicyYear <= FundTermPrev2035) {
		return factor5/100.00;
	}
	else if (aaPolicyYear > FundTerm2025) {
		return factor6/100.00;
	}
	else{
		return (double)VURetFactor/100.00;
	}
}

-(double)ReturnVURetFac :(int)aaPolicyYear andMonth:(int) aaMonth {
	double factor1;
	double factor2;
	double factor3;
	double factor4;
	double factor5;
	double factor6;
	
	if (VURetFactor > 0) {
		factor1 =(double)VURetFactor;
		factor2 = factor1 + (double)VU2023Factor * (double)(factor1/[self FactorGroup:2]);
		factor3 = factor2 + (double)VU2025Factor * (double)(factor2/[self FactorGroup:3]);
		factor4 = factor3 + (double)VU2028Factor * (double)(factor3/[self FactorGroup:4]);
		factor5 = factor4 + (double)VU2030Factor * (double)(factor4/[self FactorGroup:5]);
		factor6 = factor5 + (double)VU2035Factor * (double)(factor5/[self FactorGroup:6]);
	}
	else if (VURetOptFactor > 0){
		if ([self FactorGroup:2] == 0) {
			factor2 = (double)VURetOptFactor;
		}
		else{
			factor2 = 0.00;
		}
		
		if ([self FactorGroup:3] == 0) {
			factor3 = (double)VURetOptFactor;
		}
		else{
			factor3 = 0.00;
		}
		
		if ([self FactorGroup:4] == 0) {
			factor4 = (double)VURetOptFactor;
		}
		else{
			factor4 = 0.00;
		}
		
		if ([self FactorGroup:5] == 0) {
			factor5 = (double)VURetOptFactor;
		}
		else{
			factor5 = 0.00;
		}
		
		if ([self FactorGroup:6] == 0) {
			factor6 = (double)VURetOptFactor;
		}
		else{
			factor6 = 0.00;
		}
	}
	
	if(aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTermPrev2025 && aaMonth > MonthDiff2023 ){
		return factor2/100.00;
	}
	else if(aaPolicyYear == FundTerm2025 && aaMonth <= MonthDiff2023){
		return factor2/100.00;
	}
	else if(aaPolicyYear >= FundTerm2025 && aaPolicyYear <= FundTermPrev2028 && aaMonth > MonthDiff2025 ){
		return factor3/100.00;
	}
	else if(aaPolicyYear == FundTerm2028 && aaMonth <= MonthDiff2028){
		return factor3/100.00;
	}
	else if(aaPolicyYear >= FundTerm2028 && aaPolicyYear <= FundTermPrev2030 && aaMonth > MonthDiff2028 ){
		return factor4/100.00;
	}
	else if(aaPolicyYear == FundTerm2030 && aaMonth <= MonthDiff2030){
		return factor4/100.00;
	}
	else if(aaPolicyYear >= FundTerm2030 && aaPolicyYear <= FundTermPrev2035 && aaMonth > MonthDiff2030 ){
		return factor5/100.00;
	}
	else if(aaPolicyYear > FundTermPrev2035 && aaMonth <= MonthDiff2035){
		return factor5/100.00;
	}
	else if(aaPolicyYear > FundTermPrev2035 && aaMonth > MonthDiff2035){
		return factor6/100.00;
	}
	else{
		return (double)VURetFactor/100.00;
	}
}



-(double)FactorGroup : (uint)aaGroup{
	if (aaGroup == 1) {
		return VU2023Factor + VU2025Factor + VU2028Factor + VU2030Factor + VU2035Factor + VURetFactor;
	}
	else if (aaGroup == 2) {
		return VU2025Factor + VU2028Factor + VU2030Factor + VU2035Factor + VURetFactor;
	}
	else if (aaGroup == 3) {
		return VU2028Factor + VU2030Factor + VU2035Factor + VURetFactor;
	}
	else if (aaGroup == 4) {
		return VU2030Factor + VU2035Factor + VURetFactor;
	}
	else if (aaGroup == 5) {
		return VU2035Factor + VURetFactor;
	}
	else {
		return VURetFactor;
	}
}

-(double)ReturnTotalBasicMortHigh: (int)aaPolicyYear{
	return [txtBasicSA.text doubleValue ] * (([self ReturnBasicMort:ageClient + aaPolicyYear -1]/1000.00) * (1 + [getHLPct doubleValue ]/100.00) +
												  [getHL doubleValue] + [getOccLoading doubleValue ])/12.00;
}

-(double)ReturnTotalBasicMortMedian: (int)aaPolicyYear{
	return [txtBasicSA.text doubleValue ] * (([self ReturnBasicMort:ageClient + aaPolicyYear -1]/1000.00) * (1 + [getHLPct doubleValue ]/100.00) +
												  [getHL doubleValue] + [getOccLoading doubleValue ])/12.00;
}

-(double)ReturnTotalBasicMortLow: (int)aaPolicyYear{
	return [txtBasicSA.text doubleValue ] * (([self ReturnBasicMort:ageClient + aaPolicyYear -1]/1000.00) * (1 + [getHLPct doubleValue ]/100.00) +
												  [getHL doubleValue] + [getOccLoading doubleValue ])/12.00;
}

-(double)ReturnVUCashHigh{
	double VUCashHighS = pow((1.00 + [self ReturnVUCashInstHigh:@""]), 1.00/12.00) - 1.00 ;
	
	return (pow((1.00 + VUCashHighS), 12.00) - 1.00)/(VUCashHighS / (1.00 + VUCashHighS));
}

-(double)ReturnVUCashMedian{
	double VUCashMedianS = pow((1.00 + [self ReturnVUCashInstMedian:@""]), 1.00/12.00) - 1.00 ;
	
	return (pow((1.00 + VUCashMedianS), 12.00) - 1.00)/(VUCashMedianS / (1.00 + VUCashMedianS));
}

-(double)ReturnVUCashLow{
	double VUCashLowS = pow((1.00 + [self ReturnVUCashInstLow:@""]), 1.00/12.00) - 1.00 ;
	
	return (pow((1.00 + VUCashLowS), 12) - 1)/(VUCashLowS / (1.00 + VUCashLowS));
}

-(double)ReturnVU2023InstHigh: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0532298;
	}
}

-(double)ReturnVU2025InstHigh: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0588615;
	}
}

-(double)ReturnVU2028InstHigh: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0739896;
	}
}

-(double)ReturnVU2030InstHigh: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.077761;
	}
}

-(double)ReturnVU2035InstHigh: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0817997;
	}
}

-(double)ReturnVU2023InstMedian: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0290813;
	}
	else{
		return 0;
	}
}

-(double)ReturnVU2025InstMedian: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0340098;
	}
	else{
		return 0;
	}
}

-(double)ReturnVU2028InstMedian: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0389747;
	}
	else{
		return 0;
	}
}

-(double)ReturnVU2030InstMedian: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0413285;
	}
	else{
		return 0;
	}
}

-(double)ReturnVU2035InstMedian: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0439735;
	}
	else{
		return 0;
	}
}

-(void)CalcInst: (NSString *)aaMOP{
	sqlite3_stmt *statement;
	NSString *querySQL;
	NSString *MOP;
	
	if ([aaMOP isEqualToString:@""]) {
		MOP = [self ReturnBumpMode];
	} else {
		MOP = aaMOP;
	}
	
	if (sqlite3_open([UL_databasePath UTF8String], &contactDB) == SQLITE_OK){
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
			  VU2023InstHigh = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2023InstMedian = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}

		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '13' AND Fund_Year = '1'"];
		}
		
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2023InstLow = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		
		//------------
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}

		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2025InstHigh = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}

			if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
				if (sqlite3_step(statement) == SQLITE_ROW){
					VU2025InstMedian = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
				}
				sqlite3_finalize(statement);
			}

		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '15' AND Fund_Year = '1'"];
		}
		
			if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
				if (sqlite3_step(statement) == SQLITE_ROW){
					VU2025InstLow = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
				}
				sqlite3_finalize(statement);
			}
		
		//-----------
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2028InstHigh = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2028InstMedian = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '18' AND Fund_Year = '1'"];
		}
		

		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2028InstLow = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		
		//--------
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2030InstHigh = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2030InstMedian = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '20' AND Fund_Year = '1'"];
		}
		
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2030InstLow = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		// ----------
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Bull_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2035InstHigh = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Flat_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2035InstMedian = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		
		if ([MOP isEqualToString:@"A"]) {
			querySQL = [NSString stringWithFormat:@"Select Year_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"S"]) {
			querySQL = [NSString stringWithFormat:@"Select Half_Year_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		else if ([MOP isEqualToString:@"Q"]) {
			querySQL = [NSString stringWithFormat:@"Select Quarter_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		else {
			querySQL = [NSString stringWithFormat:@"Select Month_Bear_Rate From ES_Sys_Fund_Growth_Rate WHERE Fund_Term = '25' AND Fund_Year = '1'"];
		}
		
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				VU2035InstLow = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] doubleValue ];
			}
			sqlite3_finalize(statement);
		}
		
		sqlite3_close(contactDB);
	}
}

-(double)ReturnVUCashInstHigh :(NSString *)aaMOP{
	
	NSString *MOP;
	if ([aaMOP isEqualToString:@""]) {
		MOP = [self ReturnBumpMode];
	}
	else{
		MOP = aaMOP;
	}
	
	if ([MOP isEqualToString:@"A"]) {
		return 0.0251;
	}
	else if ([MOP isEqualToString:@"S"]) {
		return 0.0187861;
	}
	else if ([MOP isEqualToString:@"Q"]) {
		return 0.0156389;
	}
	else {
		return 0.0135443;
	}
}

-(double)ReturnVUCashInstMedian :(NSString *)aaMOP{
	NSString *MOP;
	if ([aaMOP isEqualToString:@""]) {
		MOP = [self ReturnBumpMode];
	}
	else{
		MOP = aaMOP;
	}
	
	if ([MOP isEqualToString:@"A"]) {
		return 0.0228;
	}
	else if ([MOP isEqualToString:@"S"]) {
		return 0.0170679;
	}
	else if ([MOP isEqualToString:@"Q"]) {
		return 0.0142098;
	}
	else {
		return 0.0123075;
	}
}

-(double)ReturnVUCashInstLow :(NSString *)aaMOP{
	NSString *MOP;
	if ([aaMOP isEqualToString:@""]) {
		MOP = [self ReturnBumpMode];
	}
	else{
		MOP = aaMOP;
	}
	
	if ([MOP isEqualToString:@"A"]) {
		return 0.0205;
	}
	else if ([MOP isEqualToString:@"S"]) {
		return 0.015349;
	}
	else if ([MOP isEqualToString:@"Q"]) {
		return 0.01278;
	}
	else {
		return 0.0110697;
	}
}

-(double)ReturnVURetInstHigh :(int)aaPolicyYear  andMOP:(NSString *)aaMOP{
	NSString *MOP = [self ReturnBumpMode];
	
	if ([aaMOP isEqualToString:@""]) {
		MOP = [self ReturnBumpMode];
	}
	else{
		MOP = aaMOP;
	}
	
	if ([MOP isEqualToString:@"A"]) {
		if (aaPolicyYear <= 20) {
			return 0.05808;
		}
		else{
			return 0.03784;
		}
	}
	else if ([MOP isEqualToString:@"S"]) {
		if (aaPolicyYear <= 20) {
			return 0.0433551;
		}
		else{
			return 0.0282922;
		}
	}
	else if ([MOP isEqualToString:@"Q"]) {
		if (aaPolicyYear <= 20) {
			return 0.0360438;
		}
		else{
			return 0.0235402;
		}
	}
	else {
		if (aaPolicyYear <= 20) {
			return 0.0311887;
		}
		else{
			return 0.0203804;
		}
	}
}

-(double)ReturnVURetInstMedian{
	
	if ([[self ReturnBumpMode] isEqualToString:@"A"]) {
		return 0.03324;
	}
	else if ([[self ReturnBumpMode] isEqualToString:@"S"]) {
		return 0.0248621;
	}
	else if ([[self ReturnBumpMode] isEqualToString:@"Q"]) {
		return 0.0206901;
	}
	else {
		return 0.0179151;
	}
}

-(double)ReturnVURetInstLow{
	if ([[self ReturnBumpMode] isEqualToString:@"A"]) {
		return 0.02312;
	}
	else if ([[self ReturnBumpMode] isEqualToString:@"S"]) {
		return 0.017307;
	}
	else if ([[self ReturnBumpMode] isEqualToString:@"Q"]) {
		return 0.0144087;
	}
	else {
		return 0.0124796;
	}
}

-(double)ReturnLoyaltyBonus :(int)aaPolicyYear{
	if (aaPolicyYear == 7) {
		return 0.04;
	}
	else if (aaPolicyYear == 8){
		return 0.08;
	}
	else if (aaPolicyYear == 9){
		return 0.12;
	}
	else if (aaPolicyYear == 10){
		return 0.16;
	}
	else if (aaPolicyYear > 10){
		return 0.2;
	}
	else{
		return 0;
	}
}

-(int)ReturnLoyaltyBonusFactor: (int)aaMonth{
	if (aaMonth == 1) {
		return 1;
	}
	else{
		return 0;
	}
}

-(double)ReturnPremiumFactor: (int)aaMonth{
	NSString *MOP = [self ReturnBumpMode];
	
	if ([MOP isEqualToString:@"A" ]) {
		if (aaMonth == 1) {
			return 1.00;
		}
		else{
			return 0;
		}
	}
	else if([MOP isEqualToString:@"S" ]) {
		if (aaMonth == 1 || aaMonth == 7 ) {
			return 0.5;
		}
		else{
			return 0;
		}
	}
	else if([MOP isEqualToString:@"Q" ]) {
		if (aaMonth == 1 || aaMonth == 4 || aaMonth == 7 || aaMonth == 10 ) {
			return 0.25;
		}
		else{
			return 0;
		}
	}
	else {
		return 1.00/12.00;
	}

}

-(void)CalcYearDiff{
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"dd/MM/yyyy"];
	NSDate* d = [df dateFromString:getPlanCommDate];
	NSDate* d2 = [df dateFromString:@"26/12/2023"];
	NSDate* d3 = [df dateFromString:@"26/12/2025"];
	NSDate* d4 = [df dateFromString:@"26/12/2028"];
	NSDate* d5 = [df dateFromString:@"26/12/2030"];
	NSDate* d6 = [df dateFromString:@"26/12/2035"];
	NSDate *fromDate;
    NSDate *toDate2;
	NSDate *toDate3;
	NSDate *toDate4;
	NSDate *toDate5;
	NSDate *toDate6;
	
    NSCalendar *calendar = [NSCalendar currentCalendar];
	
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
				 interval:NULL forDate:d];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate2
				 interval:NULL forDate:d2];
	[calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate3
				 interval:NULL forDate:d3];
	[calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate4
				 interval:NULL forDate:d4];
	[calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate5
				 interval:NULL forDate:d5];
	[calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate6
				 interval:NULL forDate:d6];
	
    NSDateComponents *difference2 = [calendar components:NSDayCalendarUnit
											   fromDate:fromDate toDate:toDate2 options:0];
    NSDateComponents *difference3 = [calendar components:NSDayCalendarUnit
												fromDate:fromDate toDate:toDate3 options:0];
    NSDateComponents *difference4 = [calendar components:NSDayCalendarUnit
												fromDate:fromDate toDate:toDate4 options:0];
    NSDateComponents *difference5 = [calendar components:NSDayCalendarUnit
												fromDate:fromDate toDate:toDate5 options:0];
    NSDateComponents *difference6 = [calendar components:NSDayCalendarUnit
												fromDate:fromDate toDate:toDate6 options:0];

	
	NSString *round2 = [NSString stringWithFormat:@"%.2f", [difference2 day]/365.25];
	NSString *round3 = [NSString stringWithFormat:@"%.2f", [difference3 day]/365.25];
	NSString *round4 = [NSString stringWithFormat:@"%.2f", [difference4 day]/365.25];
	NSString *round5 = [NSString stringWithFormat:@"%.2f", [difference5 day]/365.25];
	NSString *round6 = [NSString stringWithFormat:@"%.2f", [difference6 day]/365.25];
	

	//YearDiff2023 = round([round2 doubleValue]);
	//YearDiff2025 = round([round3 doubleValue]);
	//YearDiff2028 = round([round4 doubleValue]);
	//YearDiff2030 = round([round5 doubleValue]);
	//YearDiff2035 = round([round6 doubleValue]);

	YearDiff2023 = ceil([round2 doubleValue]);
	YearDiff2025 = ceil([round3 doubleValue]);
	YearDiff2028 = ceil([round4 doubleValue]);
	YearDiff2030 = ceil([round5 doubleValue]);
	YearDiff2035 = ceil([round6 doubleValue]);

	FundTermPrev2023 = YearDiff2023 - 1;
	FundTerm2023 = YearDiff2023;
	FundTermPrev2025 = YearDiff2025 - 1;
	FundTerm2025 = YearDiff2025;
	FundTermPrev2028 = YearDiff2028 - 1;
	FundTerm2028 = YearDiff2028;
	FundTermPrev2030 = YearDiff2030 - 1;
	FundTerm2030 = YearDiff2030;
	FundTermPrev2035 = YearDiff2035 - 1;
	FundTerm2035 = YearDiff2035;
	
	MonthDiff2023 = ceil(([round2 doubleValue ] - (YearDiff2023 - 1))/(1.00/12.00));
	MonthDiff2025 = ceil(([round3 doubleValue ] - (YearDiff2025 - 1))/(1.00/12.00));
	MonthDiff2028 = ceil(([round4 doubleValue ] - (YearDiff2028 - 1))/(1.00/12.00));
	MonthDiff2030 = ceil(([round5 doubleValue ] - (YearDiff2030 - 1))/(1.00/12.00));
	MonthDiff2035 = ceil(([round6 doubleValue ] - (YearDiff2035 - 1))/(1.00/12.00));
	

	
	if (MonthDiff2023 == 12) {
		Allo2023 = YearDiff2023 + 1;
	}
	else{
		Allo2023 = YearDiff2023;
	}
	
	if (MonthDiff2025 == 12) {
		Allo2025 = YearDiff2025 + 1;
	}
	else{
		Allo2025 = YearDiff2025;
	}
	
	if (MonthDiff2028 == 12) {
		Allo2028 = YearDiff2028 + 1;
	}
	else{
		Allo2028 = YearDiff2028;
	}
	
	if (MonthDiff2030 == 12) {
		Allo2030 = YearDiff2030 + 1;
	}
	else{
		Allo2030 = YearDiff2030;
	}
	
	if (MonthDiff2035 == 12) {
		Allo2035 = YearDiff2035 + 1;
	}
	else{
		Allo2035 = YearDiff2035;
	}
	 
	
	NSDate* aa = [df dateFromString:getPlanCommDate];
	NSDateComponents* components2 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
												fromDate:aa];
	CommMonth = [components2 month];
}

-(double)ReturnModeRate: (NSString *)MOP{
	if ([MOP isEqualToString:@"A"]) {
		return 0.85;
	}
	else if ([MOP isEqualToString:@"S"]){
		return 0.9;
	}
	else if ([MOP isEqualToString:@"Q"]){
		return 0.9;
	}
	else{
		return 0.95;
	}
}

-(double)ReturnExcessPrem: (int)aaPolicyYear{
	if ([txtRTUP.text isEqualToString:@""]) {
		return 0;
	}
	else {
		if (aaPolicyYear >= [txtCommFrom.text intValue ] && aaPolicyYear <= [txtCommFrom.text intValue] + [txtFor.text intValue] ) {
			return [txtRTUP.text doubleValue ];
		}
		else{
			return 0;
		}
	}
}

-(double)ReturnDivideMode{
	if ([[self ReturnBumpMode] isEqualToString:@"A"]) {
		return 1.00;
	}
	else if ([[self ReturnBumpMode] isEqualToString:@"S"]) {
		return 2.00;
	}
	else if ([[self ReturnBumpMode] isEqualToString:@"Q"]) {
		return 4.00;
	}
	else{
		return 12.00;
	}
}

-(double)ReturnPremAllocation: (int)aaPolYear{
	if (aaPolYear == 1) {
		if ([txtBasicPremium.text doubleValue ] >= 12000 && [txtBasicPremium.text doubleValue ] < 24000 ) {
			return 0.4 + 0.02;
		}
		else if ([txtBasicPremium.text doubleValue ] >= 24000){
			return 0.4 + 0.04;
		}
		else{
			return 0.4;
		}
	}
	else if (aaPolYear == 2){
		if ([txtBasicPremium.text doubleValue ] >= 12000 && [txtBasicPremium.text doubleValue ] < 24000 ) {
			return 0.52 + 0.02;
		}
		else if ([txtBasicPremium.text doubleValue ] >= 24000){
			return 0.52 + 0.04;
		}
		else{
			return 0.52;
		}
		
	}
	else if (aaPolYear == 3){
		return 0.785;
	}
	else if (aaPolYear == 4){
		return 0.835;
	}
	else if (aaPolYear >=5 && aaPolYear < 7){
		return 0.925;
	}
	else{
		return 1.00;
	}
}

-(double)ReturnBasicMort: (int)zzAge{
	NSString *MortRate;
	sqlite3_stmt *statement;
	NSString *querySQL;
	
	querySQL = [NSString stringWithFormat:@"Select Rate From ES_Sys_Basic_Mort WHERE PlanCode = '%@' AND Sex = '%@' AND Age='%d' AND Smoker ='%@' "
				 , getPlanCode, getSexLA, zzAge, getSmokerLA];
	
	//NSLog(@"%@", querySQL);
	if (sqlite3_open([UL_databasePath UTF8String], &contactDB) == SQLITE_OK){
		if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW){
				MortRate = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
	
	return [MortRate doubleValue];
}

-(int)GetMortDate{
	
	
	if (![getPlanCommDate isEqualToString:@""] && ![getDOB isEqualToString:@""]  ) {
		
		NSDateFormatter* df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"dd/MM/yyyy"];
     	NSDate* d = [df dateFromString:getDOB];
		NSDate* d2 = [df dateFromString:getPlanCommDate];
		
		NSCalendar* calendar = [NSCalendar currentCalendar];
		NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
												   fromDate:d];
		NSDateComponents* components2 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
												   fromDate:d2];
		
		if ([components month] == [components2 month] && [components day] == [components2 day]) {
			return 12;
		}
		else{
			return 12 - ([self monthsBetweenDate:d andDate:d2])%12;
		}
	}
	else{
		return -1;
	}
}

- (NSUInteger)monthsBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
	
    NSCalendar *calendar = [NSCalendar currentCalendar];
	
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
				 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
				 interval:NULL forDate:toDateTime];
	
    NSDateComponents *difference = [calendar components:NSMonthCalendarUnit
											   fromDate:fromDate toDate:toDate options:0];

    return [difference month];
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
	
    NSCalendar *calendar = [NSCalendar currentCalendar];
	
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
				 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
				 interval:NULL forDate:toDateTime];
	
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
											   fromDate:fromDate toDate:toDate options:0];
	
    return [difference day];
}

-(void)InsertIntoTPExcess{
	sqlite3_stmt *statement;
	NSString *insertSQL;
	
	insertSQL = [NSString stringWithFormat:@"INSERT INTO UL_TPExcess (SINO, FromYear, YearInt, Amount, ForYear) VALUES ('%@', '%d','%@','%@','%d') "
				 , getSINo, 1 + [txtCommFrom.text intValue], @"1", txtRTUP.text,  [txtFor.text intValue ] - 1];
	
	//NSLog(@"%@", insertSQL);
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_DONE){
				
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
	
}

-(void)UpdateTPExcess{
	sqlite3_stmt *statement;
	NSString *insertSQL;
	
	insertSQL = [NSString stringWithFormat:@"UPDATE UL_TPExcess set FromYear= '%d', YearInt='%@', Amount='%@', ForYear='%d' WHERE SINO = '%@' "
				 , 1 + [txtCommFrom.text intValue], @"1", txtRTUP.text, [txtFor.text intValue ] - 1, getSINo];
	
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_DONE){
				
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
	
}

-(void)DeleteTPExcess{
	sqlite3_stmt *statement;
	NSString *insertSQL;
	
	insertSQL = [NSString stringWithFormat:@"DELETE FROM UL_TPExcess WHERE SINO = '%@' ", getSINo];
	
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_DONE){
				
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
	
}


-(void)updateLA
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Clt_Profile SET CustCode=\"%@\", DateModified=\"%@\", ModifiedBy=\"hla\" "
							  "WHERE id=\"%d\"",LACustCode,currentdate,idProf];
        
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE){
                //save
            }
            else {
                //failed
            }
            sqlite3_finalize(statement);
        }
        
        NSString *querySQL2 = [NSString stringWithFormat:
							   @"UPDATE UL_LAPayor SET SINo=\"%@\", CustCode=\"%@\", DateModified=\"%@\", "
							   "ModifiedBy=\"hla\" WHERE rowid=\"%d\"",SINo,LACustCode,currentdate,idPay];
        
		//        NSLog(@"%@",querySQL2);
        if (sqlite3_prepare_v2(contactDB, [querySQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE){
                //save
            }
            else {
                //failed
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
}

-(void)savePayor
{
    [self getRunningCustCode];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoCust = CustLastNo + 1;
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
		
    PYCustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO UL_LAPayor (SINo, CustCode,PTypeCode,Seq,DateCreated,CreatedBy) VALUES "
							   "(\"%@\",\"%@\",\"PY\",\"1\",\"%@\",\"hla\")",SINo, PYCustCode,dateStr];
        
		//        NSLog(@"%@",insertSQL);
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA");
            } else {
                NSLog(@"Failed LA");
            }
            sqlite3_finalize(statement);
        }
        
        int ANB =PayorAge + 1;
        NSString *insertSQL2 = [NSString stringWithFormat:
                                @"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, "
								"CreatedBy,indexNo) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"hla\", \"%d\")",
								PYCustCode, NamePP, PayorSmoker, PayorSex, PayorDOB, PayorAge, ANB, PayorOccpCode, dateStr,PayorIndexNo];
		
		//        NSLog(@"%@",insertSQL2);
        if(sqlite3_prepare_v2(contactDB, [insertSQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA2");
                
            } else {
                NSLog(@"Failed LA2");
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)saveSecondLA
{
    [self getRunningCustCode];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoCust = CustLastNo + 1;
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
	
    secondLACustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO UL_LAPayor (SINo, CustCode,PTypeCode,Seq,DateCreated,CreatedBy) VALUES "
							   "(\"%@\",\"%@\",\"LA\",\"2\",\"%@\",\"hla\")",SINo, secondLACustCode,dateStr];
        
		//        NSLog(@"%@",insertSQL);
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA");
            } else {
                NSLog(@"Failed LA");
            }
            sqlite3_finalize(statement);
        }
        
        int ANB = secondLAAge + 1;
        NSString *insertSQL2 = [NSString stringWithFormat:
								@"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, CreatedBy,indexNo) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"hla\", \"%d\")", secondLACustCode, NamePP, secondLASmoker, secondLASex, secondLADOB, secondLAAge, ANB, secondLAOccpCode, dateStr,secondLAIndexNo];
        
		//        NSLog(@"%@",insertSQL2);
        if(sqlite3_prepare_v2(contactDB, [insertSQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA2");
                
            } else {
                NSLog(@"Failed LA2");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


-(NSString *)ReturnBumpMode{
	
	NSString *result;
	
	if (segPremium.selectedSegmentIndex == 0) {
		result = @"A";
	}
	else if (segPremium.selectedSegmentIndex == 1){
		result = @"S";
	}
	else if (segPremium.selectedSegmentIndex == 2){
		result = @"Q";
	}
	else if (segPremium.selectedSegmentIndex == 3){
		result = @"M";
	}
	
	return result;
}

-(void)getRunningSI
{
    sqlite3_stmt *statement;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"UL\" AND LastUpdated "
							  "like \"%%%@%%\"", dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                SILastNo = sqlite3_column_int(statement, 0);
                
                const char *lastDate = (const char *)sqlite3_column_text(statement, 1);
                SIDate = lastDate == NULL ? nil : [[NSString alloc] initWithUTF8String:lastDate];
                
                NSLog(@"LastSINo:%d SIDate:%@",SILastNo,SIDate);
                
            } else {
                SILastNo = 0;
                SIDate = dateString;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    [self updateFirstRunSI];
}

-(void)getRunningCustCode
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"CL\" AND "
							  "LastUpdated like \"%%%@%%\" ",dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CustLastNo = sqlite3_column_int(statement, 0);
                
                const char *lastDate = (const char *)sqlite3_column_text(statement, 1);
                CustDate = lastDate == NULL ? nil : [[NSString alloc] initWithUTF8String:lastDate];
                
                NSLog(@"LastCustNo:%d CustDate:%@",CustLastNo,CustDate);
                
            } else {
                CustLastNo = 0;
                CustDate = dateString;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    [self updateFirstRunCust];
}


-(void)updateFirstRunSI
{
    int newLastNo;
    newLastNo = SILastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated=\"%@\" WHERE TrnTypeCode=\"UL\"",
							  newLastNo, dateString];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Run SI update!");
                
            } else {
                NSLog(@"Run SI update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateFirstRunCust
{
    int newLastNo;
    newLastNo = CustLastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"CL\"",
							  newLastNo,dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Run Cust update!");
                
            } else {
                NSLog(@"Run Cust update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)CalcTotalRiderPrem{
	
	sqlite3_stmt *statement;
	NSString *querySQL;
	//double half = 0.5, quarter = 0.25, month = 0.0833333;
	
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
	{
		querySQL = [NSString stringWithFormat:
					@"SELECT sum(round(premium, 2)) from ul_rider_details where sino = '%@' ",  getSINo];
		
		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			if (sqlite3_step(statement) == SQLITE_ROW)
			{
				//txtRiderPremium.text =  [ NSString stringWithFormat:@"%.2f", sqlite3_column_double(statement, 0) ] ;
				TotalRiderPremium =  sqlite3_column_double(statement, 0);
			}
			sqlite3_finalize(statement);
		}
		
		sqlite3_close(contactDB);
	}
	
}


#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
	[self setMyScrollView:nil];
	[self setOutletBasic:nil];
	[self setTxtPolicyTerm:nil];
	[self setSegPremium:nil];
	[self setTxtBasicPremium:nil];
	[self setTxtBasicSA:nil];
	[self setTxtGrayRTUP:nil];
	[self setTxtRTUP:nil];
	[self setTxtCommFrom:nil];
	[self setTxtFor:nil];
	[self setTxtBUMP:nil];
	[self setTxtTotalBAPremium:nil];
	[self setTxtPremiumPayable:nil];
	[self setLabel1:nil];
	[self setLabel2:nil];
	[self setLabelComm:nil];
	[self setLabelFor:nil];
	[super viewDidUnload];
}

#pragma mark - handle data
-(void)checkingExisting
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SINo FROM UL_Details WHERE SINo=\"%@\"",SINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                getSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            } else {
                NSLog(@"error access Trad_Details");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    if (getSINo.length != 0) {
        useExist = YES;
    } else {
        useExist = NO;
    }
}


#pragma mark - button

- (IBAction)ACtionBasic:(id)sender {
	[self resignFirstResponder];
    
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
	
    if (_planList == nil) {
        self.planList = [[PlanList alloc] init];
        _planList.delegate = self;
		self.planList.TradOrEver = @"EVER";
        self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_planList];
    }

	[self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
    [self.planPopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
}
- (IBAction)ActionDone:(id)sender {
	[self resignFirstResponder];
    [self.view endEditing:YES];
	
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
	
	
	AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
	if (![zzz.EverMessage isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:zzz.EverMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		alert.tag = 1007;
        [alert show];
		zzz.EverMessage = @"";
	}
	else{
		[self Validation];
		//[self CheckBump];
	}
}

-(void)CheckBump{
	
}

-(void)Validation{
	
	NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSCharacterSet *setTerm = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    //NSRange rangeofDotSA = [txtBasicSA.text rangeOfString:@"."];
	
	if (OccpCode.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Life Assured is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1001];
        [alert show];
    }
	else if (ageClient > 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Age Last Birthday must be less than or equal to 100 for this product."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if ([txtBasicPremium.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:@"Invalid input format. Basic Premium must be numeric 0 to 9 or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
		txtBasicPremium.text = @"";
        [txtBasicPremium becomeFirstResponder];
    }
	else if ([txtBasicSA.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:@"Invalid input format. Basic Sum Assured must be numeric 0 to 9 only" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
		txtBasicSA.text = @"";
        [txtBasicSA becomeFirstResponder];
    }
	else if ([txtBasicSA.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Basic Sum Assured is required"] delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
		[txtBasicSA becomeFirstResponder];
    }
    else if ([txtBasicPremium.text doubleValue] < minPremium) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Basic Annual Premium must be at least %.0f",minPremium] delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtBasicPremium becomeFirstResponder];
    }
    else if ([txtBasicSA.text intValue] < minSA) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Basic Sum Assured must be greater or equal to %.0f", minSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		alert.tag = 1004;
		[alert show];
		[txtBasicSA becomeFirstResponder];
		//txtBasicSA.text = [NSString stringWithFormat:@"%.0f", minSA];
        
    }
	else if ([[txtRTUP.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] &&
			 ![[txtCommFrom.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Regular Top Up Premium is required"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[txtRTUP becomeFirstResponder ];
	}
	else if ([[txtRTUP.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"0"] &&
			 ![[txtCommFrom.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Regular Top Up Premium is required"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[txtRTUP becomeFirstResponder ];
	}
	else if ([[txtRTUP.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] &&
			 ![[txtFor.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Regular Top Up Premium is required"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[txtFor becomeFirstResponder ];
	}
	else if ([[txtRTUP.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"0"] &&
			 ![[txtFor.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Regular Top Up Premium is required"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[txtFor becomeFirstResponder ];
	}
	else if (![[txtRTUP.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] &&
			 [[txtCommFrom.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"0"]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Regular Top Up Premium Commnencement Year is required"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[txtCommFrom becomeFirstResponder ];
	}
	else if (![[txtRTUP.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] &&
			 [[txtFor.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"0"] ){
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"The number of year for Regular Top Up Premium is required"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[txtFor becomeFirstResponder ];
	}
	
	else if (![[txtRTUP.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] &&
			 [[txtCommFrom.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Regular Top Up Premium Commnencement Year is required"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[txtCommFrom becomeFirstResponder ];
	}
	else if (![[txtRTUP.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] &&
			 [[txtFor.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] ){
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"The number of year for Regular Top Up Premium is required"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[txtFor becomeFirstResponder ];
	}
	else if ([txtCommFrom.text intValue ] > 100 - ageClient - 1){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Regular Top Up must commence before %dth policy anniversary.", 100-ageClient-1] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[txtCommFrom becomeFirstResponder ];
	}
	else if ([txtFor.text intValue ] > [txtPolicyTerm.text intValue] - [txtCommFrom.text intValue ]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Regular Top Up years must be less than or equal to %d year(s).", [txtPolicyTerm.text intValue] - [txtCommFrom.text intValue ]]
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[txtFor becomeFirstResponder ];
	}
	else if ([txtBUMP.text doubleValue ] < 0) {
		if (PremReq < 2 * [txtBasicPremium.text doubleValue ]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
															message:[NSString stringWithFormat:@"Please increase basic premium to %.2f", PremReq]
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[txtBasicPremium becomeFirstResponder ];
		}
		else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
															message:[NSString stringWithFormat:@"Please reduce Basic Sum Assured"]
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[txtBasicSA becomeFirstResponder ];
		}
	}
	/*
	 else if (rangeofDotSA.location != NSNotFound) {
	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
	 message:[NSString stringWithFormat:@"Decimal place is not allow for Basic Sum Assured"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	 [alert show];
	 [txtBasicSA becomeFirstResponder];
	 }*/
	else {
		NSString *msg;
		[self checkingExisting];
		if (useExist) {
			msg = @"Confirm changes?";
		} else {
			msg = @"Confirm creating new record?";
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
		[alert setTag:1003];
		[alert show];
	}

}

- (IBAction)ActionPremium:(id)sender {
	
	double tempBasicPrem = [txtBasicPremium.text doubleValue ];
	//double tempBasicSA = [txtBasicSA.text doubleValue ];
	double tempPremiumPayable = [txtPremiumPayable.text doubleValue ];
	
	if ([txtBasicPremium isFirstResponder ]) {
		[self DisplayPremiumCondtion];
	}
	
	if (segPremium.selectedSegmentIndex == 0) {
		if (![txtBasicPremium.text isEqualToString:@""]) {
			
			if ([getBumpMode isEqualToString:@"S"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem /Semi   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA /Semi   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable /Semi   ];
				
			}
			else if ([getBumpMode isEqualToString:@"Q"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem /quarterly   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA /quarterly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable /quarterly   ];
			}
			else if ([getBumpMode isEqualToString:@"M"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem/Monthly   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA/Monthly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable/Monthly   ];
			}
			
		}
		getBumpMode	= @"A";
	}
	else if (segPremium.selectedSegmentIndex == 1) {
		if (![txtBasicPremium.text isEqualToString:@""]) {
			if ([getBumpMode isEqualToString:@"A"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem * Semi   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA * Semi   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable * Semi   ];
			}
			else if ([getBumpMode isEqualToString:@"Q"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem/quarterly) * Semi   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA/quarterly) * Semi   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable/quarterly) * Semi   ];
			}
			else if ([getBumpMode isEqualToString:@"M"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem /Monthly) * Semi   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA /Monthly) * Semi   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable /Monthly) * Semi   ];
			}
			
		}
		getBumpMode = @"S";
		
	}
	else if (segPremium.selectedSegmentIndex == 2) {
		if (![txtBasicPremium.text isEqualToString:@""]) {
			if ([getBumpMode isEqualToString:@"A"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem * quarterly   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA * quarterly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable * quarterly   ];
			}
			else if ([getBumpMode isEqualToString:@"S"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem/Semi) * quarterly   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA/Semi) * quarterly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable/Semi) * quarterly   ];
				
			}
			else if ([getBumpMode isEqualToString:@"M"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem /Monthly) * quarterly   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA /Monthly) * quarterly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable /Monthly) * quarterly   ];
			}
			
		}
		getBumpMode = @"Q";
		
	}
	else if (segPremium.selectedSegmentIndex == 3) {
		if (![txtBasicPremium.text isEqualToString:@""]) {
			if ([getBumpMode isEqualToString:@"A"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem * Monthly   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA * Monthly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable * Monthly   ];
			}
			else if ([getBumpMode isEqualToString:@"S"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem /Semi) * Monthly   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA /Semi) * Monthly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable /Semi) * Monthly   ];
				
			}
			else if ([getBumpMode isEqualToString:@"Q"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem /quarterly) * Monthly   ];
				//txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA /quarterly) * Monthly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable /quarterly) * Monthly   ];
			}
			
		}
		getBumpMode = @"M";
		
	}

	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
	[formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
	
	txtTotalBAPremium.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[txtBasicPremium.text doubleValue]]];
	//txtTotalBAPremium.text = [NSString stringWithFormat:@"%.2f", [txtBasicPremium.text doubleValue ]];
	txtBUMP.text = [NSString stringWithFormat:@"%.2f", [self CalculateBUMP]];
	txtBUMP.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[txtBUMP.text doubleValue]]];
}
@end
