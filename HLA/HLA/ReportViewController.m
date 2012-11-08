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

@interface ReportViewController ()

@end

@implementation ReportViewController
@synthesize SINo, PolicyTerm, BasicSA, PremiumPaymentOption, AdvanceYearlyIncome,OtherRiderCode,OtherRiderDesc,OtherRiderTerm;
@synthesize YearlyIncome, CashDividend,CustCode, Age, IncomeRiderCode,IncomeRiderDesc,IncomeRiderTerm;
@synthesize HealthLoading, OtherRiderSA, IncomeRiderSA, IncomeRiderPlanOption, OtherRiderPlanOption,Name;
@synthesize strBasicAnnually, aStrIncomeRiderAnnually, aStrOtherRiderAnnually;
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
    
    aStrIncomeRiderAnnually = [[NSMutableArray alloc] init ];
    aStrOtherRiderAnnually = [[NSMutableArray alloc] init ];
    
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
    [self InsertToSI_Temp_Trad_Rider];
    [self InsertToSI_Temp_Trad];    
    [self InsertToSI_Temp_Trad_Overall];
    [self InsertToSI_Temp_Trad_RideriLLus];
    [self InsertToSI_Temp_Trad_Summary];
    
    NSString *siNo = @"";
    NSString *databaseName = @"hladb.sqlite";
    NSString *masterName = @"Databases.db";
    
    
    self.db = [DBController sharedDatabaseController:databaseName];
    
    NSString *sqlStmt = [NSString stringWithFormat:@"SELECT SiNo FROM SI_Temp_Trad"];
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    NSArray* row = [_dataTable.rows objectAtIndex:0];
    siNo = [row objectAtIndex:0];
    //NSLog(@"%@",siNo);
    
    //sqlStmt = [NSString stringWithFormat:@"SELECT RiderCode FROM SI_Trad_Rider_Details Where SINo = '%@'",siNo];
    sqlStmt = [NSString stringWithFormat:@"SELECT RiderCode FROM Trad_Rider_Details Where SINo = '%@'",siNo];
    
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
    
    
    NSString* library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSString *WebSQLSubdir;
    NSString *WebSQLPath;
    NSString *WebSQLDb;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (IsAtLeastiOSVersion(@"6.0")){
        WebSQLSubdir = @"WebKit/LocalStorage";
        WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
        WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
    }
    else{
        WebSQLSubdir = (IsAtLeastiOSVersion(@"5.1")) ? @"Caches" : @"WebKit/Databases";
        WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
        WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
    }
    
    NSString *masterFile = [WebSQLPath stringByAppendingPathComponent:masterName];
    NSString *databaseFile = [WebSQLDb stringByAppendingPathComponent:databaseName];
    
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
            
        }
        
    }    
}

