//
//  PremiumViewController.m
//  HLA
//
//  Created by shawal sapuan on 9/11/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PremiumViewController.h"
#import "MainScreen.h"

@interface PremiumViewController ()

@end

@implementation PremiumViewController
@synthesize WebView;
@synthesize requestBasicSA,requestBasicHL,requestMOP,requestTerm,requestPlanCode,requestSINo,requestAge,requestOccpCode;
@synthesize basicRate,LSDRate,riderCode,riderSA,riderHL1K,riderHL100,riderHLP,riderRate,riderTerm;
@synthesize riderDesc,planCodeRider,riderUnit,riderPlanOpt,riderDeduct,pentaSQL;
@synthesize plnOptC,planOptHMM,deducHMM,planHSPII,planMGII,planMGIV;
@synthesize riderAge,riderCustCode,riderSmoker;
@synthesize annualRiderTot,halfRiderTot,quarterRiderTot,monthRiderTot;
@synthesize htmlRider,occLoad,annualRider,halfYearRider,quarterRider,monthlyRider,annualRiderSum,halfRiderSum,monthRiderSum,quarterRiderSum;
@synthesize premBH,premH;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    requestSINo = premBH.storedSINo;
    requestTerm = premBH.storedCovered;
    requestOccpCode = premBH.storedOccpCode;
    requestPlanCode = premBH.storedPlanCode;
    requestMOP = premBH.storedMOP;
    requestAge = premBH.storedAge;
    requestBasicSA = premBH.storedbasicSA;
    requestBasicHL = premBH.storedbasicHL;
    
    NSLog(@"Prem-SINo:%@, MOP:%d, term:%d, sa:%@, hl:%@, occpcode:%@",requestSINo,self.requestMOP,self.requestTerm,self.requestBasicSA,self.requestBasicHL,[self.requestOccpCode description]);
    
    [self getBasicPentaRate];
    [self getLSDRate];
    [self getOccLoad];
    NSLog(@"basicRate:%d,lsdRate:%d,pa_cpa:%d",basicRate,LSDRate,occLoad);
    
    [self checkExistRider];
    if ([riderCode count] != 0) {
        NSLog(@"rider exist!");
        [self calculateRiderPrem];
    } else {
        NSLog(@"rider not exist!");
    }
    
    [self calculatePremium];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)doClose:(id)sender
{
    MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
    main.modalPresentationStyle = UIModalPresentationFullScreen;
    main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    main.mainH = premH;
    main.mainBH = premBH;
    main.IndexTab = 3;
    [self presentModalViewController:main animated:YES];
}

#pragma mark - Calculation

