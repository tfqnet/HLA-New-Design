//
//  EverLifeViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 8/15/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "EverLifeViewController.h"
#import "DBController.h"
#import "DataTable.h"

@interface EverLifeViewController ()

@end

const double PolicyFee = 5, IncreasePrem =0, CYFactor = 1, ExcessAllo = 0.95, RegularAllo =0.95;
int YearDiff2023, YearDiff2025, YearDiff2028, YearDiff2030, YearDiff2035, CommMonth;
int MonthDiff2023, MonthDiff2025, MonthDiff2028, MonthDiff2030, MonthDiff2035;
int FundTermPrev2023, FundTerm2023, FundTermPrev2025, FundTerm2025,FundTermPrev2028, FundTerm2028;
int FundTermPrev2030, FundTerm2030, FundTermPrev2035, FundTerm2035;
int VU2023Factor,VU2025Factor,VU2028Factor,VU2030Factor,VU2035Factor,VUCashFactor,VURetFactor,VURetOptFactor,VUCashOptFactor;
int RegWithdrawalStartYear, RegWithdrawalEndYear, RegWithdrawalIntYear;
double PremReq;
double VU2023Fac,VU2025Fac,VU2028Fac,VU2030Fac,VU2035Fac,VUCashFac,VURetFac,VURetOptFac,VUCashOptFac;
double VUCash_FundAllo_Percen,VURet_FundAllo_Percen,VU2023_FundAllo_Percen,VU2025_FundAllo_Percen;
double VU2028_FundAllo_Percen,VU2030_FundAllo_Percen, VU2035_FundAllo_Percen, RegWithdrawalAmount;
double VU2023InstHigh, VU2023InstMedian, VU2023InstLow,VU2025InstHigh, VU2025InstMedian, VU2025InstLow;
double VU2028InstHigh, VU2028InstMedian, VU2028InstLow,VU2030InstHigh, VU2030InstMedian, VU2030InstLow;
double VU2035InstHigh, VU2035InstMedian, VU2035InstLow, NegativeValueOfMaxCashFundHigh,NegativeValueOfMaxCashFundMedian,NegativeValueOfMaxCashFundLow ;
double HSurrenderValue,MSurrenderValue,LSurrenderValue,HRiderSurrenderValue,MRiderSurrenderValue,LRiderSurrenderValue;
double VUCashValueHigh, VU2023ValueHigh,VU2025ValueHigh,VU2028ValueHigh,VU2030ValueHigh,VU2035ValueHigh,VURetValueHigh;
double VU2023PrevValuehigh, VU2025PrevValuehigh,VU2028PrevValuehigh, VU2030PrevValuehigh, VU2035PrevValuehigh,VUCashPrevValueHigh,VURetPrevValueHigh;
double MonthVU2023PrevValuehigh, MonthVU2025PrevValuehigh,MonthVU2028PrevValuehigh, MonthVU2030PrevValuehigh, MonthVU2035PrevValuehigh,MonthVUCashPrevValueHigh, MonthVURetPrevValueHigh;
double VUCashValueMedian, VU2023ValueMedian,VU2025ValueMedian,VU2028ValueMedian,VU2030ValueMedian,VU2035ValueMedian,VURetValueMedian;
double VUCashValueLow, VU2023ValueLow,VU2025ValueLow,VU2028ValueLow,VU2030ValueLow,VU2035ValueLow,VURetValueLow;
double VU2023PrevValueMedian, VU2025PrevValueMedian,VU2028PrevValueMedian, VU2030PrevValueMedian, VU2035PrevValueMedian,VUCashPrevValueMedian,VURetPrevValueMedian;
double VU2023PrevValueLow, VU2025PrevValueLow,VU2028PrevValueLow, VU2030PrevValueLow, VU2035PrevValueLow,VUCashPrevValueLow,VURetPrevValueLow;
double MonthVU2023PrevValueMedian, MonthVU2025PrevValueMedian,MonthVU2028PrevValueMedian, MonthVU2030PrevValueMedian;
double  MonthVU2035PrevValueMedian,MonthVUCashPrevValueMedian,MonthVURetPrevValueMedian;
double MonthVU2023PrevValueLow, MonthVU2025PrevValueLow,MonthVU2028PrevValueLow, MonthVU2030PrevValueLow;
double  MonthVU2035PrevValueLow,MonthVUCashPrevValueLow,MonthVURetPrevValueLow;
double Allo2023, Allo2025,Allo2028,Allo2030,Allo2035;
double Fund2023PartialReinvest, Fund2025PartialReinvest,Fund2028PartialReinvest,Fund2030PartialReinvest,Fund2035PartialReinvest;
double MonthFundMaturityValue2023_Bull, MonthFundMaturityValue2023_Flat,MonthFundMaturityValue2023_Bear;
double MonthFundMaturityValue2025_Bull, MonthFundMaturityValue2025_Flat,MonthFundMaturityValue2025_Bear;
double MonthFundMaturityValue2028_Bull, MonthFundMaturityValue2028_Flat,MonthFundMaturityValue2028_Bear;
double MonthFundMaturityValue2030_Bull, MonthFundMaturityValue2030_Flat,MonthFundMaturityValue2030_Bear;
double MonthFundMaturityValue2035_Bull, MonthFundMaturityValue2035_Flat,MonthFundMaturityValue2035_Bear;
double Fund2023ReinvestTo2025Fac,Fund2023ReinvestTo2028Fac,Fund2023ReinvestTo2030Fac,Fund2023ReinvestTo2035Fac,Fund2023ReinvestToCashFac,Fund2023ReinvestToRetFac ;
double Fund2025ReinvestTo2028Fac,Fund2025ReinvestTo2030Fac,Fund2025ReinvestTo2035Fac,Fund2025ReinvestToCashFac,Fund2025ReinvestToRetFac ;
double Fund2028ReinvestTo2030Fac,Fund2028ReinvestTo2035Fac,Fund2028ReinvestToCashFac,Fund2028ReinvestToRetFac;
double Fund2030ReinvestTo2035Fac,Fund2030ReinvestToCashFac,Fund2030ReinvestToRetFac;
double Fund2035ReinvestToCashFac,Fund2035ReinvestToRetFac;
double temp2023High, temp2023Median,temp2023Low,temp2025High, temp2025Median,temp2025Low,temp2028High, temp2028Median,temp2028Low;
double temp2030High, temp2030Median,temp2030Low, temp2035High, temp2035Median,temp2035Low;;
double FundValueOfTheYearValueTotalHigh,FundValueOfTheYearValueTotalMedian, FundValueOfTheYearValueTotalLow;
double MonthFundValueOfTheYearValueTotalHigh,MonthFundValueOfTheYearValueTotalMedian, MonthFundValueOfTheYearValueTotalLow;
double MonthVU2023ValueHigh,MonthVU2023ValueMedian,MonthVU2023ValueLow,MonthVU2025ValueHigh,MonthVU2025ValueMedian,MonthVU2025ValueLow;
double MonthVU2028ValueHigh,MonthVU2028ValueMedian,MonthVU2028ValueLow,MonthVU2030ValueHigh,MonthVU2030ValueMedian,MonthVU2030ValueLow;
double MonthVU2035ValueHigh,MonthVU2035ValueMedian,MonthVU2035ValueLow,MonthVURetValueHigh,MonthVURetValueMedian,MonthVURetValueLow;
BOOL VUCashValueNegative,RiderVUCashValueNegative, CIRDExist;

double RiderVUCashValueHigh, RiderVU2023ValueHigh,RiderVU2025ValueHigh,RiderVU2028ValueHigh,RiderVU2030ValueHigh,RiderVU2035ValueHigh,RiderVURetValueHigh;
double RiderVU2023PrevValuehigh, RiderVU2025PrevValuehigh,RiderVU2028PrevValuehigh, RiderVU2030PrevValuehigh, RiderVU2035PrevValuehigh,RiderVUCashPrevValueHigh,RiderVURetPrevValueHigh;
double RiderMonthVU2023PrevValuehigh, RiderMonthVU2025PrevValuehigh,RiderMonthVU2028PrevValuehigh, RiderMonthVU2030PrevValuehigh, RiderMonthVU2035PrevValuehigh,RiderMonthVUCashPrevValueHigh, RiderMonthVURetPrevValueHigh;
double RiderVUCashValueMedian, RiderVU2023ValueMedian,RiderVU2025ValueMedian,RiderVU2028ValueMedian,RiderVU2030ValueMedian,RiderVU2035ValueMedian,RiderVURetValueMedian;
double RiderVUCashValueLow, RiderVU2023ValueLow,RiderVU2025ValueLow,RiderVU2028ValueLow,RiderVU2030ValueLow,RiderVU2035ValueLow,RiderVURetValueLow;
double RiderVU2023PrevValueMedian, RiderVU2025PrevValueMedian,RiderVU2028PrevValueMedian, RiderVU2030PrevValueMedian, RiderVU2035PrevValueMedian,RiderVUCashPrevValueMedian,RiderVURetPrevValueMedian;
double RiderVU2023PrevValueLow, RiderVU2025PrevValueLow,RiderVU2028PrevValueLow, RiderVU2030PrevValueLow, RiderVU2035PrevValueLow,RiderVUCashPrevValueLow,RiderVURetPrevValueLow;
double RiderMonthVU2023PrevValueMedian, RiderMonthVU2025PrevValueMedian,RiderMonthVU2028PrevValueMedian, RiderMonthVU2030PrevValueMedian;
double  RiderMonthVU2035PrevValueMedian,RiderMonthVUCashPrevValueMedian,RiderMonthVURetPrevValueMedian;
double RiderMonthVU2023PrevValueLow, RiderMonthVU2025PrevValueLow,RiderMonthVU2028PrevValueLow, RiderMonthVU2030PrevValueLow;
double  RiderMonthVU2035PrevValueLow,RiderMonthVUCashPrevValueLow,RiderMonthVURetPrevValueLow;
double RiderFundValueOfTheYearValueTotalHigh,RiderFundValueOfTheYearValueTotalMedian, RiderFundValueOfTheYearValueTotalLow;
double RiderMonthFundValueOfTheYearValueTotalHigh,RiderMonthFundValueOfTheYearValueTotalMedian, RiderMonthFundValueOfTheYearValueTotalLow;
double RiderMonthVU2023ValueHigh,RiderMonthVU2023ValueMedian,RiderMonthVU2023ValueLow,RiderMonthVU2025ValueHigh,RiderMonthVU2025ValueMedian,RiderMonthVU2025ValueLow;
double RiderMonthVU2028ValueHigh,RiderMonthVU2028ValueMedian,RiderMonthVU2028ValueLow,RiderMonthVU2030ValueHigh,RiderMonthVU2030ValueMedian,RiderMonthVU2030ValueLow;
double RiderMonthVU2035ValueHigh,RiderMonthVU2035ValueMedian,RiderMonthVU2035ValueLow,RiderMonthVURetValueHigh,RiderMonthVURetValueMedian,RiderMonthVURetValueLow;
double RiderNegativeValueOfMaxCashFundHigh,RiderNegativeValueOfMaxCashFundMedian,RiderNegativeValueOfMaxCashFundLow ;
double Ridertemp2023High, Ridertemp2023Median,Ridertemp2023Low,Ridertemp2025High, Ridertemp2025Median,Ridertemp2025Low,Ridertemp2028High, Ridertemp2028Median,Ridertemp2028Low;
double Ridertemp2030High, Ridertemp2030Median,Ridertemp2030Low, Ridertemp2035High, Ridertemp2035Median,Ridertemp2035Low;;



NSString *getHL, *getHLPct, *getOccLoading, *strBumpMode, *strBasicPremium, *strBasicSA, *strRTUPFrom, *strRTUPFor,*strRTUPAmount;
NSString *strRRTUOPrem,*strRRTUOFrom,*strRRTUOFor, *PYSex, *SecSex;
int PYAge, SecAge;


@implementation EverLifeViewController
@synthesize CustCode,SINo,Age,sex,Name, BasicSA, requestOccLoading, getPlanCommDate, requestPlanCommDate, requestDOB, getDOB;
@synthesize getSexLA,requestSexLA, getSmokerLA, requestSmokerLA, SimpleOrDetail, getOccpClass, requestOccpClass;
@synthesize OtherRiderCode,OtherRiderDeductible,OtherRiderDesc,OtherRiderHL,OtherRiderHLP,OtherRiderHLPTerm,OtherRiderHLTerm;
@synthesize OtherRiderPlanOption,OtherRiderSA,OtherRiderTerm,OtherRiderPaymentTerm, OtherRiderPremium;
@synthesize UnitizeRiderCode,UnitizeRiderDeductible,UnitizeRiderHL,UnitizeRiderHLPct;
@synthesize UnitizeRiderPlanChoice,UnitizeRiderSA,UnitizeRiderTerm, UnitizeRiderPremium,UniTotalRiderPremAtPolYear;
@synthesize UniTotalRiderPremWithAlloc;

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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    UL_RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"UL_Rates.sqlite"]];
	     
	
	if ([SimpleOrDetail isEqualToString:@"Detail"]) {
		
		getSmokerLA = [self.requestSmokerLA description];
		getOccLoading = [self.requestOccLoading description];
		getPlanCommDate = [self.requestPlanCommDate description];
		getDOB = [self.requestDOB description];
		getSexLA = [self.requestSexLA description];
		getOccpClass = self.requestOccpClass;
		
		OtherRiderCode = [[NSMutableArray alloc] init];
		OtherRiderDeductible= [[NSMutableArray alloc] init];
		OtherRiderDesc= [[NSMutableArray alloc] init];
		OtherRiderHL= [[NSMutableArray alloc] init];
		OtherRiderHLP= [[NSMutableArray alloc] init];
		OtherRiderHLPTerm= [[NSMutableArray alloc] init];
		OtherRiderHLTerm= [[NSMutableArray alloc] init];
		OtherRiderPlanOption= [[NSMutableArray alloc] init];
		OtherRiderSA = [[NSMutableArray alloc] init];
		OtherRiderTerm= [[NSMutableArray alloc] init];
		OtherRiderPremium = [[NSMutableArray alloc] init];
		OtherRiderPaymentTerm= [[NSMutableArray alloc] init];
		
		UnitizeRiderCode = [[NSMutableArray alloc] init ];
		UnitizeRiderSA = [[NSMutableArray alloc] init ];
		UnitizeRiderHL= [[NSMutableArray alloc] init ];
		UnitizeRiderHLPct = [[NSMutableArray alloc] init ];
		UnitizeRiderTerm = [[NSMutableArray alloc] init ];
		//UnitizeRiderMort = [[NSMutableArray alloc] init ];
		UnitizeRiderPlanChoice = [[NSMutableArray alloc] init ];
		UnitizeRiderDeductible = [[NSMutableArray alloc] init ];
		//UnitizeRiderAlloc = [[NSMutableArray alloc] init ];
		UnitizeRiderPremium = [[NSMutableArray alloc] init ];
		UniTotalRiderPremAtPolYear = [[NSMutableArray alloc] init ];
		UniTotalRiderPremWithAlloc = [[NSMutableArray alloc] init ];
		
		[self deleteTemp];
		[self PopulateData];
		[self GetRTUPData];
		[self getAllPreDetails];
		[self InsertToUL_Temp_Trad_LA]; // for the front summary page
		[self InsertToUL_Temp_Trad_Basic]; // for the front summary page
		[self InsertToUL_Temp_Trad_Rider];
		[self InsertToUL_Temp_ECAR55];
		[self InsertToUL_Temp_ECAR1];
		[self InsertToUL_Temp_Summary];
		
		NSString *databaseName = @"hladb.sqlite";
		self.db = [DBController sharedDatabaseController:databaseName];
		NSString *sqlStmt;
		int DBID;
		int pageNum = 0;
		int riderCount = 0;
		NSString *desc = @"Page";
		
		sqlStmt = @"Delete from UL_Temp_Pages";
		DBID = [_db ExecuteINSERT:sqlStmt];
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page13.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page3.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page4.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page14.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page6.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		
		
		riderCount = 0; //reset rider count
		int descRiderCountStart = 35; //start of rider description page
		int riderInPageCount = 0; //number of rider in a page, maximum 3
		NSString *riderInPage = @""; //rider in a page, write to db
		//NSString *riderInPage1 = @"";
		NSString *curRider; //current rider
		NSString *prevRider; //previous rider
		NSString *headerTitle = @"tblHeader;";
		
		
		
		
		
		NSArray* row;
		
		sqlStmt = [NSString stringWithFormat:@"SELECT RiderCode FROM UL_Rider_Details Where SINo = '%@' ORDER BY RiderCode ASC ", SINo];
		//NSLog(@"%@",sqlStmt);
		_dataTable = [_db  ExecuteQuery:sqlStmt];
		
		for (row in _dataTable.rows)
		{
			riderCount++;
			curRider = [row objectAtIndex:0];
			
			//NSLog(@"%@",curRider);
			
			if ([curRider isEqualToString:@"CIRD"] || [curRider isEqualToString:@"DHI"] || [curRider isEqualToString:@"RRTUO"] ||
				[curRider isEqualToString:@"DCA"] || [curRider isEqualToString:@"ECAR"] || [curRider isEqualToString:@"ECAR55"] ||
				[curRider isEqualToString:@"HMM"] || [curRider isEqualToString:@"LSR"] ||
				[curRider isEqualToString:@"MG_IV"] || [curRider isEqualToString:@"MR"] || [curRider isEqualToString:@"PA"] ||
				[curRider isEqualToString:@"WI"] || [curRider isEqualToString:@"PR"] || [curRider isEqualToString:@"TPDMLA"] ||
				[curRider isEqualToString:@"TPDWP"]   ){
				riderInPageCount++;
				prevRider = curRider;
				
				if(riderCount == 1){
					riderInPage = [headerTitle stringByAppendingString:riderInPage];
				}
				
				riderInPage = [riderInPage stringByAppendingString:curRider];
				riderInPage = [riderInPage stringByAppendingString:@";"];
				if (riderInPageCount == 3){
					//NSLog(@"%@",riderInPage);
					pageNum++;
					//if(riderCount == 1)
					//  riderInPage = [headerTitle stringByAppendingString:riderInPage];
					//descRiderCountStart++;
					sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES ('%@','Page%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
					DBID = [_db ExecuteINSERT:sqlStmt];
					if (DBID <= 0){
						NSLog(@"Error inserting data into database.");
					}
					//NSLog(@"%@",sqlStmt);
					riderInPageCount = 0;
					riderInPage = @"";
					prevRider = @"";
				}
				
				if (riderInPageCount == 1 && riderCount == _dataTable.rows.count){
					//NSLog(@"%@",riderInPage);
					pageNum++;
					//descRiderCountStart++;
					sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES ('%@','Page%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
					DBID = [_db ExecuteINSERT:sqlStmt];
					if (DBID <= 0){
						NSLog(@"Error inserting data into database.");
					}
					//NSLog(@"%@",sqlStmt);
					riderInPageCount = 0;
					riderInPage = @"";
				}
				
				if (riderInPageCount == 2 && riderCount == _dataTable.rows.count) {
					pageNum++;
					//descRiderCountStart++;
					sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES ('%@','Page%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
					DBID = [_db ExecuteINSERT:sqlStmt];
					if (DBID <= 0){
						NSLog(@"Error inserting data into database.");
					}
					//NSLog(@"%@",sqlStmt);
					riderInPageCount = 0;
					riderInPage = @"";
				}
			}
			else{
				if (riderInPageCount == 2){
					//NSLog(@"%@",riderInPage);
					pageNum++;
					if(riderCount == 1)
						riderInPage = [headerTitle stringByAppendingString:riderInPage];
					//descRiderCountStart++;
					sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES ('%@','Page%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
					DBID = [_db ExecuteINSERT:sqlStmt];
					if (DBID <= 0){
						NSLog(@"Error inserting data into database.");
					}
					//NSLog(@"%@",sqlStmt);
					prevRider= @"";
					riderInPageCount = 0;
					riderInPage = @"";
				}
				if ([curRider isEqualToString:@"CIRD"] || [curRider isEqualToString:@"DHI"] || [curRider isEqualToString:@"RRTUO"] ||
					[curRider isEqualToString:@"DCA"] || [curRider isEqualToString:@"ECAR"] || [curRider isEqualToString:@"ECAR55"] ||
					[curRider isEqualToString:@"HMM"] || [curRider isEqualToString:@"LSR"] ||
					[curRider isEqualToString:@"MG_IV"] || [curRider isEqualToString:@"MR"] || [curRider isEqualToString:@"PA"] ||
					[curRider isEqualToString:@"WI"] || [curRider isEqualToString:@"PR"] || [curRider isEqualToString:@"TPDMLA"] ||
					[curRider isEqualToString:@"TPDWP"]  ){
					if (![curRider isEqualToString:@"CIWP"] && ![curRider isEqualToString:@"ACIR"] && ![curRider isEqualToString:@"LCWP"]
						&& ![prevRider isEqualToString:@""]) {
						prevRider = [prevRider stringByAppendingString:@";"];
						curRider = [prevRider stringByAppendingString:curRider];
						riderInPageCount = 0;
						riderInPage = @"";
						
					}
					else{
						pageNum++;
						
						if(riderCount == 1){
							riderInPage = [headerTitle stringByAppendingString:riderInPage];
						}
						
						sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES "
								   "('%@','Page%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
						DBID = [_db ExecuteINSERT:sqlStmt];
						if (DBID <= 0){
							NSLog(@"Error inserting data into database.");
						}
						prevRider = @"";
						riderInPage = @"";
						riderInPageCount = 0;
					}
					
				}
				//NSLog(@"%@",curRider);
				pageNum++;
				if(riderCount == 1)
					curRider = [headerTitle stringByAppendingString:curRider];
				//descRiderCountStart++;
				sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES ('%@','Page%d.html',%d,'%@')",curRider,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
				DBID = [_db ExecuteINSERT:sqlStmt];
				if (DBID <= 0){
					NSLog(@"Error inserting data into database.");
				}
				//NSLog(@"%@",sqlStmt);
			}
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page7.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}

		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page8.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page9.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page10.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		//EverCash 55
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page11.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		//EverCash 1
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page12.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page20.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		//Summary Page 1
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page30.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}

		pageNum++;
		//Summary Page 2
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page31.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}

		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page40.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page41.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page42.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page43.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page44.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page45.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page46.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page47.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
		
		pageNum++;
		sqlStmt = [NSString stringWithFormat:@"INSERT INTO UL_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page48.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
		DBID = [_db ExecuteINSERT:sqlStmt];
		if (DBID <= 0){
			NSLog(@"Error inserting data into database.");
		}
	}
	
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)deleteTemp{
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        
        QuerySQL = @"Delete from UL_temp_ECAR55";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
		
		QuerySQL = @"Delete from UL_temp_ECAR";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
		QuerySQL = @"Delete from UL_temp_Fund";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
		
		QuerySQL = @"Delete from UL_temp_Summary";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
		
        QuerySQL = @"Delete from UL_temp_Rider";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from UL_temp_Trad";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from UL_temp_Trad_Basic";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from UL_temp_Trad_details";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete  from UL_temp_Trad_Overall";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from UL_temp_Trad_Rider";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from UL_temp_Trad_Riderillus";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from UL_temp_Trad_Summary";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from UL_temp_trad_LA";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
    
    statement = Nil;
    QuerySQL = Nil;
    
}

-(void)InsertToUL_Temp_Trad_LA{
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    sqlite3_stmt *statement3;
    NSString *getCustomerCodeSQL;
    NSString *getFromCltProfileSQL;
    NSString *smoker;
    NSString *QuerySQL;
    
    NSLog(@"insert to UL Temp Trad LA --- start");
    
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		getCustomerCodeSQL = [ NSString stringWithFormat:@"select CustCode from UL_LaPayor where sino = \"%@\" AND seq = %d ", SINo, 1];
		
		if(sqlite3_prepare_v2(contactDB, [getCustomerCodeSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW) {
				CustCode  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
				
				getFromCltProfileSQL  = [NSString stringWithFormat:@"Select Name, Smoker, sex, ALB from clt_profile where custcode  = \"%@\"",  CustCode];
				
				if(sqlite3_prepare_v2(contactDB, [getFromCltProfileSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
					
					if (sqlite3_step(statement2) == SQLITE_ROW) {
						Name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
						smoker = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 1)];
						sex = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 2)];
						Age = sqlite3_column_int(statement2, 3);
						
						QuerySQL  = [ NSString stringWithFormat:@"Insert INTO UL_Temp_Trad_LA (\"SINo\", \"LADesc\", "
									 "\"PtypeCode\", \"Seq\", \"Name\", \"Age\", \"Sex\", \"Smoker\", \"LADescM\") "
									 " VALUES (\"%@\",\"1st Life Assured\",\"LA\",\"%d\",\"%@\",\"%d\", \"%@\", \"%@\", "
									 " \"Hayat yang Diinsuranskan\")", SINo, 1, Name, Age, sex, smoker ];
						
						if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement3, NULL) == SQLITE_OK) {
							if (sqlite3_step(statement3) == SQLITE_DONE) {
								//NSLog(@"done insert to temp_trad_LA");
							}
							sqlite3_finalize(statement3);
						}
						
						smoker = Nil;
					}
					sqlite3_finalize(statement2);
				}
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
    
    // check for 2nd life assured
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        getCustomerCodeSQL = [ NSString stringWithFormat:@"select CustCode from UL_LaPayor where sino = \"%@\" AND seq = %d ", SINo, 2];
        
        if(sqlite3_prepare_v2(contactDB, [getCustomerCodeSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                CustCode  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                getFromCltProfileSQL  = [NSString stringWithFormat:@"Select Name, Smoker, sex, ALB from clt_profile where custcode  = \"%@\"",  CustCode];
                
                if(sqlite3_prepare_v2(contactDB, [getFromCltProfileSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    
                    if (sqlite3_step(statement2) == SQLITE_ROW) {
                        NSString *SecName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
                        NSString *Secsmoker = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 1)];
						SecSex = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 2)];
						SecAge = sqlite3_column_int(statement2, 3);
                        
                        QuerySQL  = [ NSString stringWithFormat:@"Insert INTO UL_Temp_Trad_LA (\"SINo\", \"LADesc\", "
                                     "\"PtypeCode\", \"Seq\", \"Name\", \"Age\", \"Sex\", \"Smoker\", \"LADescM\") "
                                     " VALUES (\"%@\",\"2nd Life Assured\",\"LA\",\"%d\",\"%@\",\"%d\", \"%@\", \"%@\", "
                                     " \"Hayat yang Diinsuranskan ke-2\")", SINo, 2, SecName, SecAge, SecSex, Secsmoker ];
                        
                        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement3, NULL) == SQLITE_OK) {
                            if (sqlite3_step(statement3) == SQLITE_DONE) {
                                //NSLog(@"done insert to temp_trad_LA");
                            }
                            sqlite3_finalize(statement3);
                        }
                        
                        SecName = Nil;
                        Secsmoker = Nil;
                        SecSex = Nil;
                    }
                    sqlite3_finalize(statement2);
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    //check for payor
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        getCustomerCodeSQL = [ NSString stringWithFormat:@"select CustCode from UL_LaPayor where sino = \"%@\" AND PtypeCode = 'PY' ", SINo];
        
        if(sqlite3_prepare_v2(contactDB, [getCustomerCodeSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                CustCode  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                getFromCltProfileSQL  = [NSString stringWithFormat:@"Select Name, Smoker, sex, ALB from clt_profile where custcode  = \"%@\"",  CustCode];
                
                if(sqlite3_prepare_v2(contactDB, [getFromCltProfileSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    
                    if (sqlite3_step(statement2) == SQLITE_ROW) {
                        NSString *PYName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
                        NSString *PYsmoker = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 1)];
						PYSex = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 2)];
						PYAge = sqlite3_column_int(statement2, 3);
                        
                        QuerySQL  = [ NSString stringWithFormat:@"Insert INTO UL_Temp_Trad_LA (\"SINo\", \"LADesc\", "
                                     "\"PtypeCode\", \"Seq\", \"Name\", \"Age\", \"Sex\", \"Smoker\", \"LADescM\") "
                                     " VALUES (\"%@\",\"Policy Owner\",\"PY\",\"%d\",\"%@\",\"%d\", \"%@\", \"%@\", "
                                     " \"Pemunya Polisi\")", SINo, 1, PYName, PYAge, PYSex, PYsmoker ];
                        
                        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement3, NULL) == SQLITE_OK) {
                            if (sqlite3_step(statement3) == SQLITE_DONE) {
                                
                            }
                            sqlite3_finalize(statement3);
                        }
                        
                        PYName = Nil;
                        PYsmoker = Nil;
                        PYSex = Nil;
                    }
                    sqlite3_finalize(statement2);
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    NSLog(@"insert to UL_Temp_Trad_LA --- End");
    statement = Nil;
    statement2 = Nil;
    statement3 = Nil;
    getCustomerCodeSQL = Nil;
    getFromCltProfileSQL = Nil;
    smoker = Nil;
    QuerySQL = Nil;
    
}

-(void)InsertToUL_Temp_Trad_Basic{
    sqlite3_stmt *statement;
    NSString *QuerySQL;
	int inputAge;
	NSMutableArray *AnnualPremium = [[NSMutableArray alloc] init ];
    NSMutableArray *BasicSumAssured = [[NSMutableArray alloc] init ];
	NSMutableArray *CumulativePremium = [[NSMutableArray alloc] init ];
	NSMutableArray *AllocatedBasicPrem = [[NSMutableArray alloc] init ];
	NSMutableArray *AllocatedRiderPrem = [[NSMutableArray alloc] init ];
	NSMutableArray *UnAllocatedAllPrem = [[NSMutableArray alloc] init ];
	NSMutableArray *CumAlloBasicPrem = [[NSMutableArray alloc] init ];
	NSMutableArray *CumAlloRiderPrem = [[NSMutableArray alloc] init ];
	NSMutableArray *TotalCumPrem = [[NSMutableArray alloc] init ];
	NSMutableArray *BasicInsCharge = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderInsCharge = [[NSMutableArray alloc] init ];
	NSMutableArray *OtherCharge = [[NSMutableArray alloc] init ];
	NSMutableArray *DirectDistributionCost = [[NSMutableArray alloc] init ];
	NSMutableArray *BullSurrender = [[NSMutableArray alloc] init ];
	NSMutableArray *FlatSurrender = [[NSMutableArray alloc] init ];
	NSMutableArray *BearSurrender = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderBullSurrender = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderFlatSurrender = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderBearSurrender = [[NSMutableArray alloc] init ];
	NSMutableArray *TotalBullSurrender = [[NSMutableArray alloc] init ];
	NSMutableArray *TotalFlatSurrender = [[NSMutableArray alloc] init ];
	NSMutableArray *TotalBearSurrender = [[NSMutableArray alloc] init ];
	NSMutableArray *EOFTPDBull = [[NSMutableArray alloc] init ];
	NSMutableArray *EOFTPDFlat = [[NSMutableArray alloc] init ];
	NSMutableArray *EOFTPDBear = [[NSMutableArray alloc] init ];
	NSMutableArray *EOFOADBull = [[NSMutableArray alloc] init ];
	NSMutableArray *EOFOADFlat = [[NSMutableArray alloc] init ];
	NSMutableArray *EOFOADBear = [[NSMutableArray alloc] init ];
	NSMutableArray *FundChargeBull = [[NSMutableArray alloc] init ];
	NSMutableArray *FundChargeFlat = [[NSMutableArray alloc] init ];
	NSMutableArray *FundChargeBear = [[NSMutableArray alloc] init ];


	
	NSLog(@"------------basic start --------");
	
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		/*
		QuerySQL = [NSString stringWithFormat: @"Select BasicSA, ATPrem, replace(A.Hloading, '(null)', '0') as Hloading, replace(A.HLoadingPct, '(null)', '0') as HLoadingPct "
					", BumpMode, sum(b.premium) as TotalRiderPrem from UL_Details A, ul_rider_details B Where  "
					"A.sino = B.sino AND A.sino = '%@' AND ridercode in ('CIRD', 'DCA', 'ACIR', 'HMM', 'MG_IV', "
					"'WI', 'MR', 'TPDMLA', 'PA', 'DHI')", SINo];
		*/
		
		QuerySQL = [NSString stringWithFormat: @"Select BasicSA, ATPrem, replace(Hloading, '(null)', '0') as Hloading, replace(HLoadingPct, '(null)', '0') as HLoadingPct "
					", BumpMode from UL_Details Where  "
					" sino = '%@' ", SINo];
		
		//NSLog(@"%@", QuerySQL);
		if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {

				BasicSA = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] doubleValue ];

				strBasicSA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] ;

				strBasicPremium = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)] ;

				const char *temp = (const char*)sqlite3_column_text(statement, 2);
                getHL = temp == NULL ? nil : [[NSString alloc] initWithUTF8String:temp];

				const char *temp2 = (const char*)sqlite3_column_text(statement, 3);
				getHLPct = temp2 == NULL ? nil : [[NSString alloc] initWithUTF8String:temp2];

				strBumpMode	= [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)] ;
			
             }
            sqlite3_finalize(statement);
        }
		
		/*
		QuerySQL = [NSString stringWithFormat: @"Select sum(premium) as TotalRiderPrem from  ul_rider_details Where  "
					" sino = '%@' AND ridercode in ('CIRD', 'DCA', 'ACIR', 'HMM', 'MG_IV', "
					"'WI', 'MR', 'TPDMLA', 'PA', 'DHI')", SINo];
		if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
				
				const char *temp3 = (const char*)sqlite3_column_text(statement, 0);
				strUnitizeRiderPrem = temp3 == NULL ? nil : [[NSString alloc] initWithUTF8String:temp3];
				
			}
			else{
				strUnitizeRiderPrem = @"0.00";
			}
            sqlite3_finalize(statement);
        }
		 */
		
		
		sqlite3_close(contactDB);
	}
	
	if (sqlite3_open([UL_RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK){
		if (UnitizeRiderCode.count > 0) {
			for (int i = 1; i <= 30; i++) {
				double tempUniRiderPrem = 0.00;
				double tempValue = 0.00;
				double tempUniRiderAlloc = 0.00;
				
				for (int j = 0; j < [UnitizeRiderCode count]; j++) {
					if ([[UnitizeRiderTerm objectAtIndex:j ] integerValue ] >= i ) {
						tempUniRiderPrem = tempUniRiderPrem + [[UnitizeRiderPremium objectAtIndex:j] doubleValue ];
						
						QuerySQL = [NSString stringWithFormat: @"select Rate from ES_Sys_Rider_Allocation where Term = '%@' AND PolYear = '%d'",
									[UnitizeRiderTerm objectAtIndex:j], i];
						
						//NSLog(@"%@", QuerySQL);
						if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
							if (sqlite3_step(statement) == SQLITE_ROW) {
								tempValue = sqlite3_column_double(statement, 0);
								
							}
							else{
								tempValue = 0.00;
							}
							sqlite3_finalize(statement);
						}
						else{
							tempValue = 0.00;
						}
						
						tempUniRiderAlloc = tempUniRiderAlloc + ([[UnitizeRiderPremium objectAtIndex:j] doubleValue ] * tempValue/100.00 );
						
					}
				}
				
				[UniTotalRiderPremAtPolYear addObject:[NSString stringWithFormat:@"%f", tempUniRiderPrem]];
				[UniTotalRiderPremWithAlloc addObject:[NSString stringWithFormat:@"%f", tempUniRiderAlloc]];
			}
		}
		else{
			[UniTotalRiderPremAtPolYear addObject:[NSString stringWithFormat:@"0.00"]];
			[UniTotalRiderPremWithAlloc addObject:[NSString stringWithFormat:@"0.00"]];
		}

	}
	
	if (UniTotalRiderPremAtPolYear.count < 30) {
		NSLog(@" UniTotalRiderPremAtPolYear is less than 30");
		return;
	}

	if (UniTotalRiderPremWithAlloc.count < 30) {
		NSLog(@" UniTotalRiderAlloc is less than 30");
		return;
	}
	
	
	if ([strBasicPremium isEqualToString:@""]) {
		NSLog(@"no basic premium");
		return;
	}
	
	[self ResetData];
    for (int i =1; i <= 30; i++) {
		[BasicSumAssured addObject: strBasicSA ];
		//NSLog(@"basicSA ok");
		
		double TotalPolicyPrem = [strBasicPremium doubleValue] + [[UniTotalRiderPremAtPolYear objectAtIndex:i -1] doubleValue];
		[AnnualPremium addObject: [NSString stringWithFormat:@"%.3f", TotalPolicyPrem]];
				//NSLog(@"premium ok");
		
		if (i == 1) {
			[CumulativePremium addObject: [AnnualPremium objectAtIndex: i -1]];
		}
		else{
			NSString *Prev = [NSString stringWithFormat:@"%.3f", [[CumulativePremium objectAtIndex:i - 2] doubleValue ] + [[AnnualPremium objectAtIndex: i -1] doubleValue ]];
			[CumulativePremium addObject: Prev];
		}
				//NSLog(@"cumPremium ok");
		
		double sss = [self ReturnPremAllocation:i];
		[AllocatedBasicPrem addObject:[NSString stringWithFormat:@"%f", [strBasicPremium doubleValue ] * sss]];
							//NSLog(@"4 ok");
		[AllocatedRiderPrem addObject:[NSString stringWithFormat:@"%f", [[UniTotalRiderPremWithAlloc objectAtIndex:i -1] doubleValue ]]];
										//NSLog(@"5 ok");
		[UnAllocatedAllPrem addObject:[NSString stringWithFormat:@"%f",
									   TotalPolicyPrem - [[AllocatedBasicPrem objectAtIndex:i - 1] doubleValue] - [[AllocatedRiderPrem objectAtIndex:i - 1] doubleValue]]];
										//NSLog(@"6 ok");
		if (i == 1) {
			[CumAlloBasicPrem addObject: [AllocatedBasicPrem objectAtIndex: i -1]];
		}
		else{
			NSString *Prev = [NSString stringWithFormat:@"%f", [[CumAlloBasicPrem objectAtIndex:i - 2] doubleValue ] + [[AllocatedBasicPrem objectAtIndex: i -1] doubleValue ]];
			[CumAlloBasicPrem addObject: Prev];
		}
												//NSLog(@"7 ok");
		if (i == 1) {
			[CumAlloRiderPrem addObject: [AllocatedRiderPrem objectAtIndex: i -1]];
		}
		else{
			NSString *Prev = [NSString stringWithFormat:@"%f", [[CumAlloRiderPrem objectAtIndex:i - 2] doubleValue ] + [[AllocatedRiderPrem objectAtIndex: i -1] doubleValue ]];
			[CumAlloRiderPrem addObject: Prev];
		}
												//NSLog(@"8 ok");
		[TotalCumPrem addObject:[NSString stringWithFormat:@"%f", [[CumAlloBasicPrem objectAtIndex:i - 1] doubleValue] + [[CumAlloRiderPrem objectAtIndex:i-1] doubleValue ]]];
												//NSLog(@"9 ok");
 		 [BasicInsCharge addObject:[NSString stringWithFormat:@"%f",[self ReturnTotalBasicMortLow:i] * 12]];
		 										//NSLog(@"10 ok");
		[RiderInsCharge addObject:[NSString stringWithFormat:@"%f", [self ReturnTotalRiderMort:i] * 12.00]];
												//NSLog(@"11 ok");
		[OtherCharge addObject:[NSString stringWithFormat:@"%f", (PolicyFee + [self ReturnRiderPolicyFee:i]) * 12]];
												//NSLog(@"12 ok");
		[DirectDistributionCost addObject:[NSString stringWithFormat:@"%f", ([strBasicPremium doubleValue ] * [self ReturnBasicCommisionFee:i]/100.00) +
										   ([self ReturnRegTopUpPrem] * 0.0375) + ([self ReturnExcessPrem:1] * 0.0375) + [self ReturnRiderCommisionFee:i]  ]];
											//NSLog(@"13 ok");
		//-----------
		if (i == 1) {
			[self CalcInst:@""];
			[self GetRegWithdrawal];
			[self ReturnFundFactor]; // get factor for each fund
			[self CalcYearDiff]; //get the yearDiff
		}
		
		 VUCashValueNegative = false;
		 RiderVUCashValueNegative = false;
		 if (i == YearDiff2023 || i == YearDiff2025 || i == YearDiff2028 || i == YearDiff2030 || i == YearDiff2035) {
		 
			 for (int m = 1; m <= 12; m++) {
				 MonthFundValueOfTheYearValueTotalHigh = [self ReturnMonthFundValueOfTheYearValueTotalHigh:i andMonth:m];
				 RiderMonthFundValueOfTheYearValueTotalHigh = [self ReturnRiderMonthFundValueOfTheYearValueTotalHigh:i andMonth:m];
				 //NSLog(@"%d %f %f %f", m, MonthVURetValueHigh, MonthVU2035ValueHigh, MonthFundValueOfTheYearValueTotalHigh );
				 [self SurrenderValue:i andMonth:m andLevel:1];
				
				 MonthFundValueOfTheYearValueTotalMedian = [self ReturnMonthFundValueOfTheYearValueTotalMedian:i andMonth:m];
				 RiderMonthFundValueOfTheYearValueTotalMedian = [self ReturnRiderMonthFundValueOfTheYearValueTotalMedian:i andMonth:m];
				 [self SurrenderValue:i andMonth:m andLevel:2];
				 
				 
				 MonthFundValueOfTheYearValueTotalLow = [self ReturnMonthFundValueOfTheYearValueTotalLow:i andMonth:m];
				 RiderMonthFundValueOfTheYearValueTotalLow = [self ReturnRiderMonthFundValueOfTheYearValueTotalLow:i andMonth:m];
				 //NSLog(@"%d %f %f %f", m, MonthVURetValueLow, MonthVU2035ValueLow, MonthFundValueOfTheYearValueTotalLow );
				 [self SurrenderValue:i andMonth:m andLevel:3];
		 
			 }
		 
		 }
		 else{
			 VUCashValueNegative = false;
			 RiderVUCashValueNegative = false;
			 FundValueOfTheYearValueTotalHigh = [self ReturnFundValueOfTheYearValueTotalHigh:i];
			 FundValueOfTheYearValueTotalMedian = [self ReturnFundValueOfTheYearValueTotalMedian:i];
			 FundValueOfTheYearValueTotalLow = [self ReturnFundValueOfTheYearValueTotalLow:i];
			 RiderFundValueOfTheYearValueTotalHigh = [self ReturnRiderFundValueOfTheYearValueTotalHigh:i];
			 RiderFundValueOfTheYearValueTotalMedian = [self ReturnRiderFundValueOfTheYearValueTotalMedian:i];
			 RiderFundValueOfTheYearValueTotalLow = [self ReturnRiderFundValueOfTheYearValueTotalLow:i];
			 
			 [self SurrenderValue:i andMonth:0 andLevel:0];

		 }
		 
		[BullSurrender addObject:[NSString stringWithFormat:@"%f", HSurrenderValue]];
		[FlatSurrender addObject:[NSString stringWithFormat:@"%f", MSurrenderValue]];
		[BearSurrender addObject:[NSString stringWithFormat:@"%f", LSurrenderValue]];
		 //NSLog(@"%d) %f, %f, %f",i, HRiderSurrenderValue, MRiderSurrenderValue, LRiderSurrenderValue );
		 //NSLog(@"%d) %f,%f,%f,%f,%f,%f,%f", i, RiderVUCashValueHigh,RiderVURetValueHigh,RiderVU2023ValueHigh, RiderVU2025ValueHigh,RiderVU2028ValueHigh, RiderVU2030ValueHigh, RiderVU2035ValueHigh);
		 //NSLog(@"%d) %f,%f,%f,%f,%f,%f,%f", i, VUCashValueLow,VURetValueLow,VU2023ValueLow, VU2025ValueLow,VU2028ValueLow, VU2030ValueLow, VU2035ValueLow);
		 // --------------------
		
		[RiderBullSurrender addObject:[NSString stringWithFormat:@"%f", HRiderSurrenderValue]];
		[RiderFlatSurrender addObject:[NSString stringWithFormat:@"%f", MRiderSurrenderValue]];
		[RiderBearSurrender addObject:[NSString stringWithFormat:@"%f", LRiderSurrenderValue]];
		
		[TotalBullSurrender addObject:[NSString stringWithFormat:@"%f", HSurrenderValue + HRiderSurrenderValue] ];
		[TotalFlatSurrender addObject:[NSString stringWithFormat:@"%f", MSurrenderValue + MRiderSurrenderValue]];
		[TotalBearSurrender addObject:[NSString stringWithFormat:@"%f", LSurrenderValue + LRiderSurrenderValue]];
		
		[EOFTPDBull addObject:[NSString stringWithFormat:@"%f", [strBasicSA doubleValue] + HSurrenderValue]];
		[EOFTPDFlat addObject:[NSString stringWithFormat:@"%f", [strBasicSA doubleValue] + MSurrenderValue]];
		[EOFTPDBear addObject:[NSString stringWithFormat:@"%f", [strBasicSA doubleValue] + LSurrenderValue]];
		
		[EOFOADBull addObject:[NSString stringWithFormat:@"%f", [strBasicSA doubleValue] + HSurrenderValue]];
		[EOFOADFlat addObject:[NSString stringWithFormat:@"%f", [strBasicSA doubleValue] + MSurrenderValue]];
		[EOFOADBear addObject:[NSString stringWithFormat:@"%f", [strBasicSA doubleValue] + LSurrenderValue]];
		
		[FundChargeBull addObject:[NSString stringWithFormat:@"%f",  HSurrenderValue/12.00]];
		[FundChargeFlat addObject:[NSString stringWithFormat:@"%f", MSurrenderValue/12.00]];
		[FundChargeBear addObject:[NSString stringWithFormat:@"%f",  LSurrenderValue/12.00]];
		
	}
    
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		for (int a= 1; a<=30; a++) {
			if (Age >= 0){
				inputAge = Age + a;
				
				QuerySQL = [NSString stringWithFormat: @"Insert INTO UL_Temp_Trad_Basic (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
							"'col3','col4','col5','col6','col7','col8','col9','col10','col11','col12','col13','col14','col15','col16','col17','col18','col19','col20','col21','col22', "
							" 'col23','col24','col25','col26','col27','col28','col29','col30','col31') VALUES ( "
							" \"%@\",\"%d\",\"%@\",\"%d\",\"%d\",\"%@\", '%@', '%.0f','%.0f', '%.0f', %.0f, '%.0f', '%.0f','%.0f', '%.0f','%.0f', '%.0f','%.0f','%.0f', '%.0f','%.0f','%.0f', '%.0f','%.0f', "
							"'%.0f', '%.0f','%.0f','%.0f', '%.0f','%.0f','%.0f', '%.0f','%.0f','%.0f', '%.0f','%.0f' )",
							SINo, a, @"DATA", a, inputAge, [BasicSumAssured objectAtIndex:a-1], [AnnualPremium objectAtIndex:a -1], round([[CumulativePremium objectAtIndex: a -1] doubleValue]),
							round([[UnAllocatedAllPrem objectAtIndex:a-1] doubleValue]), round([[AllocatedBasicPrem objectAtIndex:a-1] doubleValue ]), round([[AllocatedRiderPrem objectAtIndex:a-1] doubleValue ]),
							round([[CumAlloBasicPrem objectAtIndex:a-1] doubleValue ]), round([[CumAlloRiderPrem objectAtIndex:a-1]doubleValue ]), round([[TotalCumPrem objectAtIndex:a-1] doubleValue ]),
							round([[BasicInsCharge objectAtIndex:a-1]doubleValue ]), round([[RiderInsCharge objectAtIndex:a-1]doubleValue ]), round([[OtherCharge objectAtIndex:a-1]doubleValue ]),
							round([[DirectDistributionCost objectAtIndex:a-1]doubleValue ]),
							round([[BullSurrender objectAtIndex:a-1]doubleValue ]), round([[FlatSurrender objectAtIndex:a-1]doubleValue ]), round([[BearSurrender objectAtIndex:a-1]doubleValue ]),
							round([[RiderBullSurrender objectAtIndex:a-1]doubleValue ]), round([[RiderFlatSurrender objectAtIndex:a-1] doubleValue ]), round([[RiderBearSurrender objectAtIndex:a-1] doubleValue ]),
							round([[TotalBullSurrender objectAtIndex:a-1]doubleValue ]), round([[TotalFlatSurrender objectAtIndex:a-1] doubleValue ]), round([[TotalBearSurrender objectAtIndex:a-1] doubleValue ]),
							round([[EOFTPDBull objectAtIndex:a-1]doubleValue ]), round([[EOFTPDFlat objectAtIndex:a-1] doubleValue ]), round([[EOFTPDBear objectAtIndex:a-1] doubleValue ]),
							round([[EOFOADBull objectAtIndex:a-1]doubleValue ]), round([[EOFOADFlat objectAtIndex:a-1] doubleValue ]), round([[EOFOADBear objectAtIndex:a-1] doubleValue ]),
							round([[FundChargeBull objectAtIndex:a-1]doubleValue ]), round([[FundChargeFlat objectAtIndex:a-1] doubleValue ]), round([[FundChargeBear objectAtIndex:a-1] doubleValue ])];
				
				//NSLog(@"%@", QuerySQL);
				if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
					if (sqlite3_step(statement) == SQLITE_DONE) {
						
					}
					else{
						NSLog(@"error in inserting data to UL_Temp_Trad_Basic");
					}
					sqlite3_finalize(statement);
				}
				
			}
		}
		sqlite3_close(contactDB);
	}
	
	NSLog(@"---------basic end--------");
}

