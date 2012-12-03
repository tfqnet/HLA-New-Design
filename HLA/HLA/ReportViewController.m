//
//  ReportViewController.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/18/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ReportViewController.h"
#import "DBController.h"
#import "DataTable.h"
#import "BrowserViewController.h"

@interface ReportViewController ()

@end

//double CIWPAnnual, CIWPSemiAnnual, CIWPQuarterly, CIWPMonthly;
NSMutableArray *UpdateTradDetail, *gWaiverAnnual, *gWaiverSemiAnnual, *gWaiverQuarterly, *gWaiverMonthly;

@implementation ReportViewController
@synthesize SINo, PolicyTerm, BasicSA, PremiumPaymentOption, AdvanceYearlyIncome,OtherRiderCode,OtherRiderDesc,OtherRiderTerm,sex;
@synthesize YearlyIncome, CashDividend,CustCode, Age, IncomeRiderCode,IncomeRiderDesc,IncomeRiderTerm;
@synthesize HealthLoading, OtherRiderSA, IncomeRiderSA, IncomeRiderPlanOption, OtherRiderPlanOption,Name;
@synthesize strBasicAnnually, aStrIncomeRiderAnnually, aStrOtherRiderAnnually, SummaryGuaranteedAddValue;
@synthesize SummaryGuaranteedDBValueA, SummaryGuaranteedDBValueB,SummaryGuaranteedSurrenderValue;
@synthesize SummaryGuaranteedTotalGYI, SummaryNonGuaranteedAccuCashDividendA,SummaryNonGuaranteedAccuCashDividendB;
@synthesize SummaryGuaranteedAddEndValue, SummaryNonGuaranteedAccuYearlyIncomeA, SummaryNonGuaranteedAccuYearlyIncomeB;
@synthesize SummaryNonGuaranteedDBValueA, SummaryNonGuaranteedDBValueB, SummaryNonGuaranteedSurrenderValueA,SummaryNonGuaranteedSurrenderValueB;
@synthesize BasicMaturityValueA, BasicMaturityValueB, BasicTotalPremiumPaid, BasicTotalYearlyIncome;
@synthesize EntireMaturityValueA,EntireMaturityValueB,EntireTotalPremiumPaid,EntireTotalYearlyIncome;
@synthesize aStrIncomeRiderMonthly,aStrIncomeRiderQuarterly,aStrIncomeRiderSemiAnnually,aStrOtherRiderMonthly;
@synthesize aStrOtherRiderQuarterly,aStrOtherRiderSemiAnnually,strBasicMonthly,strBasicQuarterly,strBasicSemiAnnually;
@synthesize dataTable = _dataTable;
@synthesize db = _db;

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
    
    
 
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    UpdateTradDetail = [[NSMutableArray alloc] init ];
    gWaiverAnnual = [[NSMutableArray alloc] init ];
    gWaiverSemiAnnual = [[NSMutableArray alloc] init ];
    gWaiverQuarterly = [[NSMutableArray alloc] init ];
    gWaiverMonthly = [[NSMutableArray alloc] init ];
    
    aStrIncomeRiderAnnually = [[NSMutableArray alloc] init ];
    aStrOtherRiderAnnually = [[NSMutableArray alloc] init ];
    aStrIncomeRiderSemiAnnually = [[NSMutableArray alloc] init ];
    aStrOtherRiderSemiAnnually = [[NSMutableArray alloc] init ];
    aStrIncomeRiderQuarterly = [[NSMutableArray alloc] init ];
    aStrOtherRiderQuarterly = [[NSMutableArray alloc] init ];
    aStrIncomeRiderMonthly = [[NSMutableArray alloc] init ];
    aStrOtherRiderMonthly = [[NSMutableArray alloc] init ];
    
    SummaryGuaranteedTotalGYI = [[NSMutableArray alloc] init ];
    SummaryGuaranteedAddEndValue = [[NSMutableArray alloc] init ];
    SummaryGuaranteedAddValue = [[NSMutableArray alloc] init ];
    SummaryGuaranteedDBValueA = [[NSMutableArray alloc] init ];
    SummaryGuaranteedDBValueB = [[NSMutableArray alloc] init ];
    SummaryGuaranteedSurrenderValue = [[NSMutableArray alloc] init ];

    SummaryNonGuaranteedAccuCashDividendA = [[NSMutableArray alloc] init ];
    SummaryNonGuaranteedAccuCashDividendB = [[NSMutableArray alloc] init ];
    SummaryNonGuaranteedAccuYearlyIncomeA = [[NSMutableArray alloc] init ];
    SummaryNonGuaranteedAccuYearlyIncomeB = [[NSMutableArray alloc] init ];
    SummaryNonGuaranteedDBValueA = [[NSMutableArray alloc] init ];
    SummaryNonGuaranteedDBValueB = [[NSMutableArray alloc] init ];
    SummaryNonGuaranteedSurrenderValueA = [[NSMutableArray alloc] init ];
    SummaryNonGuaranteedSurrenderValueB = [[NSMutableArray alloc] init ];
    
    BasicTotalYearlyIncome = 0.00;
    BasicMaturityValueA = 0.00;
    BasicMaturityValueB = 0.00;
    BasicTotalPremiumPaid = 0.00;
    
    EntireTotalYearlyIncome = 0.00;
    EntireMaturityValueA = 0.00;
    EntireMaturityValueB = 0.00;
    EntireTotalPremiumPaid = 0.00;
    
    [self deleteTemp]; //clear all temp data
   
    [self getAllPreDetails]; // get all the details needed before proceed 
    
    [self InsertHeaderBasicPlan]; //insert basic plan header into temp table bm and english
                
    if (IncomeRiderCode.count > 0) {
        [self InsertHeaderRiderPlan];  //insert income rider header into temp table bm and english
    }
    
    [self InsertHeaderTB]; //insert summary of basic plan header into temp table bm and english
 
    [self InsertToSI_Temp_Trad_LA]; // for the front summary page 
 
    [self InsertToSI_Temp_Trad_Details]; // for the front summary page figures
 
    [self InsertToSI_Temp_Trad_Basic];

    
    [self InsertToSI_Temp_Trad_RideriLLus];
 
    [self InsertToSI_Temp_Trad_Rider];
    
    
    [self InsertToSI_Temp_Trad_Summary];

    [self InsertToSI_Temp_Trad];    
    
    [self InsertToSI_Temp_Trad_Overall];
    
    [self UpdateToSI_Temp_Trad_Details];
    
    NSString *siNo = @"";
    NSString *databaseName = @"hladb.sqlite";
    NSString *databaseName1 = @"0000000000000001.db";
    NSString *masterName = @"Databases.db";
    
    
    
    self.db = [DBController sharedDatabaseController:databaseName];
    
    NSString *sqlStmt = [NSString stringWithFormat:@"SELECT SiNo FROM SI_Temp_Trad"];
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    NSArray* row = [_dataTable.rows objectAtIndex:0];
    siNo = [row objectAtIndex:0];
    //NSLog(@"%@",siNo);
    
    //sqlStmt = [NSString stringWithFormat:@"SELECT RiderCode FROM SI_Trad_Rider_Details Where SINo = '%@'",siNo];
    sqlStmt = [NSString stringWithFormat:@"SELECT RiderCode FROM Trad_Rider_Details Where SINo = '%@' ORDER BY RiderCode ASC",siNo];
    
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    int pageNum = 3;
    int iRiderCount = 0;
    int riderCount = 0;
    int riderCountStart = 19; //rider html page number
    NSString *desc = @"Page";
    int DBID;
    //desc = [desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]];
    //NSLog(@"%@", desc);
    
    sqlStmt = @"Delete from SI_Temp_Pages where PageNum NOT in ('1', '2', '3') ";
    DBID = [_db ExecuteINSERT:sqlStmt];
    /*
    for (row in _dataTable.rows) //income rider
    {
        if ([[row objectAtIndex:0] isEqualToString:@"I20R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page4_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page4_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"I30R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page5_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page5_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"I40R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page6_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page6_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"ID20R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page7_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page7_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"ID30R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page8_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page8_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"ID40R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page9_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page9_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"IE20R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page10_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page10_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"IE30R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page11_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page11_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
    }
    
    //summary page
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page12.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    for (row in _dataTable.rows) //income rider
    {
        //if ([row objectAtIndex:0] != @"ID20R")
        if ([[row objectAtIndex:0] isEqualToString:@"I20R"] || [[row objectAtIndex:0] isEqualToString:@"I30R"] || [[row objectAtIndex:0] isEqualToString:@"I40R"] || [[row objectAtIndex:0] isEqualToString:@"ID20R"] || [[row objectAtIndex:0] isEqualToString:@"ID30R"] || [[row objectAtIndex:0] isEqualToString:@"ID40R"] || [[row objectAtIndex:0] isEqualToString:@"IE20R"] || [[row objectAtIndex:0] isEqualToString:@"I30R"])
            NSLog(@"");
        else
        {
            //pageNum++;
            riderCount++;
            if (riderCount % 3 == 1){
                pageNum++;
                riderCountStart++;
                
                
                //[desc stringByAppendingString:[NSString stringWithFormat:@"%d",riderCountStart]];
                
                
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('%@',%d,'%@')",[desc stringByAppendingString:[NSString stringWithFormat:@"%d.html",riderCountStart]],pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                //NSLog(@"%@",sqlStmt);
                DBID = [_db ExecuteINSERT:sqlStmt];
                if (DBID <= 0){
                    NSLog(@"Error inserting data into database.");
                }
            }
            //int a;
            //a = 4 % 3;
            //NSLog(@"%d",a);
            //NSLog(@"%@",[row objectAtIndex:0]);
            
        }
    }
    */
    
    for (row in _dataTable.rows) //income rider
    {
        if ([[row objectAtIndex:0] isEqualToString:@"I20R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page4_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page4_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"I30R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page5_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page5_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"I40R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page6_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page6_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"ID20R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page7_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page7_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"ID30R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page8_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page8_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"ID40R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page9_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page9_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"IE20R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page10_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page10_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
        else if ([[row objectAtIndex:0] isEqualToString:@"IE30R"]){
            iRiderCount++;
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page11_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page11_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
        }
    }
    
    
      
      /*  
        //summary page
    if ([_dataTable.rows containsObject:@"I20R" ] == TRUE || [_dataTable.rows containsObject:@"I30R" ] == TRUE || [_dataTable.rows containsObject:@"I40R" ] == TRUE || [_dataTable.rows containsObject:@"IE20R" ] == TRUE
        ||[_dataTable.rows containsObject:@"IE30R"  ] == TRUE ||[_dataTable.rows containsObject:@"ID20R" ] == TRUE ||[_dataTable.rows containsObject:@"ID30R" ] == TRUE ||[_dataTable.rows containsObject:@"ID40R" ] == TRUE) {
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page12.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        
    }
    */
    for (row in _dataTable.rows) //income rider
    {
        if ([[row objectAtIndex:0] isEqualToString:@"I20R"] || [[row objectAtIndex:0] isEqualToString:@"I30R"] || [[row objectAtIndex:0] isEqualToString:@"I40R"] || [[row objectAtIndex:0] isEqualToString:@"ID20R"] || [[row objectAtIndex:0] isEqualToString:@"ID30R"] || [[row objectAtIndex:0] isEqualToString:@"ID40R"] || [[row objectAtIndex:0] isEqualToString:@"IE20R"] || [[row objectAtIndex:0] isEqualToString:@"IE30R"])
            //|| [[row objectAtIndex:0] isEqualToString:@"LCWP"] || [[row objectAtIndex:0] isEqualToString:@"SP_PRE"] || [[row objectAtIndex:0] isEqualToString:@"PLCP"]
            NSLog(@"");
        else
        {
            riderCount++;
            if (riderCount % 3 == 1){
                pageNum++;
                riderCountStart++;
                
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('%@',%d,'%@')",[desc stringByAppendingString:[NSString stringWithFormat:@"%d.html",riderCountStart]],pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                if (DBID <= 0){
                    NSLog(@"Error inserting data into database.");
                }
            }
            //int a;
            //a = 4 % 3;
            //NSLog(@"%d",a);
            //NSLog(@"%@",[row objectAtIndex:0]);
            
        }
    }
    
    //summary page
    for (row in _dataTable.rows){
        if ([[row objectAtIndex:0] isEqualToString:@"I20R"] || [[row objectAtIndex:0] isEqualToString:@"I30R"] || [[row objectAtIndex:0] isEqualToString:@"I40R"] || [[row objectAtIndex:0] isEqualToString:@"ID20R"] || [[row objectAtIndex:0] isEqualToString:@"ID30R"] || [[row objectAtIndex:0] isEqualToString:@"ID40R"] || [[row objectAtIndex:0] isEqualToString:@"IE20R"] || [[row objectAtIndex:0] isEqualToString:@"IE30R"])
        {
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page12.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            break;
        }
        
    }
    
    //description of basic plan, 2 pages
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page30.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page31.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    //rider benefits
    riderCount = 0; //reset rider count
    int descRiderCountStart = 100; //start of rider description page
    int riderInPageCount = 0; //number of rider in a page, maximum 3
    NSString *riderInPage = @""; //rider in a page, write to db
    //NSString *riderInPage1 = @"";
    NSString *curRider; //current rider
    NSString *prevRider; //previous rider
    NSString *headerTitle = @"tblHeader;";
    
    
    sqlStmt = [NSString stringWithFormat:@"SELECT RiderCode FROM Trad_Rider_Details Where SINo = '%@' ORDER BY RiderCode ASC ",siNo];
    //NSLog(@"%@",sqlStmt);
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    for (row in _dataTable.rows) //income rider
    {
        riderCount++;
        curRider = [row objectAtIndex:0];
        
        //NSLog(@"%@",curRider);
        
        if ([curRider isEqualToString:@"CCTR"] || [curRider isEqualToString:@"ETPD"] || [curRider isEqualToString:@"HB"] || [curRider isEqualToString:@"HMM"] || [curRider isEqualToString:@"HSP_II"] || [curRider isEqualToString:@"MG_II"] || [curRider isEqualToString:@"MG_IV"] || [curRider isEqualToString:@"PA"] || [curRider isEqualToString:@"PR"] || [curRider isEqualToString:@"SP_STD"] || [curRider isEqualToString:@"PTR"]){
            riderInPageCount++;
            prevRider = curRider;
            
            riderInPage = [riderInPage stringByAppendingString:curRider];
            riderInPage = [riderInPage stringByAppendingString:@";"];
            if (riderInPageCount == 3){
                //NSLog(@"%@",riderInPage);
                pageNum++;
                if(riderCount == 1)
                    riderInPage = [headerTitle stringByAppendingString:riderInPage];
                descRiderCountStart++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES ('%@','Page%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                if (DBID <= 0){
                    NSLog(@"Error inserting data into database.");
                }
                //NSLog(@"%@",sqlStmt);
                riderInPageCount = 0;
                riderInPage = @"";
            }
            
            if (riderInPageCount == 1 && riderCount == _dataTable.rows.count){
                NSLog(@"%@",riderInPage);
            }
        }
        else{
            if (riderInPageCount == 2){
                //NSLog(@"%@",riderInPage);
                pageNum++;
                if(riderCount == 1)
                    riderInPage = [headerTitle stringByAppendingString:riderInPage];
                descRiderCountStart++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES ('%@','Page%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                if (DBID <= 0){
                    NSLog(@"Error inserting data into database.");
                }
                //NSLog(@"%@",sqlStmt);
                riderInPageCount = 0;
                riderInPage = @"";
            }
            if ([prevRider isEqualToString:@"CCTR"] || [prevRider isEqualToString:@"ETPD"] || [prevRider isEqualToString:@"HB"] || [prevRider isEqualToString:@"HMM"] || [prevRider isEqualToString:@"HSP_II"] || [prevRider isEqualToString:@"MG_II"] || [prevRider isEqualToString:@"MG_IV"] || [prevRider isEqualToString:@"PA"] || [prevRider isEqualToString:@"PR"] || [prevRider isEqualToString:@"SP_STD"] || [prevRider isEqualToString:@"PTR"]){
                prevRider = [prevRider stringByAppendingString:@";"];
                curRider = [prevRider stringByAppendingString:curRider];
                riderInPageCount = 0;
                riderInPage = @"";
            }
            //NSLog(@"%@",curRider);
            pageNum++;
            if(riderCount == 1)
                curRider = [headerTitle stringByAppendingString:curRider];
            descRiderCountStart++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES ('%@','Page%d.html',%d,'%@')",curRider,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            //NSLog(@"%@",sqlStmt);
        }
    }
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page40.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page41.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page42.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }

    // malay version here page201.html ---> page 220
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page50.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page51.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    riderCount = 0; //reset rider count
    descRiderCountStart = 200; //start of rider description page
    riderInPageCount = 0; //number of rider in a page, maximum 3
    riderInPage = @""; //rider in a page, write to db
    //NSString *riderInPage1 = @"";
    curRider = @""; //current rider
    prevRider = @""; //previous rider
    headerTitle = @"tblHeader;";
    
    for (row in _dataTable.rows) //income rider
    {
        riderCount++;
        curRider = [row objectAtIndex:0];
        
        //NSLog(@"%@",curRider);
        
        if ([curRider isEqualToString:@"CCTR"] || [curRider isEqualToString:@"ETPD"] || [curRider isEqualToString:@"HB"] || [curRider isEqualToString:@"HMM"] || [curRider isEqualToString:@"HSP_II"] || [curRider isEqualToString:@"MG_II"] || [curRider isEqualToString:@"MG_IV"] || [curRider isEqualToString:@"PA"] || [curRider isEqualToString:@"PR"] || [curRider isEqualToString:@"SP_STD"] || [curRider isEqualToString:@"PTR"]){
            riderInPageCount++;
            prevRider = curRider;
            
            riderInPage = [riderInPage stringByAppendingString:curRider];
            riderInPage = [riderInPage stringByAppendingString:@";"];
            if (riderInPageCount == 3){
                //NSLog(@"%@",riderInPage);
                pageNum++;
                if(riderCount == 1)
                    riderInPage = [headerTitle stringByAppendingString:riderInPage];
                descRiderCountStart++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES ('%@','Page%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                if (DBID <= 0){
                    NSLog(@"Error inserting data into database.");
                }
                //NSLog(@"%@",sqlStmt);
                riderInPageCount = 0;
                riderInPage = @"";
            }
            
            if (riderInPageCount == 1 && riderCount == _dataTable.rows.count){
                NSLog(@"%@",riderInPage);
            }
        }
        else{
            if (riderInPageCount == 2){
                //NSLog(@"%@",riderInPage);
                pageNum++;
                if(riderCount == 1)
                    riderInPage = [headerTitle stringByAppendingString:riderInPage];
                descRiderCountStart++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES ('%@','Page%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                if (DBID <= 0){
                    NSLog(@"Error inserting data into database.");
                }
                //NSLog(@"%@",sqlStmt);
                riderInPageCount = 0;
                riderInPage = @"";
            }
            if ([prevRider isEqualToString:@"CCTR"] || [prevRider isEqualToString:@"ETPD"] || [prevRider isEqualToString:@"HB"] || [prevRider isEqualToString:@"HMM"] || [prevRider isEqualToString:@"HSP_II"] || [prevRider isEqualToString:@"MG_II"] || [prevRider isEqualToString:@"MG_IV"] || [prevRider isEqualToString:@"PA"] || [prevRider isEqualToString:@"PR"] || [prevRider isEqualToString:@"SP_STD"] || [prevRider isEqualToString:@"PTR"]){
                prevRider = [prevRider stringByAppendingString:@";"];
                curRider = [prevRider stringByAppendingString:curRider];
                riderInPageCount = 0;
                riderInPage = @"";
            }
            //NSLog(@"%@",curRider);
            pageNum++;
            if(riderCount == 1)
                curRider = [headerTitle stringByAppendingString:curRider];
            descRiderCountStart++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(riders,htmlName, PageNum, PageDesc) VALUES ('%@','Page%d.html',%d,'%@')",curRider,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            //NSLog(@"%@",sqlStmt);
        }
    }
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page60.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page61.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages(htmlName, PageNum, PageDesc) VALUES ('Page62.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    
    //------- end ---------
    
    NSString* library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSString *WebSQLSubdir;
    NSString *WebSQLPath;
    NSString *WebSQLDb;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (IsAtLeastiOSVersion(@"6.0")){
        /*
        WebSQLSubdir = @"WebKit/LocalStorage";
        WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
        WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
         */
        NSString *viewerPlist = [library stringByAppendingPathComponent:@"viewer.plist"];
        BOOL plistExist = [fileManager fileExistsAtPath:viewerPlist];
        if (!plistExist){
            NSLog(@"not exist!");
            NSString *viewerPlistFromDoc = [documents stringByAppendingPathComponent:@"viewer.plist"];
            [fileManager copyItemAtPath:viewerPlistFromDoc toPath:viewerPlist error:nil];
            
            databaseName = @"hladb.sqlite";//actual
            databaseName1 = @"hladb.sqlite";//dummy
            WebSQLSubdir = @"Caches";
            WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
            WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
            
            
            
        }
        else{
            NSLog(@"exist!");
            
            databaseName = @"hladb.sqlite";//actual
            databaseName1 = @"hladb.sqlite";//dummy
            WebSQLSubdir = @"WebKit/LocalStorage";
            WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
            WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
            
            
        }
        
    }
    else{
        /*
        WebSQLSubdir = (IsAtLeastiOSVersion(@"5.1")) ? @"Caches" : @"WebKit/Databases";
        WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
        WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
         */
        databaseName = @"hladb.sqlite";//actual
        databaseName1 = @"hladb.sqlite";//dummy
        WebSQLSubdir = (IsAtLeastiOSVersion(@"5.1")) ? @"Caches" : @"WebKit/Databases";
        WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
        WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
    }
    
    NSString *masterFile = [WebSQLPath stringByAppendingPathComponent:masterName];
    NSString *databaseFile = [WebSQLDb stringByAppendingPathComponent:databaseName1];
    
    [fileManager removeItemAtPath:databaseFile error:nil];
    [fileManager removeItemAtPath:masterFile error:nil];
    
    //NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    NSString *masterPathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:masterName];
    
    
    NSString *databasePathFromDoc = [docsDir stringByAppendingPathComponent:databaseName];
    //NSString *masterPathFromDoc = [docsDir stringByAppendingPathComponent:masterName];
    
    [fileManager createDirectoryAtPath:WebSQLDb withIntermediateDirectories:YES attributes:nil error:NULL];
    [fileManager copyItemAtPath:databasePathFromDoc toPath:databaseFile error:nil];
    [fileManager copyItemAtPath:masterPathFromApp toPath:masterFile error:nil];
    fileManager = Nil;
 
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)deleteTemp{
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        
        QuerySQL = @"Delete from SI_temp_Header_BM";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from SI_temp_Header_EN";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from SI_temp_Rider";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from SI_temp_Trad";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from SI_temp_Trad_Basic";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from SI_temp_Trad_details";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete  from SI_temp_Trad_Overall";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from SI_temp_Trad_Rider";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from SI_temp_Trad_Riderillus";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete  from SI_temp_Trad_Summary";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from SI_temp_trad_LA";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }    
    
}

