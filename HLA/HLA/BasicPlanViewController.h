//
//  BasicPlanViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "SIHandler.h"
#import "PlanList.h"
#import "BasicPlanHandler.h"
#import "PayorHandler.h"
#import "SecondLAHandler.h"

@class BasicPlanViewController;
@protocol BasicPlanViewControllerDelegate
-(void) BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL andMOP:(int)aaMOP andPlanCode:(NSString *)aaPlanCode andAdvance:(int)aaAdvance;
-(void)RiderAdded;
@end

@interface BasicPlanViewController : UIViewController <UITextFieldDelegate,PlanListDelegate>{
    NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
    UIPopoverController *popoverController;
    PlanList *planList;
    BOOL showHL;
    BOOL useExist;
    BOOL newSegment;
    id <BasicPlanViewControllerDelegate> _delegate;
}

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic,strong) id <BasicPlanViewControllerDelegate> delegate;
@property (nonatomic,strong) SIHandler *basicH;
@property (nonatomic,strong) BasicPlanHandler *basicBH;
@property (nonatomic,strong) PayorHandler *basicPH;
@property (nonatomic,strong) SecondLAHandler *basicLa2ndH;
@property (strong, nonatomic) NSMutableArray *dataInsert;

//--request from previous
@property (nonatomic, assign,readwrite) int requestAge;
@property (nonatomic,strong) id requestOccpCode;
@property (nonatomic, assign,readwrite) int requestOccpClass;
@property (nonatomic,strong) id requestSINo;
@property (nonatomic, assign,readwrite) int requestIDProf;
@property (nonatomic, assign,readwrite) int requestIDPay;
@property (nonatomic, assign,readwrite) int requestIndexPay;
@property (nonatomic,strong) id requestSmokerPay;
@property (nonatomic,strong) id requestSexPay;
@property (nonatomic,strong) id requestDOBPay;
@property (nonatomic, assign,readwrite) int requestAgePay;
@property (nonatomic,strong) id requestOccpPay;
@property (nonatomic, assign,readwrite) int requestIndex2ndLA;
@property (nonatomic,strong) id requestSmoker2ndLA;
@property (nonatomic,strong) id requestSex2ndLA;
@property (nonatomic,strong) id requestDOB2ndLA;
@property (nonatomic, assign,readwrite) int requestAge2ndLA;
@property (nonatomic,strong) id requestOccp2ndLA;

@property (nonatomic, assign,readwrite) int ageClient;
@property(nonatomic , retain) NSString *OccpCode;
@property (nonatomic, assign,readwrite) int OccpClass;
@property (nonatomic, copy) NSString *SINo;
@property (nonatomic, assign,readwrite) int idPay;
@property (nonatomic, assign,readwrite) int idProf;
@property (nonatomic, assign,readwrite) int PayorIndexNo;
@property (nonatomic, copy) NSString *PayorSmoker;
@property (nonatomic, copy) NSString *PayorSex;
@property (nonatomic, copy) NSString *PayorDOB;
@property (nonatomic, assign,readwrite) int PayorAge;
@property (nonatomic, copy) NSString *PayorOccpCode;
@property (nonatomic, assign,readwrite) int secondLAIndexNo;
@property (nonatomic, copy) NSString *secondLASmoker;
@property (nonatomic, copy) NSString *secondLASex;
@property (nonatomic, copy) NSString *secondLADOB;
@property (nonatomic, assign,readwrite) int secondLAAge;
@property (nonatomic, copy) NSString *secondLAOccpCode;
//--
@property (strong, nonatomic) IBOutlet UIButton *btnPlan;
@property (retain, nonatomic) IBOutlet UITextField *termField;
@property (retain, nonatomic) IBOutlet UITextField *yearlyIncomeField;
@property (retain, nonatomic) IBOutlet UILabel *minSALabel;
@property (retain, nonatomic) IBOutlet UILabel *maxSALabel;
@property (retain, nonatomic) IBOutlet UIButton *btnHealthLoading;
@property (retain, nonatomic) IBOutlet UIView *healthLoadingView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *MOPSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *incomeSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *advanceIncomeSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *cashDividendSegment;
@property (retain, nonatomic) IBOutlet UITextField *HLField;
@property (retain, nonatomic) IBOutlet UITextField *HLTermField;
@property (retain, nonatomic) IBOutlet UITextField *tempHLField;
@property (retain, nonatomic) IBOutlet UITextField *tempHLTermField;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;

//for SINo
@property (nonatomic, assign,readwrite) int SILastNo;
@property (nonatomic, assign,readwrite) int CustLastNo;
@property (nonatomic, copy) NSString *SIDate;
@property (nonatomic, copy) NSString *CustDate;

@property (nonatomic, copy) NSString *LACustCode;
@property (nonatomic, copy) NSString *PYCustCode;
@property (nonatomic, copy) NSString *secondLACustCode;
@property (nonatomic, assign,readwrite) int IndexNo;

@property (nonatomic, assign,readwrite) int termCover;
@property (nonatomic, assign,readwrite) int minSA;
@property (nonatomic, assign,readwrite) int maxSA;
@property (nonatomic,strong) NSString *planChoose;

@property(nonatomic , retain) NSString *NamePP;
@property(nonatomic , retain) NSString *DOBPP;
@property(nonatomic , retain) NSString *GenderPP;
@property(nonatomic , retain) NSString *OccpCodePP;

//use to calculate
@property (nonatomic, assign,readwrite) int MOP;
@property (nonatomic, copy) NSString *yearlyIncome;
@property (nonatomic, copy) NSString *cashDividend;
@property (nonatomic, assign,readwrite) int advanceYearlyIncome;
@property (nonatomic, assign,readwrite) int basicRate;      //mark
@property (nonatomic,strong) NSString *planCode;
//to display
@property (nonatomic,strong) NSString *getSINo;
@property (nonatomic,assign,readwrite) int getPolicyTerm;
@property (nonatomic,assign,readwrite) double getSumAssured;
@property (nonatomic,copy) NSString *getHL;
@property (nonatomic,copy) NSString *getTempHL;
@property (nonatomic,assign,readwrite) int getTempHLTerm;
@property (nonatomic,assign,readwrite) int getHLTerm;

@property (retain, nonatomic) NSMutableArray *LRiderCode;
@property (retain, nonatomic) NSMutableArray *LSumAssured;
@property (nonatomic,copy) NSString *riderCode;
@property (nonatomic, assign,readwrite) int expAge;
@property (nonatomic, assign,readwrite) int minSATerm;
@property (nonatomic, assign,readwrite) int maxSATerm;
@property (nonatomic, assign,readwrite) int minTerm;
@property (nonatomic, assign,readwrite) int maxTerm;
@property (nonatomic, assign,readwrite) double _maxRiderSA;
@property (nonatomic, assign,readwrite) double maxRiderSA;
@property (nonatomic, assign,readwrite) int GYI;

- (IBAction)btnPlanPressed:(id)sender;
- (IBAction)btnShowHealthLoadingPressed:(id)sender;
- (IBAction)doSavePlan:(id)sender;
- (IBAction)MOPSegmentPressed:(id)sender;
- (IBAction)incomeSegmentPressed:(id)sender;
- (IBAction)advanceIncomeSegmentPressed:(id)sender;
- (IBAction)cashDividendSegmentPressed:(id)sender;

-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;

@end