-(void)getAllPreDetails{
	sqlite3_stmt *statement;
    NSString *QuerySQL;
	
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		QuerySQL = [ NSString stringWithFormat:@"Select RiderCode, RiderTerm,RiderDesc, SumAssured, PlanOption, "
					"Deductible, replace(Hloading, '(null)', '0') as Hloading, HloadingTerm, "
					" replace(HloadingPct, '(null)', '0') as HloadingPct, HloadingPctTerm, Premium, paymentTerm, "
					" ReinvestGYI, GYIYear, RRTUOFromYear, RRTUOYear from UL_rider_details "
                    "  where \"sino\" = \"%@\" AND ridercode not in ('CIRD', 'DCA', 'ACIR', 'HMM', 'MG_IV', "
					"'WI', 'MR', 'TPDMLA', 'PA', 'DHI', 'ECAR', 'ECAR55', 'RRTUO') ORDER BY RiderCode ASC ", SINo];
		
		//NSLog(@"%@", QuerySQL);
		if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			while(sqlite3_step(statement) == SQLITE_ROW) {
				[OtherRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
				[OtherRiderTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
				[OtherRiderDesc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
				
				[OtherRiderSA addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)]];
				if ([[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)] isEqualToString:@"(null)" ]   ) {
					[OtherRiderPlanOption addObject:@""];
				}
				else {
					[OtherRiderPlanOption addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)]];
				}
				
				[OtherRiderDeductible addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)]];
				[OtherRiderHL addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)]];
				[OtherRiderHLTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)]];
				[OtherRiderHLP addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)]];
				[OtherRiderHLPTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)]];
				[OtherRiderPremium addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)]];
				[OtherRiderPaymentTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)]];
			}
			
			sqlite3_finalize(statement);
		}
		
		QuerySQL = [NSString stringWithFormat: @"Select ridercode, SumAssured, ifnull(Hloading, '0') as Hloading, ifnull(HLoadingPct, '0') as HLoadingPct, "
					"RiderTerm, planOption, Deductible, premium from ul_rider_details Where  "
					"  sino = '%@' AND ridercode in ('CIRD', 'DCA', 'ACIR', 'HMM', 'MG_IV', "
					"'WI', 'MR', 'TPDMLA', 'PA', 'DHI')", SINo];
		
		//NSLog(@"%@", QuerySQL);
		if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
				[UnitizeRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
				[UnitizeRiderSA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
				[UnitizeRiderHL addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
				[UnitizeRiderHLPct addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)]];
				[UnitizeRiderTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)]];
				[UnitizeRiderPlanChoice addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)]];
				[UnitizeRiderDeductible addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)]];
				[UnitizeRiderPremium addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)]];
			}
            sqlite3_finalize(statement);
        }

		QuerySQL = [NSString stringWithFormat: @"Select premium, RRTUOFromYear, RRTUOYear from ul_rider_details Where  "
					"  sino = '%@' AND ridercode in ('RRTUO')", SINo];
		
		//NSLog(@"%@", QuerySQL);
		if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
				strRRTUOPrem = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
				strRRTUOFrom = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
				strRRTUOFor = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
			}
            sqlite3_finalize(statement);
        }
		
		
		
		
		sqlite3_close(contactDB);
	}
	
}

-(void)InsertToUL_Temp_ECAR55{
	sqlite3_stmt *statement;
    NSString *QuerySQL;
	NSString *ECAR55RiderTerm = @"", *ECAR55RiderDesc, *ECAR55SumAssured, *ECAR55HLoading, *ECAR55HLoadingPct, *ECAR55Premium;
	NSString *ECAR55PaymentTerm, *ECAR55ReinvestGYI, *ECAR55HLoadingTerm, *ECAR55HLoadingPctTerm;
	double ECAR55AnnuityRate = 0.00;
	double ECAR55TPDRate = 0.00;
	NSMutableArray *CSVRate = [[NSMutableArray alloc] init ];
	NSMutableArray *AnnualPremium = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderMonthlyIncome = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderSurrenderValueMRA = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderSurrenderValue = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderTPDBegin = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderTPDEnd = [[NSMutableArray alloc] init ];
	NSMutableArray *CommissionRate = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderDistributionCost = [[NSMutableArray alloc] init ];
	

	
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		QuerySQL = [ NSString stringWithFormat:@"Select  RiderTerm,RiderDesc, SumAssured, "
					" coalesce(nullif(hloading, ''), '0' ) as Hloading, HloadingTerm, "
					" replace(HloadingPct, '(null)', '0') as HloadingPct, HloadingPctTerm, Premium, paymentTerm, "
					" ReinvestGYI from UL_rider_details where \"sino\" = \"%@\" AND ridercode = 'ECAR55' ", SINo];
		//NSLog(@"%@", QuerySQL);
		if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW) {
				ECAR55RiderTerm = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
				ECAR55RiderDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
				ECAR55SumAssured = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
				const char *temp = (const char*)sqlite3_column_text(statement, 3);
				ECAR55HLoading = temp == NULL ? Nil : [[NSString alloc] initWithUTF8String:(const char *)temp];
				//ECAR55HLoading = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
				ECAR55HLoadingTerm = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
				ECAR55HLoadingPct = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
				ECAR55HLoadingPctTerm = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
				ECAR55Premium = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
				ECAR55PaymentTerm = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
				ECAR55ReinvestGYI = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
				
			}
			
			sqlite3_finalize(statement);
		}
		
		sqlite3_close(contactDB);
	}
	
	
	
	if (![ECAR55RiderTerm isEqualToString:@""]) {
			NSLog(@"--------- ECAR55 begin --------");
		if (sqlite3_open([UL_RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK){
			for (int i =1; i <= 30; i++) {
				QuerySQL = [ NSString stringWithFormat:@"Select CSV from ES_sys_Rider_csv where PlanCode = 'ECAR55' "
							"AND PremPayOpt = '%@' AND PolTerm = '%@' AND FromAge = '%d' AND PolYear = '%d' ", ECAR55PaymentTerm, ECAR55RiderTerm, Age, i];
				
				//NSLog(@"%@", QuerySQL);
				if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
					if (sqlite3_step(statement) == SQLITE_ROW) {
							[CSVRate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
					}
					
					
					sqlite3_finalize(statement);
				}
				
				int max;
				if (i > 7) {
					max = 7;
				}
				else{
					max = i;
				}
				
				QuerySQL = [ NSString stringWithFormat:@"Select Rate from ES_sys_Rider_commission where  "
							" PolYear = '%d' AND RiderTerm = '%@' ", max, ECAR55RiderTerm];
				
				if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
					if (sqlite3_step(statement) == SQLITE_ROW) {
						[CommissionRate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
					}
					
					
					sqlite3_finalize(statement);
				}
				
			}
			
			QuerySQL = [ NSString stringWithFormat:@"Select Rate from ES_sys_Rider_AnnuityPrem where PlanCode = 'ECAR55' "
						"AND PremPayOpt = '%@' AND PolTerm = '%@' AND FromAge = '%d' ", ECAR55PaymentTerm, ECAR55RiderTerm, Age];
			
			if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
									if (sqlite3_step(statement) == SQLITE_ROW) {
										ECAR55AnnuityRate = sqlite3_column_double(statement, 0);
									}
				
				sqlite3_finalize(statement);
			}
			
			QuerySQL = [ NSString stringWithFormat:@"Select Rate from ES_sys_Rider_Prem where PlanCode = 'ECAR55' "
						"AND PremPayOpt = '%@' AND Term = '%@' AND FromAge = '%d' ", ECAR55PaymentTerm, ECAR55RiderTerm, Age];
			
			if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
				if (sqlite3_step(statement) == SQLITE_ROW) {
						ECAR55TPDRate = sqlite3_column_double(statement, 0);
				}
				
				sqlite3_finalize(statement);
			}
			
			
			sqlite3_close(contactDB);
		}
		
		if (CommissionRate.count == 0) {
			NSLog(@"no commission rate");
			return;
		}
		
		if (CSVRate.count == 0) {
			NSLog(@"no csv rate");
			return;
		}
		
		for (int i = 1; i <= 30; i++) {
			if (Age + i < 55) {
				[AnnualPremium addObject: ECAR55Premium ];
			}
			else{
				[AnnualPremium addObject:@"0.00" ];
			}
			
			
			if (Age + i ==  55) {
				[RiderMonthlyIncome addObject: ECAR55SumAssured ];
			}
			else if (Age + i > 55) {
				[RiderMonthlyIncome addObject: [NSString stringWithFormat:@"%f", [ECAR55SumAssured doubleValue ] * 12 ]];
			}
			else{
				[RiderMonthlyIncome addObject:@"0.00" ];
			}
			
			
				double tempS = [[CSVRate objectAtIndex:i -1] doubleValue ] * [ECAR55SumAssured doubleValue ]/100.00;
				double tempRetPrem = ECAR55AnnuityRate * [ECAR55Premium doubleValue]/100.00;
				double minRetention = 0.00;
				
				if (tempRetPrem > 3000) {
					tempRetPrem = 3000;
				}
				
				if (Age + i <= 55) {
					minRetention = tempRetPrem * i;
				}
				else{
					minRetention = 0.00;
				}
				
				[RiderSurrenderValueMRA addObject:[NSString stringWithFormat:@"%f", tempS - minRetention]];
				[RiderSurrenderValue addObject:[NSString stringWithFormat:@"%f", tempS]];
			
			
			double RiderTPD;
			if (Age + i <= 55) {
				RiderTPD = (ECAR55TPDRate * [ECAR55SumAssured doubleValue]/100.00) * pow(1.035, i - 1)/0.035 ;
			}
			else{
				RiderTPD = [ECAR55SumAssured doubleValue ] * 6 * (101 - (Age + i));
			}
			
			[RiderTPDBegin addObject:[NSString stringWithFormat:@"%f", RiderTPD]];
			
			double RiderTPDEOF;
			if (Age + i <= 55) {
				RiderTPDEOF = (ECAR55TPDRate * [ECAR55SumAssured doubleValue]/100.00) * 1.035 * pow(1.035, i - 1)/0.035 ;
			}
			else{
				RiderTPDEOF = [ECAR55SumAssured doubleValue ] * 6 * (100 - (Age + i));
			}
			
			[RiderTPDEnd addObject:[NSString stringWithFormat:@"%f", RiderTPDEOF]];
			
			[RiderDistributionCost addObject:[NSString stringWithFormat:@"%f", [ECAR55Premium doubleValue ] * [[CommissionRate objectAtIndex:i - 1] doubleValue ]/100.00]];
			
			
		}
		
		int inputAge;
		if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){

			for (int a= 1; a<=30; a++) {
				if (Age >= 0){
					inputAge = Age + a;
					
					if (a == 1) {
						QuerySQL = [NSString stringWithFormat: @"Insert INTO UL_Temp_ECAR55 (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
									"'col3','col4','col5','col6','col7', 'col8', 'col9') VALUES ( "
									" \"%@\",\"%d\",\"%@\",\"%d\",\"%d\",\"%@\", '%@', '%@','%@', '%@', %@, '%@', '%f', '%@')",
									SINo, a, @"DATA", a, inputAge, [AnnualPremium objectAtIndex:a - 1], [RiderMonthlyIncome objectAtIndex:a -1],
									[RiderSurrenderValueMRA objectAtIndex:a-1], [RiderSurrenderValue objectAtIndex:a-1], [RiderTPDBegin objectAtIndex:a-1],
									[RiderTPDEnd objectAtIndex:a-1], [RiderDistributionCost objectAtIndex:a-1], ECAR55AnnuityRate, ECAR55Premium];
					}
					else{
						QuerySQL = [NSString stringWithFormat: @"Insert INTO UL_Temp_ECAR55 (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
									"'col3','col4','col5','col6','col7') VALUES ( "
									" \"%@\",\"%d\",\"%@\",\"%d\",\"%d\",\"%@\", '%@', '%@','%@', '%@', %@, '%@')",
									SINo, a, @"DATA", a, inputAge, [AnnualPremium objectAtIndex:a - 1], [RiderMonthlyIncome objectAtIndex:a -1],
									[RiderSurrenderValueMRA objectAtIndex:a-1], [RiderSurrenderValue objectAtIndex:a-1], [RiderTPDBegin objectAtIndex:a-1],
									[RiderTPDEnd objectAtIndex:a-1], [RiderDistributionCost objectAtIndex:a-1]];
					}
			
					
					//NSLog(@"%@", QuerySQL);
					if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
						if (sqlite3_step(statement) == SQLITE_DONE) {
							
						}
						sqlite3_finalize(statement);
					}
					
				}
			}
			sqlite3_close(contactDB);
		}
			NSLog(@"--------- ECAR55 end --------");
	}
	
	

}

-(void)InsertToUL_Temp_ECAR1{
	sqlite3_stmt *statement;
    NSString *QuerySQL;
	NSString *ECAR1RiderTerm = @"", *ECAR1RiderDesc, *ECAR1SumAssured, *ECAR1HLoading, *ECAR1HLoadingPct, *ECAR1Premium;
	NSString *ECAR1PaymentTerm, *ECAR1ReinvestGYI, *ECAR1HLoadingTerm, *ECAR1HLoadingPctTerm;

	NSMutableArray *ECAR1TPDRate = [[NSMutableArray alloc] init ];
	NSMutableArray *ECAR1TPDRateEOY = [[NSMutableArray alloc] init ];
	NSMutableArray *ECAR1AccTPD = [[NSMutableArray alloc] init ];
	NSMutableArray *ECAR1AccTPDEOY = [[NSMutableArray alloc] init ];
	NSMutableArray *CSVRate = [[NSMutableArray alloc] init ];
	NSMutableArray *AnnualPremium = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderYearlyIncome = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderSurrenderValue = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderTPDBegin = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderTPDEnd = [[NSMutableArray alloc] init ];
	NSMutableArray *CommissionRate = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderDistributionCost = [[NSMutableArray alloc] init ];
	
	
	
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		QuerySQL = [ NSString stringWithFormat:@"Select  RiderTerm,RiderDesc, SumAssured, "
					" coalesce(nullif(hloading, ''), '0' ) as Hloading, HloadingTerm, "
					" replace(HloadingPct, '(null)', '0') as HloadingPct, HloadingPctTerm, Premium, paymentTerm, "
					" ReinvestGYI from UL_rider_details where \"sino\" = \"%@\" AND ridercode = 'ECAR' ", SINo];
		//NSLog(@"%@", QuerySQL);
		if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW) {
				ECAR1RiderTerm = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
				ECAR1RiderDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
				ECAR1SumAssured = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
				const char *temp = (const char*)sqlite3_column_text(statement, 3);
				ECAR1HLoading = temp == NULL ? Nil : [[NSString alloc] initWithUTF8String:(const char *)temp];
				//ECAR55HLoading = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
				ECAR1HLoadingTerm = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
				ECAR1HLoadingPct = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
				ECAR1HLoadingPctTerm = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
				ECAR1Premium = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
				ECAR1PaymentTerm = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
				ECAR1ReinvestGYI = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
				
			}
			
			sqlite3_finalize(statement);
		}
		
		sqlite3_close(contactDB);
	}
	
	
	
	if (![ECAR1RiderTerm isEqualToString:@""]) {
		NSLog(@"--------- ECAR1 begin --------");
		if (sqlite3_open([UL_RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK){
			for (int i =1; i <= [ECAR1RiderTerm intValue]; i++) {
				QuerySQL = [ NSString stringWithFormat:@"Select CSV from ES_sys_Rider_csv where PlanCode = 'ECAR' "
							"AND GYI_GMI_Year = '1' AND PolTerm = '%@' AND FromAge = '%d' AND PolYear = '%d' ", ECAR1RiderTerm, Age, i];
				
				//NSLog(@"%@", QuerySQL);
				if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
					if (sqlite3_step(statement) == SQLITE_ROW) {
						[CSVRate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
					}
					
					
					sqlite3_finalize(statement);
				}
				
				int max;
				if (i > 7) {
					max = 7;
				}
				else{
					max = i;
				}
				
				QuerySQL = [ NSString stringWithFormat:@"Select Rate from ES_sys_Rider_commission where  "
							" PolYear = '%d' AND RiderTerm = '%@' ", max, ECAR1RiderTerm];
				
				if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
					if (sqlite3_step(statement) == SQLITE_ROW) {
						[CommissionRate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
					}
					
					
					sqlite3_finalize(statement);
				}
				
				QuerySQL = [ NSString stringWithFormat:@"Select Rate from ES_sys_Rider_DeathTPD where CP_Start_Year = '1' AND  "
							" Policy_Year = '%d' AND Policy_Term = '%@' ", i, ECAR1RiderTerm];
				
				//NSLog(@"%@", QuerySQL);
				
				if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
					if (sqlite3_step(statement) == SQLITE_ROW) {
						[ECAR1TPDRate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
					}
					
					
					sqlite3_finalize(statement);
				}
				
				QuerySQL = [ NSString stringWithFormat:@"Select Rate from ES_sys_Rider_DeathTPD_EOY where CP_Start_Year = '1' AND  "
							" Policy_Year = '%d' AND Policy_Term = '%@' ", i, ECAR1RiderTerm];
				
				if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
					if (sqlite3_step(statement) == SQLITE_ROW) {
						[ECAR1TPDRateEOY addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
					}
					
					
					sqlite3_finalize(statement);
				}
				
			}
			
			sqlite3_close(contactDB);
		}
		
		
		if (CommissionRate.count == 0) {
			NSLog(@"no commission rate");
			return;
		}
		
		if (ECAR1TPDRate.count == 0) {
			NSLog(@"no tpd rate");
			return;
		}
		
		if (ECAR1TPDRateEOY.count == 0) {
			NSLog(@"no tpd eoy rate");
			return;
		}
		
		if (CSVRate.count == 0) {
			NSLog(@"no tpd eoy rate");
			return;
		}
		
		for (int i = 1; i <= [ECAR1RiderTerm intValue]; i++) {
			if (i <= [ECAR1PaymentTerm intValue ]) {
				[AnnualPremium addObject: ECAR1Premium ];
			}
			else{
				[AnnualPremium addObject:@"0.00" ];
			}
			
			
			if (Age + i >=  1) {
				[RiderYearlyIncome addObject: ECAR1SumAssured ];
			}
			else{
				[RiderYearlyIncome addObject:@"0.00" ];
			}
			

				double tempS = [[CSVRate objectAtIndex:i -1] doubleValue ] * [ECAR1SumAssured doubleValue ]/1000.00;
				
				[RiderSurrenderValue addObject:[NSString stringWithFormat:@"%f", tempS]];


			//-----------------
			double RiderTPD;

			RiderTPD = [ECAR1SumAssured doubleValue ]  * [[ECAR1TPDRate objectAtIndex:i-1] doubleValue];
			
			[RiderTPDBegin addObject:[NSString stringWithFormat:@"%f", RiderTPD]];
			//-------------
			double RiderTPDEOY;

				RiderTPDEOY = [ECAR1SumAssured doubleValue ] * [[ECAR1TPDRateEOY objectAtIndex:i-1] doubleValue]; ;

			
			[RiderTPDEnd addObject:[NSString stringWithFormat:@"%f", RiderTPDEOY]];
			
			// --------
			double RiderAccTPD = 0.00;
			if (Age + i <= 65) {
				double eee = RiderTPD * 3;
				if (eee + RiderTPD <= [self TPDLimit:Age + i - 1] ) {
					RiderAccTPD = RiderTPD * 3; ;
				}
				else{
					RiderAccTPD = [self TPDLimit:Age + i - 1] - RiderTPD ;
					if (RiderAccTPD <= 0) {
						RiderAccTPD = 0.00;
					}
				}
			}
			else{
				RiderAccTPD = 0.00;
			}
			
			[ECAR1AccTPD addObject:[NSString stringWithFormat:@"%f", RiderAccTPD]];
			
			//------
			double RiderAccTPD_EOY = 0.00;
			if (Age + i <= 64) {
				double fff = RiderTPDEOY * 3;
				if (fff + RiderTPDEOY <= [self TPDLimit:Age + i] ) {
					RiderAccTPD_EOY = RiderTPDEOY * 3; ;
				}
				else{
					RiderAccTPD_EOY = [self TPDLimit:Age + i] - RiderTPDEOY ;
					if (RiderAccTPD_EOY <= 0) {
						RiderAccTPD_EOY = 0.00;
					}
				}
			}
			else{
				RiderAccTPD_EOY = 0.00;
			}
			
			[ECAR1AccTPDEOY addObject:[NSString stringWithFormat:@"%f", RiderAccTPD_EOY]];
			
			//----------
			
			[RiderDistributionCost addObject:[NSString stringWithFormat:@"%f", [ECAR1Premium doubleValue ] * [[CommissionRate objectAtIndex:i - 1] doubleValue ]/100.00]];
			
			
		}
		
		int inputAge;
		if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
			for (int a= 1; a<=[ECAR1RiderTerm intValue]; a++) {
				if (Age >= 0){
					inputAge = Age + a;
					
					QuerySQL = [NSString stringWithFormat: @"Insert INTO UL_Temp_ECAR (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
								"'col3','col4','col5','col6','col7','col8') VALUES ( "
								" \"%@\",\"%d\",\"%@\",\"%d\",\"%d\",\"%@\", '%@', '%@','%@', '%@', %@, '%@', '%@')",
								SINo, a, @"DATA", a, inputAge, [AnnualPremium objectAtIndex:a - 1], [RiderYearlyIncome objectAtIndex:a -1],
								[RiderSurrenderValue objectAtIndex:a-1], [RiderTPDBegin objectAtIndex:a-1],
								[RiderTPDEnd objectAtIndex:a-1], [ECAR1AccTPD objectAtIndex:a-1],[ECAR1AccTPDEOY objectAtIndex:a-1], [RiderDistributionCost objectAtIndex:a-1]];
					
					//NSLog(@"%@", QuerySQL);
					if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
						if (sqlite3_step(statement) == SQLITE_DONE) {
							
						}
						sqlite3_finalize(statement);
					}
					
				}
			}
			sqlite3_close(contactDB);
		}
		NSLog(@"--------- ECAR1 end --------");
	}
	
	
	
}

