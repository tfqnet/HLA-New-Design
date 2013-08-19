//
//  EverLifeViewController.h
//  iMobile Planner
//
//  Created by infoconnect on 8/15/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class DataTable,DBController;
@interface EverLifeViewController : UIViewController{
	NSString *databasePath, *RatesDatabasePath;
    sqlite3 *contactDB;
}

@property (nonatomic,strong) id SINo;
@property (nonatomic,strong) id PDSorSI;
@property (nonatomic,strong) id YearlyIncome;
@property (nonatomic,strong) id CashDividend;
@property (nonatomic,strong) id CustCode;
@property (nonatomic,strong) id Name;
@property (nonatomic,strong) id sex, OccpClass,HealthLoading, HealthLoadingTerm, TempHealthLoading, TempHealthLoadingTerm ;
@property (nonatomic, assign) int Age;
@property (nonatomic, assign) int PayorAge;
@property (nonatomic, assign) int PolicyTerm;
@property (nonatomic, assign) double BasicSA;

@property (strong, nonatomic) DBController* db;
@property (strong, nonatomic) DataTable * dataTable;

+(BOOL)testing;

#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)
@end