-(void)InsertToSI_Temp_Trad{
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        QuerySQL = [NSString stringWithFormat:@"INSERT INTO SI_Temp_trad(\"SINo\",\"LAName\",\"PlanCode\",\"PlanName\",\"PlanDesc\", "
                    " \"MPlanDesc\",\"CashPaymentT\",\"CashPaymentD\",\"MCashPaymentT\",\"MCashPaymentD\",\"HLoadingT\",\"MHLoadingT\", "
                    " \"OccLoadingT\",\"MOccLoadingT\",\"PolTerm\",\"TotPremPaid\",\"SurrenderValueHigh\",\"SurrenderValueLow\",\"CashPayment\", "
                    " \"SurrenderValuePaidUpHigh\",\"SurrenderValuePaidUpLow\",\"GlncPaid\",\"SumTotPremPaid\",\"SurrenderValuePaidUpHigh2\", "
                    " \"SurrenderValuePaidUpLow2\",\"SumTotPremPaid2\",\"TotalYearlylncome\",\"SumTotalYearlyIncome\",\"SumTotalYearlyIncome2\", "
                    " \"TotalPremPaid2\",\"SurrenderValueHigh2\",\"SurrenderValueLow2\",\"TotalYearlyIncome2\") VALUES "
                    " (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\", "
                    " \"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\") ", 
                    SINo, Name, @"HLAIB", @"HLA Income Builder", @"Participating Whole Life Plan with Guaranteed Yearly Income and",
                    @"Pelan Penyertaan Sepanjang Hayat dengan Pendapatan Tahunan Terjamin dan ", @"", @"Yearly Income Pay Out", @"", @"Pendapatan Tahunan Dibayar",
                    @"", @"", @"Occ Loading (per 1k SA)", @"Caj Tambahan Perkerjaan (1k JAD)", PolicyTerm, arc4random()%10000 + 100, 
                    arc4random()%10000 + 100, arc4random()%10000 + 100, 0, 0, 0, 0, arc4random()%10000 + 100, 0, 0, 0, arc4random()%10000 + 100,
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
    NSString *sex, *smoker;
    NSString *QuerySQL;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        getCustomerCodeSQL = [ NSString stringWithFormat:@"select CustCode from Trad_LaPayor where sino = \"%@\" AND sequence = 1 ", SINo];
        
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
                                    " VALUES (\"%@\",\"Life Assured\",\"LA\",\"1\",\"%@\",\"%d\", \"%@\", \"%@\", "
                                    " \"Hayat yang Diinsuranskan\")", SINo, Name, Age, sex, smoker ]; 
                              
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
                        " \"%@\",\"1\",\"DATA\",\"HLA Income Builder\",\"\",\"0\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"2\" "
                        ")", SINo, BasicSA,PolicyTerm,PremiumPaymentOption,strAnnually, strSemiAnnually, strQuarterly, strMonthly];
            
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                        
                        
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
                [aStrOtherRiderAnnually addObject:strAnnually];
            }
            sqlite3_finalize(statement);
        }
        
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
                    [aStrIncomeRiderAnnually addObject:strAnnually];
                }
                sqlite3_finalize(statement);
            }
        
            RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                    "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") VALUES ( "
                    " \"%@\",\"5\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"\",\"%d\" "
                    ")", SINo, [IncomeRiderDesc objectAtIndex:a],@"", [IncomeRiderSA objectAtIndex:a],
                    [IncomeRiderTerm objectAtIndex:a], PremiumPaymentOption ,strAnnually, strSemiAnnually, 
                    strQuarterly, strMonthly, 2];
        
            if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    
                } 
                sqlite3_finalize(statement); 
            }
            sqlite3_close(contactDB);
        }
    }
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
    //NSString *strAnnually;   
    
    /*
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        NSString *SelectSQL = @"Select * from SI_Store_Premium where type = \"B\" ";
        if(sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                strAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    */
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
    
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
        //-------------------------------------
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
        //--------------------------------
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
        
        sqlite3_close(contactDB);
    }
    
    
   // NSString *tempYearlyIncome = [NSString stringWithFormat:@"%d", BasicSA * ([[rates objectAtIndex:0] intValue] / 100) ];
    
    
    
    for (int i =1; i <= PolicyTerm; i++) {
        
        if (i <= PremiumPaymentOption) {
            [AnnualPremium addObject:strBasicAnnually ];
        }
        else {
            [AnnualPremium addObject:@"0.00"];
        }
        
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
        
        [SurrenderValue addObject:[NSString stringWithFormat:@"%.0f", [[SurrenderRates objectAtIndex:i-1] doubleValue ] * BasicSA/1000 ]];
        [DBValue addObject:[NSString stringWithFormat:@"%.0f", BasicSA * [[DBRates objectAtIndex:i-1] doubleValue ]/100 ]];
        [DBValueEnd addObject:[NSString stringWithFormat:@"%.0f", BasicSA * [[DBRatesEnd objectAtIndex:i-1] doubleValue ]/100 ]];
        
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
        //-----------------------------------
        
        //----------------
        
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
        //-----------------
        
        //------------- current cash dividend
        [CurrentCashDividendValueA addObject: [NSString stringWithFormat: @"%.0f", 
                                               BasicSA * [[CurrentCashDividendRatesA objectAtIndex: i - 1] doubleValue ] / 100 ]];
        [CurrentCashDividendValueB addObject: [NSString stringWithFormat: @"%.0f", 
                                               round( BasicSA * [[CurrentCashDividendRatesB objectAtIndex: i - 1] doubleValue ] / 100) ]];
        
        //----------- current cash dividend
        
        
        //------ accu cash dividend
        if ([CashDividend isEqualToString:@"ACC"]) {
            double CDInterestRateHigh = 0.055;
            double CDInterestRateLow = 0.035;
            
            if (i == 1) {
                [AccuCashDividendValueA addObject:[CurrentCashDividendValueA objectAtIndex:i -1 ]];
            }
            else {
                [AccuCashDividendValueA addObject: [NSString stringWithFormat: @"%.0f", 
                                                    [[AccuCashDividendValueA objectAtIndex:i-2] intValue ] * (1 + CDInterestRateHigh) + 
                                                    [[CurrentCashDividendValueA objectAtIndex:i-1] intValue ]] ];
            }
        }
        else {
            [AccuCashDividendValueA addObject:@"-"];
        }
        
        //------- accucash dividend
    }

    for (int a= 1; a<=PolicyTerm; a++) {
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
            if (Age > 0){
            
                inputAge = Age + a;
                
                QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Basic (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                            "\"col14\",\"col15\",\"col16\",\"col17\",\"col18\",\"col19\",\"col20\",\"col21\",\"col22\") VALUES ( "
                            " \"%@\",\"%d\",\"DATA\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\", "
                            "\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\")", 
                            SINo, a, a, inputAge, [AnnualPremium objectAtIndex:a -1],[arrayYearlyIncome objectAtIndex:a-1], [SurrenderValue objectAtIndex:a-1],
                            [DBValue objectAtIndex:a-1],[DBValueEnd objectAtIndex:a-1],[aValue objectAtIndex:a-1 ],
                            [aValueEnd objectAtIndex:a-1],arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,
                            [TotalAllPremium objectAtIndex:a-1],[CurrentCashDividendValueA objectAtIndex:a-1],[CurrentCashDividendValueB objectAtIndex:a-1],
                            [AccuCashDividendValueA objectAtIndex:a-1],arc4random()%10000 + 1000,
                            arc4random()%10000 + 1000,arc4random()%10000 + 1000,
                            arc4random()%10000 + 1000,arc4random()%10000 + 1000,
                            arc4random()%10000 + 1000,arc4random()%10000 + 1000 ];
                
                //NSLog(@"%@", QuerySQL);
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

-(void)InsertToSI_Temp_Trad_Overall{
    
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                
            QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Overall (\"SINO\", \"SurrenderValueHigh1\", "
                        " \"SurrenderValueLow1\",\"TotPremPaid1\",\"TotYearlyIncome1\", "
                        " \"SurrenderValuehigh2\",\"SurrenderValueLow2\",\"TotPremPaid2\",\"TotYearlyIncome2\") VALUES ( "
                        " \"%@\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\")", 
                            SINo, arc4random()%10000 + 1000, arc4random()%10000 + 1000,arc4random()%10000 + 1000,
                        arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,arc4random()%10000 + 1000,
                        arc4random()%10000 + 1000 ];
                
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                    }
                    sqlite3_finalize(statement); 
                }
            
            sqlite3_close(contactDB);
        }
     
}