-(double)TPDLimit :(int)aaAgeEOY{
	if (aaAgeEOY <= 6) {
		return 100000.00;
	}
	else if (aaAgeEOY > 6 && aaAgeEOY <= 14) {
		return 500000.00;
	}
	else if (aaAgeEOY > 14 && aaAgeEOY <= 65) {
		return 3500000.00;
	}
	else{
		return 0.00;
	}
}

-(void)InsertToUL_Temp_Summary{
	sqlite3_stmt *statement;
    NSString *QuerySQL;
	
		NSLog(@"--------- UL_Temp_Summary begin --------");
	
		int inputAge;
		if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
			for (int a= 1; a<=30; a++) {
				if (Age >= 0){
					inputAge = Age + a;
					
					QuerySQL = [NSString stringWithFormat: @"Insert INTO UL_Temp_Summary (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
								"'col3','col4','col5','col6','col7','col8','col9','col10','col11','col12','col13','col14','col15','col16','col17') VALUES ( "
								" \"%@\",\"%d\",\"%@\",\"%d\",\"%d\",\"%@\", '%@', '%@','%@', '%@', %@, '%@', '%@',\"%@\", '%@', '%@','%@', '%@', %@, '%@', '%@','%@')",
								SINo, a, @"DATA", a, inputAge, @"0", @"0", @"0", @"0",@"0",@"0",@"0",@"0",@"0", @"0", @"0", @"0",@"0",@"0",@"0",@"0",@"0" ];
					
					//NSLog(@"%@", QuerySQL);
					if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
						if (sqlite3_step(statement) == SQLITE_DONE) {
							
						}
						sqlite3_finalize(statement);
					}
					
				}
			}
			sqlite3_close(contactDB);
		}
		NSLog(@"--------- UL_Temp_Summary end --------");
	
	
}


-(void)InsertToUL_Temp_Trad_Rider{
    
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    NSMutableArray *TotalRiderSurrenderValue = [[NSMutableArray alloc] init ];
    
    if (OtherRiderCode.count > 0) {
		NSLog(@"insert to UL_Temp_Trad_Rider --- start");
		
        for (int x = 0; x < 30; x++) {
            [TotalRiderSurrenderValue addObject:@"0.00"];
        }
        
        int page;
        
        int NoOfPages = ceil(OtherRiderCode.count/3.00);
        
        for (page =1; page <=NoOfPages; page++) {
            
            NSMutableArray *RiderCol1 = [[NSMutableArray alloc] init ];
            NSMutableArray *RiderCol2 = [[NSMutableArray alloc] init ];
            NSMutableArray *RiderCol3 = [[NSMutableArray alloc] init ];
            NSMutableArray *RiderCol4 = [[NSMutableArray alloc] init ];
            NSMutableArray *RiderCol5 = [[NSMutableArray alloc] init ];
            NSMutableArray *RiderCol6 = [[NSMutableArray alloc] init ];
            NSMutableArray *RiderCol7 = [[NSMutableArray alloc] init ];
            NSMutableArray *RiderCol8 = [[NSMutableArray alloc] init ];
            NSMutableArray *RiderCol9 = [[NSMutableArray alloc] init ];
            NSMutableArray *RiderCol10 = [[NSMutableArray alloc] init ];
            NSMutableArray *RiderCol11 = [[NSMutableArray alloc] init ];
            NSMutableArray *RiderCol12 = [[NSMutableArray alloc] init ];
            
            
            for (int Rider =0; Rider < 3; Rider++) {
                int item = 3 * (page - 1) + Rider;
                
                if (item < OtherRiderCode.count) {
                    
                    NSString *tempRiderCode = [OtherRiderCode objectAtIndex:item];
                    NSString *tempRiderDesc = [OtherRiderDesc objectAtIndex:item];
                    NSString *tempRiderPlanOption = [OtherRiderPlanOption objectAtIndex:item];
                    double tempRiderSA = [[OtherRiderSA objectAtIndex:item] doubleValue ];
                    int tempRiderTerm = [[OtherRiderTerm objectAtIndex:item] intValue ];
                    double tempPremium = [[OtherRiderPremium objectAtIndex:item] doubleValue ];
                    NSMutableArray *tempCol1 = [[NSMutableArray alloc] init ];
                    NSMutableArray *tempCol2 = [[NSMutableArray alloc] init ];
                    NSMutableArray *tempCol3 = [[NSMutableArray alloc] init ];
                    NSMutableArray *tempCol4 = [[NSMutableArray alloc] init ];
					NSString *tempHL = [OtherRiderHL objectAtIndex:item];
                    NSString *tempHLTerm = [OtherRiderHLTerm objectAtIndex:item];
                    //NSString *tempHLP = [OtherRiderHLP objectAtIndex:item];
					//NSString *tempHLPTerm = [OtherRiderHLPTerm objectAtIndex:item];

					
					NSLog(@"%@, %d", [OtherRiderCode objectAtIndex:item], item);
					
					for (int row = 0; row < 3; row++) {
						
						if (row == 0) {
							[tempCol1 addObject:tempRiderDesc ];
							[tempCol2 addObject:@"" ];
							[tempCol3 addObject:@"" ];
							[tempCol4 addObject:@"" ];
							
						}
						
						if (row == 1) {
							if ([tempRiderCode isEqualToString:@"CIWP"] || [tempRiderCode isEqualToString:@"TPDWP"] ||
									 [tempRiderCode isEqualToString:@"PR"] || [tempRiderCode isEqualToString:@"LCWP"]) {
								[tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
								[tempCol2 addObject:@"Sum<br/>Assured" ];
								[tempCol3 addObject:@"Cash Surrender Value" ];
								[tempCol4 addObject:@"-" ];
							}
							else if ([tempRiderCode isEqualToString:@"LSR"] ) {
								[tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
								[tempCol2 addObject:@"Sum Assured" ];
								[tempCol3 addObject:@"Cash Surrender Value" ];
								[tempCol4 addObject:@"-" ];
							}
							else {
								[tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
								[tempCol2 addObject:@"-" ];
								[tempCol3 addObject:@"-" ];
								[tempCol4 addObject:@"-" ];
							}
						}
						
						
					}

					double tempTotalRiderSurrenderValue = 0.00;
					NSMutableArray *Rate = [[NSMutableArray alloc] init ];
                
					for (int i = 0; i < 30; i++) {
						
						if (i < tempRiderTerm) {
							
								if ([tempRiderCode isEqualToString:@"CIWP"] || [tempRiderCode isEqualToString:@"TPDWP"] ||
									 [tempRiderCode isEqualToString:@"PR"] || [tempRiderCode isEqualToString:@"LCWP"]) {
								
									if (i == 0) {
										if (sqlite3_open([UL_RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK){
											if ([tempRiderCode isEqualToString:@"CIWP"] || [tempRiderCode isEqualToString:@"TPDWP"]) {
												QuerySQL = [NSString stringWithFormat:@"Select rate from Trad_Sys_Rider_CSV Where plancode = \"%@\" "
															"AND FromAge = \"%d\" AND PolYear = \"%d\" AND PolTerm = '%d' AND Sex = '%@'"
															, tempRiderCode, Age, i + 1, tempRiderTerm, sex ];
												
											}
											else{
												if (PYAge > 0) {
													QuerySQL = [NSString stringWithFormat:@"Select rate from Trad_Sys_Rider_CSV Where plancode = \"%@\" "
																"AND FromAge = \"%d\" AND PolYear = \"%d\" AND PolTerm = '%d' AND Sex = '%@'"
																, tempRiderCode, PYAge, i + 1, tempRiderTerm, PYSex ];
												}
												else{
													QuerySQL = [NSString stringWithFormat:@"Select rate from Trad_Sys_Rider_CSV Where plancode = \"%@\" "
																"AND FromAge = \"%d\" AND PolYear = \"%d\" AND PolTerm = '%d' AND Sex = '%@'"
																, tempRiderCode, SecAge, i + 1, tempRiderTerm, SecSex ];
												}
												
											}
											
											if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
												while (sqlite3_step(statement) == SQLITE_ROW) {
													[Rate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
													
												}
												sqlite3_finalize(statement);
											}
											sqlite3_close(contactDB);
										}
										
										if (Rate.count < 30) {
											
											int rowsToAdd = 30 - Rate.count;
											for (int u =0; u<rowsToAdd; u++) {
												[Rate addObject:@"0.00"];
											}
										}
									}
									
								double actualPremium = 0.0;
								if([tempHL isEqualToString:@"(null)"] || [tempHL isEqualToString:@"0"] || [tempHL isEqualToString:@""] ) {
									
									actualPremium = tempPremium;
								}
								else{
									if(i + 1 <= [tempHLTerm intValue ] ){
										actualPremium = tempPremium;
									}
									else{
										actualPremium = tempPremium - ((tempRiderSA *  tempRiderSA/100)/100) * [tempHL doubleValue];
									}
								}
								/*
								if (![tempTempHL isEqualToString:@"(null)"] ) {
									if (i + 1 > [tempTempHLTerm intValue]) {
										actualPremium = actualPremium - ((waiverRiderSA *  tempRiderSA/100)/100) * [tempTempHL doubleValue];
									}
									
								}
								*/
									//NSLog(@"%f", actualPremium);
								[tempCol1 addObject:[NSString stringWithFormat:@"%.2f", actualPremium]];
								[tempCol2 addObject:[NSString stringWithFormat:@"%.3f", tempRiderSA]];
								[tempCol3 addObject:[NSString stringWithFormat:@"%.3f", [[Rate objectAtIndex:i ]doubleValue ] * tempRiderSA/100.00 ]];
								[tempCol4 addObject:[NSString stringWithFormat:@"-"]];
								
								if (i == 1) {
									/*
									[gWaiverAnnual addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSA *  tempRiderSA/100.00] ];
									[gWaiverSemiAnnual addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSASemiAnnual *  tempRiderSA/100.00] ];
									[gWaiverQuarterly addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSAQuarterly *  tempRiderSA/100.00] ];
									[gWaiverMonthly addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSAMonthly *  tempRiderSA/100.00] ];
									*/
								}
								
							}
							
							else if ([tempRiderCode isEqualToString:@"LSR"]) { 
								
								if (i == 0) {
									if (sqlite3_open([UL_RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK){
										QuerySQL = [NSString stringWithFormat:@"Select rate from Trad_Sys_Rider_CSV Where plancode = \"%@\" AND FromAge = \"%d\" AND PolYear = \"%d\""
													, tempRiderCode, Age, i + 1 ];
										
										if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
											while (sqlite3_step(statement) == SQLITE_ROW) {
												[Rate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
												
											}
											sqlite3_finalize(statement);
										}
										sqlite3_close(contactDB);
									}
									
									if (Rate.count < 30) {
										
										int rowsToAdd = 30 - Rate.count;
										for (int u =0; u<rowsToAdd; u++) {
											[Rate addObject:@"0.00"];
										}
									}
								}
								
								double actualPremium = 0.0;
								if([tempHL isEqualToString:@"(null)"] || [tempHL isEqualToString:@"0"] || [tempHL isEqualToString:@""] ) {
									actualPremium = tempPremium;
								}
								else{
									if(i + 1 <= [tempHLTerm intValue ] ){
										actualPremium = tempPremium;
									}
									else{
										actualPremium = tempPremium - (tempRiderSA/1000) * [tempHL doubleValue];
									}
								}
								/*
								if (![tempTempHL isEqualToString:@"(null)"] ) {
									if (i + 1 > [tempTempHLTerm intValue]) {
										actualPremium = actualPremium - (tempRiderSA/1000) * [tempTempHL doubleValue];
									}
									
								}
								*/
								[tempCol1 addObject:[NSString stringWithFormat:@"%.2f", actualPremium]];
								[tempCol2 addObject:[NSString stringWithFormat:@"%.0f", tempRiderSA]];
								[tempCol3 addObject:[NSString stringWithFormat:@"%.3f", [[Rate objectAtIndex:i ]doubleValue ] * tempRiderSA/1000.00   ]];
								[tempCol4 addObject:[NSString stringWithFormat:@"-"]];
								
								tempTotalRiderSurrenderValue = [[TotalRiderSurrenderValue objectAtIndex:i] doubleValue ];
								tempTotalRiderSurrenderValue = tempTotalRiderSurrenderValue + [[tempCol2 objectAtIndex:i] doubleValue ];
								[TotalRiderSurrenderValue replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.3f", tempTotalRiderSurrenderValue]];
								
							}
							else {
								//no more rider 
							}
						}
						else {
							if ([tempRiderCode isEqualToString:@"CIWP"] || [tempRiderCode isEqualToString:@"TPDWP"] ||
									 [tempRiderCode isEqualToString:@"PR"] || [tempRiderCode isEqualToString:@"LCWP"]) {
								
								//[tempCol1 addObject:[NSString stringWithFormat:@"0.00", tempPremium]];
								[tempCol1 addObject:[NSString stringWithFormat:@"0.00"]];
								[tempCol2 addObject:[NSString stringWithFormat:@"0"]];
								[tempCol3 addObject:[NSString stringWithFormat:@"0"]];
								[tempCol4 addObject:[NSString stringWithFormat:@"-"]];
							}
							
							else if ([tempRiderCode isEqualToString:@"LSR"]) {
								
								[tempCol1 addObject:[NSString stringWithFormat:@"0.00"]];
								[tempCol2 addObject:[NSString stringWithFormat:@"0"] ];
								[tempCol3 addObject:[NSString stringWithFormat:@"0"]];
								[tempCol4 addObject:[NSString stringWithFormat:@"-"]];
							}
							else {
								[tempCol1 addObject:[NSString stringWithFormat:@"0.00"]];
								[tempCol2 addObject:[NSString stringWithFormat:@"-"]];
								[tempCol3 addObject:[NSString stringWithFormat:@"-"]];
								[tempCol4 addObject:[NSString stringWithFormat:@"-"]];
							}
							
						}
						
						//EntireTotalPremiumPaid = EntireTotalPremiumPaid + [[tempCol1 objectAtIndex:i + 3] doubleValue ]; //i +3 to skip the first 3 items
						
					}
                    
                    
					if (Rider == 0){
						for (int p =0; p < tempCol1.count; p++) {
							[RiderCol1 addObject:[tempCol1 objectAtIndex:p]];
							[RiderCol2 addObject:[tempCol2 objectAtIndex:p]];
							[RiderCol3 addObject:[tempCol3 objectAtIndex:p]];
							[RiderCol4 addObject:[tempCol4 objectAtIndex:p]];
						}
					}
					else if (Rider == 1){
						for (int p =0; p < tempCol1.count; p++) {
							[RiderCol5 addObject:[tempCol1 objectAtIndex:p]];
							[RiderCol6 addObject:[tempCol2 objectAtIndex:p]];
							[RiderCol7 addObject:[tempCol3 objectAtIndex:p]];
							[RiderCol8 addObject:[tempCol4 objectAtIndex:p]];
						}
					}
					else if (Rider == 2){
						for (int p =0; p < tempCol1.count; p++) {
							[RiderCol9 addObject:[tempCol1 objectAtIndex:p]];
							[RiderCol10 addObject:[tempCol2 objectAtIndex:p]];
							[RiderCol11 addObject:[tempCol3 objectAtIndex:p]];
							[RiderCol12 addObject:[tempCol4 objectAtIndex:p]];
						}
					}
                    
                    Rate = Nil;
                    tempRiderCode = Nil;
                    tempRiderDesc = Nil;
                    tempRiderPlanOption = Nil;
                    tempCol1 = Nil;
                    tempCol2 = Nil;
                    tempCol3 = Nil;
                    tempCol4 = Nil;
                    
                }
                else {
                    if (Rider == 1) {
                        for (int row = 0; row < 30 + 2; row++){
                            [RiderCol5 addObject:@"-"];
                            [RiderCol6 addObject:@"-"];
                            [RiderCol7 addObject:@"-"];
                            [RiderCol8 addObject:@"-"];
                        }
                    }
                    if (Rider == 2) {
                        for (int row = 0; row < 30 + 2; row++){
                            [RiderCol9 addObject:@"-"];
                            [RiderCol10 addObject:@"-"];
                            [RiderCol11 addObject:@"-"];
                            [RiderCol12 addObject:@"-"];
                        }
                    }
                }
                
                
            }
            
            if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                QuerySQL = [NSString stringWithFormat:@"Insert INTO UL_Temp_Trad_Rider(\"SINO\", \"SeqNo\", \"DataType\", \"PageNo\",\"col0_1\",\"col0_2\", "
                            " \"col1\",\"col2\",\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\" ) VALUES ("
                            " \"%@\", \"%d\", \"TITLE\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" "
                            " , \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" )", SINo, -2, page, @"", @"", [RiderCol1 objectAtIndex:0],[RiderCol2 objectAtIndex:0],
                            [RiderCol3 objectAtIndex:0],[RiderCol4 objectAtIndex:0],[RiderCol5 objectAtIndex:0],[RiderCol6 objectAtIndex:0],
                            [RiderCol7 objectAtIndex:0],[RiderCol8 objectAtIndex:0],[RiderCol9 objectAtIndex:0],[RiderCol10 objectAtIndex:0],
                            [RiderCol11 objectAtIndex:0],[RiderCol12 objectAtIndex:0]];
                
                
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
						
                    }
                    sqlite3_finalize(statement);
                }
                
                QuerySQL = [NSString stringWithFormat:@"Insert INTO UL_Temp_Trad_Rider(\"SINO\", \"SeqNo\", \"DataType\", \"PageNo\",\"col0_1\",\"col0_2\", "
                            " \"col1\",\"col2\",\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\" ) VALUES ("
                            " \"%@\", \"%d\", \"HEADER\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" "
                            " , \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" )", SINo, -1, page, @"Policy Year", @"Life Ass'd Age at the end of Year",
                            [RiderCol1 objectAtIndex:1],[RiderCol2 objectAtIndex:1],
                            [RiderCol3 objectAtIndex:1],[RiderCol4 objectAtIndex:1],[RiderCol5 objectAtIndex:1],[RiderCol6 objectAtIndex:1],
                            [RiderCol7 objectAtIndex:1],[RiderCol8 objectAtIndex:1],[RiderCol9 objectAtIndex:1],[RiderCol10 objectAtIndex:1],
                            [RiderCol11 objectAtIndex:1],[RiderCol12 objectAtIndex:1]];
                
                
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                    }
                    sqlite3_finalize(statement);
                }
                
                sqlite3_close(contactDB);
            }
            
            
            for (int j=1; j <= 30; j++) {
                
                if (j <= 30) {
					int currentAge = Age + j;
                    
                    NSString *strSeqNo = @"";
                    if (j < 10) {
                        strSeqNo = [NSString stringWithFormat:@"0%d", j];
                    }
                    else {
                        strSeqNo = [NSString stringWithFormat:@"%d", j];
                    }
                    
                    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
						
						NSString *value1 = [[RiderCol1 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.2f", [[RiderCol1 objectAtIndex:j + 1] doubleValue ]];
						NSString *value2 = [[RiderCol2 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol2 objectAtIndex:j + 1] doubleValue ])];
						NSString *value3 = [[RiderCol3 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol3 objectAtIndex:j + 1] doubleValue ])];
						NSString *value4 = [[RiderCol4 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol4 objectAtIndex:j + 1] doubleValue ])];
						NSString *value5 = [[RiderCol5 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.2f", [[RiderCol5 objectAtIndex:j + 1] doubleValue ]];
						NSString *value6 = [[RiderCol6 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol6 objectAtIndex:j + 1] doubleValue ])];
						NSString *value7 = [[RiderCol7 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol7 objectAtIndex:j + 1] doubleValue ])];
						NSString *value8 = [[RiderCol8 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol8 objectAtIndex:j + 1] doubleValue ])];
						NSString *value9 = [[RiderCol9 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.2f", [[RiderCol9 objectAtIndex:j + 1] doubleValue ]];
						NSString *value10 = [[RiderCol10 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol10 objectAtIndex:j + 1] doubleValue ])];
						NSString *value11 = [[RiderCol11 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol11 objectAtIndex:j + 1] doubleValue ])];
						NSString *value12 = [[RiderCol12 objectAtIndex:j + 1] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol12 objectAtIndex:j + 1] doubleValue ])];
						
						
						QuerySQL = [NSString stringWithFormat:@"Insert INTO UL_Temp_Trad_Rider(\"SINO\", \"SeqNo\", \"DataType\", \"PageNo\",\"col0_1\",\"col0_2\", "
									" \"col1\",\"col2\",\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\" ) VALUES ("
									" \"%@\", \"%@\", \"DATA\", \"%d\", \"%d\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" "
									" , \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" )", SINo, strSeqNo , page, j, currentAge, value1,value2,
									value3,value4,value5,value6,value7, value8, value9, value10, value11, value12];
						
						
						if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
							if (sqlite3_step(statement) == SQLITE_DONE) {
								
							}
							sqlite3_finalize(statement);
						}
						
                        value1 = Nil;
                        value2 = Nil;
                        value3 = Nil;
                        value4 = Nil;
                        value5 = Nil;
                        value6 = Nil;
                        value7 = Nil;
                        value8 = Nil;
                        value9 = Nil;
                        value10 = Nil;
                        value11 = Nil;
                        value12 = Nil;
                        
						sqlite3_close(contactDB);
					}
					strSeqNo = Nil;
                }
            }
			
			
            RiderCol1 = Nil;
            RiderCol2 = Nil;
            RiderCol3 = Nil;
            RiderCol4 = Nil;
            RiderCol5 = Nil;
            RiderCol6 = Nil;
            RiderCol7 = Nil;
            RiderCol8 = Nil;
            RiderCol9 = Nil;
            RiderCol10 = Nil;
            RiderCol11 = Nil;
            RiderCol12 = Nil;
            
        }
        /*
		if ([PDSorSI isEqualToString:@"SI"]) {
			for (int v= 0; v < PolicyTerm; v ++) {
				double tempA;
				double tempB;
				tempA = [[SummaryNonGuaranteedSurrenderValueA objectAtIndex:v] doubleValue ];
				tempA = tempA + [[TotalRiderSurrenderValue objectAtIndex:v] doubleValue ];
				[SummaryNonGuaranteedSurrenderValueA replaceObjectAtIndex:v withObject: [NSString stringWithFormat:@"%.3f", tempA]];
				
				tempB = [[SummaryNonGuaranteedSurrenderValueB objectAtIndex:v] doubleValue ];
				tempB = tempB + [[TotalRiderSurrenderValue objectAtIndex:v] doubleValue ];
				[SummaryNonGuaranteedSurrenderValueB replaceObjectAtIndex:v withObject: [NSString stringWithFormat:@"%.3f", tempB]];
				
				if (v  == PolicyTerm - 1) {
					// EntireMaturityValueA = EntireMaturityValueA + [[SummaryNonGuaranteedSurrenderValueA objectAtIndex:v] doubleValue ];
					// EntireMaturityValueB = EntireMaturityValueB + [[SummaryNonGuaranteedSurrenderValueB objectAtIndex:v] doubleValue ];
				}
				
			}
		}
        */
        
    }
    
    NSLog(@"insert to UL_Temp_Trad_Rider --- End");
    statement = Nil;
    QuerySQL = Nil;
    TotalRiderSurrenderValue = Nil;
	
}


-(void)GetRTUPData{
	sqlite3_stmt *statement;
	NSString *querySQL;
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
		querySQL = [NSString stringWithFormat:@"SELECT FromYear, ForYear, Amount WHERE SINo=\"%@\"",SINo];
		
		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			if (sqlite3_step(statement) == SQLITE_ROW) {
				strRTUPFrom = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0) - 1];
				strRTUPFor = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 1) + 1];
				strRTUPAmount = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
			}
			else{
				strRTUPFrom = @"";
				strRTUPFor = @"";
				strRTUPAmount = @"";
			}
			
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
}

-(void)PopulateData{
	sqlite3_stmt *statement;
	NSString *querySQL;
	
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
	
		
	querySQL = [NSString stringWithFormat:@"SELECT fund, option, partial_withd_pct, EverGreen2025, EverGreen2028, "
				"EverGreen2030, EverGreen2035, CashFund, RetireFund FROM UL_fund_maturity_option WHERE SINo=\"%@\"",SINo];
	
	Fund2023PartialReinvest = 100.00; //means fully withdraw
	Fund2025PartialReinvest = 100.00;
	Fund2028PartialReinvest = 100.00;
	Fund2030PartialReinvest = 100.00;
	Fund2035PartialReinvest = 100.00;
	//NSLog(@"%@", querySQL);
	if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		while (sqlite3_step(statement) == SQLITE_ROW)
		{
			if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"HLA EverGreen 2023"]) {
				if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"ReInvest"]) {
					Fund2023PartialReinvest = 0;
					Fund2023ReinvestTo2025Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)] doubleValue ] ;
					Fund2023ReinvestTo2028Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] doubleValue ] ;
					Fund2023ReinvestTo2030Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] doubleValue ] ;
					Fund2023ReinvestTo2035Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] doubleValue ] ;
					Fund2023ReinvestToCashFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] doubleValue ] ;
					Fund2023ReinvestToRetFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] doubleValue ] ;
				}
				else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"Partial"]) {
					Fund2023PartialReinvest = 100 - [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] doubleValue ] ;
					Fund2023ReinvestTo2025Fac =  [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)] doubleValue ] ;
					Fund2023ReinvestTo2028Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] doubleValue ] ;
					Fund2023ReinvestTo2030Fac =  [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] doubleValue ] ;
					Fund2023ReinvestTo2035Fac =  [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] doubleValue ] ;
					Fund2023ReinvestToCashFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] doubleValue ] ;
					Fund2023ReinvestToRetFac =  [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] doubleValue ] ;
				}
				else{
					Fund2023PartialReinvest = 100;
				}
			}
			else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"HLA EverGreen 2025"]) {
				if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"ReInvest"]) {
					Fund2025PartialReinvest = 0;
					Fund2025ReinvestTo2028Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] doubleValue ] ;
					Fund2025ReinvestTo2030Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] doubleValue ] ;
					Fund2025ReinvestTo2035Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] doubleValue ] ;
					Fund2025ReinvestToCashFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] doubleValue ] ;
					Fund2025ReinvestToRetFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] doubleValue ] ;
				}
				else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"Partial"]) {
					Fund2025PartialReinvest = 100 -  [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] doubleValue ] ;
					Fund2025ReinvestTo2028Fac =  [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] doubleValue ] ;
					Fund2025ReinvestTo2030Fac =  [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] doubleValue ] ;
					Fund2025ReinvestTo2035Fac =  [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] doubleValue ] ;
					Fund2025ReinvestToCashFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] doubleValue ] ;
					Fund2025ReinvestToRetFac =  [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] doubleValue ] ;
				}
				else{
					Fund2025PartialReinvest = 100;
				}
			}
			else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"HLA EverGreen 2028"]) {
				if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"ReInvest"]) {
					Fund2028PartialReinvest = 0;
					Fund2028ReinvestTo2030Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] doubleValue ] ;
					Fund2028ReinvestTo2035Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] doubleValue ] ;
					Fund2028ReinvestToCashFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] doubleValue ] ;
					Fund2028ReinvestToRetFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] doubleValue ] ;
				}
				else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"Partial"]) {
					Fund2028PartialReinvest = 100 - [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] doubleValue ] ;
					Fund2028ReinvestTo2030Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] doubleValue ] ;
					Fund2028ReinvestTo2035Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] doubleValue ] ;
					Fund2028ReinvestToCashFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] doubleValue ] ;
					Fund2028ReinvestToRetFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] doubleValue ] ;
				}
				else{
					Fund2028PartialReinvest = 100;
				}
			}
			else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"HLA EverGreen 2030"]) {
				if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"ReInvest"]) {
					Fund2030PartialReinvest = 0;
					Fund2030ReinvestTo2035Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] doubleValue ] ;
					Fund2030ReinvestToCashFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] doubleValue ] ;
					Fund2030ReinvestToRetFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] doubleValue ] ;
				}
				else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"Partial"]) {
					Fund2030PartialReinvest = 100 -  [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] doubleValue ] ;
					Fund2030ReinvestTo2035Fac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] doubleValue ] ;
					Fund2030ReinvestToCashFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] doubleValue ] ;
					Fund2030ReinvestToRetFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] doubleValue ] ;
				}
				else{
					Fund2030PartialReinvest = 100;
				}
			}
			else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"HLA EverGreen 2035"]) {
				if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"ReInvest"]) {
					Fund2035PartialReinvest = 0;
					Fund2035ReinvestToCashFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] doubleValue ] ;
					Fund2035ReinvestToRetFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] doubleValue ] ;
				}
				else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"Partial"]) {
					Fund2035PartialReinvest =  100 - [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] doubleValue ] ;
					Fund2035ReinvestToCashFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)] doubleValue ] ;
					Fund2035ReinvestToRetFac = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] doubleValue ] ;
					
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

-(double)CalculateBUMP{
	double FirstBasicMort = [self ReturnBasicMort:Age]/1000.00;
	double FirstSA = BasicSA;
	double SecondBasicMort = [self ReturnBasicMort:Age + 1]/1000.00;
	double SecondSA = 0;
	double ThirdBasicMort = [self ReturnBasicMort:Age + 2]/1000.00;
	double BUMP1;
	double BUMP2;
	
	//NSLog(@"%f, %f, %f", FirstBasicMort, SecondBasicMort, ThirdBasicMort);
	
	//[self getExistingBasic]; //disable as it will change getbumpmode
	[self CalcInst:@""];
	[self GetRegWithdrawal];
	[self ReturnFundFactor]; // get factor for each fund
	[self CalcYearDiff]; //get the yearDiff
	[self SurrenderValue:2 andMonth:0 andLevel:0];
	SecondSA = BasicSA - HSurrenderValue;
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
	
	double ModeRate = [self ReturnModeRate:strBumpMode];
	double divideMode = [self ReturnDivideMode];
	double PremAllocation = [self ReturnPremAllocation:1];
	double ExcessPrem =  [self ReturnExcessPrem:1];
	
		//NSLog(@" %f,%f,%f,%f, %f", MortDate, ModeRate, divideMode, PremAllocation, ExcessPrem);
	double FirstBasicSA =  (FirstSA * ((FirstBasicMort * MortDate + SecondBasicMort * (12 - MortDate))/12.00 * (1 + [getHLPct intValue]/100.00 ) +
									   ([getHL doubleValue] /1000.00) + ([getOccLoading doubleValue ]/1000.00)));
	
	double SecondBasicSA =  (SecondSA * ((SecondBasicMort * MortDate + ThirdBasicMort * (12 - MortDate))/12.00 * (1 + [getHLPct intValue]/100.00 ) +
										 ([getHL doubleValue] /1000.00) + ([getOccLoading doubleValue ]/1000.00)));
	
	//NSLog(@"%f %f ", FirstBasicSA, SecondBasicSA);
	BUMP1 = (ModeRate * (PremAllocation * ([strBasicPremium doubleValue ] * divideMode) +
						 (0.95 * (ExcessPrem + [strRTUPAmount doubleValue ]))) -
			 (((PolicyFee * 12) + FirstBasicSA + 0) * 12.5/12.00))/divideMode;
	
	BUMP2 = (ModeRate * ([self ReturnPremAllocation:2] * ([strBasicPremium doubleValue ] * divideMode) +
						 (0.95 * ([self ReturnExcessPrem:2] + [strRTUPAmount doubleValue ]))) -
			 (((PolicyFee * 12) + SecondBasicSA + 0) * 12.5/12.00))/divideMode;
	
	
	if (BUMP1 < 0.00) {
		PremReq = ((((0.01 * divideMode) + (((PolicyFee * 12) + FirstBasicSA + 0) * 12.5/12.00))/ModeRate -
					(0.95 * (ExcessPrem + [strRTUPAmount doubleValue ])))/PremAllocation)/divideMode;
	}
	
	NSLog(@"bump1 = %f, bump2 = %f", BUMP1, BUMP2);
	NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
	[format setNumberStyle:NSNumberFormatterDecimalStyle];
	[format setRoundingMode:NSNumberFormatterRoundHalfUp];
	[format setMaximumFractionDigits:2];
	[self ResetData];
	
	/*
	for (int i =1; i <= 30 ; i++) {
		
		VUCashValueNegative = false;
		if (i == YearDiff2023 || i == YearDiff2025 || i == YearDiff2028 || i == YearDiff2030 || i == YearDiff2035) {
			for (int m = 1; m <= 12; m++) {
				
				MonthFundValueOfTheYearValueTotalHigh = [self ReturnMonthFundValueOfTheYearValueTotalHigh:i andMonth:m];
				//NSLog(@"%d %f %f %f", m, MonthVURetValueHigh, MonthVU2035ValueHigh, MonthFundValueOfTheYearValueTotalHigh );
				[self SurrenderValue:i andMonth:m andLevel:1];
				
				
				MonthFundValueOfTheYearValueTotalMedian = [self ReturnMonthFundValueOfTheYearValueTotalMedian:i andMonth:m];
				[self SurrenderValue:i andMonth:m andLevel:2];
				
				
				MonthFundValueOfTheYearValueTotalLow = [self ReturnMonthFundValueOfTheYearValueTotalLow:i andMonth:m];
				//NSLog(@"%d %f %f %f", m, MonthVURetValueLow, MonthVU2035ValueLow, MonthFundValueOfTheYearValueTotalLow );
				[self SurrenderValue:i andMonth:m andLevel:3];
				
			}
			
		}
		else{
			VUCashValueNegative = false;
			FundValueOfTheYearValueTotalHigh = [self ReturnFundValueOfTheYearValueTotalHigh:i];
			FundValueOfTheYearValueTotalMedian = [self ReturnFundValueOfTheYearValueTotalMedian:i];
			FundValueOfTheYearValueTotalLow = [self ReturnFundValueOfTheYearValueTotalLow:i];
			[self SurrenderValue:i andMonth:0 andLevel:0];
		}
		
		
		
		NSLog(@"%d) %f, %f, %f",i, HSurrenderValue, MSurrenderValue, LSurrenderValue );
		NSLog(@"%d) %f,%f,%f,%f,%f,%f,%f", i, VUCashValueHigh,VURetValueHigh,VU2023ValueHigh, VU2025ValueHigh,VU2028ValueHigh, VU2030ValueHigh, VU2035ValueHigh);
		//NSLog(@"%d) %f,%f,%f,%f,%f,%f,%f", i, VUCashValueLow,VURetValueLow,VU2023ValueLow, VU2025ValueLow,VU2028ValueLow, VU2030ValueLow, VU2035ValueLow);
		
	}
	*/
	if (BUMP1 > BUMP2) {
		return [[NSString stringWithFormat:@"%@", [format stringFromNumber:[NSNumber numberWithFloat:BUMP2]]] doubleValue ];
	}
	else{
		//return [[NSString stringWithFormat:@"%.2f", BUMP1] doubleValue ];
		return [[NSString stringWithFormat:@"%@", [format stringFromNumber:[NSNumber numberWithFloat:BUMP1]]] doubleValue ];
	}
	
	
	
}

