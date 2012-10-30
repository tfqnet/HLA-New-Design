//
//  ReportViewController.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/18/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@end

@implementation ReportViewController
@synthesize SINo, PolicyTerm, BasicSA, PremiumPaymentOption, AdvanceYearlyIncome,OtherRiderCode,OtherRiderDesc,OtherRiderTerm;
@synthesize YearlyIncome, CashDividend,CustCode, Age, IncomeRiderCode,IncomeRiderDesc,IncomeRiderTerm;
@synthesize HealthLoading, OtherRiderSA, IncomeRiderSA, IncomeRiderPlanOption, OtherRiderPlanOption,Name;

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
    
    [self deleteTemp]; //clear all temp data
    
    [self getAllPreDetails]; // get all the details needed before proceed 
    
    [self InsertHeaderBasicPlan]; //insert basic plan header into temp table bm and english
                
    if (IncomeRiderCode.count > 0) {
        [self InsertHeaderRiderPlan];  //insert income rider header into temp table bm and english
    }
    
    [self InsertHeaderTB]; //insert summary of basic plan header into temp table bm and english
    
    [self InsertToSI_Temp_Trad_LA]; // for the front summary page 
    [self InsertToSI_Temp_Trad_Details];
    [self InsertToSI_Temp_Trad_Basic];
    [self InsertToSI_Temp_Trad_Rider];
    [self InsertToSI_Temp_Trad];    
    [self InsertToSI_Temp_Trad_Overall];
    [self InsertToSI_Temp_Trad_Summary];
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
                    @"\"\"", @"\"\"", @"Occ Loading (per 1k SA)", @"Caj Tambahan Perkerjaan (1k JAD)", PolicyTerm, arc4random()%10000 + 100, 
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
    
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                
                QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") "
                            " VALUES ( "
                            " \"%@\",\"1\",\"DATA\",\"HLA Income Builder\",\"\",\"0\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"\",\"2\" "
                            ")", SINo, BasicSA,PolicyTerm,PremiumPaymentOption,16,17,18,19];
                
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        
                        
                        
                        
                    }
                    sqlite3_finalize(statement); 
                }
            
            sqlite3_close(contactDB);
        }
    
    for (int a=0; a<OtherRiderCode.count; a++) {
        RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                    "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") "
                    " VALUES ( "
                    " \"%@\",\"3\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%d\",\"\",\"\" "
                    ")", SINo, [OtherRiderDesc objectAtIndex:a],[OtherRiderPlanOption objectAtIndex:a], [OtherRiderSA objectAtIndex:a],
                    [OtherRiderTerm objectAtIndex:a], [OtherRiderTerm objectAtIndex:a],16,17,18,19];
        
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
            if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    
                } 
                sqlite3_finalize(statement); 
            }
            sqlite3_close(contactDB);
        }
        
    }

    for (int a=0; a<IncomeRiderCode.count; a++) {
        RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                    "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") "
                    " VALUES ( "
                    " \"%@\",\"5\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"\",\"%d\" "
                    ")", SINo, [IncomeRiderDesc objectAtIndex:a],@"", [IncomeRiderSA objectAtIndex:a],
                    [IncomeRiderTerm objectAtIndex:a], PremiumPaymentOption ,16,17,18,19, 2];
        
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
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
    
    for (int a= 1; a<=PolicyTerm; a++) {
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
            if (Age > 0){
                
                inputAge = Age + a;
                
                QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Basic (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                            "\"col14\",\"col15\",\"col16\",\"col17\",\"col18\",\"col19\",\"col20\",\"col21\",\"col22\") VALUES ( "
                            " \"%@\",\"%d\",\"DataType\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\", "
                            "\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\")", 
                            SINo, a, a, inputAge, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22 ];
                
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
                
                NSLog(@"%@", QuerySQL);
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
    
    int inputAge;
    
    for (int a= 1; a<=PolicyTerm; a++) {
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                
                inputAge = Age + a;
                
                QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Summary (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                            "\"col14\",\"col15\",\"col16\",\"col17\") VALUES ( "
                            " \"%@\",\"%d\",\"Data\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", "
                            "\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\")", SINo, a, a, inputAge, arc4random()%10000+1000,@"0",@"0",@"",@"",@"",@""
                            ,@"",@"",@"",@"",@"",@"",@"",arc4random()%10000+1000,BasicSA,0 ];
                
            //NSLog(@"%@", QuerySQL);
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_step(statement) == SQLITE_DONE) {
                        QuerySQL2 = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Summary (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                                    "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                                    "\"col14\",\"col15\",\"col16\",\"col17\") VALUES ( "
                                    " \"%@\",\"%d\",\"Data2\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%d\", "
                                    "\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\")", SINo, a, a, inputAge,
                                     arc4random()%10000+1000,BasicSA,0,arc4random()%10000+1000,arc4random()%10000+1000,arc4random()%10000+1000,arc4random()%10000+1000,
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
                                " \"%@\",\"%d\",\"Data\",\"%d\",\"%d\",\"%d\" %@)", 
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
    NSString *SelectedRiderCode;
    
    if (IncomeRiderCode.count > 0 ) {
        
        for (NSString *zzz in IncomeRiderCode) {
            
            SelectedRiderCode  = @"";
            if ([zzz isEqualToString:@"I20R"]) {
              SelectedRiderCode  = @"I20R";  
            }
            else if ([zzz isEqualToString:@"I30R"]) {
              SelectedRiderCode  = @"I30R";  
            }
            else if ([zzz isEqualToString:@"I40R"]) {
                SelectedRiderCode  = @"I40R";
            }
            else if ([zzz isEqualToString:@"ICR"]) {
                SelectedRiderCode  = @"ICR";
            }
            else if ([zzz isEqualToString:@"ID20R"]) {
                SelectedRiderCode  = @"ID20R";
            }
            else if ([zzz isEqualToString:@"ID30R"]) {
                SelectedRiderCode  = @"ID30R";
            }
            else if ([zzz isEqualToString:@"ID40R"]) {
                SelectedRiderCode  = @"ID40R";
            }
            else if ([zzz isEqualToString:@"IE20R"]) {
                SelectedRiderCode  = @"IE20R";
            }
            else if ([zzz isEqualToString:@"IE30R"]) {
                SelectedRiderCode  = @"IE30R";
            }
            
            if (![SelectedRiderCode isEqualToString:@""]) {
                for (int a= 1; a<=PolicyTerm; a++) {
                    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
                        if (Age > 0){
                            
                            inputAge = Age + a;
                            
                            QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_RideriLLus (\"SINO\", \"SeqNo\",\"DataType\",\"DataType2\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                                        "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\",\"col12\",\"col13\", "
                                        "\"col14\",\"col15\",\"col16\",\"col17\",\"col18\",\"col19\",\"col20\",\"col21\") VALUES ( "
                                        " \"%@\",\"%@\",\"%@\",\"Data\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", "
                                        "\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",))", 
                                        SINo, a, SelectedRiderCode,0,a,inputAge, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21 ];
                            
                            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                if (sqlite3_step(statement) == SQLITE_DONE) {
                                    //NSLog(@"done insert to si_temp_tra_b");
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
}


-(void)getAllPreDetails{
   
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    NSString *QuerySQL;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
            QuerySQL = [ NSString stringWithFormat:@"select \"PolicyTerm\", \"BasicSA\", \"premiumPaymentOption\", \"CashDividend\",  "
                                  "\"YearlyIncome\", \"AdvanceYearlyIncome\", \"HL1KSA\" from Trad_Details where \"sino\" = \"%@\" AND \"seq\" = 1 ", SINo];
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
        
        NSLog(@"%@", QuerySQL);
        
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
