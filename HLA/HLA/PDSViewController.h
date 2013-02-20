//
//  PDSViewController.h
//  HLA Ipad
//
//  Created by infoconnect on 1/7/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class DataTable,DBController;
@interface PDSViewController : UIViewController{
    NSString *databasePath, *RatesDatabasePath;
    sqlite3 *contactDB;
}

@property (nonatomic,strong) id SINo;
@property (nonatomic,strong) id PDSLanguage;
@property (nonatomic,strong) id PDSPlanCode;
@property (strong, nonatomic) DBController* db;
@property (strong, nonatomic) DataTable * dataTable;

#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)
@end