-(void)ResetData{
	VUCashPrevValueHigh =0;
	VURetPrevValueHigh  =0;
	VU2023PrevValuehigh = 0;
	VU2025PrevValuehigh =0;
	VU2028PrevValuehigh =0;
	VU2030PrevValuehigh = 0;
	VU2035PrevValuehigh = 0;
	RiderVUCashPrevValueHigh =0;
	RiderVURetPrevValueHigh  =0;
	RiderVU2023PrevValuehigh = 0;
	RiderVU2025PrevValuehigh =0;
	RiderVU2028PrevValuehigh =0;
	RiderVU2030PrevValuehigh = 0;
	RiderVU2035PrevValuehigh = 0;

	
	VUCashPrevValueMedian =0;
	VURetPrevValueMedian  =0;
	VU2023PrevValueMedian = 0;
	VU2025PrevValueMedian =0;
	VU2028PrevValueMedian =0;
	VU2030PrevValueMedian = 0;
	VU2035PrevValueMedian = 0;
	RiderVUCashPrevValueMedian =0;
	RiderVURetPrevValueMedian  =0;
	RiderVU2023PrevValueMedian = 0;
	RiderVU2025PrevValueMedian =0;
	RiderVU2028PrevValueMedian =0;
	RiderVU2030PrevValueMedian = 0;
	RiderVU2035PrevValueMedian = 0;
	
	VUCashPrevValueLow =0;
	VURetPrevValueLow  =0;
	VU2023PrevValueLow = 0;
	VU2025PrevValueLow =0;
	VU2028PrevValueLow =0;
	VU2030PrevValueLow = 0;
	VU2035PrevValueLow = 0;
	RiderVUCashPrevValueLow =0;
	RiderVURetPrevValueLow  =0;
	RiderVU2023PrevValueLow = 0;
	RiderVU2025PrevValueLow =0;
	RiderVU2028PrevValueLow =0;
	RiderVU2030PrevValueLow = 0;
	RiderVU2035PrevValueLow = 0;
	
	MonthVUCashPrevValueHigh =0;
	MonthVURetPrevValueHigh  =0;
	MonthVU2023PrevValuehigh = 0;
	MonthVU2025PrevValuehigh =0;
	MonthVU2028PrevValuehigh =0;
	MonthVU2030PrevValuehigh = 0;
	MonthVU2035PrevValuehigh = 0;
	RiderMonthVUCashPrevValueHigh =0;
	RiderMonthVURetPrevValueHigh  =0;
	RiderMonthVU2023PrevValuehigh = 0;
	RiderMonthVU2025PrevValuehigh =0;
	RiderMonthVU2028PrevValuehigh =0;
	RiderMonthVU2030PrevValuehigh = 0;
	RiderMonthVU2035PrevValuehigh = 0;
	
	MonthVUCashPrevValueMedian =0;
	MonthVURetPrevValueMedian  =0;
	MonthVU2023PrevValueMedian = 0;
	MonthVU2025PrevValueMedian =0;
	MonthVU2028PrevValueMedian =0;
	MonthVU2030PrevValueMedian = 0;
	MonthVU2035PrevValueMedian = 0;
	RiderMonthVUCashPrevValueMedian =0;
	RiderMonthVURetPrevValueMedian  =0;
	RiderMonthVU2023PrevValueMedian = 0;
	RiderMonthVU2025PrevValueMedian =0;
	RiderMonthVU2028PrevValueMedian =0;
	RiderMonthVU2030PrevValueMedian = 0;
	RiderMonthVU2035PrevValueMedian = 0;
	
	MonthVUCashPrevValueLow =0;
	MonthVURetPrevValueLow  =0;
	MonthVU2023PrevValueLow = 0;
	MonthVU2025PrevValueLow =0;
	MonthVU2028PrevValueLow =0;
	MonthVU2030PrevValueLow = 0;
	MonthVU2035PrevValueLow = 0;
	RiderMonthVUCashPrevValueLow =0;
	RiderMonthVURetPrevValueLow  =0;
	RiderMonthVU2023PrevValueLow = 0;
	RiderMonthVU2025PrevValueLow =0;
	RiderMonthVU2028PrevValueLow =0;
	RiderMonthVU2030PrevValueLow = 0;
	RiderMonthVU2035PrevValueLow = 0;
	
	temp2023High = 0;
	temp2023Median= 0;
	temp2023Low = 0;
	temp2025High = 0;
	temp2025Median = 0;
	temp2025Low = 0;
	temp2028High = 0;
	temp2028Median = 0;
	temp2028Low = 0;
	temp2030High = 0;
	temp2030Median = 0;
	temp2030Low = 0;
	temp2035High = 0;
	temp2035Median = 0;
	temp2035Low = 0;
	Ridertemp2023High = 0;
	Ridertemp2023Median= 0;
	Ridertemp2023Low = 0;
	Ridertemp2025High = 0;
	Ridertemp2025Median = 0;
	Ridertemp2025Low = 0;
	Ridertemp2028High = 0;
	Ridertemp2028Median = 0;
	Ridertemp2028Low = 0;
	Ridertemp2030High = 0;
	Ridertemp2030Median = 0;
	Ridertemp2030Low = 0;
	Ridertemp2035High = 0;
	Ridertemp2035Median = 0;
	Ridertemp2035Low = 0;
}

#pragma mark - Surrender Value Calculation for basic
-(void)SurrenderValue :(int)aaPolicyYear andMonth:(int)aaMonth andLevel:(int)aaLevel{
	if (aaPolicyYear == YearDiff2023 || aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2028 || aaPolicyYear == YearDiff2030 ||
		aaPolicyYear == YearDiff2035) {
		//month
		if (aaLevel == 1) {
			HSurrenderValue = [self ReturnHSurrenderValue:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth ];
			
		}
		else if (aaLevel == 2){
			MSurrenderValue = [self ReturnMSurrenderValue:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth ];
			
		}
		else if (aaLevel == 3){
			LSurrenderValue = [self ReturnLSurrenderValue:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth ];
			
		}
		else{
			
		}
		
		if (aaLevel == 1) {
			HRiderSurrenderValue = [self ReturnRiderHSurrenderValue:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth ];;
		}
		else if (aaLevel == 2){
			MRiderSurrenderValue = [self ReturnRiderMSurrenderValue:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth ];
		}
		else if (aaLevel == 3){
			LRiderSurrenderValue = [self ReturnRiderLSurrenderValue:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth ];
		}
		
		
	} else {
		//year
		HSurrenderValue = [self ReturnHSurrenderValue:aaPolicyYear andYearOrMonth:@"Y" andMonth:0 ];
		MSurrenderValue = [self ReturnMSurrenderValue:aaPolicyYear andYearOrMonth:@"Y" andMonth:0 ];
		LSurrenderValue = [self ReturnLSurrenderValue:aaPolicyYear andYearOrMonth:@"Y" andMonth:0 ];
		HRiderSurrenderValue = [self ReturnRiderHSurrenderValue:aaPolicyYear andYearOrMonth:@"Y" andMonth:0 ];
		MRiderSurrenderValue = [self ReturnRiderMSurrenderValue:aaPolicyYear andYearOrMonth:@"Y" andMonth:0 ];
		LRiderSurrenderValue = [self ReturnRiderLSurrenderValue:aaPolicyYear andYearOrMonth:@"Y" andMonth:0 ];
	}
	/*
	 if (aaPolicyYear == YearDiff2035) {
	 //HSurrenderValue = HSurrenderValue - MonthFundMaturityValue2035_Bull;
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
	 */
	
	
}