-(void)calculatePremium
{
    double BasicSA = [[self.requestBasicSA description] doubleValue];
    double PolicyTerm = self.requestTerm;
    double BasicHLoad = [[self.requestBasicHL description] doubleValue];
    
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
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:22.368511]];
    NSString *numberString2 = [formatter stringFromNumber:[NSNumber numberWithFloat:22.364511]];
    NSLog(@"result 1:%@, result 2:%@",numberString,numberString2);
    [formatter release];*/
    
    NSString *displayLSD = nil;
    if (BasicSA < 1000) {
        displayLSD = @"Policy Fee Loading";
        LSDAnnually = 0 - LSDAnnually;
        LSDHalfYear = 0 - LSDHalfYear;
        LSDQuarterly = 0 - LSDQuarterly;
        LSDMonthly = 0 - LSDMonthly;
    } else {
        displayLSD = @"Large Size";
    }
    
    NSString *htmlBasic = [[NSString alloc] initWithFormat:
                 @"<html><body><table border='1' width='500' align='left'> "
                 "<tr><td>Description</td><td>Annually</td><td>Semi-annual</td><td>Quarterly</td><td>Monthly</td></tr>"
                 "<tr><td>Basic</td><td>%.3f</td><td>%.3f</td><td>%.3f</td><td>%.3f</td></tr>"
                 "<tr><td>Occupation Loading</td><td>%.3f</td><td>%.3f</td><td>%.3f</td><td>%.3f</td></tr>"
                 "<tr><td>Health Loading</td><td>%.3f</td><td>%.3f</td><td>%.3f</td><td>%.3f</td></tr>"
                 "<tr><td>%@</td><td>%.3f</td><td>%.3f</td><td>%.3f</td><td>%.3f</td></tr>"
                 "<tr><td>Sub-Total</td><td>%.3f</td><td>%.3f</td><td>%.3f</td><td>%.3f</td>"
                 "</tr>",BasicAnnually, BasicHalfYear, BasicQuarterly, BasicMonthly, OccpLoadA, OccpLoadH, OccpLoadQ, OccpLoadM, BasicHLAnnually, BasicHLHalfYear, BasicHLQuarterly, BasicHLMonthly, displayLSD, LSDAnnually, LSDHalfYear, LSDQuarterly, LSDMonthly, basicTotalA, basicTotalS, basicTotalQ, basicTotalM];
    
    NSString *htmlTail = nil;
    if ([riderCode count] != 0) {
        
        double annualSUM = annualRiderSum + basicTotalA;
        double halfSUM = halfRiderSum + basicTotalS;
        double quarterSUM = quarterRiderSum + basicTotalQ;
        double monthSUM = monthRiderSum + basicTotalM;
        
        htmlTail = [[NSString alloc] initWithFormat:
                    @"<tr><td colspan='5'>&nbsp;</td></tr>"
                    "<tr><td>Total</td><td>%.3f</td><td>%.3f</td><td>%.3f</td><td>%.3f</td></tr>"
                    "</table></body></html>",annualSUM,halfSUM,quarterSUM,monthSUM];
        
        NSString *htmlString = [htmlBasic stringByAppendingString:htmlRider];
        htmlString = [htmlString stringByAppendingString:htmlTail];
        NSURL *baseURL = [NSURL URLWithString:@""];
        [WebView loadHTMLString:htmlString baseURL:baseURL];
    } else {
        
        htmlTail = [[NSString alloc] initWithFormat:
                    @"<tr><td colspan='5'>&nbsp;</td></tr>"
                    "<tr><td>Total</td><td>%.3f</td><td>%.3f</td><td>%.3f</td><td>%.3f</td></tr>"
                    "</table></body></html>",basicTotalA, basicTotalS, basicTotalQ, basicTotalM];
        
        NSString *htmlString = [htmlBasic stringByAppendingString:htmlTail];
        NSURL *baseURL = [NSURL URLWithString:@""];
        [WebView loadHTMLString:htmlString baseURL:baseURL];
    }
}