-(void)InsertHeaderBasicPlan{
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    NSString *getHeaderEngSQL;
    NSString *getHeaderBMSQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
    
        
        if ([YearlyIncome isEqualToString:@"ACC"]) { 
           
            if ([CashDividend isEqualToString:@"ACC"]) { //yearly income = acc, cash dividend = acc
                getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                                   " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                                   " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\",\"Col14\",\"Col15\") VALUES ( "
                                   " \"%@\",\"BP\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(Beg. of Year)\", "
                                   " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                                   " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                                   " \"Total Annual Premium(Include all riders)(Beg. of Year)\", \"Current Year Cash Divedend\", "
                                   " \"Accumulated Cash Dividends\", \"Accumulated Yearly Income\",  "
                                   " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ) ", SINo];
                
                getHeaderBMSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_BM "
                                  " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                                  " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\",\"Col14\", \"Col15\") VALUES ( "
                                  " \"%@\",\"BP\",\"Tahun Polisi\",\"Umur Hayat Diinsuranskan pada Akhir Tahun\", \"Premium Tahunan(Permulaan Tahun)(1)\", "
                                  " \"Pendapatan Tahunan (Akhir Tahun)(2)\", \"Nilai Penyerahan (Akhir Tahun)(3)\", \"Faedah kematian/TPD (4)\",  "
                                  " \"Faedah Tambahab TPD kemalangan(5)\",\"Jumlah Nilai Penyerahan (Akhir Tahun)(6)=(3)+(10)+(11)+(12)\",\"Jumlah Faedah kematian/TPD (Akhir Tahun)(7)=(4B)+(10)+(11)+(13)\", "
                                  " \"Jumlah Premium Tahunan(Termasuk semua rider)(Permulaan Tahun)(8)\", \"Dividen Tunai Tahun Semasa(9)\", "
                                  " \"Dividen Tunai Terkumpul (10)\", \"Pendapatan Tahunan Terkumpul (11)\",  "
                                  " \"Dividen Terminal Dibayar atas Penyerahan/Matang (12)\", \"Dividen Terminal Istimewa Dibayar atas Kematian/TPD (13)\" ) ", SINo];
                
                
            }
            else { //yearly income = acc, cash dividend = pay out
                getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                                   " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                                   " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\",\"Col14\") VALUES ( "
                                   " \"%@\",\"BP\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(beg. of Year)\", "
                                   " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                                   " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                                   " \"Total Annual Premium(Include all riders)(Beg. of Year)\", \"Current Year Cash Divedend\", "
                                   " \"Accumulated Yearly Income\",  "
                                   " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ) ", SINo];
                
                getHeaderBMSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_BM "
                                  " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                                  " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\",\"Col14\") VALUES ( "
                                  " \"%@\",\"BP\",\"Tahun Polisi\",\"Umur Hayat Diinsuranskan pada Akhir Tahun\", \"Premium Tahunan(Permulaan Tahun)(1)\", "
                                  " \"Pendapatan Tahunan (Akhir Tahun)(2)\", \"Nilai Penyerahan (Akhir Tahun)(3)\", \"Faedah kematian/TPD (4)\",  "
                                  " \"Faedah Tambahab TPD kemalangan(5)\",\"Jumlah Nilai Penyerahan (Akhir Tahun)(6)=(3)+(10)+(11)\",\"Jumlah Faedah kematian/TPD (Akhir Tahun)(7)=(4B)+(10)+(12)\", "
                                  " \"Jumlah Premium Tahunan(Termasuk semua rider)(Permulaan Tahun)(8)\", \"Dividen Tunai Tahun Semasa(9)\", "
                                  " \"Pendapatan Tahunan Terkumpul (10)\",  "
                                  " \"Dividen Terminal Dibayar atas Penyerahan/Matang (11)\", \"Dividen Terminal Istimewa Dibayar atas Kematian/TPD (12)\" ) ", SINo];
                
            }
            
        }
        else { 
            
            if ([CashDividend isEqualToString:@"ACC"]) { //yearlyincome = pay out, cash dividend = acc
                getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                                   " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                                   " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\",\"Col14\") VALUES ( "
                                   " \"%@\",\"BP\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(beg. of Year)\", "
                                   " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                                   " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                                   " \"Total Annual Premium(Include all riders)(Beg. of Year)\", \"Current Year Cash Divedend\", "
                                   " \"Accumulated Cash Dividends\",  "
                                   " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ) ", SINo];
                
                getHeaderBMSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_BM "
                                  " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                                  " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\",\"Col14\") VALUES ( "
                                  " \"%@\",\"BP\",\"Tahun Polisi\",\"Umur Hayat Diinsuranskan pada Akhir Tahun\", \"Premium Tahunan(Permulaan Tahun)(1)\", "
                                  " \"Pendapatan Tahunan (Akhir Tahun)(2)\", \"Nilai Penyerahan (Akhir Tahun)(3)\", \"Faedah kematian/TPD (4)\",  "
                                  " \"Faedah Tambahab TPD kemalangan(5)\",\"Jumlah Nilai Penyerahan (Akhir Tahun)(6)=(3)+(10)+(11)\",\"Jumlah Faedah kematian/TPD (Akhir Tahun)(7)=(4B)+(10)+(12)\", "
                                  " \"Jumlah Premium Tahunan(Termasuk semua rider)(Permulaan Tahun)(8)\", \"Dividen Tunai Tahun Semasa(9)\", "
                                  " \"Dividen Tunai Terkumpul (10)\",  "
                                  " \"Dividen Terminal Dibayar atas Penyerahan/Matang (11)\", \"Dividen Terminal Istimewa Dibayar atas Kematian/TPD (12)\" ) ", SINo];
                
            }
            else { //yearlyincome = pay out, cash dividend = pay out
            
            getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                               " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                               " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\") VALUES ( "
                               " \"%@\",\"BP\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(beg. of Year)\", "
                               " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                               " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                               " \"Total Annual Premium(Include all riders)(Beg. of Year)\", \"Current Year Cash Divedend\", "
                               " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ) ", SINo];
            getHeaderBMSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_BM "
                              " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                              " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\") VALUES ( "
                              " \"%@\",\"BP\",\"Tahun Polisi\",\"Umur Hayat Diinsuranskan pada Akhir Tahun\", \"Premium Tahunan(Permulaan Tahun)(1)\", "
                              " \"Pendapatan Tahunan (Akhir Tahun)(2)\", \"Nilai Penyerahan (Akhir Tahun)(3)\", \"Faedah kematian/TPD (4)\",  "
                              " \"Faedah Tambahab TPD kemalangan(5)\",\"Jumlah Nilai Penyerahan (Akhir Tahun)(6)=(3)+(10)\",\"Jumlah Faedah kematian/TPD (Akhir Tahun)(7)=(4B)+(11)\", "
                              " \"Jumlah Premium Tahunan(Termasuk semua rider)(Permulaan Tahun)(8)\", \"Dividen Tunai Tahun Semasa(9)\", "
                              " \"Dividen Terminal Dibayar atas Penyerahan/Matang (10)\", \"Dividen Terminal Istimewa Dibayar atas Kematian/TPD (11)\" ) ", SINo];
            }
        }
        
        if(sqlite3_prepare_v2(contactDB, [getHeaderEngSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE){
                
                if(sqlite3_prepare_v2(contactDB, [getHeaderBMSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement2) == SQLITE_DONE){
                        
                    }
                    sqlite3_finalize(statement2);    
                }
                
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(contactDB);
    }    
}

-(void)InsertHeaderRiderPlan{
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    NSString *getHeaderEngSQL;
    NSString *getHeaderBMSQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        
        if ([YearlyIncome isEqualToString:@"ACC"]) {
            
            if ([CashDividend isEqualToString:@"ACC"]) { //YearlyIncome = acc, cash dividend = acc
             
                getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                               " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                               " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\",\"Col14\") VALUES ( "
                               " \"%@\",\"RD\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(Beg. of Year)\", "
                               " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                               " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                               " \"Current Year Cash Divedend\", "
                               " \"Accumulated Cash Dividends\", \"Accumulated Yearly Income\",  "
                               " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ) ", SINo];
            
                getHeaderBMSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_BM "
                              " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                              " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\",\"Col14\") VALUES ( "
                              " \"%@\",\"RD\",\"Tahun Polisi\",\"Umur Hayat Diinsuranskan pada Akhir Tahun\", \"Premium Tahunan(Permulaan Tahun)(1)\", "
                              " \"Pendapatan Tahunan (Akhir Tahun)(2)\", \"Nilai Penyerahan (Akhir Tahun)(3)\", \"Faedah kematian/TPD (4)\",  "
                              " \"Faedah Tambahab TPD kemalangan(5)\",\"Jumlah Nilai Penyerahan (Akhir Tahun)(6)=(3)+(9)+(10)+(11)\",\"Jumlah Faedah kematian/TPD (Akhir Tahun)(7)=(4B)+(9)+(10)+(12)\", "
                              " \"Dividen Tunai Tahun Semasa(8)\", "
                              " \"Dividen Tunai Terkumpul (9)\", \"Pendapatan Tahunan Terkumpul (10)\",  "
                              " \"Dividen Terminal Dibayar atas Penyerahan/Matang (11)\", \"Dividen Terminal Istimewa Dibayar atas Kematian/TPD (12)\" ) ", SINo];
            }
            else { //yearlyincome = acc, cash dividend = pay out
                getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                                   " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                                   " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\") VALUES ( "
                                   " \"%@\",\"RD\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(beg. of Year)\", "
                                   " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                                   " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                                   " \"Current Year Cash Divedend\", "
                                   " \"Accumulated Yearly Income\",  "
                                   " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ) ", SINo];
                
                getHeaderBMSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_BM "
                                  " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                                  " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\") VALUES ( "
                                  " \"%@\",\"RD\",\"Tahun Polisi\",\"Umur Hayat Diinsuranskan pada Akhir Tahun\", \"Premium Tahunan(Permulaan Tahun)(1)\", "
                                  " \"Pendapatan Tahunan (Akhir Tahun)(2)\", \"Nilai Penyerahan (Akhir Tahun)(3)\", \"Faedah kematian/TPD (4)\",  "
                                  " \"Faedah Tambahab TPD kemalangan(5)\",\"Jumlah Nilai Penyerahan (Akhir Tahun)(6)=(3)+(9)+(10)\",\"Jumlah Faedah kematian/TPD (Akhir Tahun)(7)=(4B)+(9)+(11)\", "
                                  " \"Dividen Tunai Tahun Semasa(8)\", "
                                  " \"Pendapatan Tahunan Terkumpul (9)\",  "
                                  " \"Dividen Terminal Dibayar atas Penyerahan/Matang (10)\", \"Dividen Terminal Istimewa Dibayar atas Kematian/TPD (11)\" ) ", SINo];
            }
            
        }
        else {
            
            if ([CashDividend isEqualToString:@"ACC"]) { //yearlyincome = pay out, cash dividend = acc
                    
                getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                                   " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                                   " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\") VALUES ( "
                                   " \"%@\",\"RD\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(beg. of Year)\", "
                                   " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                                   " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                                   " \"Current Year Cash Divedend\", "
                                   " \"Accumulated Cash Dividends\",  "
                                   " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ) ", SINo];
                
                getHeaderBMSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_BM "
                                  " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                                  " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\") VALUES ( "
                                  " \"%@\",\"RD\",\"Tahun Polisi\",\"Umur Hayat Diinsuranskan pada Akhir Tahun\", \"Premium Tahunan(Permulaan Tahun)(1)\", "
                                  " \"Pendapatan Tahunan (Akhir Tahun)(2)\", \"Nilai Penyerahan (Akhir Tahun)(3)\", \"Faedah kematian/TPD (4)\",  "
                                  " \"Faedah Tambahab TPD kemalangan(5)\",\"Jumlah Nilai Penyerahan (Akhir Tahun)(6)=(3)+(9)+(10)\",\"Jumlah Faedah kematian/TPD (Akhir Tahun)(7)=(4B)+(9)+(11)\", "
                                  " \"Dividen Tunai Tahun Semasa(8)\", "
                                  " \"Dividen Tunai Terkumpul (9)\",  "
                                  " \"Dividen Terminal Dibayar atas Penyerahan/Matang (10)\", \"Dividen Terminal Istimewa Dibayar atas Kematian/TPD (11)\" ) ", SINo];
                
            }
            else { //yearlyincome = pay out, cash dividend = pay out
                
            getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                               " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                               " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\") VALUES ( "
                               " \"%@\",\"RD\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(beg. of Year)\", "
                               " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                               " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                               " \"Current Year Cash Divedend\", "
                               " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ) ", SINo];
            
            getHeaderBMSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_BM "
                              " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                              " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\") VALUES ( "
                              " \"%@\",\"RD\",\"Tahun Polisi\",\"Umur Hayat Diinsuranskan pada Akhir Tahun\", \"Premium Tahunan(Permulaan Tahun)(1)\", "
                              " \"Pendapatan Tahunan (Akhir Tahun)(2)\", \"Nilai Penyerahan (Akhir Tahun)(3)\", \"Faedah kematian/TPD (4)\",  "
                              " \"Faedah Tambahab TPD kemalangan(5)\",\"Jumlah Nilai Penyerahan (Akhir Tahun)(6)=(3)+(10)\",\"Jumlah Faedah kematian/TPD (Akhir Tahun)(7)=(4B)+(10)\", "
                              " \"Dividen Tunai Tahun Semasa(8)\", "
                              " \"Dividen Terminal Dibayar atas Penyerahan/Matang (9)\", \"Dividen Terminal Istimewa Dibayar atas Kematian/TPD (10)\" ) ", SINo];
            
            }
        }
        
        if(sqlite3_prepare_v2(contactDB, [getHeaderEngSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE){
                if(sqlite3_prepare_v2(contactDB, [getHeaderBMSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement2) == SQLITE_DONE){
                    }
                
                    sqlite3_finalize(statement2);
                }
                
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(contactDB);
    }    

}

-(void)InsertHeaderTB{
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    NSString *getHeaderEngSQL;
    NSString *getHeaderBMSQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        
            getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                            " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                            " \"Col8\",\"Col9\") VALUES ( "
                            " \"%@\",\"TB\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Total Annual Premium of IB & IR(s)(beg. of Year)\", "
                            " \"Total Guaranteed Yearly Income (End of Year)\", \"Total Guaranteed Surrender Value(End of Year)\", \"Total Guaranteed Death/TPD Benefit *^\",  "
                            " \"Guaranteed Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\" ) "
                            " ", SINo];
            
            getHeaderBMSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_BM "
                          " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                          " \"Col8\",\"Col9\") VALUES ( "
                          " \"%@\",\"TB\",\"Tahun Polisi\",\"Umur Hayat Diinsuranskan pada Akhir Tahun\", \" Jumlah Premium Tahunan untuk IB & IR(Permulaan Tahun)\", "
                          " \"Jumlah Pendapatan Tahunan Terjamin (Akhir Tahun)\", \"Jumlah Nilai Penyerahan Terjamin (Akhir Tahun)\", \"Faedah kematian/TPD Terjamin\",  "
                          " \"Faedah Tambahan TPD kemalangan Terjamin\",\"Jumlah Nilai Penyerahan (Akhir Tahun)\",\"Jumlah Manfaat kematian/TPD (Akhir Tahun)\" ) "
                          " ", SINo];
        
        
        if(sqlite3_prepare_v2(contactDB, [getHeaderEngSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE){
                if(sqlite3_prepare_v2(contactDB, [getHeaderBMSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement2) == SQLITE_DONE){
                    
                    }
                    sqlite3_finalize(statement2);
                        
                }
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);  
    }    
}

-(void)InsertToSI_Temp_Trad{
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        NSString *strEngYearlyIncome = @"";
        NSString *strBMYearlyIncome = @"";
        
        if (![YearlyIncome isEqualToString:@"ACC"]) {
            strEngYearlyIncome = @"(Yearly Income Pay Out)";
            strBMYearlyIncome = @"(Pendapatan Tahunan Dibayar)";
        }
        else {
            strEngYearlyIncome = @"(Yearly Income Accumulation)";
            strBMYearlyIncome = @"(Pendapatan Tahunan Terkumpul)";
        }
        
        QuerySQL = [NSString stringWithFormat:@"INSERT INTO SI_Temp_trad(\"SINo\",\"LAName\",\"PlanCode\",\"PlanName\",\"PlanDesc\", "
                    " \"MPlanDesc\",\"CashPaymentT\",\"CashPaymentD\",\"MCashPaymentT\",\"MCashPaymentD\",\"HLoadingT\",\"MHLoadingT\", "
                    " \"OccLoadingT\",\"MOccLoadingT\",\"PolTerm\",\"TotPremPaid\",\"SurrenderValueHigh\",\"SurrenderValueLow\",\"CashPayment\", "
                    " \"SurrenderValuePaidUpHigh\",\"SurrenderValuePaidUpLow\",\"GlncPaid\",\"SumTotPremPaid\",\"SurrenderValuePaidUpHigh2\", "
                    " \"SurrenderValuePaidUpLow2\",\"SumTotPremPaid2\",\"TotalYearlylncome\",\"SumTotalYearlyIncome\",\"SumTotalYearlyIncome2\", "
                    " \"TotalPremPaid2\",\"SurrenderValueHigh2\",\"SurrenderValueLow2\",\"TotalYearlyIncome2\") VALUES "
                    " (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%.3f\",\"%.8f\", "
                    " \"%.9f\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%.3f\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\") ", 
                    SINo, Name, @"HLAIB", @"HLA Income Builder", @"Participating Whole Life Plan with Guaranteed Yearly Income and",
                    @"Pelan Penyertaan Sepanjang Hayat dengan Pendapatan Tahunan Terjamin dan ", @"", strEngYearlyIncome, @"", strBMYearlyIncome,
                    @"", @"", @"Occ Loading (per 1k SA)", @"Caj Tambahan Perkerjaan (1k JAD)", 
                    PolicyTerm, BasicTotalPremiumPaid, 
                    BasicMaturityValueA, BasicMaturityValueB, 0, 0, 0, 0, arc4random()%10000 + 100, 0, 0, 0, BasicTotalYearlyIncome,
                    arc4random()%10000 + 100,0,0,0,0,0 ];
        
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            } 
            sqlite3_finalize(statement);
        }   
        sqlite3_close(contactDB);
        
    }    
    
}

-(void)InsertToSI_Temp_Trad_LA{
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    sqlite3_stmt *statement3;
    NSString *getCustomerCodeSQL;
    NSString *getFromCltProfileSQL;
    NSString *smoker;
    NSString *QuerySQL;
    
    NSLog(@"insert to SI Temp Trad LA --- start");
    
    for (int i = 1; i <2; i ++) {
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
            getCustomerCodeSQL = [ NSString stringWithFormat:@"select CustCode from Trad_LaPayor where sino = \"%@\" AND sequence = %d ", SINo, i];
            
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
                            
                            QuerySQL  = [ NSString stringWithFormat:@"Insert INTO SI_Temp_Trad_LA (\"SINo\", \"LADesc\", "
                                         "\"PtypeCode\", \"Seq\", \"Name\", \"Age\", \"Sex\", \"Smoker\", \"LADescM\") "
                                         " VALUES (\"%@\",\"Life Assured\",\"LA\",\"%d\",\"%@\",\"%d\", \"%@\", \"%@\", "
                                         " \"Hayat yang Diinsuranskan\")", SINo, i, Name, Age, sex, smoker ]; 
                            
                            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement3, NULL) == SQLITE_OK) {
                                if (sqlite3_step(statement3) == SQLITE_DONE) {
                                    //NSLog(@"done insert to temp_trad_LA");
                                }
                                sqlite3_finalize(statement3);
                            }
                        }
                        sqlite3_finalize(statement2);
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        } 
    }
    
    
    NSLog(@"insert to SI_Temp_Trad_LA --- End");
        
}

