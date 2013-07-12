//
//  SIMenuViewController.h
//  HLA Ipad
//
//  Created by shawal sapuan on 10/3/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "BasicPlanHandler.h"
#import "PayorHandler.h"
#import "SecondLAHandler.h"

#import "NewLAViewController.h"
#import "PayorViewController.h"
#import "SecondLAViewController.h"
#import "BasicPlanViewController.h"
#import "RiderViewController.h"
#import "HLViewController.h"
#import "FSVerticalTabBarController.h"
#import "FMDatabase.h"
#import "NDHTMLtoPDF.h"

@interface SIMenuViewController : UIViewController <FSTabBarControllerDelegate,NewLAViewControllerDelegate,PayorViewControllerDelegate,SecondLAViewControllerDelegate,BasicPlanViewControllerDelegate,RiderViewControllerDelegate,HLViewControllerDelegate, NDHTMLtoPDFDelegate> {
    
	UIActivityIndicatorView *spinner_SI;
	//UILabel *spinnerLabel_SI;
	
	NSString *databasePath;
    sqlite3 *contactDB;
    BOOL PlanEmpty;
    NewLAViewController *_LAController;
    PayorViewController *_PayorController;
    SecondLAViewController *_SecondLAController;
    BasicPlanViewController *_BasicController;
    RiderViewController *_RiderController;
	FSVerticalTabBarController *_FS;
    HLViewController *_HLController;
    NSIndexPath *selectedPath;
    NSIndexPath *previousPath;
    BOOL blocked;
    BOOL saved;
    BOOL payorSaved;
    BOOL added;
	NSString *PDSorSI;
}

@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *RightView;
@property (nonatomic, retain) NewLAViewController *LAController;
@property (nonatomic, retain) PayorViewController *PayorController;
@property (nonatomic, retain) SecondLAViewController *SecondLAController;
@property (nonatomic, retain) BasicPlanViewController *BasicController;
@property (nonatomic,retain) RiderViewController *RiderController;
@property (nonatomic,retain) HLViewController *HLController;
@property (nonatomic,retain) FSVerticalTabBarController *FS;

@property (retain, nonatomic) NSMutableArray *ListOfSubMenu;
@property (retain, nonatomic) NSMutableArray *SelectedRow;
@property (nonatomic,strong) BasicPlanHandler *menuBH;
@property (nonatomic,strong) PayorHandler *menuPH;
@property (nonatomic,strong) SecondLAHandler *menuLa2ndH;
@property (nonatomic,strong) id requestSINo;
@property (nonatomic,strong) id requestSINo2;
@property (nonatomic,strong) id EAPPorSI;

//--from delegate
@property (nonatomic ,assign ,readwrite) int getAge;
@property (nonatomic ,assign ,readwrite) int getOccpClass;
@property (nonatomic, retain) NSString *getSex;
@property (nonatomic, retain) NSString *getSmoker;
@property (nonatomic, retain) NSString *getOccpCode;
@property (nonatomic, retain) NSString *getCommDate;
@property (nonatomic ,assign ,readwrite) int getIdProf;
@property (nonatomic ,assign ,readwrite) int getIdPay;
@property (nonatomic ,assign ,readwrite) int getLAIndexNo;

@property (nonatomic ,assign ,readwrite) int getPayorIndexNo;
@property (nonatomic, retain) NSString *getPaySmoker;
@property (nonatomic, retain) NSString *getPaySex;
@property (nonatomic, retain) NSString *getPayDOB;
@property (nonatomic ,assign ,readwrite) int getPayAge;
@property (nonatomic, retain) NSString *getPayOccp;

@property (nonatomic ,assign ,readwrite) int get2ndLAIndexNo;
@property (nonatomic, retain) NSString *get2ndLASmoker;
@property (nonatomic, retain) NSString *get2ndLASex;
@property (nonatomic, retain) NSString *get2ndLADOB;
@property (nonatomic ,assign ,readwrite) int get2ndLAAge;
@property (nonatomic, retain) NSString *get2ndLAOccp;

@property (nonatomic, retain) NSString *getSINo;
@property (nonatomic ,assign ,readwrite) int getMOP;
@property (nonatomic ,assign ,readwrite) int getTerm;
@property (nonatomic, retain) NSString *getbasicSA;
@property (nonatomic, retain) NSString *getbasicHL;
@property (nonatomic, retain) NSString *getbasicTempHL;
@property (nonatomic, retain) NSString *getPlanCode;
@property (nonatomic, retain) NSString *getBasicPlan;
@property (nonatomic ,assign ,readwrite) int getAdvance;

//----

@property (nonatomic, copy) NSString *payorSINo;
@property (nonatomic, copy) NSString *payorCustCode;
@property (nonatomic, assign,readwrite) int clientID2;
@property (nonatomic, copy) NSString *CustCode2;
@property(nonatomic , retain) NSString *NameLA;
@property(nonatomic , retain) NSString *Name2ndLA;
@property(nonatomic , retain) NSString *NamePayor;

@property (nonatomic,strong) id SIshowQuotation;
-(void)Reset;
-(void)copySIToDoc;

//@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *spinner_SI;

@property (nonatomic, strong) NSMutableDictionary *riderCode;

@end
