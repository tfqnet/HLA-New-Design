//
//  RiderViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "RiderPTypeTbViewController.h"
#import "RiderListTbViewController.h"
#import "RiderFormTbViewController.h"
#import "BasicPlanHandler.h"
#import "SIHandler.h"

@interface RiderViewController : UIViewController <RiderPTypeTbViewControllerDelegate,RiderListTbViewControllerDelegate,RiderFormTbViewControllerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *databasePath;
    sqlite3 *contactDB;
    UIPopoverController *popOverConroller;
    UIPopoverController *_RiderListPopover;
    RiderPTypeTbViewController *listPType;
    RiderListTbViewController *_RiderList;
    BOOL term;
    BOOL sumA;
    BOOL plan;
    BOOL unit;
    BOOL deduc;
    BOOL hload;
    BOOL hloadterm;
    BOOL pressedPlan;
    BOOL pressedDeduc;
    BOOL incomeRider;
    BOOL PtypeChange;
}

//request from previous
@property (nonatomic,strong) BasicPlanHandler *riderBH;
@property (nonatomic,strong) SIHandler *riderH;
@property (strong, nonatomic) NSMutableArray *dataInsert;

@property (nonatomic, retain) RiderListTbViewController *RiderList;

@property (nonatomic, assign,readwrite) int requestAge;
@property (nonatomic,strong) id requestSINo;
@property (nonatomic, assign,readwrite) int requestCoverTerm;
@property (nonatomic,strong) id requestPlanCode;
@property (nonatomic, assign,readwrite) double requestBasicSA;
@property (nonatomic,strong) id requestOccpCode;
@property (nonatomic, assign,readwrite) int requestMOP;

@property (nonatomic, retain) UIPopoverController *RiderListPopover;
@property (nonatomic,strong) UIPopoverController *popOverConroller;
@property (retain, nonatomic) IBOutlet UIButton *btnPType;
@property (retain, nonatomic) IBOutlet UIButton *btnAddRider;

@property (retain, nonatomic) IBOutlet UILabel *termLabel;
@property (retain, nonatomic) IBOutlet UILabel *sumLabel;
@property (retain, nonatomic) IBOutlet UILabel *planLabel;
@property (retain, nonatomic) IBOutlet UILabel *cpaLabel;
@property (retain, nonatomic) IBOutlet UILabel *unitLabel;
@property (retain, nonatomic) IBOutlet UILabel *occpLabel;
@property (retain, nonatomic) IBOutlet UILabel *HLLabel;
@property (retain, nonatomic) IBOutlet UILabel *HLTLabel;
@property (retain, nonatomic) IBOutlet UITextField *termField;
@property (retain, nonatomic) IBOutlet UITextField *sumField;
@property (retain, nonatomic) IBOutlet UITextField *cpaField;
@property (retain, nonatomic) IBOutlet UITextField *unitField;
@property (retain, nonatomic) IBOutlet UITextField *occpField;
@property (retain, nonatomic) IBOutlet UITextField *HLField;
@property (retain, nonatomic) IBOutlet UITextField *HLTField;
@property (retain, nonatomic) IBOutlet UIButton *planBtn;
@property (retain, nonatomic) IBOutlet UIButton *deducBtn;
@property (retain, nonatomic) IBOutlet UILabel *minDisplayLabel;
@property (retain, nonatomic) IBOutlet UILabel *maxDisplayLabel;

//get from popover
@property (nonatomic,copy) NSString *pTypeCode;
@property (nonatomic, assign,readwrite) int PTypeSeq;
@property (nonatomic,copy) NSString *pTypeDesc;
@property (nonatomic,copy) NSString *riderCode;
@property (nonatomic,copy) NSString *riderDesc;

//setup form field
@property(nonatomic , retain) NSMutableArray *FLabelCode;
@property(nonatomic , retain) NSMutableArray *FLabelDesc;
@property(nonatomic , retain) NSMutableArray *FRidName;
@property(nonatomic , retain) NSMutableArray *FInputCode;
@property(nonatomic , retain) NSMutableArray *FTbName;
@property(nonatomic , retain) NSMutableArray *FFieldName;
@property(nonatomic , retain) NSMutableArray *FCondition;

@property (nonatomic,strong) NSString *SINoPlan;
@property (nonatomic,strong) NSString *planCode;
@property (nonatomic, assign,readwrite) int expAge;
@property (nonatomic, assign,readwrite) int minSATerm;
@property (nonatomic, assign,readwrite) int maxSATerm;
@property (nonatomic, assign,readwrite) int minTerm;
@property (nonatomic, assign,readwrite) int maxTerm;
@property (nonatomic, assign,readwrite) double maxRiderTerm;
@property (nonatomic, assign,readwrite) double maxRiderSA;
@property (nonatomic,strong) NSString *planOption;
@property (nonatomic,strong) NSString *deductible;
@property (nonatomic,strong) NSString *inputHL1KSA;
@property (nonatomic,assign,readwrite) int inputHL1KSATerm;
@property (nonatomic,strong) NSString *inputHL100SA;
@property (nonatomic,assign,readwrite) int inputHL100SATerm;
@property (nonatomic,strong) NSString *inputHLPercentage;
@property (nonatomic,assign,readwrite) int inputHLPercentageTerm;
@property(nonatomic , retain) NSMutableArray *atcRidCode;
@property(nonatomic , retain) NSMutableArray *atcPlanChoice;
@property (nonatomic,strong) NSString *existRidCode;
@property (nonatomic, assign,readwrite) int GYI;
@property (nonatomic, assign,readwrite) int occLoad;
@property (nonatomic, assign,readwrite) int occClass;
@property (nonatomic, assign,readwrite) int occCPA;
@property (nonatomic, assign,readwrite) int storedMaxTerm;
@property (nonatomic, assign,readwrite) int basicRate;
@property (nonatomic, assign,readwrite) int LSDRate;

