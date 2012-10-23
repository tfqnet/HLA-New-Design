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
    
    NSLog(@"Prem-SINo:%@, MOP:%d, term:%d, sa:%@, hl:%@, occpcode:%@ sex:%@",requestSINo,self.requestMOP,self.requestTerm,self.requestBasicSA,self.requestBasicHL,[self.requestOccpCode description],premH.storedSex);
    
    [self getBasicPentaRate];
    [self getLSDRate];
    [self getOccLoad];
    NSLog(@"basicRate:%d,lsdRate:%d,occload:%d",basicRate,LSDRate,occLoad);
    
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
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
//    [formatter setMaximumFractionDigits:2];
    
    //calculate basic premium
    double _BasicAnnually = basicRate * (BasicSA/1000) * 1;
    double _BasicHalfYear = basicRate * (BasicSA/1000) * 0.5125;
    double _BasicQuarterly = basicRate * (BasicSA/1000) * 0.2625;
    double _BasicMonthly = basicRate * (BasicSA/1000) * 0.0875;
    NSString *BasicAnnually = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicAnnually]];
    NSString *BasicHalfYear = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicHalfYear]];
    NSString *BasicQuarterly = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicQuarterly]];
    NSString *BasicMonthly = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicMonthly]];
    
    //calculate occupationLoading
    double _OccpLoadA = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 1;
    double _OccpLoadH = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.5125;
    double _OccpLoadQ = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.2625;
    double _OccpLoadM = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * 0.0875;
    NSString *OccpLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadA]];
    NSString *OccpLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadH]];
    NSString *OccpLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadQ]];
    NSString *OccpLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadM]];
    
    //calculate basic health loading
    double _BasicHLAnnually = BasicHLoad * (BasicSA/1000) * 1;
    double _BasicHLHalfYear = BasicHLoad * (BasicSA/1000) * 0.5125;
    double _BasicHLQuarterly = BasicHLoad * (BasicSA/1000) * 0.2625;
    double _BasicHLMonthly = BasicHLoad * (BasicSA/1000) * 0.0875;
    NSString *BasicHLAnnually = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicHLAnnually]];
    NSString *BasicHLHalfYear = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicHLHalfYear]];
    NSString *BasicHLQuarterly = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicHLQuarterly]];
    NSString *BasicHLMonthly = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicHLMonthly]];
    
    //calculate LSD
    double _LSDAnnually = LSDRate * (BasicSA/1000) * 1;
    double _LSDHalfYear = LSDRate * (BasicSA/1000) * 0.5125;
    double _LSDQuarterly = LSDRate * (BasicSA/1000) * 0.2625;
    double _LSDMonthly = LSDRate * (BasicSA/1000) * 0.0875;
    
    //calculate Total basic premium
    double _basicTotalA = _BasicAnnually + _OccpLoadA + _BasicHLAnnually - _LSDAnnually;
    double _basicTotalS = _BasicHalfYear + _OccpLoadH + _BasicHLHalfYear - _LSDHalfYear;
    double _basicTotalQ = _BasicQuarterly + _OccpLoadQ + _BasicHLQuarterly - _LSDQuarterly;
    double _basicTotalM = _BasicMonthly + _OccpLoadM + _BasicHLMonthly - _LSDMonthly;
    NSString *basicTotalA = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalA]];
    NSString *basicTotalS = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalS]];
    NSString *basicTotalQ = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalQ]];
    NSString *basicTotalM = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalM]];
    
    NSString *displayLSD = nil;
    if (BasicSA < 1000) {
        displayLSD = @"Policy Fee Loading";
        _LSDAnnually = 0 - _LSDAnnually;
        _LSDHalfYear = 0 - _LSDHalfYear;
        _LSDQuarterly = 0 - _LSDQuarterly;
        _LSDMonthly = 0 - _LSDMonthly;
    } else {
        displayLSD = @"Large Size";
    }
    
    NSString *LSDAnnually = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDAnnually]];
    NSString *LSDHalfYear = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDHalfYear]];
    NSString *LSDQuarterly = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDQuarterly]];
    NSString *LSDMonthly = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDMonthly]];
    
    NSString *htmlBasic = [[NSString alloc] initWithFormat:
        @"<html><body><table border='1' width='70%%' align='left' style='border-collapse:collapse; border-color:gray;'> "
        "<tr><td width='32%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Description</font></td>"
            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Annually</font></td>"
            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Semi-Annual</font></td>"
            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Quarterly</font></td>"
            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Monthly</font></td></tr>"
            "<tr><td>Basic</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td></tr>"
            "<tr><td>Occupation Loading</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td></tr>"
            "<tr><td>Health Loading</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td></tr>"
            "<tr><td>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td></tr>"
            "<tr><td>Sub-Total</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td>"
        "</tr>",BasicAnnually, BasicHalfYear, BasicQuarterly, BasicMonthly, OccpLoadA, OccpLoadH, OccpLoadQ, OccpLoadM, BasicHLAnnually, BasicHLHalfYear, BasicHLQuarterly, BasicHLMonthly, displayLSD, LSDAnnually, LSDHalfYear, LSDQuarterly, LSDMonthly, basicTotalA, basicTotalS, basicTotalQ, basicTotalM];
    
    NSString *htmlTail = nil;
    if ([riderCode count] != 0) {
        
        double _annualSUM = annualRiderSum + _basicTotalA;
        double _halfSUM = halfRiderSum + _basicTotalS;
        double _quarterSUM = quarterRiderSum + _basicTotalQ;
        double _monthSUM = monthRiderSum + _basicTotalM;
        NSString *annualSUM = [formatter stringFromNumber:[NSNumber numberWithDouble:_annualSUM]];
        NSString *halfSUM = [formatter stringFromNumber:[NSNumber numberWithDouble:_halfSUM]];
        NSString *quarterSUM = [formatter stringFromNumber:[NSNumber numberWithDouble:_quarterSUM]];
        NSString *monthSUM = [formatter stringFromNumber:[NSNumber numberWithDouble:_monthSUM]];
        
        htmlTail = [[NSString alloc] initWithFormat:
                    @"<tr><td colspan='5'>&nbsp;</td></tr>"
                    "<tr><td>Total</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td></tr>"
                    "</table></body></html>",annualSUM,halfSUM,quarterSUM,monthSUM];
        
        NSString *htmlString = [htmlBasic stringByAppendingString:htmlRider];
        htmlString = [htmlString stringByAppendingString:htmlTail];
        NSURL *baseURL = [NSURL URLWithString:@""];
        [WebView loadHTMLString:htmlString baseURL:baseURL];
    } else {
        
        htmlTail = [[NSString alloc] initWithFormat:
                    @"<tr><td colspan='5'>&nbsp;</td></tr>"
                    "<tr><td>Total</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td></tr>"
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

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
//    [formatter setMaximumFractionDigits:2];
    
    NSUInteger i;
    for (i=0; i<[riderCode count]; i++) {
        //getpentacode
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            if ([[riderCode objectAtIndex:i] isEqualToString:@"C+"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Level"]) {
                    plnOptC = @"L";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Increasing"]) {
                    plnOptC = @"I";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Level_NCB"]) {
                    plnOptC = @"B";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Increasing_NCB"]) {
                    plnOptC = @"N";
                }
                
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",plnOptC];
                
            }
            else if ([[riderCode objectAtIndex:i] isEqualToString:@"HMM"])
            {
                planOptHMM = [riderPlanOpt objectAtIndex:i];
                deducHMM = [riderDeduct objectAtIndex:i];
                pentaSQL = [[NSString alloc] initWithFormat:
                        @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"HMM\" AND PlanOption=\"%@\" AND Deductible=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planOptHMM,deducHMM,[riderAge objectAtIndex:i],[riderAge objectAtIndex:i]];
            }
            else if ([[riderCode objectAtIndex:i] isEqualToString:@"HSP_II"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Standard"]) {
                    planHSPII = @"S";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Deluxe"]) {
                    planHSPII = @"D";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Premier"]) {
                    planHSPII = @"P";
                }
                pentaSQL = [[NSString alloc] initWithFormat:
                        @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",planHSPII];
                
            }
            else if ([[riderCode objectAtIndex:i] isEqualToString:@"MG_II"])
            {
                planMGII = [riderPlanOpt objectAtIndex:i];
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",planMGII];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I40R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID40R"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND PremPayOpt=\"%d\"",[riderCode objectAtIndex:i],self.requestMOP];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"ICR"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"ICR\" AND Smoker=\"%@\"",[riderSmoker objectAtIndex:i]];
                
            } else if ([[riderCode objectAtIndex:i] isEqualToString:@"MG_IV"])
            {
                planMGIV = [riderPlanOpt objectAtIndex:i];
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
        if ([[riderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I40R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"ID40R"]||[[riderCode objectAtIndex:i] isEqualToString:@"IE20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"IE30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"PA"])
        {
            [self getRiderRateAge:planCodeRider riderTerm:ridTerm];
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"CPA"]) {
            [self getRiderRate:planCodeRider riderTerm:ridTerm];
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"HB"]) {
            
            [self getRiderRateSex:planCodeRider riderTerm:ridTerm];
        }
        else {
            [self getRiderRateAgeSex:planCodeRider riderTerm:ridTerm];
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
        NSLog(@"riderRate:%.2f, ridersum:%.3f, HL:%.3f",riderRate,ridSA,riderHLoad);
        
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
            annualRider = (riderRate *ridSA /100 *1) + (RiderHLAnnually /10 *ridSA /100 *1) + (fsar /1000 *OccpLoadA *1);
            halfYearRider = (riderRate *ridSA /100 *0.5125) + (RiderHLHalfYear /10 *ridSA /100 *0.5125) + (fsar /1000 *OccpLoadH *0.5125);
            quarterRider = (riderRate *ridSA /100 *0.2625) + (RiderHLQuarterly /10 *ridSA /100 *0.2625) + (fsar /1000 *OccpLoadQ *0.2625);
            monthlyRider = (riderRate *ridSA /100 *0.0875) + (RiderHLMonthly /10 *ridSA /100 *0.0875) + (fsar /1000 *OccpLoadM *0.0875);
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"I20R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I30R"]||[[riderCode objectAtIndex:i] isEqualToString:@"I40R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm + 1)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm + 1)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm + 1)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm + 1)/2);
            annualRider = (riderRate *ridSA /1000 *1) + (occLoadFactorA *ridSA /1000 *1) + (RiderHLAnnually *ridSA /1000 *1);
            halfYearRider = (riderRate *ridSA /1000 *0.5125) + (occLoadFactorH *ridSA /1000 *0.5125) + (RiderHLHalfYear *ridSA /1000 *0.5125);
            quarterRider = (riderRate *ridSA /1000 *0.2625) + (occLoadFactorQ *ridSA /1000 *0.2625) + (RiderHLQuarterly *ridSA /1000 *0.2625);
            monthlyRider = (riderRate *ridSA /1000 *0.0875) + (occLoadFactorM *ridSA /1000 *0.0875) + (RiderHLMonthly *ridSA /1000 *0.0875);
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"ICR"])
        {
            annualRider = (riderRate *ridSA /1000 *1) + ((OccpLoadA *ridTerm) *ridSA /1000 *1) + (RiderHLAnnually *ridSA /1000 *1);
            halfYearRider = (riderRate *ridSA /1000 *0.5125) + ((OccpLoadH *ridTerm) *ridSA /1000 *0.5125) + (RiderHLHalfYear *ridSA /1000 *0.5125);
            quarterRider = (riderRate *ridSA /1000 *0.2625) + ((OccpLoadQ *ridTerm) *ridSA /1000 *0.2625) + (RiderHLQuarterly *ridSA /1000 *0.2625);
            monthlyRider = (riderRate *ridSA /1000 *0.0875) + ((OccpLoadM *ridTerm) *ridSA /1000 *0.0875) + (RiderHLMonthly *ridSA /1000 *0.0875);
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"ID20R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm - 20)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm - 20)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm - 20)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm - 20)/2);
            annualRider = (riderRate *ridSA /1000 *1) + (occLoadFactorA *ridSA /1000 *1) + (RiderHLAnnually *ridSA /1000 *1);
            halfYearRider = (riderRate *ridSA /1000 *0.5125) + (occLoadFactorH *ridSA /1000 *0.5125) + (RiderHLHalfYear *ridSA /1000 *0.5125);
            quarterRider = (riderRate *ridSA /1000 *0.2625) + (occLoadFactorQ *ridSA /1000 *0.2625) + (RiderHLQuarterly *ridSA /1000 *0.2625);
            monthlyRider = (riderRate *ridSA /1000 *0.0875) + (occLoadFactorM *ridSA /1000 *0.0875) + (RiderHLMonthly *ridSA /1000 *0.0875);
            
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"ID30R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm - 30)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm - 30)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm - 30)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm - 30)/2);
            annualRider = (riderRate *ridSA /1000 *1) + (occLoadFactorA *ridSA /1000 *1) + (RiderHLAnnually *ridSA /1000 *1);
            halfYearRider = (riderRate *ridSA /1000 *0.5125) + (occLoadFactorH *ridSA /1000 *0.5125) + (RiderHLHalfYear *ridSA /1000 *0.5125);
            quarterRider = (riderRate *ridSA /1000 *0.2625) + (occLoadFactorQ *ridSA /1000 *0.2625) + (RiderHLQuarterly *ridSA /1000 *0.2625);
            monthlyRider = (riderRate *ridSA /1000 *0.0875) + (occLoadFactorM *ridSA /1000 *0.0875) + (RiderHLMonthly *ridSA /1000 *0.0875);
            
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"ID40R"])
        {
            double occLoadFactorA = OccpLoadA * ((ridTerm - 40)/2);
            double occLoadFactorH = OccpLoadH * ((ridTerm - 40)/2);
            double occLoadFactorQ = OccpLoadQ * ((ridTerm - 40)/2);
            double occLoadFactorM = OccpLoadM * ((ridTerm - 40)/2);
            annualRider = (riderRate *ridSA /1000 *1) + (occLoadFactorA *ridSA /1000 *1) + (RiderHLAnnually *ridSA /1000 *1);
            halfYearRider = (riderRate *ridSA /1000 *0.5125) + (occLoadFactorH *ridSA /1000 *0.5125) + (RiderHLHalfYear *ridSA /1000 *0.5125);
            quarterRider = (riderRate *ridSA /1000 *0.2625) + (occLoadFactorQ *ridSA /1000 *0.2625) + (RiderHLQuarterly *ridSA /1000 *0.2625);
            monthlyRider = (riderRate *ridSA /1000 *0.0875) + (occLoadFactorM *ridSA /1000 *0.0875) + (RiderHLMonthly *ridSA /1000 *0.0875);
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
            
            annualRider = (riderRate *ridSA /1000 *1) + (OccpLoadA *ridSA /1000 *1) + (RiderHLAnnually *ridSA /1000 *1);
            halfYearRider = (riderRate *ridSA /1000 *0.5125) + (OccpLoadM *ridSA /1000 *0.5125) + (RiderHLHalfYear *ridSA /1000 *0.5125);
            quarterRider = (riderRate *ridSA /1000 *0.2625) + (OccpLoadQ *ridSA /1000 *0.2625) + (RiderHLQuarterly *ridSA /1000 *0.2625);
            monthlyRider = (riderRate *ridSA /1000 *0.0875) + (OccpLoadM *ridSA /1000 *0.0875) + (RiderHLMonthly *ridSA /1000 *0.0875);
        }
        else {
            annualRider = (riderRate *ridSA /1000 *1) + (OccpLoadA *ridSA /1000 *1) + (RiderHLAnnually *ridSA /1000 *1);
            halfYearRider = (riderRate *ridSA /1000 *0.5125) + (OccpLoadM *ridSA /1000 *0.5125) + (RiderHLHalfYear *ridSA /1000 *0.5125);
            quarterRider = (riderRate *ridSA /1000 *0.2625) + (OccpLoadQ *ridSA /1000 *0.2625) + (RiderHLQuarterly *ridSA /1000 *0.2625);
            monthlyRider = (riderRate *ridSA /1000 *0.0875) + (OccpLoadM *ridSA /1000 *0.0875) + (RiderHLMonthly *ridSA /1000 *0.0875);
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
        NSString *annual = [formatter stringFromNumber:[NSNumber numberWithDouble:[[annualRiderTot objectAtIndex:a] doubleValue]]];
        NSString *half = [formatter stringFromNumber:[NSNumber numberWithDouble:[[halfRiderTot objectAtIndex:a] doubleValue]]];
        NSString *quarter = [formatter stringFromNumber:[NSNumber numberWithDouble:[[quarterRiderTot objectAtIndex:a] doubleValue]]];
        NSString *month = [formatter stringFromNumber:[NSNumber numberWithDouble:[[monthRiderTot objectAtIndex:a] doubleValue]]];
        
        if (htmlRider.length == 0) {
            htmlRider = [[NSString alloc]initWithFormat:
                         @"<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>"
                         "<tr><td>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td>"
                         "</tr>",title,annual,half,quarter,month];
        } else {
            
            htmlRider = [htmlRider stringByAppendingFormat:@"<tr><td>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td><td align='right'>%@</td>""</tr>",title,annual,half,quarter,month];
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

-(void)getRiderRateSex:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND Sex=\"%@\"",aaplan,aaterm,aaterm,premH.storedSex];
        NSLog(@"%@",querySQL);
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
                @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\"",aaplan,aaterm,aaterm,premH.storedAge,premH.storedAge];
        
        NSLog(@"%@",querySQL);
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

-(void)getRiderRate:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0",aaplan,aaterm,aaterm];
        
        NSLog(@"%@",querySQL);
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
                @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\" AND Sex=\"%@\"",aaplan,aaterm,aaterm,premH.storedAge,premH.storedAge,premH.storedSex];
        
        NSLog(@"%@",querySQL);
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
