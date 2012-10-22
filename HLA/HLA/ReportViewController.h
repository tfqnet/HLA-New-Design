//
//  ReportViewController.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/18/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ReportViewController : UIViewController
{
    NSString *databasePath;
    sqlite3 *contactDB;
}
@property (nonatomic,strong) id SINo;
@property (nonatomic,strong) id YearlyIncome;
@property (nonatomic,strong) id CashDividend;
@property (nonatomic,strong) id CustCode;
@property (nonatomic, assign) int Age;
@property (nonatomic, assign) int PolicyTerm;
@property (nonatomic, assign) int BasicSA;
@property (nonatomic, assign) int PremiumPaymentOption;
@property (nonatomic, assign) int AdvanceYearlyIncome;
@property (retain, nonatomic) NSMutableArray *RiderCode;
@property (retain, nonatomic) NSMutableArray *RiderTerm;
@property (retain, nonatomic) NSMutableArray *RiderDesc;
@end