-(void)calculateRiderPrem
{
    annualRiderTot = [[NSMutableArray alloc] init];
    halfRiderTot = [[NSMutableArray alloc] init];
    quarterRiderTot = [[NSMutableArray alloc] init];
    monthRiderTot = [[NSMutableArray alloc] init];
    NSUInteger i;
    for (i=0; i<[riderCode count]; i++) {
        //getpentacode
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            if ([[riderCode objectAtIndex:i] isEqualToString:@"C+"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"1"]) {
                    plnOptC = @"L";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"2"]) {
                    plnOptC = @"I";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"3"]) {
                    plnOptC = @"B";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"4"]) {
                    plnOptC = @"N";
                }
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",plnOptC];
                
            }
            else if ([[riderCode objectAtIndex:i] isEqualToString:@"HMM"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"H150"]) {
                    planOptHMM = @"HMM_150";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"H200"]) {
                    planOptHMM = @"HMM_200";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"H300"]) {
                    planOptHMM = @"HMM_300";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"H400"]) {
                    planOptHMM = @"HMM_400";
                }
                
                if ([[riderDeduct objectAtIndex:i] isEqualToString:@"1"]) {
                    deducHMM = @"5000";
                } else if ([[riderDeduct objectAtIndex:i] isEqualToString:@"2"]) {
                    deducHMM = @"10000";
                } else if ([[riderDeduct objectAtIndex:i] isEqualToString:@"3"]) {
                    deducHMM = @"15000";
                }
                pentaSQL = [[NSString alloc] initWithFormat:
                        @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"HMM\" AND PlanOption=\"%@\" AND Deductible=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planOptHMM,deducHMM,[riderAge objectAtIndex:i],[riderAge objectAtIndex:i]];
                
            }
            else if ([[riderCode objectAtIndex:i] isEqualToString:@"HSP_II"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"STD"]) {
                    planHSPII = @"S";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"DLX"]) {
                    planHSPII = @"D";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"PRE"]) {
                    planHSPII = @"P";
                }
                pentaSQL = [[NSString alloc] initWithFormat:
                        @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",planHSPII];
                
            }
            else if ([[riderCode objectAtIndex:i] isEqualToString:@"MG_II"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"M100"]) {
                    planMGII = @"MG_II_100";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"M200"]) {
                    planMGII = @"MG_II_200";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"M300"]) {
                    planMGII = @"MG_II_300";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"M400"]) {
                    planMGII = @"MG_II_400";
                }
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",planMGII];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I40R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID40R"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND PremPayOpt=\"%d\"",[riderCode objectAtIndex:i],self.requestMOP];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"ICR"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"ICR\" AND Smoker=\"%@\"",[riderSmoker objectAtIndex:i]];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"MG_IV"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"MV150"]) {
                    planMGIV = [[NSString alloc] initWithFormat:@"MGIVP_150"];
                } else  if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"MV200"]) {
                    planMGIV = [[NSString alloc] initWithFormat:@"MGIVP_200"];
                } else  if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"MV300"]) {
                    planMGIV = [[NSString alloc] initWithFormat:@"MGIVP_300"];
                } else  if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"MV400"]) {
                    planMGIV = [[NSString alloc] initWithFormat:@"MGIVP_400"];
                }
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"MG_IV\" AND PlanOption=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planMGIV,[riderAge objectAtIndex:i],[riderAge objectAtIndex:i]];
            }
            else {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND Channel=\"AGT\"",[riderCode objectAtIndex:i]];
            }
            
            NSLog(@"%@",pentaSQL);
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
        
        int ridTerm = [[riderTerm objectAtIndex:i] intValue];
        //get rate
        if ([[riderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I40R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID40R"])
        {
            [self getIncomeRiderRate:planCodeRider riderTerm:ridTerm];
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"CPA"]) {
            [self getCPARiderRate:planCodeRider riderTerm:ridTerm];
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"PA"]) {
            [self getPARiderRate:planCodeRider riderTerm:ridTerm];
        }
        else {
            [self getRiderRate:planCodeRider riderTerm:ridTerm];
        }
        
        double BasicSA = [[self.requestBasicSA description] doubleValue];
        double BasicHLoad = [[self.requestBasicHL description] doubleValue];
        
        double ridSA = [[riderSA objectAtIndex:i] doubleValue];
        double PolicyTerm = self.requestTerm;
        double riderHLoad;
        if ([riderHL1K count] != 0) {
            riderHLoad = [[riderHL1K objectAtIndex:i] doubleValue];
        } else if ([riderHL100 count] != 0) {
            riderHLoad = [[riderHL100 objectAtIndex:i] doubleValue];
        } else if ([riderHLP count] != 0) {
            riderHLoad = [[riderHLP objectAtIndex:i] doubleValue];
        }
        NSLog(@"riderRate:%d, ridersum:%.3f, HL:%.3f",riderRate,ridSA,riderHLoad);
        
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
        
        if ([[riderCode objectAtIndex:i] isEqualToString:@"ETPD"])
        {
            double fsar = (65 - self.requestAge) * ridSA;
            annualRider = (riderRate + RiderHLAnnually/10)*(ridSA/100) * 1 + fsar/1000 * OccpLoadA * 1;
            halfYearRider = (riderRate + RiderHLHalfYear/10)*(ridSA/100) * 0.5125 + fsar/1000 * OccpLoadA * 0.5125;
            quarterRider = (riderRate + RiderHLQuarterly/10)*(ridSA/100) * 0.2625 + fsar/1000 * OccpLoadA * 0.2625;
            monthlyRider = (riderRate + RiderHLMonthly/10)*(ridSA/100) * 0.0875 + fsar/1000 * OccpLoadA * 0.0875;
            
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I40R"])
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
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"ICR"])
        {
            annualRider = (riderRate + OccpLoadA * ridTerm + RiderHLAnnually) * ridSA/1000 * 1;
            halfYearRider = (riderRate + OccpLoadH * ridTerm + RiderHLHalfYear) * ridSA/1000 * 0.5125;
            quarterRider = (riderRate + OccpLoadQ * ridTerm + RiderHLQuarterly) * ridSA/1000 * 0.2625;
            monthlyRider = (riderRate + OccpLoadM * ridTerm + RiderHLMonthly) * ridSA/1000 * 0.0875;
            
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"ID20R"])
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
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"ID30R"])
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
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"ID40R"])
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
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"MG_II"]||[[riderCode objectAtIndex:i] isEqualToString:@"MG_IV"]||[[riderCode objectAtIndex:i] isEqualToString:@"HSP_II"]||[[riderCode objectAtIndex:i] isEqualToString:@"HMM"])
        {
            annualRider = riderRate * (1 + RiderHLAnnually/100) * 1;
            halfYearRider = riderRate * (1 + RiderHLHalfYear/100) * 0.5125;
            quarterRider = riderRate * (1 + RiderHLQuarterly/100) * 0.2625;
            monthlyRider = riderRate * (1 + RiderHLMonthly/100) * 0.0875;
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"HB"])
        {
            int selectUnit = [[riderUnit objectAtIndex:i] intValue];
            annualRider = riderRate * (1 + RiderHLAnnually/100) * selectUnit * 1;
            halfYearRider = riderRate * (1 + RiderHLHalfYear/100) * selectUnit * 0.5125;
            quarterRider = riderRate * (1 + RiderHLQuarterly/100) * selectUnit * 0.2625;
            monthlyRider = riderRate * (1 + RiderHLMonthly/100) * selectUnit * 0.0875;
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"CIWP"]||[[riderCode objectAtIndex:i] isEqualToString:@"LCWP"]||[[riderCode objectAtIndex:i] isEqualToString:@"PR"]||[[riderCode objectAtIndex:i] isEqualToString:@"SP_STD"]||[[riderCode objectAtIndex:i] isEqualToString:@"SP_PRE"])
        {
            double RiderHLAnnually = BasicHLoad * (BasicSA/1000) * 1;
            double RiderHLHalfYear = BasicHLoad * (BasicSA/1000) * 0.5125;
            double RiderHLQuarterly = BasicHLoad * (BasicSA/1000) * 0.2625;
            double RiderHLMonthly = BasicHLoad * (BasicSA/1000) * 0.0875;

            annualRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadA + RiderHLAnnually/100) * 1;
            halfYearRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadH + RiderHLHalfYear/100) * 0.5125;
            annualRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadQ + RiderHLQuarterly/100) * 0.2625;
            annualRider = ridSA * (riderRate/100 + ridTerm/1000 * OccpLoadM + RiderHLMonthly/100) * 0.0875;
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"PLCP"]||[[riderCode objectAtIndex:i] isEqualToString:@"PTR"])
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
        else {
            annualRider = (riderRate + OccpLoadA + RiderHLAnnually) * (ridSA/1000) * 1;
            halfYearRider = (riderRate + OccpLoadH  + RiderHLHalfYear) * (ridSA/1000) * 0.5125;
            quarterRider = (riderRate + OccpLoadQ  + RiderHLQuarterly) * (ridSA/1000) * 0.2625;
            monthlyRider = (riderRate + OccpLoadM + RiderHLMonthly) * (ridSA/1000) * 0.0875;
        }
        
        NSString *calRiderAnn = [NSString stringWithFormat:@"%.3f",annualRider];
        NSString *calRiderHalf = [NSString stringWithFormat:@"%.3f",halfYearRider];
        NSString *calRiderQuarter = [NSString stringWithFormat:@"%.3f",quarterRider];
        NSString *calRiderMonth = [NSString stringWithFormat:@"%.3f",monthlyRider];
        [annualRiderTot addObject:calRiderAnn];
        [halfRiderTot addObject:calRiderHalf];
        [quarterRiderTot addObject:calRiderQuarter];
        [monthRiderTot addObject:calRiderMonth];
        NSLog(@"RiderTotal A:%@, S:%@, Q:%@, M:%@",[annualRiderTot objectAtIndex:i],[halfRiderTot objectAtIndex:i],[quarterRiderTot objectAtIndex:i],[monthRiderTot objectAtIndex:i]);
    }
    
    annualRiderSum = 0;
    halfRiderSum = 0;
    quarterRiderSum = 0;
    monthRiderSum = 0;
    NSUInteger a;
    for (a=0; a<[riderCode count]; a++) {
        int ridTerm = [[riderTerm objectAtIndex:a] intValue];
        NSString *title = [[NSString alloc ]initWithFormat:@"%@ - (%d years)",[riderDesc objectAtIndex:a],ridTerm];
        if (htmlRider.length == 0) {
            htmlRider = [[NSString alloc]initWithFormat:
                         @"<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>"
                         "<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td>"
                         "</tr>",title,[annualRiderTot objectAtIndex:a],[halfRiderTot objectAtIndex:a],[quarterRiderTot objectAtIndex:a],[monthRiderTot objectAtIndex:a]];
        } else {
            
            htmlRider = [htmlRider stringByAppendingFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td>""</tr>",title,[annualRiderTot objectAtIndex:a],[halfRiderTot objectAtIndex:a],[quarterRiderTot objectAtIndex:a],[monthRiderTot objectAtIndex:a]];
        }
        annualRiderSum = annualRiderSum + [[annualRiderTot objectAtIndex:a] doubleValue];
        halfRiderSum = halfRiderSum + [[halfRiderTot objectAtIndex:a] doubleValue];
        quarterRiderSum = quarterRiderSum + [[quarterRiderTot objectAtIndex:a] doubleValue];
        monthRiderSum = monthRiderSum + [[monthRiderTot objectAtIndex:a] doubleValue];
    }
}



