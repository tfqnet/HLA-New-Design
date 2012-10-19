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
@synthesize SINo;
@synthesize YearlyIncome, CashDividend;

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
    sqlite3_stmt *statement;
    
    //insert basic plan header into temp table bm and english
    
    [self InsertHeaderBasicPlan];
    
    
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        NSString *getHeaderSQL = [NSString stringWithFormat:@"Select * from trad_rider_details where sino = \"%@\" ", SINo];
        
        if(sqlite3_prepare_v2(contactDB, [getHeaderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(statement) == SQLITE_ROW){
                
                //insert rider header into temp table bm and english
                [self InsertHeaderRiderPlan];
            }
                
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }    
    
    //insert basic plan header into temp table bm and english
    [self InsertHeaderTB];
    
    
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

-(void)InsertHeaderBasicPlan{
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    NSString *getHeaderEngSQL;
    NSString *getHeaderBMSQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        
        if (![YearlyIncome isEqualToString:@"Acc"]) {
            getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                                      " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                                      " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col11\",\"Col12\", \"Col13\") VALUE "
                                      " \"%@\",\"BP\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(beg. of Year)\", "
                                      " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                                      " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                                      " \"Total Annual Premium(Include all riders)(Beg. of Year)\", \"Current Year Cash Divedend\", "
                                      " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ", SINo];
            getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_BM "
                               " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                               " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col11\",\"Col12\", \"Col13\") VALUE "
                               " \"%@\",\"BP\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(beg. of Year)\", "
                               " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                               " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                               " \"Total Annual Premium(Include all riders)(Beg. of Year)\", \"Current Year Cash Divedend\", "
                               " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ", SINo];
            
        }
        else {
            getHeaderEngSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                            " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                            " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\",\"Col14\",\"Col15\") VALUE "
                            " \"%@\",\"BP\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(beg. of Year)\", "
                            " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                            " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                            " \"Total Annual Premium(Include all riders)(Beg. of Year)\", \"Current Year Cash Divedend\", "
                            " \"Accumulated Cash Dividends\", \"Accumulated Yearly Income\",  "
                            " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ", SINo];
            
        }
        
        if(sqlite3_prepare_v2(contactDB, [getHeaderEngSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE){
                
                if(sqlite3_prepare_v2(contactDB, [getHeaderBMSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    
                }
                
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(contactDB);
    }    
}

-(void)InsertHeaderRiderPlan{
    sqlite3_stmt *statement;
    NSString *getHeaderSQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        
        if (![YearlyIncome isEqualToString:@"Acc"]) {
            getHeaderSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                            " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                            " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col11\",\"Col12\", \"Col13\") VALUE "
                            " \"%@\",\"RD\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(beg. of Year)\", "
                            " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                            " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                            " \"Current Year Cash Divedend\", "
                            " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ", SINo];
            
        }
        else {
            getHeaderSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                            " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                            " \"Col8\",\"Col9\",\"Col10\",\"Col11\",\"Col12\", \"Col13\",\"Col14\",\"Col15\") VALUE "
                            " \"%@\",\"RD\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Annual Premium(beg. of Year)\", "
                            " \"Yearly Income (End of Year)\", \"Surrender Value(End of Year)\", \"Death/TPD Benefit *^\",  "
                            " \"Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                            " \"Current Year Cash Divedend\", "
                            " \"Accumulated Cash Dividends\", \"Accumulated Yearly Income\",  "
                            " \"Terminal Dividend Payable on Surrender/Maturity\", \"Special Terminal Dividend Payable on Death/TPD\" ", SINo];
            
        }
        
        if(sqlite3_prepare_v2(contactDB, [getHeaderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE){
                
                
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(contactDB);
    }    

}

-(void)InsertHeaderTB{
    sqlite3_stmt *statement;
    NSString *getHeaderSQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        
            getHeaderSQL = [NSString stringWithFormat:@"Insert INTO SI_temp_Header_EN "
                            " (\"SINo\",\"Section\",\"Col1\",\"Col2\",\"Col3\",\"Col4\",\"Col5\",\"Col6\",\"Col7\", "
                            " \"Col8\",\"Col9\") VALUE "
                            " \"%@\",\"TB\",\"Policy Year\",\"Life Ass'd Age at end of year\", \"Total Annual Premium of IB & IR(s)(beg. of Year)\", "
                            " \"Total Guaranteed Yearly Income (End of Year)\", \"Total Guaranteed Surrender Value(End of Year)\", \"Total Guaranteed Death/TPD Benefit *^\",  "
                            " \"Guaranteed Additional Accidental TPD Benefit ^\",\"Total Surrender Value(End of Year)\",\"Total Death/TPD Benefit(End of Year)*^\", "
                            " ", SINo];
            
        if(sqlite3_prepare_v2(contactDB, [getHeaderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE){
                
                
            }
            
        }
        
    }    
}

@end
