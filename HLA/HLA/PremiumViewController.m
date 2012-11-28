//
//  PremiumViewController.m
//  HLA
//
//  Created by shawal sapuan on 9/11/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PremiumViewController.h"
#import "MainScreen.h"
#import "ReportViewController.h"
#import "BrowserViewController.h"

@interface PremiumViewController ()

@end

@implementation PremiumViewController
@synthesize doGenerate;
@synthesize WebView;
@synthesize requestBasicSA,requestBasicHL,requestMOP,requestTerm,requestPlanCode,requestSINo,requestAge,requestOccpCode;
@synthesize basicRate,LSDRate,riderCode,riderSA,riderHL1K,riderHL100,riderHLP,riderRate,riderTerm;
@synthesize riderDesc,planCodeRider,riderUnit,riderPlanOpt,riderDeduct,pentaSQL;
@synthesize plnOptC,planOptHMM,deducHMM,planHSPII,planMGII,planMGIV;
@synthesize riderAge,riderCustCode,riderSmoker;
@synthesize annualRiderTot,halfRiderTot,quarterRiderTot,monthRiderTot;
@synthesize htmlRider,occLoad,annualRider,halfYearRider,quarterRider,monthlyRider,annualRiderSum,halfRiderSum,monthRiderSum,quarterRiderSum;
@synthesize premBH,premH,age,riderSex,sex,waiverRiderAnn,waiverRiderHalf,waiverRiderQuar,waiverRiderMonth;
@synthesize basicPremAnn,basicPremHalf,basicPremMonth,basicPremQuar;
@synthesize waiverRiderAnn2,waiverRiderHalf2,waiverRiderMonth2,waiverRiderQuar2;
@synthesize Browser = _Browser;

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
    NSLog(@"basicRate:%d,lsdRate:%d,pa_cpa:%d",basicRate,LSDRate,occLoad);
    
    [self deleteSIStorePremium]; //heng's part for SI Report
    [self checkExistRider];
    [self calculateTempPremium];
    if ([riderCode count] != 0) {
        NSLog(@"rider exist!");
        [self calculateRiderPrem];
        [self calculateWaiver];
    } else {
        NSLog(@"rider not exist!");
    }
    
    [self calculatePremium];
    doGenerate.hidden = TRUE;
    
    
    
    
    //----- meng chiong part --------
    if (IsAtLeastiOSVersion(@"6.0")){
        NSString* library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *viewerPlist = [library stringByAppendingPathComponent:@"viewer.plist"];
        BOOL plistExist = [fileManager fileExistsAtPath:viewerPlist];
        if (!plistExist){
            CDVViewController* browserController_page = [CDVViewController new];
            browserController_page.wwwFolderName = @"www";
            browserController_page.startPage = @"dummy.html";//(NSString *)objectHTML;
            browserController_page.view.frame = CGRectMake(0, 0, 0, 0);
            [self.view addSubview:browserController_page.view];
            browserController_page = nil;
        }
    }
    //------ end ---------
     
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
    main.showQuotation = @"YES";
    [self presentModalViewController:main animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.view.superview.bounds = CGRectMake(-42, 20, 1024, 748);
    
    //[self.presentedViewController dismissModalViewControllerAnimated:YES ];
    

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
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp]; // edited by heng
    
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
//    NSLog(@"Basic A:%.3f, S:%.3f, Q:%.3f, M:%.3f",_BasicAnnually,_BasicHalfYear,_BasicQuarterly,_BasicMonthly);
//    NSLog(@"Basic A:%@, S:%@, Q:%@, M:%@",BasicAnnually,BasicHalfYear,BasicQuarterly,BasicQuarterly);
//    NSLog(@"Basic A:%.2f, S:%.2f, Q:%.2f, M:%.2f",BasicAnnually_,BasicHalfYear_,BasicQuarterly_,BasicMonthly_);
    
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
//    NSLog(@"LSD A:%.2f, S:%.2f, Q:%.2f, M:%.2f",LSDAnnually_,LSDHalfYear_,LSDQuarterly_,LSDMonthly_);
    
    //calculate Total basic premium
    NSString *displayLSD = nil;
    double _basicTotalA;
    double _basicTotalS;
    double _basicTotalQ;
    double _basicTotalM;
    if (BasicSA < 1000) {
        displayLSD = @"Policy Fee Loading";
        _basicTotalA = BasicAnnually_ + OccpLoadA_ + BasicHLAnnually_ + LSDAnnually_;
        _basicTotalS = BasicHalfYear_ + OccpLoadH_ + BasicHLHalfYear_ + LSDHalfYear_;
        _basicTotalQ = BasicQuarterly_ + OccpLoadQ_ + BasicHLQuarterly_ + LSDQuarterly_;
        _basicTotalM = BasicMonthly_ + OccpLoadM_ + BasicHLMonthly_ + LSDMonthly_;
        
    } else {
        displayLSD = @"Discount";
        _basicTotalA = BasicAnnually_ + OccpLoadA_ + BasicHLAnnually_ - LSDAnnually_;
        _basicTotalS = BasicHalfYear_ + OccpLoadH_ + BasicHLHalfYear_ - LSDHalfYear_;
        _basicTotalQ = BasicQuarterly_ + OccpLoadQ_ + BasicHLQuarterly_ - LSDQuarterly_;
        _basicTotalM = BasicMonthly_ + OccpLoadM_ + BasicHLMonthly_ - LSDMonthly_;
    }
    
    NSString *LSDAnnually = [formatter stringFromNumber:[NSNumber numberWithDouble:LSDAnnually_]];
    NSString *LSDHalfYear = [formatter stringFromNumber:[NSNumber numberWithDouble:LSDHalfYear_]];
    NSString *LSDQuarterly = [formatter stringFromNumber:[NSNumber numberWithDouble:LSDQuarterly_]];
    NSString *LSDMonthly = [formatter stringFromNumber:[NSNumber numberWithDouble:LSDMonthly_]];
    
    NSString *basicTotalA = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalA]];
    NSString *basicTotalS = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalS]];
    NSString *basicTotalQ = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalQ]];
    NSString *basicTotalM = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalM]];
    
    //------------heng's part for SI report
    
    NSString *QuerySQL =  [ NSString stringWithFormat: @"INSERT INTO SI_Store_Premium (\"Type\",\"Annually\",\"SemiAnnually\", "
                           " \"Quarterly\",\"Monthly\") VALUES "
                           " (\"B\", \"%@\", \"%@\", \"%@\", \"%@\") ", basicTotalA, basicTotalS, basicTotalQ, basicTotalM];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    //--------------
    
    
    NSString *htmlBasic = [[NSString alloc] initWithFormat:
        @"<html><body><table border='1' width='70%%' align='left' style='border-collapse:collapse; border-color:gray;'> "
        "<tr><td width='32%%' align='center' style='height:45px; background-color:#4F81BD;'>&nbsp;</td>"
            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Annually</font></td>"
            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Half-Yearly</font></td>"
            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Quarterly</font></td>"
            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Monthly</font></td></tr>"
            "<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>Basic Plan</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td></tr>"
            "<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>Occupation Loading</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td></tr>"
            "<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>Health Loading</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td></tr>"
            "<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td></tr>"
            "<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>Sub-Total</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                           "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
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
                    "<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>Total</font></td>"
                        "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                        "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                        "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                        "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td></tr>"
                    "</table></body></html>",annualSUM,halfSUM,quarterSUM,monthSUM];
        
        NSString *htmlString = [htmlBasic stringByAppendingString:htmlRider];
        htmlString = [htmlString stringByAppendingString:htmlTail];
        NSURL *baseURL = [NSURL URLWithString:@""];
        [WebView loadHTMLString:htmlString baseURL:baseURL];
    } else {
        
        htmlTail = [[NSString alloc] initWithFormat:
                    @"<tr><td colspan='5'>&nbsp;</td></tr>"
                    "<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>Total</font></td>"
                        "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                        "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                        "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                        "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td></tr>"
                    "</table></body></html>",basicTotalA, basicTotalS, basicTotalQ, basicTotalM];
        
        NSString *htmlString = [htmlBasic stringByAppendingString:htmlTail];
        NSURL *baseURL = [NSURL URLWithString:@""];
        [WebView loadHTMLString:htmlString baseURL:baseURL];
    }
}

