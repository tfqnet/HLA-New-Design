//
//  SIMenuViewController.h
//  HLA Ipad
//
//  Created by shawal sapuan on 10/3/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "SIHandler.h"
#import "BasicPlanHandler.h"
#import "PayorHandler.h"
#import "SecondLAHandler.h"

@interface SIMenuViewController : UIViewController {
    NSString *databasePath;
    sqlite3 *contactDB;
    BOOL LAEmpty;
    BOOL PlanEmpty;
    
}


@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *RightView;

@property (retain, nonatomic) NSMutableArray *ListOfSubMenu;
@property (retain, nonatomic) NSMutableArray *SelectedRow;
@property (nonatomic,strong) SIHandler *menulaH;
@property (nonatomic,strong) BasicPlanHandler *menuBH;
@property (nonatomic,strong) PayorHandler *menuPH;
@property (nonatomic,strong) SecondLAHandler *menuLa2ndH;

@property (nonatomic ,assign ,readwrite) int checkPayor;
@property (nonatomic ,assign ,readwrite) int check2ndLA;

@property (nonatomic, retain) NSString *getSINo;
@property (nonatomic ,assign ,readwrite) int getAge;
@property (nonatomic, retain) NSString *getOccpCode;
@property (nonatomic, retain) NSString *getbasicSA;

@property (nonatomic, copy) NSString *payorSINo;
@property (nonatomic, copy) NSString *payorCustCode;
@property (nonatomic, assign,readwrite) int clientID2;
@property (nonatomic, copy) NSString *CustCode2;

@property (nonatomic,strong) id SIshowQuotation;
@end