-(void)InsertToSI_Temp_Trad_Details{
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    NSString *RiderSQL;
    NSString *SelectSQL = @"";
    
        
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
             /*   
            double annually =arc4random() % 5000 + 500;
            double semiAnnually = annually * 0.5125;
            double Quarterly = annually * 0.2625;
            double monthly = annually * 0.0875;
            */
            NSString *strAnnually = @"";
            NSString *strSemiAnnually = @"";
            NSString *strQuarterly = @"";
            NSString *strMonthly = @"";
            
                SelectSQL = @"Select * from SI_Store_Premium where type = \"B\" ";
                if(sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_ROW) {
                        strAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                        strSemiAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                        strQuarterly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                        strMonthly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                        strBasicAnnually = strAnnually;
                        strBasicSemiAnnually = strSemiAnnually;
                        strBasicQuarterly = strQuarterly;
                        strBasicMonthly = strMonthly;
                    }
                    sqlite3_finalize(statement);
                }
            
            /*
                QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") "
                            " VALUES ( "
                            " \"%@\",\"1\",\"DATA\",\"HLA Income Builder\",\"\",\"0\",\"%d\",\"%d\",\"%d\",\"%.2f\",\"%.2f\",\"%.2f\",\"%.2f\",\"\",\"2\" "
                            ")", SINo, BasicSA,PolicyTerm,PremiumPaymentOption,annually, semiAnnually, Quarterly, monthly];
              */
            
            QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                        "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") "
                        " VALUES ( "
                        " \"%@\",\"1\",\"DATA\",\"HLA Income Builder\",\"\",\"0\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"\" "
                        ")", SINo, BasicSA,PolicyTerm,PremiumPaymentOption,strAnnually, strSemiAnnually, strQuarterly, strMonthly];
            
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                        NSLog(@"insert to SI_Temp_Trad_Details --- start");
                    
                        
                    }
                    sqlite3_finalize(statement); 
                }
            
            sqlite3_close(contactDB);
        }
    
    for (int a=0; a<OtherRiderCode.count; a++) {
        /*
        double annually =arc4random() % 5000 + 500;
        double semiAnnually = annually * 0.5125;
        double Quarterly = annually * 0.2625;
        double monthly = annually * 0.0875;
        */
        NSString *strAnnually = @"";
        NSString *strSemiAnnually = @"";
        NSString *strQuarterly = @"";
        NSString *strMonthly = @"";
        
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
            
        
        SelectSQL = [ NSString stringWithFormat:@"Select * from SI_Store_Premium where \"type\" = \"%@\" ", [OtherRiderCode objectAtIndex:a]];
        
        if(sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                strAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                strSemiAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                strQuarterly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                strMonthly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                 [aStrOtherRiderAnnually addObject:[strAnnually stringByReplacingOccurrencesOfString:@"," withString:@"" ]];
                 [aStrOtherRiderSemiAnnually addObject:[strSemiAnnually stringByReplacingOccurrencesOfString:@"," withString:@"" ]];
                 [aStrOtherRiderQuarterly addObject:[strQuarterly stringByReplacingOccurrencesOfString:@"," withString:@"" ]];
                 [aStrOtherRiderMonthly addObject:[strMonthly stringByReplacingOccurrencesOfString:@"," withString:@"" ]];
            }
            sqlite3_finalize(statement);
        }
        
            // special case for CIWP and LCWP
            if ([[OtherRiderCode objectAtIndex:a] isEqualToString:@"CIWP" ] || [[OtherRiderCode objectAtIndex:a] isEqualToString:@"LCWP" ]) {
                [UpdateTradDetail addObject:[OtherRiderCode objectAtIndex:a]];
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"3\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"\", \"%@\" "
                            ")", SINo, [[OtherRiderDesc objectAtIndex:a] stringByAppendingString:[ NSString stringWithFormat:@"(%@%%)", [OtherRiderSA objectAtIndex:a]]],
                            [OtherRiderPlanOption objectAtIndex:a], @"-", [OtherRiderTerm objectAtIndex:a], [OtherRiderTerm objectAtIndex:a], @"-", 
                            @"-", @"-", @"-", [OtherRiderCode objectAtIndex:a] ];
                
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                    } 
                    sqlite3_finalize(statement); 
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"3\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"\", \"%@\" "
                            ")", SINo, @"-Annual",@"-", @"500.00", @"", @"", strAnnually, @"-", @"-", @"-", [OtherRiderCode objectAtIndex:a]];
                
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                    } 
                    sqlite3_finalize(statement); 
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"3\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"\", \"%@\" "
                            ")", SINo, @"-Semi-annual",@"-", @"400.00", @"", @"", @"-", strSemiAnnually, @"-", @"-", [OtherRiderCode objectAtIndex:a]];
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                    } 
                    sqlite3_finalize(statement); 
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"3\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"\", \"%@\" "
                            ")", SINo, @"-Quarterly",@"-", @"300.00", @"", @"", @"-", @"-", strQuarterly, @"-", [OtherRiderCode objectAtIndex:a]];
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                    } 
                    sqlite3_finalize(statement); 
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"3\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"\", \"%@\" "
                            ")", SINo, @"-Monthly",@"-", @"200.00", @"", @"", @"-", @"-", @"-", strMonthly, [OtherRiderCode objectAtIndex:a]];
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                    } 
                    sqlite3_finalize(statement); 
                }
                
            }
            else {
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") VALUES ( "
                            " \"%@\",\"3\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"\" "
                            ")", SINo, [OtherRiderDesc objectAtIndex:a],[OtherRiderPlanOption objectAtIndex:a], [OtherRiderSA objectAtIndex:a],
                            [OtherRiderTerm objectAtIndex:a], [OtherRiderTerm objectAtIndex:a], strAnnually, 
                            strSemiAnnually, strQuarterly, strMonthly];
                
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                    } 
                    sqlite3_finalize(statement); 
                }
            }
            
            sqlite3_close(contactDB);
        }
        
    }

    for (int a=0; a<IncomeRiderCode.count; a++) {
        /*
        double annually =arc4random() % 5000 + 500;
        double semiAnnually = annually * 0.5125;
        double Quarterly = annually * 0.2625;
        double monthly = annually * 0.0875;
        */
        NSString *strAnnually = @"";
        NSString *strSemiAnnually = @"";
        NSString *strQuarterly = @"";
        NSString *strMonthly = @"";
        
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
            
        
            SelectSQL = [ NSString stringWithFormat:@"Select * from SI_Store_Premium where \"type\" = \"%@\" ", [IncomeRiderCode objectAtIndex:a]];
        
            if(sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    strAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    strSemiAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    strQuarterly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    strMonthly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    //aStrIncomeRiderAnnually = strAnnually;
                    [aStrIncomeRiderAnnually addObject:strAnnually];
                    [aStrIncomeRiderSemiAnnually addObject:strSemiAnnually];
                    [aStrIncomeRiderQuarterly addObject:strQuarterly];
                    [aStrIncomeRiderMonthly addObject:strMonthly];
                    
                }
                sqlite3_finalize(statement);
            }
        
            RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                    "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") VALUES ( "
                    " \"%@\",\"5\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"\" "
                    ")", SINo, [IncomeRiderDesc objectAtIndex:a],@"", [IncomeRiderSA objectAtIndex:a],
                    [IncomeRiderTerm objectAtIndex:a], PremiumPaymentOption ,strAnnually, strSemiAnnually, 
                    strQuarterly, strMonthly];
        
            if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    
                } 
                sqlite3_finalize(statement); 
            }
            sqlite3_close(contactDB);
        }
    }
    
    NSLog(@"insert to SI_Temp_Trad_Details --- End");
    
}