-(void)calculateTempPremium
{
    double BasicSA = [[self.requestBasicSA description] doubleValue];
    double PolicyTerm = self.requestTerm;
    double BasicHLoad = [[self.requestBasicHL description] doubleValue];
    
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
    NSMutableArray *annRiderTitle = [[NSMutableArray alloc] init];
    NSMutableArray *annRiderCode = [[NSMutableArray alloc] init];
    NSMutableArray *annRiderTerm = [[NSMutableArray alloc] init];
    annualRiderTot = [[NSMutableArray alloc] init];
    halfRiderTot = [[NSMutableArray alloc] init];
    quarterRiderTot = [[NSMutableArray alloc] init];
    monthRiderTot = [[NSMutableArray alloc] init];
    
    waiverRiderAnn = [[NSMutableArray alloc] init];
    waiverRiderHalf = [[NSMutableArray alloc] init];
    waiverRiderQuar = [[NSMutableArray alloc] init];
    waiverRiderMonth = [[NSMutableArray alloc] init];
    waiverRiderAnn2 = [[NSMutableArray alloc] init];
    waiverRiderHalf2 = [[NSMutableArray alloc] init];
    waiverRiderQuar2 = [[NSMutableArray alloc] init];
    waiverRiderMonth2 = [[NSMutableArray alloc] init];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    NSUInteger i;
    for (i=0; i<[riderCode count]; i++) {
        
        NSString *RidCode = [[NSString alloc] initWithFormat:@"%@",[riderCode objectAtIndex:i]];
        
        //getpentacode
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            if ([RidCode isEqualToString:@"C+"])
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
            else if ([RidCode isEqualToString:@"HMM"])
            {
                planOptHMM = [riderPlanOpt objectAtIndex:i];
                deducHMM = [riderDeduct objectAtIndex:i];
                pentaSQL = [[NSString alloc] initWithFormat:
                            @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"HMM\" AND PlanOption=\"%@\" AND Deductible=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planOptHMM,deducHMM,[riderAge objectAtIndex:i],[riderAge objectAtIndex:i]];
            }
            else if ([RidCode isEqualToString:@"HSP_II"])
            {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Standard"]) {
                    planHSPII = @"S";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Deluxe"]) {
                    planHSPII = @"D";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Premier"]) {
                    planHSPII = @"P";
                }
                pentaSQL = [[NSString alloc] initWithFormat:
                            @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"HSP_II\" AND PlanOption=\"%@\"",planHSPII];
            }
            else if ([RidCode isEqualToString:@"MG_II"])
            {
                planMGII = [riderPlanOpt objectAtIndex:i];
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"MG_II\" AND PlanOption=\"%@\"",planMGII];
            }
            else if ([RidCode isEqualToString:@"I20R"]||[RidCode isEqualToString:@"I30R"]||[RidCode isEqualToString:@"I40R"]||[RidCode isEqualToString:@"ID20R"]||[RidCode isEqualToString:@"ID30R"]||[RidCode isEqualToString:@"ID40R"]||[RidCode isEqualToString:@"IE20R"]||[RidCode isEqualToString:@"IE30R"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND PremPayOpt=\"%d\"",[riderCode objectAtIndex:i],self.requestMOP];
                
            }
            else if ([RidCode isEqualToString:@"ICR"])
            {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"ICR\" AND Smoker=\"%@\"",[riderSmoker objectAtIndex:i]];
                
            }
            else if ([RidCode isEqualToString:@"MG_IV"])
            {
                planMGIV = [riderPlanOpt objectAtIndex:i];
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"MG_IV\" AND PlanOption=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planMGIV,[riderAge objectAtIndex:i],[riderAge objectAtIndex:i]];
            }
            else if ([RidCode isEqualToString:@"CIWP"]||[RidCode isEqualToString:@"LCWP"]||[RidCode isEqualToString:@"PR"]||[RidCode isEqualToString:@"SP_STD"]||[RidCode isEqualToString:@"SP_PRE"]) {
                continue;
            }
            else {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND Channel=\"AGT\"",RidCode];
            }
            