#pragma mark - handle db
-(void)getBasicPentaRate
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Basic_Prem WHERE PlanCode=\"%@\" AND FromTerm=\"%d\" AND FromMortality=0",[self.requestPlanCode description],self.requestTerm];
        
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
                              @"SELECT LSD FROM Trad_Sys_LSD_HLAIB WHERE PremPayOpt=\"%d\" AND FromSA <=\"%@\" AND ToSA >= \"%@\"",self.requestMOP,[self.requestBasicSA description],[self.requestBasicSA description]];
        
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

-(void)checkExistRider
{
    riderCode = [[NSMutableArray alloc] init];
    riderDesc = [[NSMutableArray alloc] init];
    riderTerm = [[NSMutableArray alloc] init];
    riderSA = [[NSMutableArray alloc] init];
    riderPlanOpt = [[NSMutableArray alloc] init];
    riderUnit = [[NSMutableArray alloc] init];
    riderDeduct = [[NSMutableArray alloc] init];
    riderHL1K = [[NSMutableArray alloc] init];
    riderHL100 = [[NSMutableArray alloc] init];
    riderHLP = [[NSMutableArray alloc] init];
    riderCustCode = [[NSMutableArray alloc] init];
    riderSmoker = [[NSMutableArray alloc] init];
    riderAge = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
            @"SELECT a.RiderCode, b.RiderDesc, a.RiderTerm, a.SumAssured, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, a.HL100SA, a.HLPercentage, c.CustCode,d.Smoker,d.ALB from Trad_Rider_Details a, Trad_Sys_Rider_Profile b, Trad_LAPayor c, Clt_Profile d WHERE a.RiderCode=b.RiderCode AND a.PTypeCode=c.PTypeCode AND a.Seq=c.Sequence AND d.CustCode=c.CustCode AND a.SINo=c.SINo AND a.SINo=\"%@\"", [self.requestSINo description]];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [riderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [riderDesc addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                
                const char *RTerm = (const char *) sqlite3_column_text(statement, 2);
                [riderTerm addObject:RTerm == NULL ? nil :[[NSString alloc] initWithUTF8String:(const char *)RTerm]];
                 
                const char *RsumA = (const char *) sqlite3_column_text(statement, 3);
                [riderSA addObject:RsumA == NULL ? nil :[[NSString alloc] initWithUTF8String:RsumA]];
                
                const char *plan = (const char *) sqlite3_column_text(statement, 4);
                [riderPlanOpt addObject:plan == NULL ? nil :[[NSString alloc] initWithUTF8String:plan]];

                const char *uni = (const char *) sqlite3_column_text(statement, 5);
                [riderUnit addObject:uni == NULL ? nil :[[NSString alloc] initWithUTF8String:uni]];

                const char *deduct2 = (const char *) sqlite3_column_text(statement, 6);
                [riderDeduct addObject:deduct2 == NULL ? nil :[[NSString alloc] initWithUTF8String:deduct2]];
                
                const char *ridHL = (const char *)sqlite3_column_text(statement, 7);
                [riderHL1K addObject:ridHL == NULL ? nil :[[NSString alloc] initWithUTF8String:ridHL]];
                
                const char *ridHL100 = (const char *)sqlite3_column_text(statement, 8);
                [riderHL100 addObject:ridHL100 == NULL ? nil :[[NSString alloc] initWithUTF8String:ridHL100]];
                
                const char *ridHLP = (const char *)sqlite3_column_text(statement, 9);
                [riderHLP addObject:ridHLP == NULL ? nil :[[NSString alloc] initWithUTF8String:ridHLP]];
                
                [riderCustCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)]];
                [riderSmoker addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)]];
                [riderAge addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)]];
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
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE PlanCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND Sex=\"%@\"",aaplan,aaterm,aaterm,premH.storedSex];
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
                @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE PlanCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\"",aaplan,aaterm,aaterm,premH.storedAge,premH.storedAge];
        
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
                @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE PlanCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\"",aaplan,aaterm,aaterm,premH.storedAge,premH.storedAge];
        
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