-(double)ReturnHSurrenderValue :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth {
	//NSLog(@"%f", [self ReturnVUCashValueHigh:aaPolicyYear]);
	
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		
		VUCashValueHigh = [self ReturnVUCashValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:aaMonth];
		VURetValueHigh = [self ReturnVURetValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2023ValueHigh = [self ReturnVU2023ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2025ValueHigh = [self ReturnVU2025ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2028ValueHigh = [self ReturnVU2028ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2030ValueHigh = [self ReturnVU2030ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2035ValueHigh = [self ReturnVU2035ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		
		
		/*
		 VU2023ValueHigh = [self ReturnVU2023ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 VU2025ValueHigh = [self ReturnVU2025ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 VU2028ValueHigh = [self ReturnVU2028ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 VU2030ValueHigh = [self ReturnVU2030ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 VU2035ValueHigh = [self ReturnVU2035ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 VUCashValueHigh = [self ReturnVUCashValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth];
		 VURetValueHigh = [self ReturnVURetValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 */
		
	}
	else{
		VUCashValueHigh = [self ReturnVUCashValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:0];
		VURetValueHigh = [self ReturnVURetValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2023ValueHigh = [self ReturnVU2023ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2025ValueHigh = [self ReturnVU2025ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2028ValueHigh = [self ReturnVU2028ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2030ValueHigh = [self ReturnVU2030ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2035ValueHigh = [self ReturnVU2035ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
	}
	
	
	
	if (VUCashValueHigh == 1 && VU2023ValueHigh == 0 && VU2025ValueHigh == 0 && VU2028ValueHigh == 0 &&
		VU2030ValueHigh == 0 && VU2035ValueHigh == 0 && VURetValueHigh == 0) {
		return 0;
	} else {
		return VU2023ValueHigh + VU2025ValueHigh + VU2028ValueHigh + VU2030ValueHigh + VU2035ValueHigh +
		VUCashValueHigh + VURetValueHigh;
	}
	
}





-(double)ReturnMSurrenderValue :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth {
	//NSLog(@"%f", [self ReturnVUCashValueHigh:aaPolicyYear]);
	
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		
		VUCashValueMedian = [self ReturnVUCashValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:aaMonth];
		VURetValueMedian = [self ReturnVURetValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2023ValueMedian = [self ReturnVU2023ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2025ValueMedian = [self ReturnVU2025ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2028ValueMedian = [self ReturnVU2028ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2030ValueMedian = [self ReturnVU2030ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2035ValueMedian = [self ReturnVU2035ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		
	}
	else{
		VUCashValueMedian = [self ReturnVUCashValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:0];
		VURetValueMedian = [self ReturnVURetValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2023ValueMedian = [self ReturnVU2023ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2025ValueMedian = [self ReturnVU2025ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2028ValueMedian = [self ReturnVU2028ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2030ValueMedian = [self ReturnVU2030ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2035ValueMedian = [self ReturnVU2035ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		
	}
	
	
	
	if (VUCashValueMedian == 1 && VU2023ValueMedian == 0 && VU2025ValueMedian == 0 && VU2028ValueMedian == 0 &&
		VU2030ValueMedian == 0 && VU2035ValueMedian == 0 && VURetValueMedian == 0) {
		return 0;
	} else {
		//NSLog(@"%f,%f,%f,%f,%f,%f,%f", VUCashValueMedian,VURetValueMedian,VU2023ValueMedian, VU2025ValueMedian,VU2028ValueMedian, VU2030ValueMedian, VU2035ValueMedian);
		return VU2023ValueMedian + VU2025ValueMedian + VU2028ValueMedian + VU2030ValueMedian + VU2035ValueMedian +
		VUCashValueMedian + VURetValueMedian;
		
	}
	
}

-(double)ReturnLSurrenderValue :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth {
	//NSLog(@"%f", [self ReturnVUCashValueHigh:aaPolicyYear]);
	
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		
		VUCashValueLow = [self ReturnVUCashValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:aaMonth];
		VURetValueLow = [self ReturnVURetValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2023ValueLow = [self ReturnVU2023ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2025ValueLow = [self ReturnVU2025ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2028ValueLow = [self ReturnVU2028ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2030ValueLow = [self ReturnVU2030ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		VU2035ValueLow = [self ReturnVU2035ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		
		
	}
	else{
		VUCashValueLow = [self ReturnVUCashValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:0];
		VURetValueLow = [self ReturnVURetValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2023ValueLow = [self ReturnVU2023ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2025ValueLow = [self ReturnVU2025ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2028ValueLow = [self ReturnVU2028ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2030ValueLow = [self ReturnVU2030ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		VU2035ValueLow = [self ReturnVU2035ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		
	}
	
	
	
	if (VUCashValueLow == 1 && VU2023ValueLow == 0 && VU2025ValueLow == 0 && VU2028ValueLow == 0 &&
		VU2030ValueLow == 0 && VU2035ValueLow == 0 && VURetValueLow == 0) {
		return 0;
	} else {
		return VU2023ValueLow + VU2025ValueLow + VU2028ValueLow + VU2030ValueLow + VU2035ValueLow +
		VUCashValueLow + VURetValueLow;
		
	}
	
}

#pragma mark - Surrender Value Calculation for Rider

-(double)ReturnRiderHSurrenderValue :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth {
	//NSLog(@"%f", [self ReturnVUCashValueHigh:aaPolicyYear]);
	
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		
		RiderVUCashValueHigh = [self ReturnRiderVUCashValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:aaMonth];
		RiderVURetValueHigh = [self ReturnRiderVURetValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2023ValueHigh = [self ReturnRiderVU2023ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2025ValueHigh = [self ReturnRiderVU2025ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2028ValueHigh = [self ReturnRiderVU2028ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2030ValueHigh = [self ReturnRiderVU2030ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2035ValueHigh = [self ReturnRiderVU2035ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		
		
		/*
		 VU2023ValueHigh = [self ReturnVU2023ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 VU2025ValueHigh = [self ReturnVU2025ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 VU2028ValueHigh = [self ReturnVU2028ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 VU2030ValueHigh = [self ReturnVU2030ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 VU2035ValueHigh = [self ReturnVU2035ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 VUCashValueHigh = [self ReturnVUCashValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth];
		 VURetValueHigh = [self ReturnVURetValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2];
		 */
		
	}
	else{
		RiderVUCashValueHigh = [self ReturnRiderVUCashValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:0];
		RiderVURetValueHigh = [self ReturnRiderVURetValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2023ValueHigh = [self ReturnRiderVU2023ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2025ValueHigh = [self ReturnRiderVU2025ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2028ValueHigh = [self ReturnRiderVU2028ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2030ValueHigh = [self ReturnRiderVU2030ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2035ValueHigh = [self ReturnRiderVU2035ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
	}
	
	
	
	if (RiderVUCashValueHigh == 1 && RiderVU2023ValueHigh == 0 && RiderVU2025ValueHigh == 0 && RiderVU2028ValueHigh == 0 &&
		RiderVU2030ValueHigh == 0 && RiderVU2035ValueHigh == 0 && RiderVURetValueHigh == 0) {
		return 0;
	} else {
		return RiderVU2023ValueHigh + RiderVU2025ValueHigh + RiderVU2028ValueHigh + RiderVU2030ValueHigh + RiderVU2035ValueHigh +
		RiderVUCashValueHigh + RiderVURetValueHigh;
	}
	
}





-(double)ReturnRiderMSurrenderValue :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth {
	//NSLog(@"%f", [self ReturnVUCashValueHigh:aaPolicyYear]);
	
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		
		RiderVUCashValueMedian = [self ReturnRiderVUCashValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:aaMonth];
		RiderVURetValueMedian = [self ReturnRiderVURetValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2023ValueMedian = [self ReturnRiderVU2023ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2025ValueMedian = [self ReturnRiderVU2025ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2028ValueMedian = [self ReturnRiderVU2028ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2030ValueMedian = [self ReturnRiderVU2030ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2035ValueMedian = [self ReturnRiderVU2035ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		
	}
	else{
		RiderVUCashValueMedian = [self ReturnRiderVUCashValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:0];
		RiderVURetValueMedian = [self ReturnRiderVURetValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2023ValueMedian = [self ReturnRiderVU2023ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2025ValueMedian = [self ReturnRiderVU2025ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2028ValueMedian = [self ReturnRiderVU2028ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2030ValueMedian = [self ReturnRiderVU2030ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2035ValueMedian = [self ReturnRiderVU2035ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		
	}
	
	
	
	if (RiderVUCashValueMedian == 1 && RiderVU2023ValueMedian == 0 && RiderVU2025ValueMedian == 0 && RiderVU2028ValueMedian == 0 &&
		RiderVU2030ValueMedian == 0 && RiderVU2035ValueMedian == 0 && RiderVURetValueMedian == 0) {
		return 0;
	} else {
		//NSLog(@"%f,%f,%f,%f,%f,%f,%f", VUCashValueMedian,VURetValueMedian,VU2023ValueMedian, VU2025ValueMedian,VU2028ValueMedian, VU2030ValueMedian, VU2035ValueMedian);
		return RiderVU2023ValueMedian + RiderVU2025ValueMedian + RiderVU2028ValueMedian + RiderVU2030ValueMedian + RiderVU2035ValueMedian +
		RiderVUCashValueMedian + RiderVURetValueMedian;
		
	}
	
}

-(double)ReturnRiderLSurrenderValue :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth {
	//NSLog(@"%f", [self ReturnVUCashValueHigh:aaPolicyYear]);
	
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		
		RiderVUCashValueLow = [self ReturnRiderVUCashValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:aaMonth];
		RiderVURetValueLow = [self ReturnRiderVURetValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2023ValueLow = [self ReturnRiderVU2023ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2025ValueLow = [self ReturnRiderVU2025ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2028ValueLow = [self ReturnRiderVU2028ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2030ValueLow = [self ReturnRiderVU2030ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		RiderVU2035ValueLow = [self ReturnRiderVU2035ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:aaMonth];
		
		
	}
	else{
		RiderVUCashValueLow = [self ReturnRiderVUCashValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andMonth:0];
		RiderVURetValueLow = [self ReturnRiderVURetValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2023ValueLow = [self ReturnRiderVU2023ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2025ValueLow = [self ReturnRiderVU2025ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2028ValueLow = [self ReturnRiderVU2028ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2030ValueLow = [self ReturnRiderVU2030ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		RiderVU2035ValueLow = [self ReturnRiderVU2035ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:2 andMonth:0];
		
	}
	
	
	
	if (RiderVUCashValueLow == 1 && RiderVU2023ValueLow == 0 && RiderVU2025ValueLow == 0 && RiderVU2028ValueLow == 0 &&
		RiderVU2030ValueLow == 0 && RiderVU2035ValueLow == 0 && RiderVURetValueLow == 0) {
		return 0;
	} else {
		return RiderVU2023ValueLow + RiderVU2025ValueLow + RiderVU2028ValueLow + RiderVU2030ValueLow + RiderVU2035ValueLow +
		RiderVUCashValueLow + RiderVURetValueLow;
		
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
-(double)ReturnVU2023ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(NSInteger)aaMonth{
	double currentValue;
	if (aaPolicyYear > YearDiff2023) {
		return 0.00;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			//month calculation
			
			
			if (aaMonth == 1) {
				MonthVU2023PrevValuehigh = VU2023PrevValuehigh;
			}
			
			if (aaMonth > MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				MonthVU2023PrevValuehigh = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2023PrevValuehigh;
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalHigh != 0 ) {
				
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:aaMonth] ) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				pow((1 + [self ReturnVU2023InstHigh:@"A" ]), (1.00/12.00)) + MonthVU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear] * [self ReturnLoyaltyBonusFactor:aaMonth]/100.00)) *
				pow((1 + [self ReturnVU2023InstHigh:@"A" ]), 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				(MonthVU2023ValueHigh/MonthFundValueOfTheYearValueTotalHigh);
				
			}
			else{
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:aaMonth]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				pow(1 + [self ReturnVU2023InstHigh:@"A" ], 1.00/12.00) + MonthVU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:aaMonth]/100.00)) *
				pow(1 + [self ReturnVU2023InstHigh:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			if (aaMonth == MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				if (Fund2023PartialReinvest != 100) {
					MonthFundMaturityValue2023_Bull = MonthVU2023PrevValuehigh * (100 - Fund2023PartialReinvest)/100.00;
					
					temp2023High = currentValue * (100 - Fund2023PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2023_Bull = 0;
				}
				
				if (aaRound == 2) {
					MonthVU2023PrevValuehigh = 0;
				}
				else{
					MonthVU2023PrevValuehigh = tempPrev;
				}
			}
			else{
				if (aaRound == 2) {
					MonthVU2023PrevValuehigh = currentValue;
				}
				else{
					MonthVU2023PrevValuehigh = tempPrev;
				}
			}
			
			if (aaMonth == 12 && aaRound == 2) {
				VU2023PrevValuehigh = MonthVU2023PrevValuehigh;
			}
			
			return currentValue;
			// below part to be edit later
		}
		else{
			//year calculation
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalHigh != 0 ) {
				
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				(1 + VU2023InstHigh) + VU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				(VU2023ValueHigh/FundValueOfTheYearValueTotalHigh);
				
			}
			else{
				if (aaRound == 1) {
					currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
					(1 + VU2023InstHigh) + VU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstHigh:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					VU2023ValueHigh = currentValue;
				}
				else{
					currentValue = VU2023ValueHigh;
				}
				
			}
			
			if (aaRound == 2){
				VU2023PrevValuehigh = currentValue;
			}
			
			return currentValue;
			// below part to be edit later
		}
		
	}
}

-(double)ReturnVU2023ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	double currentValue;
	if (aaPolicyYear > YearDiff2023) {
		return 0.00;
	}
	else{
		
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				MonthVU2023PrevValueMedian = VU2023PrevValueMedian;
			}
			
			if (i > MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				MonthVU2023PrevValueMedian = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2023PrevValueMedian;
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalMedian != 0 ) {
				
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00) + MonthVU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				(MonthVU2023ValueMedian/MonthFundValueOfTheYearValueTotalMedian);
				
			}
			else{
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2023Fac ] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00) + MonthVU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			if (i == MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				if (Fund2023PartialReinvest != 100) {
					MonthFundMaturityValue2023_Flat = MonthVU2023PrevValueMedian * (100 - Fund2023PartialReinvest)/100.00;
					
					temp2023Median = currentValue * (100 - Fund2023PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2023_Flat = 0;
				}
				
				if (aaRound == 2) {
					MonthVU2023PrevValueMedian = 0;
				}
				else{
					MonthVU2023PrevValueMedian = tempPrev;
				}
			}
			else{
				if (aaRound == 2) {
					MonthVU2023PrevValueMedian = currentValue;
				}
				else{
					MonthVU2023PrevValueMedian = tempPrev;
				}
				
			}
			
			
			if (i == 12 && aaRound == 2) {
				VU2023PrevValueMedian = MonthVU2023PrevValueMedian;
			}
			
			return currentValue;
			// below part to be edit later
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalMedian != 0 ) {
				
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				(1 + VU2023InstMedian) + VU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				(VU2023ValueMedian/FundValueOfTheYearValueTotalMedian);
				
			}
			else{
				if (aaRound == 1) {
					currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
					(1 + VU2023InstMedian) + VU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstMedian:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					VU2023ValueMedian = currentValue;
				}
				else{
					currentValue = VU2023ValueMedian;
				}
				
			}
			
			if (aaRound == 2){
				VU2023PrevValueMedian = currentValue;
			}
			
			return currentValue;
			// below part to be edit later
		}
		
	}
}

-(double)ReturnVU2023ValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	double currentValue;
	if (aaPolicyYear > YearDiff2023) {
		return 0.00;
	}
	else{
		
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				MonthVU2023PrevValueLow = VU2023PrevValueLow;
			}
			
			if (i > MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				MonthVU2023PrevValueLow = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2023PrevValueLow;
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalLow != 0 ) {
				
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				pow(1 + [self ReturnVU2023InstLow:@"A" ], 1.00/12.00) + MonthVU2023PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2023InstLow:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
				(MonthVU2023ValueLow/MonthFundValueOfTheYearValueTotalLow);
				
			}
			else{
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2023Fac ] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				pow(1 + [self ReturnVU2023InstLow:@"A" ], 1.00/12.00) + MonthVU2023PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2023InstLow:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			if (i == MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				if (Fund2023PartialReinvest != 100) {
					MonthFundMaturityValue2023_Bear = MonthVU2023PrevValueLow * (100 - Fund2023PartialReinvest)/100.00;
					
					temp2023Low = currentValue * (100 - Fund2023PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2023_Bear = 0;
				}
				if (aaRound == 2) {
					MonthVU2023PrevValueLow = 0;
				}
				else{
					MonthVU2023PrevValueLow = tempPrev;
				}
			}
			else{
				if (aaRound == 2) {
					MonthVU2023PrevValueLow = currentValue;
				}
				else{
					MonthVU2023PrevValueLow = tempPrev;
				}
			}
			
			if (i == 12 && aaRound == 2) {
				VU2023PrevValueLow = MonthVU2023PrevValueLow;
			}
			
			return currentValue;
			// below part to be edit later
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalLow != 0 ) {
				
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
				(1 + VU2023InstLow) + VU2023PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstLow:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
				(VU2023ValueLow/FundValueOfTheYearValueTotalLow);
				
			}
			else{
				
				if (aaRound == 1) {
					currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2023Fac] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2023Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
					(1 + VU2023InstLow) + VU2023PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstLow:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					VU2023ValueLow = currentValue ;
				}
				else{
					currentValue = VU2023ValueLow;
				}
				
			}
			
			if (aaRound == 2){
				VU2023PrevValueLow = currentValue;
			}
			
			return currentValue;
			// below part to be edit later
		}
		
	}
}


-(double)ReturnVU2025ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(NSInteger)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2025) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				MonthVU2025PrevValuehigh = VU2025PrevValuehigh;
			}
			
			if (i > MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				MonthVU2025PrevValuehigh = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2025PrevValuehigh;
			
			if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2025PrevValuehigh = MonthVU2025PrevValuehigh + (temp2023High * Fund2023ReinvestTo2025Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalHigh != 0 ) {
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00) + MonthVU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				(MonthVU2025ValueHigh/MonthFundValueOfTheYearValueTotalHigh);
			}
			else{
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00) + MonthVU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			if (i == MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				if (Fund2025PartialReinvest != 100) {
					MonthFundMaturityValue2025_Bull = MonthVU2025PrevValuehigh * (100 - Fund2025PartialReinvest)/100.00;
					
					temp2025High = currentValue * (100 - Fund2025PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2025_Bull = 0;
				}
				if (aaRound == 2){
					MonthVU2025PrevValuehigh = 0;
				}
				else{
					MonthVU2025PrevValuehigh = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2){
					MonthVU2025PrevValuehigh = currentValue;
				}
				else{
					MonthVU2025PrevValuehigh = tempPrev;
				}
				
			}
			
			
			if (aaRound == 2 && i == 12) {
				VU2025PrevValuehigh = MonthVU2025PrevValuehigh;
			}
			
			return currentValue;
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalHigh != 0 ) {
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				(1 + VU2025InstHigh) + VU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				(VU2025ValueHigh/FundValueOfTheYearValueTotalHigh);
				
				
			}
			else{
				
				if (aaRound == 1) {
					currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
					(1 + VU2025InstHigh) + VU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstHigh:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					
					VU2025ValueHigh = currentValue;
				}
				else{
					currentValue = VU2025ValueHigh;
				}
				
			}
			
			if (aaRound == 2) {
				VU2025PrevValuehigh = currentValue;
			}
			
			return currentValue;
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnVU2025ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2025) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			
			if (i == 1) {
				MonthVU2025PrevValueMedian = VU2025PrevValueMedian;
			}
			
			if (i > MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				MonthVU2025PrevValueMedian = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2025PrevValueMedian;
			
			if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2025PrevValueMedian = MonthVU2025PrevValueMedian + (temp2023Median * Fund2023ReinvestTo2025Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalMedian != 0 ) {
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00) + MonthVU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				(MonthVU2025ValueMedian/MonthFundValueOfTheYearValueTotalMedian);
			}
			else{
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00) + MonthVU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			if (i == MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				if (Fund2025PartialReinvest != 100) {
					MonthFundMaturityValue2025_Flat = MonthVU2025PrevValueMedian * (100 - Fund2025PartialReinvest)/100.00;
					
					temp2025Median = currentValue * (100 - Fund2025PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2025_Flat = 0;
				}
				if (aaRound == 2){
					MonthVU2025PrevValueMedian = 0;
				}
				else{
					MonthVU2025PrevValueMedian = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2){
					MonthVU2025PrevValueMedian = currentValue;
				}
				else{
					MonthVU2025PrevValueMedian = tempPrev;
				}
				
			}
			
			
			if (aaRound == 2 && i == 12) {
				VU2025PrevValueMedian = MonthVU2025PrevValueMedian;
			}
			
			
			return currentValue;
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalMedian != 0 ) {
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				(1 + VU2025InstMedian) + VU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				(VU2025ValueMedian/FundValueOfTheYearValueTotalMedian);
			}
			else{
				if (aaRound == 1) {
					currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
					(1 + VU2025InstMedian) + VU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstMedian:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					
					VU2025ValueMedian = currentValue;
				}
				else{
					currentValue = VU2025ValueMedian;
				}
				
			}
			
			if (aaRound == 2) {
				VU2025PrevValueMedian = currentValue;
			}
			
			return currentValue;
		}
		
	}
	
	// below part to be edit later
}


-(double)ReturnVU2025ValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2025) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			
			if (i == 1) {
				MonthVU2025PrevValueLow = VU2025PrevValueLow;
			}
			
			if (i > MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				MonthVU2025PrevValueLow = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2025PrevValueLow;
			
			if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2025PrevValueLow = MonthVU2025PrevValueLow + (temp2023Low * Fund2023ReinvestTo2025Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalLow != 0 ) {
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				pow(1 + [self ReturnVU2025InstLow:@"A" ], 1.00/12.00) + MonthVU2025PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstLow:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
				(MonthVU2025ValueLow/MonthFundValueOfTheYearValueTotalLow);
			}
			else{
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				pow(1 + [self ReturnVU2025InstLow:@"A" ], 1.00/12.00) + MonthVU2025PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstLow:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			if (i == MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				if (Fund2025PartialReinvest != 100) {
					MonthFundMaturityValue2025_Bear = MonthVU2025PrevValueLow * (100 - Fund2025PartialReinvest)/100.00;
					
					temp2025Low = currentValue * (100 - Fund2025PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2025_Bear = 0;
				}
				if (aaRound == 2){
					MonthVU2025PrevValueLow = 0;
				}
				else{
					MonthVU2025PrevValueLow = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2){
					MonthVU2025PrevValueLow = currentValue;
				}
				else{
					MonthVU2025PrevValueLow = tempPrev;
				}
				
			}
			
			if (aaRound == 2 && i == 12) {
				VU2025PrevValueLow = MonthVU2025PrevValueLow;
			}
			
			
			return currentValue;
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalLow != 0 ) {
				currentValue =((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
				(1 + VU2025InstLow) + VU2025PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstLow:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
				(VU2025ValueLow/FundValueOfTheYearValueTotalLow);
			}
			else{
				if (aaRound == 1) {
					currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] * CYFactor +
								   [self ReturnRegTopUpPrem] * RegularAllo * VU2025Factor * CYFactor +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2025Factor * CYFactor) *
					(1 + VU2025InstLow) + VU2025PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstLow:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					
					VU2025ValueLow = currentValue;
				}
				else{
					currentValue =VU2025ValueLow;
				}
			}
			
			if (aaRound == 2) {
				VU2025PrevValueLow = currentValue;
			}
			
			return currentValue;
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnVU2028ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2028) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				MonthVU2028PrevValuehigh = VU2028PrevValuehigh;
			}
			
			if (i > MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				MonthVU2028PrevValuehigh = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2028PrevValuehigh;
			if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				MonthVU2028PrevValuehigh = MonthVU2028PrevValuehigh + (temp2025High * Fund2025ReinvestTo2028Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2028PrevValuehigh = MonthVU2028PrevValuehigh + (temp2023High * Fund2023ReinvestTo2028Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalHigh != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
				pow(1 + [self ReturnVU2028InstHigh:@"A" ], 1.00/12.00) + MonthVU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				(MonthVU2028ValueHigh/MonthFundValueOfTheYearValueTotalHigh);
			}
			else{
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
				pow(1 + [self ReturnVU2028InstHigh:@"A" ], 1.00/12.00)+ MonthVU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			if (i == MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				if (Fund2028PartialReinvest != 100) {
					MonthFundMaturityValue2028_Bull = MonthVU2028PrevValuehigh * (100 - Fund2028PartialReinvest)/100.00;
					
					temp2028High = currentValue * (100 - Fund2028PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2028_Bull = 0;
				}
				if (aaRound == 2) {
					MonthVU2028PrevValuehigh = 0;
				}
				else{
					MonthVU2028PrevValuehigh = tempPrev;
				}
			}
			else{
				if (aaRound == 2) {
					MonthVU2028PrevValuehigh = currentValue;
				}
				else{
					MonthVU2028PrevValuehigh = tempPrev;
				}
				
			}
			
			if (i == 12 && aaRound == 2) {
				VU2028PrevValuehigh = MonthVU2028PrevValuehigh;
			}
			
			return currentValue;
			
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalHigh != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
				(1 + VU2028InstHigh) + VU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				(VU2028ValueHigh/FundValueOfTheYearValueTotalHigh);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
					(1 + VU2028InstHigh) + VU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstHigh:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					VU2028ValueHigh = currentValue;
				}
				else{
					currentValue = VU2028ValueHigh;
				}
				
			}
			
			if (aaRound == 2) {
				VU2028PrevValuehigh = currentValue;
			}
			
			return currentValue;
			
		}
		
	}
	
}

-(double)ReturnVU2028ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2028) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				MonthVU2028PrevValueMedian = VU2028PrevValueMedian;
			}
			
			if (i > MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				MonthVU2028PrevValueMedian = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2028PrevValueMedian;
			if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				MonthVU2028PrevValueMedian = MonthVU2028PrevValueMedian + (temp2025Median * Fund2025ReinvestTo2028Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2028PrevValueMedian = MonthVU2028PrevValueMedian + (temp2023Median * Fund2023ReinvestTo2028Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalMedian != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
				pow(1 + [self ReturnVU2028InstMedian:@"A" ], 1.00/12.00) + MonthVU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstMedian:@"A"],1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				(MonthVU2028ValueMedian/MonthFundValueOfTheYearValueTotalMedian);
			}
			else{
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
				pow(1 + [self ReturnVU2028InstMedian:@"A" ], 1.00/12.00)+ MonthVU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstMedian:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			if (i == MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				if (Fund2028PartialReinvest != 100) {
					MonthFundMaturityValue2028_Flat = MonthVU2028PrevValueMedian * (100 - Fund2028PartialReinvest)/100.00;
					
					temp2028Median = currentValue * (100 - Fund2028PartialReinvest)/100.00;
					
				}
				else{
					MonthFundMaturityValue2028_Flat = 0;
				}
				
				if (aaRound == 2) {
					MonthVU2028PrevValueMedian = 0;
				}
				else{
					MonthVU2028PrevValueMedian = tempPrev;
				}
			}
			else{
				if (aaRound == 2) {
					MonthVU2028PrevValueMedian = currentValue;
				}
				else{
					MonthVU2028PrevValueMedian = tempPrev;
				}
				
			}
			
			if (i == 12 && aaRound == 2) {
				VU2028PrevValueMedian = MonthVU2028PrevValueMedian;
			}
			
			
			return currentValue;
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalMedian != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
				(1 + VU2028InstMedian) + VU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				(VU2028ValueMedian/FundValueOfTheYearValueTotalMedian);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
					(1 + VU2028InstMedian) + VU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstMedian:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					VU2028ValueMedian = currentValue;
				}
				else{
					currentValue = VU2028ValueMedian;
				}
				
			}
			
			if (aaRound == 2) {
				VU2028PrevValueMedian = currentValue;
			}
			
			return currentValue;
		}
		
	}
	
}

-(double)ReturnVU2028ValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2028) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			if (i == 1) {
				MonthVU2028PrevValueLow = VU2028PrevValueLow;
			}
			
			if (i > MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				MonthVU2028PrevValueLow = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2028PrevValueLow;
			if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				MonthVU2028PrevValueLow = MonthVU2028PrevValueLow + (temp2025Low * Fund2025ReinvestTo2028Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2028PrevValueLow = MonthVU2028PrevValueLow + (temp2023Low * Fund2023ReinvestTo2028Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalLow != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
				pow(1 + [self ReturnVU2028InstLow:@"A" ], 1.00/12.00) + MonthVU2028PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstLow:@"A"],1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
				(MonthVU2028ValueLow/MonthFundValueOfTheYearValueTotalLow);
			}
			else{
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
				pow(1 + [self ReturnVU2028InstLow:@"A" ], 1.00/12.00)+ MonthVU2028PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstLow:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			if (i == MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				if (Fund2028PartialReinvest != 100) {
					MonthFundMaturityValue2028_Bear = MonthVU2028PrevValueLow * (100 - Fund2028PartialReinvest)/100.00;
					
					temp2028Low = currentValue * (100 - Fund2028PartialReinvest)/100.00;
					
				}
				else{
					MonthFundMaturityValue2028_Bear = 0;
				}
				
				if (aaRound == 2) {
					MonthVU2028PrevValueLow = 0;
				}
				else{
					MonthVU2028PrevValueLow = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2) {
					MonthVU2028PrevValueLow = currentValue;
				}
				else{
					MonthVU2028PrevValueLow = tempPrev;
				}
				
			}
			
			if (i == 12 && aaRound == 2) {
				VU2028PrevValueLow = MonthVU2028PrevValueLow;
			}
			
			
			return currentValue;
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalLow != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
				(1 + VU2028InstLow) + VU2028PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstLow:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
				(VU2028ValueLow/FundValueOfTheYearValueTotalLow);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2028Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2028Factor * CYFactor) *
					(1 + VU2028InstLow) + VU2028PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstLow:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					VU2028ValueLow = currentValue;
				}
				else{
					currentValue = VU2028ValueLow;
				}
				
			}
			
			if (aaRound == 2) {
				VU2028PrevValueLow = currentValue;
			}
			
			return currentValue;
		}
		
	}
	
}

-(double)ReturnVU2030ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2030) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			if (i == 1) {
				MonthVU2030PrevValuehigh = VU2030PrevValuehigh;
			}
			
			if (i > MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				MonthVU2030PrevValuehigh = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2030PrevValuehigh;
			if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				MonthVU2030PrevValuehigh = MonthVU2030PrevValuehigh + (temp2028High * Fund2028ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				MonthVU2030PrevValuehigh = MonthVU2030PrevValuehigh + (temp2025High * Fund2025ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2030PrevValuehigh = MonthVU2030PrevValuehigh + (temp2023High * Fund2023ReinvestTo2030Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalHigh != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear  andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				pow(1 + [self ReturnVU2030InstHigh:@"A" ], 1.00/12.00) + MonthVU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				(MonthVU2030ValueHigh/MonthFundValueOfTheYearValueTotalHigh);
			}
			else{
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear  andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				pow(1 + [self ReturnVU2030InstHigh:@"A" ], 1.00/12.00) + MonthVU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			if (i == MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				if (Fund2030PartialReinvest != 100) {
					MonthFundMaturityValue2030_Bear = MonthVU2030PrevValuehigh * (100 - Fund2030PartialReinvest)/100.00;
					
					temp2030High = currentValue * (100 - Fund2030PartialReinvest)/100.00;
					
				}
				else{
					MonthFundMaturityValue2030_Bear = 0;
				}
				if (aaRound == 2) {
					MonthVU2030PrevValuehigh = 0;
				}
				
			}
			else{
				if (aaRound == 2) {
					MonthVU2030PrevValuehigh = currentValue;
				}
				else{
					MonthVU2030PrevValuehigh = tempPrev;
				}
				
			}
			
			if (aaRound == 2 && i == 12) {
				VU2030PrevValuehigh = MonthVU2030PrevValuehigh;
			}
			
			return currentValue;
			
		}
		else{
			
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalHigh != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				(1 + VU2030InstHigh) + VU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				(VU2030ValueHigh/FundValueOfTheYearValueTotalHigh);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
					(1 + VU2030InstHigh) + VU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstHigh:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					VU2030ValueHigh = currentValue;
				}
				else{
					currentValue = VU2030ValueHigh;
				}
				
			}
			
			if (aaRound == 2) {
				VU2030PrevValuehigh = currentValue;
			}
			
			return currentValue;
			
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnVU2030ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2030) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				MonthVU2030PrevValueMedian = VU2030PrevValueMedian;
			}
			
			if (i > MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				MonthVU2030PrevValueMedian = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2030PrevValueMedian;
			if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				MonthVU2030PrevValueMedian = MonthVU2030PrevValueMedian + (temp2028Median * Fund2028ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				MonthVU2030PrevValueMedian = MonthVU2030PrevValueMedian + (temp2025Median * Fund2025ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2030PrevValueMedian = MonthVU2030PrevValueMedian + (temp2023Median * Fund2023ReinvestTo2030Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative ==TRUE && MonthFundValueOfTheYearValueTotalMedian != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				pow(1 + [self ReturnVU2030InstMedian:@"A" ], 1.00/12.00) + MonthVU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstMedian:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				(MonthVU2030ValueMedian/MonthFundValueOfTheYearValueTotalMedian);
			}
			else{
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]* [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				pow(1 + [self ReturnVU2030InstMedian:@"A" ], 1.00/12.00) + MonthVU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstMedian:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			if (i == MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				if (Fund2030PartialReinvest != 100) {
					MonthFundMaturityValue2030_Flat = MonthVU2030PrevValueMedian * (100 - Fund2030PartialReinvest)/100.00;
					temp2030Median = currentValue * (100 - Fund2030PartialReinvest)/100.00;
				}
				else{
					MonthFundMaturityValue2030_Flat = 0;
				}
				if (aaRound == 2) {
					MonthVU2030PrevValueMedian = 0;
				}
				
			}
			else{
				if (aaRound == 2) {
					MonthVU2030PrevValueMedian = currentValue;
				}
				else{
					MonthVU2030PrevValueMedian = tempPrev;
				}
			}
			
			if (aaRound == 2 && i == 12) {
				VU2030PrevValueMedian = MonthVU2030PrevValueMedian;
			}
			
			
			return currentValue;
			
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalMedian != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				(1 + VU2030InstMedian) + VU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				(VU2030ValueMedian/FundValueOfTheYearValueTotalMedian);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
					(1 + VU2030InstMedian) + VU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstMedian:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					VU2030ValueMedian = currentValue;
				}
				else{
					currentValue = VU2030ValueMedian;
				}
				
			}
			
			if (aaRound == 2) {
				VU2030PrevValueMedian = currentValue;
			}
			
			return currentValue;
			
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnVU2030ValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2030) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			if (i == 1) {
				MonthVU2030PrevValueLow = VU2030PrevValueLow;
			}
			
			if (i > MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				MonthVU2030PrevValueLow = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2030PrevValueLow;
			if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				MonthVU2030PrevValueLow = MonthVU2030PrevValueLow + (temp2028Low * Fund2028ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				MonthVU2030PrevValueLow = MonthVU2030PrevValueLow + (temp2025Low * Fund2025ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2030PrevValueLow = MonthVU2030PrevValueLow + (temp2023Low * Fund2023ReinvestTo2030Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalLow != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear andMonth:i] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				pow(1 + [self ReturnVU2030InstLow:@"A" ], 1.00/12.00) + MonthVU2030PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstLow:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
				(MonthVU2030ValueLow/MonthFundValueOfTheYearValueTotalLow);
			}
			else{
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]* [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				pow(1 + [self ReturnVU2030InstLow:@"A" ], 1.00/12.00) + MonthVU2030PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstLow:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			if (i == MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				if (Fund2030PartialReinvest != 100) {
					MonthFundMaturityValue2030_Bear = MonthVU2030PrevValueLow * (100 - Fund2030PartialReinvest)/100.00;
					temp2030Low = currentValue * (100 - Fund2030PartialReinvest)/100.00;
				}
				else{
					MonthFundMaturityValue2030_Bear = 0;
				}
				if (aaRound == 2) {
					MonthVU2030PrevValueLow = 0;
				}
				
			}
			else{
				if (aaRound == 2) {
					MonthVU2030PrevValueLow = currentValue;
				}
				else{
					MonthVU2030PrevValueLow = tempPrev;
				}
				
			}
			
			if (aaRound == 2 && i == 12) {
				VU2030PrevValueLow = MonthVU2030PrevValueLow;
			}
			
			
			return currentValue;
			
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalLow != 0) {
				currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
							   [self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
							   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
				(1 + VU2030InstLow) + VU2030PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstLow:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
				(VU2030ValueLow/FundValueOfTheYearValueTotalLow);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2030Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2030Factor * CYFactor) *
					(1 + VU2030InstLow) + VU2030PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstLow:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					VU2030ValueLow = currentValue;
				}
				else{
					currentValue = VU2030PrevValueLow;
				}
				
			}
			
			if (aaRound == 2) {
				VU2030PrevValueLow = currentValue;
			}
			
			return currentValue;
			
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnVU2035ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(NSInteger)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2035) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				MonthVU2035PrevValuehigh = VU2035PrevValuehigh;
			}
			
			if (i > MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				MonthVU2035PrevValuehigh = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2035PrevValuehigh;
			if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
				MonthVU2035PrevValuehigh = MonthVU2035PrevValuehigh + (temp2030High * Fund2030ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				MonthVU2035PrevValuehigh = MonthVU2035PrevValuehigh + (temp2028High * Fund2028ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				MonthVU2035PrevValuehigh = MonthVU2035PrevValuehigh + (temp2025High * Fund2025ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2035PrevValuehigh = MonthVU2035PrevValuehigh + (temp2023High * Fund2023ReinvestTo2035Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalHigh != 0 ) {
				
				currentValue=  ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				pow(1 + [self ReturnVU2035InstHigh:@"A"], 1.00/12.00) + MonthVU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2035InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				(MonthVU2035ValueHigh/MonthFundValueOfTheYearValueTotalHigh);
				if (aaPolicyYear == 23) {
					//NSLog(@"%f %f %f", NegativeValueOfMaxCashFundHigh, MonthVU2035ValueHigh, MonthFundValueOfTheYearValueTotalHigh );
				}
			}
			else if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalHigh == 0 ) {
				currentValue = 0;
			}
			else{
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				pow(1 + [self ReturnVU2035InstHigh:@"A"], 1.00/12.00) + MonthVU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2035InstHigh:@"A"], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			if (i == MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				if (Fund2035PartialReinvest != 100) {
					
					MonthFundMaturityValue2035_Bull = MonthVU2035PrevValuehigh * (100 - Fund2035PartialReinvest)/100.00;
					
					temp2035High = currentValue * (100 - Fund2035PartialReinvest)/100.00;
				}
				else{
					MonthFundMaturityValue2035_Bull = 0;
				}
				
				if (aaRound == 2) {
					MonthVU2035PrevValuehigh = 0;
				}
				else{
					MonthVU2035PrevValuehigh = tempPrev;
				}
				
			}
			
			else{
				
				if (aaRound == 2) {
					MonthVU2035PrevValuehigh = currentValue;
				}
				else{
					MonthVU2035PrevValuehigh = tempPrev;
				}
				
			}
			
			if (i == 12 && aaRound == 2) {
				VU2035PrevValuehigh = MonthVU2035PrevValuehigh;
			}
			
			
			//return MonthVU2035PrevValuehigh;
			return currentValue;
			
			
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalHigh != 0 ) {
				
				currentValue=  ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				(1 + VU2035InstHigh) + VU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
				(VU2035ValueHigh/FundValueOfTheYearValueTotalHigh);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
					(1 + VU2035InstHigh) + VU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstHigh:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					
					VU2035ValueHigh = currentValue;
				}
				else{
					currentValue = VU2035ValueHigh;
				}
				
			}
			
			if (aaRound == 2) {
				VU2035PrevValuehigh = currentValue;
			}
			
			
			return currentValue;
		}
		
		
	}
}

-(double)ReturnVU2035ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2035) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			if (i == 1) {
				MonthVU2035PrevValueMedian = VU2035PrevValueMedian;
			}
			
			if (i > MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				MonthVU2035PrevValueMedian = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2035PrevValueMedian;
			if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
				MonthVU2035PrevValueMedian = MonthVU2035PrevValueMedian + (temp2030Median * Fund2030ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				MonthVU2035PrevValueMedian = MonthVU2035PrevValueMedian + (temp2028Median * Fund2028ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				MonthVU2035PrevValueMedian = MonthVU2035PrevValueMedian + (temp2025Median * Fund2025ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2035PrevValueMedian = MonthVU2035PrevValueMedian + (temp2023Median * Fund2023ReinvestTo2035Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalMedian != 0 ) {
				
				currentValue=  ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				pow((1 + [self ReturnVU2035InstMedian:@"A"]), (1.00/12.00)) + MonthVU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow((1 + [self ReturnVU2035InstMedian:@"A"]), (1.00/12.00)) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				(MonthVU2035ValueMedian/MonthFundValueOfTheYearValueTotalMedian);
			}
			else{
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] *[self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				pow((1 + [self ReturnVU2035InstMedian:@"A" ]), (1.00/12.00)) + MonthVU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow((1 + [self ReturnVU2035InstMedian:@"A"]), (1.00/12.00)) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			
			if (i == MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				if (Fund2035PartialReinvest != 100) {
					MonthFundMaturityValue2035_Flat = MonthVU2035PrevValueMedian * (100 - Fund2035PartialReinvest)/100.00;
					temp2035Median = currentValue * (100 - Fund2035PartialReinvest)/100.00;
				}
				else{
					MonthFundMaturityValue2035_Flat = 0;
				}
				if (aaRound == 2) {
					MonthVU2035PrevValueMedian = 0;
				}
				else{
					MonthVU2035PrevValueMedian = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2) {
					MonthVU2035PrevValueMedian = currentValue;
				}
				else{
					MonthVU2035PrevValueMedian = tempPrev;
				}
				
			}
			
			if (i == 12 && aaRound == 2) {
				VU2035PrevValueMedian = MonthVU2035PrevValueMedian;
			}
			
			//return MonthVU2035PrevValueMedian;
			return currentValue;
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalMedian != 0 ) {
				
				currentValue=  ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] ) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				(1 + VU2035InstMedian) + VU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstMedian:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
				(VU2035ValueMedian/FundValueOfTheYearValueTotalMedian);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
					(1 + VU2035InstMedian) + VU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstMedian:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					VU2035ValueMedian = currentValue;
				}
				else{
					currentValue = VU2035ValueMedian;
				}
			}
			
			if (aaRound == 2) {
				VU2035PrevValueMedian = currentValue;
			}
			
			return currentValue;
		}
		
		
	}
}

-(double)ReturnVU2035ValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2035) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			if (i == 1) {
				MonthVU2035PrevValueLow = VU2035PrevValueLow;
			}
			
			if (i > MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				MonthVU2035PrevValueLow = 0;
				return 0;
			}
			
			double tempPrev = MonthVU2035PrevValueLow;
			if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
				MonthVU2035PrevValueLow = MonthVU2035PrevValueLow + (temp2030Low * Fund2030ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				MonthVU2035PrevValueLow = MonthVU2035PrevValueLow + (temp2028Low * Fund2028ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				MonthVU2035PrevValueLow = MonthVU2035PrevValueLow + (temp2025Low * Fund2025ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				MonthVU2035PrevValueLow = MonthVU2035PrevValueLow + (temp2023Low * Fund2023ReinvestTo2035Fac/100.00);
			}
			else{
				
			}
			
			if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalLow != 0 ) {
				
				currentValue=  ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				pow((1 + [self ReturnVU2035InstLow:@"A"]), (1.00/12.00)) + MonthVU2035PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow((1 + [self ReturnVU2035InstLow:@"A"]), (1.00/12.00)) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
				(MonthVU2035ValueLow/MonthFundValueOfTheYearValueTotalLow);
			}
			else{
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] *[self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				pow((1 + [self ReturnVU2035InstLow:@"A" ]), (1.00/12.00)) + MonthVU2035PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow((1 + [self ReturnVU2035InstLow:@"A"]), (1.00/12.00)) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			}
			
			
			if (i == MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				if (Fund2035PartialReinvest != 100) {
					MonthFundMaturityValue2035_Bear = MonthVU2035PrevValueLow * (100 - Fund2035PartialReinvest)/100.00;
					temp2035Low = currentValue * (100 - Fund2035PartialReinvest)/100.00;
				}
				else{
					MonthFundMaturityValue2035_Bear = 0;
				}
				
				if (aaRound == 2) {
					MonthVU2035PrevValueLow = 0;
				}
				else{
					MonthVU2035PrevValueLow = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2) {
					MonthVU2035PrevValueLow = currentValue;
				}
				else{
					MonthVU2035PrevValueLow = tempPrev;
				}
			}
			
			if (aaRound == 2 && i == 12) {
				VU2035PrevValueLow = MonthVU2035PrevValueLow;
			}
			
			//return MonthVU2035PrevValueLow;
			return currentValue;
		}
		else{
			if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalLow != 0 ) {
				
				currentValue=  ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] ) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
				(1 + VU2035InstLow) + VU2035PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstLow:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
				(VU2035ValueLow/FundValueOfTheYearValueTotalLow);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] * CYFactor +
									[self ReturnRegTopUpPrem] * RegularAllo * VU2035Factor * CYFactor +
									[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2035Factor * CYFactor) *
					(1 + VU2035InstLow) + VU2035PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstLow:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					VU2035ValueLow = currentValue;
				}
				else{
					currentValue = VU2035ValueLow;
				}
			}
			
			if (aaRound == 2) {
				VU2035PrevValueLow = currentValue;
			}
			
			return currentValue;
		}
		
		
	}
}


-(double)ReturnVUCashValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)i {
	
	double tempValue = 0.00;
	
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		if (i == 1) {
			MonthVUCashPrevValueHigh = VUCashPrevValueHigh;
		}
		
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)  ) {
			
			MonthVUCashPrevValueHigh = MonthVUCashPrevValueHigh + (temp2035High * Fund2035ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			MonthVUCashPrevValueHigh = MonthVUCashPrevValueHigh + (temp2030High * Fund2030ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			//NSLog(@"%f", temp2028High);
			MonthVUCashPrevValueHigh = MonthVUCashPrevValueHigh + (temp2028High * Fund2028ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			MonthVUCashPrevValueHigh = MonthVUCashPrevValueHigh + (temp2025High * Fund2025ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			MonthVUCashPrevValueHigh = MonthVUCashPrevValueHigh + (temp2023High * Fund2023ReinvestToCashFac/100.00);
		}
		else{
			
		}
		
		tempValue = ((( [strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor +
					 [self ReturnRegTopUpPrem] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor +
					 [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor) *
		pow((1 + [self ReturnVUCashInstHigh:@"A"]), (1.00/12.00)) + MonthVUCashPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
		pow((1 + [self ReturnVUCashInstHigh:@"A"]), (1.00/12.00)) - (PolicyFee + [self ReturnTotalBasicMortHigh:aaPolicyYear]) -
		([self ReturnRegWithdrawal:aaPolicyYear] * [self ReturnRegWithdrawalFactor:i]);
		
		MonthVUCashPrevValueHigh =  tempValue;
		//NSLog(@"%f", MonthVUCashPrevValueHigh);
		
		if (tempValue < 0) {
			MonthVUCashPrevValueHigh = 1.00;
		}
		else{
			MonthVUCashPrevValueHigh = tempValue;
		}
		
		if (i == 12) {
			VUCashPrevValueHigh = MonthVUCashPrevValueHigh;
		}
		
		if (tempValue < 0 && MonthFundValueOfTheYearValueTotalHigh != 0) {
			NegativeValueOfMaxCashFundHigh = tempValue;
			VUCashValueNegative = TRUE;
			return MonthVUCashPrevValueHigh;
		} else {
			NegativeValueOfMaxCashFundHigh = tempValue;
			VUCashValueNegative = FALSE;
			return MonthVUCashPrevValueHigh + 0; // to be edit later
		}
		
	}
	else
	{
		tempValue = ((( [strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear] * CYFactor +
					 [self ReturnRegTopUpPrem] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear] * CYFactor +
					 [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * [self ReturnVUCashFac:aaPolicyYear] * CYFactor) *
		(1 + [self ReturnVUCashInstHigh:@""]) + VUCashPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVUCashInstHigh:@"A"]) -
		(PolicyFee + [self ReturnTotalBasicMortHigh:aaPolicyYear]) * [self ReturnVUCashHigh] -
		([self ReturnRegWithdrawal:aaPolicyYear] * 1);
		
		
		if (tempValue < 0) {
			VUCashPrevValueHigh = 1.00;
		}
		else{
			VUCashPrevValueHigh = tempValue;
		}
		
		
		//VUCashPrevValueHigh = tempValue;
		if (tempValue < 0 && FundValueOfTheYearValueTotalHigh != 0) {
			//NegativeValueOfMaxCashFundHigh = tempValue;
			NegativeValueOfMaxCashFundHigh = tempValue;
			VUCashValueNegative = TRUE;
			return VUCashPrevValueHigh;
		} else {
			VUCashValueNegative = FALSE;
			NegativeValueOfMaxCashFundHigh = tempValue;
			return tempValue + 0; // to be edit later
		}
	}
	
	
	
	
	
}

-(double)ReturnVUCashValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)i{
	
	double tempValue = 0.00;
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		if (i == 1) {
			MonthVUCashPrevValueMedian = VUCashPrevValueMedian;
		}
		
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)  ) {
			MonthVUCashPrevValueMedian = MonthVUCashPrevValueMedian + (temp2035Median * Fund2035ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			MonthVUCashPrevValueMedian = MonthVUCashPrevValueMedian + (temp2030Median * Fund2030ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			MonthVUCashPrevValueMedian = MonthVUCashPrevValueMedian + (temp2028Median * Fund2028ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			MonthVUCashPrevValueMedian = MonthVUCashPrevValueMedian + (temp2025Median * Fund2025ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			MonthVUCashPrevValueMedian = MonthVUCashPrevValueMedian + (temp2023Median * Fund2023ReinvestToCashFac/100.00);
		}
		else{
			
		}
		
		tempValue = ((( [strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor +
					 [self ReturnRegTopUpPrem] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor +
					 [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor) *
		pow(1 + [self ReturnVUCashInstMedian:@"A"], 1.00/12.00) + MonthVUCashPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
		pow(1 + [self ReturnVUCashInstMedian:@"A"], 1.00/12.00) - (PolicyFee + [self ReturnTotalBasicMortMedian:aaPolicyYear]) -
		([self ReturnRegWithdrawal:aaPolicyYear] * [self ReturnRegWithdrawalFactor:i]);
		
		MonthVUCashPrevValueMedian = tempValue;
		
		if (tempValue < 0) {
			MonthVUCashPrevValueMedian = 1.00;
		}
		else{
			MonthVUCashPrevValueMedian = tempValue;
		}
		
		if (i == 12) {
			VUCashPrevValueMedian = MonthVUCashPrevValueMedian;
		}
		
		
		if (tempValue < 0 && MonthFundValueOfTheYearValueTotalMedian != 0) {
			NegativeValueOfMaxCashFundMedian = tempValue;
			VUCashValueNegative = TRUE;
			return  MonthVUCashPrevValueMedian;
		} else {
			NegativeValueOfMaxCashFundMedian =  tempValue;
			VUCashValueNegative = FALSE;
			return  MonthVUCashPrevValueMedian + 0; // to be edit later
		}
		
		
		
		
	}
	else{
		tempValue = ((( [strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear] * CYFactor +
					 [self ReturnRegTopUpPrem] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear] * CYFactor +
					 [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * [self ReturnVUCashFac:aaPolicyYear] * CYFactor) *
		(1 + [self ReturnVUCashInstMedian:@""]) + VUCashPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVUCashInstMedian:@"A"]) -
		(PolicyFee + [self ReturnTotalBasicMortMedian:aaPolicyYear]) * [self ReturnVUCashMedian] -
		([self ReturnRegWithdrawal:aaPolicyYear] * 1);
		
		
		if (tempValue < 0) {
			VUCashPrevValueMedian = 1.00;
		}
		else{
			VUCashPrevValueMedian = tempValue;
		}
		
		//VUCashPrevValueMedian = tempValue;
		if (tempValue < 0 && FundValueOfTheYearValueTotalMedian != 0) {
			NegativeValueOfMaxCashFundMedian = tempValue;
			VUCashValueNegative = TRUE;
			return VUCashPrevValueMedian;
			//return tempValue;
		} else {
			NegativeValueOfMaxCashFundMedian = tempValue;
			VUCashValueNegative = FALSE;
			return tempValue + 0; // to be edit later
		}
	}
	
	
	
	
}


-(double)ReturnVUCashValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)i{
	
	double tempValue = 0.00;
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		if (i == 1) {
			MonthVUCashPrevValueLow = VUCashPrevValueLow;
		}
		
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)  ) {
			MonthVUCashPrevValueLow = MonthVUCashPrevValueLow + (temp2035Low * Fund2035ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			MonthVUCashPrevValueLow = MonthVUCashPrevValueLow + (temp2030Low * Fund2030ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			MonthVUCashPrevValueLow = MonthVUCashPrevValueLow + (temp2028Low * Fund2028ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			MonthVUCashPrevValueLow = MonthVUCashPrevValueLow + (temp2025Low * Fund2025ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			MonthVUCashPrevValueLow = MonthVUCashPrevValueLow + (temp2023Low * Fund2023ReinvestToCashFac/100.00);
		}
		else{
			
		}
		
		tempValue = ((( [strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor +
					 [self ReturnRegTopUpPrem] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor +
					 [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * CYFactor) *
		pow(1 + [self ReturnVUCashInstLow:@"A"], 1.00/12.00) + MonthVUCashPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
		pow(1 + [self ReturnVUCashInstLow:@"A"], 1.00/12.00) - (PolicyFee + [self ReturnTotalBasicMortLow:aaPolicyYear]) -
		([self ReturnRegWithdrawal:aaPolicyYear] * [self ReturnRegWithdrawalFactor:i]);
		
		
		
		if (tempValue < 0) {
			MonthVUCashPrevValueLow = 1.00;
		}
		else{
			MonthVUCashPrevValueLow = tempValue;
		}
		
		if (i == 12) {
			VUCashPrevValueLow = MonthVUCashPrevValueLow;
		}
		
		
		
		
		if (tempValue < 0 && MonthFundValueOfTheYearValueTotalLow != 0) {
			NegativeValueOfMaxCashFundLow = tempValue;
			VUCashValueNegative = TRUE;
			return  MonthVUCashPrevValueLow;
		} else {
			NegativeValueOfMaxCashFundLow =  tempValue;
			VUCashValueNegative = FALSE;
			return  MonthVUCashPrevValueLow + 0; // to be edit later
		}
	}
	else{
		tempValue = ((( [strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear] * CYFactor +
					 [self ReturnRegTopUpPrem] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear] * CYFactor +
					 [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * [self ReturnVUCashFac:aaPolicyYear] * CYFactor) *
		(1 + [self ReturnVUCashInstLow:@""]) + VUCashPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVUCashInstLow:@"A"]) -
		(PolicyFee + [self ReturnTotalBasicMortLow:aaPolicyYear]) * [self ReturnVUCashLow] -
		([self ReturnRegWithdrawal:aaPolicyYear] * 1);
		
		if (tempValue < 0) {
			VUCashPrevValueLow = 1.00;
		}
		else{
			VUCashPrevValueLow = tempValue;
		}
		
		//VUCashPrevValueLow = tempValue;
		if (tempValue < 0 && FundValueOfTheYearValueTotalLow != 0) {
			NegativeValueOfMaxCashFundLow = tempValue;
			VUCashValueNegative = TRUE;
			return VUCashPrevValueLow;
			//return tempValue;
		} else {
			NegativeValueOfMaxCashFundLow = tempValue;
			VUCashValueNegative = FALSE;
			return tempValue + 0; // to be edit later
		}
	}
	
	
	
	
}


-(double)ReturnVURetValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(NSInteger)i{
	
	double currentValue =0.0;
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		
		if (i == 1) {
			MonthVURetPrevValueHigh = VURetPrevValueHigh ;
		}
		
		double tempPrev = MonthVURetPrevValueHigh;
		
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)) {
			MonthVURetPrevValueHigh = MonthVURetPrevValueHigh + (temp2035High * Fund2035ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			MonthVURetPrevValueHigh = MonthVURetPrevValueHigh + (temp2030High * Fund2030ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			MonthVURetPrevValueHigh = MonthVURetPrevValueHigh + (temp2028High * Fund2028ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			MonthVURetPrevValueHigh = MonthVURetPrevValueHigh + (temp2025High * Fund2025ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			MonthVURetPrevValueHigh = MonthVURetPrevValueHigh + (temp2023High * Fund2023ReinvestToRetFac/100.00);
		}
		else{
			
		}
		
		//NSLog(@"%f", MonthVURetPrevValueHigh);
		if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalHigh != 0 ) {
			currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear andMonth:i] * CYFactor +
						   [self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
						   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			pow(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"],1.00/12.00) + MonthVURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"], 1.00/12.00) -
			([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
			(MonthVURetValueHigh/MonthFundValueOfTheYearValueTotalHigh);
			
			//NSLog(@"%f %f %f",NegativeValueOfMaxCashFundHigh, MonthVURetValueHigh,MonthFundValueOfTheYearValueTotalHigh );
			
		}
		else{
			currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] * CYFactor +
							[self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
							[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			pow((1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]),(1.00/12.00)) + MonthVURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow((1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]), (1.00/12.00)) -
			([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			
			
		}
		
		//NSLog(@"%f, %f, %f, %f",NegativeValueOfMaxCashFundHigh, MonthVURetValueHigh, MonthFundValueOfTheYearValueTotalHigh, currentValue);
		
		if (aaRound == 2) {
			MonthVURetPrevValueHigh = currentValue;
		}
		else{
			MonthVURetPrevValueHigh = tempPrev;
		}
		
		
		if (i == 12  && aaRound == 2) {
			VURetPrevValueHigh = MonthVURetPrevValueHigh;
		}
		
		//NSLog(@"%d %f %f, %d ", i, MonthVURetValueHigh, MonthFundValueOfTheYearValueTotalHigh, VUCashValueNegative);
		//return MonthVURetPrevValueHigh;
		return currentValue;
		
		
		
		
	}
	else{
		//if (VUCashValueHigh < 0 && [self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0 ) {
		if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalHigh != 0 ) {
			currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] * CYFactor +
						   [self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
						   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@""]) + VURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]) -
			([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundHigh - 1) *
			(VURetValueHigh/FundValueOfTheYearValueTotalHigh);
			
		}
		else{
			if (aaRound == 1) {
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
				(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@""]) + VURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				VURetValueHigh = currentValue;
			}
			else{
				currentValue = VURetValueHigh;
			}
			
		}
		
		if (aaRound == 2) {
			VURetPrevValueHigh = currentValue;
		}
		
		return currentValue;
	}
	
	
}

-(double)ReturnVURetValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		
		if (i == 1) {
			MonthVURetPrevValueMedian = VURetPrevValueMedian ;
		}
		
		double tempPrev = MonthVURetPrevValueMedian;
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)  ) {
			MonthVURetPrevValueMedian = MonthVURetPrevValueMedian + (temp2035Median * Fund2035ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			MonthVURetPrevValueMedian = MonthVURetPrevValueMedian + (temp2030Median * Fund2030ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			MonthVURetPrevValueMedian = MonthVURetPrevValueMedian + (temp2028Median * Fund2028ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			MonthVURetPrevValueMedian = MonthVURetPrevValueMedian + (temp2025Median * Fund2025ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			MonthVURetPrevValueMedian = MonthVURetPrevValueMedian + (temp2023Median * Fund2023ReinvestToRetFac/100.00);
		}
		else{
			
		}
		
		if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalMedian != 0 ) {
			currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] * CYFactor +
						   [self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
						   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			pow(1 + [self ReturnVURetInstMedian], 1.00/12.00) + MonthVURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow(1 + [self ReturnVURetInstMedian], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
			(MonthVURetValueMedian/MonthFundValueOfTheYearValueTotalMedian);
			
		}
		else{
			currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] * CYFactor +
							[self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
							[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			pow(1 + [self ReturnVURetInstMedian], 1.00/12.00) + MonthVURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow(1 + [self ReturnVURetInstMedian], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			
		}
		
		if (aaRound == 2) {
			MonthVURetPrevValueMedian = currentValue;
		}
		else{
			MonthVURetPrevValueMedian = tempPrev;
		}
		
		if (i == 12  && aaRound == 2) {
			VURetPrevValueMedian = MonthVURetPrevValueMedian ;
		}
		
		
		//return MonthVURetPrevValueMedian;
		return currentValue;
		
	}
	else{
		//if (VUCashValueMedian < 0 && [self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0 ) {
		if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalMedian != 0 ) {
			currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] * CYFactor +
						   [self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
						   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			(1 + [self ReturnVURetInstMedian]) + VURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstMedian]) -
			([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundMedian - 1) *
			(VURetValueMedian/FundValueOfTheYearValueTotalMedian);
			
		}
		else{
			if (aaRound == 1) {
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
				(1 + [self ReturnVURetInstMedian]) + VURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstMedian]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				VURetValueMedian = currentValue;
			}
			else{
				currentValue = VURetValueMedian;
			}
		}
		
		if (aaRound == 2) {
			VURetPrevValueMedian = currentValue;
		}
		return currentValue;
	}
	
}

-(double)ReturnVURetValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	
	
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		
		if (i == 1) {
			MonthVURetPrevValueLow = VURetPrevValueLow ;
		}
		
		double tempPrev = MonthVURetPrevValueLow;
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)  ) {
			MonthVURetPrevValueLow = MonthVURetPrevValueLow + (temp2035Low * Fund2035ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			MonthVURetPrevValueLow = MonthVURetPrevValueLow + (temp2030Low * Fund2030ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			MonthVURetPrevValueLow = MonthVURetPrevValueLow + (temp2028Low * Fund2028ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			MonthVURetPrevValueLow = MonthVURetPrevValueLow + (temp2025Low * Fund2025ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			MonthVURetPrevValueLow = MonthVURetPrevValueLow + (temp2023Low * Fund2023ReinvestToRetFac/100.00);
		}
		else{
			
		}
		
		if (VUCashValueNegative == TRUE && MonthFundValueOfTheYearValueTotalLow != 0 ) {
			currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] * CYFactor +
						   [self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
						   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			pow(1 + [self ReturnVURetInstLow], 1.00/12.00) + MonthVURetPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow(1 + [self ReturnVURetInstLow], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
			(MonthVURetValueLow/MonthFundValueOfTheYearValueTotalLow);
			
		}
		else{
			currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] * CYFactor +
							[self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
							[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			pow(1 + [self ReturnVURetInstLow], 1.00/12.00) + MonthVURetPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow(1 + [self ReturnVURetInstLow], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0);
			
		}
		
		
		if (aaRound == 2) {
			MonthVURetPrevValueLow = currentValue;
		}
		else{
			MonthVURetPrevValueLow = tempPrev;
		}
		
		if (i == 12  && aaRound == 2) {
			VURetPrevValueLow = MonthVURetPrevValueLow ;
		}
		
		//return MonthVURetPrevValueLow;
		return currentValue;
		
	}
	else{
		if (VUCashValueNegative == TRUE && FundValueOfTheYearValueTotalLow != 0 ) {
			currentValue= ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] * CYFactor +
						   [self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
						   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
			(1 + [self ReturnVURetInstLow]) + VURetPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstLow]) -
			([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (NegativeValueOfMaxCashFundLow - 1) *
			(VURetValueLow/FundValueOfTheYearValueTotalLow);
			
		}
		else{
			if (aaRound == 1) {
				currentValue = ((([strBasicPremium doubleValue ] * [self ReturnPremAllocation:aaPolicyYear]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] * CYFactor +
								[self ReturnRegTopUpPrem] * RegularAllo * VURetFactor * CYFactor +
								[self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VURetFactor * CYFactor) *
				(1 + [self ReturnVURetInstLow]) + VURetPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstLow]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0);
				VURetValueLow = currentValue;
			}
			else{
				currentValue = VURetValueLow;
			}
			
		}
		
		if (aaRound == 2) {
			VURetPrevValueLow = currentValue;
		}
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
	if (![strRTUPAmount isEqualToString:@""]) {
		return [strRTUPAmount doubleValue ];
	}
	else{
		return 0;
	}
}

-(double)ReturnRiderRegTopUpPrem :(int) aaPolicyYear{
	if ([strRRTUOPrem isEqualToString:@""]) {
		return 0.00;
	}
	else{
		if (aaPolicyYear > [strRRTUOFrom intValue ] && aaPolicyYear < ([strRRTUOFrom intValue] + [strRRTUOFor intValue])) {
			return [strRRTUOPrem doubleValue];
		}
		else{
			return 0.00;
		}
	}
	
}


#pragma mark - Calculate Fund Surrender Value for Rider
-(double)ReturnRiderVU2023ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(NSInteger)aaMonth{
	double currentValue;
	if (aaPolicyYear > YearDiff2023) {
		return 0.00;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			//month calculation
			
			
			if (aaMonth == 1) {
				RiderMonthVU2023PrevValuehigh = RiderVU2023PrevValuehigh;
			}
			
			if (aaMonth > MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				RiderMonthVU2023PrevValuehigh = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2023PrevValuehigh;
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalHigh != 0 ) {
				
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:aaMonth] ) + IncreasePrem) * [self ReturnVU2023Fac] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor * [self ReturnPremiumFactor:aaMonth]) *
				pow((1 + [self ReturnVU2023InstHigh:@"A" ]), (1.00/12.00)) + RiderMonthVU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear] * [self ReturnLoyaltyBonusFactor:aaMonth]/100.00)) *
				pow((1 + [self ReturnVU2023InstHigh:@"A" ]), 1.00/12.00)  + (NegativeValueOfMaxCashFundHigh - 1) * (RiderMonthVU2023ValueHigh/RiderMonthFundValueOfTheYearValueTotalHigh);
				
			}
			else{
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:aaMonth]) + IncreasePrem) * [self ReturnVU2023Fac] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor * [self ReturnPremiumFactor:aaMonth]) *
				pow(1 + [self ReturnVU2023InstHigh:@"A" ], 1.00/12.00) + RiderMonthVU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:aaMonth]/100.00)) *
				pow(1 + [self ReturnVU2023InstHigh:@"A" ], 1.00/12.00);
			}
			if (aaMonth == MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				if (Fund2023PartialReinvest != 100) {
					MonthFundMaturityValue2023_Bull = MonthVU2023PrevValuehigh * (100 - Fund2023PartialReinvest)/100.00;
					
					Ridertemp2023High = currentValue * (100 - Fund2023PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2023_Bull = 0;
				}
				
				if (aaRound == 2) {
					RiderMonthVU2023PrevValuehigh = 0;
				}
				else{
					RiderMonthVU2023PrevValuehigh = tempPrev;
				}
			}
			else{
				if (aaRound == 2) {
					RiderMonthVU2023PrevValuehigh = currentValue;
				}
				else{
					RiderMonthVU2023PrevValuehigh = tempPrev;
				}
			}
			
			if (aaMonth == 12 && aaRound == 2) {
				RiderVU2023PrevValuehigh = RiderMonthVU2023PrevValuehigh;
			}
			
			return currentValue;
			// below part to be edit later
		}
		else{
			//year calculation
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalHigh != 0 ) {
				
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2023Fac] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor) *
				(1 + VU2023InstHigh) + RiderVU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstHigh:@"A"])
				+ (RiderNegativeValueOfMaxCashFundHigh - 1) * (RiderVU2023ValueHigh/RiderFundValueOfTheYearValueTotalHigh);
				
			}
			else{
				if (aaRound == 1) {
					currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2023Fac]  +
								   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor) *
					(1 + VU2023InstHigh) + RiderVU2023PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstHigh:@"A"]);
					RiderVU2023ValueHigh = currentValue;
				}
				else{
					currentValue = RiderVU2023ValueHigh;
				}
				
			}
			
			if (aaRound == 2){
				RiderVU2023PrevValuehigh = currentValue;
			}
			
			return currentValue;
			// below part to be edit later
		}
		
	}
}

-(double)ReturnRiderVU2023ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	double currentValue;
	if (aaPolicyYear > YearDiff2023) {
		return 0.00;
	}
	else{
		
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				RiderMonthVU2023PrevValueMedian = RiderVU2023PrevValueMedian;
			}
			
			if (i > MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				RiderMonthVU2023PrevValueMedian = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2023PrevValueMedian;
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalMedian != 0 ) {
				
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2023Fac]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor) *
				pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00) + RiderMonthVU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00) + (RiderNegativeValueOfMaxCashFundMedian - 1) *
				(RiderMonthVU2023ValueMedian/RiderMonthFundValueOfTheYearValueTotalMedian);
				
			}
			else{
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2023Fac ]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor) *
				pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00) + RiderMonthVU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2023InstMedian:@"A" ], 1.00/12.00);
			}
			
			if (i == MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				if (Fund2023PartialReinvest != 100) {
					MonthFundMaturityValue2023_Flat = MonthVU2023PrevValueMedian * (100 - Fund2023PartialReinvest)/100.00;
					
					Ridertemp2023Median = currentValue * (100 - Fund2023PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2023_Flat = 0;
				}
				
				if (aaRound == 2) {
					RiderMonthVU2023PrevValueMedian = 0;
				}
				else{
					RiderMonthVU2023PrevValueMedian = tempPrev;
				}
			}
			else{
				if (aaRound == 2) {
					RiderMonthVU2023PrevValueMedian = currentValue;
				}
				else{
					RiderMonthVU2023PrevValueMedian = tempPrev;
				}
				
			}
			
			
			if (i == 12 && aaRound == 2) {
				RiderVU2023PrevValueMedian = RiderMonthVU2023PrevValueMedian;
			}
			
			return currentValue;
			// below part to be edit later
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalMedian != 0 ) {
				
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2023Fac]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor) *
				(1 + VU2023InstMedian) + RiderVU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstMedian:@"A"])
				+ (RiderNegativeValueOfMaxCashFundMedian - 1) * (RiderVU2023ValueMedian/RiderFundValueOfTheYearValueTotalMedian);
				
			}
			else{
				if (aaRound == 1) {
					currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2023Fac]  +
								   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor  +
								   [self ReturnExcessPrem:aaPolicyYear] * ExcessAllo * VU2023Factor * CYFactor) *
					(1 + VU2023InstMedian) + RiderVU2023PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstMedian:@"A"]);
					RiderVU2023ValueMedian = currentValue;
				}
				else{
					currentValue = RiderVU2023ValueMedian;
				}
				
			}
			
			if (aaRound == 2){
				RiderVU2023PrevValueMedian = currentValue;
			}
			
			return currentValue;
			// below part to be edit later
		}
		
	}
}