-(void)InsertToSI_Temp_Trad_Summary{
    
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    sqlite3_stmt *statement2;
    NSString *QuerySQL2;
    NSMutableArray *TotalIBPlusIR = [[NSMutableArray alloc] init ];
    NSMutableArray *arrayYearlyIncome = [[NSMutableArray alloc] init ];
    
    int inputAge;
    double IncomeRiderPlusIncomeBuilder = [[strBasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]
                                          + [[[aStrIncomeRiderAnnually objectAtIndex:0 ] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue];
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
    }
    
    for (int a= 1; a<=PolicyTerm; a++) {
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
                        QuerySQL2 = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Summary (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                                    "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                                    "\"col14\",\"col15\",\"col16\",\"col17\") VALUES ( "
                                    " \"%@\",\"%d\",\"DATA2\",\"%d\",\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%d\", "
                                    "\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")", SINo, a, a, inputAge,
                                     [TotalIBPlusIR objectAtIndex:a - 1],[arrayYearlyIncome objectAtIndex:a-1],0,arc4random()%10000+1000,arc4random()%10000+1000,arc4random()%10000+1000,arc4random()%10000+1000,
                                     @"-",@"-",arc4random()%10000+1000,arc4random()%10000+1000,arc4random()%10000+1000,arc4random()%10000+1000,
                                     @"",@"",@"",@"-" ];
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

-(void)InsertToSI_Temp_Trad_Rider{
    
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    sqlite3_stmt *statement2;
    sqlite3_stmt *statement3;
    NSString *QuerySQL2;
    NSString *QuerySQL3;
    
    
    if (OtherRiderCode.count > 0) {
        
        /*
         QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Rider (\"SINO\", \"SeqNo\", \"DataType\", \"PageNo\", \"col0_1\", \"col0_2\",\"col1\" "
         ") SELECT  "
         " \"%@\",\"-2\",\"TITLE\",\"1\", @\"\", @\"\", \"%@\" UNION ALL SELECT \"%@\",\"-1\",\"HEADER\",\"1\",\"Policy Year\", "
         " \"Life Ass'd Age at end of year\",\"Annual Premium(Beg. of Year)\" UNION ALL SELECT "
         " \"%@\",\"0\",\"HEADER\",\"1\",\"Tahun Polisi\",\"Umur Hayat Diisuranskan pada Akhir Tahun\",\"Premium Tahunan (Permulaan Tahun)\" "
         , SINo, [RiderDesc objectAtIndex:seq], SINo, SINo];
         
         if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
         
         if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
         if (sqlite3_step(statement) == SQLITE_DONE) {
         NSLog(@"");
         
         }   
         sqlite3_finalize(statement);
         }
         sqlite3_close(contactDB);
         }
         */
        
        NSString *strCol = @"";
        NSString *strTitle= @"";
        NSString *strHeader= @"";
        NSString *strHeaderBM = @"";
        NSString *strValue = @"";
        int numberOfCol =  OtherRiderCode.count  * 4;
        
        for (int i = 1; i <= numberOfCol; i++) {
            strCol = [strCol stringByAppendingFormat:@",\"col%d\"", i];
            if (i%4 == 1) {
                int dest = i/4;
                
                strTitle = [strTitle stringByAppendingFormat:@",\"%@\" ", [OtherRiderDesc objectAtIndex:dest]];
                strHeader = [strHeader stringByAppendingFormat:@",\"Annual Premium (Beg. of Year)\""];
                strHeaderBM = [strHeaderBM stringByAppendingFormat:@",\"Premium Tahunan (Permulaan Tahun)\""];                
                strValue = [strValue stringByAppendingFormat:@",\"%d\" ", arc4random() % 10000 + 100];
            }
            else {
                strTitle = [strTitle stringByAppendingFormat:@",\"-\" "];
                strHeader = [strHeader stringByAppendingFormat:@",\"-\" "];
                strHeaderBM = [strHeaderBM stringByAppendingFormat:@",\"-\" "];
                strValue = [strValue stringByAppendingFormat:@",\"%d\" ", arc4random() % 10000 + 100];
            }
            
        }
        
        QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Rider (\"SINO\", \"SeqNo\", \"DataType\", \"PageNo\",\"col0_1\",\"col0_2\" %@) VALUES ( "
                    " \"%@\",\"%d\",\"TITLE\",\"%d\",\"%@\",\"%@\" %@)", 
                    strCol, SINo, -2, 1, @"",@"", strTitle];
        
        QuerySQL2 = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Rider (\"SINO\", \"SeqNo\", \"DataType\", \"PageNo\",\"col0_1\",\"col0_2\" %@) VALUES ( "
                     " \"%@\",\"%d\",\"HEADER\",\"%d\",\"%@\",\"%@\" %@)", 
                     strCol, SINo, -1, 1, @"Policy Year",@"Life Ass'd Age at end of Year", strHeader];
        
        QuerySQL3 = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Rider (\"SINO\", \"SeqNo\", \"DataType\", \"PageNo\",\"col0_1\",\"col0_2\" %@) VALUES ( "
                     " \"%@\",\"%d\",\"HEADER\",\"%d\",\"%@\",\"%@\" %@)", 
                     strCol, SINo, 0, 1, @"Tahun Polisi",@"Umur Hayat Diinsuranskan pada Akhir Tahun", strHeaderBM];
        
        
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL2 UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                        if (sqlite3_step(statement2) == SQLITE_DONE) {
                            if(sqlite3_prepare_v2(contactDB, [QuerySQL3 UTF8String], -1, &statement3, NULL) == SQLITE_OK) {
                                if (sqlite3_step(statement3) == SQLITE_DONE) {
                                    
                                    
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
        
        int RiderCount =0; 
        int inputAge;
        
        for (NSString *riderCode in OtherRiderCode) {
            
            for (int seq= 1; seq<=[[OtherRiderTerm objectAtIndex:RiderCount] intValue ]; seq++) {
                if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                    
                    inputAge = Age + seq;
                    
                    strValue = @"";
                    
                    for (int i = 1; i <= numberOfCol; i++) {
                        if (i%4 == 1) {
                            strValue = [strValue stringByAppendingFormat:@",\"%d\" ", arc4random() % 10000 + 100];
                        }
                        else {
                            strValue = [strValue stringByAppendingFormat:@",\"-\" "];
                        }
                        
                    }
                    
                    
                    QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Rider (\"SINO\", \"SeqNo\", "
                                " \"DataType\", \"PageNo\",\"col0_1\",\"col0_2\" %@) VALUES ( "
                                " \"%@\",\"%d\",\"DATA\",\"%d\",\"%d\",\"%d\" %@)", 
                                strCol, SINo, seq, 1, seq, inputAge, strValue];
                    //NSLog(@"%@", QuerySQL);
                    
                    if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        if (sqlite3_step(statement) == SQLITE_DONE) {
                            
                        }
                        sqlite3_finalize(statement); 
                    }
                    
                    sqlite3_close(contactDB);
                }
            }
            
            RiderCount = RiderCount + 1;
        }
        
    }
    
}


-(void)InsertToSI_Temp_Trad_RideriLLus{
    
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    int inputAge;
    
    if (IncomeRiderCode.count > 0 ) {
        
        for (int i=0; i<IncomeRiderCode.count; i++) {
            
                //NSString *strAnnually = @"";
                NSMutableArray *AnnualPremium = [[NSMutableArray alloc] init ];
            /*    
            NSString *SelectSQL = [ NSString stringWithFormat:@"Select * from SI_Store_Premium where \"type\" = \"%@\" ", [IncomeRiderCode objectAtIndex:i]];
            
                if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                
                    if(sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        if (sqlite3_step(statement) == SQLITE_ROW) {
                            strAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                        
                        }
                        sqlite3_finalize(statement);
                    }
                    sqlite3_close(contactDB);
                }
            */
                for (int i =1; i <= PolicyTerm; i++) {
                    if (i <= PremiumPaymentOption ) {
                        [AnnualPremium addObject:[aStrIncomeRiderAnnually objectAtIndex:0 ] ];
                    }
                    else {
                        [AnnualPremium addObject:@"0.00"];
                    }
                }
                
                for (int a= 1; a<=[[IncomeRiderTerm objectAtIndex:i] intValue]; a++) {
                    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                        if (Age > 0){
                            
                            inputAge = Age + a;
                            
                            QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_RideriLLus (\"SINO\", \"SeqNo\",\"DataType\",\"DataType2\", "
                                        " \"PageNo\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                                        "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                                        "\"col14\",\"col15\",\"col16\",\"col17\",\"col18\",\"col19\",\"col20\",\"col21\") VALUES ( "
                                        " \"%@\",\"%d\",\"%@\",\"DATA\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\", "
                                        "\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\")", 
                                        SINo, a, [IncomeRiderCode objectAtIndex:i],0,a,inputAge, [AnnualPremium objectAtIndex:a - 1], [IncomeRiderSA objectAtIndex:i],
                                        arc4random()%1000+100 ,arc4random()%1000+100,arc4random()%1000+100,arc4random()%1000+100,arc4random()%1000+100,
                                        arc4random()%1000+100,arc4random()%1000+100,arc4random()%1000+100,arc4random()%1000+100,arc4random()%1000+100,
                                        arc4random()%1000+100,arc4random()%1000+100,arc4random()%1000+100,arc4random()%1000+100,arc4random()%1000+100,
                                        arc4random()%1000+100,arc4random()%1000+100,0,0 ];
                            
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


-(void)getAllPreDetails{
   
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    NSString *QuerySQL;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
            QuerySQL = [ NSString stringWithFormat:@"select \"PolicyTerm\", \"BasicSA\", \"premiumPaymentOption\", \"CashDividend\",  "
                                  "\"YearlyIncome\", \"AdvanceYearlyIncome\", \"HL1KSA\" from Trad_Details where \"sino\" = \"%@\" AND \"seq\" = 1 ", SINo];
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
                    [OtherRiderPlanOption addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 4)]];
                    
                }
            }
            sqlite3_finalize(statement2);
        }     
        sqlite3_close(contactDB);
    }
}
@end