-(void)InsertToSI_Temp_Trad_Basic{
    
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    int inputAge;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    NSMutableArray *rates = [[NSMutableArray alloc] init ];
    NSMutableArray *SurrenderRates = [[NSMutableArray alloc] init ];
    NSMutableArray *SurrenderValue = [[NSMutableArray alloc] init ];
    NSMutableArray *DBRates = [[NSMutableArray alloc] init ];
    NSMutableArray *DBValue = [[NSMutableArray alloc] init ];
    NSMutableArray *DBRatesEnd = [[NSMutableArray alloc] init ];
    NSMutableArray *DBValueEnd = [[NSMutableArray alloc] init ];
    NSMutableArray *aValue = [[NSMutableArray alloc] init ];
    NSMutableArray *aValueEnd = [[NSMutableArray alloc] init ];
    NSMutableArray *AnnualPremium = [[NSMutableArray alloc] init ];
    NSMutableArray *arrayYearlyIncome = [[NSMutableArray alloc] init ];
    NSMutableArray *TotalAllPremium = [[NSMutableArray alloc] init ];
    NSMutableArray *CurrentCashDividendRatesA = [[NSMutableArray alloc] init ];
    NSMutableArray *CurrentCashDividendValueA = [[NSMutableArray alloc] init ];
    NSMutableArray *CurrentCashDividendRatesB = [[NSMutableArray alloc] init ];
    NSMutableArray *CurrentCashDividendValueB = [[NSMutableArray alloc] init ];
    NSMutableArray *AccuCashDividendValueA = [[NSMutableArray alloc] init ];    
    NSMutableArray *AccuCashDividendValueB = [[NSMutableArray alloc] init ];
    NSMutableArray *AccuYearlyIncomeValueA = [[NSMutableArray alloc] init ];    
    NSMutableArray *AccuYearlyIncomeValueB = [[NSMutableArray alloc] init ];    
    NSMutableArray *tDividendRatesA = [[NSMutableArray alloc] init ];
    NSMutableArray *tDividendValueA = [[NSMutableArray alloc] init ];
    NSMutableArray *tDividendRatesB = [[NSMutableArray alloc] init ];
    NSMutableArray *tDividendValueB = [[NSMutableArray alloc] init ];
    NSMutableArray *speRatesA = [[NSMutableArray alloc] init ];
    NSMutableArray *speValueA = [[NSMutableArray alloc] init ];
    NSMutableArray *speRatesB = [[NSMutableArray alloc] init ];
    NSMutableArray *speValueB = [[NSMutableArray alloc] init ];
    NSMutableArray *TotalSurrenderValueA = [[NSMutableArray alloc] init ];
    NSMutableArray *TotalSurrenderValueB = [[NSMutableArray alloc] init ];
    NSMutableArray *TotalDBValueA = [[NSMutableArray alloc] init ];
    NSMutableArray *TotalDBValueB = [[NSMutableArray alloc] init ];
    
    NSLog(@"insert to SI_Temp_Trad_Basic --- start");
    
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        //------------------- GYI
        if(AdvanceYearlyIncome > 0){
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_GYI where advOption = \"%d\" "
                        " AND PremPayOpt = \"%d\" ", AdvanceYearlyIncome, PremiumPaymentOption];
            
        }
        else {
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_GYI where advOption = \"N\" "
                        " AND PremPayOpt = \"%d\" ", PremiumPaymentOption];
        }
            
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [rates addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //---------------- surrender value
        if(AdvanceYearlyIncome > 0){
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_CSV where advOption = \"%d\" "
                        " AND PremPayOpt = \"%d\" AND age = \"%d\" ", AdvanceYearlyIncome, PremiumPaymentOption, Age];
            
        }
        else {
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_CSV where advOption = \"N\" "
                        " AND PremPayOpt = \"%d\" AND age = \"%d\" ", PremiumPaymentOption, Age];
        }
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [SurrenderRates addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        
        //------------------------ DB start of the year
        if(AdvanceYearlyIncome > 0){
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_DB where advOption = \"%d\" "
                        " AND PremPayOpt = \"%d\" AND age = \"%d\" ", AdvanceYearlyIncome, PremiumPaymentOption, Age];
            
        }
        else {
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_DB where advOption = \"N\" "
                        " AND PremPayOpt = \"%d\" AND age = \"%d\" ", PremiumPaymentOption, Age];
        }
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [DBRates addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //--------------------------- DB end of the year
        if(AdvanceYearlyIncome > 0){
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_DB where advOption = \"%d\" "
                        " AND PremPayOpt = \"%d\" AND age = \"%d\" and PolYear > 1 ", AdvanceYearlyIncome, PremiumPaymentOption, Age];
            
        }
        else {
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_DB where advOption = \"N\" "
                        " AND PremPayOpt = \"%d\" AND age = \"%d\" and PolYear > 1 ", PremiumPaymentOption, Age];
        }
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [DBRatesEnd addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            
            NSString *zzz = [DBRatesEnd objectAtIndex:DBRatesEnd.count - 1];
            [DBRatesEnd addObject:zzz];
            sqlite3_finalize(statement);
        }
        //------------------------------------- cash dividend high
        if(AdvanceYearlyIncome > 0){
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_CD where advOption = \"%d\" "
                        " AND PremPayOpt = \"%d\" AND fromAge = \"%d\" AND Type = \"H\" ", AdvanceYearlyIncome, PremiumPaymentOption, Age];
            
        }
        else {
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_CD where advOption = \"N\" "
                        " AND PremPayOpt = \"%d\" AND fromAge = \"%d\" AND Type = \"H\" ", PremiumPaymentOption, Age];
        }
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [CurrentCashDividendRatesA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //--------------------------------  cash dividend low
        if(AdvanceYearlyIncome > 0){
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_CD where advOption = \"%d\" "
                        " AND PremPayOpt = \"%d\" AND fromAge = \"%d\" AND Type = \"L\" ", AdvanceYearlyIncome, PremiumPaymentOption, Age];
            
        }
        else {
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_CD where advOption = \"N\" "
                        " AND PremPayOpt = \"%d\" AND fromAge = \"%d\" AND Type = \"L\" ", PremiumPaymentOption, Age];
        }
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [CurrentCashDividendRatesB addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //--------------------------------  t Dividen payable on surrender high
        if(AdvanceYearlyIncome > 0){
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_TD where advOption = \"%d\" "
                        " AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"H\" ", AdvanceYearlyIncome, PremiumPaymentOption, Age];
            
        }
        else {
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_TD where advOption = \"N\" "
                        " AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"H\" ", PremiumPaymentOption, Age];
        }
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [tDividendRatesA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //--------------------------------  t Dividen payable on surrender low
        if(AdvanceYearlyIncome > 0){
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_TD where advOption = \"%d\" "
                        " AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"L\" ", AdvanceYearlyIncome, PremiumPaymentOption, Age];
            
        }
        else {
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_TD where advOption = \"N\" "
                        " AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"L\" ", PremiumPaymentOption, Age];
        }
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [tDividendRatesB addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //--------------------------------  high
        if(AdvanceYearlyIncome > 0){
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_speTD where advOption = \"%d\" "
                        " AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"H\" ", AdvanceYearlyIncome, PremiumPaymentOption, Age];
            
        }
        else {
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_speTD where advOption = \"N\" "
                        " AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"H\" ", PremiumPaymentOption, Age];
        }
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [speRatesA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //--------------------------------  low
        if(AdvanceYearlyIncome > 0){
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_speTD where advOption = \"%d\" "
                        " AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"L\" ", AdvanceYearlyIncome, PremiumPaymentOption, Age];
            
        }
        else {
            QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Basic_speTD where advOption = \"N\" "
                        " AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"L\" ", PremiumPaymentOption, Age];
        }
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [speRatesB addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    
    
    
    
    for (int i =1; i <= PolicyTerm; i++) {
        
        if (i <= PremiumPaymentOption) {
            [AnnualPremium addObject:strBasicAnnually ];
        }
        else {
            [AnnualPremium addObject:@"0.00"];
        }
        
        BasicTotalPremiumPaid = BasicTotalPremiumPaid + 
        [[[AnnualPremium objectAtIndex:i-1 ] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
        
        EntireTotalPremiumPaid = EntireTotalPremiumPaid + 
        [[[AnnualPremium objectAtIndex:i-1 ] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
        
        
        if(AdvanceYearlyIncome > 0){
            if (i + Age < AdvanceYearlyIncome) {
                [arrayYearlyIncome addObject:[NSString stringWithFormat:@"%d.00", BasicSA * ([[rates objectAtIndex:0] intValue] / 100)]];
            }
            else if (i + Age == AdvanceYearlyIncome) {
                
                [arrayYearlyIncome addObject:[NSString stringWithFormat:@"%.2f#", BasicSA * ([[rates objectAtIndex:1] doubleValue] / 100) ]];
            }
            else   {
                [arrayYearlyIncome addObject:@"0.00"];
            }
        }
        else {
            [arrayYearlyIncome addObject:[NSString stringWithFormat:@"%d", BasicSA]];
        }
        
        BasicTotalYearlyIncome = BasicTotalYearlyIncome + [[arrayYearlyIncome objectAtIndex:i -1] doubleValue ]; 
        EntireTotalYearlyIncome = EntireTotalYearlyIncome + [[arrayYearlyIncome objectAtIndex: i-1] doubleValue ];
        
        [SummaryGuaranteedTotalGYI addObject:[[arrayYearlyIncome objectAtIndex:i-1] stringByReplacingOccurrencesOfString:@"#" withString:@"" ]];
        [SurrenderValue addObject:[NSString stringWithFormat:@"%.9f", [[SurrenderRates objectAtIndex:i-1] doubleValue ] * BasicSA/1000 ]];
        [SummaryGuaranteedSurrenderValue addObject:[SurrenderValue objectAtIndex:i-1]];
        [DBValue addObject:[NSString stringWithFormat:@"%.0f", BasicSA * [[DBRates objectAtIndex:i-1] doubleValue ]/100 ]];
        [DBValueEnd addObject:[NSString stringWithFormat:@"%.3f", BasicSA * [[DBRatesEnd objectAtIndex:i-1] doubleValue ]/100 ]];
        [SummaryGuaranteedDBValueA addObject:[DBValue objectAtIndex:i-1]];
        [SummaryGuaranteedDBValueB addObject:[DBValueEnd objectAtIndex:i-1]];    
        
        //------------------------
        int TPDThresholdBEGYr;
        int TotalAD;
        if (i+ Age - 1 <= 6) {
            TPDThresholdBEGYr = 100000;
        }
        else if (i + Age - 1 <= 14) {
            TPDThresholdBEGYr = 500000; 
        }
        else if (i + Age - 1 <= 64) {
            TPDThresholdBEGYr = 3500000; 
        }
        else if (i + Age - 1 > 64) {
            TPDThresholdBEGYr = 0; 
        }
        
        if (i + Age <= 65 && [[DBValue objectAtIndex:i - 1] intValue] * 4 > TPDThresholdBEGYr ) {
            TotalAD = TPDThresholdBEGYr  - [[DBValue objectAtIndex:i - 1] intValue];
        }
        
        else if (i + Age <= 65 && [[DBValue objectAtIndex:i - 1] intValue] * 4 <= TPDThresholdBEGYr ) {
            TotalAD = [[DBValue objectAtIndex:i - 1] intValue] * 3;
        }
        else if (i + Age > 65) {
            TotalAD = 0;
        }
        
        if (TotalAD < 0) {
            TotalAD = 0;
        }
        [aValue addObject: [NSString stringWithFormat:@"%d", TotalAD] ];
        [SummaryGuaranteedAddValue addObject:[aValue objectAtIndex:i-1]];
        //-----------------------------------
        
        //------------------------
        int TPDThresholdEndYr;
        int TotalADEnd;
        if (i+ Age  <= 6) {
            TPDThresholdEndYr = 100000;
        }
        else if (i + Age <= 14) {
            TPDThresholdEndYr = 500000; 
        }
        else if (i + Age <= 64) {
            TPDThresholdEndYr = 3500000; 
        }
        else if (i + Age  > 64) {
            TPDThresholdEndYr = 0; 
        }
        
        if (i + Age <= 64 && [[DBValueEnd objectAtIndex:i - 1] intValue] * 4 > TPDThresholdEndYr ) {
            TotalADEnd = TPDThresholdEndYr  - [[DBValueEnd objectAtIndex:i - 1] intValue];
        }
        
        else if (i + Age <= 64 && [[DBValueEnd objectAtIndex:i - 1] intValue] * 4 <= TPDThresholdEndYr ) {
            TotalADEnd = [[DBValueEnd objectAtIndex:i - 1] intValue] * 3;
        }
        else if (i + Age > 64) {
            TotalADEnd = 0;
        }
        
        if (TotalADEnd < 0) {
            TotalADEnd = 0;
        }
        [aValueEnd addObject: [NSString stringWithFormat:@"%d", TotalADEnd] ];
        [SummaryGuaranteedAddEndValue addObject:[aValueEnd objectAtIndex:i-1]];
        
        //-----------------------------------
        
        //---------------- total premium paid ----------
        
        double sumBasic = 0;
        double sumIncomeRider = 0, sumOtherRider = 0;
        if (i <= PremiumPaymentOption) {
            sumBasic = [[strBasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@""  ] intValue ];
        }
        
        for (int j =0; j<IncomeRiderCode.count; j++) {
            if ( i <= [[IncomeRiderTerm objectAtIndex:j] intValue ]   ) {
                sumIncomeRider = sumIncomeRider + 
                [[[aStrIncomeRiderAnnually objectAtIndex:j ] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];  
                
            }
        }
        
        for (int j =0; j<OtherRiderCode.count; j++) {
            if ( i <= [[OtherRiderTerm objectAtIndex:j] intValue ]   ) {
                sumOtherRider = sumOtherRider +
                [[[aStrOtherRiderAnnually objectAtIndex:j ] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];  
            }
        }
        
        double TotalBasicAndRider = sumBasic + sumIncomeRider + sumOtherRider;
        [TotalAllPremium addObject: [NSString stringWithFormat:@"%.2f", TotalBasicAndRider ]];
        
        
        //----------------- total premium paid end ----------
        
        //------------- current cash dividend
        [CurrentCashDividendValueA addObject: [NSString stringWithFormat: @"%.8f", 
                                               BasicSA * [[CurrentCashDividendRatesA objectAtIndex: i - 1] doubleValue ] / 100 ]];
        [CurrentCashDividendValueB addObject: [NSString stringWithFormat: @"%.9f", 
                                                BasicSA * [[CurrentCashDividendRatesB objectAtIndex: i - 1] doubleValue ] / 100 ]];
        
        
        //----------- current cash dividend end ----------
        
        
        //------ accu cash dividend
        if ([CashDividend isEqualToString:@"ACC"]) {
            double CDInterestRateHigh = 0.055;
            double CDInterestRateLow = 0.035;
            
            if (i == 1) {
                [AccuCashDividendValueA addObject:[CurrentCashDividendValueA objectAtIndex:i -1 ]];
                [AccuCashDividendValueB addObject:[CurrentCashDividendValueB objectAtIndex:i-1]];
            }
            else {
                [AccuCashDividendValueA addObject: [NSString stringWithFormat: @"%.8f", 
                                                     [[AccuCashDividendValueA objectAtIndex:i-2] doubleValue ] * (1.00 + CDInterestRateHigh) + 
                                                    [[CurrentCashDividendValueA objectAtIndex:i-1] doubleValue ] ] ];
                [AccuCashDividendValueB addObject: [NSString stringWithFormat: @"%.9f", 
                                                     [[AccuCashDividendValueB objectAtIndex:i-2] doubleValue ] * (1.00 + CDInterestRateLow) + 
                                                          [[CurrentCashDividendValueB objectAtIndex:i-1] doubleValue ] ] ];

            }
            
            
        }
        else {
            [AccuCashDividendValueA addObject:@"-"];
            [AccuCashDividendValueB addObject:@"-"];
        }
        
        [SummaryNonGuaranteedAccuCashDividendA addObject:[AccuCashDividendValueA objectAtIndex:i-1]];
        [SummaryNonGuaranteedAccuCashDividendB addObject:[AccuCashDividendValueB objectAtIndex:i-1]]; 
        
        //------- accucash dividend end --------
        
        //------ accu yearly income ------
        if ([YearlyIncome isEqualToString:@"ACC"]) {
            double CDInterestRateHigh = 0.055;
            double CDInterestRateLow = 0.035;
            
            if (AdvanceYearlyIncome > 0 && i + Age >= AdvanceYearlyIncome) {
                
                [AccuYearlyIncomeValueA addObject:[NSString stringWithFormat:@"%.8f", 
                                    [[AccuYearlyIncomeValueA objectAtIndex:i-2] doubleValue] * (1 + CDInterestRateHigh) ] ];
                [AccuYearlyIncomeValueB addObject:[NSString stringWithFormat:@"%.9f", 
                                    [[AccuYearlyIncomeValueB objectAtIndex:i-2] doubleValue] * (1 + CDInterestRateLow) ] ];
                
            }
            else {
                if (i == 1) {
                    [AccuYearlyIncomeValueA addObject:[arrayYearlyIncome objectAtIndex:i -1]];
                    [AccuYearlyIncomeValueB addObject:[arrayYearlyIncome objectAtIndex:i -1]];
                }
                else {
                    [AccuYearlyIncomeValueA addObject:[NSString stringWithFormat:@"%.8f", 
                                    [[AccuYearlyIncomeValueA objectAtIndex:i-2] doubleValue] * (1.00 + CDInterestRateHigh) 
                                    + [[arrayYearlyIncome objectAtIndex:i -1] doubleValue ] ] ];
                    [AccuYearlyIncomeValueB addObject:[NSString stringWithFormat:@"%.9f", 
                                    [[AccuYearlyIncomeValueB objectAtIndex:i-2] doubleValue] * (1.00 + CDInterestRateLow) 
                                    + [[arrayYearlyIncome objectAtIndex:i -1] doubleValue ] ] ];
                    
                }
            }
            
        }
        else {
            [AccuYearlyIncomeValueA addObject:@"-"];
            [AccuYearlyIncomeValueB addObject:@"-"];
        }
        
        [SummaryNonGuaranteedAccuYearlyIncomeA addObject:[AccuYearlyIncomeValueA objectAtIndex:i-1]];
        [SummaryNonGuaranteedAccuYearlyIncomeB addObject:[AccuYearlyIncomeValueB objectAtIndex:i-1]]; 
        
        //------ accu yearly income end ------
        
        //------------- t dividend payable on surrender
        [tDividendValueA addObject: [NSString stringWithFormat: @"%.8f", 
                                               BasicSA * [[tDividendRatesA objectAtIndex: i - 1] doubleValue ] / 100.00 ]];
        [tDividendValueB addObject: [NSString stringWithFormat: @"%.9f", 
                                               BasicSA * [[tDividendRatesB objectAtIndex: i - 1] doubleValue ] / 100.00 ]];
        
        
        //----------- t dividend payable on surrender end ----------
        
        //-------------  spe TD
        [speValueA addObject: [NSString stringWithFormat: @"%.2f", 
                                     BasicSA * [[speRatesA objectAtIndex: i - 1] doubleValue ] / 100 ]];
        [speValueB addObject: [NSString stringWithFormat: @"%.2f", 
                                     BasicSA * [[speRatesB objectAtIndex: i - 1] doubleValue ] / 100 ]];
        
        
        //----------- spe TD end ----------
     
        //----------- total surrender value ----------
        double dTotalSurrenderValueA = 0.00;
        double dTotalSurrenderValueB = 0.00;
        
        if ([YearlyIncome isEqualToString:@"ACC"] && [CashDividend isEqualToString:@"ACC"] ) {
            dTotalSurrenderValueA = [[SurrenderValue objectAtIndex:i-1] doubleValue ] + 
                                     [[AccuCashDividendValueA objectAtIndex:i-1] doubleValue ] +
                                    [[AccuYearlyIncomeValueA objectAtIndex:i - 1] doubleValue ] +
                                    [[tDividendValueA objectAtIndex:i - 1 ] doubleValue ];
            
            dTotalSurrenderValueB = [[SurrenderValue objectAtIndex:i-1] doubleValue ] + 
            [[AccuCashDividendValueB objectAtIndex:i-1] doubleValue ] +
            [[AccuYearlyIncomeValueB objectAtIndex:i - 1] doubleValue ] +
            [[tDividendValueB objectAtIndex:i - 1 ] doubleValue ];
        }
        else if ([YearlyIncome isEqualToString:@"ACC"] && ![CashDividend isEqualToString:@"ACC"]) {
            dTotalSurrenderValueA = [[SurrenderValue objectAtIndex:i-1] doubleValue ] + 
            [[AccuYearlyIncomeValueA objectAtIndex:i - 1] doubleValue ] +
            [[tDividendValueA objectAtIndex:i - 1 ] doubleValue ];
            
            dTotalSurrenderValueB = [[SurrenderValue objectAtIndex:i-1] doubleValue ] + 
            [[AccuYearlyIncomeValueB objectAtIndex:i - 1] doubleValue ] +
            [[tDividendValueB objectAtIndex:i - 1 ] doubleValue ];
        }
        else if (![YearlyIncome isEqualToString:@"ACC"] && [CashDividend isEqualToString:@"ACC"]) {
            dTotalSurrenderValueA = [[SurrenderValue objectAtIndex:i-1] doubleValue ] + 
             [[AccuCashDividendValueA objectAtIndex:i-1] doubleValue ] +
            [[tDividendValueA objectAtIndex:i - 1 ] doubleValue ];
            
            dTotalSurrenderValueB = [[SurrenderValue objectAtIndex:i-1] doubleValue ] + 
             [[AccuCashDividendValueB objectAtIndex:i-1] doubleValue ] +
            [[tDividendValueB objectAtIndex:i - 1 ] doubleValue ];
        }    
        else {
            dTotalSurrenderValueA = [[SurrenderValue objectAtIndex:i-1] doubleValue ] + 
            [[tDividendValueA objectAtIndex:i - 1 ] doubleValue ];
            
            dTotalSurrenderValueB = [[SurrenderValue objectAtIndex:i-1] doubleValue ] + 
            [[tDividendValueB objectAtIndex:i - 1 ] doubleValue ];
        }
        
        [TotalSurrenderValueA addObject: [NSString stringWithFormat:@"%.8f", dTotalSurrenderValueA ]];
        [TotalSurrenderValueB addObject: [NSString stringWithFormat:@"%.9f", dTotalSurrenderValueB ]]; 
        
        [SummaryNonGuaranteedSurrenderValueA addObject:[TotalSurrenderValueA objectAtIndex:i-1]];
        [SummaryNonGuaranteedSurrenderValueB addObject:[TotalSurrenderValueB objectAtIndex:i-1]]; 
        
        
        if (i == PolicyTerm) {
            BasicMaturityValueA = [[SummaryNonGuaranteedSurrenderValueA objectAtIndex:PolicyTerm - 1] doubleValue ];
            BasicMaturityValueB = [[SummaryNonGuaranteedSurrenderValueB objectAtIndex:PolicyTerm - 1] doubleValue ];
            
            if (IncomeRiderCode.count == 0) {
                EntireMaturityValueA = BasicMaturityValueA;
                EntireMaturityValueB = BasicMaturityValueB;
            }
        }
        
        //------------ total surrender value end ------
        
        //----------- total DB value ----------
        double dTotalDBValueA = 0;
        double dTotalDBValueB = 0;
        
        if ([YearlyIncome isEqualToString:@"ACC"] && [CashDividend isEqualToString:@"ACC"] ) {
            dTotalDBValueA = [[DBValueEnd objectAtIndex:i-1] doubleValue ] + 
            [[AccuCashDividendValueA objectAtIndex:i-1] doubleValue ] +
            [[AccuYearlyIncomeValueA objectAtIndex:i - 1] doubleValue ] +
            [[speValueA objectAtIndex:i - 1 ] doubleValue ];
            
            dTotalDBValueB = [[DBValueEnd objectAtIndex:i-1] doubleValue ] + 
            [[AccuCashDividendValueB objectAtIndex:i-1] doubleValue ] +
            [[AccuYearlyIncomeValueB objectAtIndex:i - 1] doubleValue ] +
            [[speValueB objectAtIndex:i - 1 ] doubleValue ];
            
        }
        else if ([YearlyIncome isEqualToString:@"ACC"] && ![CashDividend isEqualToString:@"ACC"]) {
            dTotalDBValueA = [[DBValueEnd objectAtIndex:i-1] doubleValue ] + 
            [[AccuYearlyIncomeValueA objectAtIndex:i - 1] doubleValue ] +
            [[speValueA objectAtIndex:i - 1 ] doubleValue ];
            
            dTotalDBValueB = [[DBValueEnd objectAtIndex:i-1] doubleValue ] + 
            [[AccuYearlyIncomeValueB objectAtIndex:i - 1] doubleValue ] +
            [[speValueB objectAtIndex:i - 1 ] doubleValue ];
            
        }
        else if (![YearlyIncome isEqualToString:@"ACC"] && [CashDividend isEqualToString:@"ACC"]) {
            dTotalDBValueA = [[DBValueEnd objectAtIndex:i-1] doubleValue ] + 
            [[AccuCashDividendValueA objectAtIndex:i-1] doubleValue ] +
            [[speValueA objectAtIndex:i - 1 ] doubleValue ];
            
            dTotalDBValueB = [[DBValueEnd objectAtIndex:i-1] doubleValue ] + 
            [[AccuCashDividendValueB objectAtIndex:i-1] doubleValue ] +
            [[speValueB objectAtIndex:i - 1 ] doubleValue ];
            
        }    
        else {
            dTotalDBValueA = [[DBValueEnd objectAtIndex:i-1] doubleValue ] + 
            [[speValueA objectAtIndex:i - 1 ] doubleValue ];
            
            dTotalDBValueB = [[DBValueEnd objectAtIndex:i-1] doubleValue ] + 
            [[speValueB objectAtIndex:i - 1 ] doubleValue ];
            
        }
        
        [TotalDBValueA addObject: [NSString stringWithFormat:@"%.3f", dTotalDBValueA ]];
        [TotalDBValueB addObject: [NSString stringWithFormat:@"%.3f", dTotalDBValueB ]];        
        
        [SummaryNonGuaranteedDBValueA addObject:[TotalDBValueA objectAtIndex:i-1]];
        [SummaryNonGuaranteedDBValueB addObject:[TotalDBValueB objectAtIndex:i-1]]; 
        
        //------------ total DB value end ------
        
    }

    
    for (int a= 1; a<=PolicyTerm; a++) {
        
        if (a <= 20 || (a > 20 && a % 5  == 0) || (a == PolicyTerm && a%5 != 0) ) {
        
            if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
            if (Age >= 0){
            
                inputAge = Age + a;
                
                /*
                QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Basic (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                            "\"col14\",\"col15\",\"col16\",\"col17\",\"col18\",\"col19\",\"col20\",\"col21\",\"col22\") VALUES ( "
                            " \"%@\",\"%d\",\"DATA\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\", "
                            "\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\")", 
                            SINo, a, a, inputAge, [AnnualPremium objectAtIndex:a -1],[arrayYearlyIncome objectAtIndex:a-1], [SurrenderValue objectAtIndex:a-1],
                            [DBValue objectAtIndex:a-1],[DBValueEnd objectAtIndex:a-1],[aValue objectAtIndex:a-1 ],
                            [aValueEnd objectAtIndex:a-1],arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,
                            arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,
                            arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,
                            arc4random()%10000 + 1000 ];
                */
                
                NSString *strAccuCDA = @""; 
                NSString *strAccuCDB = @"";
                NSString *strAccuYIA = @"";
                NSString *strAccuYIB = @"";
                
                if ([CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"]) {
                    strAccuCDA = [NSString stringWithFormat:@"%.0f", round( [[AccuCashDividendValueA objectAtIndex:a-1] doubleValue ])];
                    strAccuCDB = [NSString stringWithFormat:@"%.0f", round( [[AccuCashDividendValueB objectAtIndex:a-1] doubleValue ])];
                    strAccuYIA = [NSString stringWithFormat:@"%.0f", round( [[AccuYearlyIncomeValueA objectAtIndex:a-1] doubleValue ])];
                    strAccuYIB = [NSString stringWithFormat:@"%.0f", round( [[AccuYearlyIncomeValueB objectAtIndex:a-1] doubleValue ])];
                }
                else if ([CashDividend isEqualToString:@"ACC"] && ![YearlyIncome isEqualToString:@"ACC"]) {
                    strAccuCDA = [NSString stringWithFormat:@"%.0f", round( [[AccuCashDividendValueA objectAtIndex:a-1] doubleValue ])];
                    strAccuCDB = [NSString stringWithFormat:@"%.0f", round( [[AccuCashDividendValueB objectAtIndex:a-1] doubleValue ])];
                    strAccuYIA = [NSString stringWithFormat:@"-"];
                    strAccuYIB = [NSString stringWithFormat:@"-"];
                }    
                else if (![CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"]) {
                    strAccuCDA = [NSString stringWithFormat:@"-"];
                    strAccuCDB = [NSString stringWithFormat:@"-"];
                    strAccuYIA = [NSString stringWithFormat:@"%.0f", round( [[AccuYearlyIncomeValueA objectAtIndex:a-1] doubleValue ])];
                    strAccuYIB = [NSString stringWithFormat:@"%.0f", round( [[AccuYearlyIncomeValueB objectAtIndex:a-1] doubleValue ])];
                }        
                else if (![CashDividend isEqualToString:@"ACC"] && ![YearlyIncome isEqualToString:@"ACC"]) {
                    strAccuCDA = [NSString stringWithFormat:@"-"];
                    strAccuCDB = [NSString stringWithFormat:@"-"];
                    strAccuYIA = [NSString stringWithFormat:@"-"];
                    strAccuYIB = [NSString stringWithFormat:@"-"];
                }        
                
                QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Basic (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                            "\"col14\",\"col15\",\"col16\",\"col17\",\"col18\",\"col19\",\"col20\",\"col21\",\"col22\") VALUES ( "
                            " \"%@\",\"%d\",\"DATA\",\"%d\",\"%d\",\"%@\",\"%@\",\"%.0f\",\"%@\",\"%.0f\",\"%@\",\"%@\",\"%.0f\",\"%.0f\",\"%.0f\", "
                            "\"%.0f\",\"%@\",\"%.0f\",\"%.0f\",\"%@\",\"%@\",\"%@\",\"%@\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\")", 
                            SINo, a, a, inputAge, [AnnualPremium objectAtIndex:a -1],[arrayYearlyIncome objectAtIndex:a-1], round([[SurrenderValue objectAtIndex:a-1] doubleValue ]),
                            [DBValue objectAtIndex:a-1], round([[DBValueEnd objectAtIndex:a-1] doubleValue ]),
                            [aValue objectAtIndex:a-1 ], [aValueEnd objectAtIndex:a-1],
                            round([[TotalSurrenderValueA objectAtIndex:a-1 ] doubleValue ]), round([[TotalSurrenderValueB objectAtIndex:a-1] doubleValue ]),
                            round( [[TotalDBValueA objectAtIndex:a-1 ] doubleValue ]), round( [[TotalDBValueB objectAtIndex:a-1 ] doubleValue ]),
                            [TotalAllPremium objectAtIndex:a-1],
                             round( [[CurrentCashDividendValueA objectAtIndex:a-1] doubleValue ]), round( [[CurrentCashDividendValueB objectAtIndex:a-1] doubleValue ]),
                            strAccuCDA, strAccuCDB,
                             strAccuYIA, strAccuYIB,
                            round([[tDividendValueA objectAtIndex:a-1] doubleValue ]), round([[tDividendValueB objectAtIndex:a-1 ] doubleValue ]),
                            round([[speValueA objectAtIndex:a-1] doubleValue ]), round( [[speValueB objectAtIndex:a-1] doubleValue]) ];
                
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                    }
                    sqlite3_finalize(statement); 
                }
            }
            sqlite3_close(contactDB);
        }
            
        }
    } 
    
    NSLog(@"insert to SI_Temp_Trad_Basic --- End");
    
}

-(void)InsertToSI_Temp_Trad_Overall{
    
    NSLog(@"insert to SI_Temp_Trad_Overall --- start");
    
    
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                
            QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Overall (\"SINO\", \"SurrenderValueHigh1\", "
                        " \"SurrenderValueLow1\",\"TotPremPaid1\",\"TotYearlyIncome1\", "
                        " \"SurrenderValuehigh2\",\"SurrenderValueLow2\",\"TotPremPaid2\",\"TotYearlyIncome2\") VALUES ( "
                        " \"%@\",\"%.8f\",\"%.9f\",\"%.2f\",\"%.2f\",\"%.8f\",\"%.9f\",\"%.2f\",\"%.2f\")", 
                            SINo, EntireMaturityValueA, EntireMaturityValueB, EntireTotalPremiumPaid,
                        EntireTotalYearlyIncome,BasicMaturityValueA,BasicMaturityValueB,BasicTotalPremiumPaid,BasicTotalYearlyIncome];
                
            
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                    }
                    sqlite3_finalize(statement); 
                }
            
            sqlite3_close(contactDB);
        }
    NSLog(@"insert to SI_Temp_Trad_Overall --- End");
    
}

-(void)InsertToSI_Temp_Trad_Summary{
    
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    sqlite3_stmt *statement2;
    NSString *QuerySQL2;
    NSMutableArray *TotalIBPlusIR = [[NSMutableArray alloc] init ];
    NSMutableArray *arrayYearlyIncome = [[NSMutableArray alloc] init ];
    NSMutableArray *aValue = [[NSMutableArray alloc] init ];
    NSMutableArray *aValueEnd = [[NSMutableArray alloc] init ];
    

       
    NSLog(@"insert to SI_Temp_Trad_Summary --- start");
    
    int inputAge;
    double IncomeRiderPlusIncomeBuilder;
    
    if (aStrIncomeRiderAnnually.count >0) {
        IncomeRiderPlusIncomeBuilder =  [[strBasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
          //      + [[[aStrIncomeRiderAnnually objectAtIndex:0 ] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
        
        for (int i=0; i < aStrIncomeRiderAnnually.count; i++) {
            IncomeRiderPlusIncomeBuilder = IncomeRiderPlusIncomeBuilder +  
            [[[aStrIncomeRiderAnnually objectAtIndex:i ] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
            
            /*
            EntireTotalPremiumPaid = EntireTotalPremiumPaid + 
            [[[aStrIncomeRiderAnnually objectAtIndex:i ] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
            */
        }
        
    }
    
    else {
        IncomeRiderPlusIncomeBuilder =  [[strBasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    }
    /*
    if (aStrOtherRiderAnnually.count > 0) {
        for (int i=0; i < aStrOtherRiderAnnually.count; i++) {
            
            //for entire calculation for other rider
            EntireTotalPremiumPaid = EntireTotalPremiumPaid + 
            [[[aStrOtherRiderAnnually objectAtIndex:i ] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
            
        }
    }
    */
    double GYI;
    if (IncomeRiderCode.count > 0) {
      GYI =[[IncomeRiderSA objectAtIndex:0] doubleValue ] + BasicSA ;   
    }
    else {
        GYI = BasicSA;
    }
        
    for (int i =1; i <=PolicyTerm; i++) {
        if (i <= PremiumPaymentOption) {
            [TotalIBPlusIR addObject:[NSString stringWithFormat:@"%.2f", IncomeRiderPlusIncomeBuilder] ];
        }
        else {
            [TotalIBPlusIR addObject:@"0.00"];
        }
        
        if(AdvanceYearlyIncome > 0){
            if (i + Age < AdvanceYearlyIncome) {
                [arrayYearlyIncome addObject:[NSString stringWithFormat:@"%.2f", GYI]];
                
            }
            else if (i + Age == AdvanceYearlyIncome) {
                [arrayYearlyIncome addObject:[NSString stringWithFormat:@"9500.00#"]];
            }
            else {
                [arrayYearlyIncome addObject:@"0.00"];
            }
        }   
        else {
            [arrayYearlyIncome addObject:[NSString stringWithFormat:@"%.2f", GYI]];
        }
        
        // --------------- AD
        double TPDThresholdBEGYr;
        double TotalAD;
        if (i+ Age - 1 <= 6) {
            TPDThresholdBEGYr = 100000;
        }
        else if (i + Age - 1 <= 14) {
            TPDThresholdBEGYr = 500000; 
        }
        else if (i + Age - 1 <= 64) {
            TPDThresholdBEGYr = 3500000; 
        }
        else if (i + Age - 1 > 64) {
            TPDThresholdBEGYr = 0; 
        }
        
        if (i + Age <= 65 && [[SummaryGuaranteedDBValueA objectAtIndex:i - 1] doubleValue] * 4 > TPDThresholdBEGYr ) {
            TotalAD = TPDThresholdBEGYr  - [[SummaryGuaranteedDBValueA objectAtIndex:i - 1] doubleValue];
        }
        
        else if (i + Age <= 65 && [[SummaryGuaranteedDBValueA objectAtIndex:i - 1] doubleValue] * 4 <= TPDThresholdBEGYr ) {
            TotalAD = [[SummaryGuaranteedAddValue objectAtIndex:i - 1] doubleValue];
        }
        else if (i + Age > 65) {
            TotalAD = 0;
        }
        
        if (TotalAD < 0) {
            TotalAD = 0;
        }
        
        [aValue addObject: [NSString stringWithFormat:@"%.3f", TotalAD] ];
        
       // ----------- AD end
        double TPDThresholdEndYr;
        double TotalADEnd;
        if (i+ Age  <= 6) {
            TPDThresholdEndYr = 100000;
        }
        else if (i + Age <= 14) {
            TPDThresholdEndYr = 500000; 
        }
        else if (i + Age <= 64) {
            TPDThresholdEndYr = 3500000; 
        }
        else if (i + Age  > 64) {
            TPDThresholdEndYr = 0; 
        }
        
        if (i + Age <= 64 && [[SummaryGuaranteedDBValueB objectAtIndex:i - 1] doubleValue] * 4 > TPDThresholdEndYr ) {
            TotalADEnd = TPDThresholdEndYr  - [[SummaryGuaranteedDBValueB objectAtIndex:i - 1] doubleValue];
        }
        
        else if (i + Age <= 64 && [[SummaryGuaranteedDBValueB objectAtIndex:i - 1] doubleValue] * 4 <= TPDThresholdEndYr ) {
            TotalADEnd = [[SummaryGuaranteedAddEndValue objectAtIndex:i - 1] doubleValue ];
        }
        else if (i + Age > 64) {
            TotalADEnd = 0;
        }
        
        if (TotalADEnd < 0) {
            TotalADEnd = 0;
        }
        [aValueEnd addObject: [NSString stringWithFormat:@"%.3f", TotalADEnd] ];
        
        
    }
    
    for (int a= 1; a<=PolicyTerm; a++) {
        
        if (a <= 20 || (a > 20 && a % 5  == 0) || (a == PolicyTerm && a%5 != 0) ) {
        
            if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                
                inputAge = Age + a;
                
                QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Summary (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                            "\"col14\",\"col15\",\"col16\",\"col17\") VALUES ( "
                            " \"%@\",\"%d\",\"DATA\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", "
                            "\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\")", SINo, a, a, inputAge, arc4random()%10000+1000,@"0",@"0",@"",@"",@"",@""
                            ,@"",@"",@"",@"",@"",@"",@"",arc4random()%10000+1000,BasicSA,0 ];
                
            //NSLog(@"%@", QuerySQL);
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        if ([CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"] ) {
                            QuerySQL2 = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Summary (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                                         "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                                         "\"col14\",\"col15\",\"col16\",\"col17\") VALUES ( "
                                         " \"%@\",\"%d\",\"DATA2\",\"%d\",\"%d\",\"%@\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\", "
                                         "\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%@\",\"%@\")", SINo, a, a, inputAge,
                                         [TotalIBPlusIR objectAtIndex:a - 1],
                                         round( [[SummaryGuaranteedTotalGYI objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryGuaranteedSurrenderValue objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryGuaranteedDBValueA objectAtIndex:a-1] doubleValue]),round([[SummaryGuaranteedDBValueB objectAtIndex:a-1] doubleValue]),
                                         round([[aValue objectAtIndex:a-1] doubleValue]),round([[aValueEnd objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryNonGuaranteedAccuYearlyIncomeA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedAccuYearlyIncomeB objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryNonGuaranteedAccuCashDividendA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedAccuCashDividendB objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryNonGuaranteedSurrenderValueA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedSurrenderValueB objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryNonGuaranteedDBValueA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedDBValueB objectAtIndex:a-1] doubleValue]),
                                         @"",@"-" ];
                            
                        }
                        else if([CashDividend isEqualToString:@"ACC"] && ![YearlyIncome isEqualToString:@"ACC"]) {
                            QuerySQL2 = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Summary (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                                         "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                                         "\"col14\",\"col15\",\"col16\",\"col17\") VALUES ( "
                                         " \"%@\",\"%d\",\"DATA2\",\"%d\",\"%d\",\"%@\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%@\",\"%@\",\"%.0f\", "
                                         "\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%@\",\"%@\")", SINo, a, a, inputAge,
                                         [TotalIBPlusIR objectAtIndex:a - 1],
                                         round( [[SummaryGuaranteedTotalGYI objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryGuaranteedSurrenderValue objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryGuaranteedDBValueA objectAtIndex:a-1] doubleValue]),round([[SummaryGuaranteedDBValueB objectAtIndex:a-1] doubleValue]),
                                         round([[aValue objectAtIndex:a-1] doubleValue]),round([[aValueEnd objectAtIndex:a-1] doubleValue]),
                                         @"-",@"-",
                                         round([[SummaryNonGuaranteedAccuCashDividendA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedAccuCashDividendB objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryNonGuaranteedSurrenderValueA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedSurrenderValueB objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryNonGuaranteedDBValueA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedDBValueB objectAtIndex:a-1] doubleValue]),
                                         @"",@"-" ];
                        }
                        else if(![CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"]) {
                            QuerySQL2 = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Summary (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                                         "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                                         "\"col14\",\"col15\",\"col16\",\"col17\") VALUES ( "
                                         " \"%@\",\"%d\",\"DATA2\",\"%d\",\"%d\",\"%@\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%@\", "
                                         "\"%@\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%@\",\"%@\")", SINo, a, a, inputAge,
                                         [TotalIBPlusIR objectAtIndex:a - 1],
                                         round( [[SummaryGuaranteedTotalGYI objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryGuaranteedSurrenderValue objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryGuaranteedDBValueA objectAtIndex:a-1] doubleValue]),round([[SummaryGuaranteedDBValueB objectAtIndex:a-1] doubleValue]),
                                         round([[aValue objectAtIndex:a-1] doubleValue]),round([[aValueEnd objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryNonGuaranteedAccuYearlyIncomeA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedAccuYearlyIncomeB objectAtIndex:a-1] doubleValue]),
                                         @"-",@"-",
                                         round([[SummaryNonGuaranteedSurrenderValueA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedSurrenderValueB objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryNonGuaranteedDBValueA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedDBValueB objectAtIndex:a-1] doubleValue]),
                                         @"",@"-" ];
                        }
                        else {
                            QuerySQL2 = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Summary (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                                         "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                                         "\"col14\",\"col15\",\"col16\",\"col17\") VALUES ( "
                                         " \"%@\",\"%d\",\"DATA2\",\"%d\",\"%d\",\"%@\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%@\",\"%@\",\"%@\", "
                                         "\"%@\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%@\",\"%@\")", SINo, a, a, inputAge,
                                         [TotalIBPlusIR objectAtIndex:a - 1],
                                         round( [[SummaryGuaranteedTotalGYI objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryGuaranteedSurrenderValue objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryGuaranteedDBValueA objectAtIndex:a-1] doubleValue]),round([[SummaryGuaranteedDBValueB objectAtIndex:a-1] doubleValue]),
                                         round([[aValue objectAtIndex:a-1] doubleValue]),round([[aValueEnd objectAtIndex:a-1] doubleValue]),
                                         @"-",@"-",
                                         @"-",@"-",
                                         round([[SummaryNonGuaranteedSurrenderValueA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedSurrenderValueB objectAtIndex:a-1] doubleValue]),
                                         round([[SummaryNonGuaranteedDBValueA objectAtIndex:a-1] doubleValue]),round([[SummaryNonGuaranteedDBValueB objectAtIndex:a-1] doubleValue]),
                                         @"",@"-" ];
                        }
                        
                        if(sqlite3_prepare_v2(contactDB, [QuerySQL2 UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                            if (sqlite3_step(statement2) == SQLITE_DONE) {
                            
                            }
                            
                        sqlite3_finalize(statement2);
                        }
                    }
                    sqlite3_finalize(statement); 
                }
            
            sqlite3_close(contactDB);
        }
        }
    } 
    
    NSLog(@"insert to SI_Temp_Trad_Summary --- End");
    
}

-(void)InsertToSI_Temp_Trad_Rider{
    
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    NSMutableArray *TotalRiderSurrenderValue = [[NSMutableArray alloc] init ];
    
    NSLog(@"insert to SI_Temp_Trad_Rider --- start");
    
    
    if (OtherRiderCode.count > 0) {
    
        for (int x = 0; x < PolicyTerm; x++) {
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
                    double tempPremium = [[aStrOtherRiderAnnually objectAtIndex:item] doubleValue ];
                    NSMutableArray *tempCol1 = [[NSMutableArray alloc] init ];
                    NSMutableArray *tempCol2 = [[NSMutableArray alloc] init ];
                    NSMutableArray *tempCol3 = [[NSMutableArray alloc] init ];
                    NSMutableArray *tempCol4 = [[NSMutableArray alloc] init ];
                    
                    
                        for (int row = 0; row < 3; row++) {
                            
                            
                                if (row == 0) {
                                    [tempCol1 addObject:tempRiderDesc ];
                                    [tempCol2 addObject:@"" ];
                                    [tempCol3 addObject:@"" ];
                                    [tempCol4 addObject:@"" ];
                                    
                                }
                                
                                if (row == 1) {
                                    if ([tempRiderCode isEqualToString:@"CCTR"]) {
                                        [tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
                                        [tempCol2 addObject:@"Surrender Value" ];
                                        [tempCol3 addObject:@"Death/TPD Benefit" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"CIWP"] || [tempRiderCode isEqualToString:@"SP_PRE"] || [tempRiderCode isEqualToString:@"SP_STD"] ||
                                             [tempRiderCode isEqualToString:@"PR"] || [tempRiderCode isEqualToString:@"LCWP"]) {
                                        [tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
                                        [tempCol2 addObject:@"Sum Assured" ];
                                        [tempCol3 addObject:@"-" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"PTR"]) {
                                        [tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
                                        [tempCol2 addObject:@"Surrender Value" ];
                                        [tempCol3 addObject:@"Death/TPD Benefit" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"LPPR"]) {
                                        [tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
                                        [tempCol2 addObject:@"Surrender Value" ];
                                        [tempCol3 addObject:@"Death/TPD Benefit" ];
                                        [tempCol4 addObject:@"Guaranteed Cash Payment" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"CPA"] || [tempRiderCode isEqualToString:@"PA"] ) {
                                        [tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
                                        [tempCol2 addObject:@"Accidental Death/TPD Benefit" ];
                                        [tempCol3 addObject:@"-" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"CIR"] || [tempRiderCode isEqualToString:@"ACIR"] || [tempRiderCode isEqualToString:@"ACIR_WL"] ||
                                             [tempRiderCode isEqualToString:@"ACIR_MPP"] || [tempRiderCode isEqualToString:@"ACIR_TWD"] || [tempRiderCode isEqualToString:@"ACIR_TWP"] ||
                                             [tempRiderCode isEqualToString:@"ACIR_EXC"]) {
                                        
                                        [tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
                                        [tempCol2 addObject:@"Critical illness Benefit" ];
                                        [tempCol3 addObject:@"-" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"LCPR"] || [tempRiderCode isEqualToString:@"PLCP"] ) {
                                        [tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
                                        [tempCol2 addObject:@"Surrender Value" ];
                                        [tempCol3 addObject:@"Death/TPD Benefit" ];
                                        [tempCol4 addObject:@"Critical Illness Benefit" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"C+"] ) {
                                        [tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
                                        [tempCol2 addObject:@"Sum Assured" ];
                                        [tempCol3 addObject:@"Guaranteed Surrender Value(if no claim admitted)" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"HPP"] || [tempRiderCode isEqualToString:@"HPPP"] ) {
                                        [tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
                                        [tempCol2 addObject:@"Sum Assured" ];
                                        [tempCol3 addObject:@"Guaranteed Surrender Value" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    else {
                                        [tempCol1 addObject:@"Annual Premium (Beg. of Year)" ];
                                        [tempCol2 addObject:@"-" ];
                                        [tempCol3 addObject:@"-" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                } 
                                
                                if (row == 2) {
                                    if ([tempRiderCode isEqualToString:@"CCTR"]) {
                                        [tempCol1 addObject:@"Premium Tahunan (Permulaan Tahun)" ];
                                        [tempCol2 addObject:@"Nilai Penyerahan" ];
                                        [tempCol3 addObject:@"Faedah kematian/TPD" ];
                                        [tempCol4 addObject:@"-" ];
                                    }    
                                    
                                    else if ([tempRiderCode isEqualToString:@"CIWP"] || [tempRiderCode isEqualToString:@"SP_PRE"] || [tempRiderCode isEqualToString:@"SP_STD"] ||
                                             [tempRiderCode isEqualToString:@"PR"] || [tempRiderCode isEqualToString:@"LCWP"]) {
                                        [tempCol1 addObject:@"Premium Tahunan (Permulaan Tahun)" ];
                                        [tempCol2 addObject:@"Jumlah Diinsuranskan" ];
                                        [tempCol3 addObject:@"-" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"PTR"]) {
                                        [tempCol1 addObject:@"Premium Tahunan (Permulaan Tahun)" ];
                                        [tempCol2 addObject:@"Nilai Penyerahan" ];
                                        [tempCol3 addObject:@"Faedah kematian/TPD" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"LPPR"]) {
                                        [tempCol1 addObject:@"Premium Tahunan (Permulaan Tahun)" ];
                                        [tempCol2 addObject:@"Nilai Penyerahan" ];
                                        [tempCol3 addObject:@"Faedah kematian/TPD" ];
                                        [tempCol4 addObject:@"Cash Payment Terjamin" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"CPA"] || [tempRiderCode isEqualToString:@"PA"] ) {
                                        [tempCol1 addObject:@"Premium Tahunan (Permulaan Tahun)" ];
                                        [tempCol2 addObject:@"Faedah Kematian kemalangan/TPD" ];
                                        [tempCol3 addObject:@"-" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"CIR"] || [tempRiderCode isEqualToString:@"ACIR"] || [tempRiderCode isEqualToString:@"ACIR_WL"] ||
                                             [tempRiderCode isEqualToString:@"ACIR_MPP"] || [tempRiderCode isEqualToString:@"ACIR_TWD"] || [tempRiderCode isEqualToString:@"ACIR_TWP"] ||
                                             [tempRiderCode isEqualToString:@"ACIR_EXC"]) {
                                        
                                        [tempCol1 addObject:@"Premium Tahunan (Permulaan Tahun)" ];
                                        [tempCol2 addObject:@"Faedah Penyakit Kritikal" ];
                                        [tempCol3 addObject:@"-" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"LCPR"] || [tempRiderCode isEqualToString:@"PLCP"] ) {
                                        [tempCol1 addObject:@"Premium Tahunan (Permulaan Tahun)" ];
                                        [tempCol2 addObject:@"Nilai Penyerahan" ];
                                        [tempCol3 addObject:@"Faedah kematian/TPD" ];
                                        [tempCol4 addObject:@"Faedah Penyakit Kritikal" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"C+"] ) {
                                        [tempCol1 addObject:@"Premium Tahunan (Permulaan Tahun)" ];
                                        [tempCol2 addObject:@"Jumlah Diinsuranskan" ];
                                        [tempCol3 addObject:@"Nilai Penyerahan Terjamin(jika tiada tuntutan)" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    
                                    else if ([tempRiderCode isEqualToString:@"HPP"] || [tempRiderCode isEqualToString:@"HPPP"] ) {
                                        [tempCol1 addObject:@"Premium Tahunan (Permulaan Tahun)" ];
                                        [tempCol2 addObject:@"Jumlah Diinsuranskan" ];
                                        [tempCol3 addObject:@"Nilai Penyerahan Terjamin" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                    else {
                                        [tempCol1 addObject:@"Premium Tahunan (Permulaan Tahun)" ];
                                        [tempCol2 addObject:@"-" ];
                                        [tempCol3 addObject:@"-" ];
                                        [tempCol4 addObject:@"-" ];
                                    }
                                }
                                
                            
                        }
                        
                        double CPlusSA = 0.00;
                        double tempTotalRiderSurrenderValue = 0.00;
                    
                        NSMutableArray *Rate = [[NSMutableArray alloc] init ];
                    
                        for (int i = 0; i < PolicyTerm; i++) {
                            
                            if (i < tempRiderTerm) {
                                
                                if ([tempRiderCode isEqualToString:@"CCTR"]) {
                                    
                                    if (i == 0) {
                                        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                                            QuerySQL = [NSString stringWithFormat:@"Select rate from Trad_Sys_Rider_CSV Where plancode = \"%@\" AND Age = \"%d\" AND Term = \"%d\""
                                                        , tempRiderCode, Age, tempRiderTerm ];
                                            
                                            
                                            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                                while (sqlite3_step(statement) == SQLITE_ROW) {
                                                    [Rate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]]; 
                                                    
                                                }
                                                sqlite3_finalize(statement);
                                            }
                                            sqlite3_close(contactDB);
                                        }    
                                        
                                        if (Rate.count < PolicyTerm) {
                                            
                                            int rowsToAdd = PolicyTerm - Rate.count;
                                            for (int u =0; u<rowsToAdd; u++) {
                                                [Rate addObject:@"0.00"];
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"%.2f", tempPremium]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"%.3f", [[Rate objectAtIndex:i ]doubleValue ] * tempRiderSA/1000.00   ]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"%.0f", tempRiderSA]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                    
                                    tempTotalRiderSurrenderValue = [[TotalRiderSurrenderValue objectAtIndex:i] doubleValue ];
                                    tempTotalRiderSurrenderValue = tempTotalRiderSurrenderValue + [[tempCol2 objectAtIndex:i] doubleValue ];
                                    [TotalRiderSurrenderValue replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.3f", tempTotalRiderSurrenderValue]];
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"CIWP"] || [tempRiderCode isEqualToString:@"SP_PRE"] || [tempRiderCode isEqualToString:@"SP_STD"] ||
                                         [tempRiderCode isEqualToString:@"PR"] || [tempRiderCode isEqualToString:@"LCWP"]) {
                                    
                                    //waiver SA
                                    
                                    double waiverRiderSA;
                                    double waiverRiderSASemiAnnual;
                                    double waiverRiderSAQuarterly;
                                    double waiverRiderSAMonthly;
                                    
                                    waiverRiderSA = [[strBasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
                                    waiverRiderSASemiAnnual = [[strBasicSemiAnnually stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
                                    waiverRiderSAQuarterly = [[strBasicQuarterly stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
                                    waiverRiderSAMonthly = [[strBasicMonthly stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
                                    
                                    for (int g=0; g < IncomeRiderCode.count; g++) {
                                        
                                        waiverRiderSA = waiverRiderSA + 
                                        [[[aStrIncomeRiderAnnually objectAtIndex:g] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
                                        waiverRiderSASemiAnnual = waiverRiderSASemiAnnual + 
                                        [[[aStrIncomeRiderSemiAnnually objectAtIndex:g] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
                                        waiverRiderSAQuarterly = waiverRiderSAQuarterly + 
                                        [[[aStrIncomeRiderQuarterly objectAtIndex:g] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
                                        waiverRiderSAMonthly = waiverRiderSAMonthly + 
                                        [[[aStrIncomeRiderMonthly objectAtIndex:g] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
                                    }
                                    
                                    if ([tempRiderCode isEqualToString:@"CIWP"]) {
                                    
                                        for (int q=0; q < OtherRiderCode.count; q++) {
                                            if (!([[OtherRiderCode objectAtIndex:q ] isEqualToString:@"LCPR"] || 
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"CIR"]  ||
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"PR"] ||
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"LCWP"] || 
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"SP_STD"] || 
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"SP_PRE"] || 
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"CIWP"] ||
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"ICR"] ||
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"ACIR_TW"] ||
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"ACIR_TWP"] ||
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"ACIR_EXC"] ||
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"ACIR_MPP"])) {
                                                waiverRiderSA = waiverRiderSA + 
                                                [[[aStrOtherRiderAnnually objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];   
                                                waiverRiderSASemiAnnual = waiverRiderSASemiAnnual + 
                                                [[[aStrOtherRiderSemiAnnually objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];   
                                                waiverRiderSAQuarterly = waiverRiderSAQuarterly + 
                                                [[[aStrOtherRiderQuarterly objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];   
                                                waiverRiderSAMonthly = waiverRiderSAMonthly + 
                                                [[[aStrOtherRiderMonthly objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];   
                                                
                                            }
                                        }
                                    }
                                    else {
                                        for (int q=0; q < OtherRiderCode.count; q++) {
                                            if (!([[OtherRiderCode objectAtIndex:q ] isEqualToString:@"PLCP"] || 
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"PR"] ||
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"LCWP"] || 
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"SP_STD"] || 
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"SP_PRE"] || 
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"CIWP"] ||
                                                  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"PTR"])) {
                                                waiverRiderSA = waiverRiderSA + 
                                                [[[aStrOtherRiderAnnually objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];   
                                                waiverRiderSASemiAnnual = waiverRiderSASemiAnnual + 
                                                [[[aStrOtherRiderSemiAnnually objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];   
                                                waiverRiderSAQuarterly = waiverRiderSAQuarterly + 
                                                [[[aStrOtherRiderQuarterly objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];   
                                                waiverRiderSAMonthly = waiverRiderSAMonthly + 
                                                [[[aStrOtherRiderMonthly objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];   
                                                
                                            }
                                        }    
                                    }
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"%.2f", tempPremium]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"%.3f", waiverRiderSA *  tempRiderSA/100]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"-"]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                    
                                    /*
                                    CIWPAnnual = waiverRiderSA *  tempRiderSA/100.00;
                                    CIWPSemiAnnual = waiverRiderSASemiAnnual *  tempRiderSA/100.00;
                                    CIWPQuarterly = waiverRiderSAQuarterly *  tempRiderSA/100.00;
                                    CIWPMonthly = waiverRiderSAMonthly *  tempRiderSA/100.00;
                                     */
                                    if (i == 1) {
                                        [gWaiverAnnual addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSA *  tempRiderSA/100.00] ];
                                        [gWaiverSemiAnnual addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSASemiAnnual *  tempRiderSA/100.00] ];
                                        [gWaiverQuarterly addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSAQuarterly *  tempRiderSA/100.00] ];
                                        [gWaiverMonthly addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSAMonthly *  tempRiderSA/100.00] ];
                                        
                                    }
                                    

                                    
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"PTR"]) {
                                    
                                    if (i == 0) {
                                        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                                            QuerySQL = [NSString stringWithFormat:@"Select rate from Trad_Sys_Rider_CSV Where plancode = \"%@\" AND Age = \"%d\" AND Term = \"%d\""
                                                        , tempRiderCode, Age, tempRiderTerm ];
                                            
                                            
                                            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                                while (sqlite3_step(statement) == SQLITE_ROW) {
                                                    [Rate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]]; 
                                                    
                                                }
                                                sqlite3_finalize(statement);
                                            }
                                            sqlite3_close(contactDB);
                                        }    
                                        
                                        if (Rate.count < PolicyTerm) {
                                            
                                            int rowsToAdd = PolicyTerm - Rate.count;
                                            for (int u =0; u<rowsToAdd; u++) {
                                                [Rate addObject:@"0.00"];
                                            }
                                        }
                                    }
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"%.2f", tempPremium]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"%.3f", [[Rate objectAtIndex:i ]doubleValue ] * tempRiderSA/1000.00   ]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"%.0f", tempRiderSA]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                    
                                    tempTotalRiderSurrenderValue = [[TotalRiderSurrenderValue objectAtIndex:i] doubleValue ];
                                    tempTotalRiderSurrenderValue = tempTotalRiderSurrenderValue + [[tempCol2 objectAtIndex:i] doubleValue ];
                                    [TotalRiderSurrenderValue replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.3f", tempTotalRiderSurrenderValue]];
                                    
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"LPPR"]) {
                                    
                                    if (i == 0) {
                                        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                                            QuerySQL = [NSString stringWithFormat:@"Select rate from Trad_Sys_Rider_CSV Where plancode = \"%@\" AND Age = \"%d\" AND Term = \"%d\""
                                                        , tempRiderCode, Age, tempRiderTerm ];
                                            
                                            
                                            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                                while (sqlite3_step(statement) == SQLITE_ROW) {
                                                    [Rate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]]; 
                                                    
                                                }
                                                sqlite3_finalize(statement);
                                            }
                                            sqlite3_close(contactDB);
                                        }    
                                        
                                        if (Rate.count < PolicyTerm) {
                                            
                                            int rowsToAdd = PolicyTerm - Rate.count;
                                            for (int u =0; u<rowsToAdd; u++) {
                                                [Rate addObject:@"0.00"];
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"%.2f", tempPremium]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"%.3f", [[Rate objectAtIndex:i ]doubleValue ] * tempRiderSA/1000.00   ]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"%.0f", [[Rate objectAtIndex:i ]doubleValue ] * tempRiderSA/1000.00   ]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"%.0f", tempRiderSA]];
                                    
                                    tempTotalRiderSurrenderValue = [[TotalRiderSurrenderValue objectAtIndex:i] doubleValue ];
                                    tempTotalRiderSurrenderValue = tempTotalRiderSurrenderValue + [[tempCol2 objectAtIndex:i] doubleValue ];
                                    [TotalRiderSurrenderValue replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.3f", tempTotalRiderSurrenderValue]];
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"CPA"] || [tempRiderCode isEqualToString:@"PA"]) {
                                    
                                    
                                    
                                    
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"%.2f", tempPremium]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"%0ff", tempRiderSA]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"-"]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"CIR"] || [tempRiderCode isEqualToString:@"ACIR"] || [tempRiderCode isEqualToString:@"ACIR_WL"] ||
                                         [tempRiderCode isEqualToString:@"ACIR_MPP"] || [tempRiderCode isEqualToString:@"ACIR_TWD"] || [tempRiderCode isEqualToString:@"ACIR_TWP"] ||
                                         [tempRiderCode isEqualToString:@"ACIR_EXC"]) {
                                    
                                    double CI;
                                    double juv; 
                                    
                                    if (Age + i < 2) {
                                        juv = 0.2;
                                    }
                                    else if (Age + i == 2) {
                                        juv = 0.4;
                                    }
                                    else if (Age + i == 3) {
                                        juv = 0.6;
                                    }
                                    else if (Age + i == 4) {
                                        juv = 0.8;
                                    }
                                    else {
                                        juv = 1.0;
                                    }
                                    
                                    if ([tempRiderCode isEqualToString:@"CIR"] || 
                                        [tempRiderCode isEqualToString:@"ACIR"]) {
                                        CI = tempRiderSA;
                                    }
                                    else if ([tempRiderCode isEqualToString:@"ACIR_TWD"] || [tempRiderCode isEqualToString:@"ACIR_TWP"]) {
                                        if (i > 20 && Age + i > 55) {
                                            CI = tempRiderSA * 0.5;
                                        }
                                        else {
                                            CI = tempRiderSA;
                                        }
                                    }
                                    else if ([tempRiderCode isEqualToString:@"ACIR_EXC"]) {
                                        if (Age <= 40 && Age + i <=60) {
                                            CI = tempRiderSA * juv;
                                        }
                                        else if (Age <= 40 && Age + i > 60) {
                                            CI = 2/3 * tempRiderSA * juv;
                                        }
                                        else if (Age > 40 && i <= 20) {
                                            CI = tempRiderSA * juv;
                                        }
                                        else if (Age > 40 && i > 20) {
                                            CI = 2/3 * tempRiderSA * juv;
                                        }
                                    }
                                    else if ([tempRiderCode isEqualToString:@"ACIR_MPP"]) {
                                            CI = tempRiderSA * juv;
                                        
                                    }
                                    
                                    
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"%.2f", tempPremium]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"%.2f", CI]];
                                    [tempCol3 addObject:@"-" ];
                                    [tempCol4 addObject:@"-" ];
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"LCPR"] || [tempRiderCode isEqualToString:@"PLCP"] ) {
                                    if (i == 0) {
                                        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                                            QuerySQL = [NSString stringWithFormat:@"Select rate from Trad_Sys_Rider_CSV Where plancode = \"%@\" AND Age = \"%d\" AND Term = \"%d\""
                                                        , tempRiderCode, Age, tempRiderTerm ];
                                            
                                            
                                            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                                while (sqlite3_step(statement) == SQLITE_ROW) {
                                                    [Rate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]]; 
                                                    
                                                }
                                                sqlite3_finalize(statement);
                                            }
                                            sqlite3_close(contactDB);
                                        }    
                                        
                                        if (Rate.count < PolicyTerm) {
                                            
                                            int rowsToAdd = PolicyTerm - Rate.count;
                                            for (int u =0; u<rowsToAdd; u++) {
                                                [Rate addObject:@"0.00"];
                                            }
                                        }
                                    }
                                    
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"%.2f", tempPremium]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"%.3f", [[Rate objectAtIndex:i ]doubleValue ] * tempRiderSA/1000.00   ]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"%.2f", tempRiderSA] ];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"%.2f", tempRiderSA]];
                                    
                                    tempTotalRiderSurrenderValue = [[TotalRiderSurrenderValue objectAtIndex:i] doubleValue ];
                                    tempTotalRiderSurrenderValue = tempTotalRiderSurrenderValue + [[tempCol2 objectAtIndex:i] doubleValue ];
                                    [TotalRiderSurrenderValue replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.3f", tempTotalRiderSurrenderValue]];
                                }
                                else if ([tempRiderCode isEqualToString:@"C+"] ) {
                                    
                                    if (i == 0) { //execute only one time to get the rates and put in array
                                        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                                            NSString *strplanOption = @"";
                                            
                                            if ([tempRiderPlanOption isEqualToString:@"Increasing"]) {
                                                strplanOption = @"I";
                                            }
                                            else if ([tempRiderPlanOption isEqualToString:@"Increasing_NCB"]) {
                                                strplanOption = @"N";
                                            }
                                            else if ([tempRiderPlanOption isEqualToString:@"Level"]) {
                                                strplanOption = @"L";
                                            }
                                            else if ([tempRiderPlanOption isEqualToString:@"Level_NCB"]) {
                                                strplanOption = @"B";
                                            }
                                            
                                            QuerySQL = [NSString stringWithFormat:@"Select Rate from Trad_Sys_Rider_CSV Where plancode = \"%@\" AND "
                                                        " Age = \"%d\" AND Term = \"%d\" AND Sex = \"%@\" AND planOption = \"%@\""
                                                        , tempRiderCode, Age, tempRiderTerm, sex, strplanOption ];
                                            
                                            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                                while  (sqlite3_step(statement) == SQLITE_ROW) {
                                                    [Rate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]]; 
                                                    
                                                }
                                                sqlite3_finalize(statement);
                                            }
                                            sqlite3_close(contactDB);
                                        }
                                        
                                        
                                        if (Rate.count < PolicyTerm) {
                                            
                                            int rowsToAdd = PolicyTerm - Rate.count;
                                            for (int u =0; u<rowsToAdd; u++) {
                                                [Rate addObject:@"0.00"];
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                    
                                    
                                    if ([tempRiderPlanOption isEqualToString:@"Increasing"] || [tempRiderPlanOption isEqualToString:@"Increasing_NCB"]  ) {
                                        
                                        if (i < 20) {
                                            if (i == 0) {
                                                CPlusSA = tempRiderSA;
                                            }
                                            else if (i%2 == 1) {
                                                CPlusSA = CPlusSA + (tempRiderSA * 0.1); 
                                            }
                                            else {
                                                CPlusSA = CPlusSA;
                                            }
                                        }
                                        else {
                                            CPlusSA = 0.00;
                                        }
                                    }
                                    else {
                                        if ([tempRiderPlanOption isEqualToString:@"Level"] || [tempRiderPlanOption isEqualToString:@"Level_NCB"]  ) {
                                            CPlusSA = tempRiderSA;
                                        }
                                    }
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"%.2f", tempPremium]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"%.2f", CPlusSA] ];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"%.3f", [[Rate objectAtIndex:i ]doubleValue ] * tempRiderSA/1000.00   ]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                    /*
                                    tempTotalRiderSurrenderValue = [[TotalRiderSurrenderValue objectAtIndex:i] doubleValue ];
                                    tempTotalRiderSurrenderValue = tempTotalRiderSurrenderValue + [[tempCol3 objectAtIndex:i] doubleValue ];
                                    [TotalRiderSurrenderValue replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.3f", tempTotalRiderSurrenderValue]];
                                    */
                                }
                                else if ([tempRiderCode isEqualToString:@"HPP"] || [tempRiderCode isEqualToString:@"HPPP"] ) {
                                    
                                    
                                    if (i == 0) {
                                        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                                            QuerySQL = [NSString stringWithFormat:@"Select rate from Trad_Sys_Rider_CSV Where plancode = \"%@\" AND Age = \"%d\" AND Term = \"%d\""
                                                        , tempRiderCode, Age, tempRiderTerm ];
                                            
                                            
                                            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                                while (sqlite3_step(statement) == SQLITE_ROW) {
                                                    [Rate addObject: [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]]; 
                                                    
                                                }
                                                sqlite3_finalize(statement);
                                            }
                                            sqlite3_close(contactDB);
                                        }    
                                        
                                        if (Rate.count < PolicyTerm) {
                                            
                                            int rowsToAdd = PolicyTerm - Rate.count;
                                            for (int u =0; u<rowsToAdd; u++) {
                                                [Rate addObject:@"0.00"];
                                            }
                                        }
                                    }    
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"%.2f", tempPremium]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"%.2f", tempRiderSA] ];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"%.3f", [[Rate objectAtIndex:i ]doubleValue ] * tempRiderSA/1000.00   ]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                    
                                    tempTotalRiderSurrenderValue = [[TotalRiderSurrenderValue objectAtIndex:i] doubleValue ];
                                    tempTotalRiderSurrenderValue = tempTotalRiderSurrenderValue + [[tempCol3 objectAtIndex:i] doubleValue ];
                                    [TotalRiderSurrenderValue replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.3f", tempTotalRiderSurrenderValue]];
                                }
                                else {
                                    [tempCol1 addObject:[NSString stringWithFormat:@"%.2f", tempPremium]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"-"]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"-"]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                }
                            }
                            else {
                                if ([tempRiderCode isEqualToString:@"CCTR"]) {
                                    
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"0.00"]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"0"]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"0"]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"CIWP"] || [tempRiderCode isEqualToString:@"SP_PRE"] || [tempRiderCode isEqualToString:@"SP_STD"] ||
                                         [tempRiderCode isEqualToString:@"PR"] || [tempRiderCode isEqualToString:@"LCWP"]) {
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"0.00", tempPremium]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"0"]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"-"]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"PTR"]) {
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"0.00"]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"0"] ];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"0"]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"LPPR"]) {
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"0.00"]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"0"]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"0"]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"0"]];
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"CPA"] || [tempRiderCode isEqualToString:@"PA"]) {
                                    [tempCol1 addObject:[NSString stringWithFormat:@"0.00"]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"0"]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"-"]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"CIR"] || [tempRiderCode isEqualToString:@"ACIR"] || [tempRiderCode isEqualToString:@"ACIR_WL"] ||
                                         [tempRiderCode isEqualToString:@"ACIR_MPP"] || [tempRiderCode isEqualToString:@"ACIR_TWD"] || [tempRiderCode isEqualToString:@"ACIR_TWP"] ||
                                         [tempRiderCode isEqualToString:@"ACIR_EXC"]) {
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"0.00"]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"0.00"]];
                                    [tempCol3 addObject:@"-" ];
                                    [tempCol4 addObject:@"-" ];
                                }
                                
                                else if ([tempRiderCode isEqualToString:@"LCPR"] || [tempRiderCode isEqualToString:@"PLCP"] ) {
                                    [tempCol1 addObject:[NSString stringWithFormat:@"0.00"]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"0"]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"0"]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"0"]];
                                }
                                else if ([tempRiderCode isEqualToString:@"C+"] ) {
                                    
                                    
                                    [tempCol1 addObject:[NSString stringWithFormat:@"0.00"]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"0"]];
                                    [tempCol3 addObject:[NSString stringWithFormat:@"0"]];
                                    [tempCol4 addObject:[NSString stringWithFormat:@"-"]];
                                }
                                else if ([tempRiderCode isEqualToString:@"HPP"] || [tempRiderCode isEqualToString:@"HPPP"] ) {
                                    [tempCol1 addObject:[NSString stringWithFormat:@"0.00"]];
                                    [tempCol2 addObject:[NSString stringWithFormat:@"0"]];
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
                            
                            EntireTotalPremiumPaid = EntireTotalPremiumPaid + [[tempCol1 objectAtIndex:i] doubleValue ];
                            
                            
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
                    
                }
                else {
                    if (Rider == 1) {
                        for (int row = 0; row < PolicyTerm + 3; row++){
                            [RiderCol5 addObject:@"-"];
                            [RiderCol6 addObject:@"-"];
                            [RiderCol7 addObject:@"-"];
                            [RiderCol8 addObject:@"-"];
                        }
                    }
                    if (Rider == 2) {
                        for (int row = 0; row < PolicyTerm + 3; row++){
                            [RiderCol9 addObject:@"-"];
                            [RiderCol10 addObject:@"-"];
                            [RiderCol11 addObject:@"-"];
                            [RiderCol12 addObject:@"-"];
                        }
                    }
                }
            }
            
            if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                QuerySQL = [NSString stringWithFormat:@"Insert INTO SI_Temp_Trad_Rider(\"SINO\", \"SeqNo\", \"DataType\", \"PageNo\",\"col0_1\",\"col0_2\", "
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
                
                QuerySQL = [NSString stringWithFormat:@"Insert INTO SI_Temp_Trad_Rider(\"SINO\", \"SeqNo\", \"DataType\", \"PageNo\",\"col0_1\",\"col0_2\", "
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
                
                QuerySQL = [NSString stringWithFormat:@"Insert INTO SI_Temp_Trad_Rider(\"SINO\", \"SeqNo\", \"DataType\", \"PageNo\",\"col0_1\",\"col0_2\", "
                            " \"col1\",\"col2\",\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\" ) VALUES ("
                            " \"%@\", \"%d\", \"HEADER\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" "
                            " , \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" )", SINo, 0, page, @"Tahun Polisi", @"Umur Hayat Diinsuranskan pada Akhir Tahun",
                            [RiderCol1 objectAtIndex:2],[RiderCol2 objectAtIndex:2],
                            [RiderCol3 objectAtIndex:2],[RiderCol4 objectAtIndex:2],[RiderCol5 objectAtIndex:2],[RiderCol6 objectAtIndex:2],
                            [RiderCol7 objectAtIndex:2],[RiderCol8 objectAtIndex:2],[RiderCol9 objectAtIndex:2],[RiderCol10 objectAtIndex:2],
                            [RiderCol11 objectAtIndex:2],[RiderCol12 objectAtIndex:2]];
                
                
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                    }
                    sqlite3_finalize(statement);
                }
                
                sqlite3_close(contactDB);
            }        
            
            
            for (int j=1; j <= PolicyTerm; j++) {
                
                if (j <= 20 || (j > 20 && j % 5  == 0) || (j == PolicyTerm && j%5 != 0) ) {
                    int currentAge = Age + j;
                    
                    NSString *strSeqNo = @"";
                    if (j < 10) {
                        strSeqNo = [NSString stringWithFormat:@"0%d", j];    
                    }
                    else {
                        strSeqNo = [NSString stringWithFormat:@"%d", j];    
                    }
                    
                    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                    
                    NSString *value1 = [[RiderCol1 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.2f", [[RiderCol1 objectAtIndex:j + 2] doubleValue ]];
                    NSString *value2 = [[RiderCol2 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol2 objectAtIndex:j + 2] doubleValue ])];
                    NSString *value3 = [[RiderCol3 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol3 objectAtIndex:j + 2] doubleValue ])];
                    NSString *value4 = [[RiderCol4 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol4 objectAtIndex:j + 2] doubleValue ])];
                    NSString *value5 = [[RiderCol5 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.2f", [[RiderCol5 objectAtIndex:j + 2] doubleValue ]];
                    NSString *value6 = [[RiderCol6 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol6 objectAtIndex:j + 2] doubleValue ])];
                    NSString *value7 = [[RiderCol7 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol7 objectAtIndex:j + 2] doubleValue ])];
                    NSString *value8 = [[RiderCol8 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol8 objectAtIndex:j + 2] doubleValue ])];
                    NSString *value9 = [[RiderCol9 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.2f", [[RiderCol9 objectAtIndex:j + 2] doubleValue ]];
                    NSString *value10 = [[RiderCol10 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol10 objectAtIndex:j + 2] doubleValue ])];
                    NSString *value11 = [[RiderCol11 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol11 objectAtIndex:j + 2] doubleValue ])];
                    NSString *value12 = [[RiderCol12 objectAtIndex:j + 2] isEqualToString: @"-"] ? @"-" : [NSString stringWithFormat:@"%.0f", round([[RiderCol12 objectAtIndex:j + 2] doubleValue ])];
                    
                    
                    QuerySQL = [NSString stringWithFormat:@"Insert INTO SI_Temp_Trad_Rider(\"SINO\", \"SeqNo\", \"DataType\", \"PageNo\",\"col0_1\",\"col0_2\", "
                                " \"col1\",\"col2\",\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\" ) VALUES ("
                                " \"%@\", \"%@\", \"DATA\", \"%d\", \"%d\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" "
                                " , \"%@\", \"%@\", \"%@\", \"%@\", \"%@\" )", SINo, strSeqNo , page, j, currentAge, value1,value2,
                                value3,value4,value5,value6,value7, value8, value9, value10, value11, value12];
                    
                    
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        if (sqlite3_step(statement) == SQLITE_DONE) {
                            
                        }
                        sqlite3_finalize(statement);
                    }
                    sqlite3_close(contactDB);
                } 
                }
            }
           
            
        }
        
        //
        for (int v= 0; v < PolicyTerm; v ++) {
            double tempA;
            double tempB;
            tempA = [[SummaryNonGuaranteedSurrenderValueA objectAtIndex:v] doubleValue ];
            tempA = tempA + [[TotalRiderSurrenderValue objectAtIndex:v] doubleValue ];
            [SummaryNonGuaranteedSurrenderValueA replaceObjectAtIndex:v withObject: [NSString stringWithFormat:@"%.3f", tempA]];
            
            tempB = [[SummaryNonGuaranteedSurrenderValueB objectAtIndex:v] doubleValue ];
            tempB = tempB + [[TotalRiderSurrenderValue objectAtIndex:v] doubleValue ];
            [SummaryNonGuaranteedSurrenderValueB replaceObjectAtIndex:v withObject: [NSString stringWithFormat:@"%.3f", tempB]];
            
            //NSLog(@"%@", [TotalRiderSurrenderValue objectAtIndex:v]);
            
            if (v  == PolicyTerm - 1) {
               // EntireMaturityValueA = EntireMaturityValueA + [[SummaryNonGuaranteedSurrenderValueA objectAtIndex:v] doubleValue ];
               // EntireMaturityValueB = EntireMaturityValueB + [[SummaryNonGuaranteedSurrenderValueB objectAtIndex:v] doubleValue ];
            }
                
        }
    } 
    
    NSLog(@"insert to SI_Temp_Trad_Rider --- End");
    
      
}