//            NSLog(@"%@",pentaSQL);
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
        age = [[riderAge objectAtIndex:i] intValue];
        sex = [[NSString alloc] initWithFormat:@"%@",[riderSex objectAtIndex:i]];
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
        NSLog(@"riderRate(%@):%.2f, ridersum:%.3f, HL:%.3f",RidCode,riderRate,ridSA,riderHLoad);
        
        double annFac;
        double halfFac;
        double quarterFac;
        double monthFac;
        /*
        if ([RidCode isEqualToString:@"PA"]) {
            annFac = 1;
            halfFac = 0.5;
            quarterFac = 0.25;
            monthFac = ((double)1)/12;
        }
        else */if ([RidCode isEqualToString:@"HB"]) {
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
        NSLog(@"factorann (%@):%.4f, half:%.4f, quar:%.4f, month:%.4f",RidCode,annFac,halfFac,quarterFac,monthFac);
        
        //calculate occupationLoading
        double OccpLoadA = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * annFac;
        double OccpLoadH = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * halfFac;
        double OccpLoadQ = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * quarterFac;
        double OccpLoadM = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * monthFac;
        NSLog(@"OccpLoad A:%.3f, S:%.3f, Q:%.3f, M:%.3f",OccpLoadA,OccpLoadH,OccpLoadQ,OccpLoadM);
        
        //calculate rider health loading
        double RiderHLAnnually = riderHLoad * (BasicSA/1000) * annFac;
        double RiderHLHalfYear = riderHLoad * (BasicSA/1000) * halfFac;
        double RiderHLQuarterly = riderHLoad * (BasicSA/1000) * quarterFac;
        double RiderHLMonthly = riderHLoad * (BasicSA/1000) * monthFac;
        NSLog(@"RiderHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",RiderHLAnnually,RiderHLHalfYear,RiderHLQuarterly,RiderHLMonthly);
        
        if ([RidCode isEqualToString:@"ETPD"])
        {
            double fsar = (65 - self.requestAge) * ridSA;
            annualRider = (riderRate *ridSA /100 *annFac) + (RiderHLAnnually /10 *ridSA /100 *annFac) + (fsar /1000 *OccpLoadA *annFac);
            halfYearRider = (riderRate *ridSA /100 *halfFac) + (RiderHLHalfYear /10 *ridSA /100 *halfFac) + (fsar /1000 *OccpLoadH *halfFac);
            quarterRider = (riderRate *ridSA /100 *quarterFac) + (RiderHLQuarterly /10 *ridSA /100 *quarterFac) + (fsar /1000 *OccpLoadQ *quarterFac);
            monthlyRider = (riderRate *ridSA /100 *monthFac) + (RiderHLMonthly /10 *ridSA /100 *monthFac) + (fsar /1000 *OccpLoadM *monthFac);
        }
        else if ([RidCode isEqualToString:@"I20R"]||[RidCode isEqualToString:@"I30R"]||[RidCode isEqualToString:@"I40R"]||[RidCode isEqualToString:@"IE20R"]||[RidCode isEqualToString:@"IE30R"])
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
        else if ([RidCode isEqualToString:@"ICR"])
        {
            annualRider = (riderRate *ridSA /1000 *annFac) + ((OccpLoadA *ridTerm) *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + ((OccpLoadH *ridTerm) *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + ((OccpLoadQ *ridTerm) *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + ((OccpLoadM *ridTerm) *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        else if ([RidCode isEqualToString:@"ID20R"])
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
        else if ([RidCode isEqualToString:@"ID30R"])
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
        else if ([RidCode isEqualToString:@"ID40R"])
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
        else if ([RidCode isEqualToString:@"MG_II"]||[RidCode isEqualToString:@"MG_IV"]||[RidCode isEqualToString:@"HSP_II"]||[RidCode isEqualToString:@"HMM"])
        {
            annualRider = riderRate * (1 + RiderHLAnnually/100) * annFac;
            halfYearRider = riderRate * (1 + RiderHLHalfYear/100) * halfFac;
            quarterRider = riderRate * (1 + RiderHLQuarterly/100) * quarterFac;
            monthlyRider = riderRate * (1 + RiderHLMonthly/100) * monthFac;
        }
        else if ([RidCode isEqualToString:@"HB"])
        {
            int selectUnit = [[riderUnit objectAtIndex:i] intValue];
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
            
            annualRider = (riderRate *ridSA /1000 *annFac) + (OccpLoadA *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + (OccpLoadM *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + (OccpLoadQ *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + (OccpLoadM *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        else {
            annualRider = (riderRate *ridSA /1000 *annFac) + (OccpLoadA *ridSA /1000 *annFac) + (RiderHLAnnually *ridSA /1000 *annFac);
            halfYearRider = (riderRate *ridSA /1000 *halfFac) + (OccpLoadM *ridSA /1000 *halfFac) + (RiderHLHalfYear *ridSA /1000 *halfFac);
            quarterRider = (riderRate *ridSA /1000 *quarterFac) + (OccpLoadQ *ridSA /1000 *quarterFac) + (RiderHLQuarterly *ridSA /1000 *quarterFac);
            monthlyRider = (riderRate *ridSA /1000 *monthFac) + (OccpLoadM *ridSA /1000 *monthFac) + (RiderHLMonthly *ridSA /1000 *monthFac);
        }
        
        NSString *calRiderAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:annualRider]];
        NSString *calRiderHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:halfYearRider]];
        NSString *calRiderQuarter = [formatter stringFromNumber:[NSNumber numberWithDouble:quarterRider]];
        NSString *calRiderMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:monthlyRider]];
        calRiderAnn = [calRiderAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
        calRiderHalf = [calRiderHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
        calRiderQuarter = [calRiderQuarter stringByReplacingOccurrencesOfString:@"," withString:@""];
        calRiderMonth = [calRiderMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
        [annualRiderTot addObject:calRiderAnn];
        [halfRiderTot addObject:calRiderHalf];
        [quarterRiderTot addObject:calRiderQuarter];
        [monthRiderTot addObject:calRiderMonth];
//        [annRiderTitle addObject:[riderDesc objectAtIndex:i]];
        [annRiderTitle addObject:RidCode];
        [annRiderTerm addObject:[riderTerm objectAtIndex:i]];
        [annRiderCode addObject:RidCode];
        NSLog(@"RiderTotal(%@) A:%@, S:%@, Q:%@, M:%@",[riderCode objectAtIndex:i],calRiderAnn,calRiderHalf,calRiderQuarter,calRiderMonth);
        
        //for waiver CIWP
        if (!([RidCode isEqualToString:@"LCPR"]) && !([RidCode isEqualToString:@"CIR"]) && !([RidCode isEqualToString:@"PR"]) && !([RidCode isEqualToString:@"LCWP"]) && !([RidCode isEqualToString:@"SP_STD"]) && !([RidCode isEqualToString:@"SP_PRE"]) && !([RidCode isEqualToString:@"CIWP"]) && !([RidCode isEqualToString:@"ICR"])) {
            NSLog(@"waiver1 insert :%@",[riderCode objectAtIndex:i]);
            
            NSString *calWaiverAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:annualRider]];
            NSString *calWaiverHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:halfYearRider]];
            NSString *calWaiverQuarter = [formatter stringFromNumber:[NSNumber numberWithDouble:quarterRider]];
            NSString *calWaiverMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:monthlyRider]];
            calWaiverAnn = [calWaiverAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
            calWaiverHalf = [calWaiverHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
            calWaiverQuarter = [calWaiverQuarter stringByReplacingOccurrencesOfString:@"," withString:@""];
            calWaiverMonth = [calWaiverMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
            [waiverRiderAnn addObject:calWaiverAnn];
            [waiverRiderHalf addObject:calWaiverHalf];
            [waiverRiderQuar addObject:calWaiverQuarter];
            [waiverRiderMonth addObject:calWaiverMonth];
        }
        
        //for other waiver
        if (!([RidCode isEqualToString:@"PLCP"]) && !([RidCode isEqualToString:@"CIWP"]) && !([RidCode isEqualToString:@"LCWP"]) && !([RidCode isEqualToString:@"SP_STD"]) && !([RidCode isEqualToString:@"SP_PRE"]) && !([RidCode isEqualToString:@"PR"]) && !([RidCode isEqualToString:@"PTR"])) {
            NSLog(@"waiver2 insert :%@",[riderCode objectAtIndex:i]);
            
            NSString *calWaiverAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:annualRider]];
            NSString *calWaiverHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:halfYearRider]];
            NSString *calWaiverQuarter = [formatter stringFromNumber:[NSNumber numberWithDouble:quarterRider]];
            NSString *calWaiverMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:monthlyRider]];
            calWaiverAnn = [calWaiverAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
            calWaiverHalf = [calWaiverHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
            calWaiverQuarter = [calWaiverQuarter stringByReplacingOccurrencesOfString:@"," withString:@""];
            calWaiverMonth = [calWaiverMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
            [waiverRiderAnn2 addObject:calWaiverAnn];
            [waiverRiderHalf2 addObject:calWaiverHalf];
            [waiverRiderQuar2 addObject:calWaiverQuarter];
            [waiverRiderMonth2 addObject:calWaiverMonth];
        }
        
    }
    
    annualRiderSum = 0;
    halfRiderSum = 0;
    quarterRiderSum = 0;
    monthRiderSum = 0;
    NSUInteger a;
    for (a=0; a<[annualRiderTot count]; a++) {
        int ridTerm = [[annRiderTerm objectAtIndex:a] intValue];
        NSString *title = [[NSString alloc ]initWithFormat:@"%@ - (%d years)",[annRiderTitle objectAtIndex:a],ridTerm];
        NSString *annual = [formatter stringFromNumber:[NSNumber numberWithDouble:[[annualRiderTot objectAtIndex:a] doubleValue]]];
        NSString *half = [formatter stringFromNumber:[NSNumber numberWithDouble:[[halfRiderTot objectAtIndex:a] doubleValue]]];
        NSString *quarter = [formatter stringFromNumber:[NSNumber numberWithDouble:[[quarterRiderTot objectAtIndex:a] doubleValue]]];
        NSString *month = [formatter stringFromNumber:[NSNumber numberWithDouble:[[monthRiderTot objectAtIndex:a] doubleValue]]];
        
        //-------------- heng's part for SI Report
        NSString *QuerySQL =  [ NSString stringWithFormat: @"INSERT INTO SI_Store_Premium (\"Type\",\"Annually\",\"SemiAnnually\", "
                               " \"Quarterly\",\"Monthly\") VALUES "
                               " (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\") ",[annRiderCode objectAtIndex:a], annual, half, quarter, month ];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
        //---------------
        if (htmlRider.length == 0) {
            htmlRider = [[NSString alloc]initWithFormat:
                         @"<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>"
                         "<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "</tr>",title,annual,half,quarter,month];
        } else {
            
            htmlRider = [htmlRider stringByAppendingFormat:
                         @"<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "</tr>",title,annual,half,quarter,month];
        }
        annualRiderSum = annualRiderSum + [[annualRiderTot objectAtIndex:a] doubleValue];
        halfRiderSum = halfRiderSum + [[halfRiderTot objectAtIndex:a] doubleValue];
        quarterRiderSum = quarterRiderSum + [[quarterRiderTot objectAtIndex:a] doubleValue];
        monthRiderSum = monthRiderSum + [[monthRiderTot objectAtIndex:a] doubleValue];
    }
}

-(void)calculateWaiver
{
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
    NSLog(@"AccRiderPrem1 A:%.2f, S:%.2f, Q:%.2f, M:%.2f",waiverAnnSum,waiverHalfSum,waiverQuarSum,waiverMonthSum);
    
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
    NSLog(@"AccRiderPrem2 A:%.2f, S:%.2f, Q:%.2f, M:%.2f",waiverAnnSum2,waiverHalfSum2,waiverQuarSum2,waiverMonthSum2);
    
    NSMutableArray *waiverTitle = [[NSMutableArray alloc] init];
    NSMutableArray *waiverCode = [[NSMutableArray alloc] init];
    NSMutableArray *waiverTerm = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidAnnTol = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidHalfTol = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidQuarTol = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidMonthTol = [[NSMutableArray alloc] init];
    
    NSUInteger i;
    for (i=0; i<[riderCode count]; i++) {
        //getpentacode
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            if ([[riderCode objectAtIndex:i] isEqualToString:@"CIWP"]||[[riderCode objectAtIndex:i] isEqualToString:@"LCWP"]||[[riderCode objectAtIndex:i] isEqualToString:@"PR"]||[[riderCode objectAtIndex:i] isEqualToString:@"SP_STD"]||[[riderCode objectAtIndex:i] isEqualToString:@"SP_PRE"]) {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND Channel=\"AGT\"",[riderCode objectAtIndex:i]];
            }
            else {
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
        
        int ridTerm = [[riderTerm objectAtIndex:i] intValue];
        age = [[riderAge objectAtIndex:i] intValue];
        sex = [[NSString alloc] initWithFormat:@"%@",[riderSex objectAtIndex:i]];
        
        //get rate
        [self getRiderRateAgeSex:planCodeRider riderTerm:ridTerm];
        
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
        NSLog(@"riderRate(%@):%.2f, ridersum:%.3f, HL:%.3f",[riderCode objectAtIndex:i],riderRate,ridSA,riderHLoad);
        
        double annFac = 1;
        double halfFac = 0.5125;
        double quarterFac = 0.2625;
        double monthFac = 0.0875;
        
        //calculate occupationLoading
        double OccpLoadA = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * annFac;
        double OccpLoadH = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * halfFac;
        double OccpLoadQ = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * quarterFac;
        double OccpLoadM = occLoad * ((PolicyTerm + 1)/2) * (BasicSA/1000) * monthFac;
        NSLog(@"RiderOccpL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",OccpLoadA,OccpLoadH,OccpLoadQ,OccpLoadM);
        
        //calculate rider health loading
        double RiderHLAnnually = BasicHLoad * (BasicSA/1000) * annFac;
        double RiderHLHalfYear = BasicHLoad * (BasicSA/1000) * halfFac;
        double RiderHLQuarterly = BasicHLoad * (BasicSA/1000) * quarterFac;
        double RiderHLMonthly = BasicHLoad * (BasicSA/1000) * monthFac;
        NSLog(@"RiderHL A:%.3f, S:%.3f, Q:%.3f, M:%.3f",RiderHLAnnually,RiderHLHalfYear,RiderHLQuarterly,RiderHLMonthly);
    
        if ([[riderCode objectAtIndex:i] isEqualToString:@"CIWP"])
        {
            double waiverAnnPrem = ridSA/100 * (waiverAnnSum+basicPremAnn);
            double waiverHalfPrem = ridSA/100 * (waiverHalfSum+basicPremHalf) *2;
            double waiverQuarPrem = ridSA/100 * (waiverQuarSum+basicPremQuar) *4;
            double waiverMonthPrem = ridSA/100 * (waiverMonthSum+basicPremMonth) *12;
            NSLog(@"waiverSA A:%.2f, S:%.2f, Q:%.2f, M:%.2f",waiverAnnPrem,waiverHalfPrem,waiverQuarPrem,waiverMonthPrem);
            
            double annualRider_ = waiverAnnPrem * (riderRate/100 + ((double)ridTerm)/1000 * OccpLoadA + RiderHLAnnually/100);
            double halfYearRider_ = waiverHalfPrem * (riderRate/100 + ((double)ridTerm)/1000 * OccpLoadH + RiderHLHalfYear/100);
            double quarterRider_ = waiverQuarPrem * (riderRate/100 + ((double)ridTerm)/1000 * OccpLoadQ + RiderHLQuarterly/100);
            double monthlyRider_ = waiverMonthPrem * (riderRate/100 + ((double)ridTerm)/1000 * OccpLoadM + RiderHLMonthly/100);
            NSLog(@"waiverPrem A:%.2f S:%.2f, Q:%.2f, M:%.2f",annualRider_,halfYearRider_,quarterRider_,monthlyRider_);
            
            annualRider = annualRider_ * annFac;
            halfYearRider = halfYearRider_ * halfFac;
            quarterRider = quarterRider_ * quarterFac;
            monthlyRider = monthlyRider_ * monthFac;
        }
        else if ([[riderCode objectAtIndex:i] isEqualToString:@"LCWP"]||[[riderCode objectAtIndex:i] isEqualToString:@"PR"]||[[riderCode objectAtIndex:i] isEqualToString:@"SP_STD"]||[[riderCode objectAtIndex:i] isEqualToString:@"SP_PRE"])
        {
            double waiverAnnPrem = ridSA/100 * (waiverAnnSum2+basicPremAnn);
            double waiverHalfPrem = ridSA/100 * (waiverHalfSum2+basicPremHalf) *2;
            double waiverQuarPrem = ridSA/100 * (waiverQuarSum2+basicPremQuar) *4;
            double waiverMonthPrem = ridSA/100 * (waiverMonthSum2+basicPremMonth) *12;
            NSLog(@"waiverSA A:%.2f, S:%.2f, Q:%.2f, M:%.2f",waiverAnnPrem,waiverHalfPrem,waiverQuarPrem,waiverMonthPrem);
            
            double annualRider_ = waiverAnnPrem * (riderRate/100 + ((double)ridTerm)/1000 * OccpLoadA + RiderHLAnnually/100);
            double halfYearRider_ = waiverHalfPrem * (riderRate/100 + ((double)ridTerm)/1000 * OccpLoadH + RiderHLHalfYear/100);
            double quarterRider_ = waiverQuarPrem * (riderRate/100 + ((double)ridTerm)/1000 * OccpLoadQ + RiderHLQuarterly/100);
            double monthlyRider_ = waiverMonthPrem * (riderRate/100 + ((double)ridTerm)/1000 * OccpLoadM + RiderHLMonthly/100);
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
        
//        [waiverTitle addObject:[riderDesc objectAtIndex:i]];
        [waiverTitle addObject:[riderCode objectAtIndex:i]];
        [waiverTerm addObject:[riderTerm objectAtIndex:i]];
        [waiverCode addObject:[riderCode objectAtIndex:i]];
        [waiverRidAnnTol addObject:calRiderAnn];
        [waiverRidHalfTol addObject:calRiderHalf];
        [waiverRidQuarTol addObject:calRiderQuarter];
        [waiverRidMonthTol addObject:calRiderMonth];
        NSLog(@"waiverTotal(%@) A:%@, S:%@, Q:%@, M:%@",[riderCode objectAtIndex:i],calRiderAnn,calRiderHalf,calRiderQuarter,calRiderMonth);
    }

    NSUInteger a;
    for (a=0; a<[waiverRidAnnTol count]; a++) {
        int ridTerm = [[waiverTerm objectAtIndex:a] intValue];
        NSString *title = [[NSString alloc ]initWithFormat:@"%@ - (%d years)",[waiverTitle objectAtIndex:a],ridTerm];
        NSString *annual = [formatter stringFromNumber:[NSNumber numberWithDouble:[[waiverRidAnnTol objectAtIndex:a] doubleValue]]];
        NSString *half = [formatter stringFromNumber:[NSNumber numberWithDouble:[[waiverRidHalfTol objectAtIndex:a] doubleValue]]];
        NSString *quarter = [formatter stringFromNumber:[NSNumber numberWithDouble:[[waiverRidQuarTol objectAtIndex:a] doubleValue]]];
        NSString *month = [formatter stringFromNumber:[NSNumber numberWithDouble:[[waiverRidMonthTol objectAtIndex:a] doubleValue]]];
        
        //-------------- heng's part for SI Report
        
        NSString *QuerySQL =  [ NSString stringWithFormat: @"INSERT INTO SI_Store_Premium (\"Type\",\"Annually\",\"SemiAnnually\", "
                               " \"Quarterly\",\"Monthly\") VALUES "
                               " (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\") ",[waiverCode objectAtIndex:a], annual, half, quarter, month ];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
         
        //---------------
        
        if (htmlRider.length == 0) {
            htmlRider = [[NSString alloc]initWithFormat:
                         @"<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>"
                         "<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "</tr>",title,annual,half,quarter,month];
        } else {
            
            htmlRider = [htmlRider stringByAppendingFormat:
                         @"<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "</tr>",title,annual,half,quarter,month];
        }
        
        annualRiderSum = annualRiderSum + [[waiverRidAnnTol objectAtIndex:a] doubleValue];
        halfRiderSum = halfRiderSum + [[waiverRidHalfTol objectAtIndex:a] doubleValue];
        quarterRiderSum = quarterRiderSum + [[waiverRidQuarTol objectAtIndex:a] doubleValue];
        monthRiderSum = monthRiderSum + [[waiverRidMonthTol objectAtIndex:a] doubleValue];
        
        NSLog(@"allRiderSum A:%.2f S:%.2f, Q:%.2f, M:%.2f",annualRiderSum,halfRiderSum,quarterRiderSum,monthRiderSum);
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
    riderSex = [[NSMutableArray alloc] init];
    riderAge = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
            @"SELECT a.RiderCode, b.RiderDesc, a.RiderTerm, a.SumAssured, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, a.HL100SA, a.HLPercentage, c.CustCode,d.Smoker,d.Sex,d.ALB from Trad_Rider_Details a, Trad_Sys_Rider_Profile b, Trad_LAPayor c, Clt_Profile d WHERE a.RiderCode=b.RiderCode AND a.PTypeCode=c.PTypeCode AND a.Seq=c.Sequence AND d.CustCode=c.CustCode AND a.SINo=c.SINo AND a.SINo=\"%@\"", [self.requestSINo description]];
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
                [riderSex addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)]];
                [riderAge addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)]];
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

-(void)getRiderRateAge:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        //----------------- edited by heng on 25th oct 2012 because IE20R and IE30R dont have term
        NSString *querySQL;
        if (aaterm == 0) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\"",aaplan,age,age];
            
        }
        else {
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\"",aaplan,aaterm,aaterm,age,age];
            
        }
        //-------------------
        
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
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND "
                              " FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\" AND Sex=\"%@\" AND occpClass = \"%d\"",
                              aaplan,aaterm,aaterm,age,age,sex, premH.storedOccpClass];
        
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