-(double)ReturnRiderVU2023ValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	double currentValue;
	if (aaPolicyYear > YearDiff2023) {
		return 0.00;
	}
	else{
		
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				RiderMonthVU2023PrevValueLow = RiderVU2023PrevValueLow;
			}
			
			if (i > MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				RiderMonthVU2023PrevValueLow = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2023PrevValueLow;
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalLow != 0 ) {
				
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2023Fac]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor * [self ReturnPremiumFactor:aaPolicyYear]) *
				pow(1 + [self ReturnVU2023InstLow:@"A" ], 1.00/12.00) + RiderMonthVU2023PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2023InstLow:@"A" ], 1.00/12.00)  + (RiderNegativeValueOfMaxCashFundLow - 1) *
				(RiderMonthVU2023ValueLow/RiderMonthFundValueOfTheYearValueTotalLow);
				
			}
			else{
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2023Fac ]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor * [self ReturnPremiumFactor:aaPolicyYear]) *
				pow(1 + [self ReturnVU2023InstLow:@"A" ], 1.00/12.00) + RiderMonthVU2023PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2023InstLow:@"A" ], 1.00/12.00);
			}
			
			if (i == MonthDiff2023 && aaPolicyYear == YearDiff2023) {
				if (Fund2023PartialReinvest != 100) {
					MonthFundMaturityValue2023_Bear = MonthVU2023PrevValueLow * (100 - Fund2023PartialReinvest)/100.00;
					
					Ridertemp2023Low = currentValue * (100 - Fund2023PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2023_Bear = 0;
				}
				if (aaRound == 2) {
					RiderMonthVU2023PrevValueLow = 0;
				}
				else{
					RiderMonthVU2023PrevValueLow = tempPrev;
				}
			}
			else{
				if (aaRound == 2) {
					RiderMonthVU2023PrevValueLow = currentValue;
				}
				else{
					RiderMonthVU2023PrevValueLow = tempPrev;
				}
			}
			
			if (i == 12 && aaRound == 2) {
				RiderVU2023PrevValueLow = RiderMonthVU2023PrevValueLow;
			}
			
			return currentValue;
			// below part to be edit later
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalLow != 0 ) {
				
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1 ] doubleValue ]) + IncreasePrem) * [self ReturnVU2023Fac]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor * [self ReturnPremiumFactor:aaPolicyYear]) *
				(1 + VU2023InstLow) + RiderVU2023PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstLow:@"A"]) +
				(RiderNegativeValueOfMaxCashFundLow - 1) * (RiderVU2023ValueLow/RiderFundValueOfTheYearValueTotalLow);
				
			}
			else{
				
				if (aaRound == 1) {
					currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2023Fac] * +
								   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2023Factor * [self ReturnPremiumFactor:aaPolicyYear]) *
					(1 + VU2023InstLow) + RiderVU2023PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2023InstLow:@"A"]);
					RiderVU2023ValueLow = currentValue ;
				}
				else{
					currentValue = RiderVU2023ValueLow;
				}
				
			}
			
			if (aaRound == 2){
				RiderVU2023PrevValueLow = currentValue;
			}
			
			return currentValue;
			// below part to be edit later
		}
		
	}
}


-(double)ReturnRiderVU2025ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(NSInteger)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2025) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				RiderMonthVU2025PrevValuehigh = RiderVU2025PrevValuehigh;
			}
			
			if (i > MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				RiderMonthVU2025PrevValuehigh = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2025PrevValuehigh;
			
			if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2025PrevValuehigh = RiderMonthVU2025PrevValuehigh + (Ridertemp2023High * Fund2023ReinvestTo2025Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalHigh != 0 ) {
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]  * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00) + RiderMonthVU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00) - ([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (RiderNegativeValueOfMaxCashFundHigh - 1) *
				(RiderMonthVU2025ValueHigh/RiderMonthFundValueOfTheYearValueTotalHigh);
			}
			else{
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00) + RiderMonthVU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstHigh:@"A" ], 1.00/12.00);
			}
			
			if (i == MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				if (Fund2025PartialReinvest != 100) {
					MonthFundMaturityValue2025_Bull = MonthVU2025PrevValuehigh * (100 - Fund2025PartialReinvest)/100.00;
					
					Ridertemp2025High = currentValue * (100 - Fund2025PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2025_Bull = 0;
				}
				if (aaRound == 2){
					RiderMonthVU2025PrevValuehigh = 0;
				}
				else{
					RiderMonthVU2025PrevValuehigh = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2){
					RiderMonthVU2025PrevValuehigh = currentValue;
				}
				else{
					RiderMonthVU2025PrevValuehigh = tempPrev;
				}
				
			}
			
			
			if (aaRound == 2 && i == 12) {
				RiderVU2025PrevValuehigh = RiderMonthVU2025PrevValuehigh;
			}
			
			return currentValue;
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalHigh != 0 ) {
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2025InstHigh) + RiderVU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstHigh:@"A"]) -
				([self ReturnRegWithdrawal:aaPolicyYear] * 0) + (RiderNegativeValueOfMaxCashFundHigh - 1) *
				(RiderVU2025ValueHigh/RiderFundValueOfTheYearValueTotalHigh);
				
				
			}
			else{
				
				if (aaRound == 1) {
					currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] +
								   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2025InstHigh) + RiderVU2025PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstHigh:@"A"]) -
					([self ReturnRegWithdrawal:aaPolicyYear] * 0);
					
					RiderVU2025ValueHigh = currentValue;
				}
				else{
					currentValue = RiderVU2025ValueHigh;
				}
				
			}
			
			if (aaRound == 2) {
				RiderVU2025PrevValuehigh = currentValue;
			}
			
			return currentValue;
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnRiderVU2025ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2025) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			
			if (i == 1) {
				RiderMonthVU2025PrevValueMedian = RiderVU2025PrevValueMedian;
			}
			
			if (i > MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				RiderMonthVU2025PrevValueMedian = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2025PrevValueMedian;
			
			if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2025PrevValueMedian = RiderMonthVU2025PrevValueMedian + (Ridertemp2023Median * Fund2023ReinvestTo2025Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalMedian != 0 ) {
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00) + RiderMonthVU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00) + (NegativeValueOfMaxCashFundMedian - 1) *
				(RiderMonthVU2025ValueMedian/RiderMonthFundValueOfTheYearValueTotalMedian);
			}
			else{
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00) + RiderMonthVU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstMedian:@"A" ], 1.00/12.00);
			}
			
			if (i == MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				if (Fund2025PartialReinvest != 100) {
					MonthFundMaturityValue2025_Flat = RiderMonthVU2025PrevValueMedian * (100 - Fund2025PartialReinvest)/100.00;
					
					Ridertemp2025Median = currentValue * (100 - Fund2025PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2025_Flat = 0;
				}
				if (aaRound == 2){
					RiderMonthVU2025PrevValueMedian = 0;
				}
				else{
					RiderMonthVU2025PrevValueMedian = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2){
					RiderMonthVU2025PrevValueMedian = currentValue;
				}
				else{
					RiderMonthVU2025PrevValueMedian = tempPrev;
				}
				
			}
			
			
			if (aaRound == 2 && i == 12) {
				RiderVU2025PrevValueMedian = RiderMonthVU2025PrevValueMedian;
			}
			
			
			return currentValue;
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalMedian != 0 ) {
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2025InstMedian) + RiderVU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstMedian:@"A"]) + (RiderNegativeValueOfMaxCashFundMedian - 1) *
				(RiderVU2025ValueMedian/RiderFundValueOfTheYearValueTotalMedian);
			}
			else{
				if (aaRound == 1) {
					currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear]  +
								   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2025InstMedian) + RiderVU2025PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstMedian:@"A"]);
					
					RiderVU2025ValueMedian = currentValue;
				}
				else{
					currentValue = RiderVU2025ValueMedian;
				}
				
			}
			
			if (aaRound == 2) {
				RiderVU2025PrevValueMedian = currentValue;
			}
			
			return currentValue;
		}
		
	}
	
	// below part to be edit later
}


-(double)ReturnRiderVU2025ValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2025) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			
			if (i == 1) {
				RiderMonthVU2025PrevValueLow = RiderVU2025PrevValueLow;
			}
			
			if (i > MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				RiderMonthVU2025PrevValueLow = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2025PrevValueLow;
			
			if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2025PrevValueLow = RiderMonthVU2025PrevValueLow + (Ridertemp2023Low * Fund2023ReinvestTo2025Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalLow != 0 ) {
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2025InstLow:@"A" ], 1.00/12.00) + RiderMonthVU2025PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstLow:@"A" ], 1.00/12.00) + (RiderNegativeValueOfMaxCashFundLow - 1) *
				(RiderMonthVU2025ValueLow/RiderMonthFundValueOfTheYearValueTotalLow);
			}
			else{
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]  * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear  andMonth:i]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2025InstLow:@"A" ], 1.00/12.00) + RiderMonthVU2025PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2025InstLow:@"A" ], 1.00/12.00);
			}
			
			if (i == MonthDiff2025 && aaPolicyYear == YearDiff2025) {
				if (Fund2025PartialReinvest != 100) {
					MonthFundMaturityValue2025_Bear = RiderMonthVU2025PrevValueLow * (100 - Fund2025PartialReinvest)/100.00;
					
					Ridertemp2025Low = currentValue * (100 - Fund2025PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2025_Bear = 0;
				}
				if (aaRound == 2){
					RiderMonthVU2025PrevValueLow = 0;
				}
				else{
					RiderMonthVU2025PrevValueLow = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2){
					RiderMonthVU2025PrevValueLow = currentValue;
				}
				else{
					RiderMonthVU2025PrevValueLow = tempPrev;
				}
				
			}
			
			if (aaRound == 2 && i == 12) {
				RiderVU2025PrevValueLow = RiderMonthVU2025PrevValueLow;
			}
			
			
			return currentValue;
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalLow != 0 ) {
				currentValue =((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] ) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2025InstLow) + RiderVU2025PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstLow:@"A"]) + (RiderNegativeValueOfMaxCashFundLow - 1) *
				(RiderVU2025ValueLow/RiderFundValueOfTheYearValueTotalLow);
			}
			else{
				if (aaRound == 1) {
					currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2025Fac:aaPolicyYear] +
								   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2025Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2025InstLow) + RiderVU2025PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2025InstLow:@"A"]);
					
					RiderVU2025ValueLow = currentValue;
				}
				else{
					currentValue =RiderVU2025ValueLow;
				}
			}
			
			if (aaRound == 2) {
				RiderVU2025PrevValueLow = currentValue;
			}
			
			return currentValue;
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnRiderVU2028ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2028) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				RiderMonthVU2028PrevValuehigh = RiderVU2028PrevValuehigh;
			}
			
			if (i > MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				RiderMonthVU2028PrevValuehigh = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2028PrevValuehigh;
			if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				RiderMonthVU2028PrevValuehigh = RiderMonthVU2028PrevValuehigh + (Ridertemp2025High * Fund2025ReinvestTo2028Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2028PrevValuehigh = RiderMonthVU2028PrevValuehigh + (Ridertemp2023High * Fund2023ReinvestTo2028Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalHigh != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2028InstHigh:@"A" ], 1.00/12.00) + RiderMonthVU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstHigh:@"A"], 1.00/12.00) + (RiderNegativeValueOfMaxCashFundHigh - 1) *
				(RiderMonthVU2028ValueHigh/RiderMonthFundValueOfTheYearValueTotalHigh);
			}
			else{
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2028InstHigh:@"A" ], 1.00/12.00)+ RiderMonthVU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstHigh:@"A"], 1.00/12.00);
			}
			
			if (i == MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				if (Fund2028PartialReinvest != 100) {
					MonthFundMaturityValue2028_Bull = MonthVU2028PrevValuehigh * (100 - Fund2028PartialReinvest)/100.00;
					
					Ridertemp2028High = currentValue * (100 - Fund2028PartialReinvest)/100.00;
					//NSLog(@"%f", temp2028High);
				}
				else{
					MonthFundMaturityValue2028_Bull = 0;
				}
				if (aaRound == 2) {
					RiderMonthVU2028PrevValuehigh = 0;
				}
				else{
					RiderMonthVU2028PrevValuehigh = tempPrev;
				}
			}
			else{
				if (aaRound == 2) {
					RiderMonthVU2028PrevValuehigh = currentValue;
				}
				else{
					RiderMonthVU2028PrevValuehigh = tempPrev;
				}
				
			}
			
			if (i == 12 && aaRound == 2) {
				RiderVU2028PrevValuehigh = RiderMonthVU2028PrevValuehigh;
			}
			
			return currentValue;
			
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalHigh != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2028InstHigh) + RiderVU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstHigh:@"A"]) + (RiderNegativeValueOfMaxCashFundHigh - 1) *
				(RiderVU2028ValueHigh/RiderFundValueOfTheYearValueTotalHigh);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] +
									[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2028InstHigh) + RiderVU2028PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstHigh:@"A"]);
					RiderVU2028ValueHigh = currentValue;
				}
				else{
					currentValue = RiderVU2028ValueHigh;
				}
				
			}
			
			if (aaRound == 2) {
				RiderVU2028PrevValuehigh = currentValue;
			}
			
			return currentValue;
			
		}
		
	}
	
}

-(double)ReturnRiderVU2028ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2028) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				RiderMonthVU2028PrevValueMedian = RiderVU2028PrevValueMedian;
			}
			
			if (i > MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				RiderMonthVU2028PrevValueMedian = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2028PrevValueMedian;
			if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				RiderMonthVU2028PrevValueMedian = RiderMonthVU2028PrevValueMedian + (Ridertemp2025Median * Fund2025ReinvestTo2028Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2028PrevValueMedian = RiderMonthVU2028PrevValueMedian + (Ridertemp2023Median * Fund2023ReinvestTo2028Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalMedian != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2028InstMedian:@"A" ], 1.00/12.00) + RiderMonthVU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstMedian:@"A"],1.00/12.00) + (RiderNegativeValueOfMaxCashFundMedian - 1) *
				(RiderMonthVU2028ValueMedian/RiderMonthFundValueOfTheYearValueTotalMedian);
			}
			else{
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2028InstMedian:@"A" ], 1.00/12.00)+ RiderMonthVU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstMedian:@"A"], 1.00/12.00);
			}
			if (i == MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				if (Fund2028PartialReinvest != 100) {
					MonthFundMaturityValue2028_Flat = RiderMonthVU2028PrevValueMedian * (100 - Fund2028PartialReinvest)/100.00;
					
					Ridertemp2028Median = currentValue * (100 - Fund2028PartialReinvest)/100.00;
					
				}
				else{
					MonthFundMaturityValue2028_Flat = 0;
				}
				
				if (aaRound == 2) {
					RiderMonthVU2028PrevValueMedian = 0;
				}
				else{
					RiderMonthVU2028PrevValueMedian = tempPrev;
				}
			}
			else{
				if (aaRound == 2) {
					RiderMonthVU2028PrevValueMedian = currentValue;
				}
				else{
					RiderMonthVU2028PrevValueMedian = tempPrev;
				}
				
			}
			
			if (i == 12 && aaRound == 2) {
				RiderVU2028PrevValueMedian = RiderMonthVU2028PrevValueMedian;
			}
			
			
			return currentValue;
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalMedian != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2028InstMedian) + RiderVU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstMedian:@"A"]) + (RiderNegativeValueOfMaxCashFundMedian - 1) *
				(RiderVU2028ValueMedian/RiderFundValueOfTheYearValueTotalMedian);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] +
									[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2028InstMedian) + RiderVU2028PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstMedian:@"A"]);
					RiderVU2028ValueMedian = currentValue;
				}
				else{
					currentValue = RiderVU2028ValueMedian;
				}
				
			}
			
			if (aaRound == 2) {
				RiderVU2028PrevValueMedian = currentValue;
			}
			
			return currentValue;
		}
		
	}
	
}

-(double)ReturnRiderVU2028ValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2028) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			if (i == 1) {
				RiderMonthVU2028PrevValueLow = RiderVU2028PrevValueLow;
			}
			
			if (i > MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				RiderMonthVU2028PrevValueLow = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2028PrevValueLow;
			if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				RiderMonthVU2028PrevValueLow = RiderMonthVU2028PrevValueLow + (Ridertemp2025Low * Fund2025ReinvestTo2028Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2028PrevValueLow = RiderMonthVU2028PrevValueLow + (Ridertemp2023Low * Fund2023ReinvestTo2028Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalLow != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2028InstLow:@"A" ], 1.00/12.00) + RiderMonthVU2028PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstLow:@"A"],1.00/12.00) + (RiderNegativeValueOfMaxCashFundLow - 1) *
				(RiderMonthVU2028ValueLow/RiderMonthFundValueOfTheYearValueTotalLow);
			}
			else{
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear  andMonth:i] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2028InstLow:@"A" ], 1.00/12.00)+ RiderMonthVU2028PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2028InstLow:@"A"], 1.00/12.00);
			}
			if (i == MonthDiff2028 && aaPolicyYear == YearDiff2028) {
				if (Fund2028PartialReinvest != 100) {
					MonthFundMaturityValue2028_Bear = RiderMonthVU2028PrevValueLow * (100 - Fund2028PartialReinvest)/100.00;
					
					Ridertemp2028Low = currentValue * (100 - Fund2028PartialReinvest)/100.00;
					
				}
				else{
					MonthFundMaturityValue2028_Bear = 0;
				}
				
				if (aaRound == 2) {
					RiderMonthVU2028PrevValueLow = 0;
				}
				else{
					RiderMonthVU2028PrevValueLow = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2) {
					RiderMonthVU2028PrevValueLow = currentValue;
				}
				else{
					RiderMonthVU2028PrevValueLow = tempPrev;
				}
				
			}
			
			if (i == 12 && aaRound == 2) {
				RiderVU2028PrevValueLow = RiderMonthVU2028PrevValueLow;
			}
			
			
			return currentValue;
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalLow != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2028InstLow) + RiderVU2028PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstLow:@"A"]) + (RiderNegativeValueOfMaxCashFundLow - 1) *
				(RiderVU2028ValueLow/RiderFundValueOfTheYearValueTotalLow);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2028Fac:aaPolicyYear] +
									[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2028Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2028InstLow) + RiderVU2028PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2028InstLow:@"A"]);
					RiderVU2028ValueLow = currentValue;
				}
				else{
					currentValue = RiderVU2028ValueLow;
				}
				
			}
			
			if (aaRound == 2) {
				RiderVU2028PrevValueLow = currentValue;
			}
			
			return currentValue;
		}
		
	}
	
}

-(double)ReturnRiderVU2030ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2030) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			if (i == 1) {
				RiderMonthVU2030PrevValuehigh = RiderVU2030PrevValuehigh;
			}
			
			if (i > MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				RiderMonthVU2030PrevValuehigh = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2030PrevValuehigh;
			if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				RiderMonthVU2030PrevValuehigh = RiderMonthVU2030PrevValuehigh + (Ridertemp2028High * Fund2028ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				RiderMonthVU2030PrevValuehigh = RiderMonthVU2030PrevValuehigh + (Ridertemp2025High * Fund2025ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2030PrevValuehigh = RiderMonthVU2030PrevValuehigh + (Ridertemp2023High * Fund2023ReinvestTo2030Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalHigh != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear  andMonth:i]  +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2030InstHigh:@"A" ], 1.00/12.00) + RiderMonthVU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstHigh:@"A"], 1.00/12.00)  + (RiderNegativeValueOfMaxCashFundHigh - 1) *
				(RiderMonthVU2030ValueHigh/RiderMonthFundValueOfTheYearValueTotalHigh);
			}
			else{
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear  andMonth:i]  +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2030InstHigh:@"A" ], 1.00/12.00) + RiderMonthVU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstHigh:@"A"], 1.00/12.00);
			}
			
			if (i == MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				if (Fund2030PartialReinvest != 100) {
					MonthFundMaturityValue2030_Bear = RiderMonthVU2030PrevValuehigh * (100 - Fund2030PartialReinvest)/100.00;
					
					Ridertemp2030High = currentValue * (100 - Fund2030PartialReinvest)/100.00;
					
				}
				else{
					MonthFundMaturityValue2030_Bear = 0;
				}
				if (aaRound == 2) {
					RiderMonthVU2030PrevValuehigh = 0;
				}
				
			}
			else{
				if (aaRound == 2) {
					RiderMonthVU2030PrevValuehigh = currentValue;
				}
				else{
					RiderMonthVU2030PrevValuehigh = tempPrev;
				}
				
			}
			
			if (aaRound == 2 && i == 12) {
				RiderVU2030PrevValuehigh = RiderMonthVU2030PrevValuehigh;
			}
			
			return currentValue;
			
		}
		else{
			
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalHigh != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2030InstHigh) + RiderVU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstHigh:@"A"]) + (RiderNegativeValueOfMaxCashFundHigh - 1) *
				(RiderVU2030ValueHigh/RiderFundValueOfTheYearValueTotalHigh);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear]  +
									[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2030InstHigh) + RiderVU2030PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstHigh:@"A"]);
					RiderVU2030ValueHigh = currentValue;
				}
				else{
					currentValue = RiderVU2030ValueHigh;
				}
				
			}
			
			if (aaRound == 2) {
				RiderVU2030PrevValuehigh = currentValue;
			}
			
			return currentValue;
			
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnRiderVU2030ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2030) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				RiderMonthVU2030PrevValueMedian = RiderVU2030PrevValueMedian;
			}
			
			if (i > MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				RiderMonthVU2030PrevValueMedian = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2030PrevValueMedian;
			if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				RiderMonthVU2030PrevValueMedian = RiderMonthVU2030PrevValueMedian + (Ridertemp2028Median * Fund2028ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				RiderMonthVU2030PrevValueMedian = RiderMonthVU2030PrevValueMedian + (Ridertemp2025Median * Fund2025ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2030PrevValueMedian = RiderMonthVU2030PrevValueMedian + (Ridertemp2023Median * Fund2023ReinvestTo2030Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative ==TRUE && RiderMonthFundValueOfTheYearValueTotalMedian != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear andMonth:i] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2030InstMedian:@"A" ], 1.00/12.00) + RiderMonthVU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstMedian:@"A"], 1.00/12.00) + (RiderNegativeValueOfMaxCashFundMedian - 1) *
				(RiderMonthVU2030ValueMedian/RiderMonthFundValueOfTheYearValueTotalMedian);
			}
			else{
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear andMonth:i]  +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2030InstMedian:@"A" ], 1.00/12.00) + RiderMonthVU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstMedian:@"A"], 1.00/12.00);
			}
			
			if (i == MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				if (Fund2030PartialReinvest != 100) {
					MonthFundMaturityValue2030_Flat = MonthVU2030PrevValueMedian * (100 - Fund2030PartialReinvest)/100.00;
					Ridertemp2030Median = currentValue * (100 - Fund2030PartialReinvest)/100.00;
				}
				else{
					MonthFundMaturityValue2030_Flat = 0;
				}
				if (aaRound == 2) {
					RiderMonthVU2030PrevValueMedian = 0;
				}
				
			}
			else{
				if (aaRound == 2) {
					RiderMonthVU2030PrevValueMedian = currentValue;
				}
				else{
					RiderMonthVU2030PrevValueMedian = tempPrev;
				}
			}
			
			if (aaRound == 2 && i == 12) {
				RiderVU2030PrevValueMedian = RiderMonthVU2030PrevValueMedian;
			}
			
			
			return currentValue;
			
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalMedian != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2030InstMedian) + RiderVU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstMedian:@"A"]) + (RiderNegativeValueOfMaxCashFundMedian - 1) *
				(RiderVU2030ValueMedian/RiderFundValueOfTheYearValueTotalMedian);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] +
									[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2030InstMedian) + RiderVU2030PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstMedian:@"A"]);
					RiderVU2030ValueMedian = currentValue;
				}
				else{
					currentValue = RiderVU2030ValueMedian;
				}
				
			}
			
			if (aaRound == 2) {
				RiderVU2030PrevValueMedian = currentValue;
			}
			
			return currentValue;
			
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnRiderVU2030ValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2030) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			if (i == 1) {
				RiderMonthVU2030PrevValueLow = RiderVU2030PrevValueLow;
			}
			
			if (i > MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				RiderMonthVU2030PrevValueLow = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2030PrevValueLow;
			if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				RiderMonthVU2030PrevValueLow = RiderMonthVU2030PrevValueLow + (Ridertemp2028Low * Fund2028ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				RiderMonthVU2030PrevValueLow = RiderMonthVU2030PrevValueLow + (Ridertemp2025Low * Fund2025ReinvestTo2030Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2030PrevValueLow = RiderMonthVU2030PrevValueLow + (Ridertemp2023Low * Fund2023ReinvestTo2030Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalLow != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear andMonth:i] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2030InstLow:@"A" ], 1.00/12.00) + RiderMonthVU2030PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstLow:@"A"], 1.00/12.00) + (RiderNegativeValueOfMaxCashFundLow - 1) *
				(RiderMonthVU2030ValueLow/RiderMonthFundValueOfTheYearValueTotalLow);
			}
			else{
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear andMonth:i] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2030InstLow:@"A" ], 1.00/12.00) + RiderMonthVU2030PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2030InstLow:@"A"], 1.00/12.00);
			}
			
			if (i == MonthDiff2030 && aaPolicyYear == YearDiff2030) {
				if (Fund2030PartialReinvest != 100) {
					MonthFundMaturityValue2030_Bear = MonthVU2030PrevValueLow * (100 - Fund2030PartialReinvest)/100.00;
					Ridertemp2030Low = currentValue * (100 - Fund2030PartialReinvest)/100.00;
				}
				else{
					MonthFundMaturityValue2030_Bear = 0;
				}
				if (aaRound == 2) {
					RiderMonthVU2030PrevValueLow = 0;
				}
				
			}
			else{
				if (aaRound == 2) {
					RiderMonthVU2030PrevValueLow = currentValue;
				}
				else{
					RiderMonthVU2030PrevValueLow = tempPrev;
				}
				
			}
			
			if (aaRound == 2 && i == 12) {
				RiderVU2030PrevValueLow = RiderMonthVU2030PrevValueLow;
			}
			
			
			return currentValue;
			
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalLow != 0) {
				currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear] +
							   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2030InstLow) + RiderVU2030PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstLow:@"A"]) + (RiderNegativeValueOfMaxCashFundLow - 1) *
				(RiderVU2030ValueLow/RiderFundValueOfTheYearValueTotalLow);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2030Fac:aaPolicyYear]  +
									[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2030Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2030InstLow) + RiderVU2030PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2030InstLow:@"A"]);
					RiderVU2030ValueLow = currentValue;
				}
				else{
					currentValue = RiderVU2030PrevValueLow;
				}
				
			}
			
			if (aaRound == 2) {
				RiderVU2030PrevValueLow = currentValue;
			}
			
			return currentValue;
			
		}
		
	}
	
	// below part to be edit later
}

-(double)ReturnRiderVU2035ValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(NSInteger)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2035) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			
			if (i == 1) {
				RiderMonthVU2035PrevValuehigh = RiderVU2035PrevValuehigh;
			}
			
			if (i > MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				RiderMonthVU2035PrevValuehigh = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2035PrevValuehigh;
			if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
				RiderMonthVU2035PrevValuehigh = RiderMonthVU2035PrevValuehigh + (Ridertemp2030High * Fund2030ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				RiderMonthVU2035PrevValuehigh = RiderMonthVU2035PrevValuehigh + (Ridertemp2028High * Fund2028ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				RiderMonthVU2035PrevValuehigh = RiderMonthVU2035PrevValuehigh + (Ridertemp2025High * Fund2025ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2035PrevValuehigh = RiderMonthVU2035PrevValuehigh + (Ridertemp2023High * Fund2023ReinvestTo2035Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalHigh != 0 ) {
				
				currentValue=  ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2035InstHigh:@"A"], 1.00/12.00) + RiderMonthVU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2035InstHigh:@"A"], 1.00/12.00) + (RiderNegativeValueOfMaxCashFundHigh - 1) *
				(RiderMonthVU2035ValueHigh/RiderMonthFundValueOfTheYearValueTotalHigh);
				if (aaPolicyYear == 23) {
					//NSLog(@"%f %f %f", NegativeValueOfMaxCashFundHigh, MonthVU2035ValueHigh, MonthFundValueOfTheYearValueTotalHigh );
				}
			}
			else if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalHigh == 0 ) {
				currentValue = 0;
			}
			else{
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
				pow(1 + [self ReturnVU2035InstHigh:@"A"], 1.00/12.00) + RiderMonthVU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow(1 + [self ReturnVU2035InstHigh:@"A"], 1.00/12.00);
			}
			
			if (i == MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				if (Fund2035PartialReinvest != 100) {
					
					MonthFundMaturityValue2035_Bull = RiderMonthVU2035PrevValuehigh * (100 - Fund2035PartialReinvest)/100.00;
					
					Ridertemp2035High = currentValue * (100 - Fund2035PartialReinvest)/100.00;
				}
				else{
					MonthFundMaturityValue2035_Bull = 0;
				}
				
				if (aaRound == 2) {
					RiderMonthVU2035PrevValuehigh = 0;
				}
				else{
					RiderMonthVU2035PrevValuehigh = tempPrev;
				}
				
			}
			
			else{
				
				if (aaRound == 2) {
					RiderMonthVU2035PrevValuehigh = currentValue;
				}
				else{
					RiderMonthVU2035PrevValuehigh = tempPrev;
				}
				
			}
			
			if (i == 12 && aaRound == 2) {
				RiderVU2035PrevValuehigh = RiderMonthVU2035PrevValuehigh;
			}
			
			
			//return MonthVU2035PrevValuehigh;
			return currentValue;
			
			
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalHigh != 0 ) {
				
				currentValue=  ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] ) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2035InstHigh) + RiderVU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstHigh:@"A"]) + (RiderNegativeValueOfMaxCashFundHigh - 1) *
				(RiderVU2035ValueHigh/RiderFundValueOfTheYearValueTotalHigh);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear]  +
									[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2035InstHigh) + RiderVU2035PrevValuehigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstHigh:@"A"]);
					
					RiderVU2035ValueHigh = currentValue;
				}
				else{
					currentValue = RiderVU2035ValueHigh;
				}
				
			}
			
			if (aaRound == 2) {
				RiderVU2035PrevValuehigh = currentValue;
			}
			
			
			return currentValue;
		}
		
		
	}
}