//setup tableview listing rider
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) NSMutableArray *LRiderCode;
@property (retain, nonatomic) NSMutableArray *LSumAssured;
@property (retain, nonatomic) NSMutableArray *LTerm;
@property (retain, nonatomic) NSMutableArray *LPlanOpt;
@property (retain, nonatomic) NSMutableArray *LUnits;
@property(nonatomic , retain) NSMutableArray *LDeduct;
@property(nonatomic , retain) NSMutableArray *LRidHL1K;
@property(nonatomic , retain) NSMutableArray *LRidHL100;
@property(nonatomic , retain) NSMutableArray *LRidHLP;
@property(nonatomic , retain) NSMutableArray *LSmoker;
@property(nonatomic , retain) NSMutableArray *LSex;
@property(nonatomic , retain) NSMutableArray *LAge;
@property (retain, nonatomic) IBOutlet UILabel *titleRidCode;
@property (retain, nonatomic) IBOutlet UILabel *titleSA;
@property (retain, nonatomic) IBOutlet UILabel *titleTerm;
@property (retain, nonatomic) IBOutlet UILabel *titleUnit;
@property (strong, nonatomic) IBOutlet UILabel *titleClass;
@property (strong, nonatomic) IBOutlet UILabel *titleLoad;
@property (strong, nonatomic) IBOutlet UILabel *titleHL1K;
@property (strong, nonatomic) IBOutlet UILabel *titleHL100;
@property (strong, nonatomic) IBOutlet UILabel *titleHLP;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, assign,readwrite) int age;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic, assign,readwrite) double riderRate;
@property (nonatomic, assign,readwrite) int CombNo;
@property (nonatomic, assign,readwrite) int RBBenefit;
@property (nonatomic, assign,readwrite) int RBLimit;
@property (nonatomic, assign,readwrite) int RBGroup;
@property (nonatomic, assign,readwrite) int AllCombNo;
@property (nonatomic,strong) NSString *OccpCat;
@property (nonatomic,strong) NSString *pentaSQL;
@property (nonatomic,strong) NSString *medPentaSQL;
@property (nonatomic,strong) NSString *plnOptC;
@property (nonatomic,strong) NSString *planOptHMM;
@property (nonatomic,strong) NSString *deducHMM;
@property (nonatomic,strong) NSString *planHSPII;
@property (nonatomic,strong) NSString *planMGII;
@property (nonatomic,strong) NSString *planMGIV;
@property (nonatomic,strong) NSString *planCodeRider;
@property (nonatomic,strong) NSString *medPlanCodeRider;
@property (nonatomic,strong) NSString *medRiderCode;
@property (nonatomic,strong) NSString *medPlanOpt;
@property (nonatomic,strong) NSMutableArray *annualRiderPrem;
@property (nonatomic,strong) NSMutableArray *quarterRiderPrem;
@property (nonatomic,strong) NSMutableArray *halfRiderPrem;
@property (nonatomic,strong) NSMutableArray *monthRiderPrem;
@property (nonatomic, assign,readwrite) double annualRiderSum;
@property (nonatomic, assign,readwrite) double halfRiderSum;
@property (nonatomic, assign,readwrite) double quarterRiderSum;
@property (nonatomic, assign,readwrite) double monthRiderSum;
@property (nonatomic,strong) NSMutableArray *arrCombNo;
@property (nonatomic,strong) NSMutableArray *arrRBBenefit;

@property (nonatomic,strong) NSMutableArray *annualMedRiderPrem;
@property (nonatomic,strong) NSMutableArray *quarterMedRiderPrem;
@property (nonatomic,strong) NSMutableArray *halfMedRiderPrem;
@property (nonatomic,strong) NSMutableArray *monthMedRiderPrem;
@property (nonatomic, assign,readwrite) double annualMedRiderSum;
@property (nonatomic, assign,readwrite) double halfMedRiderSum;
@property (nonatomic, assign,readwrite) double quarterMedRiderSum;
@property (nonatomic, assign,readwrite) double monthMedRiderSum;

@property (nonatomic, assign,readwrite) double basicPrem;
@property (nonatomic, assign,readwrite) double riderPrem;
@property (nonatomic, assign,readwrite) double medRiderPrem;

- (IBAction)btnPTypePressed:(id)sender;
- (IBAction)btnAddRiderPressed:(id)sender;
- (IBAction)planBtnPressed:(id)sender;
- (IBAction)deducBtnPressed:(id)sender;
- (IBAction)doSaveRider:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)editPressed:(id)sender;
- (IBAction)deletePressed:(id)sender;

-(void)keyboardDidHide:(NSNotificationCenter *)notification;

@end