-(void)getOccLoad
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                        @"SELECT OccLoading_TL FROM Adm_Occp_Loading_Penta WHERE OccpCode=\"%@\"",[self.requestOccpCode description]];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
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

#pragma mark - memory management

- (void)viewDidUnload
{
    [self setRequestPlanCode:nil];
    [self setWebView:nil];
    [self setRequestBasicHL:nil];
    [self setRequestBasicSA:nil];
    [self setRiderCode:nil];
    [self setRiderSA:nil];
    [self setRiderHL1K:nil];
    [self setRiderHL100:nil];
    [self setRiderHLP:nil];
    [self setRequestSINo:nil];
    [self setRiderTerm:nil];
    [self setRiderDesc:nil];
    [self setPlanCodeRider:nil];
    [self setRiderPlanOpt:nil];
    [self setRiderUnit:nil];
    [self setRiderDeduct:nil];
    [self setPentaSQL:nil];
    [self setPlnOptC:nil];
    [self setPlanOptHMM:nil];
    [self setDeducHMM:nil];
    [self setPlanHSPII:nil];
    [self setPlanMGII:nil];
    [self setRiderAge:nil];
    [self setRiderSmoker:nil];
    [self setRiderCustCode:nil];
    [self setPlanMGIV:nil];
    [self setAnnualRiderTot:nil];
    [self setHalfRiderTot:nil];
    [self setQuarterRiderTot:nil];
    [self setMonthRiderTot:nil];
    [self setRequestOccpCode:nil];
    [super viewDidUnload];
}

@end