-(double)ReturnRiderVU2035ValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2035) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			if (i == 1) {
				RiderMonthVU2035PrevValueMedian = RiderVU2035PrevValueMedian;
			}
			
			if (i > MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				RiderMonthVU2035PrevValueMedian = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2035PrevValueMedian;
			if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
				RiderMonthVU2035PrevValueMedian = RiderMonthVU2035PrevValueMedian + (Ridertemp2030Median * Fund2030ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				RiderMonthVU2035PrevValueMedian = RiderMonthVU2035PrevValueMedian + (Ridertemp2028Median * Fund2028ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				RiderMonthVU2035PrevValueMedian = RiderMonthVU2035PrevValueMedian + (Ridertemp2025Median * Fund2025ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2035PrevValueMedian = RiderMonthVU2035PrevValueMedian + (Ridertemp2023Median * Fund2023ReinvestTo2035Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalMedian != 0 ) {
				
				currentValue=  ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
				pow((1 + [self ReturnVU2035InstMedian:@"A"]), (1.00/12.00)) + RiderMonthVU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow((1 + [self ReturnVU2035InstMedian:@"A"]), (1.00/12.00)) + (RiderNegativeValueOfMaxCashFundMedian - 1) *
				(RiderMonthVU2035ValueMedian/RiderMonthFundValueOfTheYearValueTotalMedian);
			}
			else{
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] *[self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
				pow((1 + [self ReturnVU2035InstMedian:@"A" ]), (1.00/12.00)) + RiderMonthVU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow((1 + [self ReturnVU2035InstMedian:@"A"]), (1.00/12.00));
			}
			
			
			if (i == MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				if (Fund2035PartialReinvest != 100) {
					MonthFundMaturityValue2035_Flat = RiderMonthVU2035PrevValueMedian * (100 - Fund2035PartialReinvest)/100.00;
					Ridertemp2035Median = currentValue * (100 - Fund2035PartialReinvest)/100.00;
				}
				else{
					MonthFundMaturityValue2035_Flat = 0;
				}
				if (aaRound == 2) {
					RiderMonthVU2035PrevValueMedian = 0;
				}
				else{
					RiderMonthVU2035PrevValueMedian = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2) {
					RiderMonthVU2035PrevValueMedian = currentValue;
				}
				else{
					RiderMonthVU2035PrevValueMedian = tempPrev;
				}
				
			}
			
			if (i == 12 && aaRound == 2) {
				RiderVU2035PrevValueMedian = RiderMonthVU2035PrevValueMedian;
			}
			
			//return MonthVU2035PrevValueMedian;
			return currentValue;
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalMedian != 0 ) {
				
				currentValue=  ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] ) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear]  +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2035InstMedian) + RiderVU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstMedian:@"A"]) + (RiderNegativeValueOfMaxCashFundMedian - 1) *
				(RiderVU2035ValueMedian/RiderFundValueOfTheYearValueTotalMedian);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] +
									[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2035InstMedian) + RiderVU2035PrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstMedian:@"A"]);
					RiderVU2035ValueMedian = currentValue;
				}
				else{
					currentValue = RiderVU2035ValueMedian;
				}
			}
			
			if (aaRound == 2) {
				RiderVU2035PrevValueMedian = currentValue;
			}
			
			return currentValue;
		}
		
		
	}
}

-(double)ReturnRiderVU2035ValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	if (aaPolicyYear > YearDiff2035) {
		return 0;
	}
	else{
		if ([aaYearOrMonth isEqualToString:@"M"]) {
			
			if (i == 1) {
				RiderMonthVU2035PrevValueLow = RiderVU2035PrevValueLow;
			}
			
			if (i > MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				RiderMonthVU2035PrevValueLow = 0;
				return 0;
			}
			
			double tempPrev = RiderMonthVU2035PrevValueLow;
			if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
				RiderMonthVU2035PrevValueLow = RiderMonthVU2035PrevValueLow + (Ridertemp2030Low * Fund2030ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
				RiderMonthVU2035PrevValueLow = RiderMonthVU2035PrevValueLow + (Ridertemp2028Low * Fund2028ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
				RiderMonthVU2035PrevValueLow = RiderMonthVU2035PrevValueLow + (Ridertemp2025Low * Fund2025ReinvestTo2035Fac/100.00);
			}
			else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
				RiderMonthVU2035PrevValueLow = RiderMonthVU2035PrevValueLow + (Ridertemp2023Low * Fund2023ReinvestTo2035Fac/100.00);
			}
			else{
				
			}
			
			if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalLow != 0 ) {
				
				currentValue=  ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i]  +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
				pow((1 + [self ReturnVU2035InstLow:@"A"]), (1.00/12.00)) + RiderMonthVU2035PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow((1 + [self ReturnVU2035InstLow:@"A"]), (1.00/12.00)) + (RiderNegativeValueOfMaxCashFundLow - 1) *
				(RiderMonthVU2035ValueLow/RiderMonthFundValueOfTheYearValueTotalLow);
			}
			else{
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] *[self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear andMonth:i] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
				pow((1 + [self ReturnVU2035InstLow:@"A" ]), (1.00/12.00)) + RiderMonthVU2035PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
				pow((1 + [self ReturnVU2035InstLow:@"A"]), (1.00/12.00));
			}
			
			
			if (i == MonthDiff2035 && aaPolicyYear == YearDiff2035) {
				if (Fund2035PartialReinvest != 100) {
					MonthFundMaturityValue2035_Bear = MonthVU2035PrevValueLow * (100 - Fund2035PartialReinvest)/100.00;
					Ridertemp2035Low = currentValue * (100 - Fund2035PartialReinvest)/100.00;
				}
				else{
					MonthFundMaturityValue2035_Bear = 0;
				}
				
				if (aaRound == 2) {
					RiderMonthVU2035PrevValueLow = 0;
				}
				else{
					RiderMonthVU2035PrevValueLow = tempPrev;
				}
				
			}
			else{
				if (aaRound == 2) {
					RiderMonthVU2035PrevValueLow = currentValue;
				}
				else{
					RiderMonthVU2035PrevValueLow = tempPrev;
				}
			}
			
			if (aaRound == 2 && i == 12) {
				RiderVU2035PrevValueLow = RiderMonthVU2035PrevValueLow;
			}
			
			//return MonthVU2035PrevValueLow;
			return currentValue;
		}
		else{
			if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalLow != 0 ) {
				
				currentValue=  ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] ) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear]  +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
				(1 + VU2035InstLow) + RiderVU2035PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstLow:@"A"]) + (RiderNegativeValueOfMaxCashFundLow - 1) *
				(RiderVU2035ValueLow/RiderFundValueOfTheYearValueTotalLow);
			}
			else{
				if (aaRound == 1) {
					currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] ) + IncreasePrem) * [self ReturnVU2035Fac:aaPolicyYear] +
									[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VU2035Factor * [self ReturnPremiumFactor:i]) *
					(1 + VU2035InstLow) + RiderVU2035PrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVU2035InstLow:@"A"]);
					RiderVU2035ValueLow = currentValue;
				}
				else{
					currentValue = RiderVU2035ValueLow;
				}
			}
			
			if (aaRound == 2) {
				RiderVU2035PrevValueLow = currentValue;
			}
			
			return currentValue;
		}
		
		
	}
}


-(double)ReturnRiderVUCashValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)i {
	
	double tempValue = 0.00;
	
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		if (i == 1) {
			RiderMonthVUCashPrevValueHigh = RiderVUCashPrevValueHigh;
		}
		
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)  ) {
			
			RiderMonthVUCashPrevValueHigh = RiderMonthVUCashPrevValueHigh + (Ridertemp2035High * Fund2035ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			RiderMonthVUCashPrevValueHigh = RiderMonthVUCashPrevValueHigh + (Ridertemp2030High * Fund2030ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			//NSLog(@"%f", temp2028High);
			RiderMonthVUCashPrevValueHigh = RiderMonthVUCashPrevValueHigh + (Ridertemp2028High * Fund2028ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			RiderMonthVUCashPrevValueHigh = RiderMonthVUCashPrevValueHigh + (Ridertemp2025High * Fund2025ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			RiderMonthVUCashPrevValueHigh = RiderMonthVUCashPrevValueHigh + (Ridertemp2023High * Fund2023ReinvestToCashFac/100.00);
		}
		else{
			
		}
		
		tempValue = ((( [[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear andMonth:i] +
					 [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * [self ReturnPremiumFactor:i]) *
		pow((1 + [self ReturnVUCashInstHigh:@"A"]), (1.00/12.00)) + RiderMonthVUCashPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
		pow((1 + [self ReturnVUCashInstHigh:@"A"]), (1.00/12.00)) - ([self ReturnRiderPolicyFee:aaPolicyYear] + [self ReturnTotalRiderMort:aaPolicyYear]);
		
		RiderMonthVUCashPrevValueHigh =  tempValue;
		//NSLog(@"%f", MonthVUCashPrevValueHigh);
		
		if (tempValue < 0) {
			RiderMonthVUCashPrevValueHigh = 1.00;
		}
		else{
			RiderMonthVUCashPrevValueHigh = tempValue;
		}
		
		if (i == 12) {
			RiderVUCashPrevValueHigh = RiderMonthVUCashPrevValueHigh;
		}
		
		if (tempValue < 0 && RiderMonthFundValueOfTheYearValueTotalHigh != 0) {
			RiderNegativeValueOfMaxCashFundHigh = tempValue;
			RiderVUCashValueNegative = TRUE;
			return RiderMonthVUCashPrevValueHigh;
		} else {
			RiderNegativeValueOfMaxCashFundHigh = tempValue;
			RiderVUCashValueNegative = FALSE;
			return RiderMonthVUCashPrevValueHigh + 0; // to be edit later
		}
		
	}
	else
	{
		tempValue = ((( [[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear] +
					 [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear] * [self ReturnPremiumFactor:i]) *
		(1 + [self ReturnVUCashInstHigh:@""]) + RiderVUCashPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVUCashInstHigh:@"A"]) -
		([self ReturnRiderPolicyFee:aaPolicyYear ] + [self ReturnTotalRiderMort:aaPolicyYear]) * [self ReturnVUCashHigh];
		//NSLog(@"%f, %f", [self ReturnRiderPolicyFee:aaPolicyYear ], [self ReturnTotalRiderMort:aaPolicyYear] );
		
		if (tempValue < 0) {
			RiderVUCashPrevValueHigh = 1.00;
		}
		else{
			RiderVUCashPrevValueHigh = tempValue;
		}
		
		
		//VUCashPrevValueHigh = tempValue;
		if (tempValue < 0 && RiderFundValueOfTheYearValueTotalHigh != 0) {
			//NegativeValueOfMaxCashFundHigh = tempValue;
			RiderNegativeValueOfMaxCashFundHigh = tempValue;
			RiderVUCashValueNegative = TRUE;
			return RiderVUCashPrevValueHigh;
		} else {
			RiderVUCashValueNegative = FALSE;
			RiderNegativeValueOfMaxCashFundHigh = tempValue;
			return tempValue + 0; // to be edit later
		}
	}
	
	
	
	
	
}

-(double)ReturnRiderVUCashValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)i{
	
	double tempValue = 0.00;
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		if (i == 1) {
			RiderMonthVUCashPrevValueMedian = RiderVUCashPrevValueMedian;
		}
		
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)  ) {
			RiderMonthVUCashPrevValueMedian = RiderMonthVUCashPrevValueMedian + (Ridertemp2035Median * Fund2035ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			RiderMonthVUCashPrevValueMedian = RiderMonthVUCashPrevValueMedian + (Ridertemp2030Median * Fund2030ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			RiderMonthVUCashPrevValueMedian = RiderMonthVUCashPrevValueMedian + (Ridertemp2028Median * Fund2028ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			RiderMonthVUCashPrevValueMedian = RiderMonthVUCashPrevValueMedian + (Ridertemp2025Median * Fund2025ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			RiderMonthVUCashPrevValueMedian = RiderMonthVUCashPrevValueMedian + (Ridertemp2023Median * Fund2023ReinvestToCashFac/100.00);
		}
		else{
			
		}
		
		tempValue = ((( [[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear andMonth:i] +
					 [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * [self ReturnPremiumFactor:i]) *
		pow(1 + [self ReturnVUCashInstMedian:@"A"], 1.00/12.00) + RiderMonthVUCashPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
		pow(1 + [self ReturnVUCashInstMedian:@"A"], 1.00/12.00) - ([self ReturnRiderPolicyFee:aaPolicyYear ] + [self ReturnTotalRiderMort:aaPolicyYear]);
		
		RiderMonthVUCashPrevValueMedian = tempValue;
		
		if (tempValue < 0) {
			RiderMonthVUCashPrevValueMedian = 1.00;
		}
		else{
			RiderMonthVUCashPrevValueMedian = tempValue;
		}
		
		if (i == 12) {
			RiderVUCashPrevValueMedian = RiderMonthVUCashPrevValueMedian;
		}
		
		
		if (tempValue < 0 && RiderMonthFundValueOfTheYearValueTotalMedian != 0) {
			RiderNegativeValueOfMaxCashFundMedian = tempValue;
			RiderVUCashValueNegative = TRUE;
			return  RiderMonthVUCashPrevValueMedian;
		} else {
			RiderNegativeValueOfMaxCashFundMedian =  tempValue;
			RiderVUCashValueNegative = FALSE;
			return  RiderMonthVUCashPrevValueMedian + 0; // to be edit later
		}
		
		
		
		
	}
	else{
		tempValue = ((( [[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear] +
					 [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear] * [self ReturnPremiumFactor:i]) *
		(1 + [self ReturnVUCashInstMedian:@""]) + RiderVUCashPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVUCashInstMedian:@"A"]) -
		([self ReturnRiderPolicyFee:aaPolicyYear ] + [self ReturnTotalRiderMort:aaPolicyYear]) * [self ReturnVUCashMedian];
		
		
		if (tempValue < 0) {
			RiderVUCashPrevValueMedian = 1.00;
		}
		else{
			RiderVUCashPrevValueMedian = tempValue;
		}
		
		//VUCashPrevValueMedian = tempValue;
		if (tempValue < 0 && RiderFundValueOfTheYearValueTotalMedian != 0) {
			RiderNegativeValueOfMaxCashFundMedian = tempValue;
			RiderVUCashValueNegative = TRUE;
			return RiderVUCashPrevValueMedian;
			//return tempValue;
		} else {
			RiderNegativeValueOfMaxCashFundMedian = tempValue;
			RiderVUCashValueNegative = FALSE;
			return tempValue + 0; // to be edit later
		}
	}
	
	
	
	
}


-(double)ReturnRiderVUCashValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)i{
	
	double tempValue = 0.00;
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		if (i == 1) {
			RiderMonthVUCashPrevValueLow = VUCashPrevValueLow;
		}
		
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)  ) {
			RiderMonthVUCashPrevValueLow = RiderMonthVUCashPrevValueLow + (Ridertemp2035Low * Fund2035ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			RiderMonthVUCashPrevValueLow = RiderMonthVUCashPrevValueLow + (Ridertemp2030Low * Fund2030ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			RiderMonthVUCashPrevValueLow = RiderMonthVUCashPrevValueLow + (Ridertemp2028Low * Fund2028ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			RiderMonthVUCashPrevValueLow = RiderMonthVUCashPrevValueLow + (Ridertemp2025Low * Fund2025ReinvestToCashFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			RiderMonthVUCashPrevValueLow = RiderMonthVUCashPrevValueLow + (Ridertemp2023Low * Fund2023ReinvestToCashFac/100.00);
		}
		else{
			
		}
		
		tempValue = ((( [[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear andMonth:i] +
					 [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear andMonth:i] * [self ReturnPremiumFactor:i]) *
		pow(1 + [self ReturnVUCashInstLow:@"A"], 1.00/12.00) + RiderMonthVUCashPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
		pow(1 + [self ReturnVUCashInstLow:@"A"], 1.00/12.00) - ([self ReturnRiderPolicyFee:aaPolicyYear ] + [self ReturnTotalRiderMort:aaPolicyYear]);
		
		
		
		if (tempValue < 0) {
			RiderMonthVUCashPrevValueLow = 1.00;
		}
		else{
			RiderMonthVUCashPrevValueLow = tempValue;
		}
		
		if (i == 12) {
			RiderVUCashPrevValueLow = RiderMonthVUCashPrevValueLow;
		}
		
		
		
		
		if (tempValue < 0 && RiderMonthFundValueOfTheYearValueTotalLow != 0) {
			RiderNegativeValueOfMaxCashFundLow = tempValue;
			RiderVUCashValueNegative = TRUE;
			return  RiderMonthVUCashPrevValueLow;
		} else {
			RiderNegativeValueOfMaxCashFundLow =  tempValue;
			RiderVUCashValueNegative = FALSE;
			return  RiderMonthVUCashPrevValueLow + 0; // to be edit later
		}
	}
	else{
		tempValue = ((( [[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] ) + IncreasePrem) * [self ReturnVUCashFac:aaPolicyYear] +
					 [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * [self ReturnVUCashFac:aaPolicyYear] * [self ReturnPremiumFactor:i]) *
		(1 + [self ReturnVUCashInstLow:@""]) + RiderVUCashPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVUCashInstLow:@"A"]) -
		([self ReturnRiderPolicyFee:aaPolicyYear ] + [self ReturnTotalRiderMort:aaPolicyYear]) * [self ReturnVUCashLow];
		
		if (tempValue < 0) {
			RiderVUCashPrevValueLow = 1.00;
		}
		else{
			RiderVUCashPrevValueLow = tempValue;
		}
		
		//VUCashPrevValueLow = tempValue;
		if (tempValue < 0 && RiderFundValueOfTheYearValueTotalLow != 0) {
			RiderNegativeValueOfMaxCashFundLow = tempValue;
			RiderVUCashValueNegative = TRUE;
			return RiderVUCashPrevValueLow;
			//return tempValue;
		} else {
			RiderNegativeValueOfMaxCashFundLow = tempValue;
			RiderVUCashValueNegative = FALSE;
			return tempValue + 0; // to be edit later
		}
	}
	
	
	
	
}


-(double)ReturnRiderVURetValueHigh :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(NSInteger)i{
	
	double currentValue =0.0;
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		
		if (i == 1) {
			RiderMonthVURetPrevValueHigh = RiderVURetPrevValueHigh ;
		}
		
		double tempPrev = RiderMonthVURetPrevValueHigh;
		
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)) {
			RiderMonthVURetPrevValueHigh = RiderMonthVURetPrevValueHigh + (Ridertemp2035High * Fund2035ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			RiderMonthVURetPrevValueHigh = RiderMonthVURetPrevValueHigh + (Ridertemp2030High * Fund2030ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			RiderMonthVURetPrevValueHigh = RiderMonthVURetPrevValueHigh + (Ridertemp2028High * Fund2028ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			RiderMonthVURetPrevValueHigh = RiderMonthVURetPrevValueHigh + (Ridertemp2025High * Fund2025ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			RiderMonthVURetPrevValueHigh = RiderMonthVURetPrevValueHigh + (Ridertemp2023High * Fund2023ReinvestToRetFac/100.00);
		}
		else{
			
		}
		
		//NSLog(@"%f", MonthVURetPrevValueHigh);
		if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalHigh != 0 ) {
			currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear andMonth:i] +
						   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
			pow(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"],1.00/12.00) + RiderMonthVURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"], 1.00/12.00) + (RiderNegativeValueOfMaxCashFundHigh - 1) *
			(RiderMonthVURetValueHigh/RiderMonthFundValueOfTheYearValueTotalHigh);
			
			//NSLog(@"%f %f %f",NegativeValueOfMaxCashFundHigh, MonthVURetValueHigh,MonthFundValueOfTheYearValueTotalHigh );
			
		}
		else{
			currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] +
							[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
			pow((1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]),(1.00/12.00)) + RiderMonthVURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow((1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]), (1.00/12.00));
			
			
		}
		
		//NSLog(@"%f, %f, %f, %f",NegativeValueOfMaxCashFundHigh, MonthVURetValueHigh, MonthFundValueOfTheYearValueTotalHigh, currentValue);
		
		if (aaRound == 2) {
			RiderMonthVURetPrevValueHigh = currentValue;
		}
		else{
			RiderMonthVURetPrevValueHigh = tempPrev;
		}
		
		
		if (i == 12  && aaRound == 2) {
			RiderVURetPrevValueHigh = RiderMonthVURetPrevValueHigh;
		}
		
		//NSLog(@"%d %f %f, %d ", i, MonthVURetValueHigh, MonthFundValueOfTheYearValueTotalHigh, VUCashValueNegative);
		//return MonthVURetPrevValueHigh;
		return currentValue;
		
		
		
		
	}
	else{
		//if (VUCashValueHigh < 0 && [self ReturnFundValueOfTheYearValueTotalHigh:aaPolicyYear] != 0 ) {
		if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalHigh != 0 ) {
			currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] ) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] +
						   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
			(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@""]) + RiderVURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]) + (RiderNegativeValueOfMaxCashFundHigh - 1) *
			(RiderVURetValueHigh/RiderFundValueOfTheYearValueTotalHigh);
			
		}
		else{
			if (aaRound == 1) {
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] ) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
				(1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@""]) + RiderVURetPrevValueHigh * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstHigh:aaPolicyYear andMOP:@"A"]);
				RiderVURetValueHigh = currentValue;
			}
			else{
				currentValue = RiderVURetValueHigh;
			}
			
		}
		
		if (aaRound == 2) {
			RiderVURetPrevValueHigh = currentValue;
		}
		
		return currentValue;
	}
	
	
}

-(double)ReturnRiderVURetValueMedian :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		
		if (i == 1) {
			RiderMonthVURetPrevValueMedian = RiderVURetPrevValueMedian ;
		}
		
		double tempPrev = RiderMonthVURetPrevValueMedian;
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)  ) {
			RiderMonthVURetPrevValueMedian = RiderMonthVURetPrevValueMedian + (Ridertemp2035Median * Fund2035ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			RiderMonthVURetPrevValueMedian = RiderMonthVURetPrevValueMedian + (Ridertemp2030Median * Fund2030ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			RiderMonthVURetPrevValueMedian = RiderMonthVURetPrevValueMedian + (Ridertemp2028Median * Fund2028ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			RiderMonthVURetPrevValueMedian = RiderMonthVURetPrevValueMedian + (Ridertemp2025Median * Fund2025ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			RiderMonthVURetPrevValueMedian = RiderMonthVURetPrevValueMedian + (Ridertemp2023Median * Fund2023ReinvestToRetFac/100.00);
		}
		else{
			
		}
		
		if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalMedian != 0 ) {
			currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] +
						   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
			pow(1 + [self ReturnVURetInstMedian], 1.00/12.00) + RiderMonthVURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow(1 + [self ReturnVURetInstMedian], 1.00/12.00) + (RiderNegativeValueOfMaxCashFundMedian - 1) *
			(RiderMonthVURetValueMedian/RiderMonthFundValueOfTheYearValueTotalMedian);
			
		}
		else{
			currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] +
							[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
			pow(1 + [self ReturnVURetInstMedian], 1.00/12.00) + RiderMonthVURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow(1 + [self ReturnVURetInstMedian], 1.00/12.00);
			
		}
		
		if (aaRound == 2) {
			RiderMonthVURetPrevValueMedian = currentValue;
		}
		else{
			RiderMonthVURetPrevValueMedian = tempPrev;
		}
		
		if (i == 12  && aaRound == 2) {
			RiderVURetPrevValueMedian = RiderMonthVURetPrevValueMedian ;
		}
		
		
		//return MonthVURetPrevValueMedian;
		return currentValue;
		
	}
	else{
		//if (VUCashValueMedian < 0 && [self ReturnFundValueOfTheYearValueTotalMedian:aaPolicyYear] != 0 ) {
		if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalMedian != 0 ) {
			currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] +
						   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
			(1 + [self ReturnVURetInstMedian]) + RiderVURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstMedian]) + (RiderNegativeValueOfMaxCashFundMedian - 1) *
			(RiderVURetValueMedian/RiderFundValueOfTheYearValueTotalMedian);
			
		}
		else{
			if (aaRound == 1) {
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
				(1 + [self ReturnVURetInstMedian]) + RiderVURetPrevValueMedian * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstMedian]);
				RiderVURetValueMedian = currentValue;
			}
			else{
				currentValue = RiderVURetValueMedian;
			}
		}
		
		if (aaRound == 2) {
			RiderVURetPrevValueMedian = currentValue;
		}
		return currentValue;
	}
	
}

-(double)ReturnRiderVURetValueLow :(int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andRound:(NSInteger)aaRound andMonth:(int)i{
	
	double currentValue;
	
	
	if ([aaYearOrMonth isEqualToString:@"M"]) {
		
		
		if (i == 1) {
			RiderMonthVURetPrevValueLow = RiderVURetPrevValueLow ;
		}
		
		double tempPrev = RiderMonthVURetPrevValueLow;
		if ((i == MonthDiff2035 + 1 && aaPolicyYear == YearDiff2035)  ) {
			RiderMonthVURetPrevValueLow = RiderMonthVURetPrevValueLow + (Ridertemp2035Low * Fund2035ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2030 + 1 && aaPolicyYear == YearDiff2030){
			RiderMonthVURetPrevValueLow = RiderMonthVURetPrevValueLow + (Ridertemp2030Low * Fund2030ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2028 + 1 && aaPolicyYear == YearDiff2028){
			RiderMonthVURetPrevValueLow = RiderMonthVURetPrevValueLow + (Ridertemp2028Low * Fund2028ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2025 + 1 && aaPolicyYear == YearDiff2025){
			RiderMonthVURetPrevValueLow = RiderMonthVURetPrevValueLow + (Ridertemp2025Low * Fund2025ReinvestToRetFac/100.00);
		}
		else if(i == MonthDiff2023 + 1 && aaPolicyYear == YearDiff2023){
			RiderMonthVURetPrevValueLow = RiderMonthVURetPrevValueLow + (Ridertemp2023Low * Fund2023ReinvestToRetFac/100.00);
		}
		else{
			
		}
		
		if (RiderVUCashValueNegative == TRUE && RiderMonthFundValueOfTheYearValueTotalLow != 0 ) {
			currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] +
						   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
			pow(1 + [self ReturnVURetInstLow], 1.00/12.00) + RiderMonthVURetPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow(1 + [self ReturnVURetInstLow], 1.00/12.00) + (RiderNegativeValueOfMaxCashFundLow - 1) *
			(RiderMonthVURetValueLow/RiderMonthFundValueOfTheYearValueTotalLow);
			
		}
		else{
			currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ] * [self ReturnPremiumFactor:i]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear  andMonth:i] +
							[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
			pow(1 + [self ReturnVURetInstLow], 1.00/12.00) + RiderMonthVURetPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]* [self ReturnLoyaltyBonusFactor:i]/100.00)) *
			pow(1 + [self ReturnVURetInstLow], 1.00/12.00);
			
		}
		
		
		if (aaRound == 2) {
			RiderMonthVURetPrevValueLow = currentValue;
		}
		else{
			RiderMonthVURetPrevValueLow = tempPrev;
		}
		
		if (i == 12  && aaRound == 2) {
			RiderVURetPrevValueLow = RiderMonthVURetPrevValueLow ;
		}
		
		//return MonthVURetPrevValueLow;
		return currentValue;
		
	}
	else{
		if (RiderVUCashValueNegative == TRUE && RiderFundValueOfTheYearValueTotalLow != 0 ) {
			currentValue= ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear]  +
						   [self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
			(1 + [self ReturnVURetInstLow]) + RiderVURetPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstLow]) + (RiderNegativeValueOfMaxCashFundLow - 1) *
			(RiderVURetValueLow/RiderFundValueOfTheYearValueTotalLow);
			
		}
		else{
			if (aaRound == 1) {
				currentValue = ((([[UniTotalRiderPremWithAlloc objectAtIndex:aaPolicyYear - 1] doubleValue ]) + IncreasePrem) * [self ReturnVURetFac:aaPolicyYear] +
								[self ReturnRiderRegTopUpPrem:aaPolicyYear] * RegularAllo * VURetFactor * [self ReturnPremiumFactor:i]) *
				(1 + [self ReturnVURetInstLow]) + RiderVURetPrevValueLow * (1 + ([self ReturnLoyaltyBonus:aaPolicyYear]/100.00)) * (1 + [self ReturnVURetInstLow]);
				RiderVURetValueLow = currentValue;
			}
			else{
				currentValue = RiderVURetValueLow;
			}
			
		}
		
		if (aaRound == 2) {
			RiderVURetPrevValueLow = currentValue;
		}
		return currentValue;
	}
	
}


#pragma mark - Calculate Yearly Fund Value for Basic

-(double)ReturnFundValueOfTheYearValueTotalHigh: (int)aaPolicyYear{
	
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		return [self ReturnFundValueOfTheYearVU2023ValueHigh:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2025ValueHigh:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2028ValueHigh:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2030ValueHigh:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2035ValueHigh:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVURetValueHigh:aaPolicyYear andYearOrMonth:@"M"];
	}
	else{
		return [self ReturnFundValueOfTheYearVU2023ValueHigh:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2025ValueHigh:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2028ValueHigh:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2030ValueHigh:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2035ValueHigh:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVURetValueHigh:aaPolicyYear andYearOrMonth:@"Y"];
	}
	
	/*
	 return  0;
	 */
}