-(void)getRiderRateAgeClass:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND "
                              " FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\" AND occpClass = \"%d\"",
                              aaplan,aaterm,aaterm,age,age, premH.storedOccpClass];
        
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

-(void)getRiderRateClass:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND "
                              " FromMortality=0 AND occpClass = \"%d\"",
                              aaplan,aaterm,aaterm, premH.storedOccpClass];
        
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

//-----

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
    [self setDoGenerate:nil];
    [super viewDidUnload];
}

- (IBAction)btnGenerate:(id)sender {
    ReportViewController *ReportPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Report"];
    ReportPage.SINo = requestSINo;
    [self presentViewController:ReportPage animated:NO completion:^{
        [ReportPage dismissViewControllerAnimated:NO completion:^{
            /*
            MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
            main.modalPresentationStyle = UIModalPresentationFullScreen;
            main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            main.IndexTab = 6;
            [self presentModalViewController:main animated:YES];
             */
         ReportViewController *reportVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoHtml"];
         [self presentViewController:reportVC animated:YES completion:Nil];
        }];
    }];
}

- (IBAction)btnQuotation:(id)sender {
    if (_Browser == Nil) {
        self.Browser = [self.storyboard instantiateViewControllerWithIdentifier:@"Browser"];
        _Browser.delegate = self;
    }
    
    sqlite3_stmt *statement;
    BOOL cont = FALSE;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {  
        // NSString *querySQL = [NSString stringWithFormat:@"SELECT * from SI_Store_Premium "];
        
        NSString *QuerySQL = [ NSString stringWithFormat:@"select \"PolicyTerm\", \"BasicSA\", \"premiumPaymentOption\", \"CashDividend\",  "
                              "\"YearlyIncome\", \"AdvanceYearlyIncome\", \"HL1KSA\",  \"sex\" from Trad_Details as A, "
                              "Clt_Profile as B, trad_LaPayor as C where A.Sino = C.Sino AND C.custCode = B.custcode AND "
                              "A.sino = \"%@\" AND \"seq\" = 1 ", requestSINo];
        
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
            ReportPage.SINo = requestSINo;
            [self presentViewController:ReportPage animated:NO completion:Nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                spinnerLabel.text = @"";
                
                [ReportPage dismissViewControllerAnimated:NO completion:Nil];
    
                    
                    BrowserViewController *controller = [[BrowserViewController alloc] init];
                    controller.title = @"Quotation";
                    controller.delegate = self;
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

-(void)deleteSIStorePremium{
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
       NSString *DeleteSQL =  [ NSString stringWithFormat: @"DELETE from SI_Store_Premium"];
        if (sqlite3_prepare_v2(contactDB, [DeleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
            }
            
            sqlite3_finalize(statement);
        }
            
        sqlite3_close(contactDB);
    }    
    
}

-(void)CloseWindow{
    NSLog(@"received");
    [self.presentingViewController dismissModalViewControllerAnimated:YES ];
}
@end