-(void)InsertToSI_Temp_Trad_RideriLLus{
    
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    /*
    NSMutableArray *GlobalGYI = [[NSMutableArray alloc] init ];
    for (int p = 0; p < PolicyTerm ; p++) {
        [GlobalGYI addObject:@"temp" ];
    }
      */  

    NSLog(@"insert to SI_Temp_Trad_RideriLLus --- start");
    
    
    if (IncomeRiderCode.count > 0 ) {
        
        for (int i=0; i<IncomeRiderCode.count; i++) {
            
                NSMutableArray *AnnualPremium = [[NSMutableArray alloc] init ];
                NSMutableArray *YearlyIncomeEOF = [[NSMutableArray alloc] init ];
                NSMutableArray *SurrenderRates = [[NSMutableArray alloc] init ];
                NSMutableArray *SurrenderValue = [[NSMutableArray alloc] init ];
            NSMutableArray *DBRates = [[NSMutableArray alloc] init ];
            NSMutableArray *DBValue = [[NSMutableArray alloc] init ];
            NSMutableArray *DBRatesEnd = [[NSMutableArray alloc] init ];
            NSMutableArray *DBValueEnd = [[NSMutableArray alloc] init ];
            NSMutableArray *aValue = [[NSMutableArray alloc] init ];
            NSMutableArray *aValueEnd = [[NSMutableArray alloc] init ];
            NSMutableArray *CurrentCashDividendRatesA = [[NSMutableArray alloc] init ];
            NSMutableArray *CurrentCashDividendValueA = [[NSMutableArray alloc] init ];
            NSMutableArray *CurrentCashDividendRatesB = [[NSMutableArray alloc] init ];
            NSMutableArray *CurrentCashDividendValueB = [[NSMutableArray alloc] init ];
            NSMutableArray *AccuCashDividendValueA = [[NSMutableArray alloc] init ];    
            NSMutableArray *AccuCashDividendValueB = [[NSMutableArray alloc] init ];
            NSMutableArray *AccuYearlyIncomeValueA = [[NSMutableArray alloc] init ];    
            NSMutableArray *AccuYearlyIncomeValueB = [[NSMutableArray alloc] init ];    
            NSMutableArray *tDividendRatesA = [[NSMutableArray alloc] init ];
            NSMutableArray *tDividendValueA = [[NSMutableArray alloc] init ];
            NSMutableArray *tDividendRatesB = [[NSMutableArray alloc] init ];
            NSMutableArray *tDividendValueB = [[NSMutableArray alloc] init ];
            NSMutableArray *speRatesA = [[NSMutableArray alloc] init ];
            NSMutableArray *speValueA = [[NSMutableArray alloc] init ];
            NSMutableArray *speRatesB = [[NSMutableArray alloc] init ];
            NSMutableArray *speValueB = [[NSMutableArray alloc] init ];
            NSMutableArray *TotalSurrenderValueA = [[NSMutableArray alloc] init ];
            NSMutableArray *TotalSurrenderValueB = [[NSMutableArray alloc] init ];
            NSMutableArray *TotalDBValueA = [[NSMutableArray alloc] init ];
            NSMutableArray *TotalDBValueB = [[NSMutableArray alloc] init ];
            
            
                NSString *strIncRiderCode = [IncomeRiderCode objectAtIndex:i];
                double dRiderSA = [[IncomeRiderSA objectAtIndex:i] doubleValue ];
            int iTerm = [[IncomeRiderTerm objectAtIndex:i] intValue ];
            
                int inputAge = 0;
            
                
                if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                
                    //------- surrender value
                    QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Rider_CSV where  "
                                "plancode = \"%@\" AND PremPayOpt = \"%d\" AND Age = \"%d\" ORDER by polyear asc ", strIncRiderCode, PremiumPaymentOption, Age];
                    
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            [SurrenderRates addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                        }
                        sqlite3_finalize(statement);
                    }
                
                    //------- DB 
                    QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Rider_IBR_DB where  "
                                "plancode = \"%@\" AND PremPayOpt = \"%d\" AND Age = \"%d\" ORDER by polyear asc ", strIncRiderCode, PremiumPaymentOption, Age];
                    
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            [DBRates addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                        }
                        
                        sqlite3_finalize(statement);
                    }
                    
                    //------- DB End
                    QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Rider_IBR_DB where  "
                                "plancode = \"%@\" AND PremPayOpt = \"%d\" AND Age = \"%d\" And polyear > 1 ORDER by polyear asc ", strIncRiderCode, PremiumPaymentOption, Age];
                    
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            [DBRatesEnd addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                        }
                        [DBRatesEnd addObject:[DBRatesEnd objectAtIndex:DBRatesEnd.count - 1]];
                        sqlite3_finalize(statement);
                    }
                    
                    //-------  cash dividend high
                    QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Rider_IBR_CD where  "
                                "plancode = \"%@\" AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"H\" ORDER by polyear asc ", strIncRiderCode, PremiumPaymentOption, Age];
                    
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            [CurrentCashDividendRatesA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    //-------  cash dividend low
                    QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Rider_IBR_CD where  "
                                "plancode = \"%@\" AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"L\" ORDER by polyear asc ", strIncRiderCode, PremiumPaymentOption, Age];
                    
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            [CurrentCashDividendRatesB addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    //------TD high
                    QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Rider_IBR_TD where  "
                                "plancode = \"%@\" AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"H\" ORDER by polyear asc ", strIncRiderCode, PremiumPaymentOption, Age];
                    
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            [tDividendRatesA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                        }
                        sqlite3_finalize(statement);
                    }
                   
                    //------TD low
                    QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Rider_IBR_TD where  "
                                "plancode = \"%@\" AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"L\" ORDER by polyear asc ", strIncRiderCode, PremiumPaymentOption, Age];
                    
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            [tDividendRatesB addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    //------spe high
                    QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Rider_IBR_speTD where  "
                                "plancode = \"%@\" AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"H\" ORDER by polyear asc ", strIncRiderCode, PremiumPaymentOption, Age];
                    
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            [speRatesA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    //------spe low
                    QuerySQL = [NSString stringWithFormat: @"Select rate from trad_sys_Rider_IBR_speTD where  "
                                "plancode = \"%@\" AND PremPayOpt = \"%d\" AND Age = \"%d\" AND Type = \"L\" ORDER by polyear asc ", strIncRiderCode, PremiumPaymentOption, Age];
                    
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            [speRatesB addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    sqlite3_close(contactDB);
                }
            
                    
            
                for (int j =1; j <= [[IncomeRiderTerm objectAtIndex:i] intValue ]; j++) {
                    if (j <= PremiumPaymentOption ) {
                        [AnnualPremium addObject:[aStrIncomeRiderAnnually objectAtIndex:i ] ];
                    }
                    else {
                        [AnnualPremium addObject:@"0.00"];
                    }
                    
                    EntireTotalPremiumPaid = EntireTotalPremiumPaid +
                    [[[AnnualPremium objectAtIndex:j-1 ] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ]; 
                    
                    
                    // ----- GYI -----
                    double GYIRate;
                    if ([strIncRiderCode isEqualToString:@"ID20R"] ) {
                        if (j >= 21 && j < 91 ) {
                            GYIRate = 100.00;
                        }
                        else {
                            GYIRate = 0.00;
                        }
                    }
                    else if ([strIncRiderCode isEqualToString:@"ID30R"]) {
                        if (j >= 31 && j < 91 ) {
                            GYIRate = 100.00;
                        }
                        else {
                            GYIRate = 0.00;
                        }
                    }
                    else if ([strIncRiderCode isEqualToString:@"ID40R"]) {
                        if (j >= 41 && j < 91 ) {
                            GYIRate = 100.00;
                        }
                        else {
                            GYIRate = 0.00;
                        }
                    }
                    else {
                        GYIRate = 100.00;
                    }
                    
                    [YearlyIncomeEOF addObject:[NSString stringWithFormat:@"%.2f", GYIRate/100 * dRiderSA ]];
                    EntireTotalYearlyIncome = EntireTotalYearlyIncome + [[YearlyIncomeEOF objectAtIndex:j-1 ] doubleValue ];
                    
                    //-----Surrender Value -------
                    [SurrenderValue addObject: [NSString stringWithFormat:@"%.9f", 
                                                [[SurrenderRates objectAtIndex:j-1] doubleValue ] * dRiderSA/1000.00 ]];
                    
                    
                    //----- DB    ----------------
                    [DBValue addObject:[NSString stringWithFormat:@"%.3f", [[DBRates objectAtIndex:j-1] doubleValue]/100 * dRiderSA ]];
                    
                    //----- DB End    ----------------
                    [DBValueEnd addObject:[NSString stringWithFormat:@"%.3f", [[DBRatesEnd objectAtIndex:j-1] doubleValue]/100 * dRiderSA ]];
                 
                    // ---- AD --------
                    int TPDThresholdBEGYr;
                    int TotalAD;
                    if (j+ Age - 1 <= 6) {
                        TPDThresholdBEGYr = 100000;
                    }
                    else if (j + Age - 1 <= 14) {
                        TPDThresholdBEGYr = 500000; 
                    }
                    else if (j + Age - 1 <= 64) {
                        TPDThresholdBEGYr = 3500000; 
                    }
                    else if (j + Age - 1 > 64) {
                        TPDThresholdBEGYr = 0; 
                    }
                    
                    if (j + Age <= 65 && [[DBValue objectAtIndex:j - 1] intValue] * 4 > TPDThresholdBEGYr ) {
                        TotalAD = TPDThresholdBEGYr  - [[DBValue objectAtIndex:j - 1] intValue];
                    }
                    
                    else if (j + Age <= 65 && [[DBValue objectAtIndex:j - 1] intValue] * 4 <= TPDThresholdBEGYr ) {
                        TotalAD = [[DBValue objectAtIndex:j - 1] intValue] * 3;
                    }
                    else if (j + Age > 65) {
                        TotalAD = 0;
                    }
                    
                    if (TotalAD < 0) {
                        TotalAD = 0;
                    }
                    [aValue addObject: [NSString stringWithFormat:@"%d", TotalAD] ];
                    
                    // ----------- AD end of year ------
                    int TPDThresholdEndYr;
                    int TotalADEnd;
                    if (j+ Age  <= 6) {
                        TPDThresholdEndYr = 100000;
                    }
                    else if (j + Age <= 14) {
                        TPDThresholdEndYr = 500000; 
                    }
                    else if (j + Age <= 64) {
                        TPDThresholdEndYr = 3500000; 
                    }
                    else if (j + Age  > 64) {
                        TPDThresholdEndYr = 0; 
                    }
                    
                    if (j + Age <= 64 && [[DBValueEnd objectAtIndex:j - 1] intValue] * 4 > TPDThresholdEndYr ) {
                        TotalADEnd = TPDThresholdEndYr  - [[DBValueEnd objectAtIndex:j - 1] intValue];
                    }
                    
                    else if (j + Age <= 64 && [[DBValueEnd objectAtIndex:j - 1] intValue] * 4 <= TPDThresholdEndYr ) {
                        TotalADEnd = [[DBValueEnd objectAtIndex:j - 1] intValue] * 3;
                    }
                    else if (j + Age > 64) {
                        TotalADEnd = 0;
                    }
                    
                    if (TotalADEnd < 0) {
                        TotalADEnd = 0;
                    }
                    [aValueEnd addObject: [NSString stringWithFormat:@"%d", TotalADEnd] ];
                    
                    //------ current year dividend
                    [CurrentCashDividendValueA addObject:[NSString stringWithFormat:@"%.8f", 
                                                          [[CurrentCashDividendRatesA objectAtIndex:j-1] doubleValue ]/100.00 * dRiderSA ]];    
                    [CurrentCashDividendValueB addObject:[NSString stringWithFormat:@"%.9f", 
                                                          [[CurrentCashDividendRatesB objectAtIndex:j-1] doubleValue ]/100.00 * dRiderSA ]];    
                    // --- accu cash dividend
                    if ([CashDividend isEqualToString:@"ACC"]) {
                        
                        if (j > iTerm) {
                            [AccuCashDividendValueA addObject: [NSString stringWithFormat:@"%.8f",  
                                                                [[AccuCashDividendValueA objectAtIndex:j - 2] doubleValue ] * (1 + 0.055) ]];
                            [AccuCashDividendValueB addObject: [NSString stringWithFormat:@"%.9f",  
                                                                [[AccuCashDividendValueB objectAtIndex:j - 2] doubleValue ] * (1 + 0.035) ]];
                            
                            
                        }
                        else {
                            if (j == 1) {
                                [AccuCashDividendValueA addObject:[CurrentCashDividendValueA objectAtIndex:j-1]];
                                [AccuCashDividendValueB addObject:[CurrentCashDividendValueB objectAtIndex:j-1]];
                            }
                            else {
                                [AccuCashDividendValueA addObject: [NSString stringWithFormat:@"%.8f", 
                                                                    [[CurrentCashDividendValueA objectAtIndex:j-1] doubleValue ] + 
                                                                    [[AccuCashDividendValueA objectAtIndex:j - 2] doubleValue ] * (1 + 0.055) ]];
                                [AccuCashDividendValueB addObject: [NSString stringWithFormat:@"%.9f", 
                                                                    [[CurrentCashDividendValueB objectAtIndex:j-1] doubleValue ] + 
                                                                    [[AccuCashDividendValueB objectAtIndex:j - 2] doubleValue ] * (1 + 0.035) ]];
                            }
                        }
                    }
                    else {
                        [AccuCashDividendValueA addObject:@"-" ];
                        [AccuCashDividendValueB addObject:@"-" ];
                    }
                    
                    
                    
                    // --- accu yearly income
                    if ([YearlyIncome isEqualToString:@"ACC"]) {
                        
                        
                            if (j == 1) {
                                [AccuYearlyIncomeValueA addObject:[YearlyIncomeEOF objectAtIndex:j-1]];
                                [AccuYearlyIncomeValueB addObject:[YearlyIncomeEOF objectAtIndex:j-1]];
                            }
                            else {
                                [AccuYearlyIncomeValueA addObject: [NSString stringWithFormat:@"%.8f", 
                                                                    [[YearlyIncomeEOF objectAtIndex:j-1] doubleValue ] + 
                                                                    [[AccuYearlyIncomeValueA objectAtIndex:j - 2] doubleValue ] * (1 + 0.055) ]];
                                [AccuYearlyIncomeValueB addObject: [NSString stringWithFormat:@"%.9f", 
                                                                    [[YearlyIncomeEOF objectAtIndex:j-1] doubleValue ] + 
                                                                    [[AccuYearlyIncomeValueB objectAtIndex:j - 2] doubleValue ] * (1 + 0.035) ]];
                            }
                        
                    }
                    else {
                        [AccuYearlyIncomeValueA addObject:@"-" ];
                        [AccuYearlyIncomeValueB addObject:@"-" ];
                    }
                    
                    // ---- TD
                    [tDividendValueA addObject:[NSString stringWithFormat:@"%.8f", [[tDividendRatesA objectAtIndex:j-1] doubleValue ]/100.00 * dRiderSA ]];
                    [tDividendValueB addObject:[NSString stringWithFormat:@"%.9f", [[tDividendRatesB objectAtIndex:j-1] doubleValue ]/100.00 * dRiderSA ]];
                    
                    // --- spe
                    
                    [speValueA addObject:[NSString stringWithFormat:@"%.3f", [[speRatesA objectAtIndex:j-1] doubleValue ]/100 * dRiderSA ]];
                    [speValueB addObject:[NSString stringWithFormat:@"%.3f", [[speRatesB objectAtIndex:j-1] doubleValue ]/100 * dRiderSA ]];
                    
                    // --- Total Surrender value
                    double dTotalSurrenderValueA = 0.00;
                    double dTotalSurrenderValueB = 0.00;
                    
                        if (j > iTerm) {
                            
                            if ([strIncRiderCode isEqualToString:@"ID20R"] || [strIncRiderCode isEqualToString:@"ID30R"] || [strIncRiderCode isEqualToString:@"ID40R"] ) {
                                if (j == 1) {
                                    dTotalSurrenderValueA = 0.00;
                                    dTotalSurrenderValueB = 0.00;
                                }
                                else {
                                    dTotalSurrenderValueA = [[TotalSurrenderValueA objectAtIndex:j-2] doubleValue ] * (1 + 0.055);
                                    dTotalSurrenderValueB = [[TotalSurrenderValueB objectAtIndex:j-2] doubleValue ] * (1 + 0.035);
                                }
                            }
                            else {
                                if ([CashDividend isEqualToString:@"ACC"] ) {
                                    if (j == 1) {
                                        dTotalSurrenderValueA = 0.00;
                                        dTotalSurrenderValueB = 0.00;
                                    }
                                    else {
                                        dTotalSurrenderValueA = [[TotalSurrenderValueA objectAtIndex:j-2] doubleValue ] * (1 + 0.055);
                                        dTotalSurrenderValueB = [[TotalSurrenderValueB objectAtIndex:j-2] doubleValue ] * (1 + 0.035);
                                    }
                                }
                                else if (![CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"] ) {
                                    dTotalSurrenderValueA = [[AccuYearlyIncomeValueA objectAtIndex:j-1] doubleValue ];
                                    dTotalSurrenderValueB = [[AccuYearlyIncomeValueB objectAtIndex:j-1] doubleValue ];
                                }
                                else if (![CashDividend isEqualToString:@"ACC"] && ![YearlyIncome isEqualToString:@"ACC"] ) {
                                   dTotalSurrenderValueA =  [[SurrenderValue objectAtIndex:j-1] doubleValue ] + 
                                    [[tDividendValueA objectAtIndex:j-1] doubleValue ];
                                    dTotalSurrenderValueB =  [[SurrenderValue objectAtIndex:j-1] doubleValue ] + 
                                    [[tDividendValueB objectAtIndex:j-1] doubleValue ];

                                }
                            }
                            
                        }
                        else {
                            if ([CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"] ) {
                                dTotalSurrenderValueA = [[SurrenderValue objectAtIndex:j-1]doubleValue ] +
                                                        [[AccuYearlyIncomeValueA objectAtIndex:j-1] doubleValue ] + 
                                                        [[AccuCashDividendValueA objectAtIndex:j-1] doubleValue ] + 
                                                        [[tDividendValueA objectAtIndex:j-1] doubleValue ];
                                
                                dTotalSurrenderValueB = [[SurrenderValue objectAtIndex:j-1]doubleValue ] +
                                [[AccuYearlyIncomeValueB objectAtIndex:j-1] doubleValue ] + 
                                [[AccuCashDividendValueB objectAtIndex:j-1] doubleValue ] + 
                                [[tDividendValueB objectAtIndex:j-1] doubleValue ];
                            }
                            else if ([CashDividend isEqualToString:@"ACC"] && ![YearlyIncome isEqualToString:@"ACC"]) {
                                dTotalSurrenderValueA = [[SurrenderValue objectAtIndex:j-1]doubleValue ] +
                                [[AccuCashDividendValueA objectAtIndex:j-1] doubleValue ] + 
                                [[tDividendValueA objectAtIndex:j-1] doubleValue ];
                                
                                dTotalSurrenderValueB = [[SurrenderValue objectAtIndex:j-1]doubleValue ] +
                                [[AccuCashDividendValueB objectAtIndex:j-1] doubleValue ] + 
                                [[tDividendValueB objectAtIndex:j-1] doubleValue ];
                            }
                            else if (![CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"] ) {
                                dTotalSurrenderValueA = [[SurrenderValue objectAtIndex:j-1]doubleValue ] +
                                [[AccuYearlyIncomeValueA objectAtIndex:j-1] doubleValue ] + 
                                [[tDividendValueA objectAtIndex:j-1] doubleValue ];
                                
                                dTotalSurrenderValueB = [[SurrenderValue objectAtIndex:j-1]doubleValue ] +
                                [[AccuYearlyIncomeValueB objectAtIndex:j-1] doubleValue ] + 
                                [[tDividendValueB objectAtIndex:j-1] doubleValue ];
                            }
                            else {
                                dTotalSurrenderValueA = [[SurrenderValue objectAtIndex:j-1]doubleValue ] +
                                [[tDividendValueA objectAtIndex:j-1] doubleValue ];
                                
                                dTotalSurrenderValueB = [[SurrenderValue objectAtIndex:j-1]doubleValue ] +
                                [[tDividendValueB objectAtIndex:j-1] doubleValue ];
                            }
                        }
                    [TotalSurrenderValueA addObject: [NSString stringWithFormat: @"%.8f", dTotalSurrenderValueA ] ];   
                    [TotalSurrenderValueB addObject: [NSString stringWithFormat: @"%.9f", dTotalSurrenderValueB ] ];        
                    
                    // --- Total Db value
                    double dDBValueA = 0.00;
                    double dDbValueB = 0.00;
                    
                    if (j > iTerm) {
                        
                        if ([strIncRiderCode isEqualToString:@"I20R"] || [strIncRiderCode isEqualToString:@"I30R"] || [strIncRiderCode isEqualToString:@"I40R"]
                            || [strIncRiderCode isEqualToString:@"IE20R"] || [strIncRiderCode isEqualToString:@"IE30R"]  ) {
                            
                            if (![CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"] ) {
                                dDBValueA = [[AccuYearlyIncomeValueA objectAtIndex:j-1] doubleValue ];
                                dDbValueB = [[AccuYearlyIncomeValueB objectAtIndex:j-1] doubleValue ];
                                
                            }
                        }
                        else {
                            dDBValueA = [[TotalSurrenderValueA objectAtIndex:j-1] doubleValue ];
                            dDbValueB = [[TotalSurrenderValueB objectAtIndex:j-1] doubleValue ];
                            
                        }    
                        
                        
                    }
                    else {
                        if ([CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"] ) {
                            dDBValueA = [[DBValueEnd objectAtIndex:j-1] doubleValue ] + 
                                         [[AccuCashDividendValueA objectAtIndex:j-1] doubleValue ] +
                                         [[AccuYearlyIncomeValueA objectAtIndex:j-1] doubleValue ] +
                            [[speValueA objectAtIndex:j-1] doubleValue ];
                            
                            dDbValueB = [[DBValueEnd objectAtIndex:j-1] doubleValue ] + 
                            [[AccuCashDividendValueB objectAtIndex:j-1] doubleValue ] +
                            [[AccuYearlyIncomeValueB objectAtIndex:j-1] doubleValue ] +
                            [[speValueB objectAtIndex:j-1] doubleValue ];
                        }
                        else if ([CashDividend isEqualToString:@"ACC"] && ![YearlyIncome isEqualToString:@"ACC"]) {
                            dDBValueA = [[DBValueEnd objectAtIndex:j-1] doubleValue ] + 
                            [[AccuCashDividendValueA objectAtIndex:j-1] doubleValue ] +
                            [[speValueA objectAtIndex:j-1] doubleValue ];
                            
                            dDbValueB = [[DBValueEnd objectAtIndex:j-1] doubleValue ] + 
                            [[AccuCashDividendValueB objectAtIndex:j-1] doubleValue ] +
                            [[speValueB objectAtIndex:j-1] doubleValue ];
                        }
                        else if (![CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"] ) {
                            dDBValueA = [[DBValueEnd objectAtIndex:j-1] doubleValue ] + 
                            [[AccuYearlyIncomeValueA objectAtIndex:j-1] doubleValue ] +
                            [[speValueA objectAtIndex:j-1] doubleValue ];
                            
                            dDbValueB = [[DBValueEnd objectAtIndex:j-1] doubleValue ] + 
                            [[AccuYearlyIncomeValueB objectAtIndex:j-1] doubleValue ] +
                            [[speValueB objectAtIndex:j-1] doubleValue ];
                        }
                        else {
                            dDBValueA = [[DBValueEnd objectAtIndex:j-1] doubleValue ] + 
                            [[speValueA objectAtIndex:j-1] doubleValue ];
                            
                            dDbValueB = [[DBValueEnd objectAtIndex:j-1] doubleValue ] + 
                            [[speValueB objectAtIndex:j-1] doubleValue ];
                        }
                    }
                    
                    [TotalDBValueA addObject:[NSString stringWithFormat:@"%.3f", dDBValueA]];
                    [TotalDBValueB addObject:[NSString stringWithFormat:@"%.3f", dDbValueB]];
                }
                
            for (int k=0; k < PolicyTerm; k++) {
                double tempValueGYI;
                double tempSurrenderValue;
                double tempDBValueA;
                double tempDBValueB;
                double tempADValueA;
                double tempADValueB;
                double tempCashDividendA;
                double tempCashDividendB;
                double tempYearlyIncomeA;
                double tempYearlyincomeB;
                double tempTotalSurrenderA;
                double tempTotalSurrenderB;    
                double tempTotalDbA;
                double tempTotalDbB;
                if (k < iTerm) {
                    tempValueGYI = [[SummaryGuaranteedTotalGYI objectAtIndex:k] doubleValue ];
                    tempValueGYI = tempValueGYI + [[YearlyIncomeEOF objectAtIndex:k] doubleValue ];
                    
                    tempSurrenderValue = [[SummaryGuaranteedSurrenderValue objectAtIndex:k] doubleValue ];
                    tempSurrenderValue = tempSurrenderValue + [[SurrenderValue objectAtIndex:k] doubleValue ];
                    
                    tempDBValueA = [[SummaryGuaranteedDBValueA objectAtIndex:k] doubleValue ];
                    tempDBValueA = tempDBValueA + [[DBValue objectAtIndex:k] doubleValue ];
                    
                    tempDBValueB = [[SummaryGuaranteedDBValueB objectAtIndex:k] doubleValue ];
                    tempDBValueB = tempDBValueB + [[DBValueEnd objectAtIndex:k] doubleValue ];
                    
                    tempADValueA = [[SummaryGuaranteedAddValue objectAtIndex:k] doubleValue ];
                    tempADValueA = tempADValueA + [[aValue objectAtIndex:k] doubleValue ];
                
                    tempADValueB = [[SummaryGuaranteedAddEndValue objectAtIndex:k] doubleValue ];
                    tempADValueB = tempADValueB + [[aValueEnd objectAtIndex:k] doubleValue ];
                    
                    if ([CashDividend isEqualToString:@"ACC" ]) {
                        tempCashDividendA = [[SummaryNonGuaranteedAccuCashDividendA objectAtIndex:k] doubleValue ];
                        tempCashDividendA = tempCashDividendA + [[AccuCashDividendValueA objectAtIndex:k] doubleValue ];
                        
                        tempCashDividendB = [[SummaryNonGuaranteedAccuCashDividendB objectAtIndex:k] doubleValue ];
                        tempCashDividendB = tempCashDividendB + [[AccuCashDividendValueB objectAtIndex:k] doubleValue ];
                    }
                    
                    if ([YearlyIncome isEqualToString:@"ACC" ]) {
                        tempYearlyIncomeA = [[SummaryNonGuaranteedAccuYearlyIncomeA objectAtIndex:k] doubleValue ];
                        tempYearlyIncomeA = tempYearlyIncomeA + [[AccuYearlyIncomeValueA objectAtIndex:k] doubleValue ];
                        
                        tempYearlyincomeB = [[SummaryNonGuaranteedAccuYearlyIncomeB objectAtIndex:k] doubleValue ];
                        tempYearlyincomeB = tempYearlyincomeB + [[AccuYearlyIncomeValueB objectAtIndex:k] doubleValue ];
                    }
                    
                    tempTotalSurrenderA = [[SummaryNonGuaranteedSurrenderValueA objectAtIndex:k] doubleValue ];
                    tempTotalSurrenderA = tempTotalSurrenderA + [[TotalSurrenderValueA objectAtIndex:k] doubleValue ];
                    
                    tempTotalSurrenderB = [[SummaryNonGuaranteedSurrenderValueB objectAtIndex:k] doubleValue ];
                    tempTotalSurrenderB = tempTotalSurrenderB + [[TotalSurrenderValueB objectAtIndex:k] doubleValue ];
                    
                    tempTotalDbA = [[SummaryNonGuaranteedDBValueA objectAtIndex:k] doubleValue ];
                    tempTotalDbA = tempTotalDbA + [[TotalDBValueA objectAtIndex:k] doubleValue ];
                    
                    tempTotalDbB = [[SummaryNonGuaranteedDBValueB objectAtIndex:k] doubleValue ];
                    tempTotalDbB = tempTotalDbB + [[TotalDBValueB objectAtIndex:k] doubleValue ];
                    
                }
                else {
                    
                    // ----- GYI -----
                    double GYIRate;
                    if ([strIncRiderCode isEqualToString:@"ID20R"] ) {
                        if (k +1 >= 21 &&  k +1 < 91 ) {
                            GYIRate = 100.00;
                        }
                        else {
                            GYIRate = 0.00;
                        }
                    }
                    else if ([strIncRiderCode isEqualToString:@"ID30R"]) {
                        if (k + 1 >= 31 && k + 1 < 91 ) {
                            GYIRate = 100.00;
                        }
                        else {
                            GYIRate = 0.00;
                        }
                    }
                    else if ([strIncRiderCode isEqualToString:@"ID40R"]) {
                        if (k + 1 >= 41 && k + 1 < 91 ) {
                            GYIRate = 100.00;
                        }
                        else {
                            GYIRate = 0.00;
                        }
                    }
                    else {
                        GYIRate = 0.00;
                    }
                    
                    [YearlyIncomeEOF addObject:[NSString stringWithFormat:@"%.2f", GYIRate/100 * dRiderSA ]];
                    
                    
                    tempValueGYI = [[SummaryGuaranteedTotalGYI objectAtIndex:k] doubleValue ];
                    tempValueGYI = tempValueGYI + [[YearlyIncomeEOF objectAtIndex:k] doubleValue ];;
                    
                    //-------- end ----------
                    
                    // --- surrender value -----
                    [SurrenderValue addObject: @"0.00"];
                    
                    tempSurrenderValue = [[SummaryGuaranteedSurrenderValue objectAtIndex:k] doubleValue ];
                    tempSurrenderValue = tempSurrenderValue + [[SurrenderValue objectAtIndex:k] doubleValue ];
                    //----- end --------
                    
                    tempDBValueA = [[SummaryGuaranteedDBValueA objectAtIndex:k] doubleValue ];
                    tempDBValueA = tempDBValueA + 0.00;
                    
                    tempDBValueB = [[SummaryGuaranteedDBValueB objectAtIndex:k] doubleValue ];
                    tempDBValueB = tempDBValueB + 0.00;
                    
                    tempADValueA = [[SummaryGuaranteedAddValue objectAtIndex:k] doubleValue ];
                    tempADValueA = tempADValueA + 0.00;
                    
                    tempADValueB = [[SummaryGuaranteedAddEndValue objectAtIndex:k] doubleValue ];
                    tempADValueB = tempADValueB + 0.00;
                    
                    if ([CashDividend isEqualToString:@"ACC" ]) {
                        
                        [AccuCashDividendValueA addObject: [NSString stringWithFormat:@"%.8f",  
                                                            [[AccuCashDividendValueA objectAtIndex:k - 1] doubleValue ] * (1 + 0.055) ]];
                        [AccuCashDividendValueB addObject: [NSString stringWithFormat:@"%.9f",  
                                                            [[AccuCashDividendValueB objectAtIndex:k - 1] doubleValue ] * (1 + 0.035) ]];
                        
                        
                        tempCashDividendA = [[SummaryNonGuaranteedAccuCashDividendA objectAtIndex:k] doubleValue ];
                        tempCashDividendA = tempCashDividendA + [[AccuCashDividendValueA objectAtIndex:k] doubleValue ];
                        
                        tempCashDividendB = [[SummaryNonGuaranteedAccuCashDividendB objectAtIndex:k] doubleValue ];
                        tempCashDividendB = tempCashDividendB + [[AccuCashDividendValueB objectAtIndex:k] doubleValue ];
                    }
                    
                    
                    if ([YearlyIncome isEqualToString:@"ACC" ]) {
                        
                        [AccuYearlyIncomeValueA addObject: [NSString stringWithFormat:@"%.8f", 
                                                            [[YearlyIncomeEOF objectAtIndex:k] doubleValue ] + 
                                                            [[AccuYearlyIncomeValueA objectAtIndex:k - 1] doubleValue ] * (1 + 0.055) ]];
                        [AccuYearlyIncomeValueB addObject: [NSString stringWithFormat:@"%.9f", 
                                                            [[YearlyIncomeEOF objectAtIndex:k] doubleValue ] + 
                                                            [[AccuYearlyIncomeValueB objectAtIndex:k - 1] doubleValue ] * (1 + 0.035) ]];
                        
                        tempYearlyIncomeA = [[SummaryNonGuaranteedAccuYearlyIncomeA objectAtIndex:k] doubleValue ];
                        tempYearlyIncomeA = tempYearlyIncomeA + [[AccuYearlyIncomeValueA objectAtIndex:k] doubleValue ];
                        
                        tempYearlyincomeB = [[SummaryNonGuaranteedAccuYearlyIncomeB objectAtIndex:k] doubleValue ];
                        tempYearlyincomeB = tempYearlyincomeB + [[AccuYearlyIncomeValueB objectAtIndex:k] doubleValue ];
                    }
                    
                    
                    // -------- continue to add remaining total surrender value after policy year > income rider's term
                    double dTotalSurrenderValueA;
                    double dTotalSurrenderValueB;
                    
                    [tDividendValueA addObject:[NSString stringWithFormat:@"0.00"]];
                    [tDividendValueB addObject:[NSString stringWithFormat:@"0.00"]];
                    
                    
                    if ([strIncRiderCode isEqualToString:@"ID20R"] || [strIncRiderCode isEqualToString:@"ID30R"] || [strIncRiderCode isEqualToString:@"ID40R"] ) {
                        if (k == 0) {
                            dTotalSurrenderValueA = 0.00;
                            dTotalSurrenderValueB = 0.00;
                        }
                        else {
                            dTotalSurrenderValueA = [[TotalSurrenderValueA objectAtIndex:k-1] doubleValue ] * (1 + 0.055);
                            dTotalSurrenderValueB = [[TotalSurrenderValueB objectAtIndex:k-1] doubleValue ] * (1 + 0.035);
                        }
                    }
                    else {
                        if ([CashDividend isEqualToString:@"ACC"] ) {
                            if (k == 0) {
                                dTotalSurrenderValueA = 0.00;
                                dTotalSurrenderValueB = 0.00;
                            }
                            else {
                                dTotalSurrenderValueA = [[TotalSurrenderValueA objectAtIndex:k-1] doubleValue ] * (1 + 0.055);
                                dTotalSurrenderValueB = [[TotalSurrenderValueB objectAtIndex:k-1] doubleValue ] * (1 + 0.035);
                            }
                        }
                        else if (![CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"] ) {
                            dTotalSurrenderValueA = [[AccuYearlyIncomeValueA objectAtIndex:k] doubleValue ];
                            dTotalSurrenderValueB = [[AccuYearlyIncomeValueB objectAtIndex:k] doubleValue ];
                        }
                        else if (![CashDividend isEqualToString:@"ACC"] && ![YearlyIncome isEqualToString:@"ACC"] ) {
                            dTotalSurrenderValueA =  [[SurrenderValue objectAtIndex:k] doubleValue ] + 
                            [[tDividendValueA objectAtIndex:k] doubleValue ];
                            dTotalSurrenderValueB =  [[SurrenderValue objectAtIndex:k] doubleValue ] + 
                            [[tDividendValueB objectAtIndex:k] doubleValue ];
                            
                        }
                    }
                    [TotalSurrenderValueA addObject: [NSString stringWithFormat: @"%.8f", dTotalSurrenderValueA ] ];   
                    [TotalSurrenderValueB addObject: [NSString stringWithFormat: @"%.9f", dTotalSurrenderValueB ] ];        
                    
                    
    
                    tempTotalSurrenderA = [[SummaryNonGuaranteedSurrenderValueA objectAtIndex:k] doubleValue ];
                    tempTotalSurrenderA = tempTotalSurrenderA + [[TotalSurrenderValueA objectAtIndex:k] doubleValue ];
                    
                    tempTotalSurrenderB = [[SummaryNonGuaranteedSurrenderValueB objectAtIndex:k] doubleValue ];
                    tempTotalSurrenderB = tempTotalSurrenderB  + [[TotalSurrenderValueB objectAtIndex:k] doubleValue ];
                    
                    //----- end ----
                    double dDBValueA;
                    double dDbValueB;
                    
                    if ([strIncRiderCode isEqualToString:@"I20R"] || [strIncRiderCode isEqualToString:@"I30R"] || [strIncRiderCode isEqualToString:@"I40R"]
                        || [strIncRiderCode isEqualToString:@"IE20R"] || [strIncRiderCode isEqualToString:@"IE30R"]  ) {
                        
                        if (![CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"] ) {
                            dDBValueA = [[AccuYearlyIncomeValueA objectAtIndex:k] doubleValue ];
                            dDbValueB = [[AccuYearlyIncomeValueB objectAtIndex:k] doubleValue ];
                            
                        }
                        else {
                            dDBValueA = [[TotalSurrenderValueA objectAtIndex:k] doubleValue ];
                            dDbValueB = [[TotalSurrenderValueB objectAtIndex:k] doubleValue ];
                        }
                    }
                    else {
                        dDBValueA = [[TotalSurrenderValueA objectAtIndex:k] doubleValue ];
                        dDbValueB = [[TotalSurrenderValueB objectAtIndex:k] doubleValue ];
                        
                    }
                    
                    [TotalDBValueA addObject:[NSString stringWithFormat:@"%.3f", dDBValueA]];
                    [TotalDBValueB addObject:[NSString stringWithFormat:@"%.3f", dDbValueB]];
                    
                    tempTotalDbA = [[SummaryNonGuaranteedDBValueA objectAtIndex:k] doubleValue ];
                    tempTotalDbA = tempTotalDbA + [[TotalDBValueA objectAtIndex:k] doubleValue ];
                    
                    tempTotalDbB = [[SummaryNonGuaranteedDBValueB objectAtIndex:k] doubleValue ];
                    tempTotalDbB = tempTotalDbB + [[TotalDBValueB objectAtIndex:k] doubleValue ];
                    
                }
                
                //NSLog(@"%.3f", tempSurrenderValue);
                [SummaryGuaranteedTotalGYI replaceObjectAtIndex:k withObject: [NSString stringWithFormat:@"%.9f", tempValueGYI]];
                [SummaryGuaranteedSurrenderValue replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.9f", tempSurrenderValue ]];
                [SummaryGuaranteedDBValueA replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.3f", tempDBValueA ]];
                [SummaryGuaranteedDBValueB replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.3f", tempDBValueB ]];
                [SummaryGuaranteedAddValue replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.3f", tempADValueA ]];
                [SummaryGuaranteedAddEndValue replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.3f", tempADValueB ]];
                if ([CashDividend isEqualToString:@"ACC" ]) {
                    [SummaryNonGuaranteedAccuCashDividendA replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.8f", tempCashDividendA ]];
                    [SummaryNonGuaranteedAccuCashDividendB replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.9f", tempCashDividendB ]];
                    
                }
                
                if ([YearlyIncome isEqualToString:@"ACC" ]) {
                    [SummaryNonGuaranteedAccuYearlyIncomeA replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.8f", tempYearlyIncomeA ]];
                    [SummaryNonGuaranteedAccuYearlyIncomeB replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.9f", tempYearlyincomeB ]];
                    
                }
                
                [SummaryNonGuaranteedSurrenderValueA replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.8f", tempTotalSurrenderA ]];
                [SummaryNonGuaranteedSurrenderValueB replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.9f", tempTotalSurrenderB ]];
                [SummaryNonGuaranteedDBValueA replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.3f", tempTotalDbA ]];
                [SummaryNonGuaranteedDBValueB replaceObjectAtIndex:k withObject:[NSString stringWithFormat:@"%.3f", tempTotalDbB ]];
                
                
                if (k == PolicyTerm - 1) {
                    //EntireTotalYearlyIncome = [[SummaryGuaranteedTotalGYI objectAtIndex:k ] doubleValue ];
                    EntireMaturityValueA = [[SummaryNonGuaranteedSurrenderValueA objectAtIndex:k ] doubleValue ];
                    EntireMaturityValueB = [[SummaryNonGuaranteedSurrenderValueB objectAtIndex:k ] doubleValue ];        
                }
                //NSLog(@"%.3f", EntireMaturityValueA);
            }
            
                for (int a= 1; a<=[[IncomeRiderTerm objectAtIndex:i] intValue]; a++) {
                    
                    if (a <= 20 || (a > 20 && a % 5  == 0) || (a == a<=[[IncomeRiderTerm objectAtIndex:i] intValue] && a%5 != 0) ) {
                    
                        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                        if (Age > 0){
                            
                            inputAge = Age + a;
                            
                            NSString *strAccuCDA = @""; 
                            NSString *strAccuCDB = @"";
                            NSString *strAccuYIA = @"";
                            NSString *strAccuYIB = @"";
                            
                            if ([CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"]) {
                                strAccuCDA = [NSString stringWithFormat:@"%.0f", round( [[AccuCashDividendValueA objectAtIndex:a-1] doubleValue ])];
                                strAccuCDB = [NSString stringWithFormat:@"%.0f", round( [[AccuCashDividendValueB objectAtIndex:a-1] doubleValue ])];
                                strAccuYIA = [NSString stringWithFormat:@"%.0f", round( [[AccuYearlyIncomeValueA objectAtIndex:a-1] doubleValue ])];
                                strAccuYIB = [NSString stringWithFormat:@"%.0f", round( [[AccuYearlyIncomeValueB objectAtIndex:a-1] doubleValue ])];
                            }
                            else if ([CashDividend isEqualToString:@"ACC"] && ![YearlyIncome isEqualToString:@"ACC"]) {
                                strAccuCDA = [NSString stringWithFormat:@"%.0f", round( [[AccuCashDividendValueA objectAtIndex:a-1] doubleValue ])];
                                strAccuCDB = [NSString stringWithFormat:@"%.0f", round( [[AccuCashDividendValueB objectAtIndex:a-1] doubleValue ])];
                                strAccuYIA = [NSString stringWithFormat:@"-"];
                                strAccuYIB = [NSString stringWithFormat:@"-"];
                            }    
                            else if (![CashDividend isEqualToString:@"ACC"] && [YearlyIncome isEqualToString:@"ACC"]) {
                                strAccuCDA = [NSString stringWithFormat:@"-"];
                                strAccuCDB = [NSString stringWithFormat:@"-"];
                                strAccuYIA = [NSString stringWithFormat:@"%.0f", round( [[AccuYearlyIncomeValueA objectAtIndex:a-1] doubleValue ])];
                                strAccuYIB = [NSString stringWithFormat:@"%.0f", round( [[AccuYearlyIncomeValueB objectAtIndex:a-1] doubleValue ])];
                            }        
                            else if (![CashDividend isEqualToString:@"ACC"] && ![YearlyIncome isEqualToString:@"ACC"]) {
                                strAccuCDA = [NSString stringWithFormat:@"-"];
                                strAccuCDB = [NSString stringWithFormat:@"-"];
                                strAccuYIA = [NSString stringWithFormat:@"-"];
                                strAccuYIB = [NSString stringWithFormat:@"-"];
                            }
                            
                            
                            QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_RideriLLus (\"SINO\", \"SeqNo\",\"DataType\",\"DataType2\", "
                                        " \"PageNo\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                                        "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                                        "\"col14\",\"col15\",\"col16\",\"col17\",\"col18\",\"col19\",\"col20\",\"col21\") VALUES ( "
                                        " \"%@\",\"%d\",\"%@\",\"DATA\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%.0f\",\"%.0f\",\"%.0f\",\"%@\",\"%@\",\"%.0f\", "
                                        "\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\",\"%@\",\"%@\",\"%@\",\"%@\",\"%.0f\",\"%.0f\",\"%.0f\",\"%.0f\")", 
                                        SINo, a, [IncomeRiderCode objectAtIndex:i],i,a,inputAge, [AnnualPremium objectAtIndex:a - 1], [YearlyIncomeEOF objectAtIndex:a-1],
                                         round( [[SurrenderValue objectAtIndex:a-1] doubleValue ]) ,
                                         round( [[DBValue objectAtIndex:a-1] doubleValue ]), round( [[DBValueEnd objectAtIndex:a-1] doubleValue ]),
                                        [aValue objectAtIndex:a-1],[aValueEnd objectAtIndex:a-1],
                                        round([[TotalSurrenderValueA objectAtIndex:a-1] doubleValue ]), round([[TotalSurrenderValueB objectAtIndex:a-1] doubleValue ]),
                                        round([[TotalDBValueA objectAtIndex:a-1] doubleValue ]), round([[TotalDBValueB objectAtIndex:a-1] doubleValue ]),
                                        round([[CurrentCashDividendValueA objectAtIndex:a-1] doubleValue ]), round([[CurrentCashDividendValueB objectAtIndex:a-1] doubleValue ]),
                                        strAccuCDA,strAccuCDB,
                                        strAccuYIA,strAccuYIB,
                                        round([[tDividendValueA objectAtIndex:a-1] doubleValue ]),round([[tDividendValueB objectAtIndex:a-1] doubleValue ]),
                                        round([[speValueA objectAtIndex:a-1] doubleValue ]),round([[speValueB objectAtIndex:a-1] doubleValue ])
                                        ];
                            
                            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                if (sqlite3_step(statement) == SQLITE_DONE) {
                                    
                                }
                                sqlite3_finalize(statement); 
                            }
                        }
                        sqlite3_close(contactDB);
                    }
                    }
                }
            
        }
    }
    
    NSLog(@"insert to SI_Temp_Trad_RideriLLus --- End");
    
}

-(void)UpdateToSI_Temp_Trad_Details{
    
    if (UpdateTradDetail.count > 0) {
        NSLog(@"Update Trad Detail start");
        sqlite3_stmt *statement;
        NSString *QuerySQL = @"";
        
        for (int i = 0; i< UpdateTradDetail.count; i++) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            //[formatter setMaximumFractionDigits:3];
            [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
            NSString *SAAnnual = [formatter stringFromNumber:[NSNumber numberWithFloat:[[gWaiverAnnual objectAtIndex:i] doubleValue ]]];
            NSString *SASemiAnnual = [formatter stringFromNumber:[NSNumber numberWithFloat:[[gWaiverSemiAnnual objectAtIndex:i] doubleValue ]]];
            NSString *SAQuaterly = [formatter stringFromNumber:[NSNumber numberWithFloat:[[gWaiverQuarterly objectAtIndex:i] doubleValue ]]];
            NSString *SAMonthly = [formatter stringFromNumber:[NSNumber numberWithFloat:[[gWaiverMonthly objectAtIndex:i] doubleValue ]]];
            
            
            if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                QuerySQL = [ NSString stringWithFormat:@"UPDATE SI_Temp_Trad_Details set col2 = \"%@\" where col0_1 = \"-Annual\" AND col11 = \"%@\" ", 
                            SAAnnual, [UpdateTradDetail objectAtIndex:i ]];
                
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                    }    
                    sqlite3_finalize(statement);
                }
                
                QuerySQL = [ NSString stringWithFormat:@"UPDATE SI_Temp_Trad_Details set col2 = \"%@\" where col0_1 = \"-Semi-annual\" AND col11 = \"%@\" ", 
                            SASemiAnnual, [UpdateTradDetail objectAtIndex:i ]];
                
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                    }    
                    sqlite3_finalize(statement);
                }   
                
                QuerySQL = [ NSString stringWithFormat:@"UPDATE SI_Temp_Trad_Details set col2 = \"%@\" where col0_1 = \"-Quarterly\" AND col11 = \"%@\" ", 
                            SAQuaterly, [UpdateTradDetail objectAtIndex:i ]];
                
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                    }    
                    sqlite3_finalize(statement);
                }
                
                
                QuerySQL = [ NSString stringWithFormat:@"UPDATE SI_Temp_Trad_Details set col2 = \"%@\" where col0_1 = \"-Monthly\" AND col11 = \"%@\" ", 
                            SAMonthly, [UpdateTradDetail objectAtIndex:i ]];
                
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                    }    
                    sqlite3_finalize(statement);
                }
                
                sqlite3_close(contactDB);
            }
        }
        
        NSLog(@"Update Trad Detail end");
    }
    
        
}

-(void)getAllPreDetails{
   
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    NSString *QuerySQL;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
            QuerySQL = [ NSString stringWithFormat:@"select \"PolicyTerm\", \"BasicSA\", \"premiumPaymentOption\", \"CashDividend\",  "
                                  "\"YearlyIncome\", \"AdvanceYearlyIncome\", \"HL1KSA\",  \"sex\" from Trad_Details as A, "
                        "Clt_Profile as B, trad_LaPayor as C where A.Sino = C.Sino AND C.custCode = B.custcode AND "
                        "A.sino = \"%@\" AND \"seq\" = 1 ", SINo];
        
        NSLog(@"%@", QuerySQL);
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                PolicyTerm = sqlite3_column_int(statement, 0);
                BasicSA = sqlite3_column_int(statement, 1);
                PremiumPaymentOption = sqlite3_column_int(statement, 2);
                CashDividend = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                YearlyIncome = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                AdvanceYearlyIncome = sqlite3_column_int(statement, 5);
                HealthLoading = sqlite3_column_int(statement, 6);
                
                
            }
            sqlite3_finalize(statement);
            
        }     
        sqlite3_close(contactDB);
    }
    
    IncomeRiderCode = [[NSMutableArray alloc] init ];
    IncomeRiderTerm = [[NSMutableArray alloc] init ];
    IncomeRiderDesc = [[NSMutableArray alloc] init ];
    IncomeRiderSA = [[NSMutableArray alloc] init ];
    IncomeRiderPlanOption = [[NSMutableArray alloc] init ];
    OtherRiderCode = [[NSMutableArray alloc] init ];
    OtherRiderTerm = [[NSMutableArray alloc] init ];
    OtherRiderDesc = [[NSMutableArray alloc] init ];
    OtherRiderSA = [[NSMutableArray alloc] init ];
    OtherRiderPlanOption = [[NSMutableArray alloc] init ];
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        QuerySQL = [ NSString stringWithFormat:@"Select A.RiderCode, \"RiderTerm\",\"RiderDesc\", \"SumAssured\", \"PlanOption\" from trad_rider_details as A, "
                    "trad_sys_rider_profile as B  where \"sino\" = \"%@\" AND A.ridercode = B.RiderCode ", SINo];
        
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(statement2) == SQLITE_ROW) {
            
                NSString *zzz = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
                
                if ([zzz isEqualToString:@"I20R"] || [zzz isEqualToString:@"I30R"] || [zzz isEqualToString:@"I40R"]|| [zzz isEqualToString:@"ICR"]
                    || [zzz isEqualToString:@"ID20R"]|| [zzz isEqualToString:@"ID30R"]|| [zzz isEqualToString:@"ID40R"]|| [zzz isEqualToString:@"IE20R"]
                    || [zzz isEqualToString:@"IE30R"]) {
                    
                    [IncomeRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)]];
                    [IncomeRiderTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 1)]];
                    [IncomeRiderDesc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 2)]];
                    [IncomeRiderSA addObject: [NSString stringWithFormat:@"%d", sqlite3_column_int(statement2, 3)]];
                    [IncomeRiderPlanOption addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 4)]];
                }
                else {
                    [OtherRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)]];
                    [OtherRiderTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 1)]];
                    [OtherRiderDesc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 2)]];
                    [OtherRiderSA addObject: [NSString stringWithFormat:@"%d", sqlite3_column_int(statement2, 3)]];
                    
                                    
                    
                    if ([[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 4)] isEqualToString:@"(null)" ]   ) {
                        [OtherRiderPlanOption addObject:@""]; 
                        
                    }
                    else {
                        [OtherRiderPlanOption addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 4)]];
                        
                    }
                    
                    
                    
                }
            }
            sqlite3_finalize(statement2);
        }     
        sqlite3_close(contactDB);
    }
}
@end