-(double)ReturnFundValueOfTheYearVU2023ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth {
	if (aaPolicyYear <= YearDiff2023) {
		return [self ReturnVU2023ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2025ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2025) {
		return [self ReturnVU2025ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}


-(double)ReturnFundValueOfTheYearVU2028ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2028) {
		return [self ReturnVU2028ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2030ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2030) {
		return [self ReturnVU2030ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2035ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2035) {
		return [self ReturnVU2035ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVURetValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	return [self ReturnVURetValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
}

-(double)ReturnMonthFundValueOfTheYearValueTotalHigh: (int)aaPolicyYear andMonth:(int)aaMonth{
	
	[self ReturnMonthFundValueOfTheYearVURetValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	[self ReturnMonthFundValueOfTheYearVU2023ValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	[self ReturnMonthFundValueOfTheYearVU2025ValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	[self ReturnMonthFundValueOfTheYearVU2028ValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	[self ReturnMonthFundValueOfTheYearVU2030ValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	[self ReturnMonthFundValueOfTheYearVU2035ValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	
	
	return MonthVU2023ValueHigh + MonthVU2025ValueHigh + MonthVU2028ValueHigh + MonthVU2030ValueHigh + MonthVU2035ValueHigh + MonthVURetValueHigh;
	//return  0;
	
}

-(double)ReturnMonthFundValueOfTheYearVU2023ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	
	if (aaPolicyYear <= YearDiff2023) {
		MonthVU2023ValueHigh = [self ReturnVU2023ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return MonthVU2023ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2025ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	
	if (aaPolicyYear <= YearDiff2025) {
		MonthVU2025ValueHigh = [self ReturnVU2025ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return MonthVU2025ValueHigh;
	} else {
		return 0;
	}
}


-(double)ReturnMonthFundValueOfTheYearVU2028ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2028) {
		MonthVU2028ValueHigh = [self ReturnVU2028ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return MonthVU2028ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2030ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2030) {
		MonthVU2030ValueHigh = [self ReturnVU2030ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return MonthVU2030ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2035ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2035) {
		MonthVU2035ValueHigh = [self ReturnVU2035ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return MonthVU2035ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVURetValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	MonthVURetValueHigh = [self ReturnVURetValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
	return MonthVURetValueHigh;
}

-(double)ReturnFundValueOfTheYearValueTotalMedian: (int)aaPolicyYear{
	
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		
		return [self ReturnFundValueOfTheYearVU2023ValueMedian:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2025ValueMedian:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2028ValueMedian:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2030ValueMedian:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2035ValueMedian:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVURetValueMedian:aaPolicyYear andYearOrMonth:@"M"];
	}
	else{
		return [self ReturnFundValueOfTheYearVU2023ValueMedian:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2025ValueMedian:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2028ValueMedian:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2030ValueMedian:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2035ValueMedian:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVURetValueMedian:aaPolicyYear andYearOrMonth:@"Y"];
	}
	/*
	 return  0;
	 */
}


-(double)ReturnFundValueOfTheYearVU2023ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2023) {
		return [self ReturnVU2023ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2025ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2025) {
		return [self ReturnVU2025ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}


-(double)ReturnFundValueOfTheYearVU2028ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2028) {
		return [self ReturnVU2028ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2030ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth {
	if (aaPolicyYear <= YearDiff2030) {
		return [self ReturnVU2030ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2035ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2035) {
		return [self ReturnVU2035ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVURetValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	//return VURetValueMedian;
	return [self ReturnVURetValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
}

-(double)ReturnMonthFundValueOfTheYearValueTotalMedian: (int)aaPolicyYear andMonth:(int)aaMonth{
	
	return [self ReturnMonthFundValueOfTheYearVU2023ValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth] +
	[self ReturnMonthFundValueOfTheYearVU2025ValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth] +
	[self ReturnMonthFundValueOfTheYearVU2028ValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth] +
	[self ReturnMonthFundValueOfTheYearVU2030ValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth] +
	[self ReturnMonthFundValueOfTheYearVU2035ValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth] +
	[self ReturnMonthFundValueOfTheYearVURetValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth];
	
	
	
}


-(double)ReturnMonthFundValueOfTheYearVU2023ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2023) {
		MonthVU2023ValueMedian = [self ReturnVU2023ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return MonthVU2023ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2025ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2025) {
		MonthVU2025ValueMedian = [self ReturnVU2025ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return 	MonthVU2025ValueMedian;
	} else {
		return 0;
	}
}


-(double)ReturnMonthFundValueOfTheYearVU2028ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2028) {
		MonthVU2028ValueMedian = [self ReturnVU2028ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return 	MonthVU2028ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2030ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2030) {
		MonthVU2030ValueMedian = [self ReturnVU2030ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return 	MonthVU2030ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2035ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2035) {
		MonthVU2035ValueMedian = [self ReturnVU2035ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return 	MonthVU2035ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVURetValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	MonthVURetValueMedian = [self ReturnVURetValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
	return 	MonthVURetValueMedian;
}

-(double)ReturnFundValueOfTheYearValueTotalLow: (int)aaPolicyYear{
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		return [self ReturnFundValueOfTheYearVU2023ValueLow:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2025ValueLow:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2028ValueLow:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2030ValueLow:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVU2035ValueLow:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnFundValueOfTheYearVURetValueLow:aaPolicyYear andYearOrMonth:@"M"];
	}
	else{
		return [self ReturnFundValueOfTheYearVU2023ValueLow:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2025ValueLow:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2028ValueLow:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2030ValueLow:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVU2035ValueLow:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnFundValueOfTheYearVURetValueLow:aaPolicyYear andYearOrMonth:@"Y"];
	}
	
	
	/*
	 return  0;
	 */
}


-(double)ReturnFundValueOfTheYearVU2023ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2023) {
		return [self ReturnVU2023ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2025ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2025) {
		return [self ReturnVU2025ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}


-(double)ReturnFundValueOfTheYearVU2028ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2028) {
		return [self ReturnVU2028ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2030ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2030) {
		return [self ReturnVU2030ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVU2035ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2035) {
		return [self ReturnVU2035ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnFundValueOfTheYearVURetValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	return [self ReturnVURetValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
}


-(double)ReturnMonthFundValueOfTheYearValueTotalLow: (int)aaPolicyYear andMonth:(int)aaMonth{
	
	return [self ReturnMonthFundValueOfTheYearVU2023ValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth] +
	[self ReturnMonthFundValueOfTheYearVU2025ValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth] +
	[self ReturnMonthFundValueOfTheYearVU2028ValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth] +
	[self ReturnMonthFundValueOfTheYearVU2030ValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth] +
	[self ReturnMonthFundValueOfTheYearVU2035ValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth] +
	[self ReturnMonthFundValueOfTheYearVURetValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	
	
}

-(double)ReturnMonthFundValueOfTheYearVU2023ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2023) {
		MonthVU2023ValueLow = [self ReturnVU2023ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return MonthVU2023ValueLow;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2025ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2025) {
		MonthVU2025ValueLow = [self ReturnVU2025ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return MonthVU2025ValueLow;
	} else {
		return 0;
	}
}


-(double)ReturnMonthFundValueOfTheYearVU2028ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2028) {
		MonthVU2028ValueLow = [self ReturnVU2028ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return MonthVU2028ValueLow;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2030ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2030) {
		MonthVU2030ValueLow = [self ReturnVU2030ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return MonthVU2030ValueLow;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVU2035ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2035) {
		MonthVU2035ValueLow = [self ReturnVU2035ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return MonthVU2035ValueLow;
	} else {
		return 0;
	}
}

-(double)ReturnMonthFundValueOfTheYearVURetValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	MonthVURetValueLow = [self ReturnVURetValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
	return MonthVURetValueLow;
}

#pragma mark - Calculate Yearly Fund Value for Rider

-(double)ReturnRiderFundValueOfTheYearValueTotalHigh: (int)aaPolicyYear{
	
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		return [self ReturnRiderFundValueOfTheYearVU2023ValueHigh:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2025ValueHigh:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2028ValueHigh:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2030ValueHigh:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2035ValueHigh:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVURetValueHigh:aaPolicyYear andYearOrMonth:@"M"];
	}
	else{
		return [self ReturnRiderFundValueOfTheYearVU2023ValueHigh:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2025ValueHigh:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2028ValueHigh:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2030ValueHigh:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2035ValueHigh:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVURetValueHigh:aaPolicyYear andYearOrMonth:@"Y"];
	}
	
	/*
	 return  0;
	 */
}



-(double)ReturnRiderFundValueOfTheYearVU2023ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth {
	if (aaPolicyYear <= YearDiff2023) {
		return [self ReturnRiderVU2023ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVU2025ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2025) {
		return [self ReturnRiderVU2025ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}


-(double)ReturnRiderFundValueOfTheYearVU2028ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2028) {
		return [self ReturnRiderVU2028ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVU2030ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2030) {
		return [self ReturnRiderVU2030ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVU2035ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2035) {
		return [self ReturnRiderVU2035ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVURetValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	return [self ReturnRiderVURetValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
}

-(double)ReturnRiderMonthFundValueOfTheYearValueTotalHigh: (int)aaPolicyYear andMonth:(int)aaMonth{
	
	[self ReturnRiderMonthFundValueOfTheYearVURetValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	[self ReturnRiderMonthFundValueOfTheYearVU2023ValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	[self ReturnRiderMonthFundValueOfTheYearVU2025ValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	[self ReturnRiderMonthFundValueOfTheYearVU2028ValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	[self ReturnRiderMonthFundValueOfTheYearVU2030ValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	[self ReturnRiderMonthFundValueOfTheYearVU2035ValueHigh:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	
	
	return RiderMonthVU2023ValueHigh + RiderMonthVU2025ValueHigh + RiderMonthVU2028ValueHigh + RiderMonthVU2030ValueHigh + RiderMonthVU2035ValueHigh + RiderMonthVURetValueHigh;
	//return  0;
	
}

-(double)ReturnRiderMonthFundValueOfTheYearVU2023ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	
	if (aaPolicyYear <= YearDiff2023) {
		RiderMonthVU2023ValueHigh = [self ReturnRiderVU2023ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return RiderMonthVU2023ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVU2025ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	
	if (aaPolicyYear <= YearDiff2025) {
		RiderMonthVU2025ValueHigh = [self ReturnRiderVU2025ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return RiderMonthVU2025ValueHigh;
	} else {
		return 0;
	}
}


-(double)ReturnRiderMonthFundValueOfTheYearVU2028ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2028) {
		RiderMonthVU2028ValueHigh = [self ReturnRiderVU2028ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return RiderMonthVU2028ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVU2030ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2030) {
		RiderMonthVU2030ValueHigh = [self ReturnRiderVU2030ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return RiderMonthVU2030ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVU2035ValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2035) {
		RiderMonthVU2035ValueHigh = [self ReturnRiderVU2035ValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return RiderMonthVU2035ValueHigh;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVURetValueHigh: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	RiderMonthVURetValueHigh = [self ReturnRiderVURetValueHigh:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
	return RiderMonthVURetValueHigh;
}

-(double)ReturnRiderFundValueOfTheYearValueTotalMedian: (int)aaPolicyYear{
	
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		
		return [self ReturnRiderFundValueOfTheYearVU2023ValueMedian:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2025ValueMedian:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2028ValueMedian:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2030ValueMedian:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2035ValueMedian:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVURetValueMedian:aaPolicyYear andYearOrMonth:@"M"];
	}
	else{
		return [self ReturnRiderFundValueOfTheYearVU2023ValueMedian:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2025ValueMedian:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2028ValueMedian:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2030ValueMedian:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2035ValueMedian:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVURetValueMedian:aaPolicyYear andYearOrMonth:@"Y"];
	}
	/*
	 return  0;
	 */
}


-(double)ReturnRiderFundValueOfTheYearVU2023ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2023) {
		return [self ReturnRiderVU2023ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
		
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVU2025ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2025) {
		return [self ReturnRiderVU2025ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}


-(double)ReturnRiderFundValueOfTheYearVU2028ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2028) {
		return [self ReturnRiderVU2028ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVU2030ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth {
	if (aaPolicyYear <= YearDiff2030) {
		return [self ReturnRiderVU2030ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVU2035ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2035) {
		return [self ReturnRiderVU2035ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVURetValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	//return VURetValueMedian;
	return [self ReturnRiderVURetValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
}

-(double)ReturnRiderMonthFundValueOfTheYearValueTotalMedian: (int)aaPolicyYear andMonth:(int)aaMonth{
	
	return
	[self ReturnRiderMonthFundValueOfTheYearVU2023ValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth] +
	[self ReturnRiderMonthFundValueOfTheYearVU2025ValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth] +
	[self ReturnRiderMonthFundValueOfTheYearVU2028ValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth] +
	[self ReturnRiderMonthFundValueOfTheYearVU2030ValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth] +
	[self ReturnRiderMonthFundValueOfTheYearVU2035ValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth] +
	[self ReturnRiderMonthFundValueOfTheYearVURetValueMedian:aaPolicyYear andYearOrMonth:@"M" andMont:aaMonth];
	
	
	
}


-(double)ReturnRiderMonthFundValueOfTheYearVU2023ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2023) {
		RiderMonthVU2023ValueMedian = [self ReturnRiderVU2023ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return RiderMonthVU2023ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVU2025ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2025) {
		RiderMonthVU2025ValueMedian = [self ReturnRiderVU2025ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return 	RiderMonthVU2025ValueMedian;
	} else {
		return 0;
	}
}


-(double)ReturnRiderMonthFundValueOfTheYearVU2028ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2028) {
		RiderMonthVU2028ValueMedian = [self ReturnRiderVU2028ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return 	RiderMonthVU2028ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVU2030ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2030) {
		RiderMonthVU2030ValueMedian = [self ReturnRiderVU2030ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return 	RiderMonthVU2030ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVU2035ValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2035) {
		RiderMonthVU2035ValueMedian = [self ReturnRiderVU2035ValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return 	RiderMonthVU2035ValueMedian;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVURetValueMedian: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMont:(int)aaMonth{
	RiderMonthVURetValueMedian = [self ReturnRiderVURetValueMedian:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
	return 	RiderMonthVURetValueMedian;
}

-(double)ReturnRiderFundValueOfTheYearValueTotalLow: (int)aaPolicyYear{
	if (aaPolicyYear == YearDiff2035 || aaPolicyYear == YearDiff2030 || aaPolicyYear == YearDiff2028
		|| aaPolicyYear == YearDiff2025 || aaPolicyYear == YearDiff2023) {
		return [self ReturnRiderFundValueOfTheYearVU2023ValueLow:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2025ValueLow:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2028ValueLow:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2030ValueLow:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVU2035ValueLow:aaPolicyYear andYearOrMonth:@"M"] +
		[self ReturnRiderFundValueOfTheYearVURetValueLow:aaPolicyYear andYearOrMonth:@"M"];
	}
	else{
		return [self ReturnRiderFundValueOfTheYearVU2023ValueLow:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2025ValueLow:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2028ValueLow:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2030ValueLow:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVU2035ValueLow:aaPolicyYear andYearOrMonth:@"Y"] +
		[self ReturnRiderFundValueOfTheYearVURetValueLow:aaPolicyYear andYearOrMonth:@"Y"];
	}
	
	
	/*
	 return  0;
	 */
}


-(double)ReturnRiderFundValueOfTheYearVU2023ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2023) {
		return [self ReturnRiderVU2023ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVU2025ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2025) {
		return [self ReturnRiderVU2025ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}


-(double)ReturnRiderFundValueOfTheYearVU2028ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2028) {
		return [self ReturnRiderVU2028ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVU2030ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2030) {
		return [self ReturnRiderVU2030ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVU2035ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	if (aaPolicyYear <= YearDiff2035) {
		return [self ReturnRiderVU2035ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
	} else {
		return 0;
	}
}

-(double)ReturnRiderFundValueOfTheYearVURetValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth{
	return [self ReturnRiderVURetValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:0];
}


-(double)ReturnRiderMonthFundValueOfTheYearValueTotalLow: (int)aaPolicyYear andMonth:(int)aaMonth{
	
	return [self ReturnRiderMonthFundValueOfTheYearVU2023ValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth] +
	[self ReturnRiderMonthFundValueOfTheYearVU2025ValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth] +
	[self ReturnRiderMonthFundValueOfTheYearVU2028ValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth] +
	[self ReturnRiderMonthFundValueOfTheYearVU2030ValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth] +
	[self ReturnRiderMonthFundValueOfTheYearVU2035ValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth] +
	[self ReturnRiderMonthFundValueOfTheYearVURetValueLow:aaPolicyYear andYearOrMonth:@"M" andMonth:aaMonth];
	
	
}

-(double)ReturnRiderMonthFundValueOfTheYearVU2023ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2023) {
		RiderMonthVU2023ValueLow = [self ReturnRiderVU2023ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return RiderMonthVU2023ValueLow;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVU2025ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2025) {
		RiderMonthVU2025ValueLow = [self ReturnRiderVU2025ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return RiderMonthVU2025ValueLow;
	} else {
		return 0;
	}
}


-(double)ReturnRiderMonthFundValueOfTheYearVU2028ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2028) {
		RiderMonthVU2028ValueLow = [self ReturnRiderVU2028ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return RiderMonthVU2028ValueLow;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVU2030ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2030) {
		RiderMonthVU2030ValueLow = [self ReturnRiderVU2030ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return RiderMonthVU2030ValueLow;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVU2035ValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	if (aaPolicyYear <= YearDiff2035) {
		RiderMonthVU2035ValueLow = [self ReturnRiderVU2035ValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
		return RiderMonthVU2035ValueLow;
	} else {
		return 0;
	}
}

-(double)ReturnRiderMonthFundValueOfTheYearVURetValueLow: (int)aaPolicyYear andYearOrMonth:(NSString *)aaYearOrMonth andMonth:(int)aaMonth{
	RiderMonthVURetValueLow = [self ReturnRiderVURetValueLow:aaPolicyYear andYearOrMonth:aaYearOrMonth andRound:1 andMonth:aaMonth];
	return RiderMonthVURetValueLow;
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

-(double)ReturnVU2025Fac :(int)aaPolicyYear andMonth:(int)aaMonth {
	double factor1 = (double)VU2025Factor;
	double factor2 = factor1 + (double)VU2023Factor * (factor1/[self FactorGroup:2]);
	double factor3 = 0.00;
	
	if (aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTermPrev2025 && aaMonth > MonthDiff2023) {
		return factor2/100.00;
	}
	else if (aaPolicyYear == FundTerm2025 && aaMonth <= MonthDiff2025){
		return factor2/100.00;
	}
	else if (aaPolicyYear > FundTerm2025 && aaMonth > MonthDiff2025){
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

-(double)ReturnVU2028Fac :(int)aaPolicyYear andMonth:(int)aaMonth {
	double factor1 = (double)VU2028Factor;
	double factor2 = factor1 + (double)VU2023Factor * (factor1/[self FactorGroup:2]);
	double factor3 = factor2 + (double)VU2025Factor * (factor2/[self FactorGroup:3]);;
	double factor4 = 0.00;
	
	if (aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTermPrev2025 && aaMonth > MonthDiff2023) {
		return factor2/100.00;
	}
	else if (aaPolicyYear == FundTerm2025 && aaMonth <= MonthDiff2025) {
		return factor2/100.00;
	}
	else if (aaPolicyYear >= FundTerm2025 && aaPolicyYear <= FundTermPrev2028 && aaMonth > MonthDiff2025) {
		return factor3/100.00;
	}
	else if (aaPolicyYear == FundTerm2028 && aaMonth <= MonthDiff2028) {
		return factor3/100.00;
	}
	else if (aaPolicyYear > FundTerm2028 && aaMonth > MonthDiff2028){
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
	double factor4 = factor3 + (double)VU2028Factor * (factor3/[self FactorGroup:4]);;
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

-(double)ReturnVU2030Fac :(int)aaPolicyYear andMonth:(int)aaMonth {
	double factor1 = (double)VU2030Factor;
	double factor2 = factor1 + (double)VU2023Factor * (factor1/[self FactorGroup:2]);
	double factor3 = factor2 + (double)VU2025Factor * (factor2/[self FactorGroup:3]);;
	double factor4 = factor3 + (double)VU2028Factor * (factor3/[self FactorGroup:4]);;
	double factor5 = 0.00;
	
	if (aaPolicyYear >= FundTerm2023 && aaPolicyYear <= FundTermPrev2025 && aaMonth > MonthDiff2023) {
		return factor2/100.00;
	}
	else if (aaPolicyYear == FundTerm2025 && aaMonth <= MonthDiff2025) {
		return factor2/100.00;
	}
	else if (aaPolicyYear >= FundTerm2025 && aaPolicyYear <= FundTermPrev2028 && aaMonth > MonthDiff2025) {
		return factor3/100.00;
	}
	else if (aaPolicyYear == FundTerm2028 && aaMonth <= MonthDiff2028) {
		return factor3/100.00;
	}
	else if (aaPolicyYear >= FundTerm2028 && aaPolicyYear <= FundTermPrev2030 && aaMonth > MonthDiff2028) {
		return factor4/100.00;
	}
	else if (aaPolicyYear == FundTerm2030 && aaMonth <= MonthDiff2030) {
		return factor4/100.00;
	}
	else if (aaPolicyYear > FundTerm2030 && aaMonth > MonthDiff2030) {
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
	double factor4 = factor3 + (double)VU2028Factor * (factor3/[self FactorGroup:4]);
	double factor5 = factor4 + (double)VU2030Factor * (factor4/[self FactorGroup:5]);
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
	double factor4 = factor3 + (double)VU2028Factor * (factor3/[self FactorGroup:4]);
	double factor5 = factor4 + (double)VU2030Factor * (factor4/[self FactorGroup:5]);
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
	return [strBasicSA doubleValue ] * (([self ReturnBasicMort:Age + aaPolicyYear -1]/1000.00) * (1 + [getHLPct doubleValue ]/100.00) +
											 [getHL doubleValue] + [getOccLoading doubleValue ])/12.00;
}

-(double)ReturnTotalBasicMortMedian: (int)aaPolicyYear{
	return [strBasicSA doubleValue ] * (([self ReturnBasicMort:Age + aaPolicyYear -1]/1000.00) * (1 + [getHLPct doubleValue ]/100.00) +
											 [getHL doubleValue] + [getOccLoading doubleValue ])/12.00;
}

-(double)ReturnTotalBasicMortLow: (int)aaPolicyYear{
	return [strBasicSA doubleValue ] * (([self ReturnBasicMort:Age + aaPolicyYear -1]/1000.00) * (1 + [getHLPct doubleValue ]/100.00) +
											 [getHL doubleValue] + [getOccLoading doubleValue ])/12.00;
}

-(double)ReturnTotalRiderMort: (int)aaPolicyYear{
	double tempTotal = 0.00;
	sqlite3_stmt *statement;
	NSString *QuerySQL;
	NSMutableArray *UnitizeRiderAlloc = [[NSMutableArray alloc] init ];
	NSMutableArray *UnitizeRiderMort = [[NSMutableArray alloc] init ];
	/*
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		QuerySQL = [NSString stringWithFormat: @"Select ridercode, SumAssured, ifnull(Hloading, '0') as Hloading, ifnull(HLoadingPct, '0') as HLoadingPct, "
					"RiderTerm, planOption, Deductible from ul_rider_details Where  "
					"  sino = '%@' AND ridercode in ('CIRD', 'DCA', 'ACIR', 'HMM', 'MG_IV', "
					"'WI', 'MR', 'TPDMLA', 'PA', 'DHI')", SINo];
		
		//NSLog(@"%@", QuerySQL);
		if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
				[UnitizeRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
				[UnitizeRiderSA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
				[UnitizeRiderHL addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
				[UnitizeRiderHLPct addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)]];
				[UnitizeRiderTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)]];
				[UnitizeRiderPlanChoice addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)]];
				[UnitizeRiderDeductible addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)]];
				//NSLog(@"10- 1 ok");
			}
            sqlite3_finalize(statement);
        }
		
		sqlite3_close(contactDB);
	}
	*/
	if (sqlite3_open([UL_RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK){

		for (int i = 0; i < UnitizeRiderCode.count; i++) {
			if ([[UnitizeRiderCode objectAtIndex:i] isEqualToString:@"ACIR"]) {
				QuerySQL = [NSString stringWithFormat: @"select Rate from ES_Sys_Rider_Mort where plancode = '%@' AND sex = '%@' AND fromage='%d' AND smoker = '%@' ",
							[UnitizeRiderCode objectAtIndex:i] ,getSexLA, Age + aaPolicyYear - 1, getSmokerLA];
			}
			else if ([[UnitizeRiderCode objectAtIndex:i] isEqualToString:@"CIRD"]){
				QuerySQL = [NSString stringWithFormat: @"select Rate from ES_Sys_Rider_Mort where plancode = '%@' AND sex = '%@' AND fromage='%d' AND PolYear = '%d' AND Term = '%@' ",
							[UnitizeRiderCode objectAtIndex:i], getSexLA, Age + aaPolicyYear - 1, aaPolicyYear, [UnitizeRiderTerm objectAtIndex:i] ];
			}
			else if ([[UnitizeRiderCode objectAtIndex:i] isEqualToString:@"WI"] ||
					 [[UnitizeRiderCode objectAtIndex:i] isEqualToString:@"PA"] ||
					 [[UnitizeRiderCode objectAtIndex:i] isEqualToString:@"MR"] ||
					 [[UnitizeRiderCode objectAtIndex:i] isEqualToString:@"TPDMLA"] ||
					 [[UnitizeRiderCode objectAtIndex:i] isEqualToString:@"DHI"] ||
					 [[UnitizeRiderCode objectAtIndex:i] isEqualToString:@"DCA"]){
				
				QuerySQL = [NSString stringWithFormat: @"select Rate from ES_Sys_Rider_Mort where plancode = '%@' AND sex = '%@' AND fromage='%d' AND  OccClass= '%d' ",
							[UnitizeRiderCode objectAtIndex:i], getSexLA, Age + aaPolicyYear - 1, getOccpClass ];
			}
			else if ([[UnitizeRiderCode objectAtIndex:i] isEqualToString:@"HMM"]){
				NSString *ccc;
				if ([[UnitizeRiderPlanChoice objectAtIndex:i] isEqualToString:@"HMM_150"]) {
					ccc = @"MM150";
				}
				else if ([[UnitizeRiderPlanChoice objectAtIndex:i] isEqualToString:@"HMM_200"]) {
					ccc = @"MM200";
				}
				else if ([[UnitizeRiderPlanChoice objectAtIndex:i] isEqualToString:@"HMM_300"]) {
					ccc = @"MM300";
				}
				else if ([[UnitizeRiderPlanChoice objectAtIndex:i] isEqualToString:@"HMM_400"]) {
					ccc = @"MM400";
				}
				
				QuerySQL = [NSString stringWithFormat: @"select Rate from ES_Sys_Rider_Mort where plancode = '%@' AND sex = '%@' AND fromage='%d' AND  OccClass= '%d' "
							"AND Type = '%@' AND Deductible = '%@'",
							[UnitizeRiderCode objectAtIndex:i], getSexLA, Age + aaPolicyYear - 1, getOccpClass, ccc, [UnitizeRiderDeductible objectAtIndex:i] ];
			}
			else if ([[UnitizeRiderCode objectAtIndex:i] isEqualToString:@"MG_IV"]){
				NSString *ccc;
				if ([[UnitizeRiderPlanChoice objectAtIndex:i] isEqualToString:@"MGIVP_150"]) {
					ccc = @"MGIV_150";
				}
				else if ([[UnitizeRiderPlanChoice objectAtIndex:i] isEqualToString:@"MGIVP_200"]) {
					ccc = @"MGIV_200";
				}
				else if ([[UnitizeRiderPlanChoice objectAtIndex:i] isEqualToString:@"MGIVP_300"]) {
					ccc = @"MGIV_300";
				}
				else if ([[UnitizeRiderPlanChoice objectAtIndex:i] isEqualToString:@"MGIVP_400"]) {
					ccc = @"MGIV_400";
				}
				
				
				QuerySQL = [NSString stringWithFormat: @"select Rate from ES_Sys_Rider_Mort where plancode = '%@' AND sex = '%@' AND fromage='%d' AND  OccClass= '%d' "
							"AND Type = '%@'",
							[UnitizeRiderCode objectAtIndex:i], getSexLA, Age + aaPolicyYear - 1, getOccpClass, ccc];
			}
			
			
			//NSLog(@"%@", QuerySQL);
			if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
				if (sqlite3_step(statement) == SQLITE_ROW) {
					[UnitizeRiderMort addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
						//NSLog(@"10- 2 ok");
				}
				else{
					[UnitizeRiderMort addObject:@"0.00"];
				}
				sqlite3_finalize(statement);
			}
			else{
				[UnitizeRiderMort addObject:@"0.00"];
			}
			
			QuerySQL = [NSString stringWithFormat: @"select Rate from ES_Sys_Rider_Allocation where Term = '%@' AND PolYear = '%d'",
						[UnitizeRiderTerm objectAtIndex:i], aaPolicyYear];
				
				//NSLog(@"%@", QuerySQL);
			if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
				if (sqlite3_step(statement) == SQLITE_ROW) {
					[UnitizeRiderAlloc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
					
				}
				else{
					[UnitizeRiderAlloc addObject:@"0.00"];
				}
				sqlite3_finalize(statement);
			}
			else{
				[UnitizeRiderAlloc addObject:@"0.00"];
			}
			
		}
		sqlite3_close(contactDB);

	}

	for (int i = 0; i < [UnitizeRiderCode count]; i++) {

		NSString *RidercodeFromArray = [UnitizeRiderCode objectAtIndex:i];
		double SAFromArray = [[UnitizeRiderSA objectAtIndex:i] doubleValue ];
		double HLFromArray = [[UnitizeRiderHL objectAtIndex:i] doubleValue ];
		double  HLPctFromArray = [[UnitizeRiderHLPct objectAtIndex:i] doubleValue ];
		double  RiderMortFromArray = [[UnitizeRiderMort objectAtIndex:i] doubleValue ];
		double RiderAllocFromArray = [[UnitizeRiderAlloc objectAtIndex:i]doubleValue ]/100.00;
		
		//NSLog(@"%d, %@, %f, %f, %f, %f, %f", aaPolicyYear,  RidercodeFromArray, SAFromArray, HLFromArray, HLPctFromArray, RiderMortFromArray, RiderAllocFromArray);
		if ([RidercodeFromArray isEqualToString:@"CIRD"] || [RidercodeFromArray isEqualToString:@"ACIR" ] ) {
			tempTotal = tempTotal +  (SAFromArray * (RiderMortFromArray/1000.00) * (1.00 + HLPctFromArray/100.00) + HLFromArray + SAFromArray * [getOccLoading doubleValue]/1000.00)/12.00 * RiderAllocFromArray;
			if ([RidercodeFromArray isEqualToString:@"CIRD"]) {
				CIRDExist = TRUE;
			}

		}
		else if ([RidercodeFromArray isEqualToString:@"WI"] || [RidercodeFromArray isEqualToString:@"PA" ] ||
				 [RidercodeFromArray isEqualToString:@"PA"] || [RidercodeFromArray isEqualToString:@"MR" ] ||
				 [RidercodeFromArray isEqualToString:@"TPDMLA"] || [RidercodeFromArray isEqualToString:@"DCA" ]) {
			
			tempTotal = tempTotal +  (SAFromArray * (RiderMortFromArray/100.00) * RiderAllocFromArray * (1 + HLPctFromArray/100.00) + HLFromArray + SAFromArray * [getOccLoading doubleValue ]/1000.00)/12.00;
		}
		else if ([RidercodeFromArray isEqualToString:@"DCA"]) {
			tempTotal = tempTotal +  ((10000.00 + SAFromArray) * (RiderMortFromArray/100.00) * RiderAllocFromArray * (1 + HLPctFromArray/100.00) + HLFromArray + (10000.00 + SAFromArray) * [getOccLoading doubleValue ]/1000.00)/12;
		}
		else if ([RidercodeFromArray isEqualToString:@"HMM"] || [RidercodeFromArray isEqualToString:@"MG_IV"] ) {
			tempTotal = tempTotal +  (RiderMortFromArray * (1 + HLPctFromArray/100.00) + HLFromArray + SAFromArray * [getOccLoading doubleValue ]/1000.00)/12.00 * RiderAllocFromArray;
		}
		
	}

	return tempTotal;
}

-(double)ReturnRiderPolicyFee: (int)aaPolicyYear{
	//sqlite3_stmt *statement;
	//NSString *QuerySQL;

	/*
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
		QuerySQL = [NSString stringWithFormat: @"Select * From UL_Rider_Details Where sino = '%@' AND ridercode in ('CIRD')", SINo];
		
		//NSLog(@"%@", QuerySQL);
		if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
				cird
			}
            sqlite3_finalize(statement);
        }
		
		sqlite3_close(contactDB);
	}
	 */
	if (CIRDExist == TRUE) {
		if (aaPolicyYear <= 10) {
			return 3.00;
		}
		else{
			return 0.00;
		}
	}
	else{
		return 0.00;
	}
}

-(double)ReturnBasicCommisionFee: (int)aaPolicyYear{
	sqlite3_stmt *statement;
	NSString *QuerySQL;
	double value = 0.00;
	
	 if (sqlite3_open([UL_RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK){
		 QuerySQL = [NSString stringWithFormat: @"Select Rate From ES_Sys_Basic_Commission Where Year = %d", aaPolicyYear];
	 
		 //NSLog(@"%@", QuerySQL);
		 if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			 if (sqlite3_step(statement) == SQLITE_ROW) {
				 value = sqlite3_column_double(statement, 0);
			 }
			 else{
				 value = 0.00;
			 }
			 sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	 }

	
	return value;
}

-(double)ReturnRiderCommisionFee: (int)aaPolicyYear{
	sqlite3_stmt *statement;
	NSString *QuerySQL;
	double value = 0.00;
	double TotalValue = 0.00;
	
	if (sqlite3_open([UL_RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK){
		for (int i =0; i < [UnitizeRiderCode count]; i++) {
			QuerySQL = [NSString stringWithFormat: @"Select Rate From ES_Sys_Rider_Commission Where PolYear = %d AND RiderTerm = '%@' ",
						aaPolicyYear, [UnitizeRiderTerm objectAtIndex:i]];
			
			//NSLog(@"%@", QuerySQL);
			if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
				if (sqlite3_step(statement) == SQLITE_ROW) {
					value = sqlite3_column_double(statement, 0);
				}
				else{
					value = 0.00;
				}
				sqlite3_finalize(statement);
			}
			
			TotalValue = TotalValue + ([[UnitizeRiderPremium objectAtIndex:i] doubleValue ] * value)/100.00;
		}
		
		sqlite3_close(contactDB);
	}
	
	
	return TotalValue;
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

-(double)ReturnVU2023InstLow: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0113432;
	}
	else{
		return 0;
	}
}

-(double)ReturnVU2025InstLow: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.01146;
	}
	else{
		return 0;
	}
}

-(double)ReturnVU2028InstLow: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0121202;
	}
	else{
		return 0;
	}
}

-(double)ReturnVU2030InstLow: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0121884;
	}
	else{
		return 0;
	}
}

-(double)ReturnVU2035InstLow: (NSString *)aaMOP{
	if ([aaMOP isEqualToString:@"A"]) {
		return 0.0122828;
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
		MOP = strBumpMode;
	} else {
		MOP = aaMOP;
	}
	
	if (sqlite3_open([UL_RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK){
		
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
		MOP = strBumpMode;
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
		MOP = strBumpMode;
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
		MOP = strBumpMode;
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
	NSString *MOP = strBumpMode;
	
	if ([aaMOP isEqualToString:@""]) {
		MOP = strBumpMode;
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
	
	if ([strBumpMode isEqualToString:@"A"]) {
		return 0.03324;
	}
	else if ([strBumpMode isEqualToString:@"S"]) {
		return 0.0248621;
	}
	else if ([strBumpMode isEqualToString:@"Q"]) {
		return 0.0206901;
	}
	else {
		return 0.0179151;
	}
}

-(double)ReturnVURetInstLow{
	if ([strBumpMode isEqualToString:@"A"]) {
		return 0.02312;
	}
	else if ([strBumpMode isEqualToString:@"S"]) {
		return 0.017307;
	}
	else if ([strBumpMode isEqualToString:@"Q"]) {
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
	NSString *MOP = strBumpMode;
	
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
	
	NSLog(@"yeardiff2023:%d, yeardiff2025:%d, yeardiff2028:%d, yeardiff2030:%d,yeardiff2035:%d ", YearDiff2023,YearDiff2025,
		  YearDiff2028, YearDiff2030, YearDiff2035);
	
	
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
	if ([strRTUPAmount isEqualToString:@""]) {
		return 0;
	}
	else {
		if (aaPolicyYear >= [strRTUPFrom intValue ] && aaPolicyYear <= [strRTUPFrom intValue] + [strRTUPFor intValue] ) {
			return [strRTUPAmount doubleValue ];
		}
		else{
			return 0;
		}
	}
}

-(double)ReturnDivideMode{
	if ([strBumpMode isEqualToString:@"A"]) {
		return 1.00;
	}
	else if ([strBumpMode isEqualToString:@"S"]) {
		return 2.00;
	}
	else if ([strBumpMode isEqualToString:@"Q"]) {
		return 4.00;
	}
	else{
		return 12.00;
	}
}

-(double)ReturnPremAllocation: (int)aaPolYear{
	if (aaPolYear == 1) {
		if ([strBasicPremium doubleValue ] >= 12000 && [strBasicPremium doubleValue ] < 24000 ) {
			return 0.4 + 0.02;
		}
		else if ([strBasicPremium doubleValue ] >= 24000){
			return 0.4 + 0.04;
		}
		else{
			return 0.4;
		}
	}
	else if (aaPolYear == 2){
		if ([strBasicPremium doubleValue ] >= 12000 && [strBasicPremium doubleValue ] < 24000 ) {
			return 0.52 + 0.02;
		}
		else if ([strBasicPremium doubleValue ] >= 24000){
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
	
	querySQL = [NSString stringWithFormat:@"Select Rate From ES_Sys_Basic_Mort WHERE PlanCode = 'UV' AND Sex = '%@' AND Age='%d' AND Smoker ='%@' "
				, getSexLA, zzAge, getSmokerLA];
	
	//NSLog(@"%@", querySQL);
	if (sqlite3_open([UL_RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK){
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
     	NSDate* d = [[df dateFromString:getDOB] dateByAddingTimeInterval:8*60*60 - 1800 ];
		NSDate* d2 = [[df dateFromString:getPlanCommDate]dateByAddingTimeInterval:8*60*60  ];
		
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
		NSLog(@"error, no DOB and plan Comm date");
		return -1;
	}
}

- (NSUInteger)monthsBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
	
    NSCalendar *calendar = [NSCalendar currentCalendar];
	//NSLog(@"%@ %@", fromDateTime, toDateTime);
	
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&fromDate
				 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&toDate
				 interval:NULL forDate:toDateTime];
	
    NSDateComponents *difference = [calendar components:NSMonthCalendarUnit
											   fromDate:fromDate toDate:toDate options:0];
	

	//NSLog(@"%d", [difference month]);
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


-(double)FromBasic:(NSString *)aaATPrem andGetHL:(NSString *)aaGetHL andGetHLPct:(NSString *)aaGetHLPct
	   andBumpMode:(NSString *)aaBumpMode andBasicSA:(NSString *)aaBasicSA
	   andRTUPFrom:(NSString *)aaRTUPFrom andRTUPFor:(NSString *)aaRTUPFor andRTUPAmount:(NSString *)aaRTUPAmount
	   andSmokerLA:(NSString *)aaSmokerLA andOccLoading:(NSString *)aaOccLoading andPlanCommDate:(NSString *)aaPlanCommDate
			andDOB:(NSString *)aaDOB andSexLA:(NSString *)aaSexLA andSino:(NSString *)aaSino andLAAge:(int)aaLAAge{
	
	NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    UL_RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"UL_Rates.sqlite"]];
	
	strBasicPremium = aaATPrem;
	getHL = aaGetHL;
	getHLPct = aaGetHLPct;
	strBumpMode = aaBumpMode;
	strBasicSA = aaBasicSA;
	BasicSA = [aaBasicSA doubleValue];
	strRTUPFrom = aaRTUPFrom;
	strRTUPFor = aaRTUPFor;
	strRTUPAmount = aaRTUPAmount;
	getSmokerLA = aaSmokerLA;
	getOccLoading = aaOccLoading;
	getPlanCommDate = aaPlanCommDate;
	getDOB = aaDOB;
	getSexLA = aaSexLA;
	SINo = aaSino;
	Age = aaLAAge;
	
	NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %d", aaATPrem, aaGetHL, aaGetHLPct, aaBumpMode, aaBasicSA, aaRTUPFrom, aaRTUPFor,
		  aaRTUPAmount, aaSmokerLA, aaOccLoading, aaPlanCommDate, aaDOB, aaSexLA, aaSino, aaLAAge);
	SimpleOrDetail = @"Simple";
	[self PopulateData];
	
	return [self CalculateBUMP];
}

@end
